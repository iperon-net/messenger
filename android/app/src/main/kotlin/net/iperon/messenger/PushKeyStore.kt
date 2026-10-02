package net.iperon.messenger

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/// Хранилище ключей расшифровки push-уведомлений для нативного FCM-сервиса,
/// который работает без Flutter-движка и не может читать зашифрованную
/// SQLCipher-базу. Ключ пушей (HKDF от sharedKey сессии, выводит Dart — см.
/// `PushManager`) лежит в SharedPreferences, обёрнутый AES-GCM ключом из Android
/// Keystore (неэкспортируемый, привязан к устройству). Ключ по keyID — первые 8
/// байт сессии из заголовка `p`.
///
/// Аккаунт сейчас один, поэтому [put] заменяет все прежние ключи (старая сессия
/// после перелогина пуши расшифровывать не должна). Под несколько аккаунтов —
/// хранить по ключу на keyID и чистить по сессиям.
///
/// Здесь же — флаг «включён код-пароль»: тогда уведомления показываются без
/// имени и текста (аналог Telegram updateDeviceLocked, только на клиенте).
object PushKeyStore {
    private const val PREFS = "iperon_push"
    private const val KEY_PREFIX = "key_"
    private const val PASSCODE_ENABLED = "passcode_enabled"
    private const val KEYSTORE = "AndroidKeyStore"
    private const val WRAP_ALIAS = "iperon_push_wrap"
    private const val IV_LENGTH = 12
    private const val TAG_BITS = 128

    fun put(context: Context, keyId: ByteArray, key: ByteArray) {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, wrapKey())
        val wrapped = cipher.iv + cipher.doFinal(key)

        val prefs = prefs(context)
        val editor = prefs.edit()
        prefs.all.keys.filter { it.startsWith(KEY_PREFIX) }.forEach { editor.remove(it) }
        editor.putString(KEY_PREFIX + hex(keyId), Base64.encodeToString(wrapped, Base64.NO_WRAP))
        editor.apply()
    }

    fun get(context: Context, keyId: ByteArray): ByteArray? {
        val stored = prefs(context).getString(KEY_PREFIX + hex(keyId), null) ?: return null
        val wrapped = Base64.decode(stored, Base64.NO_WRAP)
        if (wrapped.size <= IV_LENGTH) return null

        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.DECRYPT_MODE, wrapKey(), GCMParameterSpec(TAG_BITS, wrapped, 0, IV_LENGTH))
        return cipher.doFinal(wrapped, IV_LENGTH, wrapped.size - IV_LENGTH)
    }

    fun clear(context: Context) {
        val prefs = prefs(context)
        val editor = prefs.edit()
        prefs.all.keys.filter { it.startsWith(KEY_PREFIX) }.forEach { editor.remove(it) }
        editor.apply()
    }

    fun setPasscodeEnabled(context: Context, enabled: Boolean) {
        prefs(context).edit().putBoolean(PASSCODE_ENABLED, enabled).apply()
    }

    fun isPasscodeEnabled(context: Context): Boolean = prefs(context).getBoolean(PASSCODE_ENABLED, false)

    private fun prefs(context: Context) = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    @Synchronized
    private fun wrapKey(): SecretKey {
        val keyStore = KeyStore.getInstance(KEYSTORE).apply { load(null) }
        (keyStore.getKey(WRAP_ALIAS, null) as? SecretKey)?.let { return it }

        val generator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, KEYSTORE)
        generator.init(
            KeyGenParameterSpec.Builder(WRAP_ALIAS, KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT)
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build(),
        )
        return generator.generateKey()
    }

    private fun hex(bytes: ByteArray) = bytes.joinToString("") { "%02x".format(it) }
}
