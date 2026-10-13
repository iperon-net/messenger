import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../di.dart';
import '../logger.dart';

/// Файл вложения для системы: [path] — где лежит (кэш скачанного / outbox),
/// [name] — как его назвать снаружи (имя файла из сообщения; пусто — как
/// есть), [video] — для галереи.
class MediaFile {
  final String path;
  final String name;
  final bool video;

  const MediaFile(this.path, {this.name = '', this.video = false});
}

/// Чем закончилось сохранение.
enum MediaSaveResult { saved, canceled, denied, failed }

/// Вложения чата для системы: открыть в другом приложении, скопировать в буфер
/// обмена (вставить в другой мессенджер), сохранить в галерею / файлы,
/// поделиться. Нативная часть — канал `net.iperon.messenger/files`
/// (`ios/Runner/MediaFiles.swift`, `android/.../MediaFiles.kt`).
///
/// Скачанные вложения лежат в кэше под именем `<cdnID>.<расширение>`; наружу
/// (открыть, сохранить файл, поделиться) отдаём копию с настоящим именем —
/// приложение-просмотрщик и «Файлы» показывают его.
class MediaFiles {
  MediaFiles._();

  static const _channel = MethodChannel('net.iperon.messenger/files');

  static Logger get _logger => getIt.get<Logger>();

  /// Копии с настоящими именами старше этого удаляются при следующем экспорте.
  static const _exportTtl = Duration(hours: 1);

  /// Открыть: iOS — Quick Look (в нём же «Поделиться»), Android — приложение
  /// для этого типа. `false` — открыть нечем.
  static Future<bool> open(MediaFile file) async {
    final path = await _named(file);
    return await _channel.invokeMethod<bool>('open', {'path': path}) ?? false;
  }

  /// В буфер обмена (фото и видео — как файлы, их можно вставить в другой
  /// мессенджер). `false` — не вышло.
  static Future<bool> copy(List<MediaFile> files) async {
    try {
      await _channel.invokeMethod<void>('copy', {
        'paths': [for (final f in files) f.path],
      });
      _logger.info('media files: copied ${files.length} ${[for (final f in files) p.basename(f.path)]}');
      return true;
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace, 'media files: copy');
      return false;
    }
  }

  /// Фото / видео — в галерею (iOS — «Фото», Android — Pictures|Movies/Iperon).
  static Future<MediaSaveResult> saveToGallery(List<MediaFile> files) async {
    for (final file in files) {
      final result = await _save('saveToGallery', {'path': await _named(file), 'video': file.video});
      if (result != MediaSaveResult.saved) return result;
    }
    return MediaSaveResult.saved;
  }

  /// Файл: iOS — «Сохранить в Файлы» (место выбирают), Android — в
  /// Download/Iperon.
  static Future<MediaSaveResult> saveFile(MediaFile file) async => _save('saveFile', {'path': await _named(file)});

  /// Есть ли в буфере обмена фото / видео (без чтения содержимого).
  static Future<bool> clipboardHasMedia() async {
    try {
      return await _channel.invokeMethod<bool>('clipboardHasMedia') ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Фото / видео из буфера обмена — файлами во временном каталоге (пусто —
  /// там их нет).
  static Future<List<String>> pasteMedia() async {
    try {
      final pasted = await _channel.invokeListMethod<Map<Object?, Object?>>('pasteMedia', {'dir': await _pasteDir()});
      final paths = [for (final item in pasted ?? const <Map<Object?, Object?>>[]) item['path'] as String];
      _logger.info('media files: pasted ${paths.length} ${[for (final path in paths) p.basename(path)]}');
      return paths;
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace, 'media files: paste');
      return const [];
    }
  }

  /// Картинка / видео с клавиатуры (Android: вставка из буфера Gboard,
  /// GIF-клавиатура) — файлом во временном каталоге; `null` — данных нет.
  static Future<String?> saveInserted(Uint8List? data, String mimeType) async {
    if (data == null || data.isEmpty) return null;
    final ext = switch (mimeType) {
      'image/png' => 'png',
      'image/gif' => 'gif',
      'image/webp' => 'webp',
      'image/heic' || 'image/heif' => 'heic',
      'video/mp4' => 'mp4',
      'video/3gpp' => '3gp',
      'video/webm' => 'webm',
      _ => mimeType.startsWith('video/') ? 'mp4' : 'jpg',
    };
    final file = File(p.join(await _pasteDir(), 'paste_${DateTime.now().microsecondsSinceEpoch}.$ext'));
    await file.writeAsBytes(data, flush: true);
    return file.path;
  }

  static Future<String> _pasteDir() async {
    final dir = Directory(p.join((await getTemporaryDirectory()).path, 'media_paste'));
    await _cleanExports(dir);
    await dir.create(recursive: true);
    return dir.path;
  }

  /// Системное «Поделиться».
  static Future<void> share(List<MediaFile> files) async {
    final named = [for (final f in files) XFile(await _named(f))];
    await SharePlus.instance.share(ShareParams(files: named));
  }

  static Future<MediaSaveResult> _save(String method, Map<String, Object> args, {bool retried = false}) async {
    try {
      final saved = await _channel.invokeMethod<bool>(method, args);
      return saved == false ? MediaSaveResult.canceled : MediaSaveResult.saved;
    } on PlatformException catch (error) {
      switch (error.code) {
        case 'denied':
          return MediaSaveResult.denied;
        // До Android 10 — запись в общую папку по разрешению: просим и повторяем.
        case 'permission' when !retried:
          if (!await Permission.storage.request().isGranted) return MediaSaveResult.denied;
          return _save(method, args, retried: true);
        case 'permission':
          return MediaSaveResult.denied;
        default:
          return MediaSaveResult.failed;
      }
    }
  }

  /// Путь с настоящим именем: имя совпадает — сам файл, иначе — копия во
  /// временном каталоге.
  static Future<String> _named(MediaFile file) async {
    final name = _safeName(file.name);
    if (name.isEmpty || name == p.basename(file.path)) return file.path;
    final root = Directory(p.join((await getTemporaryDirectory()).path, 'media_export'));
    await _cleanExports(root);
    final dir = Directory(p.join(root.path, DateTime.now().microsecondsSinceEpoch.toString()));
    await dir.create(recursive: true);
    return (await File(file.path).copy(p.join(dir.path, name))).path;
  }

  /// Имя файла без каталогов и запрещённых символов.
  static String _safeName(String name) => p.basename(name.trim()).replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1F]'), '_');

  static Future<void> _cleanExports(Directory root) async {
    if (!await root.exists()) return;
    final now = DateTime.now();
    await for (final entry in root.list()) {
      try {
        if (now.difference((await entry.stat()).modified) > _exportTtl) await entry.delete(recursive: true);
      } on FileSystemException {
        // Занят / уже удалён — в следующий раз.
      }
    }
  }
}

/// Есть ли в буфере обмена фото / видео — для «Вставить» в меню поля ввода
/// (меню строится синхронно, поэтому знаем заранее). Обновляется, когда поле
/// получает фокус ([refresh]), при возврате в приложение и по сигналу
/// Android о смене буфера.
class ClipboardMedia extends ValueNotifier<bool> {
  ClipboardMedia._() : super(false) {
    MediaFiles._channel.setMethodCallHandler((call) async {
      if (call.method == 'clipboardChanged') await refresh();
    });
    _lifecycle = AppLifecycleListener(onResume: refresh);
  }

  static final ClipboardMedia instance = ClipboardMedia._();

  // ignore: unused_field
  late final AppLifecycleListener _lifecycle;

  Future<void> refresh() async {
    value = await MediaFiles.clipboardHasMedia();
    MediaFiles._logger.debug('media files: clipboard has media=$value');
  }
}
