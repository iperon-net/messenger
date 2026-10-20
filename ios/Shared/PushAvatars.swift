import Foundation
import Intents
import UIKit

/// Аватары собеседников и групп для уведомлений (Communication Notifications:
/// аватар вместо иконки приложения, иконка — маленьким значком в углу). NSE сам
/// скачать их не может (файлы на CDN зашифрованы, ключи — в SQLCipher-базе),
/// поэтому приложение кладёт уже скачанные аватары уменьшенными копиями в общий
/// контейнер App Group `group.net.iperon.messenger` (`application-groups` в
/// entitlements обоих target'ов). Аналог PushAvatars.kt на Android.
///
/// Ключи — `u<hex userID>` (личный чат, звонок, реакция) и `c<hex chatID>`
/// (группа). Dart присылает полный снимок ([sync], `syncAvatars` в
/// PushBridge): новые и сменившиеся (другой cdnID) копируются, пропавшие
/// удаляются; что уже скопировано — помнит `manifest.json` (ключ → cdnID).
///
/// Файл входит в оба target'а (Runner и NotificationService).
enum PushAvatars {
  private static let appGroup = "group.net.iperon.messenger"
  private static let manifestName = "manifest.json"
  // Сторона квадрата копии в пикселях: в уведомлении аватар ~40pt.
  private static let side: CGFloat = 192
  private static let queue = DispatchQueue(label: "net.iperon.messenger.push-avatars", qos: .utility)

  private static var directory: URL? {
    FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)?
      .appendingPathComponent("Library/Caches/PushAvatars", isDirectory: true)
  }

  // MARK: - NSE

  static func user(_ userID: Data) -> Data? {
    userID.isEmpty ? nil : read("u" + PushKeychain.hex(userID))
  }

  static func chat(_ chatID: Data) -> Data? {
    chatID.isEmpty ? nil : read("c" + PushKeychain.hex(chatID))
  }

  private static func read(_ key: String) -> Data? {
    guard let url = directory?.appendingPathComponent(key + ".jpg") else { return nil }
    return try? Data(contentsOf: url)
  }

  /// groupIdentifier подаренного системе INInteraction личного чата (подсказки
  /// «Поделиться», Siri) — чтобы их можно было удалить ([forgetInteractions]).
  static func interactionGroup(user hex: String) -> String {
    "u" + hex.lowercased()
  }

  // MARK: - Приложение

  /// Снимок аватаров из Dart: `[{key, id (hex cdnID), path}]`. Работает в
  /// фоновой очереди — первый снимок может нести сотни картинок.
  static func sync(_ entries: [[String: String]]) {
    queue.async { apply(entries) }
  }

  private static func apply(_ entries: [[String: String]]) {
    guard let dir = directory else {
      NSLog("IperonPush: app group container unavailable, avatars skipped")
      return
    }
    let fm = FileManager.default
    try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
    let manifestURL = dir.appendingPathComponent(manifestName)
    var manifest = (try? Data(contentsOf: manifestURL))
      .flatMap { try? JSONSerialization.jsonObject(with: $0) as? [String: String] } ?? [:]

    var wanted = Set<String>()
    for entry in entries {
      guard let key = entry["key"], isValidKey(key), let id = entry["id"], let path = entry["path"] else { continue }
      wanted.insert(key)
      let target = dir.appendingPathComponent(key + ".jpg")
      if manifest[key] == id, fm.fileExists(atPath: target.path) { continue }
      guard let data = thumbnail(path) else { continue }
      do {
        try data.write(to: target, options: .atomic)
        manifest[key] = id
      } catch {
        NSLog("IperonPush: avatar write failed: \(error)")
      }
    }
    for key in manifest.keys where !wanted.contains(key) {
      try? fm.removeItem(at: dir.appendingPathComponent(key + ".jpg"))
      manifest.removeValue(forKey: key)
    }
    if let data = try? JSONSerialization.data(withJSONObject: manifest) {
      try? data.write(to: manifestURL, options: .atomic)
    }
  }

  /// Удаляет подаренные системе беседы: всех ([users] == nil — код-пароль,
  /// разлогин) или личные чаты со скрытыми профилями.
  static func forgetInteractions(users: [String]? = nil) {
    if let users {
      guard !users.isEmpty else { return }
      INInteraction.delete(with: users.map { interactionGroup(user: $0) }, completion: nil)
    } else {
      INInteraction.deleteAll(completion: nil)
    }
  }

  /// Ключ становится именем файла — только `u`/`c` + hex.
  private static func isValidKey(_ key: String) -> Bool {
    guard let first = key.first, first == "u" || first == "c", key.count > 1 else { return false }
    return key.dropFirst().allSatisfy { $0.isHexDigit }
  }

  /// Квадрат [side]×[side] по центру картинки, JPEG (круг рисует система).
  private static func thumbnail(_ path: String) -> Data? {
    guard let image = UIImage(contentsOfFile: path), image.size.width > 0, image.size.height > 0 else { return nil }
    let scale = side / min(image.size.width, image.size.height)
    let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    format.opaque = true
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: side, height: side), format: format)
    return renderer.jpegData(withCompressionQuality: 0.85) { _ in
      image.draw(in: CGRect(x: (side - size.width) / 2, y: (side - size.height) / 2, width: size.width, height: size.height))
    }
  }
}
