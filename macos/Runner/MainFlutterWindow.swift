import Cocoa
import FlutterMacOS
import ServiceManagement
import UserNotifications

class MainFlutterWindow: NSWindow {
  private var desktop: DesktopChannel?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // По умолчанию шире SplitLayout.minWidth (700) — две панели, как Telegram
    // Desktop. Дальше размер и положение запоминает сам AppKit (autosave name);
    // системное восстановление окна выключено, чтобы не спорило с ним.
    self.isRestorable = false
    self.contentMinSize = NSSize(width: 380, height: 500)
    self.setContentSize(NSSize(width: 1100, height: 760))
    self.center()
    self.setFrameAutosaveName("IperonMainWindow")

    RegisterGeneratedPlugins(registry: flutterViewController)
    desktop = DesktopChannel(messenger: flutterViewController.engine.binaryMessenger, window: self)
    // Сжатие видео перед отправкой — тот же код, что на iOS (ios/Runner/VideoCompressor.swift).
    VideoCompressor.shared.attach(messenger: flutterViewController.engine.binaryMessenger)

    super.awakeFromNib()
  }
}

/// Канал `net.iperon.messenger/desktop` (lib/desktop.dart): счётчик на значке в
/// Dock, системные уведомления о сообщениях (UNUserNotificationCenter, тап →
/// `notificationTap` с маршрутом), время бездействия пользователя (presence) и
/// запуск при входе в систему (SMAppService).
final class DesktopChannel: NSObject, UNUserNotificationCenterDelegate {
  private let channel: FlutterMethodChannel
  private weak var window: NSWindow?

  init(messenger: FlutterBinaryMessenger, window: NSWindow) {
    channel = FlutterMethodChannel(name: "net.iperon.messenger/desktop", binaryMessenger: messenger)
    self.window = window
    super.init()
    UNUserNotificationCenter.current().delegate = self
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "setBadge":
      let count = args["count"] as? Int ?? 0
      NSApp.dockTile.badgeLabel = count > 0 ? String(count) : nil
      result(nil)
    case "requestAttention":
      NSApp.requestUserAttention(.informationalRequest)
      result(nil)
    case "idleSeconds":
      // Любой ввод в системе (клавиатура, мышь), не только в нашем окне.
      let anyInput = CGEventType(rawValue: ~0)!
      result(CGEventSource.secondsSinceLastEventType(.combinedSessionState, eventType: anyInput))
    case "requestNotifications":
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
        DispatchQueue.main.async { result(granted) }
      }
    case "showNotification":
      showNotification(args, result: result)
    case "launchAtLogin":
      result(SMAppService.mainApp.status == .enabled)
    case "setLaunchAtLogin":
      let service = SMAppService.mainApp
      do {
        if args["enabled"] as? Bool ?? false {
          try service.register()
        } else {
          try service.unregister()
        }
      } catch {
        // Уже в нужном состоянии — не ошибка; иначе сообщаем.
        let wanted = args["enabled"] as? Bool ?? false
        if (service.status == .enabled) != wanted {
          result(FlutterError(code: "launch_at_login", message: error.localizedDescription, details: nil))
          return
        }
      }
      // Пользователь выключил Iperon в «Объектах входа» — включить можно только
      // там: открываем настройки, Dart покажет подсказку.
      if service.status == .requiresApproval {
        SMAppService.openSystemSettingsLoginItems()
        result("requiresApproval")
        return
      }
      result(service.status == .enabled ? "enabled" : "disabled")
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func showNotification(_ args: [String: Any], result: @escaping FlutterResult) {
    let content = UNMutableNotificationContent()
    content.title = args["title"] as? String ?? ""
    content.body = args["body"] as? String ?? ""
    content.sound = .default
    // Сообщения одного чата — одной группой в Центре уведомлений.
    if let thread = args["thread"] as? String { content.threadIdentifier = thread }
    if let route = args["route"] as? String { content.userInfo = ["route": route] }
    let request = UNNotificationRequest(identifier: args["id"] as? String ?? UUID().uuidString, content: content, trigger: nil)
    UNUserNotificationCenter.current().add(request) { error in
      DispatchQueue.main.async { result(error == nil) }
    }
  }

  // Окно не в фокусе — уведомление показываем и при открытом приложении
  // (Dart решает, нужно ли оно, и шлёт только когда окно не активно).
  func userNotificationCenter(
    _ center: UNUserNotificationCenter, willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.banner, .sound, .list])
  }

  // Тап по уведомлению — окно вперёд и маршрут в Dart.
  func userNotificationCenter(
    _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    NSApp.activate(ignoringOtherApps: true)
    window?.makeKeyAndOrderFront(nil)
    if let route = response.notification.request.content.userInfo["route"] as? String {
      channel.invokeMethod("notificationTap", arguments: ["route": route])
    }
    completionHandler()
  }
}
