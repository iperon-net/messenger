import Flutter
import UIKit
import flutter_callkit_incoming
import yandex_login_sdk

class SceneDelegate: FlutterSceneDelegate {
  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    var handled = false
    for ctx in URLContexts {
      if YandexLoginSdkPlugin.handle(openURL: ctx.url) { handled = true }
    }
    if !handled {
      super.scene(scene, openURLContexts: URLContexts)
    }
  }

  /// Перезвон из системного списка «Недавние» (Phone → Recents). iOS отдаёт
  /// NSUserActivity с INStartAudioCallIntent/INStartVideoCallIntent, когда
  /// пользователь тапает по нашему прошлому звонку. Плагин flutter_callkit_incoming
  /// достаёт из активности `handle` (то, что мы клали в CallKit handle — userID
  /// абонента в hex) и `isVideo`. Пробрасываем Dart-событием ACTION_CALL_CALLBACK
  /// (sendCallbackEvent) — его ловит CallPush и открывает нашу звонилку (см.
  /// lib/call_push.dart). Приложение на UISceneDelegate, поэтому обработчик здесь,
  /// а не в AppDelegate. Не наш userActivity — пробрасываем в super (форвардинг
  /// плагинам, как для universal links).
  override func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    if let handle = userActivity.handle, !handle.isEmpty {
      let isVideo = userActivity.isVideo ?? false
      NSLog("IPERON_CALL recents callback: handle=\(handle) video=\(isVideo)")
      SwiftFlutterCallkitIncomingPlugin.sharedInstance?.sendCallbackEvent(["id": handle, "isVideo": isVideo])
      return
    }
    super.scene(scene, continue: userActivity)
  }
}
