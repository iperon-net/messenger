import CryptoKit
import Foundation

/// Расшифровка поля `p` push-уведомления (см. protos/push_payload_v1.proto и
/// серверный internal/crypto/push.go):
///
///     header = version(1) || session[0:8] || nonce(12)
///     p      = base64(header || AES-256-GCM(pushKey, nonce, plaintext, aad = header))
///
/// pushKey = HKDF-SHA256(sharedKey, sharedSalt, "iperon-push-v1") выводит Dart и
/// кладёт в [PushKeychain] по keyID (первые 8 байт сессии), поэтому здесь только
/// AES-GCM. Проверяется на общих векторах test/fixtures/push_vectors.json (как
/// PushCrypto.kt на Android).
enum PushCrypto {
  static let version: UInt8 = 1
  static let keyIdLength = 8
  static let nonceLength = 12
  static let tagLength = 16
  static let headerSize = 1 + keyIdLength + nonceLength

  enum Failure: Error {
    case base64
    case header
    case decrypt(Error)
  }

  /// Расшифровывает [payload]. [keyLookup] по keyID возвращает ключ или nil —
  /// тогда результат nil (ключа нет: разлогин/чужая сессия). Битый формат или
  /// неверный ключ/подпись — [Failure].
  static func open(_ payload: String, keyLookup: (Data) -> Data?) throws -> Data? {
    guard let raw = Data(base64Encoded: payload) else { throw Failure.base64 }
    let bytes = [UInt8](raw)
    guard bytes.count >= headerSize + tagLength, bytes[0] == version else { throw Failure.header }

    let keyId = Data(bytes[1 ..< 1 + keyIdLength])
    guard let key = keyLookup(keyId) else { return nil }

    do {
      let box = try AES.GCM.SealedBox(
        nonce: AES.GCM.Nonce(data: Data(bytes[1 + keyIdLength ..< headerSize])),
        ciphertext: Data(bytes[headerSize ..< bytes.count - tagLength]),
        tag: Data(bytes[(bytes.count - tagLength)...])
      )
      return try AES.GCM.open(box, using: SymmetricKey(data: key), authenticating: Data(bytes[0 ..< headerSize]))
    } catch {
      throw Failure.decrypt(error)
    }
  }
}
