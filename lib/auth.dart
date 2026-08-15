import 'package:flutter/foundation.dart';

import 'api.dart';
import 'di.dart';
import 'logger.dart';
import 'models.dart';
import 'repositories.dart';

/// Источник правды об авторизации для роутера.
///
/// Активная сессия читается из БД один раз при старте и дальше держится
/// в памяти. `redirect` у go_router умеет быть асинхронным, но вызывается
/// на каждую навигацию — читать SQLite оттуда значило бы ходить в БД на
/// каждый переход и отдавать пустой кадр на холодном старте, пока Future
/// не разрешится.
///
/// Изменения (вход/выход) прокидываются в роутер через `refreshListenable`,
/// поэтому после [refresh] или [logout] go_router сам пересчитает маршрут.
class Auth extends ChangeNotifier {
  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();
  final api = getIt.get<API>();

  Session _session = Session();

  Session get session => _session;

  bool get isAuthorized => _session.sessionID.isNotEmpty;

  static Future<Auth> initialization() async {
    final auth = Auth();
    auth._session = await auth.repositories.sessions.getActive();
    await auth._syncStream();
    return auth;
  }

  Future<void> refresh() async {
    _session = await repositories.sessions.getActive();
    logger.logCustom(RepositoriesLog("session refreshed, isAuthorized = $isAuthorized"));
    await _syncStream();
    notifyListeners();
  }

  Future<void> logout() async {
    await repositories.sessions.deleteActive();
    _session = Session();
    await _syncStream();
    notifyListeners();
  }

  /// Сообщает API о состоянии авторизации. Реальное открытие/закрытие стрима
  /// решает координатор в [API] (с учётом переднего/фонового плана), поэтому
  /// метод безопасно вызывать на каждом изменении сессии.
  Future<void> _syncStream() async {
    api.setAuthorized(isAuthorized);
  }
}
