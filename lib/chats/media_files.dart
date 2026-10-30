import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/share_origin.dart';
import '../desktop.dart';
import '../di.dart';
import '../logger.dart';
import '../platform.dart';
import '../repositories.dart';

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
  /// для этого типа, десктоп — программа по умолчанию для типа, из копии в
  /// папке загрузок (как Telegram Desktop: правки в открытом документе не
  /// пропадут вместе с временной копией). `false` — открыть нечем.
  static Future<bool> open(MediaFile file) async {
    if (AppPlatform.isDesktop) {
      final path = await _downloaded(file);
      return path != null && await launchUrl(Uri.file(path));
    }
    return await _channel.invokeMethod<bool>('open', {'path': await _named(file)}) ?? false;
  }

  /// Десктоп: «Показать в Finder» — копия в папке загрузок (уже есть — та
  /// же), выделенная в Finder / Проводнике. `false` — не вышло.
  static Future<bool> reveal(MediaFile file) async {
    final path = await _downloaded(file);
    return path != null && await Desktop.revealFile(path);
  }

  /// В буфер обмена (фото и видео — как файлы, их можно вставить в другой
  /// мессенджер). `false` — не вышло.
  static Future<bool> copy(List<MediaFile> files) async {
    try {
      if (AppPlatform.isDesktop) {
        // Файлами, как «Скопировать» в Finder / Проводнике.
        if (!await Pasteboard.writeFiles([for (final f in files) await _named(f)])) return false;
      } else {
        await _channel.invokeMethod<void>('copy', {
          'paths': [for (final f in files) f.path],
        });
      }
      _logger.info('media files: copied ${files.length} ${[for (final f in files) p.basename(f.path)]}');
      // Своё «Копировать» — «Вставить» в поле ввода уже знает про медиа.
      unawaited(ClipboardMedia.instance.refresh());
      return true;
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace, 'media files: copy');
      return false;
    }
  }

  /// Фото / видео — в галерею (iOS — «Фото», Android — Pictures|Movies/Iperon).
  static Future<MediaSaveResult> saveToGallery(List<MediaFile> files) async {
    if (AppPlatform.isDesktop) return _saveDesktop(files);
    for (final file in files) {
      final result = await _save('saveToGallery', {'path': await _named(file), 'video': file.video});
      if (result != MediaSaveResult.saved) return result;
    }
    return MediaSaveResult.saved;
  }

  /// Файл: iOS — «Сохранить в Файлы» (место выбирают), Android — в
  /// Download/Iperon.
  static Future<MediaSaveResult> saveFile(MediaFile file) async =>
      AppPlatform.isDesktop ? _saveDesktop([file]) : _save('saveFile', {'path': await _named(file)});

  /// Десктоп: галереи нет — фото, видео и файлы в папку загрузок
  /// («Загрузки/Iperon» или своя, как Android и Telegram Desktop), занятое
  /// имя — «имя (1).ext».
  static Future<MediaSaveResult> _saveDesktop(List<MediaFile> files) async {
    try {
      final dir = await _downloadsDir();
      if (dir == null) return MediaSaveResult.failed;
      for (final file in files) {
        _exported[file.path] = await _copyUnique(file, dir);
      }
      _logger.info('media files: saved ${files.length} to ${dir.path}');
      return MediaSaveResult.saved;
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace, 'media files: save');
      return MediaSaveResult.failed;
    }
  }

  /// Десктоп: копии в «Загрузках» за этот запуск — файл в кэше → копия.
  /// Повторные «Открыть» / «Показать в Finder» берут её, а не плодят
  /// «имя (1).ext».
  static final _exported = <String, String>{};

  /// Копия [file] в папку загрузок для «Открыть» / «Показать в Finder»:
  /// сделанная в этот запуск (ещё на месте), там же файл с этим именем и
  /// размером (скачан раньше) или новая. `null` — не вышло.
  static Future<String?> _downloaded(MediaFile file) async {
    try {
      final dir = await _downloadsDir();
      if (dir == null) return null;
      // Папку в «Данных и памяти» сменили — копия в новую.
      final known = _exported[file.path];
      if (known != null && p.dirname(known) == dir.path && await File(known).exists()) return known;
      final same = File(p.join(dir.path, _exportName(file)));
      if (await same.exists() && await same.length() == await File(file.path).length()) {
        return _exported[file.path] = same.path;
      }
      final path = await _copyUnique(file, dir);
      _logger.info('media files: exported ${p.basename(path)} to ${dir.path}');
      return _exported[file.path] = path;
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace, 'media files: export');
      return null;
    }
  }

  /// Десктоп: куда сохранять — папка из «Данных и памяти» (macOS; пропала —
  /// диск отключён, папку удалили — по умолчанию), иначе «Загрузки/Iperon».
  static Future<Directory?> _downloadsDir() async {
    final custom = await customDownloadsDir();
    if (custom != null) return Directory(custom);
    final path = await defaultDownloadsDir();
    return path == null ? null : Directory(path).create(recursive: true);
  }

  /// «Загрузки/Iperon» (папки может ещё не быть).
  static Future<String?> defaultDownloadsDir() async {
    final downloads = await getDownloadsDirectory();
    return downloads == null ? null : p.join(downloads.path, 'Iperon');
  }

  /// Выбранная в «Данных и памяти» папка, если она на месте; `null` — по
  /// умолчанию.
  static Future<String?> customDownloadsDir() async {
    if (!Platform.isMacOS) return null;
    final path = (await getIt.get<DeviceRepositories>().settingsDevice.getAll()).downloadsDir;
    return path.isNotEmpty && await Directory(path).exists() ? path : null;
  }

  static String _exportName(MediaFile file) => _safeName(file.name).isEmpty ? p.basename(file.path) : _safeName(file.name);

  /// Копия [file] в [dir]; занятое имя — «имя (1).ext».
  static Future<String> _copyUnique(MediaFile file, Directory dir) async {
    final name = _exportName(file);
    var target = File(p.join(dir.path, name));
    for (var i = 1; await target.exists(); i++) {
      target = File(p.join(dir.path, '${p.basenameWithoutExtension(name)} ($i)${p.extension(name)}'));
    }
    return (await File(file.path).copy(target.path)).path;
  }

  /// Есть ли в буфере обмена фото / видео (без чтения содержимого).
  static Future<bool> clipboardHasMedia() async {
    if (AppPlatform.isDesktop) return (await _desktopClipboard()) != null;
    try {
      return await _channel.invokeMethod<bool>('clipboardHasMedia') ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Фото / видео из буфера обмена — файлами во временном каталоге (пусто —
  /// там их нет).
  static Future<List<String>> pasteMedia() async {
    if (AppPlatform.isDesktop) return _pasteDesktop();
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

  /// Десктоп (канала `files` нет): что вставлять из буфера — файлы (скопированные
  /// в Finder / Проводнике) или картинка (снимок экрана, «Скопировать
  /// изображение»), но картинку — только без текста: из браузера / редактора
  /// вместе с текстом копируется и её снимок, а вставить ждут текст. `null` —
  /// вставлять нечего (вставка текста — полем).
  static Future<({List<String> files, Uint8List? image})?> _desktopClipboard() async {
    try {
      final files = await Pasteboard.files();
      if (files.isNotEmpty) return (files: files, image: null);
      if (await Clipboard.hasStrings()) return null;
      final image = await Pasteboard.image;
      return image == null || image.isEmpty ? null : (files: const <String>[], image: image);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace, 'media files: desktop clipboard');
      return null;
    }
  }

  static Future<List<String>> _pasteDesktop() async {
    final clipboard = await _desktopClipboard();
    if (clipboard == null) return const [];
    if (clipboard.files.isNotEmpty) {
      _logger.info('media files: pasted ${clipboard.files.length} files');
      return clipboard.files;
    }
    final path = await saveInserted(clipboard.image, 'image/png');
    return path == null ? const [] : [path];
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

  /// Системное «Поделиться»; [context] — откуда раскрыть popover на iPad.
  static Future<void> share(List<MediaFile> files, {BuildContext? context}) async {
    final origin = shareOrigin(context);
    final named = [for (final f in files) XFile(await _named(f))];
    await SharePlus.instance.share(ShareParams(files: named, sharePositionOrigin: origin));
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
