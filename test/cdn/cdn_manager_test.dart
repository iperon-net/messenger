import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:messenger/account_scope.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/cdn.dart';
import 'package:messenger/crypto.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf.dart' as pb;
import 'package:messenger/protobuf/protos/v1.pb.dart' show MessageType;
import 'package:messenger/protobuf/protos/v1.pbgrpc.dart' show IperonClient;
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/utils.dart';
import 'package:sqlite_async/sqlite_async.dart';

import '../support/fake_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final me = List<int>.filled(12, 1);
  final cdnID = List<int>.filled(12, 9);

  late Directory dir;
  late AccountScope scope;
  late SqliteDatabase db;
  late Downloads downloads;
  late Uploads uploads;
  late CdnFakeApi api;
  late FakeUploadClient uploadClient;
  late CDNManager manager;
  late FileEncryptor encryptor;
  late HttpServer server;
  late FutureOr<void> Function(HttpRequest request) handler;
  var scopeID = 0;

  setUp(() async {
    HttpOverrides.global = LoopbackHttpOverrides();
    dir = await Directory.systemTemp.createTemp('cdn_manager_test');
    scope = AccountScope('cdn-${scopeID++}')..files = (data: dir, cache: dir);
    AccountScope.activate(scope);
    db = SqliteDatabase(path: '${dir.path}/test.db');
    await db.execute('''
      CREATE TABLE downloads (
        cdnID BLOB PRIMARY KEY, url TEXT NOT NULL, tmpPath TEXT NOT NULL, targetPath TEXT NULL,
        encryptionKey BLOB NOT NULL, hkdfSalt BLOB NOT NULL, contentType TEXT NOT NULL,
        hashSumEncrypted BLOB NOT NULL, cipherSize INTEGER NULL, receivedBytes INTEGER NOT NULL DEFAULT 0,
        status TEXT NOT NULL, createdAt INTEGER NOT NULL, chatID TEXT NOT NULL DEFAULT '', accessedAt INTEGER NOT NULL DEFAULT 0
      );
    ''');
    await db.execute('''
      CREATE TABLE uploads (
        localID TEXT PRIMARY KEY, uploadID TEXT NULL, filePath TEXT NOT NULL, fileSize INTEGER NOT NULL,
        fileKey BLOB NOT NULL, hkdfSalt BLOB NOT NULL, folder TEXT NOT NULL,
        contentType TEXT NOT NULL, createdAt INTEGER NOT NULL
      );
    ''');
    final logger = Logger();
    downloads = Downloads(logger: logger, db: db);
    uploads = Uploads(logger: logger, db: db);
    uploadClient = FakeUploadClient();
    api = CdnFakeApi(uploadClient);
    encryptor = FileEncryptor(logger: logger);
    await getIt.reset();
    getIt.registerSingleton<Logger>(logger);
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Auth>(CdnAuth(models.Session(userID: me, session: me)));
    getIt.registerSingleton<Crypto>(CdnCrypto(encryptor));
    getIt.registerSingleton<Repositories>(CdnRepositories(downloads, uploads));
    getIt.registerSingleton<Utils>(CdnUtils());
    manager = CDNManager();
    handler = (request) async {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
    };
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async => await handler(request));
  });

  tearDown(() async {
    await server.close(force: true);
    await scope.dispose();
    await api.dispose();
    await getIt.reset();
    AccountScope.activate(AccountScope(''));
    await db.close();
    await dir.delete(recursive: true);
    HttpOverrides.global = null;
  });

  String url([String path = '/file']) => 'http://${server.address.address}:${server.port}$path';

  Future<({models.CDN cdn, Uint8List cipher, Uint8List plain, Uint8List key})> encrypted({String? fileURL}) async {
    final plain = Uint8List.fromList(List.generate(4096, (index) => index % 251));
    final key = Uint8List.fromList(encryptor.generateFileKey());
    final salt = Uint8List.fromList(encryptor.generateHkdfSalt());
    final source = File('${dir.path}/plain.bin');
    await source.writeAsBytes(plain);
    final cipherFile = File('${dir.path}/cipher.bin');
    final sink = cipherFile.openWrite();
    await for (final chunk in encryptor.encryptFile(file: source, fileKey: key, hkdfSalt: salt)) {
      sink.add(chunk);
    }
    await sink.close();
    final cipher = await cipherFile.readAsBytes();
    final hash = await Sha256().hash(cipher);
    return (
      cdn: models.CDN(
        cdnID: Uint8List.fromList(cdnID),
        url: fileURL ?? url(),
        hashSumEncrypted: Uint8List.fromList(hash.bytes),
        contentType: 'application/pdf',
        encryptionKey: key,
        hkdfSalt: salt,
        createAt: DateTime(2026),
      ),
      cipher: cipher,
      plain: plain,
      key: key,
    );
  }

  test('download дешифрует файл, а повтор и cachedFile работают из кэша без HTTP', () async {
    final data = await encrypted();
    var requests = 0;
    handler = (request) async {
      requests++;
      request.response.headers.contentType = ContentType.binary;
      request.response.add(data.cipher);
      await request.response.close();
    };
    final progress = <(int, int)>[];

    final file = await manager.download(cdn: data.cdn, chatID: 'chat-1', onProgress: (received, total) => progress.add((received, total)));

    expect(await file.readAsBytes(), data.plain);
    expect(file.path, endsWith('.pdf'));
    expect(progress.last, (data.cipher.length, data.cipher.length));
    expect(requests, 1);
    expect((await downloads.stored()).single.chatID, 'chat-1');

    final cached = await manager.cachedFile(data.cdn.cdnID);
    expect(cached?.path, file.path);
    expect((await manager.download(cdn: data.cdn)).path, file.path);
    expect(requests, 1);
  });

  test('несовпадение хеша фатально и не создаёт готовый plaintext', () async {
    final data = await encrypted();
    handler = (request) async {
      final damaged = Uint8List.fromList(data.cipher)..[10] ^= 1;
      request.response.add(damaged);
      await request.response.close();
    };

    await expectLater(manager.download(cdn: data.cdn), throwsA(isA<DownloadException>()));

    expect(await manager.cachedFile(data.cdn.cdnID), isNull);
    expect((await downloads.getByCdnID(data.cdn.cdnID))?.status, models.DownloadStatus.downloading);
    expect(Directory('${dir.path}/media').listSync().whereType<File>().where((file) => file.path.endsWith('.pdf')), isEmpty);
  });

  test('неверный ключ с корректным ciphertext не проходит AEAD', () async {
    final data = await encrypted();
    handler = (request) async {
      request.response.add(data.cipher);
      await request.response.close();
    };
    final wrong = models.CDN(
      cdnID: data.cdn.cdnID,
      url: data.cdn.url,
      hashSumEncrypted: data.cdn.hashSumEncrypted,
      contentType: data.cdn.contentType,
      encryptionKey: Uint8List.fromList(encryptor.generateFileKey()),
      hkdfSalt: data.cdn.hkdfSalt,
      createAt: data.cdn.createAt,
    );

    await expectLater(manager.download(cdn: wrong), throwsA(isA<DownloadException>()));
    expect(await manager.cachedFile(data.cdn.cdnID), isNull);
  });

  test('одновременные download одного CDN делят один HTTP-запрос', () async {
    final data = await encrypted();
    final gate = Completer<void>();
    var requests = 0;
    handler = (request) async {
      requests++;
      await gate.future;
      request.response.add(data.cipher);
      await request.response.close();
    };

    final first = manager.download(cdn: data.cdn);
    final second = manager.download(cdn: data.cdn);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(requests, 1);
    gate.complete();
    final files = await Future.wait([first, second]);

    expect(files[0].path, files[1].path);
    expect(await files[0].readAsBytes(), data.plain);
    expect(requests, 1);
  });

  test('evict удаляет кэш и разрешает скачивание заново', () async {
    final data = await encrypted();
    var requests = 0;
    handler = (request) async {
      requests++;
      request.response.add(data.cipher);
      await request.response.close();
    };
    final file = await manager.download(cdn: data.cdn);

    expect(await manager.evict(data.cdn.cdnID), isTrue);
    expect(await file.exists(), isFalse);
    expect(await downloads.getByCdnID(data.cdn.cdnID), isNull);
    expect(await manager.evict(data.cdn.cdnID), isFalse);

    await manager.download(cdn: data.cdn);
    expect(requests, 2);
  });

  test('устаревшая ссылка обновляется один раз через refresh', () async {
    final data = await encrypted(fileURL: url('/old'));
    var refreshed = 0;
    handler = (request) async {
      if (request.uri.path == '/old') {
        request.response.statusCode = HttpStatus.forbidden;
      } else {
        request.response.add(data.cipher);
      }
      await request.response.close();
    };

    final file = await manager.download(
      cdn: data.cdn,
      refresh: () async {
        refreshed++;
        return data.cdn.copyWith(url: url('/fresh'));
      },
    );

    expect(await file.readAsBytes(), data.plain);
    expect(refreshed, 1);
    expect((await downloads.getByCdnID(data.cdn.cdnID))?.url, url('/fresh'));
  });

  test('частичный ciphertext после перезапуска докачивается через Range', () async {
    final data = await encrypted();
    final hex = data.cdn.cdnID.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    final partDir = await Directory('${dir.path}/media/.part').create(recursive: true);
    final part = File('${partDir.path}/$hex.part');
    await part.writeAsBytes(data.cipher.sublist(0, 100));
    await downloads.create(
      models.DownloadState(
        cdnID: data.cdn.cdnID,
        url: data.cdn.url,
        tmpPath: part.path,
        targetPath: null,
        encryptionKey: data.cdn.encryptionKey,
        hkdfSalt: data.cdn.hkdfSalt,
        contentType: data.cdn.contentType,
        hashSumEncrypted: data.cdn.hashSumEncrypted,
        cipherSize: data.cipher.length,
        receivedBytes: 100,
        status: models.DownloadStatus.downloading,
        createdAt: DateTime(2026),
      ),
    );
    String? range;
    handler = (request) async {
      range = request.headers.value(HttpHeaders.rangeHeader);
      request.response.statusCode = HttpStatus.partialContent;
      request.response.contentLength = data.cipher.length - 100;
      request.response.add(data.cipher.sublist(100));
      await request.response.close();
    };

    final file = await manager.download(cdn: data.cdn);

    expect(await file.readAsBytes(), data.plain);
    expect(range, 'bytes=100-');
    expect(await part.exists(), isFalse);
  });

  test('uploadBytes шифрует, подтверждает, засеивает кэш и удаляет temp', () async {
    final plain = Uint8List.fromList(List.generate(1024, (index) => index % 31));
    final cdn = await manager.uploadBytes(bytes: plain, folder: 'chats', contentType: 'image/png', extension: 'png');

    expect(uploadClient.chunks, isNotEmpty);
    expect(uploadClient.initSize, greaterThan(plain.length));
    expect(cdn.encryptionKey, isNotEmpty);
    expect(await uploads.getAllPending(), isEmpty);
    expect(await manager.cachedFile(cdn.cdnID), isNotNull);
    expect(await (await manager.cachedFile(cdn.cdnID))!.readAsBytes(), plain);
    expect(Directory.systemTemp.listSync().where((entry) => entry.path.contains('upload_') && entry.path.endsWith('.png')), isEmpty);
  });

  test('отмена uploadFile очищает локальное состояние без UPLOAD_CONFIRM', () async {
    final file = File('${dir.path}/cancel.bin');
    await file.writeAsBytes(List.filled(1024, 1));

    await expectLater(
      manager.uploadFile(file: file, folder: 'chats', contentType: 'application/octet-stream', isCancelled: () => true),
      throwsA(isA<UploadCancelledException>()),
    );

    expect(await uploads.getAllPending(), isEmpty);
    expect(api.unaryCalls.where((call) => call.type == MessageType.UPLOAD_CONFIRM), isEmpty);
  });

  test('secret upload не отправляет ключ серверу, но возвращает его локально', () async {
    final file = File('${dir.path}/secret.bin');
    await file.writeAsBytes(List.filled(128, 2));
    final cdn = await manager.uploadFile(file: file, folder: secretMediaFolder, contentType: 'application/octet-stream');

    final confirm = pb.UploadConfirm_Request.fromBuffer(api.unaryCalls.single.payload);
    expect(confirm.opaque, isTrue);
    expect(confirm.encryptionKey, isEmpty);
    expect(confirm.hkdfSalt, isEmpty);
    expect(cdn.encryptionKey, isNotEmpty);
    expect(cdn.hkdfSalt, isNotEmpty);
  });
}

final class CdnFakeApi extends FakeApi {
  CdnFakeApi(this._uploadClient);
  final FakeUploadClient _uploadClient;
  @override
  IperonClient get uploadClient => _uploadClient;

  @override
  Future<(APICallStatus, Uint8List?)> unaryEncodedWithResponse(MessageType type, Uint8List payload) async {
    unaryCalls.add(FakeApiCall(type, payload));
    if (type == MessageType.UPLOAD_CONFIRM) {
      final request = pb.UploadConfirm_Request.fromBuffer(payload);
      final response = pb.UploadConfirm_Response(
        cdn: pb.CDN(
          cdnID: List<int>.filled(12, 9),
          url: 'http://cdn.test/file',
          hashSumEncrypted: List.filled(32, 1),
          contentType: request.contentType,
          encryptionKey: request.encryptionKey,
          hkdfSalt: request.hkdfSalt,
        ),
      );
      return (const APICallStatus(status: APIStatus.success, statusCode: 0), response.writeToBuffer());
    }
    return super.unaryEncodedWithResponse(type, payload);
  }
}

final class FakeUploadClient implements IperonClient {
  final chunks = <int>[];
  int initSize = 0;

  @override
  ResponseStream<pb.Upload_Response> upload(Stream<pb.Upload_Request> request, {CallOptions? options}) {
    final responses = StreamController<pb.Upload_Response>();
    var received = 0;
    request.listen((item) {
      if (item.hasInit()) {
        initSize = item.init.fileSize.toInt();
        responses.add(
          pb.Upload_Response(
            initAck: pb.Upload_InitAck(uploadId: 'upload-1', receivedBytes: Int64(0)),
          ),
        );
      } else if (item.hasChunk()) {
        received += item.chunk.data.length;
        chunks.add(item.chunk.data.length);
        responses.add(pb.Upload_Response(chunkAck: pb.Upload_ChunkAck(receivedBytes: Int64(received))));
      } else if (item.hasDone()) {
        responses.add(pb.Upload_Response(completeAck: pb.Upload_CompleteAck(receivedBytes: Int64(received))));
        responses.close();
      }
    }, onDone: responses.close);
    return FakeUploadResponseStream(responses.stream);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeUploadResponseStream implements ResponseStream<pb.Upload_Response> {
  final Stream<pb.Upload_Response> _stream;
  const FakeUploadResponseStream(this._stream);

  @override
  StreamSubscription<pb.Upload_Response> listen(
    void Function(pb.Upload_Response event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => _stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class CdnAuth implements Auth {
  @override
  final models.Session session;
  const CdnAuth(this.session);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class CdnCrypto implements Crypto {
  @override
  final FileEncryptor fileEncryptor;
  const CdnCrypto(this.fileEncryptor);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class CdnRepositories implements Repositories {
  @override
  final Downloads downloads;
  @override
  final Uploads uploads;
  @override
  late final DataUsageRepository dataUsage = CdnDataUsage();
  CdnRepositories(this.downloads, this.uploads);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class CdnDataUsage implements DataUsageRepository {
  @override
  Future<void> addTraffic(Map<(models.NetworkKind, models.TrafficCategory), models.TrafficCounter> usage) async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class LoopbackHttpOverrides extends HttpOverrides {}

final class CdnUtils implements Utils {
  @override
  String bytesToHex(Uint8List bytes) => bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
