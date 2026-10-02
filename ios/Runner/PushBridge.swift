import Flutter
import UserNotifications

/// iOS-сторона канала `net.iperon.messenger/push` (тот же контракт, что у
/// MainActivity/MessagePushHandler на Android, см. lib/push.dart):
///
/// - `setPushKey {keyId, key}` / `clearPushKeys` / `setPasscodeEnabled` — Dart
///   кладёт в общий Keychain то, что нужно Notification Service Extension для
///   расшифровки ([PushKeychain]);
/// - `takeInitialTap` — тап, открывший приложение до готовности Dart;
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
