import AVFoundation
import Cocoa
import FlutterMacOS
import ServiceManagement
import Sparkle
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

/// Автообновление (Sparkle, docs/plans/desktop-client.md §10): раз в сутки
/// читает appcast (`SUFeedURL`), проверяет EdDSA-подпись DMG (`SUPublicEDKey`)
/// и предлагает поставить новую версию; вручную — «Проверить обновления…» в
/// меню приложения и в строке меню. В debug и без ключа выключено (`nil`).
final class AppUpdater {
  private let controller: SPUStandardUpdaterController
  /// Пункт меню в строке меню ([TrayIcon]); пункт меню приложения — свой
  /// (NSMenuItem живёт только в одном меню).
  let trayItem: NSMenuItem
  private let appMenuItem: NSMenuItem

  init?() {
    #if DEBUG
    return nil
    #else
    let key = Bundle.main.object(forInfoDictionaryKey: "SUPublicEDKey") as? String ?? ""
    if key.isEmpty { return nil }
    controller = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    let action = #selector(SPUStandardUpdaterController.checkForUpdates(_:))
    trayItem = NSMenuItem(title: "Check for Updates…", action: action, keyEquivalent: "")
    appMenuItem = NSMenuItem(title: "Check for Updates…", action: action, keyEquivalent: "")
    trayItem.target = controller
    appMenuItem.target = controller
    #endif
  }

  /// Подпись на языке приложения; пункт в меню приложения (после «О программе»)
  /// добавляется при первом вызове — к этому времени главное меню уже загружено.
  func setTitle(_ title: String) {
    trayItem.title = title
    appMenuItem.title = title
    if appMenuItem.menu == nil, let menu = NSApp.mainMenu?.items.first?.submenu {
      menu.insertItem(appMenuItem, at: min(1, menu.numberOfItems))
    }
  }
}

/// Значок в строке меню (как у Telegram Desktop): шаблонная картинка (система
/// красит её под светлую / тёмную строку), рядом — число непрочитанных чатов.
/// Клик — сразу окно (как у Telegram Desktop); правый клик (или ⌃-клик) —
/// меню: открыть окно, проверить обновления ([AppUpdater]), завершить
/// приложение. Подписи приходят из Dart (`setTrayMenu`) на языке приложения.
final class TrayIcon: NSObject {
  private let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  private let openItem = NSMenuItem(title: "Open Iperon", action: #selector(open), keyEquivalent: "")
  private let quitItem = NSMenuItem(title: "Quit Iperon", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
  private let menu = NSMenu()
  private weak var window: NSWindow?

  init(window: NSWindow, updater: AppUpdater?) {
    self.window = window
    super.init()
    let image = NSImage(named: "TrayIcon")
    image?.isTemplate = true
    item.button?.image = image
    item.button?.imagePosition = .imageLeading
    item.button?.toolTip = "Iperon"
    openItem.target = self
    menu.addItem(openItem)
    if let updater {
      menu.addItem(updater.trayItem)
    }
    menu.addItem(.separator())
    menu.addItem(quitItem)
    // Меню не привязываем к значку насовсем (тогда любой клик открывал бы его):
    // клики приходят в clicked, меню показываем только на правый.
    item.button?.target = self
    item.button?.action = #selector(clicked)
    item.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
  }

  @objc private func clicked() {
    let event = NSApp.currentEvent
    if event?.type == .rightMouseUp || event?.modifierFlags.contains(.control) == true {
      item.menu = menu
      item.button?.performClick(nil)
      item.menu = nil
    } else {
      open()
    }
  }

  func setTitles(open: String, quit: String) {
    openItem.title = open
    quitItem.title = quit
  }

  func setCount(_ count: Int) {
    item.button?.title = count > 0 ? String(count) : ""
  }

  @objc private func open() {
    NSApp.activate(ignoringOtherApps: true)
    window?.makeKeyAndOrderFront(nil)
  }
}

/// Канал `net.iperon.messenger/desktop` (lib/desktop.dart): счётчик на значке в
/// Dock и в строке меню ([TrayIcon]), системные уведомления о сообщениях (UNUserNotificationCenter, тап →
/// `notificationTap` с маршрутом), время бездействия пользователя (presence) и
/// запуск при входе в систему (SMAppService).
final class DesktopChannel: NSObject, UNUserNotificationCenterDelegate {
  private let channel: FlutterMethodChannel
  private weak var window: NSWindow?
  private let tray: TrayIcon
  private let updater = AppUpdater()
  /// Запрос «прыгать значком» входящего звонка (`showWindow` attention).
  private var attentionRequest = 0

  init(messenger: FlutterBinaryMessenger, window: NSWindow) {
    channel = FlutterMethodChannel(name: "net.iperon.messenger/desktop", binaryMessenger: messenger)
    self.window = window
    tray = TrayIcon(window: window, updater: updater)
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
      tray.setCount(count)
      result(nil)
    case "setTrayMenu":
      tray.setTitles(open: args["open"] as? String ?? "", quit: args["quit"] as? String ?? "")
      if let title = args["updates"] as? String {
        updater?.setTitle(title)
      }
      result(nil)
    case "requestAttention":
      NSApp.requestUserAttention(.informationalRequest)
      result(nil)
    case "showWindow":
      // Входящий звонок: окно вперёд; значок в Dock прыгает, пока не откроют
      // (`critical`) — система может не дать отнять фокус у другого приложения.
      NSApp.activate(ignoringOtherApps: true)
      window?.makeKeyAndOrderFront(nil)
      if args["attention"] as? Bool ?? false {
        attentionRequest = NSApp.requestUserAttention(.criticalRequest)
      }
      result(nil)
    case "cancelAttention":
      if attentionRequest != 0 { NSApp.cancelUserAttentionRequest(attentionRequest) }
      attentionRequest = 0
      result(nil)
    case "removeNotification":
      if let id = args["id"] as? String {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
      }
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
    case "listWidth":
      result(UserDefaults.standard.object(forKey: "splitListWidth") as? Double)
    case "setListWidth":
      if let width = args["width"] as? Double {
        UserDefaults.standard.set(width, forKey: "splitListWidth")
      } else {
        UserDefaults.standard.removeObject(forKey: "splitListWidth")
      }
      result(nil)
    case "mediaAccess":
      // Доступ к камере / микрофону: granted | denied | notDetermined.
      guard let type = Self.mediaType(args["kind"] as? String) else { return result("denied") }
      switch AVCaptureDevice.authorizationStatus(for: type) {
      case .authorized: result("granted")
      case .notDetermined: result("notDetermined")
      default: result("denied")
      }
    case "requestMediaAccess":
      // Системный вопрос (только из notDetermined; иначе сразу ответ).
      guard let type = Self.mediaType(args["kind"] as? String) else { return result(false) }
      AVCaptureDevice.requestAccess(for: type) { granted in
        DispatchQueue.main.async { result(granted) }
      }
    case "openPrivacySettings":
      // «Конфиденциальность и безопасность → Камера / Микрофон» — включить
      // доступ после отказа можно только там.
      let pane = (args["kind"] as? String) == "camera" ? "Privacy_Camera" : "Privacy_Microphone"
      if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?\(pane)") {
        NSWorkspace.shared.open(url)
      }
      result(nil)
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

  private static func mediaType(_ kind: String?) -> AVMediaType? {
    switch kind {
    case "camera": return .video
    case "microphone": return .audio
    default: return nil
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
