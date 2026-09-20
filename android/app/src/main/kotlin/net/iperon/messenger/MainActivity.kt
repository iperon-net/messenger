package net.iperon.messenger

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

/// Хост Flutter-приложения на Android.
///
/// Помимо стандартного `FlutterFragmentActivity` умеет показываться поверх
/// экрана блокировки на время звонка. Без этого при ответе на входящий с
/// заблокированного экрана Android требует разблокировку (отпечаток/PIN):
/// плагин `flutter_callkit_incoming` поднимает нас обычным launch-intent из
/// своей `TransparentActivity`, а Activity без флага `showWhenLocked` система
/// не рисует поверх keyguard.
///
/// Использует ОДИН кэшированный [FlutterEngine] на весь процесс (см.
/// [getCachedEngineId]). Без этого повторный запуск Activity под входящий звонок
/// (приложение свёрнуто, но процесс жив; старый движок ещё резидентен, т.к. его
/// isolate держит gRPC-стрим/DI-синглтоны) создавал ВТОРОЙ движок и прогонял
/// `main()` заново. Тогда в одном процессе жили два isolate'а, каждый со своим
/// `Calls`/`CallPush`; оба ловили нативный ACTION_CALL_ACCEPT и оба входили в
/// комнату LiveKit с одной identity → сервер выбивал участника
/// (DUPLICATE_IDENTITY), звонок падал с ICE-таймаутом. Внутриизолятные дедуп-
/// гарды такое не ловят — они не переживают границу isolate'а.
///
/// ВАЖНО: движок отдаётся через [getCachedEngineId] (путь `withCachedEngine` +
/// `destroyEngineWithFragment=false`), а НЕ через `provideFlutterEngine()`.
/// Последний на `FlutterFragmentActivity` идёт по «new engine»-пути
/// (`destroyEngineWithHost=true`): при перезапуске Activity новый `FlutterFragment`
/// цеплялся к тому же кэш-движку, ещё «принадлежащему» прошлой Activity →
/// `java.lang.AssertionError: The internal FlutterEngine ... has been attached to
/// by another activity` → краш процесса ~через 2с после старта звонка. Кэш-путь
/// этого не делает, а `launchMode=singleTask` (см. манифест) гарантирует
/// единственный инстанс Activity — движок всегда прикреплён ровно к одному хосту.
class MainActivity : FlutterFragmentActivity() {
    private val channelName = "net.iperon.messenger/call_window"
    private var callWindowChannel: MethodChannel? = null

    // Свой выбор аудио-выхода звонка (setCommunicationDevice, API 31+). См.
    // AudioDevicesHandler и lib/audio_routes.dart.
    private var audioDevicesHandler: AudioDevicesHandler? = null

    /// Имя кэшированного движка, к которому цепляется `FlutterFragment`. Сам движок
    /// кладётся в кэш в [onCreate] ДО `super.onCreate` (см. [ensureEngine]) — иначе
    /// восстановленный из saved-state фрагмент на cold-start не найдёт его и упадёт
    /// `IllegalStateException: The requested cached FlutterEngine did not exist`.
    override fun getCachedEngineId(): String = ENGINE_ID

    override fun onCreate(savedInstanceState: Bundle?) {
        // Движок должен быть в кэше ДО super.onCreate: там FlutterFragmentActivity
        // создаёт/восстанавливает FlutterFragment, а тот сразу цепляется к
        // кэш-движку по [getCachedEngineId]. Ленивое создание здесь (а не прогрев
        // в Application.onCreate) не поднимает полный DI/БД, когда процесс стартовал
        // только ради фонового FCM-обработчика (тот в отдельном isolate, Activity
        // не поднимает).
        ensureEngine()
        // Холодный старт для ответа на звонок: плагин запускает нас с action
        // ...ACTION_CALL_*. Включаем показ поверх локскрина ещё до отрисовки
        // окна, иначе keyguard успеет потребовать разблокировку.
        applyCallLaunchFlags(intent)
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        // Тёплый старт (приложение уже живо): тот же call-intent приходит сюда,
        // т.к. Activity в singleTask (единственный инстанс, повторный launch =
        // onNewIntent).
        applyCallLaunchFlags(intent)
        super.onNewIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Каналы выбора аудио-выхода звонка. Движок один на процесс и переживает
        // пересоздание Activity — переинициализируем handler на каждую привязку,
        // старый освобождаем, чтобы не текли AudioDeviceCallback/каналы.
        audioDevicesHandler?.dispose()
        audioDevicesHandler = AudioDevicesHandler(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
        callWindowChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .also { it.setMethodCallHandler { call, result ->
                when (call.method) {
                    // Flutter держит флаг «поверх локскрина» ровно на время
                    // активного звонка (см. lib/call_push.dart) — включает при
                    // старте звонка, снимает при завершении, чтобы весь мессенджер
                    // не оставался виден поверх блокировки.
                    "allowOverLockscreen" -> {
                        setShowOverLockscreen(call.arguments as? Boolean ?: false)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } }
    }

    private fun applyCallLaunchFlags(intent: Intent?) {
        if (intent == null) return
        // Плагин flutter_callkit_incoming поднимает нас двумя путями:
        //  - full-screen intent входящего (экран выключен): action == null, но в
        //    extras лежит EXTRA_CALLKIT_CALL_DATA;
        //  - «Ответить» из TransparentActivity: action содержит ACTION_CALL_*.
        // Ловим оба, иначе при выключенном экране keyguard успеет потребовать
        // разблокировку раньше, чем Dart узнает о звонке (в фоне стрим закрыт).
        val isCallLaunch =
            intent.action?.contains("ACTION_CALL") == true ||
                intent.hasExtra("EXTRA_CALLKIT_CALL_DATA")
        if (!isCallLaunch) return

        setShowOverLockscreen(true)
        // Тап по ongoing-нотификации активного звонка тоже приходит call-intent'ом
        // (тёплый старт) — просим Flutter снова открыть экран звонка, если он был
        // свёрнут. При холодном старте канал ещё не готов (null) — там `/call`
        // откроет CallGate по снимку.
        callWindowChannel?.invokeMethod("focusCall", null)
    }

    private fun setShowOverLockscreen(show: Boolean) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(show)
            setTurnScreenOn(show)
        } else {
            @Suppress("DEPRECATION")
            val flags =
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            if (show) window.addFlags(flags) else window.clearFlags(flags)
        }
    }

    /// Лениво создаёт единственный на процесс движок и кладёт в
    /// [FlutterEngineCache] под [ENGINE_ID]. `FlutterEngine(context)` сам
    /// авторегистрирует плагины (embedding v2), затем гоняем `main()`.
    /// Идемпотентно и потокобезопасно: под звонок Activity может подниматься
    /// гонкой (full-screen intent + «Ответить»), а два создания вернули бы нас к
    /// исходной проблеме двух isolate'ов.
    private fun ensureEngine() {
        val cache = FlutterEngineCache.getInstance()
        synchronized(engineLock) {
            if (cache.get(ENGINE_ID) == null) {
                val engine = FlutterEngine(applicationContext)
                engine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
                cache.put(ENGINE_ID, engine)
            }
        }
    }

    companion object {
        // Ключ единственного на процесс движка в FlutterEngineCache.
        private const val ENGINE_ID = "net.iperon.messenger/main_engine"

        // Сериализует ленивое создание движка (см. [ensureEngine]).
        private val engineLock = Any()
    }
}
