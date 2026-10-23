import 'dart:async';
import 'dart:typed_data';

import '../auth.dart';
import '../di.dart';
import '../logger.dart';
import '../repositories/repositories.dart';
import '../utils.dart';

/// Раскрытые спойлеры (фото, видео, текст): вышли из чата и вернулись,
/// пузырь пересоздан прокруткой или приложение перезапущено — раскрытое
/// остаётся раскрытым, а не прячется под пыль снова. Пузырь спрашивает
/// синхронно, поэтому набор держится в памяти, а в БД
/// ([SpoilerRevealsRepository]) пишется в фоне. Набор свой у каждого
/// аккаунта: сменилась сессия — перечитывается. Ключ — [key]; пустой — не
/// запоминать (превью, цитаты).
abstract final class SpoilerReveals {
  static final _revealed = <String>{};

  // Чей набор в памяти (hex userID); пусто — ещё не читали.
  static String _owner = '';
  static Future<void>? _loading;

  /// Ключ спойлера сообщения [chatID]/[messageID]; [part] — элемент альбома
  /// или участок текста.
  static String key(String chatID, String messageID, Object part) => '$chatID/$messageID/$part';

  static bool isRevealed(String key) {
    if (key.isEmpty) return false;
    _sync();
    return _revealed.contains(key);
  }

  static void reveal(String key) {
    if (key.isEmpty) return;
    _sync();
    if (!_revealed.add(key) || _owner.isEmpty) return;
    unawaited(
      getIt.get<Repositories>().spoilerReveals.add(key).catchError((Object error, StackTrace stackTrace) {
        getIt.get<Logger>().handle(error, stackTrace);
      }),
    );
  }

  /// Прочитать набор заранее (старт приложения), чтобы первый открытый чат
  /// уже знал, что раскрыто.
  static Future<void> preload() async {
    _sync();
    await _loading;
  }

  /// Набор в памяти — активного аккаунта; иначе перечитываем из БД. Без
  /// зависимостей (тесты виджетов) — только память.
  static void _sync() {
    if (!getIt.isRegistered<Auth>() || !getIt.isRegistered<Repositories>()) return;
    final userID = getIt.get<Auth>().session.userID;
    final owner = userID.isEmpty ? '' : getIt.get<Utils>().bytesToHex(Uint8List.fromList(userID));
    if (owner == _owner) return;
    _owner = owner;
    _revealed.clear();
    if (owner.isEmpty) return;
    _loading = () async {
      try {
        final keys = await getIt.get<Repositories>().spoilerReveals.all();
        if (_owner == owner) _revealed.addAll(keys);
      } catch (error, stackTrace) {
        getIt.get<Logger>().handle(error, stackTrace);
      }
    }();
  }
}
