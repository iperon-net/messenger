package net.iperon.messenger

import android.content.Context
import android.os.Build
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Откуда установлено приложение — для обновления через тот же канал
 * (lib/components/app_update/app_update_common.dart, docs/plans/app-updates.md §3).
 * Канал `net.iperon.messenger/app_update`, тот же протокол, что у iOS
 * (AppDelegate.swift, AppUpdateBridge):
 *  - `installSource` → {installer (пакет установщика или null), abis (Build.SUPPORTED_ABIS)}.
 */
class AppInstallSource(private val context: Context, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "net.iperon.messenger/app_update")

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "installSource" -> result.success(mapOf("installer" to installer(), "abis" to Build.SUPPORTED_ABIS.toList()))
                else -> result.notImplemented()
            }
        }
    }

    /** Пакет установщика: com.android.vending — Play, ru.vk.store — RuStore, иначе — APK. */
    private fun installer(): String? =
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                context.packageManager.getInstallSourceInfo(context.packageName).installingPackageName
            } else {
                @Suppress("DEPRECATION")
                context.packageManager.getInstallerPackageName(context.packageName)
            }
        } catch (_: Exception) {
            null
        }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }
}
