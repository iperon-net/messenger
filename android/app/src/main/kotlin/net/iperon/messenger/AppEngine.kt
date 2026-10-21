package net.iperon.messenger

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

/// Единственный на процесс [FlutterEngine] (см. описание [MainActivity]): его
/// поднимает Activity, а без неё — кнопки уведомлений
/// ([NotificationActionReceiver]: ответ и «прочитано» уходят из Dart). Второй
/// движок в процессе нельзя — два isolate'а с одним DI/БД/звонками.
///
/// Канал пушей ([PushChannel]) живёт на движке, а не на Activity: без неё Dart
/// тоже должен получать ключи/действия.
object AppEngine {
    /// Ключ движка в [FlutterEngineCache].
    const val ENGINE_ID = "net.iperon.messenger/main_engine"

    // Сериализует ленивое создание движка.
    private val lock = Any()

    /// Лениво создаёт движок и кладёт в кэш. `FlutterEngine(context)` сам
    /// авторегистрирует плагины (embedding v2), затем гоняем `main()`.
    /// Идемпотентно и потокобезопасно: под звонок Activity может подниматься
    /// гонкой (full-screen intent + «Ответить»), а два создания вернули бы нас к
    /// двум isolate'ам. Только с главного потока.
    fun ensure(context: Context): FlutterEngine {
        val cache = FlutterEngineCache.getInstance()
        synchronized(lock) {
            cache.get(ENGINE_ID)?.let { return it }
            val app = context.applicationContext
            val engine = FlutterEngine(app)
            PushChannel.attach(app, engine)
            engine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
            cache.put(ENGINE_ID, engine)
            return engine
        }
    }
}
