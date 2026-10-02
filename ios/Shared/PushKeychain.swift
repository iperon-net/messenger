import Foundation
import Security

/// Общее хранилище приложения и Notification Service Extension: ключ расшифровки
/// push-уведомлений и флаг «включён код-пароль». NSE — отдельный процесс без
/// Flutter и без доступа к зашифрованной SQLCipher-базе, поэтому всё нужное ему
/// лежит в Keychain с общей access group `<TeamID>.net.iperon.messenger.shared`
/// (`keychain-access-groups` в entitlements обоих target'ов). Аналог
/// PushKeyStore.kt на Android.
///
/// Ключ пушей (HKDF от sharedKey сессии) выводит Dart (`PushManager`) и отдаёт
/// по каналу `net.iperon.messenger/push`; ищется по keyID — первые 8 байт сессии
/// из заголовка `p`. Аккаунт один, поэтому [putKey] заменяет все прежние ключи
/// (после перелогина пуши старой сессии не расшифровываются).
///
/// Доступность — `AfterFirstUnlockThisDeviceOnly`: пуши приходят и на
/// заблокированный телефон, а NSE должен их расшифровать; в бэкапы/на другое
/// устройство ключи не уезжают.
///
/// Файл входит в оба target'а (Runner и NotificationService).
enum PushKeychain {
  private static let service = "net.iperon.messenger.push"
  private static let keyPrefix = "key_"
  private static let passcodeAccount = "passcode_enabled"
  private static let sharedGroupSuffix = "net.iperon.messenger.shared"

  /// `<TeamID>.net.iperon.messenger.shared`. Префикс команды берём из Info.plist
  /// (`AppIdentifierPrefix = $(AppIdentifierPrefix)`) — так код не зависит от
  /// Team ID (смена аккаунта разработчика ничего не ломает).
  private static var accessGroup: String? {
    guard let prefix = Bundle.main.object(forInfoDictionaryKey: "AppIdentifierPrefix") as? String,
          !prefix.isEmpty
    else { return nil }
    return prefix + sharedGroupSuffix
  }

  private static func baseQuery() -> [String: Any] {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
    ]
    if let group = accessGroup {
      query[kSecAttrAccessGroup as String] = group
    }
    return query
  }

  // MARK: - Ключи пушей

  static func putKey(keyId: Data, key: Data) {
    clearKeys()
    write(account: keyPrefix + hex(keyId), value: key)
  }

  static func key(forId keyId: Data) -> Data? {
    read(account: keyPrefix + hex(keyId))
  }

  static func clearKeys() {
    for account in accounts() where account.hasPrefix(keyPrefix) {
      delete(account: account)
    }
  }

  // MARK: - Код-пароль

  /// Включён код-пароль — уведомления показываются без имени и текста (аналог
  /// Telegram updateDeviceLocked, только на клиенте).
  static func setPasscodeEnabled(_ enabled: Bool) {
    if enabled {
      write(account: passcodeAccount, value: Data([1]))
    } else {
      delete(account: passcodeAccount)
    }
  }

  static var isPasscodeEnabled: Bool {
    read(account: passcodeAccount) != nil
  }

  // MARK: - Keychain

  private static func write(account: String, value: Data) {
    delete(account: account)
    var query = baseQuery()
    query[kSecAttrAccount as String] = account
    query[kSecValueData as String] = value
    query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
    let status = SecItemAdd(query as CFDictionary, nil)
    if status != errSecSuccess {
      NSLog("IperonPush keychain add failed: \(status)")
    }
  }

  private static func read(account: String) -> Data? {
    var query = baseQuery()
    query[kSecAttrAccount as String] = account
    query[kSecReturnData as String] = true
    query[kSecMatchLimit as String] = kSecMatchLimitOne
    var item: CFTypeRef?
    guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess else { return nil }
    return item as? Data
  }

  private static func delete(account: String) {
    var query = baseQuery()
    query[kSecAttrAccount as String] = account
    SecItemDelete(query as CFDictionary)
  }

  private static func accounts() -> [String] {
    var query = baseQuery()
    query[kSecReturnAttributes as String] = true
    query[kSecMatchLimit as String] = kSecMatchLimitAll
    var items: CFTypeRef?
    guard SecItemCopyMatching(query as CFDictionary, &items) == errSecSuccess,
          let list = items as? [[String: Any]]
    else { return [] }
    return list.compactMap { $0[kSecAttrAccount as String] as? String }
  }

  static func hex(_ data: Data) -> String {
    data.map { String(format: "%02x", $0) }.joined()
  }
}
