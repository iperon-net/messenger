import Contacts
import Intents
import UserNotifications

/// Notification Service Extension: расшифровывает alert-пуши конвейера
/// уведомлений сервера (поле `p` рядом с `aps`, `mutable-content: 1`) и
/// подставляет настоящие заголовок и текст. Apple содержимого не видит — в
/// `aps.alert` сервер кладёт только `loc-key = PUSH_FALLBACK_BODY` («Новое
/// уведомление»), он и остаётся, если расшифровать не вышло (нет ключа, битый
/// `p`, не уложились в ~30 с). См. docs/plans/push-notifications.md, этап 3;
/// аналог MessagePushHandler.kt на Android.
///
/// В `userInfo` дописываем kind/id/chatID/fromUserID — по ним приложение решает,
/// показывать ли пуш в foreground и куда вести по тапу (PushBridge.swift).
///
/// Сообщения, реакции, пропущенные звонки и «контакт в Iperon» оформляются
/// как Communication Notification (INSendMessageIntent): слева аватар
/// собеседника или группы, иконка приложения — маленьким значком в углу.
/// Аватары — копии, которые положило приложение ([PushAvatars]); нет копии —
/// система рисует инициалы.
class NotificationService: UNNotificationServiceExtension {
  private var contentHandler: ((UNNotificationContent) -> Void)?
  private var bestAttempt: UNMutableNotificationContent?

  override func didReceive(
    _ request: UNNotificationRequest,
    withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
  ) {
    guard let content = request.content.mutableCopy() as? UNMutableNotificationContent else {
      contentHandler(request.content)
      return
    }
    self.contentHandler = contentHandler
    bestAttempt = content

    if let encrypted = content.userInfo["p"] as? String {
      do {
        // Аккаунт пуша — по ключу (keyID → accountID): аккаунтов на
        // устройстве несколько, у каждого свой ключ.
        var account = ""
        let plaintext = try PushCrypto.open(encrypted) { keyId in
          account = PushKeychain.account(forId: keyId)
          return PushKeychain.key(forId: keyId)
        }
        if let plaintext {
          let payload = try Iperon_V1_PushPayload(serializedBytes: plaintext)
          if let intent = apply(payload, account: account, to: content) {
            bestAttempt = Self.communication(content, intent: intent)
          }
        } else {
          // Ключа нет: разлогинены или пуш для старой сессии. Скрыть уведомление
          // iOS не даёт без filtering entitlement — остаётся фолбэк.
          NSLog("IperonPush: no key for payload, fallback shown")
        }
      } catch {
        NSLog("IperonPush: decrypt/parse failed: \(error)")
      }
    }

    finish()
  }

  /// Система вот-вот прервёт расширение — отдаём то, что успели (фолбэк или
  /// уже подставленный текст).
  override func serviceExtensionTimeWillExpire() {
    finish()
  }

  private func finish() {
    guard let handler = contentHandler, let content = bestAttempt else { return }
    contentHandler = nil
    handler(content)
  }

  /// Подставляет заголовок и текст; возвращает intent для Communication
  /// Notification (nil — обычное уведомление с иконкой приложения).
  private func apply(_ payload: Iperon_V1_PushPayload, account: String, to content: UNMutableNotificationContent) -> INSendMessageIntent? {
    var userInfo = content.userInfo
    // Чей пуш: тап переключает на этот аккаунт, «прочитано» снимает только его.
    userInfo["account"] = account
    userInfo["kind"] = payload.kind.rawValue
    userInfo["id"] = payload.id
    userInfo["chatID"] = PushKeychain.hex(payload.chatID)
    userInfo["fromUserID"] = PushKeychain.hex(payload.fromUserID)
    // По нему READ_HISTORY / MESSAGE_DELETED снимают только своё (PushBridge).
    userInfo["messageID"] = NSNumber(value: payload.messageID)
    // Комментарий к посту канала (4.3): chatID — ветка, тап открывает её по
    // каналу и посту (на устройстве её может ещё не быть).
    if !payload.parentChatID.isEmpty {
      userInfo["parentChatID"] = PushKeychain.hex(payload.parentChatID)
      userInfo["postID"] = NSNumber(value: payload.postID)
    }
    content.userInfo = userInfo
    // Бейдж на иконке — сумма по аккаунтам: число этого аккаунта из пуша
    // (aps.badge, иначе PushPayload.badge) плюс последние числа остальных.
    if let badge = content.badge?.intValue ?? (payload.hasBadge ? Int(payload.badge) : nil) {
      content.badge = NSNumber(value: PushBadges.set(badge, account: account))
    }
    // Аккаунтов несколько — подпись, чей пуш (как в Telegram).
    if let label = PushKeychain.accountLabel(account) { content.subtitle = label }
    // Треды по чату — свои у каждого аккаунта (общий чат двух аккаунтов).
    let thread = (account.isEmpty ? "" : account + ":") + "chat:" + PushKeychain.hex(payload.chatID)

    let appName = Self.text("PUSH_APP_NAME")
    // Имя как в приложении: облачный контакт (title, titleFromContact) →
    // адресная книга устройства по номеру → профиль / номер (title).
    var senderName = payload.title
    if !payload.titleFromContact, !payload.senderPhone.isEmpty,
       let bookName = Self.addressBookName(payload.senderPhone) {
      senderName = bookName
    }
    let title = senderName.isEmpty ? appName : senderName

    // Включён код-пароль или отправитель — локально скрытый профиль («Скрыть
    // профиль») — ни имени, ни текста на экране блокировки.
    if PushKeychain.isPasscodeEnabled || PushKeychain.isHiddenUser(payload.fromUserID, account: account) {
      content.title = appName
      content.body = Self.text("PUSH_FALLBACK_BODY")
      return nil
    }

    switch payload.kind {
    case .test:
      content.title = Self.text("PUSH_TEST_TITLE")
      content.body = Self.text("PUSH_TEST_ENCRYPTED_BODY")
      return nil
    case .contactJoined:
      // Как у Telegram — имя из адресной книги устройства (на сервере имён
      // приватных контактов нет): args[0] — номер в E.164. Нет доступа к
      // контактам или номера там нет — имя, которое прислал сервер.
      content.title = payload.args.first.flatMap(Self.addressBookName) ?? title
      content.body = Self.text("PUSH_CONTACT_JOINED_BODY")
      return Self.intent(payload, sender: content.title, body: content.body)
    case .callMissed:
      content.title = title
      content.body = Self.text("PUSH_CALL_MISSED_BODY")
      return Self.intent(payload, sender: title, body: content.body)
    case .message:
      let body = payload.body.isEmpty ? Self.text("PUSH_MESSAGE_NO_PREVIEW") : payload.body
      if payload.isChannel {
        // Пост канала: от имени канала — заголовок его название, без «Имя:».
        content.title = payload.chatTitle.isEmpty ? appName : payload.chatTitle
        content.body = body
      } else if payload.chatTitle.isEmpty {
        content.title = title
        content.body = body
      } else {
        // Группа и комментарий к посту канала (parentChatID; chatTitle —
        // название канала): заголовок — название, отправитель — в начале текста.
        content.title = payload.chatTitle
        content.body = senderName.isEmpty ? body : senderName + ": " + body
      }
      content.threadIdentifier = thread
      return Self.intent(payload, sender: title, body: body)
    case .secretMessage:
      // Секретный чат: текста у сервера нет — только «новое сообщение».
      content.title = title
      content.body = Self.text("PUSH_SECRET_MESSAGE")
      content.threadIdentifier = thread
      return Self.intent(payload, sender: title, body: content.body)
    case .messageReaction:
      // messageID — моё сообщение: прочитал чат на другом устройстве —
      // READ_HISTORY снимет и это уведомление.
      content.title = title
      content.body = Self.reactionBody(payload)
      content.threadIdentifier = thread
      return Self.intent(payload, sender: title, body: content.body)
    case .systemNotice:
      // Уведомление «Iperon» (новый вход, облачный пароль…): текст по виду
      // события, у входа — ещё устройство и место.
      content.title = title
      content.body = Self.systemNoticeBody(payload)
      content.threadIdentifier = thread
      return nil
    default:
      // READ_HISTORY / MESSAGE_DELETED сюда не попадают: сервер шлёт их
      // background-пушем, их разбирает приложение (PushBridge.handleSilent).
      content.title = title
      content.body = payload.body.isEmpty ? Self.text("PUSH_FALLBACK_BODY") : payload.body
      return nil
    }
  }

  /// INSendMessageIntent от отправителя (аватар — копия по fromUserID). Группа
  /// (chatTitle) — беседа с её названием и аватаром по chatID; получателей
  /// двое (я и отправитель) — иначе iOS покажет её как личную.
  private static func intent(_ payload: Iperon_V1_PushPayload, sender name: String, body: String) -> INSendMessageIntent? {
    if payload.isChannel { return channelIntent(payload, body: body) }
    let senderID = PushKeychain.hex(payload.fromUserID)
    guard !senderID.isEmpty, !name.isEmpty else { return nil }
    var components = PersonNameComponents()
    components.nickname = name
    let sender = INPerson(
      personHandle: INPersonHandle(value: senderID, type: .unknown),
      nameComponents: components,
      displayName: name,
      image: PushAvatars.user(payload.fromUserID).map { INImage(imageData: $0) },
      contactIdentifier: nil,
      customIdentifier: senderID
    )

    let isGroup = !payload.chatTitle.isEmpty
    let chatID = PushKeychain.hex(payload.chatID)
    var recipients: [INPerson]?
    if isGroup {
      let me = INPerson(
        personHandle: INPersonHandle(value: "me", type: .unknown),
        nameComponents: nil,
        displayName: nil,
        image: nil,
        contactIdentifier: nil,
        customIdentifier: nil,
        isMe: true
      )
      recipients = [me, sender]
    }
    let intent = INSendMessageIntent(
      recipients: recipients,
      outgoingMessageType: .outgoingMessageText,
      content: body,
      speakableGroupName: isGroup ? INSpeakableString(spokenPhrase: payload.chatTitle) : nil,
      conversationIdentifier: chatID.isEmpty ? senderID : chatID,
      serviceName: nil,
      sender: sender,
      attachments: nil
    )
    // Комментарий (4.3): аватар — канала (у ветки своего нет).
    let avatarChatID = payload.parentChatID.isEmpty ? payload.chatID : payload.parentChatID
    if isGroup, let image = PushAvatars.chat(avatarChatID) {
      intent.setImage(INImage(imageData: image), forParameterNamed: \.speakableGroupName)
    }
    return intent
  }

  /// Пост канала: «отправитель» — сам канал (автора нет), аватар — копия по
  /// chatID (c<chatID>), как личная беседа с каналом.
  private static func channelIntent(_ payload: Iperon_V1_PushPayload, body: String) -> INSendMessageIntent? {
    let chatID = PushKeychain.hex(payload.chatID)
    guard !chatID.isEmpty, !payload.chatTitle.isEmpty else { return nil }
    var components = PersonNameComponents()
    components.nickname = payload.chatTitle
    let channel = INPerson(
      personHandle: INPersonHandle(value: chatID, type: .unknown),
      nameComponents: components,
      displayName: payload.chatTitle,
      image: PushAvatars.chat(payload.chatID).map { INImage(imageData: $0) },
      contactIdentifier: nil,
      customIdentifier: chatID
    )
    return INSendMessageIntent(
      recipients: nil,
      outgoingMessageType: .outgoingMessageText,
      content: body,
      speakableGroupName: nil,
      conversationIdentifier: chatID,
      serviceName: nil,
      sender: channel,
      attachments: nil
    )
  }

  /// Уведомление в виде Communication Notification. Нет entitlement'а
  /// (`usernotifications.communication`) или иная ошибка — прежний вид.
  private static func communication(_ content: UNMutableNotificationContent, intent: INSendMessageIntent) -> UNMutableNotificationContent {
    let interaction = INInteraction(intent: intent, response: nil)
    interaction.direction = .incoming
    // По нему PushBridge удаляет подсказки скрытых профилей / при код-пароле.
    if intent.speakableGroupName == nil, let sender = intent.sender?.customIdentifier {
      interaction.groupIdentifier = PushAvatars.interactionGroup(user: sender)
    }
    interaction.donate(completion: nil)
    do {
      return try content.updating(from: intent).mutableCopy() as? UNMutableNotificationContent ?? content
    } catch {
      NSLog("IperonPush: communication notification failed: \(error)")
      return content
    }
  }

  /// «❤️ к вашему сообщению «…»» / «❤️ к вашему фото»: args[0] — эмодзи,
  /// body — начало текста, без текста args[1] — вид вложения. Без превью
  /// (args пустые) — «Новая реакция».
  private static func reactionBody(_ payload: Iperon_V1_PushPayload) -> String {
    guard let emoji = payload.args.first else { return text("PUSH_REACTION_NO_PREVIEW") }
    if !payload.body.isEmpty {
      return String(format: text("PUSH_REACTION_TEXT"), emoji, payload.body)
    }
    let key: String
    switch payload.args.count > 1 ? payload.args[1] : "" {
    case "photo": key = "PUSH_REACTION_PHOTO"
    case "video": key = "PUSH_REACTION_VIDEO"
    case "file": key = "PUSH_REACTION_FILE"
    case "voice": key = "PUSH_REACTION_VOICE"
    case "poll": key = "PUSH_REACTION_POLL"
    default: key = "PUSH_REACTION_MESSAGE"
    }
    return String(format: text(key), emoji)
  }

  private static func text(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
  }

  /// Текст SYSTEM_NOTICE: args[0] — вид (имя MessageSystemNotice.Kind),
  /// args[1] — устройство, args[2] / args[3] — место (en / ru). Неизвестный
  /// вид (сервер новее) — общий текст.
  private static func systemNoticeBody(_ payload: Iperon_V1_PushPayload) -> String {
    let key = "PUSH_SYSTEM_" + (payload.args.first ?? "")
    let title = text(key)
    guard title != key else { return text("PUSH_FALLBACK_BODY") }
    let args = payload.args
    let russian = Bundle.main.preferredLocalizations.first == "ru"
    let location = (russian ? [3, 2] : [2, 3]).lazy.compactMap { args.count > $0 && !args[$0].isEmpty ? args[$0] : nil }.first
    let details = [args.count > 1 ? args[1] : "", location ?? ""].filter { !$0.isEmpty }
    return details.isEmpty ? title : title + ": " + details.joined(separator: ", ")
  }

  /// Имя контакта из адресной книги по номеру. nil — нет доступа к контактам
  /// (разрешение общее с приложением), номера нет или ошибка.
  private static func addressBookName(_ phone: String) -> String? {
    let status = CNContactStore.authorizationStatus(for: .contacts)
    var allowed = status == .authorized
    if #available(iOS 18.0, *) {
      allowed = allowed || status == .limited
    }
    guard allowed else { return nil }

    let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: phone))
    let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
    guard let contact = try? CNContactStore().unifiedContacts(matching: predicate, keysToFetch: keys).first,
          let name = CNContactFormatter.string(from: contact, style: .fullName),
          !name.trimmingCharacters(in: .whitespaces).isEmpty
    else { return nil }
    return name
  }
}
