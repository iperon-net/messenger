package net.iperon.messenger

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInstaller
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

/**
 * Обновление приложения (lib/components/app_update/app_update_common.dart,
 * lib/app_update.dart, docs/plans/app-updates.md §3, §5). Канал
 * `net.iperon.messenger/app_update`, `installSource` — тот же протокол, что у iOS
 * (AppDelegate.swift, AppUpdateBridge):
 *  - `installSource` → {installer (пакет установщика или null), abis (Build.SUPPORTED_ABIS)};
 *  - `canInstall` → можно ли ставить APK («Установка неизвестных приложений» для Iperon);
 *  - `openInstallSettings` — экран этого разрешения;
 *  - `install` {path} — APK через PackageInstaller: системное окно «Обновить приложение?».
 *    Ответ — когда установка не удалась или её отменили: {status, message}
 *    (PackageInstaller.STATUS_*); при успехе процесс завершает система, ответа нет.
 */
class AppUpdate(private val context: Context, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "net.iperon.messenger/app_update")
    private val io = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "installSource" -> result.success(mapOf("installer" to installer(), "abis" to Build.SUPPORTED_ABIS.toList()))
                "canInstall" -> result.success(canInstall())
                "openInstallSettings" -> {
                    openInstallSettings()
                    result.success(null)
                }
                "install" -> {
                    val path = call.argument<String>("path")
                    if (path == null) {
                        result.error("bad_args", "path is required", null)
                    } else {
                        install(File(path), result)
                    }
                }
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

    private fun canInstall(): Boolean =
        Build.VERSION.SDK_INT < Build.VERSION_CODES.O || context.packageManager.canRequestPackageInstalls()

    private fun openInstallSettings() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, Uri.parse("package:${context.packageName}"))
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    /** APK пишется в сессию в фоне (~70 МБ), коммит — с ответом в [AppUpdateInstallReceiver]. */
    private fun install(apk: File, result: MethodChannel.Result) {
        io.execute {
            try {
                val installer = context.packageManager.packageInstaller
                val params = PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL)
                params.setAppPackageName(context.packageName)
                params.setSize(apk.length())
                val sessionId = installer.createSession(params)
                installer.openSession(sessionId).use { session ->
                    apk.inputStream().use { input ->
                        session.openWrite("base.apk", 0, apk.length()).use { output ->
                            input.copyTo(output)
                            session.fsync(output)
                        }
                    }
                    AppUpdateInstallReceiver.pending[sessionId] = { status, message ->
                        main.post { result.success(mapOf("status" to status, "message" to message)) }
                    }
                    val intent = Intent(context, AppUpdateInstallReceiver::class.java)
                    // Mutable: установщик дописывает в интент статус и окно подтверждения.
                    val flags = PendingIntent.FLAG_UPDATE_CURRENT or
                        (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_MUTABLE else 0)
                    session.commit(PendingIntent.getBroadcast(context, sessionId, intent, flags).intentSender)
                }
            } catch (e: Exception) {
                main.post { result.error("install_failed", e.message, null) }
            }
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        io.shutdown()
    }
}

/**
 * Статусы сессии PackageInstaller: «нужно подтверждение» — показываем системное
 * окно, остальное (кроме успеха — тогда процесс завершает система) — ответ в Dart.
 */
class AppUpdateInstallReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val sessionId = intent.getIntExtra(PackageInstaller.EXTRA_SESSION_ID, -1)
        val status = intent.getIntExtra(PackageInstaller.EXTRA_STATUS, PackageInstaller.STATUS_FAILURE)
        if (status == PackageInstaller.STATUS_PENDING_USER_ACTION) {
            val confirm = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                intent.getParcelableExtra(Intent.EXTRA_INTENT, Intent::class.java)
            } else {
                @Suppress("DEPRECATION")
                intent.getParcelableExtra(Intent.EXTRA_INTENT)
            }
            confirm?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)?.let(context::startActivity)
            return
        }
        pending.remove(sessionId)?.invoke(status, intent.getStringExtra(PackageInstaller.EXTRA_STATUS_MESSAGE))
    }

    companion object {
        /** Ждущие ответа вызовы `install` по sessionId. */
        val pending = java.util.concurrent.ConcurrentHashMap<Int, (Int, String?) -> Unit>()
    }
}
