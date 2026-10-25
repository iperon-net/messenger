package net.iperon.messenger

import android.content.Context

/// Непрочитанные каждого аккаунта (как `PushBadges` на iOS): последнее число
/// от сервера из пушей аккаунта (`PushPayload.badge`) или от Dart, пока он
/// активен. По нему список аккаунтов показывает счётчики неактивных — их
/// стримы закрыты, пуши приходят нативу. Число на иконке Android рисует сам
/// лаунчер по уведомлениям, здесь его не ставим.
object PushBadges {
    private const val PREFS = "iperon_push"
    private const val PREFIX = "badge_"

    fun set(context: Context, account: String, count: Int) {
        if (account.isEmpty()) return
        prefs(context).edit().putInt(PREFIX + account, maxOf(count, 0)).apply()
    }

    fun remove(context: Context, account: String) {
        prefs(context).edit().remove(PREFIX + account).apply()
    }

    fun clearAll(context: Context) {
        val prefs = prefs(context)
        val editor = prefs.edit()
        prefs.all.keys.filter { it.startsWith(PREFIX) }.forEach { editor.remove(it) }
        editor.apply()
    }

    fun all(context: Context): Map<String, Int> = prefs(context).all
        .filterKeys { it.startsWith(PREFIX) }
        .mapNotNull { (key, value) -> (value as? Int)?.let { key.removePrefix(PREFIX) to it } }
        .toMap()

    private fun prefs(context: Context) = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
}
