package net.iperon.messenger

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.RemoteInput
import java.util.UUID

/// Кнопки уведомления чата «Ответить» (поле ввода в шторке) и «Прочитано» —
/// как в Telegram (`WearReplyReceiver` / `AutoMessageHeardReceiver`): без
/// открытия приложения. Шифрованный запрос к серверу и outbox живут в Dart,
/// поэтому действие уходит в единственный движок ([AppEngine], при
/// необходимости поднимается без Activity) по [PushChannel], а Dart отправляет
/// сообщение / «прочитано» ([PushManager] на стороне Dart).
///
/// Уведомление меняем сразу, не дожидаясь сети: ответ дописывается в ленту
/// («Вы: …» — иначе Android крутит на поле ввода индикатор отправки), на
/// «Прочитано» снимается. Ответ после отправки тоже читает чат — тогда
/// уведомление снимет обычное обновление readInbox.
class NotificationActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val chatHex = intent.getStringExtra(EXTRA_CHAT_ID).orEmpty()
        val maxID = intent.getLongExtra(EXTRA_MAX_ID, 0)
        val account = intent.getStringExtra(EXTRA_ACCOUNT).orEmpty()
        if (chatHex.isEmpty()) return

        val action: Map<String, Any> = when (intent.action) {
            ACTION_REPLY -> {
                val text = RemoteInput.getResultsFromIntent(intent)?.getCharSequence(KEY_REPLY_TEXT)?.toString()?.trim().orEmpty()
                if (text.isEmpty()) return
                MessagePushHandler.appendReply(context, account, chatHex, text)
                mapOf("action" to "reply", "chatID" to chatHex, "maxID" to maxID, "text" to text, "account" to account)
            }
            ACTION_READ -> {
                MessagePushHandler.clearChat(context, account, chatHex, maxID = maxID, all = maxID <= 0)
                mapOf("action" to "read", "chatID" to chatHex, "maxID" to maxID, "account" to account)
            }
            else -> return
        }
        Log.i(LOG_TAG, "push: notification action ${action["action"]} chat=$chatHex")

        // Держим процесс, пока Dart не доделает (или до таймаута PushChannel).
        val hold = goAsync()
        try {
            AppEngine.ensure(context)
            PushChannel.deliverAction(action + ("id" to UUID.randomUUID().toString()), hold)
        } catch (error: Exception) {
            Log.w(LOG_TAG, "push: notification action failed", error)
            hold.finish()
        }
    }

    companion object {
        private const val LOG_TAG = "IperonPush"

        const val ACTION_REPLY = "net.iperon.messenger.NOTIFICATION_REPLY"
        const val ACTION_READ = "net.iperon.messenger.NOTIFICATION_READ"
        const val EXTRA_CHAT_ID = "chat_id"

        // Аккаунт уведомления (accountID слота): ответ и «прочитано» — от него.
        const val EXTRA_ACCOUNT = "account"

        // Последнее сообщение уведомления: «прочитано» — до него включительно.
        const val EXTRA_MAX_ID = "max_id"

        // Ключ RemoteInput поля «Ответить».
        const val KEY_REPLY_TEXT = "reply_text"
    }
}
