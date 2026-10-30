import AVFoundation
import Cocoa
import CoreAudio
import FlutterMacOS
import NaturalLanguage
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
  /// Делегат Sparkle держим сами: контроллер хранит его слабой ссылкой.
  private let probe = UpdateProbe()
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
    controller = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: probe, userDriverDelegate: nil)
    let action = #selector(SPUStandardUpdaterController.checkForUpdates(_:))
    trayItem = NSMenuItem(title: "Check for Updates…", action: action, keyEquivalent: "")
    appMenuItem = NSMenuItem(title: "Check for Updates…", action: action, keyEquivalent: "")
    trayItem.target = controller
    appMenuItem.target = controller
    #endif
  }

  /// Проверка по запросу приложения (экран «Обновите приложение», «Общие»).
  func check() {
    controller.checkForUpdates(nil)
  }

  /// Тихая проверка appcast без окна Sparkle («Общие» → «Проверить
  /// обновления»): версия новой сборки или пусто — новее нет / не вышло.
  func latestVersion(_ completion: @escaping (String) -> Void) {
    probe.waiting.append(completion)
    // Идёт своя проверка Sparkle — дождёмся её конца (ответ придёт оттуда).
    if probe.waiting.count == 1, !controller.updater.sessionInProgress {
      controller.updater.checkForUpdateInformation()
    }
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

/// Итог тихой проверки [AppUpdater.latestVersion]: найденная версия приходит в
/// `didFindValidUpdate`, конец любой проверки — в `didFinishUpdateCycleFor`
/// (там отвечаем «пусто», если версии не нашли).
final class UpdateProbe: NSObject, SPUUpdaterDelegate {
  var waiting: [(String) -> Void] = []
  private var found = ""

  func updater(_ updater: SPUUpdater, didFindValidUpdate item: SUAppcastItem) {
    found = item.displayVersionString
  }

  func updater(_ updater: SPUUpdater, didFinishUpdateCycleFor updateCheck: SPUUpdateCheck, error: Error?) {
    let version = found
    found = ""
    let callbacks = waiting
    waiting = []
    callbacks.forEach { $0(version) }
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
  /// Проверка динамика (`playTestSound`) — держим, пока играет.
  private var testPlayer: AVPlayer?
  private lazy var textMenu = TextMenu(window: window)

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
    case "checkForUpdates":
      updater?.check()
      result(nil)
    case "latestVersion":
      // nil — автообновление выключено (debug, нет ключа Sparkle).
      guard let updater else {
        result(nil)
        return
      }
      updater.latestVersion { result($0) }
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
    case "audioOutputs":
      result(Self.audioOutputs())
    case "playTestSound":
      // Проверка динамика: файл через выбранное устройство (UID CoreAudio;
      // пусто — системное).
      guard let path = args["path"] as? String else { return result(nil) }
      let player = AVPlayer(url: URL(fileURLWithPath: path))
      if let device = args["device"] as? String, !device.isEmpty {
        player.audioOutputDeviceUniqueID = device
      }
      testPlayer = player
      player.play()
      result(nil)
    case "openPrivacySettings":
      // «Конфиденциальность и безопасность → Камера / Микрофон» — включить
      // доступ после отказа можно только там.
      let pane = (args["kind"] as? String) == "camera" ? "Privacy_Camera" : "Privacy_Microphone"
      if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?\(pane)") {
        NSWorkspace.shared.open(url)
      }
      result(nil)
    case "showTextMenu":
      textMenu.show(args, result: result)
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

  /// Устройства вывода звука (CoreAudio): UID и имя — те же имена, что у
  /// WebRTC (по ним звонок находит выбранный динамик).
  private static func audioOutputs() -> [[String: String]] {
    let system = AudioObjectID(kAudioObjectSystemObject)
    var address = AudioObjectPropertyAddress(
      mSelector: kAudioHardwarePropertyDevices, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMain)
    var size: UInt32 = 0
    guard AudioObjectGetPropertyDataSize(system, &address, 0, nil, &size) == noErr else { return [] }
    var ids = [AudioDeviceID](repeating: 0, count: Int(size) / MemoryLayout<AudioDeviceID>.size)
    guard AudioObjectGetPropertyData(system, &address, 0, nil, &size, &ids) == noErr else { return [] }
    return ids.compactMap { id in
      // Только устройства с выходными потоками.
      var streams = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyStreams, mScope: kAudioDevicePropertyScopeOutput, mElement: kAudioObjectPropertyElementMain)
      var streamsSize: UInt32 = 0
      guard AudioObjectGetPropertyDataSize(id, &streams, 0, nil, &streamsSize) == noErr, streamsSize > 0,
        let uid = stringProperty(id, kAudioDevicePropertyDeviceUID),
        let name = stringProperty(id, kAudioObjectPropertyName)
      else { return nil }
      return ["id": uid, "name": name]
    }
  }

  private static func stringProperty(_ id: AudioObjectID, _ selector: AudioObjectPropertySelector) -> String? {
    var address = AudioObjectPropertyAddress(
      mSelector: selector, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMain)
    var value: Unmanaged<CFString>?
    var size = UInt32(MemoryLayout<Unmanaged<CFString>?>.size)
    guard AudioObjectGetPropertyData(id, &address, 0, nil, &size, &value) == noErr, let value else { return nil }
    return value.takeRetainedValue() as String
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

/// Контекстное меню поля ввода (`showTextMenu`, lib/desktop.dart) — настоящее
/// `NSMenu`, как у `NSTextView` в Telegram для macOS: варианты исправления
/// слова с ошибкой, «Найти», «Искать в Google», пункты приложения (вырезать /
/// скопировать / вставить, «Форматирование»), «Поделиться», «Правописание и
/// грамматика», «Преобразования», «Речь». Поле рисует Flutter, поэтому
/// системное меню само не появляется: пункты приложения приходят из Dart, их
/// выбор уходит обратно (`id`), остальное делаем здесь. Ответ: `{id}` —
/// пункт приложения, `{replace}` — заменить выделение, `{select: [start,
/// end]}` — выделить (UTF-16), `nil` — закрыли или сделано здесь.
final class TextMenu: NSObject {
  private weak var window: NSWindow?
  /// Ответ выбранного пункта (до конца показа меню).
  private var answer: [String: Any]?
  /// «Поделиться» работает после закрытия меню — держим.
  private var sharePicker: NSSharingServicePicker?
  private let speech = AVSpeechSynthesizer()
  /// «Пропустить написание» — на время работы приложения.
  private let spellTag = NSSpellChecker.uniqueSpellDocumentTag()

  init(window: NSWindow?) {
    self.window = window
  }

  func show(_ args: [String: Any], result: @escaping FlutterResult) {
    guard let window, let view = window.contentViewController?.view else { return result(nil) }
    let titles = args["titles"] as? [String: String] ?? [:]
    let selected = args["selected"] as? String ?? ""
    let text = args["text"] as? String ?? ""
    let range = args["selection"] as? [Int] ?? [0, 0]
    let point = view.convert(window.mouseLocationOutsideOfEventStream, from: nil)
    answer = nil
    let menu = NSMenu()
    menu.autoenablesItems = false

    // Слово с ошибкой — варианты сверху, как в NSTextView.
    let word = selected.trimmingCharacters(in: .whitespacesAndNewlines)
    if !word.isEmpty, !word.contains(where: \.isWhitespace) {
      let checker = NSSpellChecker.shared
      let wrong = checker.checkSpelling(of: word, startingAt: 0, language: nil, wrap: false, inSpellDocumentWithTag: spellTag, wordCount: nil)
      if wrong.location != NSNotFound {
        let guesses = checker.guesses(forWordRange: wrong, in: word, language: nil, inSpellDocumentWithTag: spellTag) ?? []
        if guesses.isEmpty {
          menu.addItem(item(titles["noGuesses"], enabled: false))
        }
        for guess in guesses.prefix(8) {
          menu.addItem(item(guess, font: .boldSystemFont(ofSize: NSFont.systemFontSize)) { [weak self] in self?.answer = ["replace": guess] })
        }
        menu.addItem(.separator())
        menu.addItem(item(titles["learnSpelling"]) { checker.learnWord(word) })
        menu.addItem(item(titles["ignoreSpelling"]) { [spellTag] in checker.ignoreWord(word, inSpellDocumentWithTag: spellTag) })
        menu.addItem(.separator())
      }
    }

    if !word.isEmpty {
      let short = word.count > 24 ? String(word.prefix(24)) + "…" : word
      let lookUp = (titles["lookUp"] ?? "Look Up “{text}”").replacingOccurrences(of: "{text}", with: short.replacingOccurrences(of: "\n", with: " "))
      menu.addItem(item(lookUp, icon: "character.book.closed") { [weak view] in
        view?.showDefinition(for: NSAttributedString(string: selected), at: point)
      })
      menu.addItem(item(titles["searchGoogle"], icon: "magnifyingglass") {
        var query = URLComponents(string: "https://www.google.com/search")!
        query.queryItems = [URLQueryItem(name: "q", value: selected)]
        if let url = query.url { NSWorkspace.shared.open(url) }
      })
      menu.addItem(.separator())
    }

    for entry in args["items"] as? [[String: Any]] ?? [] {
      menu.addItem(appItem(entry))
    }

    if !word.isEmpty {
      menu.addItem(.separator())
      let picker = NSSharingServicePicker(items: [selected])
      sharePicker = picker
      let share = picker.standardShareMenuItem
      if let title = titles["share"] { share.title = title }
      menu.addItem(share)
    }

    menu.addItem(.separator())
    let spelling = item(titles["spelling"], icon: "textformat.abc")
    spelling.submenu = NSMenu()
    spelling.submenu?.addItem(item(titles["checkNow"]) { [weak self] in
      self?.answer = self?.check(text, from: range.count > 1 ? range[1] : 0).map { ["select": [$0.location, $0.location + $0.length]] }
    })
    menu.addItem(spelling)
    for entry in args["extra"] as? [[String: Any]] ?? [] {
      menu.addItem(appItem(entry))
    }
    let speak = item(titles["speech"], icon: "speaker.wave.2")
    speak.submenu = NSMenu()
    let spoken = word.isEmpty ? text : selected
    speak.submenu?.addItem(item(titles["startSpeaking"], enabled: !spoken.isEmpty) { [weak self] in self?.say(spoken) })
    speak.submenu?.addItem(item(titles["stopSpeaking"], enabled: speech.isSpeaking) { [weak self] in
      self?.speech.stopSpeaking(at: .immediate)
    })
    menu.addItem(speak)

    menu.popUp(positioning: nil, at: point, in: view)
    // Действие пункта могло встать в очередь после закрытия меню.
    DispatchQueue.main.async { [weak self] in
      result(self?.answer)
      self?.answer = nil
    }
  }

  /// Пункт приложения: `{id, title, enabled, checked, icon, key, children}`,
  /// `{separator: true}`.
  private func appItem(_ entry: [String: Any]) -> NSMenuItem {
    if entry["separator"] as? Bool ?? false { return .separator() }
    let id = entry["id"] as? String ?? ""
    let result = item(entry["title"] as? String, icon: entry["icon"] as? String, enabled: entry["enabled"] as? Bool ?? true) {
      [weak self] in self?.answer = ["id": id]
    }
    result.state = entry["checked"] as? Bool ?? false ? .on : .off
    if let key = entry["key"] as? String, !key.isEmpty {
      result.keyEquivalent = key
      result.keyEquivalentModifierMask = .command
    }
    if let children = entry["children"] as? [[String: Any]] {
      result.submenu = NSMenu()
      result.submenu?.autoenablesItems = false
      children.forEach { result.submenu?.addItem(appItem($0)) }
    }
    return result
  }

  private func item(
    _ title: String?, icon: String? = nil, enabled: Bool = true, font: NSFont? = nil, action: (() -> Void)? = nil
  ) -> NSMenuItem {
    let item = NSMenuItem(title: title ?? "", action: nil, keyEquivalent: "")
    item.isEnabled = enabled
    if let font {
      item.attributedTitle = NSAttributedString(string: title ?? "", attributes: [.font: font])
    }
    // Значки в меню — как у системных с macOS 26; раньше меню без них.
    if #available(macOS 26.0, *), let icon {
      item.image = NSImage(systemSymbolName: icon, accessibilityDescription: nil)
    }
    if let action {
      let target = MenuAction(action)
      item.target = target
      item.action = #selector(MenuAction.run)
      item.representedObject = target
    }
    return item
  }

  /// «Проверить документ сейчас»: первая ошибка правописания или грамматики
  /// после [from] (по кругу); нет — звук.
  private func check(_ text: String, from: Int) -> NSRange? {
    let checker = NSSpellChecker.shared
    let start = min(max(from, 0), (text as NSString).length)
    let spelling = checker.checkSpelling(of: text, startingAt: start, language: nil, wrap: true, inSpellDocumentWithTag: spellTag, wordCount: nil)
    let grammar = checker.checkGrammar(of: text, startingAt: start, language: nil, wrap: true, inSpellDocumentWithTag: spellTag, details: nil)
    // Ближайшая после каретки (найденные «по кругу» — позже).
    let found = [spelling, grammar].filter { $0.location != NSNotFound && $0.length > 0 }
    let next = found.min { a, b in
      (a.location >= start ? a.location : a.location + Int(Int32.max)) < (b.location >= start ? b.location : b.location + Int(Int32.max))
    }
    if next == nil { NSSound.beep() }
    return next
  }

  /// «Начать говорить» — голосом языка текста.
  private func say(_ text: String) {
    speech.stopSpeaking(at: .immediate)
    let utterance = AVSpeechUtterance(string: text)
    if let language = NLLanguageRecognizer.dominantLanguage(for: text)?.rawValue {
      utterance.voice = AVSpeechSynthesisVoice(language: language)
    }
    speech.speak(utterance)
  }
}

/// Действие пункта меню замыканием (держит его сам пункт).
private final class MenuAction: NSObject {
  private let action: () -> Void

  init(_ action: @escaping () -> Void) {
    self.action = action
  }

  @objc func run() {
    action()
  }
}
