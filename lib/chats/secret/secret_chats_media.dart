import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../cdn.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../protobuf/protos/secret_payload_v1.pb.dart' as sp;
import '../../utils.dart';
import '../chats_sync.dart' show ChatsOfflineException;
import 'secret_chats_sync.dart';
import '../../account_scope.dart';

/// Скачивание вложений секретных чатов (открытый чат качает всё сам, как
/// обычные чаты): ссылку на шифротекст выдаёт сервер (`SecretChats.GetFiles`,
/// только участнику чата), ключ / соль / хеш — из сообщения
/// ([sp.SecretMedia]), расшифровка и кэш — `CDNManager.download`.
class SecretChatsMedia {
  SecretChatsMedia._();

  static SecretChatsMedia get instance => AccountScope.current.resolve(SecretChatsMedia._);

  /// Скачанные: fileID (hex) → путь в кэше.
  final _paths = <String, String>{};

  /// В очереди и идущие: fileID (hex) → получено / всего байт шифротекста.
  final _downloads = <String, ({int received, int total})>{};
  final _queue = <({String key, List<int> chatID, sp.SecretMedia media})>[];
  var _active = 0;
  static const _maxDownloads = 3;

  /// Неудачные (нет сети, ошибка): повтор не раньше чем через [_retry].
  final _failed = <String, DateTime>{};
  static const _retry = Duration(minutes: 1);

  /// Что-то скачалось / сдвинулся прогресс (не чаще раза в 250 мс).
  Stream<void> get changed => _changed.stream;
  final _changed = StreamController<void>.broadcast();
  Timer? _notify;

  void _changedLater() => _notify ??= Timer(const Duration(milliseconds: 250), () {
    _notify = null;
    _changed.add(null);
  });

  CDNManager get _cdn => getIt.get<CDNManager>();

  static String _hex(List<int> bytes) => getIt.get<Utils>().bytesToHex(Uint8List.fromList(bytes));

  /// Путь скачанного файла вложения [media] чата [chatID]; ещё не скачан —
  /// ставит в очередь и отдаёт пусто.
  Future<String> file(List<int> chatID, sp.SecretMedia media) async {
    if (media.fileID.isEmpty) return '';
    final key = _hex(media.fileID);
    final known = _paths[key];
    if (known != null) return known;
    if (_downloads.containsKey(key)) return '';
    final cached = await _cdn.cachedFile(Uint8List.fromList(media.fileID));
    if (cached != null) return _paths[key] = cached.path;
    final failed = _failed[key];
    if (failed != null && DateTime.now().difference(failed) < _retry) return '';
    _downloads[key] = (received: 0, total: 0);
    _queue.add((key: key, chatID: chatID, media: media));
    _pump();
    return '';
  }

  /// Прогресс скачивания (байты шифротекста); `null` — не качается.
  ({int received, int total})? progress(List<int> fileID) => fileID.isEmpty ? null : _downloads[_hex(fileID)];

  /// Файл удалён с устройства (сообщение удалили) — забыть путь.
  void forget(List<int> fileID) => _paths.remove(_hex(fileID));

  void _pump() {
    while (_active < _maxDownloads && _queue.isNotEmpty) {
      final job = _queue.removeAt(0);
      _active++;
      unawaited(
        _download(job.key, job.chatID, job.media).whenComplete(() {
          _active--;
          _pump();
        }),
      );
    }
  }

  Future<void> _download(String key, List<int> chatID, sp.SecretMedia media) async {
    final sync = SecretChatsSync.instance;
    try {
      if (!await sync.hasNetwork()) return _fail(key);
      Future<String?> url() async => (await sync.fileUrls(chatID, [media.fileID]))[key];
      final first = await url();
      if (first == null) return _fail(key);
      final cdn = models.CDN(
        cdnID: Uint8List.fromList(media.fileID),
        url: first,
        hashSumEncrypted: Uint8List.fromList(media.sha256),
        contentType: media.mimeType,
        encryptionKey: Uint8List.fromList(media.key),
        hkdfSalt: Uint8List.fromList(media.hkdfSalt),
        createAt: DateTime.now(),
      );
      final file = await _cdn.download(
        cdn: cdn,
        onProgress: (received, total) {
          _downloads[key] = (received: received, total: total);
          _changedLater();
        },
        refresh: () async {
          final fresh = await url();
          return fresh == null ? null : cdn.copyWith(url: fresh);
        },
      );
      _paths[key] = file.path;
      _failed.remove(key);
    } catch (error, stackTrace) {
      _fail(key);
      if (error is! ChatsOfflineException) getIt.get<Logger>().handle(error, stackTrace);
    } finally {
      _downloads.remove(key);
      _changedLater();
    }
  }

  void _fail(String key) => _failed[key] = DateTime.now();
}
