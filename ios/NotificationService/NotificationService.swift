import Contacts
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
        if let plaintext = try PushCrypto.open(encrypted, keyLookup: PushKeychain.key(forId:)) {
          apply(try Iperon_V1_PushPayload(serializedBytes: plaintext), to: content)
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

  private func apply(_ payload: Iperon_V1_PushPayload, to content: UNMutableNotificationContent) {
    var userInfo = content.userInfo
    userInfo["kind"] = payload.kind.rawValue
    userInfo["id"] = payload.id
    userInfo["chatID"] = PushKeychain.hex(payload.chatID)
    userInfo["fromUserID"] = PushKeychain.hex(payload.fromUserID)
    // По нему READ_HISTORY / MESSAGE_DELETED снимают только своё (PushBridge).
    userInfo["messageID"] = NSNumber(value: payload.messageID)
    content.userInfo = userInfo

    let appName = Self.text("PUSH_APP_NAME")
    let title = payload.title.isEmpty ? appName : payload.title

    // Включён код-пароль — ни имени, ни текста на экране блокировки.
    if PushKeychain.isPasscodeEnabled {
      content.title = appName
      content.body = Self.text("PUSH_FALLBACK_BODY")
      return
    }

    switch payload.kind {
    case .test:
      content.title = Self.text("PUSH_TEST_TITLE")
      content.body = Self.text("PUSH_TEST_ENCRYPTED_BODY")
    case .contactJoined:
      // Как у Telegram — имя из адресной книги устройства (на сервере имён
      // приватных контактов нет): args[0] — номер в E.164. Нет доступа к
      // контактам или номера там нет — имя, которое прислал сервер.
      content.title = payload.args.first.flatMap(Self.addressBookName) ?? title
      content.body = Self.text("PUSH_CONTACT_JOINED_BODY")
    case .callMissed:
      content.title = title
      content.body = Self.text("PUSH_CALL_MISSED_BODY")
    case .message:
      content.title = title
      content.body = payload.body.isEmpty ? Self.text("PUSH_MESSAGE_NO_PREVIEW") : payload.body
      content.threadIdentifier = "chat:" + PushKeychain.hex(payload.chatID)
    default:
      // READ_HISTORY / MESSAGE_DELETED сюда не попадают: сервер шлёт их
      // background-пушем, их разбирает приложение (PushBridge.handleSilent).
      content.title = title
      content.body = payload.body.isEmpty ? Self.text("PUSH_FALLBACK_BODY") : payload.body
    }
  }

  private static func text(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
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
