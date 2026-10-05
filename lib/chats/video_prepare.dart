import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

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

Future<_VideoInfo?> _info(String path, {String? thumb}) async {
  final raw = await _channel.invokeMapMethod<String, Object?>('info', {
    'path': path,
    'thumb': ?thumb,
    'thumbSide': ChatVideoCompression.thumbSide,
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

/// Нужно ли сжимать: кадр больше [ChatVideoQuality.shortSide], битрейт выше
/// [ChatVideoQuality.keepBitrate] или больше 30 к/с.
bool _needsCompression(_VideoInfo info, ChatVideoQuality quality) {
  final short = info.width < info.height ? info.width : info.height;
  return short > quality.shortSide ||
      info.bitrate > quality.keepBitrate ||
      info.bitrate == 0 ||
      info.fps > ChatVideoCompression.maxFps + 0.5;
}

/// Готовит видео [source] к отправке в качестве [quality]; [onProgress] —
/// доля 0..1 сжатия.
/// `null` — не удалось прочитать видео (тогда отправляем исходник как есть);
/// [ChatVideoCancelled] — пользователь отменил.
Future<PreparedVideo?> prepareChatVideo(
  String source, {
  ChatVideoQuality quality = ChatVideoQuality.standard,
  ChatVideoJob? job,
  void Function(double)? onProgress,
}) async {
  _ensureHandler();
  job ??= ChatVideoJob();
  try {
    final dir = await chatMediaOutputDir();
    final thumbPath = p.join(dir.path, '${job.id}_thumb.jpg');
    final original = await _info(source, thumb: thumbPath);
    if (original == null) return null;

    var path = source;
    var info = original;
    if (_needsCompression(original, quality)) {
      final out = p.join(dir.path, '${job.id}.mp4');
      final short = original.width < original.height ? original.width : original.height;
      if (onProgress != null) _progress[job.id] = onProgress;
      Future<void> compress({required bool hevc}) => _channel.invokeMethod<String>('compress', {
        'id': job!.id,
        'path': source,
        'out': out,
        // Меньше нужного не растягиваем — только снижаем битрейт.
        'shortSide': short > quality.shortSide ? quality.shortSide : 0,
        'bitrate': hevc ? quality.bitrate : quality.h264Bitrate,
        'codec': hevc ? 'hevc' : 'h264',
        'maxFps': ChatVideoCompression.maxFps,
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
      // Сжатое вышло больше исходника — отправляем исходник.
      if (await File(out).length() < await File(source).length()) {
        path = out;
        info = await _info(out) ?? original;
      } else {
        File(out).delete().ignore();
      }
    }
    onProgress?.call(1);

    final thumbExists = original.thumb.isNotEmpty && await File(original.thumb).exists();
    return PreparedVideo(
      path: path,
      width: info.width,
      height: info.height,
      duration: (info.durationMs / 1000).ceil(),
      size: await File(path).length(),
      thumbPath: thumbExists ? original.thumb : '',
      thumbhash: thumbExists ? await chatThumbhash(await File(original.thumb).readAsBytes()) : '',
    );
  } on ChatVideoCancelled {
    rethrow;
  } catch (e, s) {
    getIt.get<Logger>().handle(e, s, 'prepareChatVideo: $source');
    return null;
  }
}
