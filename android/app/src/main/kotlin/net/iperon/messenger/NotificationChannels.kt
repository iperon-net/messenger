package net.iperon.messenger

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context

/// Каналы уведомлений приложения (кроме звонковых — их создаёт плагин
/// flutter_callkit_incoming). См. docs/plans/push-notifications.md, этап 1.
///
/// Id каналов с версией: после создания Android не даёт приложению менять
/// важность/звук канала (это решает пользователь), поэтому смена поведения =
/// новый id (`messages_v2`) + удаление старого.
///
/// [ensure] идемпотентен (`createNotificationChannel` с существующим id лишь
/// обновляет имя/описание) — зовём из `MainActivity.onCreate` и перед показом
/// уведомления из FCM-сервиса: процесс мог стартовать только ради пуша, ни разу
/// не открыв Activity.
object NotificationChannels {
    const val MESSAGES = "messages_v1"
    const val GROUPS = "groups_v1"
    const val OTHER = "other_v1"

    fun ensure(context: Context) {
        val manager = context.getSystemService(NotificationManager::class.java) ?: return
        manager.createNotificationChannels(
            listOf(
                NotificationChannel(
                    MESSAGES,
                    context.getString(R.string.notification_channel_messages),
                    NotificationManager.IMPORTANCE_HIGH,
                ),
                NotificationChannel(
                    GROUPS,
                    context.getString(R.string.notification_channel_groups),
                    NotificationManager.IMPORTANCE_HIGH,
                ),
                NotificationChannel(
                    OTHER,
                    context.getString(R.string.notification_channel_other),
                    NotificationManager.IMPORTANCE_DEFAULT,
                ).apply {
                    description = context.getString(R.string.notification_channel_other_description)
                },
            ),
        )
    }
}
