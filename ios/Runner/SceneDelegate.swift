import Flutter
import UIKit
import vkid_flutter_sdk
import yandex_login_sdk

class SceneDelegate: FlutterSceneDelegate {
  // Yandex LoginSDK: возврат из приложения Яндекса по custom URL-схеме
  // yx<clientId>://… (Info.plist → CFBundleURLTypes).
  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    var handled = false
    for ctx in URLContexts {
      if YandexLoginSdkPlugin.handle(openURL: ctx.url) {
        handled = true
      }
      // VK ID SDK: возврат по его схеме vk<clientId>://… — SDK ждёт ссылку, пока идёт
      // авторизация (метод "authorize" канала com.vk.id/vkid).
      else if vkClientId.map({ ctx.url.scheme == "vk\($0)" }) == true,
        VkidFlutterSdkPlugin.vkid.open(url: ctx.url)
      {
        handled = true
      }
    }
    if !handled {
      super.scene(scene, openURLContexts: URLContexts)
    }
  }

  /// Client_id приложения VK ID из Info.plist; nil — VK в этой сборке не настроен.
  /// Экземпляр SDK создаётся при первом обращении и падает без ключей
  /// (preconditionFailure), поэтому без client_id к нему не обращаемся.
  private var vkClientId: String? {
    guard
      let clientId = Bundle.main.object(forInfoDictionaryKey: "VK_APP_CLIENT_ID") as? String,
      !clientId.isEmpty
    else { return nil }
    return clientId
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
    // VK ID SDK: возврат в приложение после быстрой авторизации в приложении VK — по
    // Universal Link https://iperon.net/auth/vk-id (Universal link приложения в
    // кабинете VK ID, компонент /auth/vk-id в AASA; нужен applinks: в entitlements).
    // Прочие ссылки iperon.net — профили и приглашения (lib/deep_links.dart): их SDK
    // не признаёт (open возвращает false), и они уходят в super.
    if vkClientId != nil,
      userActivity.activityType == NSUserActivityTypeBrowsingWeb,
      let url = userActivity.webpageURL,
      url.host == "iperon.net",
      url.path == "/auth/vk-id",
      VkidFlutterSdkPlugin.vkid.open(url: url)
    {
      return
    }
    super.scene(scene, continue: userActivity)
  }
}
