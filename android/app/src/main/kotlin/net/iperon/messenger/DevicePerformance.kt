package net.iperon.messenger

import android.app.ActivityManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.PowerManager
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Признаки производительности устройства для `DevicePerformance`
 * (lib/device_performance.dart). Канал `net.iperon.messenger/device_performance`,
 * тот же протокол, что у iOS (AppDelegate.swift, DevicePerformanceBridge):
 *  - `info` → {ram (байты), lowRam, cores, maxFreqKHz (0 — неизвестно), sdk,
 *    mediaClass (Build.VERSION.MEDIA_PERFORMANCE_CLASS, 0 — не заявлен),
 *    powerSave};
 *  - из натива: `powerSave` (bool) — включили / выключили экономию батареи.
 */
class DevicePerformance(private val context: Context, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "net.iperon.messenger/device_performance")
    private val power = context.getSystemService(Context.POWER_SERVICE) as PowerManager

    private val powerSaveReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            channel.invokeMethod("powerSave", power.isPowerSaveMode)
        }
    }

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "info" -> result.success(info())
                else -> result.notImplemented()
            }
        }
        // Системная рассылка — NOT_EXPORTED её не отсекает (флаг обязателен с Android 14).
        ContextCompat.registerReceiver(
            context,
            powerSaveReceiver,
            IntentFilter(PowerManager.ACTION_POWER_SAVE_MODE_CHANGED),
            ContextCompat.RECEIVER_NOT_EXPORTED,
        )
    }

    private fun info(): Map<String, Any> {
        val activity = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memory = ActivityManager.MemoryInfo().also { activity.getMemoryInfo(it) }
        val cores = Runtime.getRuntime().availableProcessors()
        return mapOf(
            "ram" to memory.totalMem,
            "lowRam" to activity.isLowRamDevice,
            "cores" to cores,
            "maxFreqKHz" to maxFrequencyKHz(cores),
            "sdk" to Build.VERSION.SDK_INT,
            "mediaClass" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) Build.VERSION.MEDIA_PERFORMANCE_CLASS else 0,
            "powerSave" to power.isPowerSaveMode,
        )
    }

    /** Наибольшая частота среди ядер (кГц); 0 — не прочитали. */
    private fun maxFrequencyKHz(cores: Int): Int {
        var max = 0
        for (i in 0 until cores) {
            val value = try {
                File("/sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_max_freq").readText().trim().toInt()
            } catch (_: Exception) {
                0
            }
            if (value > max) max = value
        }
        return max
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        try {
            context.unregisterReceiver(powerSaveReceiver)
        } catch (_: IllegalArgumentException) {
        }
    }
}
