part of 'repositories.dart';

/// Одна запись снимка контактов. [userID] задан только для зарегистрированных в
/// Iperon; у остальных — `null`. [isCloud] — облачный контакт (синхронизируемый
/// между устройствами; источник истины — сервер), для него хранится [oprf] —
/// отпечаток номера, по которому сопоставляется входящее удаление
/// (`CONTACTS_UPDATED.removedOprf`) после холодного старта.
class ContactCacheEntry {
  final String phoneE164;
  final String displayName;
  final String phone;
  final List<int>? userID;
  final bool isCloud;
  final List<int>? oprf;

  const ContactCacheEntry({
    required this.phoneE164,
    required this.displayName,
    required this.phone,
    this.userID,
    this.isCloud = false,
    this.oprf,
  });
}

/// Локальный снимок экрана контактов (таблица `contacts`). Держит две группы,
/// различаемые `isCloud`:
///   • книжные (isCloud=0) — полный снимок последнего OPRF-прохода по телефонной
///     книге (и совпадения, и записи для приглашения), источник истины — книга;
///   • облачные (isCloud=1) — синхронизируемые между устройствами контакты,
///     источник истины — сервер (`CONTACTS_LIST` / `CONTACTS_UPDATED`).
/// Нужен, чтобы при повторном открытии экрана мгновенно показать оба списка ещё
/// до чтения книги, OPRF-запроса и ответа сервера. Наполняется из [ContactsCubit].
class Contacts {
  final Logger logger;
  final SqliteDatabase db;

  Contacts({required this.logger, required this.db});

  /// Весь снимок (книжные + облачные).
  Future<List<ContactCacheEntry>> getAll() async {
    final rows = await db.execute("SELECT phoneE164, displayName, phone, userID, isCloud, oprf FROM contacts;");
    return rows
        .map(
          (row) => ContactCacheEntry(
            phoneE164: row["phoneE164"] as String,
            displayName: row["displayName"] as String,
            phone: row["phone"] as String,
            userID: row["userID"] as List<int>?,
            isCloud: (row["isCloud"] as int? ?? 0) != 0,
            oprf: row["oprf"] as List<int>?,
          ),
        )
        .toList(growable: false);
  }

  /// Запись контакта с этим [userID] (имя/номер; облачная главнее книжной) —
  /// для журнала звонков, когда профиль ещё не попал в кэш, и для профиля
  /// пользователя («в контактах ли»). `null`, если такого нет.
  Future<ContactCacheEntry?> getByUserID(List<int> userID) async {
    final rows = await db.execute(
      "SELECT phoneE164, displayName, phone, userID, isCloud, oprf FROM contacts WHERE userID = ? ORDER BY isCloud DESC LIMIT 1;",
      [userID],
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    return ContactCacheEntry(
      phoneE164: row["phoneE164"] as String,
      displayName: row["displayName"] as String,
      phone: row["phone"] as String,
      userID: row["userID"] as List<int>?,
      isCloud: (row["isCloud"] as int? ?? 0) != 0,
      oprf: row["oprf"] as List<int>?,
    );
  }

  /// Имена «как я его записал» по userID (hex через [toHex]) — для общего
  /// правила имени (`Utils.composeDisplayName`): облачный контакт главнее
  /// книжного; без имени (в `displayName` подставлен номер) — не имя, такого
  /// userID в карте нет. [userIDs] пустой — все.
  Future<Map<String, String>> namesByUserID({required String Function(List<int>) toHex, List<List<int>>? userIDs}) async {
    final ids = userIDs ?? const [];
    final filter = ids.isEmpty ? '' : ' AND userID IN (${List.filled(ids.length, '?').join(',')})';
    final rows = await db.execute(
      "SELECT userID, displayName, phone FROM contacts WHERE userID IS NOT NULL$filter ORDER BY isCloud DESC;",
      ids,
    );
    final names = <String, String>{};
    for (final row in rows) {
      final name = (row["displayName"] as String).trim();
      if (name.isEmpty || name == row["phone"] as String) continue;
      names.putIfAbsent(toHex(row["userID"] as List<int>), () => name);
    }
    return names;
  }

  /// Номер контакта по userID — запасной, когда профиля ещё нет в кэше.
  Future<String?> phoneByUserID(List<int> userID) async {
    final rows = await db.execute("SELECT phone FROM contacts WHERE userID = ? ORDER BY isCloud DESC LIMIT 1;", [userID]);
    return rows.isEmpty ? null : rows.first["phone"] as String;
  }

  /// Полностью заменяет книжную часть снимка (isCloud=0) свежим OPRF-проходом.
  /// Облачные строки не трогаем; `OR IGNORE` не даёт книжной записи затереть
  /// облачную с тем же номером (облачная в показе главнее).
  Future<void> replaceBook(List<ContactCacheEntry> entries) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.writeTransaction((tx) async {
      await tx.execute("DELETE FROM contacts WHERE isCloud = 0;");
      for (final entry in entries) {
        await tx.execute(
          "INSERT OR IGNORE INTO contacts (phoneE164, displayName, phone, userID, isCloud, oprf, updatedAt) VALUES (?, ?, ?, ?, 0, NULL, ?);",
          [entry.phoneE164, entry.displayName, entry.phone, entry.userID, now],
        );
      }
    });
  }

  /// Полностью заменяет облачную часть снимка (isCloud=1) ответом `CONTACTS_LIST`.
  Future<void> replaceCloud(List<ContactCacheEntry> entries) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.writeTransaction((tx) async {
      await tx.execute("DELETE FROM contacts WHERE isCloud = 1;");
      for (final entry in entries) {
        await tx.execute(
          "INSERT OR REPLACE INTO contacts (phoneE164, displayName, phone, userID, isCloud, oprf, updatedAt) VALUES (?, ?, ?, ?, 1, ?, ?);",
          [entry.phoneE164, entry.displayName, entry.phone, entry.userID, entry.oprf, now],
        );
      }
    });
  }

  /// Добавляет/обновляет один облачный контакт (дельта `CONTACTS_UPDATED` или
  /// оптимистичное добавление). `OR REPLACE` перекрывает и книжную строку.
  Future<void> upsertCloudOne(ContactCacheEntry entry) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.execute(
      "INSERT OR REPLACE INTO contacts (phoneE164, displayName, phone, userID, isCloud, oprf, updatedAt) VALUES (?, ?, ?, ?, 1, ?, ?);",
      [entry.phoneE164, entry.displayName, entry.phone, entry.userID, entry.oprf, now],
    );
  }

  /// Удаляет один облачный контакт из снимка по e164.
  Future<void> removeCloudOne(String phoneE164) async {
    await db.execute("DELETE FROM contacts WHERE phoneE164 = ? AND isCloud = 1;", [phoneE164]);
  }

  /// Восстанавливает/обновляет одну книжную строку (isCloud=0) — например, когда
  /// снятый из облака контакт всё ещё есть в телефонной книге и должен вернуться
  /// в книжный список. `OR REPLACE` перекрывает строку любого типа с тем же
  /// номером (облачную книжной делать безопасно: облачную снимает вызывающий).
  Future<void> upsertBookOne(ContactCacheEntry entry) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.execute(
      "INSERT OR REPLACE INTO contacts (phoneE164, displayName, phone, userID, isCloud, oprf, updatedAt) VALUES (?, ?, ?, ?, 0, NULL, ?);",
      [entry.phoneE164, entry.displayName, entry.phone, entry.userID, now],
    );
  }
}
