package net.iperon.messenger

import java.util.Base64
import javax.crypto.Cipher
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.SecretKeySpec

/// Расшифровка поля `p` push-уведомления (см. protos/push_payload_v1.proto и
/// серверный internal/crypto/push.go):
///
///     header = version(1) || session[0:8] || nonce(12)
///     p      = base64(header || AES-256-GCM(pushKey, nonce, plaintext, aad = header))
///
/// pushKey = HKDF-SHA256(sharedKey, sharedSalt, "iperon-push-v1") выводит Dart и
/// кладёт в [PushKeyStore] по keyID (первые 8 байт сессии), поэтому здесь только
/// AES-GCM. Чистый JVM-код (java.util.Base64, javax.crypto) — проверяется
/// unit-тестом на общих векторах test/fixtures/push_vectors.json.
object PushCrypto {
    const val VERSION: Byte = 1
    const val KEY_ID_LENGTH = 8
    private const val NONCE_LENGTH = 12
    private const val TAG_BITS = 128
    const val HEADER_SIZE = 1 + KEY_ID_LENGTH + NONCE_LENGTH

    class MalformedPayloadException(message: String, cause: Throwable? = null) : Exception(message, cause)

    /// Расшифровывает [payload]. [keyLookup] по keyID возвращает ключ или null —
    /// тогда результат null (ключа нет: разлогин/чужая сессия). Битый формат или
    /// неверный ключ/подпись — [MalformedPayloadException].
    fun open(payload: String, keyLookup: (ByteArray) -> ByteArray?): ByteArray? {
        val raw = try {
            Base64.getDecoder().decode(payload)
        } catch (error: IllegalArgumentException) {
            throw MalformedPayloadException("base64", error)
        }
        if (raw.size < HEADER_SIZE + TAG_BITS / 8 || raw[0] != VERSION) {
            throw MalformedPayloadException("header")
        }

        val keyId = raw.copyOfRange(1, 1 + KEY_ID_LENGTH)
        val key = keyLookup(keyId) ?: return null

        return try {
            val cipher = Cipher.getInstance("AES/GCM/NoPadding")
            cipher.init(
                Cipher.DECRYPT_MODE,
                SecretKeySpec(key, "AES"),
                GCMParameterSpec(TAG_BITS, raw, 1 + KEY_ID_LENGTH, NONCE_LENGTH),
            )
            cipher.updateAAD(raw, 0, HEADER_SIZE)
            cipher.doFinal(raw, HEADER_SIZE, raw.size - HEADER_SIZE)
        } catch (error: Exception) {
            throw MalformedPayloadException("decrypt", error)
        }
    }
}
