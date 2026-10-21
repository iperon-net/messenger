package net.iperon.messenger

import android.content.BroadcastReceiver
import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// Канал `net.iperon.messenger/push` (Dart — `PushManager`): ключи расшифровки,
/// флаг код-пароля, скрытые профили и аватары для нативного FCM-сервиса
/// ([PushKeyStore], [PushAvatars]); обратно — тапы по уведомлениям и их кнопки
/// ([NotificationActionReceiver]).
///
/// Привязан к движку ([AppEngine]), а не к Activity: кнопка уведомления
/// поднимает движок без Activity, и Dart всё равно должен получить действие.
/// Пока Dart не готов (холодный старт: `main()` не дошёл до
/// `PushManager.start`), тап и действия ждут здесь — Dart заберёт их вызовами
/// `takeInitialTap` / `takePendingActions`.
object PushChannel {
    private const val CHANNEL = "net.iperon.messenger/push"

    // Сколько держим процесс живым (goAsync) ради действия: система даёт
    // приёмнику ~10 с, дальше — ANR. Не успели — действие всё равно
    // доделывается, пока процесс жив (outbox в SQLite переживёт и убийство).
    private const val ACTION_TIMEOUT_MS = 9_000L

    private val main = Handler(Looper.getMainLooper())

    private var channel: MethodChannel? = null

    // Dart-сторона готова (вызвала takeInitialTap). Живёт на процесс, как и движок.
    private var dartReady = false

    // Тап холодного старта, ещё не забранный Dart.
    private var pendingTap: Map<String, Any>? = null

    // Действия кнопок, ещё не отданные в Dart.
    private val pendingActions = mutableListOf<Map<String, Any>>()

    // id действия → удержание процесса приёмником (снимаем по
    // notificationActionDone или таймауту).
    private val holds = mutableMapOf<String, BroadcastReceiver.PendingResult>()

    fun attach(context: Context, engine: FlutterEngine) {
        val app = context.applicationContext
        channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).also { it.setMethodCallHandler { call, result ->
            when (call.method) {
                // Ключ расшифровки пушей текущей сессии (Dart выводит HKDF).
                "setPushKey" -> {
                    val keyId = call.argument<ByteArray>("keyId")
                    val key = call.argument<ByteArray>("key")
                    if (keyId == null || key == null) {
                        result.error("args", "keyId and key are required", null)
                    } else {
                        PushKeyStore.put(app, keyId, key)
                        result.success(null)
                    }
                }
                "clearPushKeys" -> {
                    PushKeyStore.clear(app)
                    PushAvatars.clear(app)
                    MessagePushHandler.removeShortcuts(app)
                    result.success(null)
                }
                // Прочитано / удалено (обновление из стрима) — снять показанное.
                "clearChatNotifications" -> {
                    MessagePushHandler.clearChat(
                        app,
                        chatHex = call.argument<String>("chatID") ?: "",
                        maxID = call.argument<Number>("maxID")?.toLong() ?: 0,
                        messageIDs = call.argument<List<Number>>("messageIDs").orEmpty().map { it.toLong() }.toSet(),
                        all = call.argument<Boolean>("all") ?: false,
                    )
                    result.success(null)
                }
                "setPasscodeEnabled" -> {
                    val enabled = call.arguments as? Boolean ?: false
                    PushKeyStore.setPasscodeEnabled(app, enabled)
                    // В шорткатах бесед — имена и аватары.
                    if (enabled) MessagePushHandler.removeShortcuts(app)
                    result.success(null)
                }
                // Локально скрытые профили — их пуши без имени и текста.
                "setHiddenUsers" -> {
                    val users = (call.arguments as? List<*>).orEmpty().filterIsInstance<String>()
                    PushKeyStore.setHiddenUsers(app, users)
                    if (users.isNotEmpty()) MessagePushHandler.removeShortcuts(app, users.map { it.lowercase() }.toSet())
                    result.success(null)
                }
                // Снимок скачанных аватаров для уведомлений: [{key, id, path}].
                "syncAvatars" -> {
                    val entries = (call.arguments as? List<*>).orEmpty().mapNotNull { entry ->
                        (entry as? Map<*, *>)?.entries
                            ?.mapNotNull { (k, v) -> if (k is String && v is String) k to v else null }
                            ?.toMap()
                    }
                    PushAvatars.sync(app, entries)
                    result.success(null)
                }
                // Движок поднят без видимой Activity (кнопка уведомления) —
                // presence сессии «в фоне», сервер продолжает слать пуши.
                "isInBackground" -> result.success(!MainActivity.isForeground)
                // Dart готов принимать тапы; заодно забирает отложенный тап
                // холодного старта.
                "takeInitialTap" -> {
                    dartReady = true
                    result.success(pendingTap)
                    pendingTap = null
                }
                // Кнопки уведомлений, нажатые до готовности Dart.
                "takePendingActions" -> {
                    dartReady = true
                    result.success(pendingActions.toList())
                    pendingActions.clear()
                }
                // Dart доделал действие — процесс можно отпустить.
                "notificationActionDone" -> {
                    (call.arguments as? String)?.let { release(it) }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        } }
    }

    /// Отдаёт тап по уведомлению в Dart (или откладывает до готовности).
    fun deliverTap(tap: Map<String, Any>) {
        val channel = channel
        if (dartReady && channel != null) {
            channel.invokeMethod("onNotificationTap", tap)
        } else {
            pendingTap = tap
        }
    }

    /// Отдаёт кнопку уведомления в Dart (`action["id"]` — уникальный). [hold]
    /// держит процесс, пока Dart не ответит `notificationActionDone`. Только с
    /// главного потока.
    fun deliverAction(action: Map<String, Any>, hold: BroadcastReceiver.PendingResult?) {
        val id = action["id"] as String
        if (hold != null) {
            holds[id] = hold
            main.postDelayed({ release(id) }, ACTION_TIMEOUT_MS)
        }
        val channel = channel
        if (dartReady && channel != null) {
            channel.invokeMethod("onNotificationAction", action)
        } else {
            pendingActions += action
        }
    }

    private fun release(id: String) {
        holds.remove(id)?.finish()
    }
}
