package net.iperon.messenger

import android.content.Context
import android.media.AudioDeviceCallback
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.telecom.CallAudioState
import android.util.Log
import com.hiennv.flutter_callkit_incoming.CallkitConnection
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/**
 * Свой выбор аудио-выхода звонка на Android поверх
 * [AudioManager.getAvailableCommunicationDevices] / [AudioManager.setCommunicationDevice]
 * (API 31+). Отдаёт Flutter список доступных устройств, применяет выбор и шлёт
 * обновления при подключении/отключении устройств.
 *
 * ВАЖНО (осознанный компромисс, см. lib/audio_routes.dart): маршрутом в норме
 * владеет audioswitch LiveKit — он держит автоматический выбор по
 * preferredDeviceList и пересчитывает лучший маршрут на hot-plug/активацию. Наш
 * ручной [setCommunicationDevice] перебивает его до следующего такого пересчёта.
 * Встроенный ДИНАМИК Dart сюда НЕ шлёт — он идёт через LiveKit
 * `setSpeakerOutputPreferred(force)` (его штатный путь), иначе наш вызов гонялся с
 * audioswitch и динамик «не включался». Сюда приходят только не-динамик выходы
 * (разговорный/BT/проводная), и Dart уже снял предпочтение динамика в LiveKit
 * перед вызовом, чтобы последним словом остался наш setCommunicationDevice.
 *
 * Каналы:
 *  - method `net.iperon.messenger/audio_devices`: `list` → List<Map>, `select {id}`.
 *  - event  `net.iperon.messenger/audio_devices_events`: List<Map> при изменениях.
 */
class AudioDevicesHandler(
    private val context: Context,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    private val mainHandler = Handler(Looper.getMainLooper())

    private val methodChannel = MethodChannel(messenger, METHOD_CHANNEL).also { it.setMethodCallHandler(this) }
    private val eventChannel = EventChannel(messenger, EVENT_CHANNEL).also { it.setStreamHandler(this) }

    private var eventSink: EventChannel.EventSink? = null

    private val deviceCallback = object : AudioDeviceCallback() {
        override fun onAudioDevicesAdded(addedDevices: Array<out AudioDeviceInfo>?) = emitDevices()
        override fun onAudioDevicesRemoved(removedDevices: Array<out AudioDeviceInfo>?) = emitDevices()
    }

    // Слушатель СМЕНЫ активного коммуникационного устройства (API 31+). Нужен,
    // потому что маршрут «разговорный↔динамик» меняет audioswitch LiveKit через
    // setCommunicationDevice, а не наш select — [deviceCallback] на это не
    // реагирует (он только про подключение/отключение). Без него иконка/подпись
    // кнопки «Вывод звука» не обновлялись бы при переключении.
    private val commDeviceListener =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            AudioManager.OnCommunicationDeviceChangedListener { emitDevices() }
        } else {
            null
        }

    fun dispose() {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        audioManager.unregisterAudioDeviceCallback(deviceCallback)
        unregisterCommDeviceListener()
        CallkitConnection.audioRouteListener = null
        eventSink = null
    }

    // --- MethodChannel ---

    override fun onMethodCall(call: io.flutter.plugin.common.MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "list" -> result.success(devicesPayload())
            "select" -> {
                val id = call.argument<String>("id")
                if (id == null) {
                    result.error("bad_args", "id is required", null)
                    return
                }
                selectDevice(id)
                result.success(null)
            }
            // Смена маршрута через Telecom, если звонок ведётся как self-managed
            // Telecom-соединение (flutter_callkit_incoming): тогда маршрутом владеет
            // система, и наш setCommunicationDevice она перебивает — переключать
            // надо через Connection.setAudioRoute. Возвращаем true, если звонок в
            // Telecom (обработано); false — вызывающая Dart-сторона сделает fallback
            // на LiveKit/setCommunicationDevice (звонок без CallKit).
            "setTelecomRoute" -> {
                val type = call.argument<String>("type")
                result.success(setTelecomRoute(type))
            }
            else -> result.notImplemented()
        }
    }

    // --- EventChannel ---

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        audioManager.registerAudioDeviceCallback(deviceCallback, mainHandler)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && commDeviceListener != null) {
            audioManager.addOnCommunicationDeviceChangedListener({ it.run() }, commDeviceListener)
        }
        // Смена маршрута во время CallKit-звонка идёт через Telecom (не через
        // communicationDevice), поэтому активный выход и его смену берём из
        // Telecom onCallAudioStateChanged — иначе иконка кнопки не обновлялась бы.
        CallkitConnection.audioRouteListener = { emitDevices() }
        // Начальный снимок сразу после подписки.
        emitDevices()
    }

    override fun onCancel(arguments: Any?) {
        audioManager.unregisterAudioDeviceCallback(deviceCallback)
        unregisterCommDeviceListener()
        CallkitConnection.audioRouteListener = null
        eventSink = null
    }

    private fun unregisterCommDeviceListener() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && commDeviceListener != null) {
            audioManager.removeOnCommunicationDeviceChangedListener(commDeviceListener)
        }
    }

    // --- Реализация ---

    /**
     * Пробует сменить аудио-маршрут через активное self-managed Telecom-соединение
     * (см. [CallkitConnection.setAudioRouteForActive]). Возвращает true, если
     * звонок ведётся в Telecom и маршрут применён его средствами; false — активного
     * Telecom-звонка нет, и Dart должен сделать fallback (LiveKit/setCommunicationDevice).
     *
     * [type] — имя Dart-enum AudioRouteType. Маппится в [CallAudioState] ROUTE_*.
     */
    private fun setTelecomRoute(type: String?): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return false
        if (CallkitConnection.activeCount() == 0) return false
        val route = when (type) {
            "speaker" -> CallAudioState.ROUTE_SPEAKER
            "earpiece" -> CallAudioState.ROUTE_EARPIECE
            "bluetooth", "hearingAid" -> CallAudioState.ROUTE_BLUETOOTH
            "wiredHeadset" -> CallAudioState.ROUTE_WIRED_HEADSET
            else -> return false
        }
        val handled = CallkitConnection.setAudioRouteForActive(route)
        Log.i(TAG, "setTelecomRoute type=$type route=$route handled=$handled")
        // Активный маршрут сменится — переспросим снимок для UI.
        if (handled) emitDevices()
        return handled
    }

    private fun selectDevice(id: String) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return
        // Dart зовёт нас ТОЛЬКО для не-динамика (динамик идёт через LiveKit force,
        // см. lib/audio_routes.dart) и уже снял предпочтение динамика в LiveKit,
        // поэтому здесь просто ставим устройство — оно и остаётся последним словом.
        val device = availableCommunicationDevices().firstOrNull { it.id.toString() == id }
        if (device == null) {
            Log.w(TAG, "selectDevice: no device for id=$id")
            return
        }
        val ok = audioManager.setCommunicationDevice(device)
        Log.i(TAG, "selectDevice id=$id type=${device.type} setCommunicationDevice=$ok -> active=${activeDeviceId()}")
        emitDevices()
    }

    private fun availableCommunicationDevices(): List<AudioDeviceInfo> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return emptyList()
        return audioManager.availableCommunicationDevices
    }

    private fun activeDeviceId(): Int? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return null
        return audioManager.communicationDevice?.id
    }

    /**
     * Тип активного выхода во время CallKit-звонка — из маршрута Telecom
     * ([CallkitConnection.currentAudioRoute]), т.к. при self-managed звонке
     * `communicationDevice` маршрут не отражает. null — нет Telecom-звонка/маршрут
     * неизвестен, тогда активность считаем по communicationDevice (как раньше).
     */
    private fun telecomActiveType(): String? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return null
        if (CallkitConnection.activeCount() == 0) return null
        return when (CallkitConnection.currentAudioRoute) {
            CallAudioState.ROUTE_SPEAKER -> "speaker"
            CallAudioState.ROUTE_EARPIECE -> "earpiece"
            CallAudioState.ROUTE_BLUETOOTH -> "bluetooth"
            CallAudioState.ROUTE_WIRED_HEADSET -> "wiredHeadset"
            else -> null
        }
    }

    private fun devicesPayload(): List<Map<String, Any?>> {
        val activeId = activeDeviceId()
        // Во время CallKit-звонка активный выход берём из маршрута Telecom, иначе —
        // по communicationDevice.
        val telecomActive = telecomActiveType()
        // Одна запись на тип: система может отдавать несколько AudioDeviceInfo для
        // одного физического выхода (напр. IN/OUT), нам важен выход. Дедупим по
        // (type + productName), сохраняя первый.
        val seen = HashSet<String>()
        val result = ArrayList<Map<String, Any?>>()
        for (device in availableCommunicationDevices()) {
            val type = routeType(device.type) ?: continue
            val name = device.productName?.toString().orEmpty()
            val key = "$type|$name"
            if (!seen.add(key)) continue
            val active = if (telecomActive != null) type == telecomActive else (activeId != null && device.id == activeId)
            result.add(
                mapOf(
                    "id" to device.id.toString(),
                    "type" to type,
                    "productName" to name,
                    "active" to active,
                ),
            )
        }
        return result
    }

    /** Маппинг [AudioDeviceInfo] type → имя [AudioRouteType] на Dart-стороне. null = игнорируем. */
    private fun routeType(type: Int): String? = when (type) {
        AudioDeviceInfo.TYPE_BUILTIN_EARPIECE -> "earpiece"
        AudioDeviceInfo.TYPE_BUILTIN_SPEAKER -> "speaker"
        AudioDeviceInfo.TYPE_WIRED_HEADSET,
        AudioDeviceInfo.TYPE_WIRED_HEADPHONES,
        AudioDeviceInfo.TYPE_USB_HEADSET,
        AudioDeviceInfo.TYPE_USB_DEVICE,
        AudioDeviceInfo.TYPE_USB_ACCESSORY,
        -> "wiredHeadset"
        AudioDeviceInfo.TYPE_BLUETOOTH_SCO,
        AudioDeviceInfo.TYPE_BLE_HEADSET,
        AudioDeviceInfo.TYPE_BLE_SPEAKER,
        -> "bluetooth"
        AudioDeviceInfo.TYPE_HEARING_AID -> "hearingAid"
        else -> null
    }

    private fun emitDevices() {
        val payload = devicesPayload()
        mainHandler.post { eventSink?.success(payload) }
    }

    companion object {
        private const val METHOD_CHANNEL = "net.iperon.messenger/audio_devices"
        private const val EVENT_CHANNEL = "net.iperon.messenger/audio_devices_events"
        private const val TAG = "IperonAudioDevices"
    }
}
