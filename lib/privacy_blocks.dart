import 'dart:async';

import 'package:flutter/foundation.dart';

import 'api.dart';
import 'auth.dart';
import 'di.dart';
import 'logger.dart';
import 'protobuf.dart';
import 'repositories.dart';
import 'utils.dart';

/// Заблокированные пользователи (как в Telegram): список — поле `blocked`
/// снимка `PrivacySettings` (кэш в SQLite, `privacySettings`; пишет
/// `API._handleMessage` — ответ и push с других устройств). Гейты — на сервере:
/// заблокированный не пишет и не звонит мне (и я ему, пока не разблокирую),
/// не видит моё «в сети», «О себе», день рождения и аватар.
abstract final class PrivacyBlocks {
  static Repositories get _repositories => getIt.get<Repositories>();

  /// Таблица кэша — подписка на изменения (`db.onChange`).
  static const table = 'privacySettings';

  /// Заблокированные (hex userID) из кэша — без сети, мгновенно. Кэша ещё нет
  /// (настройки ни разу не приходили) — пусто, [refresh] его принесёт.
  static Future<Set<String>> hexes() async {
    final utils = getIt.get<Utils>();
    return {for (final id in await list()) utils.bytesToHex(id)};
  }

  static Future<List<Uint8List>> list() async {
    final buffer = await _repositories.privacySettings.get(userID: getIt.get<Auth>().session.userID);
    if (buffer == null) return const [];
    try {
      return PrivacySettings_Response.fromBuffer(buffer).blocked.map(Uint8List.fromList).toList(growable: false);
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
      return const [];
    }
  }

  static Future<bool> isBlocked(List<int> userID) async => (await list()).any((id) => listEquals(id, userID));

  /// Изменился кэш (в т.ч. блокировки с другого устройства).
  static Stream<void> changes() => _repositories.db.onChange([table], triggerImmediately: false);

  /// Запросить свежий снимок настроек (ответ — в кэш через стрим). Без сети —
  /// ничего: остаёмся на кэше.
  static Future<void> refresh() async {
    if (!await getIt.get<Utils>().hasNetwork()) return;
    await getIt.get<API>().sendEncoded(MessageType.PRIVACY_SETTINGS, PrivacySettings_Request().writeToBuffer());
  }

  static bool _refreshed = false;

  /// [refresh] один раз за запуск (окно личного чата, профиль): дальше
  /// изменения приходят push'ем по стриму.
  static Future<void> refreshOnce() async {
    if (_refreshed || !await getIt.get<Utils>().hasNetwork()) return;
    _refreshed = true;
    await getIt.get<API>().sendEncoded(MessageType.PRIVACY_SETTINGS, PrivacySettings_Request().writeToBuffer());
  }

  /// Заблокировать / разблокировать. Серверная операция: без сети или при
  /// ошибке — `false` (вызывающий показывает «нет соединения»), без
  /// оптимистичного отката. Успех — сразу правим кэш (сервер затем разошлёт
  /// снимок на все устройства, и этот тоже).
  static Future<bool> setBlocked(List<int> userID, bool blocked) async {
    final logger = getIt.get<Logger>();
    if (!await getIt.get<Utils>().hasNetwork()) {
      logger.info('privacy: block update aborted, no network');
      return false;
    }
    final status = await getIt.get<API>().unaryEncoded(
      MessageType.PRIVACY_BLOCK_UPDATE,
      PrivacyBlockUpdate_Request(userId: userID, blocked: blocked).writeToBuffer(),
    );
    if (status.status != APIStatus.success) {
      logger.warning('privacy: block update failed (${status.error})');
      return false;
    }

    final me = getIt.get<Auth>().session.userID;
    final buffer = await _repositories.privacySettings.get(userID: me);
    if (buffer == null) {
      // Кэша нет — снимок целиком придёт push'ем; на всякий случай и запросом.
      unawaited(refresh());
      return true;
    }
    final settings = PrivacySettings_Response.fromBuffer(buffer);
    settings.blocked.removeWhere((id) => listEquals(id, userID));
    if (blocked) settings.blocked.add(userID);
    await _repositories.privacySettings.upsert(userID: me, payload: settings.writeToBuffer());
    return true;
  }
}
