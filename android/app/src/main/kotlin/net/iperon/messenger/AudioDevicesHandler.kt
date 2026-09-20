package net.iperon.messenger

import android.content.Context
import android.media.AudioDeviceCallback
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.os.Build
import android.os.Handler
import android.os.Looper
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
 * Чтобы они не «спорили», предпочтение динамика в LiveKit подравнивает Dart-
 * сторона (`AudioManager.setSpeakerOutputPreferred`) ПЕРЕД вызовом [select] — см.
 * lib/audio_routes.dart, чтобы последним словом остался наш setCommunicationDevice.
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

    fun dispose() {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        audioManager.unregisterAudioDeviceCallback(deviceCallback)
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
            else -> result.notImplemented()
        }
    }

    // --- EventChannel ---

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        audioManager.registerAudioDeviceCallback(deviceCallback, mainHandler)
        // Начальный снимок сразу после подписки.
        emitDevices()
    }

    override fun onCancel(arguments: Any?) {
        audioManager.unregisterAudioDeviceCallback(deviceCallback)
        eventSink = null
    }

    // --- Реализация ---

    private fun selectDevice(id: String) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return
        val device = availableCommunicationDevices().firstOrNull { it.id.toString() == id } ?: return
        // Предпочтение динамика в LiveKit Dart уже подравнял ПЕРЕД этим вызовом
        // (см. lib/audio_routes.dart), поэтому здесь просто ставим устройство —
        // оно и остаётся последним словом.
        audioManager.setCommunicationDevice(device)
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

    private fun devicesPayload(): List<Map<String, Any?>> {
        val activeId = activeDeviceId()
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
            result.add(
                mapOf(
                    "id" to device.id.toString(),
                    "type" to type,
                    "productName" to name,
                    "active" to (activeId != null && device.id == activeId),
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
    }
}
