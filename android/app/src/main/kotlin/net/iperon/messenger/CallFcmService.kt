package net.iperon.messenger

import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Bundle
import com.google.firebase.messaging.RemoteMessage
import com.hiennv.flutter_callkit_incoming.CallkitConstants
import com.hiennv.flutter_callkit_incoming.CallkitIncomingBroadcastReceiver
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService

/// FCM-сервис приложения. Расширяет сервис firebase_messaging, чтобы ДОБАВИТЬ
/// нативное снятие входящего звонка на `action=cancel`, а всё остальное
/// (показ RING фоновым isolate'ом, доставку в Dart `onMessage`/`onBackgroundMessage`,
/// обновление токена) делегировать в `super` без изменений.
///
/// Зачем нативно. Входящий в фоне/на локскрине показывает нативная
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
/// Регистрируется в AndroidManifest вместо дефолтного
/// `FlutterFirebaseMessagingService` (он удалён через `tools:node="remove"`),
/// т.к. Android отдаёт FCM-сообщение только одному сервису.
class CallFcmService : FlutterFirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        val data = remoteMessage.data
        // Тестовый push (экран «Разработчик», PUSH_TEST) рисуем нативно и в Dart
        // не отдаём — поднимать Flutter-isolate ради уведомления незачем.
        if (data[KEY_KIND] == KIND_TEST) {
            showTestNotification()
            return
        }
        if (data[KEY_ACTION] == ACTION_CANCEL) {
            val callId = data[KEY_CALL_ID].orEmpty()
            if (callId.isNotEmpty()) {
                endIncomingCall(callId)
            }
        }
        // Всё остальное — как раньше: RING (фоновый isolate), доставка в Dart,
        // токены. Наш cancel идемпотентен, повторный Dart-endCall безвреден.
        super.onMessageReceived(remoteMessage)
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

        // Не звонковые пуши: kind — тип уведомления (push.go PushKind*).
        const val KEY_KIND = "kind"
        const val KIND_TEST = "test"
        const val TEST_NOTIFICATION_TAG = "push_test"
    }
}
