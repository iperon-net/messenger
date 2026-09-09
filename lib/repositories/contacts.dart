part of 'repositories.dart';

/// Одна запись кэша: зарегистрированный в Iperon контакт из телефонной книги.
class ContactMatch {
  final String phoneE164;
  final List<int> userID;

  const ContactMatch({required this.phoneE164, required this.userID});
}

/// Локальный кэш результатов приватного поиска контактов (таблица `contacts`).
/// Хранит только совпадения (номер книги ↔ зарегистрированный userID), чтобы при
/// повторном открытии экрана мгновенно показать «В Iperon» до завершения нового
/// OPRF-запроса. Наполняется из [ContactsCubit] после раунда Match.
class Contacts {
  final Logger logger;
  final SqliteDatabase db;

  Contacts({required this.logger, required this.db});

  /// Все закэшированные совпадения.
  Future<List<ContactMatch>> getRegistered() async {
    final rows = await db.execute("SELECT phoneE164, userID FROM contacts;");
    return rows
        .map((row) => ContactMatch(phoneE164: row["phoneE164"] as String, userID: row["userID"] as List<int>))
        .toList(growable: false);
  }

  /// Полностью заменяет кэш свежим набором совпадений (результат последнего
  /// поиска — источник истины: номер мог перестать быть зарегистрированным).
  Future<void> replaceAll(List<ContactMatch> matches) async {
    await db.writeTransaction((tx) async {
      await tx.execute("DELETE FROM contacts;");
      for (final match in matches) {
        await tx.execute("INSERT OR REPLACE INTO contacts (phoneE164, userID, updatedAt) VALUES (?, ?, ?);", [
          match.phoneE164,
          match.userID,
          DateTime.now().millisecondsSinceEpoch,
        ]);
      }
    });
  }
}
