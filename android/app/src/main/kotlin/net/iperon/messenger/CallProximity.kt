package net.iperon.messenger

import android.content.Context
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.telecom.CallAudioState
import android.util.Log
import com.hiennv.flutter_callkit_incoming.CallkitConnection
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Датчик приближения на аудиозвонке: поднёс телефон к уху — экран гаснет (и не
 * нажимается щекой), отвёл — включается. Система сама этого для нашего экрана
 * звонка не делает, поэтому держим `PROXIMITY_SCREEN_OFF_WAKE_LOCK`.
 *
 * Dart (`lib/call_proximity.dart`) говорит только «звонок, где это нужно, идёт»
 * (`set {enabled}`); включён ли датчик на самом деле, решаем здесь по текущему
 * выходу звука: только разговорный динамик — на громкой связи, гарнитуре и BT
 * телефон у уха не держат. Выход меняют разные стороны (Telecom при CallKit,
 * audioswitch LiveKit, гарнитура), единого колбэка на всё нет, поэтому пока
 * звонок идёт, выход перепроверяется раз в [POLL_MS].
 *
 * Состояние — на процесс (object): движок переживает пересоздание Activity, а
 * Dart повторно `set` не шлёт.
 */
object CallProximity : MethodChannel.MethodCallHandler {
    private const val CHANNEL = "net.iperon.messenger/call_proximity"
    private const val TAG = "IperonCallProximity"
    private const val POLL_MS = 500L

    private val mainHandler = Handler(Looper.getMainLooper())
    private var channel: MethodChannel? = null
    private var audioManager: AudioManager? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private var wanted = false

    private val poll = object : Runnable {
        override fun run() {
            update()
            if (wanted) mainHandler.postDelayed(this, POLL_MS)
        }
    }

    fun attach(context: Context, messenger: BinaryMessenger) {
        val app = context.applicationContext
        audioManager = app.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        if (wakeLock == null) {
            val power = app.getSystemService(Context.POWER_SERVICE) as PowerManager
            if (power.isWakeLockLevelSupported(PowerManager.PROXIMITY_SCREEN_OFF_WAKE_LOCK)) {
                wakeLock = power.newWakeLock(PowerManager.PROXIMITY_SCREEN_OFF_WAKE_LOCK, "iperon:call-proximity").apply {
                    setReferenceCounted(false)
                }
            }
        }
        channel?.setMethodCallHandler(null)
        channel = MethodChannel(messenger, CHANNEL).also { it.setMethodCallHandler(this) }
    }

    override fun onMethodCall(call: io.flutter.plugin.common.MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "set" -> {
                setWanted(call.argument<Boolean>("enabled") == true)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun setWanted(enabled: Boolean) {
        if (wanted == enabled) return
        wanted = enabled
        mainHandler.removeCallbacks(poll)
        if (enabled) poll.run() else update()
    }

    private fun update() {
        val lock = wakeLock ?: return
        val on = wanted && onEarpiece()
        if (on && !lock.isHeld) {
            // Без тайм-аута: держим ровно пока звонок на разговорном динамике.
            @Suppress("WakelockTimeout")
            lock.acquire()
            Log.i(TAG, "proximity on")
        } else if (!on && lock.isHeld) {
            // Отвели от уха после отбоя — экран включится, когда датчик освободится.
            lock.release(PowerManager.RELEASE_FLAG_WAIT_FOR_NO_PROXIMITY)
            Log.i(TAG, "proximity off")
        }
    }

    /** Звук звонка идёт в разговорный динамик. */
    private fun onEarpiece(): Boolean {
        // CallKit-звонок (self-managed Telecom): маршрутом владеет система.
        if (CallkitConnection.activeCount() > 0 && CallkitConnection.currentAudioRoute != 0) {
            return CallkitConnection.currentAudioRoute == CallAudioState.ROUTE_EARPIECE
        }
        val audio = audioManager ?: return false
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            audio.communicationDevice?.let { return it.type == AudioDeviceInfo.TYPE_BUILTIN_EARPIECE }
        }
        @Suppress("DEPRECATION")
        return audio.mode == AudioManager.MODE_IN_COMMUNICATION &&
            !audio.isSpeakerphoneOn &&
            !audio.isBluetoothScoOn &&
            !audio.isWiredHeadsetOn
    }
}
