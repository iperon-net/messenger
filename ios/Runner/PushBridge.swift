import Flutter
import UIKit
import UserNotifications

/// iOS-сторона канала `net.iperon.messenger/push` (тот же контракт, что у
/// MainActivity/MessagePushHandler на Android, см. lib/push.dart):
///
/// - `setPushKey {keyId, key}` / `clearPushKeys` / `setPasscodeEnabled` — Dart
///   кладёт в общий Keychain то, что нужно Notification Service Extension для
///   расшифровки ([PushKeychain]);
/// - `takeInitialTap` — тап, открывший приложение до готовности Dart;
/// - `isInBackground` — запущено ли приложение системой в фоне (presence);
/// - `onNotificationTap` (натив → Dart) — тап по уведомлению в живом приложении.
///
/// Плюс решения делегата UNUserNotificationCenter для наших зашифрованных пушей
/// (с полем `p`): показ в foreground и тапы. Прочие пуши AppDelegate отдаёт
/// плагинам (firebase_messaging), как раньше.
final class PushBridge {
  static let shared = PushBridge()

  private var channel: FlutterMethodChannel?
  // Dart готов принимать onNotificationTap — он уже забрал отложенный тап
  // (takeInitialTap зовётся на старте после установки обработчика).
  private var dartReady = false
  private var pendingTap: [String: Any]?

  // PushPayload.Kind.TEST (protobuf-код живёт только в target'е NotificationService).
  private static let kindTest = 1

  func attach(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "net.iperon.messenger/push", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    self.channel = channel
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setPushKey":
      guard let args = call.arguments as? [String: Any],
            let keyId = (args["keyId"] as? FlutterStandardTypedData)?.data,
            let key = (args["key"] as? FlutterStandardTypedData)?.data
      else {
        result(FlutterError(code: "bad_args", message: "keyId/key required", details: nil))
        return
      }
      PushKeychain.putKey(keyId: keyId, key: key)
      result(nil)
    case "clearPushKeys":
      PushKeychain.clearKeys()
      result(nil)
    case "setPasscodeEnabled":
      PushKeychain.setPasscodeEnabled((call.arguments as? Bool) ?? false)
      result(nil)
    case "clearChatNotifications":
      guard let args = call.arguments as? [String: Any], let chatID = args["chatID"] as? String else {
        result(FlutterError(code: "bad_args", message: "chatID required", details: nil))
        return
      }
      let ids = Set(((args["messageIDs"] as? [NSNumber]) ?? []).map(\.int64Value))
      Self.clearChat(
        chatID,
        maxID: (args["maxID"] as? NSNumber)?.int64Value ?? 0,
        messageIDs: ids,
        all: (args["all"] as? Bool) ?? false
      ) { result(nil) }
    case "isInBackground":
      // Фоновый запуск системой (VoIP / тихий пуш): Dart не ставит presence
      // online (Subscribe{background}). См. PushManager.isLaunchedInBackground.
      result(UIApplication.shared.applicationState == .background)
    case "takeInitialTap":
      dartReady = true
      result(pendingTap)
      pendingTap = nil
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Пуш конвейера уведомлений (зашифрованный `p`), а не звонковый/тестовый.
  static func isEncrypted(_ userInfo: [AnyHashable: Any]) -> Bool {
    userInfo["p"] is String
  }

  private static func kind(_ userInfo: [AnyHashable: Any]) -> Int {
    (userInfo["kind"] as? NSNumber)?.intValue ?? 0
  }

  /// Приложение на экране — событие и так придёт по стриму, системное
  /// уведомление не нужно (сервер такие сессии обычно и не будит — presence; это
  /// страховка на гонку APP_STATE). Тестовое показываем всегда: его шлют
  /// нажатием в открытом приложении. Kind кладёт NSE после расшифровки.
  static func foregroundOptions(_ userInfo: [AnyHashable: Any]) -> UNNotificationPresentationOptions {
    kind(userInfo) == kindTest ? [.banner, .list, .sound] : []
  }

  /// Тихий background-пуш конвейера (READ_HISTORY / MESSAGE_DELETED, без
  /// `aps.alert`): расшифровываем `p` и снимаем показанные уведомления чата.
  /// true — пуш наш и разобран (completion позовётся), false — не наш.
  static func handleSilent(_ userInfo: [AnyHashable: Any], completion: @escaping () -> Void) -> Bool {
    guard let encrypted = userInfo["p"] as? String,
          let aps = userInfo["aps"] as? [String: Any], aps["alert"] == nil
    else { return false }

    let signal: SilentSignal?
    do {
      signal = try PushCrypto.open(encrypted, keyLookup: PushKeychain.key(forId:)).flatMap(SilentSignal.parse)
    } catch {
      NSLog("IperonPush: silent decrypt failed: \(error)")
      signal = nil
    }
    guard let signal else {
      completion()
      return true
    }

    let chatID = PushKeychain.hex(signal.chatID)
    switch signal.kind {
    case SilentSignal.kindReadHistory:
      clearChat(chatID, maxID: signal.messageID, messageIDs: [], all: false, completion: completion)
    case SilentSignal.kindMessageDeleted:
      clearChat(chatID, maxID: 0, messageIDs: Set(signal.messageIDs), all: false, completion: completion)
    default:
      completion()
    }
    return true
  }

  /// Снимает доставленные уведомления чата: до [maxID] включительно (у
  /// уведомлений без messageID — тоже), [messageIDs] или все ([all]). chatID и
  /// messageID в userInfo кладёт NSE.
  static func clearChat(
    _ chatID: String, maxID: Int64, messageIDs: Set<Int64>, all: Bool, completion: @escaping () -> Void
  ) {
    let center = UNUserNotificationCenter.current()
    center.getDeliveredNotifications { notifications in
      let identifiers = notifications.compactMap { notification -> String? in
        let info = notification.request.content.userInfo
        guard (info["chatID"] as? String) == chatID else { return nil }
        let id = (info["messageID"] as? NSNumber)?.int64Value ?? 0
        let remove = all || (maxID > 0 && id <= maxID) || (id != 0 && messageIDs.contains(id))
        return remove ? notification.request.identifier : nil
      }
      if !identifiers.isEmpty {
        center.removeDeliveredNotifications(withIdentifiers: identifiers)
      }
      DispatchQueue.main.async(execute: completion)
    }
  }

  /// Тап по уведомлению: Dart решает, куда перейти (PushManager.routeForKind).
  func handleTap(_ userInfo: [AnyHashable: Any]) {
    let tap: [String: Any] = [
      "kind": Self.kind(userInfo),
      "id": (userInfo["id"] as? String) ?? "",
      "chatID": (userInfo["chatID"] as? String) ?? "",
      "fromUserID": (userInfo["fromUserID"] as? String) ?? "",
    ]
    if dartReady, let channel {
      channel.invokeMethod("onNotificationTap", arguments: tap)
    } else {
      pendingTap = tap
    }
  }
}

/// Нужное приложению из `PushPayload` тихого пуша (protos/push_payload_v1.proto):
/// kind (1), chatID (4), messageID (5), messageIDs (11). Свой минимальный
/// декодер, как PushPayload.kt на Android: SwiftProtobuf линкуется только в
/// NSE. Неизвестные поля пропускаются.
struct SilentSignal {
  static let kindReadHistory: Int64 = 11
  static let kindMessageDeleted: Int64 = 12

  var kind: Int64 = 0
  var chatID = Data()
  var messageID: Int64 = 0
  var messageIDs: [Int64] = []

  static func parse(_ data: Data) -> SilentSignal? {
    var reader = Reader(data: [UInt8](data))
    var signal = SilentSignal()
    while !reader.atEnd {
      guard let tag = reader.varint() else { return nil }
      let field = tag >> 3
      let wire = tag & 7
      switch (field, wire) {
      case (1, 0):
        guard let value = reader.varint() else { return nil }
        signal.kind = Int64(bitPattern: value)
      case (4, 2):
        guard let value = reader.bytes() else { return nil }
        signal.chatID = Data(value)
      case (5, 0):
        guard let value = reader.varint() else { return nil }
        signal.messageID = Int64(bitPattern: value)
      case (11, 2):
        // repeated int64: proto3 пишет packed, но принимаем и unpacked.
        guard let value = reader.bytes() else { return nil }
        var packed = Reader(data: value)
        while !packed.atEnd {
          guard let id = packed.varint() else { return nil }
          signal.messageIDs.append(Int64(bitPattern: id))
        }
      case (11, 0):
        guard let value = reader.varint() else { return nil }
        signal.messageIDs.append(Int64(bitPattern: value))
      default:
        guard reader.skip(wire: wire) else { return nil }
      }
    }
    return signal
  }

  private struct Reader {
    let data: [UInt8]
    var position = 0

    var atEnd: Bool { position >= data.count }

    mutating func varint() -> UInt64? {
      var result: UInt64 = 0
      var shift: UInt64 = 0
      while shift < 64, position < data.count {
        let byte = data[position]
        position += 1
        result |= UInt64(byte & 0x7F) << shift
        if byte & 0x80 == 0 { return result }
        shift += 7
      }
      return nil
    }

    mutating func bytes() -> [UInt8]? {
      guard let length = varint(), length <= UInt64(data.count - position) else { return nil }
      let end = position + Int(length)
      defer { position = end }
      return Array(data[position ..< end])
    }

    mutating func skip(wire: UInt64) -> Bool {
      switch wire {
      case 0: return varint() != nil
      case 2: return bytes() != nil
      case 1: return advance(8)
      case 5: return advance(4)
      default: return false
      }
    }

    private mutating func advance(_ count: Int) -> Bool {
      guard count <= data.count - position else { return false }
      position += count
      return true
    }
  }
}
