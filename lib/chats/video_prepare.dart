import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../di.dart';
import '../logger.dart';
import 'media_prepare.dart';

/// Видео, подготовленное к отправке в чат: сжатый MP4 (или исходник, если он
/// и так небольшой), размеры, длительность, кадр-превью и ThumbHash.
///
/// Сжимаем на клиенте по той же причине, что и фото (см. [prepareChatPhoto]):
/// сервер видит только шифротекст. Кодирует нативная часть — iOS
/// `VideoCompressor.swift` (AVAssetReader/Writer), Android `VideoCompressor.kt`
/// (Media3 Transformer), аппаратным кодеком.
class PreparedVideo {
  final String path;
  final int width;
  final int height;

  /// Секунды (округлённо вверх).
  final int duration;
  final int size;
  final String thumbPath;
  final String thumbhash;

  const PreparedVideo({
    required this.path,
    required this.width,
    required this.height,
    required this.duration,
    required this.size,
    required this.thumbPath,
    required this.thumbhash,
  });
}

/// Качество отправляемого видео (переключатель «HD» в превью перед
/// отправкой). Кодек — HEVC: по качеству как H.264 с битрейтом в ~1,5 раза
/// выше, т. е. файл на ~35% меньше. HEVC кодируют и играют аппаратно все
/// поддерживаемые устройства (iPhone с A10, Android последних лет). Нет
/// аппаратного HEVC-кодировщика или он упал — откат на H.264 [h264Bitrate].
/// Звук — AAC 128 кбит/с, частота кадров — не выше [ChatVideoCompression.maxFps].
enum ChatVideoQuality {
  /// 720p, ~13 МБ/мин — как «стандартное» качество Telegram.
  standard(shortSide: 720, bitrate: 1600000, h264Bitrate: 2500000, keepBitrate: 2200000),

  /// 1080p, ~24 МБ/мин.
  hd(shortSide: 1080, bitrate: 3000000, h264Bitrate: 4500000, keepBitrate: 4000000);

  /// Короткая сторона кадра (больше — уменьшаем).
  final int shortSide;
  final int bitrate;
  final int h264Bitrate;

  /// Не больше [shortSide], битрейт не выше этого и ≤ 30 к/с — отправляем как есть.
  final int keepBitrate;

  const ChatVideoQuality({required this.shortSide, required this.bitrate, required this.h264Bitrate, required this.keepBitrate});
}

abstract final class ChatVideoCompression {
  /// Выше — прореживаем кадры (как Telegram и WhatsApp): 60 к/с на том же
  /// битрейте выглядят заметно хуже.
  static const maxFps = 30;
  static const thumbSide = 320;
}

/// Правки видео из редактора перед отправкой: обрезка, без звука, обложка,
/// кадрирование и поворот.
class ChatVideoEdit {
  /// Обрезка, мс от начала исходника; [endMs] 0 — до конца.
  final int startMs;
  final int endMs;
  final bool mute;

  /// Кадр-обложка (мс от начала исходника); `null` — первый кадр отрезка.
  final int? coverMs;

  /// Кадрирование — доли 0..1 кадра исходника в том виде, как он
  /// показывается (с учётом поворота из метаданных), до [rotation];
  /// `null` — весь кадр.
  final Rect? crop;

  /// Поворот по часовой стрелке после кадрирования: 0 / 90 / 180 / 270.
  final int rotation;

  const ChatVideoEdit({this.startMs = 0, this.endMs = 0, this.mute = false, this.coverMs, this.crop, this.rotation = 0});

  bool get trimmed => startMs > 0 || endMs > 0;

  /// Меняется кадр: кадрирование или поворот.
  bool get changesFrame => crop != null || rotation != 0;

  /// Есть, что перекодировать (обложка — только кадр-превью, видео не трогает).
  bool get changesVideo => trimmed || mute || changesFrame;

  int get thumbAtMs => coverMs ?? startMs;

  /// Размеры кадра после кадрирования и поворота для исходника [width]×[height].
  ({double width, double height}) frameSize(num width, num height) {
    final crop = this.crop ?? const Rect.fromLTWH(0, 0, 1, 1);
    final w = width * crop.width;
    final h = height * crop.height;
    return rotation % 180 == 0 ? (width: w, height: h) : (width: h, height: w);
  }
}

/// Отмена сжатия (кнопка «Отмена» в окне прогресса).
class ChatVideoCancelled implements Exception {
  const ChatVideoCancelled();
}

/// Одно сжатие: [cancel] прерывает его, [prepareChatVideo] бросает
/// [ChatVideoCancelled].
class ChatVideoJob {
  final String id = '${DateTime.now().microsecondsSinceEpoch}';
  bool _cancelled = false;

  bool get cancelled => _cancelled;

  Future<void> cancel() async {
    _cancelled = true;
    await _channel.invokeMethod<void>('cancel', {'id': id});
  }
}

const _channel = MethodChannel('net.iperon.messenger/video');

/// Прогресс сжатий по id задачи — нативная часть вызывает `progress`.
final _progress = <String, void Function(double)>{};
bool _handlerSet = false;

void _ensureHandler() {
  if (_handlerSet) return;
  _handlerSet = true;
  _channel.setMethodCallHandler((call) async {
    if (call.method != 'progress') return;
    final args = Map<String, Object?>.from(call.arguments as Map);
    final id = args['id'] as String?;
    final value = (args['progress'] as num?)?.toDouble();
    if (id != null && value != null) _progress[id]?.call(value.clamp(0.0, 1.0));
  });
}

typedef _VideoInfo = ({int width, int height, int durationMs, int bitrate, double fps, String thumb});

Future<_VideoInfo?> _info(String path, {String? thumb, int thumbAtMs = 0, int thumbSide = ChatVideoCompression.thumbSide}) async {
  final raw = await _channel.invokeMapMethod<String, Object?>('info', {
    'path': path,
    'thumb': ?thumb,
    'thumbSide': thumbSide,
    'thumbAtMs': thumbAtMs,
  });
  if (raw == null) return null;
  return (
    width: (raw['width'] as num?)?.toInt() ?? 0,
    height: (raw['height'] as num?)?.toInt() ?? 0,
    durationMs: (raw['durationMs'] as num?)?.toInt() ?? 0,
    bitrate: (raw['bitrate'] as num?)?.toInt() ?? 0,
    // 0 — неизвестно.
    fps: (raw['fps'] as num?)?.toDouble() ?? 0,
    thumb: raw['thumb'] as String? ?? '',
  );
}

Future<Directory> _editorDir() async {
  final dir = Directory(p.join((await getTemporaryDirectory()).path, 'video_edit'));
  await dir.create(recursive: true);
  return dir;
}

int _editorSeq = 0;

/// Превью видео до отправки (миниатюра в листе подписи и редактор): кадр в
/// момент [atMs], длительность и размеры. `null` — не прочиталось.
Future<({String thumb, int durationMs, int width, int height})?> chatVideoPreview(String path, {int atMs = 0}) async {
  try {
    final thumb = p.join((await _editorDir()).path, 'preview_${DateTime.now().microsecondsSinceEpoch}_${_editorSeq++}.jpg');
    final info = await _info(path, thumb: thumb, thumbAtMs: atMs);
    if (info == null) return null;
    return (thumb: info.thumb, durationMs: info.durationMs, width: info.width, height: info.height);
  } catch (e, s) {
    getIt.get<Logger>().handle(e, s, 'chatVideoPreview: $path');
    return null;
  }
}

/// Кадры для ленты редактора: [count] штук равномерно по длине, не больше
/// [side] пикселей по стороне; не получившийся кадр — пустая строка.
Future<List<String>> chatVideoFrames(String path, {int count = 10, int side = 160}) async {
  try {
    final prefix = p.join((await _editorDir()).path, 'frame_${DateTime.now().microsecondsSinceEpoch}_${_editorSeq++}');
    final frames = await _channel.invokeListMethod<String>('frames', {'path': path, 'count': count, 'side': side, 'prefix': prefix});
    return frames ?? const [];
  } catch (e, s) {
    getIt.get<Logger>().handle(e, s, 'chatVideoFrames: $path');
    return const [];
  }
}

/// Кадрирует и поворачивает кадр-превью [path] (кадр исходника, как он
/// показывается) по [edit] и перезаписывает его JPEG не больше
/// [ChatVideoCompression.thumbSide] по стороне. `false` — не вышло.
Future<bool> _reframeThumb(String path, ChatVideoEdit edit) async {
  ui.Codec? codec;
  ui.Image? image;
  ui.Image? out;
  try {
    codec = await ui.instantiateImageCodec(await File(path).readAsBytes());
    image = (await codec.getNextFrame()).image;
    final crop = edit.crop ?? const Rect.fromLTWH(0, 0, 1, 1);
    final src = Rect.fromLTWH(crop.left * image.width, crop.top * image.height, crop.width * image.width, crop.height * image.height);
    final scale = math.min(1.0, ChatVideoCompression.thumbSide / math.max(src.width, src.height));
    final width = math.max(1, (src.width * scale).round());
    final height = math.max(1, (src.height * scale).round());
    final quarter = edit.rotation % 180 != 0;
    final outWidth = quarter ? height : width;
    final outHeight = quarter ? width : height;

    final recorder = ui.PictureRecorder();
    // Поворот вокруг центра; в координатах Flutter (y вниз) положительный
    // угол — по часовой.
    ui.Canvas(recorder)
      ..translate(outWidth / 2, outHeight / 2)
      ..rotate(edit.rotation * math.pi / 180)
      ..drawImageRect(
        image,
        src,
        Rect.fromCenter(center: Offset.zero, width: width.toDouble(), height: height.toDouble()),
        ui.Paint()..filterQuality = ui.FilterQuality.medium,
      );
    out = await recorder.endRecording().toImage(outWidth, outHeight);
    final png = await out.toByteData(format: ui.ImageByteFormat.png);
    if (png == null) return false;
    final jpeg = await FlutterImageCompress.compressWithList(
      png.buffer.asUint8List(),
      minWidth: outWidth,
      minHeight: outHeight,
      quality: 75,
      autoCorrectionAngle: false,
    );
    await File(path).writeAsBytes(jpeg, flush: true);
    return true;
  } catch (e, s) {
    getIt.get<Logger>().handle(e, s, '_reframeThumb: $path');
    return false;
  } finally {
    out?.dispose();
    image?.dispose();
    codec?.dispose();
  }
}

/// Кадрирование для нативной части: [left, top, width, height] долями.
List<double> _cropOf(ChatVideoEdit edit) {
  final crop = edit.crop ?? const Rect.fromLTWH(0, 0, 1, 1);
  return [crop.left, crop.top, crop.width, crop.height];
}

int _capBitrate(int target, int source) => source > 0 && source < target ? source : target;

/// Нужно ли сжимать: кадр больше [ChatVideoQuality.shortSide], битрейт выше
/// [ChatVideoQuality.keepBitrate] или больше 30 к/с.
bool _needsCompression(_VideoInfo info, ChatVideoQuality quality) {
  final short = info.width < info.height ? info.width : info.height;
  return short > quality.shortSide ||
      info.bitrate > quality.keepBitrate ||
      info.bitrate == 0 ||
      info.fps > ChatVideoCompression.maxFps + 0.5;
}

/// Готовит видео [source] к отправке в качестве [quality] с правками [edit]
/// из редактора; [onProgress] — доля 0..1 сжатия.
/// `null` — не удалось прочитать видео (тогда отправляем исходник как есть);
/// [ChatVideoCancelled] — пользователь отменил.
Future<PreparedVideo?> prepareChatVideo(
  String source, {
  ChatVideoQuality quality = ChatVideoQuality.standard,
  ChatVideoEdit? edit,
  ChatVideoJob? job,
  void Function(double)? onProgress,
}) async {
  _ensureHandler();
  job ??= ChatVideoJob();
  try {
    final dir = await chatMediaOutputDir();
    final thumbPath = p.join(dir.path, '${job.id}_thumb.jpg');
    // Кадрирование / поворот: обложку берём из исходника (крупнее — после
    // кадрирования останется часть) и кадрируем здесь же, а не из результата
    // сжатия — не зависим от того, каким вышел первый кадр.
    final reframed = edit != null && edit.changesFrame;
    final crop = edit?.crop ?? const Rect.fromLTWH(0, 0, 1, 1);
    final original = await _info(
      source,
      thumb: thumbPath,
      thumbAtMs: edit?.thumbAtMs ?? 0,
      thumbSide: reframed
          ? (ChatVideoCompression.thumbSide / math.min(crop.width, crop.height)).ceil().clamp(ChatVideoCompression.thumbSide, 1280)
          : ChatVideoCompression.thumbSide,
    );
    if (original == null) return null;

    // Обрезка и «без звука» — только перекодированием, даже небольшого видео.
    final edited = edit?.changesVideo ?? false;
    var thumb = original.thumb;
    if (reframed && thumb.isNotEmpty && !await _reframeThumb(thumb, edit)) thumb = '';
    var path = source;
    var info = original;
    if (edited || _needsCompression(original, quality)) {
      final out = p.join(dir.path, '${job.id}.mp4');
      // Короткая сторона — уже кадрированного кадра.
      final frame =
          edit?.frameSize(original.width, original.height) ?? (width: original.width.toDouble(), height: original.height.toDouble());
      final short = (frame.width < frame.height ? frame.width : frame.height).round();
      if (onProgress != null) _progress[job.id] = onProgress;
      Future<void> compress({required bool hevc}) => _channel.invokeMethod<String>('compress', {
        'id': job!.id,
        'path': source,
        'out': out,
        // Меньше нужного не растягиваем — только снижаем битрейт.
        'shortSide': short > quality.shortSide ? quality.shortSide : 0,
        // Небольшое видео пережимаем из-за правок или частоты кадров —
        // битрейт не выше исходного, файл не должен вырасти.
        'bitrate': _capBitrate(hevc ? quality.bitrate : quality.h264Bitrate, original.bitrate),
        'codec': hevc ? 'hevc' : 'h264',
        'maxFps': ChatVideoCompression.maxFps,
        if (edit != null && edited) ...{'startMs': edit.startMs, 'endMs': edit.endMs, 'mute': edit.mute},
        if (edit != null && edit.changesFrame) ...{'crop': _cropOf(edit), 'rotation': edit.rotation},
      });
      try {
        try {
          await compress(hevc: true);
        } on PlatformException catch (e) {
          if (e.code == 'cancelled' || job.cancelled) rethrow;
          getIt.get<Logger>().warning('prepareChatVideo: HEVC недоступен (${e.code}: ${e.message}), сжимаем в H.264');
          onProgress?.call(0);
          await compress(hevc: false);
        }
      } on PlatformException catch (e) {
        if (e.code == 'cancelled' || job.cancelled) throw const ChatVideoCancelled();
        rethrow;
      } finally {
        _progress.remove(job.id);
      }
      if (job.cancelled) throw const ChatVideoCancelled();
      // Сжатое вышло больше исходника — отправляем исходник (если правок нет).
      if (edited || await File(out).length() < await File(source).length()) {
        path = out;
        info = await _info(out) ?? original;
      } else {
        File(out).delete().ignore();
      }
    }
    onProgress?.call(1);

    final thumbExists = thumb.isNotEmpty && await File(thumb).exists();
    return PreparedVideo(
      path: path,
      width: info.width,
      height: info.height,
      duration: (info.durationMs / 1000).ceil(),
      size: await File(path).length(),
      thumbPath: thumbExists ? thumb : '',
      thumbhash: thumbExists ? await chatThumbhash(await File(thumb).readAsBytes()) : '',
    );
  } on ChatVideoCancelled {
    rethrow;
  } catch (e, s) {
    getIt.get<Logger>().handle(e, s, 'prepareChatVideo: $source');
    return null;
  }
}
