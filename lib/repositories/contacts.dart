part of 'repositories.dart';

/// Одна запись кэша контактов — снимок нормализованной записи телефонной книги.
/// [userID] задан только для зарегистрированных в Iperon (найденных по OPRF);
/// у остальных — `null` (их можно пригласить).
class ContactCacheEntry {
  final String phoneE164;
  final String displayName;
  final String phone;
  final List<int>? userID;

  const ContactCacheEntry({required this.phoneE164, required this.displayName, required this.phone, this.userID});
}

/// Локальный кэш приватного поиска контактов (таблица `contacts`). Хранит полный
/// снимок последнего прохода по телефонной книге: и совпадения (номер книги ↔
/// зарегистрированный userID), и записи для приглашения (userID == null). Нужен,
/// чтобы при повторном открытии экрана мгновенно показать оба списка целиком —
/// ещё до чтения книги и нового OPRF-запроса. Наполняется из [ContactsCubit].
class Contacts {
  final Logger logger;
  final SqliteDatabase db;

  Contacts({required this.logger, required this.db});

  /// Весь закэшированный снимок книги (registered + invitable).
  Future<List<ContactCacheEntry>> getAll() async {
    final rows = await db.execute("SELECT phoneE164, displayName, phone, userID FROM contacts;");
    return rows
        .map(
          (row) => ContactCacheEntry(
            phoneE164: row["phoneE164"] as String,
            displayName: row["displayName"] as String,
            phone: row["phone"] as String,
            userID: row["userID"] as List<int>?,
          ),
        )
        .toList(growable: false);
  }

  /// Полностью заменяет кэш свежим снимком (последний проход — источник истины:
  /// контакты книги и статус регистрации могли измениться).
  Future<void> replaceAll(List<ContactCacheEntry> entries) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.writeTransaction((tx) async {
      await tx.execute("DELETE FROM contacts;");
      for (final entry in entries) {
        await tx.execute("INSERT OR REPLACE INTO contacts (phoneE164, displayName, phone, userID, updatedAt) VALUES (?, ?, ?, ?, ?);", [
          entry.phoneE164,
          entry.displayName,
          entry.phone,
          entry.userID,
          now,
        ]);
      }
    });
  }
}
