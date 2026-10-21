part of 'repositories.dart';

/// Одна запись скрытого профиля: [userID] собеседника и [phraseHash] —
/// sha256(нормализованная код-фраза) в hex. Сама фраза нигде не хранится
/// (хеш необратим): чтобы снова показать профиль, пользователь вводит фразу
/// в поиске, а мы сверяем её хеш с этим полем.
class HiddenProfileEntry {
  final List<int> userID;
  final String phraseHash;

  const HiddenProfileEntry({required this.userID, required this.phraseHash});
}

/// Локально скрытые профили (таблица `hiddenProfiles`). Прячет собеседника из
/// списков Контактов/Звонков/Чатов на этом устройстве, а его пуши показываются
/// без имени и текста (набор уходит в натив — `PushManager.setHiddenUsers`).
/// Источник истины — только локальная БД; на сервер ничего не уходит.
/// Набор свой у каждого аккаунта (`ownerID`, миграция 42): все запросы — по
/// активной сессии ([_owner]), поэтому вызывающим владельца передавать не надо.
///
/// [changes] — широковещательный сигнал «набор скрытых изменился». Списки
/// (`ContactsCubit`/`CallsCubit`) живут в долгоживущем IndexedStack и не
/// пересоздаются, поэтому подписываются на него, чтобы перечитать набор после
/// того как пользователь скрыл/показал профиль на отдельном экране.
class HiddenProfiles {
  final Logger logger;
  final SqliteDatabase db;

  HiddenProfiles({required this.logger, required this.db});

  final _changes = StreamController<void>.broadcast();

  /// userID активного аккаунта — подзапросом, чтобы не тянуть `Auth` в слой БД.
  static const _owner = '(SELECT userID FROM sessions WHERE isActive = 1 LIMIT 1)';

  Stream<void> get changes => _changes.stream;

  /// Весь набор скрытых профилей.
  Future<List<HiddenProfileEntry>> getAll() async {
    final rows = await db.execute("SELECT userID, phraseHash FROM hiddenProfiles WHERE ownerID = $_owner;");
    return rows
        .map((row) => HiddenProfileEntry(userID: row["userID"] as List<int>, phraseHash: row["phraseHash"] as String))
        .toList(growable: false);
  }

  /// Набор в виде hex(userID) → sha256 код-фразы (hex) — как его держат
  /// состояния списков (сверка с `Chat.peerUserID` / `ChatMember.id`).
  Future<Map<String, String>> hashByHex() async => {
    for (final e in await getAll()) e.userID.map((b) => b.toRadixString(16).padLeft(2, '0')).join(): e.phraseHash,
  };

  /// Скрыт ли профиль с этим [userID].
  Future<bool> isHidden(List<int> userID) async {
    final rows = await db.execute("SELECT 1 FROM hiddenProfiles WHERE ownerID = $_owner AND userID = ? LIMIT 1;", [userID]);
    return rows.isNotEmpty;
  }

  /// Скрывает профиль (или обновляет код-фразу существующего). [phraseHash] —
  /// sha256 нормализованной фразы в hex (см. `Utils.passphraseHash`).
  Future<void> hide({required List<int> userID, required String phraseHash}) async {
    await db.execute("INSERT OR REPLACE INTO hiddenProfiles (ownerID, userID, phraseHash, createdAt) VALUES ($_owner, ?, ?, ?);", [
      userID,
      phraseHash,
      DateTime.now().millisecondsSinceEpoch,
    ]);
    _changes.add(null);
  }

  /// Снимает скрытие — профиль снова виден в списках. Идемпотентно (сброс
  /// разрешён, даже если профиль не был скрыт).
  Future<void> unhide(List<int> userID) async {
    await db.execute("DELETE FROM hiddenProfiles WHERE ownerID = $_owner AND userID = ?;", [userID]);
    _changes.add(null);
  }
}
