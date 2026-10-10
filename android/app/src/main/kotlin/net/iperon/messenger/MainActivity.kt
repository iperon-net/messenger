package net.iperon.messenger

import android.app.AppOpsManager
import android.app.PendingIntent
import android.app.PictureInPictureParams
import android.app.RemoteAction
import android.content.ActivityNotFoundException
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.graphics.Rect
import android.graphics.drawable.Icon
import android.media.AudioManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Process
import android.provider.Settings
import android.util.Rational
import android.view.WindowManager
import androidx.lifecycle.Lifecycle
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
    // Зоны, где жест «назад» от края экрана не срабатывает (ползунки редактора
    // видео у самых краёв) — см. lib/components/chats/gesture_exclusion.dart.
    private val gesturesChannelName = "net.iperon.messenger/system_gestures"
    private var gesturesChannel: MethodChannel? = null

    // Канал Picture-in-Picture (мини-окно видеозвонка поверх рабочего стола).
    // Отдельный от call_window, чтобы не перебивать его обработчик (focusCall) в
    // CallPush своим setMethodCallHandler.
    private val pipChannelName = "net.iperon.messenger/call_pip"
    private var pipChannel: MethodChannel? = null

    private val systemCallChannelName = "net.iperon.messenger/system_call"
    private var systemCallChannel: MethodChannel? = null

    // Канал push-уведомлений: ключи расшифровки и флаг код-пароля для нативного
    // FCM-сервиса (PushKeyStore), тапы по уведомлениям → Dart (PushManager).
    private val pushChannelName = "net.iperon.messenger/push"
    private var pushChannel: MethodChannel? = null

    // Разрешён ли автовход в PiP по нажатию Home. Flutter взводит флаг, пока открыт
    // активный видеозвонок (см. lib/components/calls/call_view.dart), и снимает при
    // уходе с экрана/переходе в аудио. Без флага любое сворачивание приложения
    // (например, из списка чатов) уводило бы в мини-окно.
    private var pipAllowed = false

    // Приёмник действий из PiP-окна. Кнопки в PiP (RemoteAction) не могут напрямую
    // дёргать Flutter — они шлют PendingIntent-broadcast, который ловим здесь и
    // ретранслируем в Dart по pipChannel. Регистрируется в [onCreate], снимается в
    // [onDestroy]. Кнопка «Открыть» (возврат) действует своим launch-intent'ом и
    // сюда не приходит.
    private val pipActionReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == ACTION_PIP_SWITCH_CAMERA) {
                pipChannel?.invokeMethod("pipSwitchCamera", null)
            }
        }
    }

    // Свой выбор аудио-выхода звонка (setCommunicationDevice, API 31+). См.
    // AudioDevicesHandler и lib/audio_routes.dart.
    private var audioDevicesHandler: AudioDevicesHandler? = null

    // Сжатие видео перед отправкой в чат (VideoCompressor, lib/chats/video_prepare.dart).
    private var videoCompressor: VideoCompressor? = null

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
        NotificationChannels.ensure(this)
        // Холодный старт тапом по уведомлению.
        MessagePushHandler.tapFromIntent(intent)?.let { deliverPushTap(it) }
        // Приёмник действий PiP-окна (смена камеры). NOT_EXPORTED — внутренний,
        // снаружи слать нельзя (Android 13+ требует явный флаг экспорта).
        val filter = IntentFilter(ACTION_PIP_SWITCH_CAMERA)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(pipActionReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(pipActionReceiver, filter)
        }
    }

    override fun onDestroy() {
        try {
            unregisterReceiver(pipActionReceiver)
        } catch (_: IllegalArgumentException) {
            // Уже снят / не был зарегистрирован — игнорируем.
        }
        super.onDestroy()
    }

    override fun onNewIntent(intent: Intent) {
        // Тёплый старт (приложение уже живо): тот же call-intent приходит сюда,
        // т.к. Activity в singleTask (единственный инстанс, повторный launch =
        // onNewIntent).
        applyCallLaunchFlags(intent)
        super.onNewIntent(intent)
        // Тёплый старт тапом по уведомлению.
        MessagePushHandler.tapFromIntent(intent)?.let { deliverPushTap(it) }
    }

    override fun onStart() {
        super.onStart()
        isForeground = true
    }

    override fun onStop() {
        isForeground = false
        super.onStop()
    }

    /// Отдаёт тап по уведомлению в Dart. Если Dart ещё не готов (холодный старт:
    /// main() не дошёл до PushManager.start) — откладываем, Dart заберёт его
    /// вызовом `takeInitialTap`.
    private fun deliverPushTap(tap: Map<String, Any>) {
        val channel = pushChannel
        if (pushDartReady && channel != null) {
            channel.invokeMethod("onNotificationTap", tap)
        } else {
            pendingPushTap = tap
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Каналы выбора аудио-выхода звонка. Движок один на процесс и переживает
        // пересоздание Activity — переинициализируем handler на каждую привязку,
        // старый освобождаем, чтобы не текли AudioDeviceCallback/каналы.
        audioDevicesHandler?.dispose()
        audioDevicesHandler = AudioDevicesHandler(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
        videoCompressor?.dispose()
        videoCompressor = VideoCompressor(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
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

        gesturesChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, gesturesChannelName)
            .also { it.setMethodCallHandler { call, result ->
                when (call.method) {
                    // Прямоугольники в логических пикселях Flutter: [left, top, right, bottom, …].
                    "setExclusionRects" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            val values = (call.arguments as? List<*>)?.mapNotNull { (it as? Number)?.toDouble() } ?: emptyList()
                            val density = resources.displayMetrics.density
                            val rects = values.chunked(4).filter { it.size == 4 }.map { (l, t, r, b) ->
                                Rect((l * density).toInt(), (t * density).toInt(), (r * density).toInt(), (b * density).toInt())
                            }
                            window.decorView.systemGestureExclusionRects = rects
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } }

        pipChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, pipChannelName)
            .also { it.setMethodCallHandler { call, result ->
                when (call.method) {
                    // Разрешить/запретить автовход в PiP по Home (взводится на время
                    // активного видеозвонка).
                    "setPipAllowed" -> {
                        pipAllowed = (call.arguments as? Boolean ?: false) && isPipSupported()
                        result.success(pipAllowed)
                    }
                    // Есть ли у приложения разрешение на PiP (AppOps). Отдельно от
                    // системной фичи устройства: фича может быть, а разрешение
                    // пользователь отключил в настройках приложения.
                    "isPipPermissionGranted" -> result.success(isPipPermissionGranted())
                    // Открыть системный экран настройки PiP приложения (запросить
                    // разрешение диалогом нельзя — это AppOps, не runtime-permission).
                    "openPipSettings" -> {
                        openPipSettings()
                        result.success(null)
                    }
                    // Явный вход в PiP (например, по кнопке на экране звонка).
                    "enterPip" -> result.success(enterPipIfPossible())
                    // Закрыть мини-окно (звонок завершился, в т.ч. собеседником).
                    // Иначе PiP-окно висело бы поверх рабочего стола после конца звонка.
                    "exitPip" -> {
                        if (isInPictureInPictureMode) finish()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } }

        // Детект «телефон занят ДРУГИМ звонком» — сотовым или чужим VoIP. См.
        // lib/calls.dart (_systemBusyByOtherCall): вход. → ответить «занято»,
        // исход. → заблокировать. Аргумент exclude (UUID своих CallKit-звонков)
        // на Android не нужен — режим аудио глобальный, а свой in-app-звонок в
        // окно проверки не попадает (см. hasActiveExternalCall).
        pushChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, pushChannelName)
            .also { it.setMethodCallHandler { call, result ->
                when (call.method) {
                    // Ключ расшифровки пушей текущей сессии (Dart выводит HKDF).
                    "setPushKey" -> {
                        val keyId = call.argument<ByteArray>("keyId")
                        val key = call.argument<ByteArray>("key")
                        if (keyId == null || key == null) {
                            result.error("args", "keyId and key are required", null)
                        } else {
                            PushKeyStore.put(applicationContext, keyId, key)
                            result.success(null)
                        }
                    }
                    "clearPushKeys" -> {
                        PushKeyStore.clear(applicationContext)
                        result.success(null)
                    }
                    // Прочитано / удалено (обновление из стрима) — снять показанное.
                    "clearChatNotifications" -> {
                        MessagePushHandler.clearChat(
                            applicationContext,
                            chatHex = call.argument<String>("chatID") ?: "",
                            maxID = call.argument<Number>("maxID")?.toLong() ?: 0,
                            messageIDs = call.argument<List<Number>>("messageIDs").orEmpty().map { it.toLong() }.toSet(),
                            all = call.argument<Boolean>("all") ?: false,
                        )
                        result.success(null)
                    }
                    "setPasscodeEnabled" -> {
                        PushKeyStore.setPasscodeEnabled(applicationContext, call.arguments as? Boolean ?: false)
                        result.success(null)
                    }
                    // Dart готов принимать тапы; заодно забирает отложенный тап
                    // холодного старта.
                    "takeInitialTap" -> {
                        pushDartReady = true
                        result.success(pendingPushTap)
                        pendingPushTap = null
                    }
                    else -> result.notImplemented()
                }
            } }

        systemCallChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, systemCallChannelName)
            .also { it.setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasActiveExternalCall" -> result.success(hasActiveExternalCall())
                    else -> result.notImplemented()
                }
            } }
    }

    /// Занят ли телефон ДРУГИМ АКТИВНЫМ звонком: сотовым (`MODE_IN_CALL`) или чужим
    /// VoIP-приложением (`MODE_IN_COMMUNICATION`). Через `AudioManager.getMode()` —
    /// БЕЗ разрешений (не нужен чувствительный `READ_PHONE_STATE`, которого требуют
    /// `TelephonyManager`/`TelecomManager`). Просто звонящий (не отвеченный) сотовый
    /// (`MODE_RINGING`) занятостью не считаем — разговора ещё нет. Свой собственный
    /// in-app-звонок сюда не попадает: Dart зовёт проверку ДО подключения к комнате
    /// LiveKit (в `startCall` — до старта, в `_onRing` — до подъёма входящего), пока
    /// наш звонок ещё не выставил `MODE_IN_COMMUNICATION`; занятость своим звонком и
    /// так знает `_hasActiveCall`.
    private fun hasActiveExternalCall(): Boolean {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager ?: return false
        return when (audioManager.mode) {
            AudioManager.MODE_IN_CALL, AudioManager.MODE_IN_COMMUNICATION -> true
            else -> false
        }
    }

    /// Поддерживает ли устройство/ОС PiP. Android 8.0+ и системная фича
    /// (на некоторых прошивках/Go-устройствах её нет).
    private fun isPipSupported(): Boolean =
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)

    /// Разрешён ли PiP для приложения на уровне AppOps (пользователь может выключить
    /// его в настройках приложения). Отдельно от [isPipSupported] (фича устройства).
    /// Если фичи нет — считаем «не разрешено».
    private fun isPipPermissionGranted(): Boolean {
        if (!isPipSupported()) return false
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as? AppOpsManager ?: return false
        val uid = Process.myUid()
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_PICTURE_IN_PICTURE, uid, packageName)
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(AppOpsManager.OPSTR_PICTURE_IN_PICTURE, uid, packageName)
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    /// Открывает системный экран настройки PiP приложения (там пользователь включает
    /// разрешение тумблером). При отсутствии экрана — фолбэк на общие настройки
    /// приложения.
    private fun openPipSettings() {
        val uri = Uri.parse("package:$packageName")
        try {
            // Строковый action (публичной константы Settings.ACTION_... нет).
            startActivity(Intent("android.settings.PICTURE_IN_PICTURE_SETTINGS", uri))
        } catch (e: ActivityNotFoundException) {
            try {
                startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, uri))
            } catch (e2: ActivityNotFoundException) {
                // Ни один экран настроек не открылся — молча игнорируем.
            }
        }
    }

    /// Уходит в мини-окно, если это разрешено Flutter'ом и поддерживается. Возвращает
    /// true, если запрос на вход отправлен. Соотношение сторон окна — портретное
    /// 9:16 (видеозвонок в портрете; система ограничивает крайние пропорции).
    private fun enterPipIfPossible(): Boolean {
        if (!pipAllowed || !isPipSupported()) return false
        return try {
            enterPictureInPictureMode(buildPipParams())
        } catch (e: IllegalStateException) {
            // Activity в состоянии, из которого вход в PiP запрещён (например, уже
            // финишируется) — молча игнорируем.
            false
        }
    }

    /// Параметры PiP-окна: портретное соотношение 9:16 + кнопка-действие «Сменить
    /// камеру» (RemoteAction), которую система рисует поверх мини-окна по тапу:
    /// broadcast [ACTION_PIP_SWITCH_CAMERA] → [pipActionReceiver] → Dart (switchCamera).
    /// Отдельной кнопки возврата не добавляем — для разворота на полный экран есть
    /// системная иконка PiP.
    private fun buildPipParams(): PictureInPictureParams {
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE

        val switchIntent = Intent(ACTION_PIP_SWITCH_CAMERA).setPackage(packageName)
        val switchPending = PendingIntent.getBroadcast(this, REQ_PIP_SWITCH, switchIntent, flags)
        val switchAction = RemoteAction(
            Icon.createWithResource(this, R.drawable.ic_pip_flip),
            "Сменить камеру",
            "Переключить фронтальную/тыловую камеру",
            switchPending,
        )

        return PictureInPictureParams.Builder()
            .setAspectRatio(Rational(9, 16))
            .setActions(listOf(switchAction))
            .build()
    }

    /// Пользователь уходит из приложения (Home / переключатель задач). Во время
    /// активного видеозвонка вместо сворачивания уводим экран в мини-окно, чтобы
    /// видео продолжало показываться поверх рабочего стола.
    override fun onUserLeaveHint() {
        if (pipAllowed) enterPipIfPossible()
        super.onUserLeaveHint()
    }

    /// Смена режима PiP ⇄ полноэкранный. Сообщаем Flutter, чтобы экран звонка
    /// переключил компактный лейаут (в мини-окне прячем панель управления, оставляя
    /// только видео).
    override fun onPictureInPictureModeChanged(isInPictureInPictureMode: Boolean, newConfig: Configuration) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        pipChannel?.invokeMethod("pipModeChanged", isInPictureInPictureMode)
        // Выход из PiP бывает двух видов, и различаем их по состоянию жизненного
        // цикла в этот момент:
        //  • разворот на полный экран — Activity идёт в STARTED/RESUMED;
        //  • закрытие крестиком — Activity останавливается (ниже STARTED).
        // При закрытии сообщаем Flutter завершить звонок: система лишь убирает окно,
        // а комната LiveKit без этого осталась бы жить без UI («звонок висит»).
        if (!isInPictureInPictureMode && !lifecycle.currentState.isAtLeast(Lifecycle.State.STARTED)) {
            pipChannel?.invokeMethod("pipClosed", null)
        }
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
        /// Activity видна пользователю (onStart..onStop). Читает FCM-сервис того же
        /// процесса: в foreground системные уведомления не показываем.
        @Volatile
        var isForeground = false
            private set

        // Dart-сторона push-канала готова (вызвала takeInitialTap). Живёт на
        // процесс, как и кэшированный движок, — пересоздание Activity её не
        // сбрасывает.
        @Volatile
        private var pushDartReady = false

        // Тап холодного старта, ещё не забранный Dart.
        private var pendingPushTap: Map<String, Any>? = null

        // Ключ единственного на процесс движка в FlutterEngineCache.
        private const val ENGINE_ID = "net.iperon.messenger/main_engine"

        // Сериализует ленивое создание движка (см. [ensureEngine]).
        private val engineLock = Any()

        // Action внутреннего broadcast'а от кнопки «Сменить камеру» в PiP-окне.
        private const val ACTION_PIP_SWITCH_CAMERA = "net.iperon.messenger.PIP_SWITCH_CAMERA"

        // requestCode для PendingIntent'а действия «Сменить камеру» в PiP.
        private const val REQ_PIP_SWITCH = 1001
    }
}
