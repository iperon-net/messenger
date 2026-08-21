part of 'repositories.dart';

class Cache {
  final Logger logger;
  final SqliteDatabase db;

  Cache({required this.logger, required this.db});

  /// Кладёт значение в кэш. Если задан [ttl], запись живёт не дольше него: в
  /// колонку `ttl` пишется абсолютная метка истечения (мс эпохи); `0` — бессрочно.
  /// Протухшую запись отсекает [get] на чтении.
  Future<void> set({required Uint8List userID, required String key, required Uint8List value, Duration? ttl}) async {
    final expiresAt = ttl == null ? 0 : DateTime.now().millisecondsSinceEpoch + ttl.inMilliseconds;
    await db.execute("DELETE FROM cache WHERE userID = ? AND key = ?;", [userID, key]);
    await db.execute("INSERT INTO cache (key, value, ttl, userID) VALUES (?, ?, ?, ?);", [key, value, expiresAt, userID]);
    logger.info("set cache key=$key");
  }

  Future<Uint8List?> get({required Uint8List userID, required String key}) async {
    final res = await db.getAll("SELECT value, ttl FROM cache WHERE userID = ? AND key = ? LIMIT 1;", [userID, key]);
    if (res.isEmpty) return null;

    // ttl == 0 — бессрочно; иначе это метка истечения. Протухшую запись удаляем
    // лениво (на первом чтении после истечения) и отдаём null.
    final ttl = res.first["ttl"] as int;
    if (ttl != 0 && DateTime.now().millisecondsSinceEpoch >= ttl) {
      await delete(userID: userID, key: key);
      return null;
    }

    return res.first["value"] as Uint8List;
  }

  /// Кладёт целое (например, метку времени в мс) в кэш, кодируя его строкой в
  /// BLOB `value`. Читается парным [getInt].
  Future<void> setInt({required Uint8List userID, required String key, required int value, Duration? ttl}) async {
    await set(userID: userID, key: key, value: Uint8List.fromList(utf8.encode(value.toString())), ttl: ttl);
  }

  /// Возвращает ранее сохранённое [setInt] целое или null, если ключа нет или
  /// значение не парсится.
  Future<int?> getInt({required Uint8List userID, required String key}) async {
    final value = await get(userID: userID, key: key);
    if (value == null) return null;
    return int.tryParse(utf8.decode(value));
  }

  /// Кладёт строку в кэш, кодируя её в BLOB `value`. Читается парным [getString].
  Future<void> setString({required Uint8List userID, required String key, required String value, Duration? ttl}) async {
    await set(userID: userID, key: key, value: Uint8List.fromList(utf8.encode(value)), ttl: ttl);
  }

  /// Возвращает ранее сохранённую [setString] строку или null, если ключа нет.
  Future<String?> getString({required Uint8List userID, required String key}) async {
    final value = await get(userID: userID, key: key);
    if (value == null) return null;
    return utf8.decode(value);
  }

  /// Кладёт булево в кэш (как "1"/"0"). Читается парным [getBool].
  Future<void> setBool({required Uint8List userID, required String key, required bool value, Duration? ttl}) async {
    await setString(userID: userID, key: key, value: value ? "1" : "0", ttl: ttl);
  }

  /// Возвращает ранее сохранённое [setBool] булево или null, если ключа нет.
  Future<bool?> getBool({required Uint8List userID, required String key}) async {
    final value = await getString(userID: userID, key: key);
    if (value == null) return null;
    return value == "1";
  }

  /// Кладёт вещественное в кэш, кодируя его строкой в BLOB `value`. Читается
  /// парным [getDouble].
  Future<void> setDouble({required Uint8List userID, required String key, required double value, Duration? ttl}) async {
    await set(userID: userID, key: key, value: Uint8List.fromList(utf8.encode(value.toString())), ttl: ttl);
  }

  /// Возвращает ранее сохранённое [setDouble] вещественное или null, если ключа
  /// нет или значение не парсится.
  Future<double?> getDouble({required Uint8List userID, required String key}) async {
    final value = await get(userID: userID, key: key);
    if (value == null) return null;
    return double.tryParse(utf8.decode(value));
  }

  /// Удаляет запись кэша по ключу.
  Future<void> delete({required Uint8List userID, required String key}) async {
    await db.execute("DELETE FROM cache WHERE userID = ? AND key = ?;", [userID, key]);
    logger.info("delete cache key=$key");
  }
}
