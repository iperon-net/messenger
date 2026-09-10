import Flutter
import UIKit
import PushKit
import CallKit
import flutter_callkit_incoming

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, PKPushRegistryDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    excludeAppDataFromBackup()

    // PushKit: регистрируем приём VoIP-пушей. VoIP-токен ≠ FCM/APNs-токену для
    // уведомлений; он приходит в pushRegistry(_:didUpdate:...) и уезжает на сервер
    // через flutter_callkit_incoming (setDevicePushTokenVoIP шлёт Dart-событие,
    // которое ловит CallPush → PushManager.registerVoipToken). См. фазу 4,
    // docs/plans/melodic-beaming-elephant.md.
    let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
    voipRegistry.delegate = self
    voipRegistry.desiredPushTypes = [.voIP]

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // MARK: - PushKit (VoIP)

  /// Новый/обновлённый VoIP-токен. Передаём плагину — он сохранит его и пришлёт
  /// Dart-событие actionDidUpdateDevicePushTokenVoip, откуда токен уходит на
  /// сервер (см. CallPush).
  func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
    guard type == .voIP else { return }
    let token = credentials.token.map { String(format: "%02x", $0) }.joined()
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(token)
  }

  func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
    guard type == .voIP else { return }
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
  }

  /// Входящий VoIP-push. Требование Apple (iOS 13+): на КАЖДЫЙ VoIP-push
  /// приложение обязано немедленно отрепортить входящий звонок в CallKit, иначе
  /// система его завершит и перестанет доставлять VoIP-пуши. Поэтому даже на
  /// action=cancel сначала репортим звонок, затем сразу его снимаем.
  func pushRegistry(
    _ registry: PKPushRegistry,
    didReceiveIncomingPushWith payload: PKPushPayload,
    for type: PKPushType,
    completion: @escaping () -> Void
  ) {
    guard type == .voIP else {
      completion()
      return
    }

    let dict = payload.dictionaryPayload
    let callId = (dict["callId"] as? String) ?? ""
    let action = (dict["action"] as? String) ?? "incoming"
    let fromUserID = (dict["fromUserID"] as? String) ?? ""
    // video приходит строкой "true"/"false" (map<string,string> у FCM/APNs).
    let isVideo = ((dict["video"] as? String) ?? "false") == "true" || (dict["video"] as? Bool ?? false)

    guard !callId.isEmpty else {
      // Всё равно обязаны отрепортить звонок, иначе iOS накажет — репортим
      // «пустой» и сразу завершаем.
      let data = flutter_callkit_incoming.Data(id: UUID().uuidString, nameCaller: "Iperon", handle: "", type: 0)
      SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endAllCalls()
        completion()
      }
      return
    }

    let data = flutter_callkit_incoming.Data(
      id: callId,
      nameCaller: "Iperon",
      handle: isVideo ? "Видеозвонок" : "Аудиозвонок",
      type: isVideo ? 1 : 0
    )
    data.extra = ["fromUserID": fromUserID, "video": isVideo]
    data.supportsHolding = false
    data.supportsGrouping = false
    data.supportsUngrouping = false

    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true) {
      if action == "cancel" {
        // Звонок уже отменён звонящим — снимаем только что отрепорченный экран.
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endCall(data)
      }
      completion()
    }
  }

  /// Исключает каталоги с данными приложения из резервных копий iCloud/iTunes
  /// через NSURLIsExcludedFromBackupKey. Library/Caches и tmp система и так не
  /// бэкапит, поэтому помечаем только Application Support (зашифрованная БД) и
  /// Documents. Исключение каталога распространяется на всё его содержимое,
  /// включая файлы, созданные позже.
  private func excludeAppDataFromBackup() {
    let fileManager = FileManager.default
    let directories: [FileManager.SearchPathDirectory] = [
      .applicationSupportDirectory,
      .documentDirectory,
    ]
    for directory in directories {
      guard var url = fileManager.urls(for: directory, in: .userDomainMask).first else {
        continue
      }
      // Каталог должен существовать, иначе setResourceValues завершится ошибкой.
      if !fileManager.fileExists(atPath: url.path) {
        try? fileManager.createDirectory(at: url, withIntermediateDirectories: true)
      }
      do {
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try url.setResourceValues(values)
      } catch {
        NSLog("Failed to exclude \(url.path) from backup: \(error)")
      }
    }
  }
}
