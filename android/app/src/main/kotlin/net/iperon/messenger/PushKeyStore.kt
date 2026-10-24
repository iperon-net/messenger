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
/// Аккаунтов на устройстве несколько (docs/plans/multi-account.md, этап 3.3):
/// ключ хранится на keyID вместе с аккаунтом (локальный `accountID` слота) — по
/// нему пуш знает, чей он (теги, скрытые профили, переход по тапу). Новый ключ
/// аккаунта заменяет его прежние (перелогин), ключи других аккаунтов не трогает.
///
/// Здесь же — флаг «включён код-пароль»: тогда уведомления показываются без
/// имени и текста (аналог Telegram updateDeviceLocked, только на клиенте), — и
/// hex(userID) локально скрытых профилей («Скрыть профиль»): их уведомления
/// показываются так же.
object PushKeyStore {
    private const val PREFS = "iperon_push"
    private const val KEY_PREFIX = "key_"
    // keyID → accountID: чей ключ.
    private const val ACCOUNT_PREFIX = "acct_"
    // accountID → имя аккаунта (подпись уведомления, когда аккаунтов несколько).
    private const val NAME_PREFIX = "name_"
    private const val PASSCODE_ENABLED = "passcode_enabled"
    private const val HIDDEN_USERS = "hidden_users"
    private const val KEYSTORE = "AndroidKeyStore"
    private const val WRAP_ALIAS = "iperon_push_wrap"
    private const val IV_LENGTH = 12
    private const val TAG_BITS = 128

    fun put(context: Context, keyId: ByteArray, key: ByteArray, account: String, accountName: String) {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, wrapKey())
        val wrapped = cipher.iv + cipher.doFinal(key)

        val prefs = prefs(context)
        val editor = prefs.edit()
        // Прежние ключи этого аккаунта (до перелогина) — больше не нужны.
        removeKeys(prefs, editor, account)
        val id = hex(keyId)
        editor.putString(KEY_PREFIX + id, Base64.encodeToString(wrapped, Base64.NO_WRAP))
        editor.putString(ACCOUNT_PREFIX + id, account)
        editor.putString(NAME_PREFIX + account, accountName)
        editor.apply()
    }

    /// Аккаунт ключа [keyId] (пусто — ключ из сборки до мультиаккаунта).
    fun accountOf(context: Context, keyId: ByteArray): String = prefs(context).getString(ACCOUNT_PREFIX + hex(keyId), null).orEmpty()

    /// Имя аккаунта [account] для подписи уведомления — только когда аккаунтов
    /// с ключами больше одного (иначе подпись не нужна): null.
    fun accountLabel(context: Context, account: String): String? {
        if (account.isEmpty()) return null
        val prefs = prefs(context)
        val accounts = prefs.all.filterKeys { it.startsWith(ACCOUNT_PREFIX) }.values.toSet()
        if (accounts.size < 2) return null
        return prefs.getString(NAME_PREFIX + account, null)?.takeIf { it.isNotEmpty() }
    }

    /// Аккаунт ушёл с устройства (выход): его ключи, имя и скрытые профили.
    fun removeAccount(context: Context, account: String) {
        val prefs = prefs(context)
        val editor = prefs.edit()
        removeKeys(prefs, editor, account)
        editor.remove(NAME_PREFIX + account)
        editor.remove("${HIDDEN_USERS}_$account")
        editor.apply()
    }

    private fun removeKeys(prefs: android.content.SharedPreferences, editor: android.content.SharedPreferences.Editor, account: String) {
        for ((name, value) in prefs.all) {
            if (!name.startsWith(ACCOUNT_PREFIX) || value != account) continue
            val id = name.removePrefix(ACCOUNT_PREFIX)
            editor.remove(name)
            editor.remove(KEY_PREFIX + id)
        }
        // Ключи из сборки до мультиаккаунта (без аккаунта) — тоже: они той же
        // сессии, что сейчас перевыпускается.
        for (name in prefs.all.keys) {
            if (name.startsWith(KEY_PREFIX) && !prefs.contains(ACCOUNT_PREFIX + name.removePrefix(KEY_PREFIX))) editor.remove(name)
        }
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
        prefs.all.keys.filter { it.startsWith(KEY_PREFIX) || it.startsWith(ACCOUNT_PREFIX) || it.startsWith(NAME_PREFIX) }.forEach { editor.remove(it) }
        editor.apply()
    }

    fun setPasscodeEnabled(context: Context, enabled: Boolean) {
        prefs(context).edit().putBoolean(PASSCODE_ENABLED, enabled).apply()
    }

    fun isPasscodeEnabled(context: Context): Boolean = prefs(context).getBoolean(PASSCODE_ENABLED, false)

    fun setHiddenUsers(context: Context, account: String, users: List<String>) {
        prefs(context).edit().putStringSet("${HIDDEN_USERS}_$account", users.map { it.lowercase() }.toSet()).apply()
    }

    fun isHiddenUser(context: Context, account: String, userID: ByteArray): Boolean =
        userID.isNotEmpty() && prefs(context).getStringSet("${HIDDEN_USERS}_$account", null)?.contains(hex(userID)) == true

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
