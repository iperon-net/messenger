package net.iperon.messenger

import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.hiennv.flutter_callkit_incoming.CallkitConstants
import com.hiennv.flutter_callkit_incoming.CallkitEventCallback
import com.hiennv.flutter_callkit_incoming.FlutterCallkitIncomingPlugin
import io.flutter.embedding.engine.FlutterEngineCache
import java.util.UUID

/// «Отклонить» входящего, когда приложение выгружено. Баннер тогда показывает
/// фоновый isolate FCM (`callPushBackgroundHandler`), а событие плагина
/// `ACTION_CALL_DECLINE` слушать некому: `CallPush` подписан только в движке
/// приложения ([AppEngine]), которого нет, — отказ не уходил, звонящий ждал
/// таймаута. Здесь ловим отказ нативно, поднимаем движок без Activity и отдаём
/// его в Dart тем же путём, что кнопки уведомлений ([PushChannel], действие
/// `callDecline`): `PushManager` шлёт `CALL_REJECT` от сессии аккаунта, которому
/// звонили.
///
/// Есть подписчик событий плагина (движок приложения жив, `CallPush` слушает
/// `FlutterCallkitIncoming.onEvent`) — он и отклонит, здесь ничего не делаем,
/// иначе отказ ушёл бы дважды.
object CallDeclineBridge : CallkitEventCallback {
    private const val LOG_TAG = "IperonCall"

    private var context: Context? = null

    /// Регистрирует мост (идемпотентно). Плагин держит колбэки слабыми
    /// ссылками — объект живёт на процесс.
    fun register(context: Context) {
        if (this.context != null) return
        this.context = context.applicationContext
        FlutterCallkitIncomingPlugin.registerEventCallback(this)
    }

    override fun onCallEvent(event: CallkitEventCallback.CallEvent, callData: Bundle) {
        if (event != CallkitEventCallback.CallEvent.DECLINE) return
        val context = context ?: return
        if (FlutterCallkitIncomingPlugin.hasEventListeners()) return
        val callId = callData.getString(CallkitConstants.EXTRA_CALLKIT_ID).orEmpty()
        @Suppress("UNCHECKED_CAST", "DEPRECATION")
        val extra = callData.getSerializable(CallkitConstants.EXTRA_CALLKIT_EXTRA) as? HashMap<String, Any?>
        val fromUserID = extra?.get("fromUserID")?.toString().orEmpty()
        if (callId.isEmpty() || fromUserID.isEmpty()) return
        Log.i(LOG_TAG, "call: decline without engine, raising it callId=$callId")
        val action = mapOf<String, Any>(
            "action" to "callDecline",
            "callId" to callId,
            "fromUserID" to fromUserID,
            "account" to extra?.get("account")?.toString().orEmpty(),
            "id" to UUID.randomUUID().toString(),
        )
        // Движок и канал — только с главного потока.
        Handler(Looper.getMainLooper()).post {
            try {
                AppEngine.ensure(context)
                PushChannel.deliverAction(action, null)
            } catch (error: Exception) {
                Log.w(LOG_TAG, "call: decline delivery failed", error)
            }
        }
    }
}
