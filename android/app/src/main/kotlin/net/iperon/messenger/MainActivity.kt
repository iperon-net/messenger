package net.iperon.messenger

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// Хост Flutter-приложения на Android.
///
/// Помимо стандартного `FlutterFragmentActivity` умеет показываться поверх
/// экрана блокировки на время звонка. Без этого при ответе на входящий с
/// заблокированного экрана Android требует разблокировку (отпечаток/PIN):
/// плагин `flutter_callkit_incoming` поднимает нас обычным launch-intent из
/// своей `TransparentActivity`, а Activity без флага `showWhenLocked` система
/// не рисует поверх keyguard.
class MainActivity : FlutterFragmentActivity() {
    private val channelName = "net.iperon.messenger/call_window"
    private var callWindowChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        // Холодный старт для ответа на звонок: плагин запускает нас с action
        // ...ACTION_CALL_*. Включаем показ поверх локскрина ещё до отрисовки
        // окна, иначе keyguard успеет потребовать разблокировку.
        applyCallLaunchFlags(intent)
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        // Тёплый старт (приложение уже живо): тот же call-intent приходит сюда,
        // т.к. Activity в singleTop.
        applyCallLaunchFlags(intent)
        super.onNewIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
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
}
