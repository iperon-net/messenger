package net.iperon.messenger

import android.Manifest
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.ContactsContract
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.Person

/// Показ зашифрованных push-уведомлений (FCM data `{p}` от конвейера
/// уведомлений сервера) — нативно, без Flutter-движка: расшифровка
/// ([PushCrypto] + ключ из [PushKeyStore]), разбор [PushPayload] и сборка
/// системного уведомления. См. docs/plans/push-notifications.md, этап 4.
///
/// Тег системного уведомления: для сообщений — `chat:<chatHex>` (одно
/// уведомление на чат, новые сообщения дописываются в MessagingStyle), для
/// прочих — id уведомления (повтор доставки заменяет, а не дублирует).
object MessagePushHandler {
    private const val LOG_TAG = "IperonPush"

    const val ACTION_PUSH_TAP = "net.iperon.messenger.PUSH_TAP"
    const val EXTRA_KIND = "push_kind"
    const val EXTRA_ID = "push_id"
    const val EXTRA_CHAT_ID = "push_chat_id"
    const val EXTRA_FROM_USER_ID = "push_from_user_id"

    // Сколько последних сообщений чата держать в MessagingStyle.
    private const val MAX_STYLE_MESSAGES = 7

    fun handle(context: Context, encrypted: String) {
        val payload = try {
            val plaintext = PushCrypto.open(encrypted) { keyId -> PushKeyStore.get(context, keyId) }
            if (plaintext == null) {
                // Ключа нет: разлогинены или пуш для старой сессии — молча.
                Log.i(LOG_TAG, "push: no key for payload, dropped")
                return
            }
            PushPayload.parse(plaintext)
        } catch (error: Exception) {
            Log.w(LOG_TAG, "push: decrypt/parse failed", error)
            return
        }

        when (payload.kind) {
            // Прочитано/удалено на другом устройстве — снимаем уведомление чата.
            // TODO(этап 7): MESSAGE_DELETED — снимать только удалённые сообщения.
            PushPayload.KIND_READ_HISTORY, PushPayload.KIND_MESSAGE_DELETED -> {
                NotificationManagerCompat.from(context).cancel(chatTag(payload), 0)
                return
            }
        }

        // Приложение на экране — событие придёт по стриму, системное уведомление
        // не нужно (сервер такие сессии обычно и не будит — presence; это страховка
        // на гонку APP_STATE). Тестовое показываем всегда: его шлют нажатием в
        // открытом приложении.
        if (MainActivity.isForeground && payload.kind != PushPayload.KIND_TEST) {
            Log.i(LOG_TAG, "push: app in foreground, kind=${payload.kind} not shown")
            return
        }

        show(context, payload)
    }

    private fun show(context: Context, payload: PushPayload) {
        NotificationChannels.ensure(context)
        val manager = NotificationManagerCompat.from(context)
        if (!manager.areNotificationsEnabled()) {
            Log.i(LOG_TAG, "push: notifications disabled by user")
            return
        }

        val appName = context.getString(R.string.push_app_name)
        // Включён код-пароль — ни имени, ни текста на экране блокировки/в шторке.
        val hidden = PushKeyStore.isPasscodeEnabled(context)
        val isMessage = payload.kind == PushPayload.KIND_MESSAGE
        val tag = if (isMessage) chatTag(payload) else payload.id.ifEmpty { "kind:${payload.kind}" }

        val builder = NotificationCompat.Builder(context, if (isMessage) NotificationChannels.MESSAGES else NotificationChannels.OTHER)
            .setSmallIcon(R.drawable.ic_stat_notification)
            .setAutoCancel(true)
            .setContentIntent(tapIntent(context, payload, tag))
            .setCategory(if (isMessage) NotificationCompat.CATEGORY_MESSAGE else NotificationCompat.CATEGORY_SOCIAL)
        if (payload.date > 0) builder.setWhen(payload.date).setShowWhen(true)

        when {
            hidden -> builder
                .setContentTitle(appName)
                .setContentText(context.getString(R.string.push_fallback_body))

            isMessage -> {
                val sender = Person.Builder().setName(payload.title.ifEmpty { appName }).build()
                val text = payload.body.ifEmpty { context.getString(R.string.push_message_no_preview) }
                val style = existingStyle(context, tag)
                    ?: NotificationCompat.MessagingStyle(Person.Builder().setName(appName).build())
                style.addMessage(text, payload.date.takeIf { it > 0 } ?: System.currentTimeMillis(), sender)
                while (style.messages.size > MAX_STYLE_MESSAGES) style.messages.removeAt(0)
                builder.setStyle(style)
                    .setContentTitle(payload.title.ifEmpty { appName })
                    .setContentText(text)
            }

            else -> {
                val (title, text) = textFor(context, payload, appName)
                builder.setContentTitle(title).setContentText(text)
                    .setStyle(NotificationCompat.BigTextStyle().bigText(text))
            }
        }

        try {
            manager.notify(tag, 0, builder.build())
        } catch (error: SecurityException) {
            // POST_NOTIFICATIONS отозван между проверкой и показом.
            Log.w(LOG_TAG, "push: notify denied", error)
        }
    }

    private fun textFor(context: Context, payload: PushPayload, appName: String): Pair<String, String> = when (payload.kind) {
        PushPayload.KIND_TEST -> context.getString(R.string.push_test_title) to
            context.getString(R.string.push_test_encrypted_body)
        // Как у Telegram — имя из адресной книги устройства (на сервере имён
        // приватных контактов нет): args[0] — номер в E.164. Нет доступа к
        // контактам или номера там нет — имя, которое прислал сервер.
        PushPayload.KIND_CONTACT_JOINED -> (
            payload.args.firstOrNull()?.let { addressBookName(context, it) } ?: payload.title.ifEmpty { appName }
            ) to context.getString(R.string.push_contact_joined_body)
        PushPayload.KIND_CALL_MISSED -> payload.title.ifEmpty { appName } to
            context.getString(R.string.push_call_missed_body)
        else -> payload.title.ifEmpty { appName } to
            payload.body.ifEmpty { context.getString(R.string.push_fallback_body) }
    }

    /// Имя контакта из адресной книги по номеру (PhoneLookup сам нормализует
    /// форматы). null — нет разрешения READ_CONTACTS, номера нет или ошибка.
    private fun addressBookName(context: Context, phone: String): String? {
        if (context.checkSelfPermission(Manifest.permission.READ_CONTACTS) != PackageManager.PERMISSION_GRANTED) return null
        return try {
            val uri = Uri.withAppendedPath(ContactsContract.PhoneLookup.CONTENT_FILTER_URI, Uri.encode(phone))
            context.contentResolver.query(uri, arrayOf(ContactsContract.PhoneLookup.DISPLAY_NAME), null, null, null)?.use { cursor ->
                if (cursor.moveToFirst()) cursor.getString(0)?.takeIf { it.isNotBlank() } else null
            }
        } catch (error: Exception) {
            Log.w(LOG_TAG, "push: address book lookup failed", error)
            null
        }
    }

    /// MessagingStyle уже показанного уведомления чата — чтобы дописать новое
    /// сообщение, а не заменить ленту одним последним.
    private fun existingStyle(context: Context, tag: String): NotificationCompat.MessagingStyle? {
        val manager = context.getSystemService(NotificationManager::class.java) ?: return null
        val active = manager.activeNotifications.firstOrNull { it.tag == tag } ?: return null
        return NotificationCompat.MessagingStyle.extractMessagingStyleFromNotification(active.notification)
    }

    /// Тап открывает приложение (MainActivity в singleTask) с данными
    /// уведомления — Dart решает, куда перейти (см. PushManager).
    private fun tapIntent(context: Context, payload: PushPayload, tag: String): PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = ACTION_PUSH_TAP
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            putExtra(EXTRA_KIND, payload.kind)
            putExtra(EXTRA_ID, payload.id)
            putExtra(EXTRA_CHAT_ID, hex(payload.chatID))
            putExtra(EXTRA_FROM_USER_ID, hex(payload.fromUserID))
        }
        return PendingIntent.getActivity(
            context, tag.hashCode(), intent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
    }

    /// Данные тапа из intent'а MainActivity (или null, если это не тап по пушу).
    fun tapFromIntent(intent: Intent?): Map<String, Any>? {
        if (intent?.action != ACTION_PUSH_TAP) return null
        return mapOf(
            "kind" to intent.getIntExtra(EXTRA_KIND, PushPayload.KIND_UNKNOWN),
            "id" to (intent.getStringExtra(EXTRA_ID) ?: ""),
            "chatID" to (intent.getStringExtra(EXTRA_CHAT_ID) ?: ""),
            "fromUserID" to (intent.getStringExtra(EXTRA_FROM_USER_ID) ?: ""),
        )
    }

    private fun chatTag(payload: PushPayload) = "chat:" + hex(payload.chatID)

    private fun hex(bytes: ByteArray) = bytes.joinToString("") { "%02x".format(it) }
}
