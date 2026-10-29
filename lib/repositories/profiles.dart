part of 'repositories.dart';

/// Локальный кэш публичных профилей чужих пользователей (таблица `profiles`).
/// Заполняется из стрима (`MessageType.PROFILE`, см. `API._handleMessage`) и
/// читается экраном профиля для мгновенного показа без сети.
class Profiles {
  final Logger logger;
  final SqliteDatabase db;

  Profiles({required this.logger, required this.db});

  final _avatarChanges = StreamController<Uint8List>.broadcast();

  /// userID, у которого сменился (или снят) аватар — для живого обновления
  /// уже построенных [UserAvatar] (вкладки держатся в памяти, строки не
  /// пересоздаются).
  Stream<Uint8List> get avatarChanges => _avatarChanges.stream;

  Future<models.Profile> getByUserID({required List<int> userID}) async {
    final rows = await db.execute(
      "SELECT userID, username, fistName, lastName, birthDate, hideBirthYear, aboutMe, phoneNumber, avatarCdnID, avatarThumbhash, lastSeenAt, accountBlocked FROM profiles WHERE userID = ?;",
      [userID],
    );
    if (rows.isEmpty) return models.Profile();
    return models.ProfileMapper.fromMap(rows.first);
  }

  /// userID закэшированного профиля по имени (без учёта регистра); `null` —
  /// такого в кэше нет.
  Future<Uint8List?> userIDByUsername(String username) async {
    final rows = await db.execute("SELECT userID FROM profiles WHERE lower(username) = ? LIMIT 1;", [username.toLowerCase()]);
    return rows.isEmpty ? null : Uint8List.fromList(rows.first["userID"] as List<int>);
  }

  /// Профили набора userID одним запросом (список чатов) — карта
  /// `userID(hex) -> Profile` только по тем, кто есть в кэше.
  Future<Map<String, models.Profile>> getByUserIDs({required List<List<int>> userIDs, required String Function(List<int>) toHex}) async {
    if (userIDs.isEmpty) return {};
    final placeholders = List.filled(userIDs.length, '?').join(',');
    final rows = await db.execute(
      "SELECT userID, username, fistName, lastName, birthDate, hideBirthYear, aboutMe, phoneNumber, avatarCdnID, avatarThumbhash, lastSeenAt, accountBlocked FROM profiles WHERE userID IN ($placeholders);",
      userIDs,
    );
    return {for (final row in rows) toHex(row["userID"] as List<int>): models.ProfileMapper.fromMap(row)};
  }

  /// Кэш last-seen по набору userID для мгновенного показа на cold-start (батч,
  /// один запрос). Возвращает карту `userID(hex) -> DateTime` только по тем, у
  /// кого дата известна. [toHex] — Utils.bytesToHex (ключ, совместимый с кубитом).
  Future<Map<String, DateTime>> getLastSeenByUserIDs({required List<List<int>> userIDs, required String Function(List<int>) toHex}) async {
    if (userIDs.isEmpty) return {};
    final placeholders = List.filled(userIDs.length, '?').join(',');
    final rows = await db.execute(
      "SELECT userID, lastSeenAt FROM profiles WHERE lastSeenAt IS NOT NULL AND userID IN ($placeholders);",
      userIDs,
    );
    final result = <String, DateTime>{};
    for (final row in rows) {
      final id = row["userID"] as List<int>?;
      final ms = row["lastSeenAt"] as int?;
      if (id == null || ms == null) continue;
      result[toHex(id)] = DateTime.fromMillisecondsSinceEpoch(ms);
    }
    return result;
  }

  /// Пишет last-seen пользователя (epoch-millis) — upsert по userID. Обновления
  /// присутствия приходят из ContactsCubit при получении PRESENCE.
  Future<void> updateLastSeen({required List<int> userID, required DateTime lastSeen}) async {
    await db.execute(
      """
      INSERT INTO profiles (userID, lastSeenAt)
      VALUES(?, ?)
      ON CONFLICT(userID) DO UPDATE SET
        lastSeenAt = excluded.lastSeenAt;
      """,
      [userID, lastSeen.millisecondsSinceEpoch],
    );
  }

  /// Upsert всех текстовых полей профиля разом (кроме аватара — он привязывается
  /// отдельно через [updateAvatarByCdnID], т.к. может приходить/скачиваться
  /// независимо). Ключ конфликта — `userID`.
  Future<void> upsert({
    required List<int> userID,
    String username = "",
    String fistName = "",
    String lastName = "",
    DateTime? birthDate,
    bool hideBirthYear = false,
    String aboutMe = "",
    String phoneNumber = "",
    bool accountBlocked = false,
  }) async {
    await db.execute(
      """
      INSERT INTO profiles (userID, username, fistName, lastName, birthDate, hideBirthYear, aboutMe, phoneNumber, accountBlocked)
      VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(userID) DO UPDATE SET
        username = excluded.username,
        fistName = excluded.fistName,
        lastName = excluded.lastName,
        birthDate = excluded.birthDate,
        hideBirthYear = excluded.hideBirthYear,
        aboutMe = excluded.aboutMe,
        phoneNumber = excluded.phoneNumber,
        accountBlocked = excluded.accountBlocked;
      """,
      [
        userID,
        username,
        fistName,
        lastName,
        birthDate?.millisecondsSinceEpoch,
        hideBirthYear ? 1 : 0,
        aboutMe,
        phoneNumber,
        accountBlocked ? 1 : 0,
      ],
    );
  }

  /// Привязывает скачанный на CDN аватар к профилю: пишет [cdnID] в колонку
  /// `avatarCdnID`. Строка `downloads` с этим `cdnID` к этому моменту уже создана
  /// (`CDNManager.download`), поэтому внешний ключ соблюдён. Upsert — на случай,
  /// если строки профиля для [userID] ещё нет.
  Future<void> updateAvatarByCdnID({required List<int> userID, required List<int> cdnID}) async {
    await db.execute(
      """
      INSERT INTO profiles (userID, avatarCdnID)
      VALUES(?, ?)
      ON CONFLICT(userID) DO UPDATE SET
        avatarCdnID = excluded.avatarCdnID;
      """,
      [userID, cdnID],
    );
    _avatarChanges.add(Uint8List.fromList(userID));
  }

  /// ThumbHash аватара из PROFILE — пишется сразу, до скачивания картинки
  /// (пустой — аватара нет). Сменился — событие [avatarChanges]: строки
  /// [UserAvatar] покажут размытое превью, пока файл качается.
  Future<void> setAvatarThumbhash({required List<int> userID, required String thumbhash}) async {
    final rows = await db.execute(
      """
      INSERT INTO profiles (userID, avatarThumbhash)
      VALUES(?, ?)
      ON CONFLICT(userID) DO UPDATE SET
        avatarThumbhash = excluded.avatarThumbhash
      WHERE profiles.avatarThumbhash IS NOT excluded.avatarThumbhash
      RETURNING userID;
      """,
      [userID, thumbhash],
    );
    if (rows.isNotEmpty) _avatarChanges.add(Uint8List.fromList(userID));
  }

  /// Привязанные аватары, которые уже скачаны (строка `downloads` в статусе
  /// ready): их уменьшенные копии натив показывает в уведомлениях
  /// (`PushManager._syncAvatars`).
  Future<List<({Uint8List userID, Uint8List cdnID})>> readyAvatars() async {
    final rows = await db.execute(
      "SELECT p.userID, p.avatarCdnID FROM profiles p JOIN downloads d ON d.cdnID = p.avatarCdnID WHERE d.status = ?;",
      [models.DownloadStatus.ready.name],
    );
    return [
      for (final row in rows)
        (userID: Uint8List.fromList(row["userID"] as List<int>), cdnID: Uint8List.fromList(row["avatarCdnID"] as List<int>)),
    ];
  }

  /// Аватар снят (в ответе PROFILE его нет) — отвязываем, чтобы не показывать
  /// прежний. Событие — только если что-то было привязано.
  Future<void> clearAvatar({required List<int> userID}) async {
    final rows = await db.execute("UPDATE profiles SET avatarCdnID = NULL WHERE userID = ? AND avatarCdnID IS NOT NULL RETURNING userID;", [
      userID,
    ]);
    if (rows.isNotEmpty) _avatarChanges.add(Uint8List.fromList(userID));
  }
}
