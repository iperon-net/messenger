package net.iperon.messenger

import android.Manifest
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.PersistableBundle
import android.provider.ContactsContract
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.Person
import androidx.core.app.RemoteInput
import androidx.core.content.LocusIdCompat
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat

/// Показ зашифрованных push-уведомлений (FCM data `{p}` от конвейера
/// уведомлений сервера) — нативно, без Flutter-движка: расшифровка
/// ([PushCrypto] + ключ из [PushKeyStore]), разбор [PushPayload] и сборка
/// системного уведомления. См. docs/plans/push-notifications.md, этап 4.
///
/// Тег системного уведомления: для сообщений — `chat:<chatHex>` (одно
/// уведомление на чат, новые сообщения дописываются в MessagingStyle), для
/// прочих — id уведомления (повтор доставки заменяет, а не дублирует). У
/// реакций id — `reaction:<chatHex>:<messageID>:<кто>`: по нему [clearChat]
/// снимает их вместе с сообщениями чата.
///
/// Сообщения и реакции — conversation-уведомления (MessagingStyle +
/// long-lived шорткат беседы с id = тег чата): слева аватар собеседника или
/// группы, иконка приложения — маленьким значком в углу. Аватары — копии,
/// которые отдало приложение ([PushAvatars]); нет копии — круг с инициалом.
object MessagePushHandler {
    private const val LOG_TAG = "IperonPush"

    const val ACTION_PUSH_TAP = "net.iperon.messenger.PUSH_TAP"
    const val EXTRA_KIND = "push_kind"
    const val EXTRA_ID = "push_id"
    const val EXTRA_CHAT_ID = "push_chat_id"
    const val EXTRA_FROM_USER_ID = "push_from_user_id"
    const val EXTRA_PARENT_CHAT_ID = "push_parent_chat_id"
    const val EXTRA_POST_ID = "push_post_id"
    const val EXTRA_ACCOUNT = "push_account"

    // Сколько последних сообщений чата держать в MessagingStyle.
    private const val MAX_STYLE_MESSAGES = 7

    // messageID сообщений MessagingStyle (в том же порядке) — в extras самого
    // уведомления: по ним READ_HISTORY / MESSAGE_DELETED снимают только своё.
    private const val EXTRA_MESSAGE_IDS = "iperon_message_ids"

    // hex(userID) собеседника в extras шортката личного чата — чтобы снять
    // шорткаты скрытых профилей ([removeShortcuts]).
    private const val SHORTCUT_USER = "user"

    /// Расшифровывает и разбирает `p`. null — ключа нет (разлогинены или пуш
    /// для старой сессии) или формат битый: такой пуш молча отбрасываем.
    fun decrypt(context: Context, encrypted: String): PushPayload? = try {
        // Аккаунт — по ключу пуша (keyID → accountID): несколько аккаунтов на
        // устройстве, у каждого свой ключ.
        var account = ""
        val plaintext = PushCrypto.open(encrypted) { keyId ->
            account = PushKeyStore.accountOf(context, keyId)
            PushKeyStore.get(context, keyId)
        }
        if (plaintext == null) {
            Log.i(LOG_TAG, "push: no key for payload, dropped")
            null
        } else {
            PushPayload.parse(plaintext)?.copy(account = account)
        }
    } catch (error: Exception) {
        Log.w(LOG_TAG, "push: decrypt/parse failed", error)
        null
    }

    fun handle(context: Context, payload: PushPayload) {
        // Непрочитанные аккаунта — для его строки в списке аккаунтов (их пуши
        // приходят и когда он не активен).
        payload.badge?.let { PushBadges.set(context, payload.account, it) }
        when (payload.kind) {
            // Прочитано / удалено на другом устройстве — снимаем показанное.
            PushPayload.KIND_READ_HISTORY -> {
                clearChat(context, payload.account, hex(payload.chatID), maxID = payload.messageID)
                return
            }
            PushPayload.KIND_MESSAGE_DELETED -> {
                clearChat(context, payload.account, hex(payload.chatID), messageIDs = payload.messageIDs.toSet())
                return
            }
        }

        // Приложение на экране — событие придёт по стриму, системное уведомление
        // не нужно (сервер такие сессии обычно и не будит — presence; это страховка
        // на гонку APP_STATE). Только для активного аккаунта: у остальных стрима
        // нет, их уведомления показываем и на переднем плане. Тестовое — всегда:
        // его шлют нажатием в открытом приложении.
        if (MainActivity.isForeground && payload.kind != PushPayload.KIND_TEST && isActiveAccount(payload.account)) {
            Log.i(LOG_TAG, "push: app in foreground, kind=${payload.kind} not shown")
            return
        }

        show(context, payload)
    }

    /// Пуш активного аккаунта (или неизвестно чей / Dart ещё не сообщил активный).
    private fun isActiveAccount(account: String): Boolean {
        val active = PushChannel.activeAccount
        return active == null || account.isEmpty() || account == active
    }

    private fun show(context: Context, received: PushPayload) {
        // Имя как в приложении: облачный контакт (title, titleFromContact) →
        // адресная книга устройства по номеру → профиль / номер (title).
        val payload = if (!received.titleFromContact && received.senderPhone.isNotEmpty()) {
            addressBookName(context, received.senderPhone)?.let { received.copy(title = it) } ?: received
        } else {
            received
        }
        NotificationChannels.ensure(context)
        val manager = NotificationManagerCompat.from(context)
        if (!manager.areNotificationsEnabled()) {
            Log.i(LOG_TAG, "push: notifications disabled by user")
            return
        }

        val appName = context.getString(R.string.push_app_name)
        // Включён код-пароль или отправитель — локально скрытый профиль («Скрыть
        // профиль») — ни имени, ни текста на экране блокировки/в шторке.
        val hidden = PushKeyStore.isPasscodeEnabled(context) || PushKeyStore.isHiddenUser(context, payload.account, payload.fromUserID)
        // Секретный чат — как сообщение, но текста у сервера нет.
        val secret = payload.kind == PushPayload.KIND_SECRET_MESSAGE
        val isMessage = payload.kind == PushPayload.KIND_MESSAGE || secret
        val isChat = isMessage || payload.kind == PushPayload.KIND_MESSAGE_REACTION
        val tag = if (isMessage) chatTag(payload) else accountTag(payload.account, payload.id.ifEmpty { "kind:${payload.kind}" })

        val builder = NotificationCompat.Builder(context, if (isChat) NotificationChannels.MESSAGES else NotificationChannels.OTHER)
            .setSmallIcon(R.drawable.ic_stat_notification)
            .setAutoCancel(true)
            .setContentIntent(tapIntent(context, payload, tag))
            .setCategory(if (isChat) NotificationCompat.CATEGORY_MESSAGE else NotificationCompat.CATEGORY_SOCIAL)
        if (payload.date > 0) builder.setWhen(payload.date).setShowWhen(true)
        // Аккаунтов несколько — чей пуш (как в Telegram: подпись аккаунта).
        PushKeyStore.accountLabel(context, payload.account)?.let { builder.setSubText(it) }

        when {
            hidden -> builder
                .setContentTitle(appName)
                .setContentText(context.getString(R.string.push_fallback_body))

            isChat -> {
                // Пост канала: автора нет — «отправитель» сам канал (его
                // название и аватар по chatID).
                val channel = payload.isChannel
                val senderID = if (channel) payload.chatID else payload.fromUserID
                val senderName = (if (channel) payload.chatTitle else payload.title).ifEmpty { appName }
                val senderAvatar = if (channel) PushAvatars.chat(context, payload.chatID) else PushAvatars.user(context, payload.fromUserID)
                val sender = Person.Builder()
                    .setName(senderName)
                    .setKey(hex(senderID).ifEmpty { null })
                    .setIcon(IconCompat.createWithBitmap(senderAvatar ?: PushAvatars.placeholder(senderName, senderID)))
                    .build()
                if (isMessage) {
                    messageStyle(context, builder, payload, tag, sender, appName)
                    // Секретный — без кнопок: текста в пуше нет, а ответ в
                    // него — отдельный E2EE-путь. В канал подписчик не пишет.
                    // Комментарий — ветки на устройстве может не быть (ответ
                    // и «прочитано» — из её окна).
                    if (!secret && !channel && !payload.isComment) addActions(context, builder, payload, tag)
                } else {
                    // Реакция: отдельное уведомление (свой тег), но в той же беседе.
                    val text = reactionText(context, payload)
                    builder.setStyle(
                        NotificationCompat.MessagingStyle(Person.Builder().setName(appName).build())
                            .addMessage(text, payload.date.takeIf { it > 0 } ?: System.currentTimeMillis(), sender),
                    ).setContentTitle(senderName).setContentText(text)
                }
                // В реакции нет названия группы — шорткат беседы не трогаем,
                // если он уже есть (иначе группа «переименуется» в отправителя).
                conversation(context, builder, payload, sender, senderName, senderAvatar, keepExisting = !isMessage)
            }

            else -> {
                val (title, text) = textFor(context, payload, appName)
                builder.setContentTitle(title).setContentText(text)
                    .setStyle(NotificationCompat.BigTextStyle().bigText(text))
                // Пропущенный звонок / «контакт в Iperon» — аватар человека
                // («Iperon» — значок приложения).
                if (payload.fromUserID.isNotEmpty() && payload.kind != PushPayload.KIND_SYSTEM_NOTICE) {
                    builder.setLargeIcon(PushAvatars.user(context, payload.fromUserID) ?: PushAvatars.placeholder(title, payload.fromUserID))
                }
            }
        }

        try {
            manager.notify(tag, 0, builder.build())
        } catch (error: SecurityException) {
            // POST_NOTIFICATIONS отозван между проверкой и показом.
            Log.w(LOG_TAG, "push: notify denied", error)
        }
    }

    /// Новое сообщение дописывается в MessagingStyle уже показанного
    /// уведомления чата [tag] (последние [MAX_STYLE_MESSAGES]).
    private fun messageStyle(
        context: Context,
        builder: NotificationCompat.Builder,
        payload: PushPayload,
        tag: String,
        sender: Person,
        appName: String,
    ) {
        val secret = payload.kind == PushPayload.KIND_SECRET_MESSAGE
        val text = if (secret) {
            context.getString(R.string.push_secret_message)
        } else {
            payload.body.ifEmpty { context.getString(R.string.push_message_no_preview) }
        }
        val active = activeNotification(context, tag)
        val style = active?.let { NotificationCompat.MessagingStyle.extractMessagingStyleFromNotification(it) }
            ?: NotificationCompat.MessagingStyle(Person.Builder().setName(appName).build())
        val ids = messageIDs(active, style.messages.size)
        style.addMessage(text, payload.date.takeIf { it > 0 } ?: System.currentTimeMillis(), sender)
        ids += payload.messageID
        while (style.messages.size > MAX_STYLE_MESSAGES) {
            style.messages.removeAt(0)
            ids.removeAt(0)
        }
        // Группа: название — заголовком беседы, отправитель — у каждого
        // сообщения («Имя: текст»). Канал — как личная беседа с каналом.
        val group = payload.chatTitle.isNotEmpty() && !payload.isChannel
        if (group) style.setConversationTitle(payload.chatTitle).setGroupConversation(true)
        builder.setStyle(style)
            .setContentTitle(if (group || payload.isChannel) payload.chatTitle.ifEmpty { appName } else payload.title.ifEmpty { appName })
            .setContentText(if (group && payload.title.isNotEmpty()) "${payload.title}: $text" else text)
            .addExtras(android.os.Bundle().apply { putLongArray(EXTRA_MESSAGE_IDS, ids.toLongArray()) })
    }

    /// Кнопки «Ответить» (поле ввода в шторке) и «Прочитано», как в Telegram:
    /// семантика REPLY / MARK_AS_READ — их понимают Android Auto и Wear OS,
    /// generated replies — системные подсказки ответа. Обрабатывает
    /// [NotificationActionReceiver], приложение не открывается.
    private fun addActions(context: Context, builder: NotificationCompat.Builder, payload: PushPayload, tag: String) {
        fun intent(action: String) = Intent(context, NotificationActionReceiver::class.java).apply {
            this.action = action
            putExtra(NotificationActionReceiver.EXTRA_CHAT_ID, hex(payload.chatID))
            putExtra(NotificationActionReceiver.EXTRA_MAX_ID, payload.messageID)
            putExtra(NotificationActionReceiver.EXTRA_ACCOUNT, payload.account)
        }
        // RemoteInput дописывает текст в intent — PendingIntent ответа обязан
        // быть mutable (intent явный, на свой приёмник).
        val reply = PendingIntent.getBroadcast(
            context,
            "$tag:reply".hashCode(),
            intent(NotificationActionReceiver.ACTION_REPLY),
            PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        val read = PendingIntent.getBroadcast(
            context,
            "$tag:read".hashCode(),
            intent(NotificationActionReceiver.ACTION_READ),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        val label = context.getString(R.string.push_action_reply)
        builder
            .addAction(
                NotificationCompat.Action.Builder(R.drawable.ic_notification_reply, label, reply)
                    .addRemoteInput(RemoteInput.Builder(NotificationActionReceiver.KEY_REPLY_TEXT).setLabel(label).build())
                    .setAllowGeneratedReplies(true)
                    .setSemanticAction(NotificationCompat.Action.SEMANTIC_ACTION_REPLY)
                    .setShowsUserInterface(false)
                    .build(),
            )
            .addAction(
                NotificationCompat.Action.Builder(R.drawable.ic_notification_read, context.getString(R.string.push_action_read), read)
                    .setSemanticAction(NotificationCompat.Action.SEMANTIC_ACTION_MARK_AS_READ)
                    .setShowsUserInterface(false)
                    .build(),
            )
    }

    /// Ответ из шторки — в ленту уведомления чата [chatHex] от «Вы» (так
    /// просит Android: перепоказ снимает индикатор отправки с поля ввода).
    /// id своего сообщения неизвестен (0) — «прочитано» снимет его вместе с
    /// остальными.
    fun appendReply(context: Context, account: String, chatHex: String, text: String) {
        val tag = chatTag(account, chatHex)
        val active = activeNotification(context, tag) ?: return
        val previous = NotificationCompat.MessagingStyle.extractMessagingStyleFromNotification(active) ?: return
        val ids = messageIDs(active, previous.messages.size)
        // «Вы» — пользователь стиля: его сообщения (person = null) система
        // рисует как свои.
        val style = NotificationCompat.MessagingStyle(Person.Builder().setName(context.getString(R.string.push_reply_self)).build())
            .setConversationTitle(previous.conversationTitle)
            .setGroupConversation(previous.isGroupConversation)
        previous.messages.forEach { style.addMessage(it) }
        style.addMessage(text, System.currentTimeMillis(), null as Person?)
        ids += 0L
        while (style.messages.size > MAX_STYLE_MESSAGES) {
            style.messages.removeAt(0)
            ids.removeAt(0)
        }
        val builder = NotificationCompat.Builder(context, active)
            .setStyle(style)
            .setContentText(text)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .addExtras(android.os.Bundle().apply { putLongArray(EXTRA_MESSAGE_IDS, ids.toLongArray()) })
        try {
            NotificationManagerCompat.from(context).notify(tag, 0, builder.build())
        } catch (error: SecurityException) {
            Log.w(LOG_TAG, "push: reply re-notify denied", error)
        }
    }

    /// Делает уведомление беседой: шорткат чата (имя и аватар собеседника или
    /// группы) + [NotificationCompat.Builder.setShortcutId]. До Android 11
    /// бесед нет — тот же аватар large icon'ом.
    private fun conversation(
        context: Context,
        builder: NotificationCompat.Builder,
        payload: PushPayload,
        sender: Person,
        senderName: String,
        senderAvatar: Bitmap?,
        keepExisting: Boolean,
    ) {
        val group = payload.chatTitle.isNotEmpty()
        val name = if (group) payload.chatTitle else senderName
        // Комментарий (4.3): у ветки своего аватара нет — канала.
        val avatar = (if (group) PushAvatars.chat(context, if (payload.isComment) payload.parentChatID else payload.chatID) else senderAvatar)
            ?: PushAvatars.placeholder(name, if (group) payload.chatID else payload.fromUserID)
        val id = chatTag(payload)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) builder.setLargeIcon(avatar)
        try {
            if (keepExisting && hasShortcut(context, id)) {
                builder.setShortcutId(id).setLocusId(LocusIdCompat(id))
                return
            }
            // Тап по шорткату (лаунчер, «Поделиться») — в чат, как тап по пушу.
            val intent = Intent(context, MainActivity::class.java).apply {
                action = ACTION_PUSH_TAP
                putExtra(EXTRA_KIND, if (payload.kind == PushPayload.KIND_SECRET_MESSAGE) payload.kind else PushPayload.KIND_MESSAGE)
                putExtra(EXTRA_ID, "")
                putExtra(EXTRA_CHAT_ID, hex(payload.chatID))
                putExtra(EXTRA_FROM_USER_ID, hex(payload.fromUserID))
                putExtra(EXTRA_PARENT_CHAT_ID, hex(payload.parentChatID))
                putExtra(EXTRA_POST_ID, payload.postID)
                // Чат другого аккаунта — Dart сначала переключится на него.
                putExtra(EXTRA_ACCOUNT, payload.account)
            }
            val shortcut = ShortcutInfoCompat.Builder(context, id)
                .setShortLabel(name)
                .setLongLived(true)
                .setLocusId(LocusIdCompat(id))
                .setIcon(IconCompat.createWithBitmap(avatar))
                .setIntent(intent)
                .setExtras(PersistableBundle().apply { if (!group) putString(SHORTCUT_USER, hex(payload.fromUserID)) })
            if (!group) shortcut.setPerson(sender)
            ShortcutManagerCompat.pushDynamicShortcut(context, shortcut.build())
            builder.setShortcutId(id).setLocusId(LocusIdCompat(id))
        } catch (error: Exception) {
            Log.w(LOG_TAG, "push: conversation shortcut failed", error)
        }
    }

    private fun hasShortcut(context: Context, id: String): Boolean =
        ShortcutManagerCompat.getShortcuts(context, ShortcutManagerCompat.FLAG_MATCH_DYNAMIC or ShortcutManagerCompat.FLAG_MATCH_CACHED)
            .any { it.id == id }

    /// Снимает шорткаты бесед: все (разлогин, включён код-пароль — в них имена)
    /// или только личных чатов с [users] (hex userID скрытых профилей).
    fun removeShortcuts(context: Context, users: Set<String>? = null) {
        try {
            val flags = ShortcutManagerCompat.FLAG_MATCH_DYNAMIC or ShortcutManagerCompat.FLAG_MATCH_CACHED
            val ids = ShortcutManagerCompat.getShortcuts(context, flags)
                .filter { users == null || it.extras?.getString(SHORTCUT_USER)?.let { user -> user in users } == true }
                .map { it.id }
            if (ids.isNotEmpty()) ShortcutManagerCompat.removeLongLivedShortcuts(context, ids)
        } catch (error: Exception) {
            Log.w(LOG_TAG, "push: remove shortcuts failed", error)
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
        PushPayload.KIND_MESSAGE_REACTION -> payload.title.ifEmpty { appName } to reactionText(context, payload)
        PushPayload.KIND_SYSTEM_NOTICE -> payload.title.ifEmpty { appName } to systemNoticeText(context, payload)
        else -> payload.title.ifEmpty { appName } to
            payload.body.ifEmpty { context.getString(R.string.push_fallback_body) }
    }

    /// Уведомление «Iperon»: args[0] — вид (имя MessageSystemNotice.Kind),
    /// args[1] — устройство, args[2] / args[3] — место (en / ru). Неизвестный
    /// вид (сервер новее) — общий текст.
    private fun systemNoticeText(context: Context, payload: PushPayload): String {
        val res = when (payload.args.firstOrNull()) {
            "NEW_LOGIN" -> R.string.push_system_new_login
            "CLOUD_PASSWORD_SET" -> R.string.push_system_cloud_password_set
            "CLOUD_PASSWORD_CHANGED" -> R.string.push_system_cloud_password_changed
            "CLOUD_PASSWORD_DISABLED" -> R.string.push_system_cloud_password_disabled
            "CLOUD_PASSWORD_RESET" -> R.string.push_system_cloud_password_reset
            "CLOUD_PASSWORD_WRONG" -> R.string.push_system_cloud_password_wrong
            "RECOVERY_EMAIL_SET" -> R.string.push_system_recovery_email_set
            "PASSKEY_ADDED" -> R.string.push_system_passkey_added
            "PASSKEY_REMOVED" -> R.string.push_system_passkey_removed
            else -> return context.getString(R.string.push_fallback_body)
        }
        val args = payload.args
        val russian = context.resources.configuration.locales[0].language == "ru"
        val location = (if (russian) listOf(3, 2) else listOf(2, 3)).firstNotNullOfOrNull { i -> args.getOrNull(i)?.ifEmpty { null } }
        val details = listOfNotNull(args.getOrNull(1)?.ifEmpty { null }, location)
        val title = context.getString(res)
        return if (details.isEmpty()) title else "$title: ${details.joinToString(", ")}"
    }

    /// «❤️ к вашему сообщению «…»» / «❤️ к вашему фото»: args[0] — эмодзи,
    /// body — начало текста, без текста args[1] — вид вложения. Без превью
    /// (args пустые) — «Новая реакция».
    private fun reactionText(context: Context, payload: PushPayload): String {
        val emoji = payload.args.firstOrNull() ?: return context.getString(R.string.push_reaction_no_preview)
        if (payload.body.isNotEmpty()) return context.getString(R.string.push_reaction_text, emoji, payload.body)
        val res = when (payload.args.getOrNull(1)) {
            "photo" -> R.string.push_reaction_photo
            "video" -> R.string.push_reaction_video
            "file" -> R.string.push_reaction_file
            "voice" -> R.string.push_reaction_voice
            "poll" -> R.string.push_reaction_poll
            else -> R.string.push_reaction_message
        }
        return context.getString(res, emoji)
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

    /// Уже показанное уведомление с тегом [tag] — чтобы дописать новое
    /// сообщение в его MessagingStyle, а не заменить ленту одним последним.
    private fun activeNotification(context: Context, tag: String): android.app.Notification? {
        val manager = context.getSystemService(NotificationManager::class.java) ?: return null
        return manager.activeNotifications.firstOrNull { it.tag == tag }?.notification
    }

    /// messageID сообщений стиля уведомления [notification] (выровнены по
    /// концу: у уведомлений старой версии без списка — 0, «неизвестно»).
    private fun messageIDs(notification: android.app.Notification?, count: Int): MutableList<Long> {
        val stored = notification?.extras?.getLongArray(EXTRA_MESSAGE_IDS)?.toList().orEmpty().takeLast(count)
        return (List(count - stored.size) { 0L } + stored).toMutableList()
    }

    /// Снимает показанные сообщения чата [chatHex]: до [maxID] включительно
    /// (прочитано; сообщения с неизвестным id — тоже), [messageIDs] (удалены)
    /// или все ([all]). Осталось что-то — уведомление пересобирается без звука,
    /// иначе снимается целиком. Зовётся из тихого пуша и из Dart (прочитано /
    /// удалено при живом стриме).
    fun clearChat(context: Context, account: String, chatHex: String, maxID: Long = 0, messageIDs: Set<Long> = emptySet(), all: Boolean = false) {
        val manager = NotificationManagerCompat.from(context)
        clearReactions(context, account, chatHex, maxID, messageIDs, all)
        val tag = chatTag(account, chatHex)
        val active = activeNotification(context, tag) ?: return
        val style = NotificationCompat.MessagingStyle.extractMessagingStyleFromNotification(active)
        if (all || style == null) {
            if (all || maxID > 0) manager.cancel(tag, 0)
            return
        }

        val ids = messageIDs(active, style.messages.size)
        val keep = ids.indices.filterNot { i ->
            val id = ids[i]
            (maxID > 0 && id <= maxID) || (id != 0L && id in messageIDs)
        }
        if (keep.size == ids.size) return
        if (keep.isEmpty()) {
            manager.cancel(tag, 0)
            return
        }

        val messages = keep.map { style.messages[it] }
        style.messages.clear()
        style.messages.addAll(messages)
        val last = messages.last()
        val builder = NotificationCompat.Builder(context, active)
            .setStyle(style)
            .setContentText(last.text)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .addExtras(android.os.Bundle().apply { putLongArray(EXTRA_MESSAGE_IDS, keep.map { ids[it] }.toLongArray()) })
        try {
            manager.notify(tag, 0, builder.build())
        } catch (error: SecurityException) {
            Log.w(LOG_TAG, "push: re-notify denied", error)
        }
    }

    /// Снимает уведомления о реакциях чата [chatHex] по тем же правилам, что
    /// [clearChat]: messageID — из тега `reaction:<chatHex>:<messageID>:…`.
    private fun clearReactions(context: Context, account: String, chatHex: String, maxID: Long, messageIDs: Set<Long>, all: Boolean) {
        val manager = context.getSystemService(NotificationManager::class.java) ?: return
        val prefix = accountTag(account, "reaction:$chatHex:")
        for (active in manager.activeNotifications) {
            val tag = active.tag ?: continue
            if (!tag.startsWith(prefix)) continue
            val id = tag.removePrefix(prefix).substringBefore(':').toLongOrNull() ?: 0L
            if (all || (maxID > 0 && id <= maxID) || (id != 0L && id in messageIDs)) {
                manager.cancel(tag, active.id)
            }
        }
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
            // Комментарий к посту канала: ветка открывается по каналу и посту.
            putExtra(EXTRA_PARENT_CHAT_ID, hex(payload.parentChatID))
            putExtra(EXTRA_POST_ID, payload.postID)
            putExtra(EXTRA_ACCOUNT, payload.account)
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
            "parentChatID" to (intent.getStringExtra(EXTRA_PARENT_CHAT_ID) ?: ""),
            "postID" to intent.getLongExtra(EXTRA_POST_ID, 0L),
            "account" to (intent.getStringExtra(EXTRA_ACCOUNT) ?: ""),
        )
    }

    /// Аккаунт ушёл с устройства: его уведомления и шорткаты бесед.
    fun removeAccount(context: Context, account: String) {
        if (account.isEmpty()) return
        val prefix = accountTag(account, "")
        context.getSystemService(NotificationManager::class.java)?.let { manager ->
            for (active in manager.activeNotifications) {
                val tag = active.tag ?: continue
                if (tag.startsWith(prefix)) manager.cancel(tag, active.id)
            }
        }
        try {
            val flags = ShortcutManagerCompat.FLAG_MATCH_DYNAMIC or ShortcutManagerCompat.FLAG_MATCH_CACHED
            val ids = ShortcutManagerCompat.getShortcuts(context, flags).map { it.id }.filter { it.startsWith(prefix) }
            if (ids.isNotEmpty()) ShortcutManagerCompat.removeLongLivedShortcuts(context, ids)
        } catch (error: Exception) {
            Log.w(LOG_TAG, "push: remove account shortcuts failed", error)
        }
    }

    /// Тег уведомления чата: `<accountID>:chat:<chatHex>` — у двух аккаунтов
    /// может быть один чат (личный друг с другом, общая группа). Без аккаунта
    /// (ключ из сборки до мультиаккаунта) — прежний `chat:<chatHex>`.
    private fun chatTag(payload: PushPayload) = chatTag(payload.account, hex(payload.chatID))

    private fun chatTag(account: String, chatHex: String) = accountTag(account, "chat:$chatHex")

    private fun accountTag(account: String, tag: String) = if (account.isEmpty()) tag else "$account:$tag"

    private fun hex(bytes: ByteArray) = bytes.joinToString("") { "%02x".format(it) }
}
