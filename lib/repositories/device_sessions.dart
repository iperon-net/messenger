part of 'repositories.dart';

class DeviceSessions {
  final Logger logger;
  final SqliteDatabase db;

  DeviceSessions({required this.logger, required this.db});

  Future<List<models.DeviceSessionsModel>> getAll() async {
    final res = await db.execute("SELECT * FROM deviceSessions");
    return res.map(models.DeviceSessionsModelMapper.fromMap).toList();
  }

  Future<void> deleteAndCreate({required List<models.DeviceSessionsModel> deviceSessionsModel, required List<int> userID}) async {
    await db.writeTransaction((txn) async {
      // Таблица зеркалит удалённые сессии ТЕКУЩЕГО пользователя. Чистим целиком,
      // а не WHERE userID = ?, иначе строки прошлых логинов (другие userID)
      // остаются навсегда и getAll() отдаёт их вперемешку со свежими.
      await txn.execute("DELETE FROM deviceSessions;");
      if (deviceSessionsModel.isEmpty) return;

      await txn.executeBatch(
        """
        INSERT INTO deviceSessions (sessionID, userID, deviceModel, os, osVersion, appVersion, appBuildNumber,
        locationRussian, locationEnglish, updateAt)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      """,
        [
          for (final item in deviceSessionsModel)
            [
              item.sessionID,
              userID,
              item.deviceModel,
              item.os,
              item.osVersion,
              item.appVersion,
              item.appBuildNumber,
              item.locationRussian,
              item.locationEnglish,
              item.updateAt.millisecondsSinceEpoch,
            ],
        ],
      );
    });
  }
}
