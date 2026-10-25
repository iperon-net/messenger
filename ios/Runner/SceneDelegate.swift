import Flutter
import UIKit
import yandex_login_sdk

class SceneDelegate: FlutterSceneDelegate {
  // Yandex LoginSDK: возврат из приложения Яндекса по custom URL-схеме
  // yx<clientId>://… (Info.plist → CFBundleURLTypes).
  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    var handled = false
    for ctx in URLContexts {
      if YandexLoginSdkPlugin.handle(openURL: ctx.url) { handled = true }
    }
    if !handled {
      super.scene(scene, openURLContexts: URLContexts)
    }
  }

  // Быстрые действия иконки (UIApplicationShortcutItems в Info.plist,
  // lib/app_shortcuts.dart): на холодном старте приходят в опциях подключения
  // сцены, в живом приложении — в windowScene(_:performActionFor:). Dart
  // получает их как тап по уведомлению (PushBridge).
  override func scene(
    _ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    if let item = connectionOptions.shortcutItem {
      PushBridge.shared.handleShortcut(item.type)
    }
  }

  override func windowScene(
    _ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) {
    PushBridge.shared.handleShortcut(shortcutItem.type)
    completionHandler(true)
  }

  // Yandex LoginSDK: возврат по Universal Link https://yx<clientId>.oauth.yandex.ru/auth/finish
  // (redirect_uri токен-flow на iOS; нужен applinks: в entitlements). В scene-based
  // приложении он приходит сюда, а не в AppDelegate, где его ловит плагин.
  override func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    if YandexLoginSdkPlugin.handle(continue: userActivity) { return }
    super.scene(scene, continue: userActivity)
  }
}
