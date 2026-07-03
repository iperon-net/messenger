part of 'repositories.dart';

class PendingLogouts {
  final Logger logger;
  final Database database;

  PendingLogouts({required this.logger, required this.database});

  Future<void> add({required List<int> encodedMessage}) async {
    database.execute(
      "INSERT INTO pendingLogouts (encodedMessage) VALUES (?);",
      [encodedMessage],
    );
  }

  Future<List<({int id, List<int> encodedMessage})>> getAll() async {
    final rows = database.select("SELECT id, encodedMessage FROM pendingLogouts;");
    return rows.map((r) => (id: r['id'] as int, encodedMessage: (r['encodedMessage'] as List).cast<int>())).toList();
  }

  Future<void> delete({required int id}) async {
    database.execute("DELETE FROM pendingLogouts WHERE id = ?;", [id]);
  }
}
