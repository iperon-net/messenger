import Flutter
import UIKit
import PushKit
import CallKit
import AVFoundation
import AVKit
import MediaPlayer
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

    // PlatformView системного пикера аудио-маршрутов (AVRoutePickerView) для
    // экрана звонка — «полный» выбор выхода на iOS (iPhone/Speaker/BT/CarPlay/
    // AirPlay). См. RoutePickerViewFactory и lib/components/calls/route_picker_button.dart.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "IperonRoutePicker") {
      registrar.register(
        RoutePickerViewFactory(messenger: registrar.messenger()),
        withId: "net.iperon.messenger/route_picker"
      )
    }

    // iOS Picture-in-Picture видеозвонка: мини-окно с видео собеседника при
    // сворачивании приложения. Канал net.iperon.messenger/call_pip_ios,
    // драйвится из lib/call_pip_ios.dart. См. CallPipController + docs/ios_pip_plan.md.
    if let messenger = engineBridge.pluginRegistry.registrar(forPlugin: "IperonCallPip")?.messenger() {
      CallPipController.shared().register(withMessenger: messenger)
    }

    // Канал явной активации AVAudioSession на пути без CallKit
    // (externalCallSystem: исходящий/foreground) — LiveKit сессию сам не
    // активирует. Смену маршрута на динамик/разговорный делает Dart через
    // LiveKit `AudioManager.setSpeakerOutputPreferred` (в externalCallSystem он
    // меняет режим videoChat/voiceChat через движок, не активируя сессию заново),
    // а НЕ здесь. См. lib/calls.dart toggleSpeaker.
    if let messenger = engineBridge.pluginRegistry.registrar(forPlugin: "IperonCallAudio")?.messenger() {
      let channel = FlutterMethodChannel(name: "net.iperon.messenger/call_audio", binaryMessenger: messenger)
      channel.setMethodCallHandler { call, result in
        let session = AVAudioSession.sharedInstance()
        switch call.method {
        // Явная активация AVAudioSession для исходящего/foreground-звонка без
        // CallKit (LiveKit в externalCallSystem не активирует сессию сам). Категория
        // playAndRecord + режим voiceChat (по умолчанию разговорный динамик), с
        // Bluetooth-гарнитурами. См. lib/calls.dart _configureIosAudioForCall.
        case "activateSession":
          do {
            try session.setCategory(.playAndRecord, mode: .voiceChat, options: [.allowBluetooth, .allowBluetoothA2DP])
            try session.setActive(true)
            result(nil)
          } catch {
            result(FlutterError(code: "audio_session", message: error.localizedDescription, details: nil))
          }
        case "deactivateSession":
          do {
            try session.setActive(false, options: [.notifyOthersOnDeactivation])
            result(nil)
          } catch {
            result(FlutterError(code: "audio_session", message: error.localizedDescription, details: nil))
          }
        // Now Playing: заполняем метаданные текущего «воспроизведения» (имя
        // собеседника + аватар) через MPNowPlayingInfoCenter. iOS показывает их
        // в шапке системного пикера аудио-маршрутов (AVRoutePickerView) — вместо
        // дефолтного «Нет аудио» будет имя контакта. Очищается в clearNowPlaying
        // при завершении звонка. Аргументы: title:String, subtitle:String?,
        // artwork:Uint8List? (байты аватара). См. lib/calls.dart setIosNowPlaying.
        case "setNowPlaying":
          let args = call.arguments as? [String: Any]
          let title = (args?["title"] as? String) ?? ""
          var info: [String: Any] = [
            MPMediaItemPropertyTitle: title,
            // Помечаем как «живой поток» — у звонка нет длительности/позиции, иначе
            // iOS рисует шкалу прогресса на 0:00.
            MPNowPlayingInfoPropertyIsLiveStream: true,
          ]
          if let subtitle = args?["subtitle"] as? String, !subtitle.isEmpty {
            info[MPMediaItemPropertyArtist] = subtitle
          }
          if let data = (args?["artwork"] as? FlutterStandardTypedData)?.data,
             let image = UIImage(data: data) {
            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
          }
          MPNowPlayingInfoCenter.default().nowPlayingInfo = info
          result(nil)
        case "clearNowPlaying":
          MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }

  // MARK: - PushKit (VoIP)

  /// Новый/обновлённый VoIP-токен. Передаём плагину — он сохранит его и пришлёт
  /// Dart-событие actionDidUpdateDevicePushTokenVoip, откуда токен уходит на
  /// сервер (см. CallPush).
  func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
    guard type == .voIP else { return }
    let token = credentials.token.map { String(format: "%02x", $0) }.joined()
    NSLog("IPERON_CALL voip token updated: \(token.count) chars")
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
    // Имя звонящего для CallKit-баннера — сервер кладёт его из профиля
    // (имя/фамилия, иначе телефон). Пусто — фолбэк на "Iperon".
    let nameCaller = (dict["nameCaller"] as? String) ?? ""
    // video приходит строкой "true"/"false" (map<string,string> у FCM/APNs).
    let isVideo = ((dict["video"] as? String) ?? "false") == "true" || (dict["video"] as? Bool ?? false)
    NSLog("IPERON_CALL voip push received: callId=\(callId) action=\(action) video=\(isVideo)")

    guard !callId.isEmpty else {
      // Всё равно обязаны отрепортить звонок, иначе iOS накажет — репортим
      // «пустой» и сразу завершаем.
      let data = flutter_callkit_incoming.Data(id: UUID().uuidString, nameCaller: "Iperon", handle: "", type: 0)
      // appName → CXProviderConfiguration.localizedName (подпись «Аудиовызов
      // <appName>»). Иначе плагин подставит дефолт "Callkit".
      data.appName = "Iperon"
      data.includesCallsInRecents = false
      SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endAllCalls()
        completion()
      }
      return
    }

    let data = flutter_callkit_incoming.Data(
      id: callId,
      nameCaller: nameCaller.isEmpty ? "Iperon" : nameCaller,
      handle: isVideo ? "Видеозвонок" : "Аудиозвонок",
      type: isVideo ? 1 : 0
    )
    data.extra = ["fromUserID": fromUserID, "video": isVideo]
    // appName → CXProviderConfiguration.localizedName (подпись «Аудиовызов
    // <appName>»). Иначе плагин подставит дефолт "Callkit".
    data.appName = "Iperon"
    data.supportsHolding = false
    data.supportsGrouping = false
    data.supportsUngrouping = false
    // Не добавляем звонки приложения в системный журнал iOS «Недавние»/историю
    // «Телефона» (CXProviderConfiguration.includesCallsInRecents).
    data.includesCallsInRecents = false
    // Авто-снятие входящего как пропущенного через 60с (плагинный дефолт — 30с,
    // короче каллер-таймаута 45с: callee показал бы «пропущен», пока звонящий ещё
    // звонит). Держим чуть больше каллер-таймаута — штатную отмену обычно успевает
    // cancel-пуш. Совпадает с _kIncomingBannerTimeoutMs в lib/call_push.dart.
    data.duration = 60000

    // configureAudioSession = true — на ответе плагин
    // (SwiftFlutterCallkitIncomingPlugin `provider(perform: CXAnswerCallAction)`)
    // ставит категорию `PlayAndRecord` и `setActive(true)`. Это ЕДИНСТВЕННОЕ
    // место, где флаг применяется на cold-start: входящий по VoIP-push репортит
    // натив отсюда, Dart `_incomingParams` в этот путь НЕ попадает. Без активации
    // сессии плагином CallKit не шлёт `provider(didActivate:)`, LiveKit в
    // `externalCallSystem` держит движок выключенным и ждёт его вечно → тишина; а
    // если бы LiveKit был в `automatic` и активировал сам — гонка `startCapture`
    // на неготовой сессии (ошибка -4100). Итог: активацией владеет CallKit
    // (через плагин), движок LiveKit поднимается по `didActivate` →
    // ACTION_CALL_TOGGLE_AUDIO_SESSION → calls.dart `setAudioEngineActive`.
    // См. lib/calls.dart `_configureIosAudioForCall`, lib/call_push.dart.
    data.configureAudioSession = true

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

/// PlatformView-фабрика системного `AVRoutePickerView` — «полный» выбор
/// аудио-выхода на iOS: одна кнопка, по тапу открывается системный список
/// маршрутов (iPhone / Speaker / Bluetooth / CarPlay / AirPlay) с галочкой на
/// текущем. Apple не даёт приложению программно выбирать произвольный выход, а
/// этот пикер — штатный путь (так делает FaceTime). Работает с активной
/// AVAudioSession звонка (CallKit / наш externalCallSystem), см. lib/calls.dart.
///
/// Регистрируется в [AppDelegate.didInitializeImplicitFlutterEngine] под viewType
/// `net.iperon.messenger/route_picker`. Живёт в этом файле (а не отдельном), т.к.
/// он уже в target Runner — новый .swift пришлось бы вручную прописывать в
/// project.pbxproj. Цвета иконки приходят из Flutter через creationParams
/// (`tint`/`activeTint` — ARGB int), см. route_picker_button.dart.
class RoutePickerViewFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    return RoutePickerPlatformView(frame: frame, args: args)
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

private class RoutePickerPlatformView: NSObject, FlutterPlatformView {
  private let picker: AVRoutePickerView

  init(frame: CGRect, args: Any?) {
    picker = AVRoutePickerView(frame: frame)
    picker.prioritizesVideoDevices = false
    super.init()

    if let params = args as? [String: Any] {
      if let tint = params["tint"] as? NSNumber {
        picker.tintColor = RoutePickerPlatformView.color(fromARGB: tint.intValue)
      }
      if let activeTint = params["activeTint"] as? NSNumber {
        picker.activeTintColor = RoutePickerPlatformView.color(fromARGB: activeTint.intValue)
      }
    }
    picker.backgroundColor = .clear
  }

  func view() -> UIView {
    return picker
  }

  private static func color(fromARGB argb: Int) -> UIColor {
    let a = CGFloat((argb >> 24) & 0xFF) / 255.0
    let r = CGFloat((argb >> 16) & 0xFF) / 255.0
    let g = CGFloat((argb >> 8) & 0xFF) / 255.0
    let b = CGFloat(argb & 0xFF) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
}
