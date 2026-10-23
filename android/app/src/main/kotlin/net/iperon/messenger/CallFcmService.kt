package net.iperon.messenger

import android.app.ActivityManager
import android.app.KeyguardManager
import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Bundle
import android.os.Parcel
import com.google.firebase.messaging.RemoteMessage
import com.hiennv.flutter_callkit_incoming.CallkitConstants
import com.hiennv.flutter_callkit_incoming.CallkitIncomingBroadcastReceiver
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService
import io.flutter.plugins.firebase.messaging.FlutterFirebaseRemoteMessageLiveData

/// FCM-сервис приложения: нативное снятие входящего звонка на `action=cancel`,
/// расшифровка пушей с полем `p` и тестовый пуш. В Dart (`onMessage` /
/// `onBackgroundMessage`) FCM-сообщения доставляет не этот сервис, а
/// `FlutterFirebaseMessagingReceiver` плагина — он видит сырой пуш независимо
/// от нас (у `super.onMessageReceived` тело пустое).
///
/// Зачем cancel нативно. Входящий в фоне/на локскрине показывает нативная
/// `CallkitIncomingActivity` БЕЗ поднятого Flutter-движка. Снятие баннера
/// (`FlutterCallkitIncoming.endCall`) в приложении дёргается только из Dart
/// (`onMessage`/`onBackgroundMessage`/стрим) — всем нужен живой движок. Пока
/// висит эта нативная Activity, приложение для FCM считается foreground, поэтому
/// cancel-пуш маршрутизируется в `onMessage`, а движка нет → отмена теряется, и
/// у сиблинга (аккаунт с несколькими устройствами: ответили на одном — на
/// другом продолжает звонить) экран входящего висит до нативного таймаута.
/// `onMessageReceived` же вызывается FCM всегда — и когда движок не поднят, —
/// поэтому гасим звонок здесь, послав тот же broadcast `ACTION_CALL_ENDED`, что
/// и `endCall` (глушит рингтон, закрывает `CallkitIncomingActivity`, убирает
/// уведомление — см. `CallkitNotificationManager.clearIncomingNotification`).
///
/// Зашифрованный call-пуш (`CALL_INCOMING` / `CALL_CANCEL` в `p`): ресивер
/// плагина отдаёт Dart сырой `{p}`, который `lib/call_push.dart` пропускает (нет
/// callId), поэтому расшифрованный звонок мы сами отдаём в Dart в прежнем
/// открытом виде ([deliverToDart]).
///
/// Регистрируется в AndroidManifest вместо дефолтного
/// `FlutterFirebaseMessagingService` (он удалён через `tools:node="remove"`),
/// т.к. Android отдаёт FCM-сообщение только одному сервису.
class CallFcmService : FlutterFirebaseMessagingService() {

    override fun onMessageReceived(received: RemoteMessage) {
        // Тестовый push (экран «Разработчик», PUSH_TEST) рисуем нативно и в Dart
        // не отдаём — поднимать Flutter-isolate ради уведомления незачем.
        if (received.data[KEY_KIND] == KIND_TEST) {
            showTestNotification()
            return
        }
        // Зашифрованный пуш (поле p): уведомления конвейера показываем нативно,
        // Flutter-isolate не поднимаем; звонок (CALL_INCOMING / CALL_CANCEL)
        // разворачиваем в прежнюю открытую data-map и отдаём Dart тем же
        // путём, что и старый call-пуш, — lib/call_push.dart не меняется.
        received.data[KEY_ENCRYPTED_PAYLOAD]?.let { encrypted ->
            val payload = MessagePushHandler.decrypt(this, encrypted) ?: return
            if (payload.kind != PushPayload.KIND_CALL_INCOMING && payload.kind != PushPayload.KIND_CALL_CANCEL) {
                MessagePushHandler.handle(this, payload)
                return
            }
            val message = callMessage(received, payload)
            cancelIfNeeded(message.data)
            deliverToDart(message)
            return
        }
        // Открытый call-пуш старого сервера. Наш cancel идемпотентен, повторный
        // Dart-endCall безвреден; RING показывает фоновый isolate.
        cancelIfNeeded(received.data)
        super.onMessageReceived(received)
    }

    private fun cancelIfNeeded(data: Map<String, String>) {
        if (data[KEY_ACTION] != ACTION_CANCEL) return
        val callId = data[KEY_CALL_ID].orEmpty()
        if (callId.isNotEmpty()) {
            endIncomingCall(callId)
        }
    }

    /// Отдаёт расшифрованный call-пуш в Dart так же, как ресивер плагина
    /// (`FlutterFirebaseMessagingReceiver.onReceive`, firebase_messaging 17):
    /// приложение на переднем плане — в `onMessage`, иначе — фоновому isolate
    /// (`onBackgroundMessage` → `callPushBackgroundHandler`). Ключ extra
    /// `notification` и разбор foreground — копия пакетных
    /// `FlutterFirebaseMessagingUtils.EXTRA_REMOTE_MESSAGE` /
    /// `isApplicationForeground`: при обновлении плагина сверить.
    private fun deliverToDart(message: RemoteMessage) {
        if (isApplicationForeground()) {
            FlutterFirebaseRemoteMessageLiveData.getInstance().postRemoteMessage(message)
            return
        }
        val parcel = Parcel.obtain()
        try {
            message.writeToParcel(parcel, 0)
            val intent = Intent(this, FlutterFirebaseMessagingBackgroundService::class.java)
                .putExtra(EXTRA_REMOTE_MESSAGE, parcel.marshall())
            FlutterFirebaseMessagingBackgroundService.enqueueMessageProcessing(
                this, intent, message.originalPriority == RemoteMessage.PRIORITY_HIGH,
            )
        } finally {
            parcel.recycle()
        }
    }

    private fun isApplicationForeground(): Boolean {
        val keyguard = getSystemService(KeyguardManager::class.java)
        if (keyguard?.isKeyguardLocked == true) return false
        val processes = getSystemService(ActivityManager::class.java)?.runningAppProcesses ?: return false
        return processes.any {
            it.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND && it.processName == packageName
        }
    }

    /// Копия [received] (id сообщения, приоритет и т.д. — как пришли), где
    /// вместо `p` — data-map call-пуша, как у старого сервера (push.go
    /// SendCallPush; ключи — lib/call_push.dart).
    private fun callMessage(received: RemoteMessage, payload: PushPayload): RemoteMessage {
        val bundle = Bundle(received.toIntent().extras ?: Bundle())
        bundle.remove(KEY_ENCRYPTED_PAYLOAD)
        bundle.putString(KEY_CALL_ID, payload.callID)
        bundle.putString(KEY_ACTION, if (payload.kind == PushPayload.KIND_CALL_INCOMING) ACTION_INCOMING else ACTION_CANCEL)
        bundle.putString(KEY_FROM_USER_ID, payload.fromUserID.joinToString("") { "%02x".format(it) })
        bundle.putString(KEY_VIDEO, payload.video.toString())
        if (payload.kind == PushPayload.KIND_CALL_INCOMING) {
            if (payload.title.isNotEmpty()) bundle.putString(KEY_NAME_CALLER, payload.title)
            if (payload.senderPhone.isNotEmpty()) bundle.putString(KEY_CALLER_PHONE, payload.senderPhone)
            if (payload.titleFromContact) bundle.putString(KEY_NAME_FROM_CONTACT, "true")
            bundle.putString(KEY_SHOW_MISSED, "false")
        }
        return RemoteMessage(bundle)
    }

    /// Гасит нативный входящий по callId независимо от состояния Flutter-движка.
    /// Кладём в бандл id и пустые extra/headers: `Data.fromBundle` кастует их как
    /// non-null (иначе упал бы), а обработчик `ACTION_CALL_ENDED` в
    /// `CallkitIncomingBroadcastReceiver` по этому бандлу останавливает звук,
    /// закрывает `CallkitIncomingActivity` и снимает уведомление.
    private fun endIncomingCall(callId: String) {
        val bundle = Bundle().apply {
            putString(CallkitConstants.EXTRA_CALLKIT_ID, callId)
            putSerializable(CallkitConstants.EXTRA_CALLKIT_EXTRA, HashMap<String, Any?>())
            putSerializable(CallkitConstants.EXTRA_CALLKIT_HEADERS, HashMap<String, Any?>())
        }
        sendBroadcast(CallkitIncomingBroadcastReceiver.getIntentEnded(this, bundle))
    }

    /// Уведомление тестового пуша в канале «Прочее». Тап открывает приложение.
    /// Без разрешения POST_NOTIFICATIONS (Android 13+) система его молча не
    /// покажет — это и проверяем тестом.
    private fun showTestNotification() {
        NotificationChannels.ensure(this)
        val manager = getSystemService(NotificationManager::class.java) ?: return

        val launch = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        }
        val contentIntent = launch?.let {
            PendingIntent.getActivity(this, 0, it, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
        }

        val notification = Notification.Builder(this, NotificationChannels.OTHER)
            .setSmallIcon(R.drawable.ic_stat_notification)
            .setContentTitle(getString(R.string.push_test_title))
            .setContentText(getString(R.string.push_test_body))
            .setAutoCancel(true)
            .setContentIntent(contentIntent)
            .build()

        manager.notify(TEST_NOTIFICATION_TAG, 0, notification)
    }

    private companion object {
        // Ключи FCM-payload — см. internal/services/push.go (data map) и
        // lib/call_push.dart (_kAction/_kCallId/_kActionCancel).
        const val KEY_ACTION = "action"
        const val KEY_CALL_ID = "callId"
        const val ACTION_CANCEL = "cancel"
        const val ACTION_INCOMING = "incoming"
        const val KEY_FROM_USER_ID = "fromUserID"
        const val KEY_VIDEO = "video"
        const val KEY_NAME_CALLER = "nameCaller"
        const val KEY_CALLER_PHONE = "callerPhone"
        const val KEY_NAME_FROM_CONTACT = "nameFromContact"
        const val KEY_SHOW_MISSED = "showMissed"
        // FlutterFirebaseMessagingUtils.EXTRA_REMOTE_MESSAGE (package-private).
        const val EXTRA_REMOTE_MESSAGE = "notification"

        // Не звонковые пуши: kind — тип уведомления (push.go PushKind*).
        const val KEY_KIND = "kind"
        const val KEY_ENCRYPTED_PAYLOAD = "p"
        const val KIND_TEST = "test"
        const val TEST_NOTIFICATION_TAG = "push_test"
    }
}
