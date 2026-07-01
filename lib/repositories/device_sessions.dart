part of 'repositories.dart';

class DeviceSessions {
  final Logger logger;
  final Database database;

  DeviceSessions({required this.logger, required this.database});

  Future<void> deleteAndCreate({required models.Session session, required List<models.DeviceSession> deviceSessions}) async {
    database.execute("BEGIN;");
    database.execute("DELETE FROM deviceSessions WHERE userID = ?;", [session.userID]);

    for (final deviceSession in deviceSessions) {
      database.execute(
          "INSERT INTO deviceSessions"
              "(userID, session, deviceModel, os, osVersion, appVersion, appBuildNumber, locationRussian, locationEnglish, updateAt)"
              "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",

          [
            session.userID,
            deviceSession.session,
            deviceSession.deviceModel,
            deviceSession.os,
            deviceSession.osVersion,
            deviceSession.appVersion,
            deviceSession.appBuildNumber,
            deviceSession.locationRussian,
            deviceSession.locationEnglish,
            deviceSession.updateAt.millisecondsSinceEpoch,
          ]
      );
    }

    database.select("COMMIT;");
  }

  Future<List<models.DeviceSession>> getAll({required models.Session session}) async {
    final sqlSessions = database.select(
        "SELECT userID, session, deviceModel, os, osVersion, appVersion, appBuildNumber, locationRussian,"
            " locationEnglish, updateAt FROM deviceSessions WHERE userID = ?;",
        [session.userID]
    );

    return sqlSessions.map((row) {
      final deviceSession = models.DeviceSessionMapper.fromMap(row);
      return deviceSession.copyWith(
        isCurrent: listEquals(deviceSession.session, session.session),
      );
    }).toList();
  }

}
