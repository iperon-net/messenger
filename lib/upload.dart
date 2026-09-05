import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/helpers.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:path/path.dart' as p;

import 'api.dart';
import 'auth.dart';
import 'crypto.dart';
import 'di.dart';
import 'logger.dart';
import 'models.dart' as models;
import 'protobuf.dart';
import 'repositories.dart';
import 'utils.dart';

/// Ошибка загрузки/подтверждения файла, не сведённая к обычному
/// [APICallStatus] (например, обрыв сырого стрима `Upload` до `CompleteAck`,
/// который на gRPC-уровне не всегда даёт осмысленный `GrpcError`).
class UploadException implements Exception {
  final String message;
  const UploadException(this.message);

  @override
  String toString() => 'UploadException: $message';
}

/// `UploadManager` — этапы 1+2 загрузки больших зашифрованных на клиенте
/// медиафайлов (см. `docs/plans/client-media-upload-stage-1-2.md` и, на
/// сервере, `docs/plans/breezy-uploading-courier.md` /
/// `docs/plans/shimmying-tumbling-owl.md` в репозитории `iperon`).
///
/// Намеренно отдельный класс, а не часть [API]: у `Upload` свой gRPC-метод и
/// свой жизненный цикл на файл (открывается/закрывается на каждую попытку
/// загрузки), в отличие от одного долгоживущего персистентного стрима,
/// которым управляет `API`.
///
/// Домено-нейтрален: отдаёт наружу только `CDN` (`cdn_id`/`url`/обёрнутый
/// ключ) — привязку к конкретной сущности (аватарка, вложение в чат и т.п.)
/// делает вызывающий код, когда такая сущность появится (см. "Заметки на
/// будущее" в `shimmying-tumbling-owl.md`).
class UploadManager {
  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final crypto = getIt.get<Crypto>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();
  final utils = getIt.get<Utils>();

  /// Число автоматических попыток переоткрыть стрим `Upload` после обрыва
  /// (докачка с оффсета из свежего `InitAck`), прежде чем пробросить ошибку
  /// вызывающему коду.
  static const int _maxStreamAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  /// Число автоматических повторов `UPLOAD_CONFIRM` при транзиентном обрыве
  /// соединения — сервер temp-файл не трогает до успешного confirm (см.
  /// `shimmying-tumbling-owl.md`), поэтому повтор безопасен и не требует
  /// повторной заливки файла.
  static const int _maxConfirmAttempts = 3;

  /// gRPC-коды, при которых имеет смысл повторить `UPLOAD_CONFIRM` — обрыв
  /// соединения/таймаут, а не осмысленный отказ сервера (тот же confirm с теми
  /// же данными не станет валиднее от повтора, например `InvalidArgument`,
  /// `NotFound`, `PermissionDenied`).
  static const Set<int> _transientStatusCodes = {StatusCode.unavailable, StatusCode.unknown, StatusCode.deadlineExceeded};

  /// Шифрует [file] на клиенте, заливает с докачкой (этап 1) и подтверждает
  /// загрузку (этап 2). Резюмирует уже поставленную в очередь, но не
  /// подтверждённую загрузку того же [file.path] — при повторном вызове (тот
  /// же локальный файл) новые `fileKey`/`hkdfSalt` не генерируются.
  ///
  /// [onProgress] — необязательный колбэк (уже посланные/подтверждённые
  /// сервером байты шифротекста, полный размер шифротекста) для UI-прогресса.
  Future<CDN> uploadFile({
    required File file,
    required String folder,
    required String contentType,
    String? fileName,
    void Function(int sentBytes, int totalBytes)? onProgress,
  }) async {
    var state = await _resolveUploadState(file: file, folder: folder, contentType: contentType, fileName: fileName);

    for (var attempt = 1; ; attempt++) {
      try {
        state = await _runUploadStream(state, onProgress: onProgress);
        break;
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);

        if (attempt >= _maxStreamAttempts) {
          rethrow;
        }

        await Future.delayed(_retryDelay * attempt);

        // Между попытками мог сохраниться uploadID (первая попытка успела
        // получить InitAck перед обрывом) — перечитываем состояние, чтобы
        // докачка стартовала не с нуля.
        final reloaded = await repositories.uploads.getByLocalID(state.localID);
        if (reloaded == null) {
          throw const UploadException('upload: local state disappeared between retries');
        }
        state = reloaded;
      }
    }

    return _confirm(state);
  }

  Future<models.UploadState> _resolveUploadState({
    required File file,
    required String folder,
    required String contentType,
    String? fileName,
  }) async {
    final existing = await repositories.uploads.getByFilePath(file.path);
    if (existing != null) {
      return existing;
    }

    final fileSize = await file.length();

    final state = models.UploadState(
      localID: randomBytesAsHexString(16),
      uploadID: null,
      filePath: file.path,
      fileSize: fileSize,
      fileKey: Uint8List.fromList(crypto.fileEncryptor.generateFileKey()),
      hkdfSalt: Uint8List.fromList(crypto.fileEncryptor.generateHkdfSalt()),
      noncePrefix: Uint8List.fromList(crypto.fileEncryptor.generateNoncePrefix()),
      folder: folder,
      contentType: contentType,
      fileName: fileName ?? p.basename(file.path),
      createdAt: DateTime.now(),
    );

    await repositories.uploads.create(state);
    return state;
  }

  /// Один проход по сырому bidi-стриму `Upload`: `Init` (новая загрузка или
  /// докачка по `state.uploadID`) → чанки → `Done`. Кидает исключение при
  /// любом обрыве до `CompleteAck` — вызывающий код (см. [uploadFile]) решает,
  /// переоткрывать стрим или нет; сама функция стрим не переоткрывает.
  Future<models.UploadState> _runUploadStream(models.UploadState state, {void Function(int sentBytes, int totalBytes)? onProgress}) async {
    final outgoing = StreamController<Upload_Request>();
    final responses = StreamIterator(api.client.upload(outgoing.stream));
    var completedCleanly = false;

    try {
      final sessionIDHex = utils.bytesToHex(Uint8List.fromList(auth.session.session));

      outgoing.add(
        Upload_Request(
          init: Upload_Init(
            sessionId: sessionIDHex,
            // Сервер меряет байты потока (шифротекст), а не plaintext —
            // state.fileSize исходного файла тут занизит лимит на 16 байт
            // (AEAD-тег) на каждый чанк и ChunkAck на последнем чанке
            // отклонится как "upload size exceeded".
            fileSize: Int64(crypto.fileEncryptor.totalCipherSize(state.fileSize)),
            resumeUploadId: state.uploadID,
          ),
        ),
      );

      if (!await responses.moveNext()) {
        throw const UploadException('upload: stream closed before InitAck');
      }

      final initAck = responses.current.initAck;

      var uploadState = state;
      if (uploadState.uploadID == null) {
        await repositories.uploads.setUploadID(localID: uploadState.localID, uploadID: initAck.uploadId);
        uploadState = uploadState.copyWithUploadID(initAck.uploadId);
      }

      var sentBytes = initAck.receivedBytes.toInt();
      onProgress?.call(sentBytes, uploadState.fileSize);

      final startChunkIndex = crypto.fileEncryptor.chunkIndexForReceivedBytes(uploadState.fileSize, sentBytes);

      final chunks = crypto.fileEncryptor.encryptFile(
        file: File(uploadState.filePath),
        fileKey: uploadState.fileKey,
        hkdfSalt: uploadState.hkdfSalt,
        noncePrefix: uploadState.noncePrefix,
        startChunkIndex: startChunkIndex,
      );

      // Строго последовательно: следующий чанк уходит только после ack на
      // предыдущий (сервер пайплайнинг не поддерживает, см. серверный план).
      await for (final cipherChunk in chunks) {
        outgoing.add(Upload_Request(chunk: Upload_Chunk(data: cipherChunk)));

        if (!await responses.moveNext()) {
          throw const UploadException('upload: stream closed mid-chunk');
        }

        sentBytes = responses.current.chunkAck.receivedBytes.toInt();
        onProgress?.call(sentBytes, uploadState.fileSize);
      }

      outgoing.add(Upload_Request(done: Upload_Done()));

      if (!await responses.moveNext()) {
        throw const UploadException('upload: stream closed before CompleteAck');
      }
      // completeAck.receivedBytes == fileSize уже проверен сервером
      // (иначе стрим завершился бы ошибкой InvalidArgument) — дублировать
      // проверку на клиенте незачем.

      completedCleanly = true;
      return uploadState;
    } finally {
      await outgoing.close();

      // cancel() шлёт RST_STREAM — уместно только если стрим прервали сами
      // (исключение выше). Звать его и после штатного CompleteAck (сервер уже
      // сам закрыл стрим) — попытка отменить то, что уже полностью завершено
      // по HTTP/2, что как минимум одна реализация трактует как protocol
      // error и рвёт всё gRPC-соединение целиком (включая персистентный
      // Stream API) — именно это било по последующему UPLOAD_CONFIRM.
      if (!completedCleanly) {
        await responses.cancel();
      }
    }
  }

  Future<CDN> _confirm(models.UploadState state) async {
    final uploadID = state.uploadID;
    if (uploadID == null) {
      throw const UploadException('upload: confirm called before InitAck ever succeeded');
    }

    final request = UploadConfirm_Request(
      uploadId: uploadID,
      encryptionKey: state.fileKey,
      hkdfSalt: state.hkdfSalt,
      fileName: state.fileName,
      contentType: state.contentType,
      folder: state.folder,
    );
    final payload = request.writeToBuffer();

    for (var attempt = 1; ; attempt++) {
      final (status, response) = await api.unaryEncodedWithResponse(MessageType.UPLOAD_CONFIRM, payload);

      if (status.status == APIStatus.success && response != null) {
        final cdn = UploadConfirm_Response.fromBuffer(response).cdn;
        await repositories.uploads.delete(state.localID);
        return cdn;
      }

      // Temp-файл на сервере не тронут (см. shimmying-tumbling-owl.md) —
      // локальную строку не удаляем в любом случае, чтобы вызывающий код мог
      // повторить именно confirm (без повторной заливки файла) даже после
      // исчерпания автоматических попыток здесь.
      final retryable = status.isGrpc && _transientStatusCodes.contains(status.statusCode);
      if (!retryable || attempt >= _maxConfirmAttempts) {
        throw UploadException('upload: confirm failed: $status');
      }

      logger.debug('upload: confirm attempt $attempt failed ($status), retrying');
      await Future.delayed(_retryDelay * attempt);
    }
  }
}
