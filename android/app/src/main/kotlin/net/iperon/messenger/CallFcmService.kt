package net.iperon.messenger

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

    private companion object {
        // Ключи FCM-payload — см. internal/services/push.go (data map) и
        // lib/call_push.dart (_kAction/_kCallId/_kActionCancel).
        const val KEY_ACTION = "action"
        const val KEY_CALL_ID = "callId"
        const val ACTION_CANCEL = "cancel"
    }
}
