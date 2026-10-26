import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/network_usage.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// «Данные и память»: миграция 51, привязка файлов кэша к чатам и давность,
// счётчики трафика, категории по MIME-типу.
void main() {
  late Directory dir;
  late SqliteDatabase db;
  late Downloads downloads;
  late DataUsageRepository usage;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('data_usage');
    db = SqliteDatabase(path: '${dir.path}/iperon.db');
    await Repositories.accountMigrations().migrate(db);
    downloads = Downloads(logger: Logger(), db: db);
    usage = DataUsageRepository(logger: Logger(), db: db);
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  models.DownloadState download(int id, {DateTime? createdAt}) => models.DownloadState(
    cdnID: Uint8List.fromList(List.filled(12, id)),
    url: 'https://cdn/$id',
    tmpPath: '/media/.part/$id.part',
    targetPath: null,
    encryptionKey: Uint8List(32),
    hkdfSalt: Uint8List(16),
    contentType: 'image/jpeg',
    hashSumEncrypted: Uint8List(32),
    cipherSize: null,
    receivedBytes: 0,
    status: models.DownloadStatus.downloading,
    createdAt: createdAt ?? DateTime.now(),
  );

  test('файл кэша помнит чат; привязанный не перепривязывается', () async {
    await downloads.create(download(1), chatID: 'aa');
    await downloads.create(download(2));
    await downloads.create(download(3));

    await downloads.setChatID(cdnID: download(1).cdnID, chatID: 'bb');
    await downloads.setChatID(cdnID: download(2).cdnID, chatID: 'cc');
    await downloads.setChatIDs({download(3).cdnID: '~'});
    // «Не из сообщений» ('~') потом всё же скачали из чата — привязываем.
    await downloads.setChatID(cdnID: download(3).cdnID, chatID: 'dd');

    final chats = {for (final row in await downloads.stored()) row.cdnID.first: row.chatID};
    expect(chats, {1: 'aa', 2: 'cc', 3: 'dd'});
  });

  test('давность: создание, готовность и открытие из кэша', () async {
    final old = DateTime.now().subtract(const Duration(days: 10));
    await downloads.create(download(1, createdAt: old));
    expect((await downloads.stored()).single.accessedAt.millisecondsSinceEpoch, old.millisecondsSinceEpoch);

    await downloads.touch(download(1).cdnID);
    final touched = (await downloads.stored()).single.accessedAt;
    expect(DateTime.now().difference(touched).inMinutes, 0);

    await downloads.markReady(cdnID: download(1).cdnID, targetPath: '/media/1.jpg');
    final row = (await downloads.stored()).single;
    expect(row.ready, isTrue);
    expect(row.hasChat, isFalse);
  });

  test('трафик копится по сети и категории, сброс обнуляет и двигает начало', () async {
    expect(await usage.setting(DataUsageRepository.networkSinceKey), isNull);
    const key = (models.NetworkKind.mobile, models.TrafficCategory.photos);
    await usage.addTraffic({key: const models.TrafficCounter(sent: 10, received: 100)});
    final since = await usage.setting(DataUsageRepository.networkSinceKey);
    expect(since, isNotNull);
    await usage.addTraffic({
      key: const models.TrafficCounter(sent: 5, received: 1),
      (models.NetworkKind.wifi, models.TrafficCategory.calls): const models.TrafficCounter(received: 7),
    });

    final traffic = await usage.traffic();
    expect(traffic[key]!.sent, 15);
    expect(traffic[key]!.received, 101);
    expect(traffic[(models.NetworkKind.wifi, models.TrafficCategory.calls)]!.total, 7);
    // Начало отсчёта ставит только первая запись.
    expect(await usage.setting(DataUsageRepository.networkSinceKey), since);

    final reset = DateTime.now().add(const Duration(minutes: 1));
    await usage.resetTraffic(reset);
    expect(await usage.traffic(), isEmpty);
    expect(await usage.setting(DataUsageRepository.networkSinceKey), reset.millisecondsSinceEpoch);
  });

  test('настройки кэша', () async {
    expect(await usage.setting(DataUsageRepository.keepMediaDaysKey), isNull);
    await usage.setSetting(DataUsageRepository.keepMediaDaysKey, 7);
    await usage.setSetting(DataUsageRepository.keepMediaDaysKey, 30);
    expect(await usage.setting(DataUsageRepository.keepMediaDaysKey), 30);
  });

  test('категории по MIME-типу', () {
    expect(storageCategoryFor('image/jpeg'), models.StorageCategory.photos);
    expect(storageCategoryFor('Video/MP4; codecs=avc1'), models.StorageCategory.videos);
    expect(storageCategoryFor('audio/ogg'), models.StorageCategory.audio);
    expect(storageCategoryFor('application/pdf'), models.StorageCategory.files);
    expect(trafficCategoryFor('image/png', fromChat: true), models.TrafficCategory.photos);
    expect(trafficCategoryFor('image/png', fromChat: false), models.TrafficCategory.other);
  });
}
