import Foundation
import Security

/// Общее хранилище приложения и Notification Service Extension: ключ расшифровки
/// push-уведомлений, флаг «включён код-пароль» и локально скрытые профили. NSE — отдельный процесс без
/// Flutter и без доступа к зашифрованной SQLCipher-базе, поэтому всё нужное ему
/// лежит в Keychain с общей access group `<TeamID>.net.iperon.messenger.shared`
/// (`keychain-access-groups` в entitlements обоих target'ов). Аналог
/// PushKeyStore.kt на Android.
///
/// Ключ пушей (HKDF от sharedKey сессии) выводит Dart (`PushManager`) и отдаёт
/// по каналу `net.iperon.messenger/push`; ищется по keyID — первые 8 байт сессии
/// из заголовка `p`. Аккаунтов несколько (docs/plans/multi-account.md, этап
/// 3.3): ключ хранится вместе с аккаунтом (accountID слота) — по нему пуш
/// знает, чей он; новый ключ аккаунта заменяет только его прежние.
///
/// Доступность — `AfterFirstUnlockThisDeviceOnly`: пуши приходят и на
/// заблокированный телефон, а NSE должен их расшифровать; в бэкапы/на другое
/// устройство ключи не уезжают.
///
/// Файл входит в оба target'а (Runner и NotificationService).
enum PushKeychain {
  private static let service = "net.iperon.messenger.push"
  private static let keyPrefix = "key_"
  // keyID → accountID и accountID → имя (подпись, когда аккаунтов несколько).
  private static let accountPrefix = "acct_"
  private static let namePrefix = "name_"
  private static let passcodeAccount = "passcode_enabled"
  private static let hiddenUsersAccount = "hidden_users"
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

  static func putKey(keyId: Data, key: Data, account: String, accountName: String) {
    removeKeys(account: account)
    let id = hex(keyId)
    write(account: keyPrefix + id, value: key)
    write(account: accountPrefix + id, value: Data(account.utf8))
    write(account: namePrefix + account, value: Data(accountName.utf8))
  }

  static func key(forId keyId: Data) -> Data? {
    read(account: keyPrefix + hex(keyId))
  }

  /// Аккаунт ключа [keyId] (пусто — ключ из сборки до мультиаккаунта).
  static func account(forId keyId: Data) -> String {
    read(account: accountPrefix + hex(keyId)).map { String(decoding: $0, as: UTF8.self) } ?? ""
  }

  /// Подпись аккаунта для уведомления — только когда аккаунтов с ключами
  /// больше одного.
  static func accountLabel(_ account: String) -> String? {
    guard !account.isEmpty else { return nil }
    let owners = Set(accounts().filter { $0.hasPrefix(accountPrefix) }.compactMap { read(account: $0) })
    guard owners.count > 1, let name = read(account: namePrefix + account) else { return nil }
    let label = String(decoding: name, as: UTF8.self)
    return label.isEmpty ? nil : label
  }

  /// Аккаунт ушёл с устройства: его ключи, имя и скрытые профили.
  static func removeAccount(_ account: String) {
    removeKeys(account: account)
    delete(account: namePrefix + account)
    delete(account: hiddenUsersAccount + "_" + account)
  }

  /// Ключи аккаунта [account] и ключи из сборки до мультиаккаунта (без
  /// аккаунта — той же, перевыпускаемой, сессии).
  private static func removeKeys(account: String) {
    let all = accounts()
    for item in all where item.hasPrefix(accountPrefix) {
      guard let owner = read(account: item), String(decoding: owner, as: UTF8.self) == account else { continue }
      let id = String(item.dropFirst(accountPrefix.count))
      delete(account: item)
      delete(account: keyPrefix + id)
    }
    for item in all where item.hasPrefix(keyPrefix) {
      let id = String(item.dropFirst(keyPrefix.count))
      if !all.contains(accountPrefix + id) { delete(account: item) }
    }
  }

  static func clearKeys() {
    for account in accounts() where account.hasPrefix(keyPrefix) || account.hasPrefix(accountPrefix) || account.hasPrefix(namePrefix) {
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

  // MARK: - Скрытые профили

  /// hex(userID) локально скрытых профилей («Скрыть профиль», HiddenProfiles в
  /// Dart): их уведомления — без имени и текста, как при код-пароле.
  static func setHiddenUsers(_ users: [String], account: String) {
    let item = hiddenUsersAccount + "_" + account
    if users.isEmpty {
      delete(account: item)
    } else {
      write(account: item, value: Data(users.map { $0.lowercased() }.joined(separator: ",").utf8))
    }
  }

  static func isHiddenUser(_ userID: Data, account: String) -> Bool {
    guard !userID.isEmpty,
          let data = read(account: hiddenUsersAccount + "_" + account),
          let list = String(data: data, encoding: .utf8)
    else { return false }
    return list.split(separator: ",").contains(Substring(hex(userID)))
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

/// Непрочитанные каждого аккаунта для бейджа на иконке (этап 3.4
/// мультиаккаунта): сервер шлёт число своего пользователя (`aps.badge`,
/// `PushPayload.badge`), а на иконке — сумма по аккаунтам. Последнее число
/// аккаунта хранится в общих UserDefaults App Group — их видят приложение и
/// NSE.
enum PushBadges {
  private static let appGroup = "group.net.iperon.messenger"
  private static let key = "push_badges"

  private static var defaults: UserDefaults? { UserDefaults(suiteName: appGroup) }

  /// Запомнить [count] аккаунта [account]; вернуть сумму по всем.
  @discardableResult
  static func set(_ count: Int, account: String) -> Int {
    var badges = all()
    if account.isEmpty {
      // Пуш из сборки до мультиаккаунта — число одного (единственного) аккаунта.
      return max(count, 0)
    }
    badges[account] = max(count, 0)
    defaults?.set(badges, forKey: key)
    return badges.values.reduce(0, +)
  }

  /// Аккаунт ушёл с устройства; вернуть сумму по оставшимся.
  @discardableResult
  static func remove(account: String) -> Int {
    var badges = all()
    badges.removeValue(forKey: account)
    defaults?.set(badges, forKey: key)
    return badges.values.reduce(0, +)
  }

  /// Последние непрочитанные каждого аккаунта (список аккаунтов в Dart).
  static func all() -> [String: Int] {
    (defaults?.dictionary(forKey: key) as? [String: Int]) ?? [:]
  }
}
