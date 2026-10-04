import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:thumbhash/thumbhash.dart' as th;

import '../di.dart';
import '../logger.dart';

/// Фото, подготовленное к отправке в чат: сжатый JPEG, миниатюра и thumbhash.
///
/// Сжимаем на клиенте, потому что сервер видит только шифротекст (файл
/// шифруется своим ключом до загрузки, см. `CDNManager`) — ни пережать, ни
/// сделать превью он не может.
class PreparedPhoto {
  /// Сжатый JPEG: длинная сторона ≤ [ChatPhotoCompression.standard] / `hd`,
  /// без EXIF (там GPS), уже повёрнут по EXIF-ориентации.
  final String path;
  final int width;
  final int height;

  /// Размер [path] в байтах.
  final int size;

  /// Миниатюра (длинная сторона ≤ 320, JPEG) — отдельный маленький файл на CDN.
  final String thumbPath;

  /// ThumbHash (~25 байт, base64): размытое превью прямо в сообщении — видно
  /// мгновенно, до загрузки миниатюры.
  final String thumbhash;

  const PreparedPhoto({
    required this.path,
    required this.width,
    required this.height,
    required this.size,
    required this.thumbPath,
    required this.thumbhash,
  });
}

/// Параметры сжатия фото — как в Telegram: обычное 1280, «HD» 2560 по
/// длинной стороне, JPEG ~82.
abstract final class ChatPhotoCompression {
  static const standard = 1280;
  static const hd = 2560;
  static const quality = 82;
  static const thumbSide = 320;
  static const thumbQuality = 70;
}

/// Анимированные и прочие форматы, которые не пережимаем в JPEG (GIF потеряет
/// анимацию) — уходят как есть.
const _keepAsIs = {'.gif'};

/// Сжимает фото [source] для отправки. `null` — формат не пережимается или
/// сжать не удалось (тогда отправляем оригинал).
Future<PreparedPhoto?> prepareChatPhoto(String source, {bool hd = false}) async {
  if (_keepAsIs.contains(p.extension(source).toLowerCase())) return null;
  try {
    final dir = await _outputDir();
    final id = '${DateTime.now().microsecondsSinceEpoch}_${source.hashCode.abs()}';
    final longSide = hd ? ChatPhotoCompression.hd : ChatPhotoCompression.standard;

    final original = await _dimensions(await File(source).readAsBytes());
    final photoPath = p.join(dir.path, '$id.jpg');
    final photo = await FlutterImageCompress.compressAndGetFile(
      source,
      photoPath,
      // Плагин уменьшает, пока одна из сторон не упрётся в свой минимум
      // (никогда не увеличивает). Минимум одинаковый по обеим сторонам =
      // короткая сторона результата, тогда длинная выходит ровно [longSide] —
      // и не важно, повёрнуто ли фото по EXIF.
      minWidth: _shortSideFor(original, longSide),
      minHeight: _shortSideFor(original, longSide),
      quality: ChatPhotoCompression.quality,
      keepExif: false,
    );
    if (photo == null) return null;
    final bytes = await File(photo.path).readAsBytes();
    final size = await _dimensions(bytes);
    if (size == null) return null;

    final thumbPath = p.join(dir.path, '${id}_thumb.jpg');
    final thumb = await FlutterImageCompress.compressAndGetFile(
      photo.path,
      thumbPath,
      minWidth: _shortSideFor(size, ChatPhotoCompression.thumbSide),
      minHeight: _shortSideFor(size, ChatPhotoCompression.thumbSide),
      quality: ChatPhotoCompression.thumbQuality,
      // Уже повёрнуто и без EXIF — второй поворот не нужен.
      autoCorrectionAngle: false,
    );

    return PreparedPhoto(
      path: photo.path,
      width: size.width,
      height: size.height,
      size: bytes.length,
      thumbPath: thumb?.path ?? '',
      thumbhash: await _thumbhash(bytes),
    );
  } catch (e, s) {
    getIt.get<Logger>().handle(e, s, 'prepareChatPhoto: $source');
    return null;
  }
}

/// Короткая сторона результата, при которой длинная — не больше [longSide].
/// Размер не прочитался — ограничиваем короткую сторону, не уменьшая лишнего.
int _shortSideFor(({int width, int height})? size, int longSide) {
  if (size == null) return longSide;
  final long = math.max(size.width, size.height);
  final short = math.min(size.width, size.height);
  if (long <= longSide) return short;
  return math.max(1, (short * longSide / long).round());
}

/// Размеры картинки по заголовку, без полного декодирования.
Future<({int width, int height})?> _dimensions(Uint8List bytes) async {
  try {
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final size = (width: descriptor.width, height: descriptor.height);
    descriptor.dispose();
    buffer.dispose();
    return size;
  } catch (_) {
    return null;
  }
}

/// ThumbHash по картинке, уменьшенной до 100×100 (ограничение формата).
Future<String> _thumbhash(Uint8List jpeg) async {
  final size = await _dimensions(jpeg);
  if (size == null) return '';
  final scale = 100 / math.max(size.width, size.height);
  final codec = await ui.instantiateImageCodec(
    jpeg,
    targetWidth: math.max(1, (size.width * scale).round()),
    targetHeight: math.max(1, (size.height * scale).round()),
  );
  final frame = await codec.getNextFrame();
  final image = frame.image;
  try {
    final rgba = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (rgba == null) return '';
    return base64Encode(th.rgbaToThumbHash(image.width, image.height, rgba.buffer.asUint8List()));
  } finally {
    image.dispose();
    codec.dispose();
  }
}

/// Картинка-превью из ThumbHash (BMP в памяти) — для `Image.memory`.
Uint8List? thumbhashToBmp(String thumbhash) {
  if (thumbhash.isEmpty) return null;
  try {
    return th.rgbaToBmp(th.thumbHashToRGBA(base64Decode(thumbhash)));
  } catch (_) {
    return null;
  }
}

/// Сжатые файлы ждут загрузки здесь (temp: система может почистить, но к
/// этому моменту файл уже на CDN и в кэше скачанных).
Future<Directory> _outputDir() async {
  final dir = Directory(p.join((await getTemporaryDirectory()).path, 'chat_media'));
  if (!await dir.exists()) await dir.create(recursive: true);
  return dir;
}
