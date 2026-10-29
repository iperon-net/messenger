import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'media_prepare.dart';

/// Линия карандаша на фото. Точки — доли кадра исходника (до кадрирования и
/// поворота), толщина — доля его ширины: так рисунок не съезжает при
/// повторном кадрировании.
class ChatPhotoStroke {
  final Color color;
  final double width;
  final List<Offset> points;

  ChatPhotoStroke({required this.color, required this.width, List<Offset>? points}) : points = points ?? [];

  /// Путь линии в кадре [size]: сглаженный через середины отрезков.
  Path path(Size size) {
    final path = Path();
    if (points.isEmpty) return path;
    Offset at(int i) => Offset(points[i].dx * size.width, points[i].dy * size.height);
    path.moveTo(at(0).dx, at(0).dy);
    if (points.length == 1) return path..lineTo(at(0).dx, at(0).dy);
    for (var i = 1; i < points.length - 1; i++) {
      final mid = Offset.lerp(at(i), at(i + 1), 0.5)!;
      path.quadraticBezierTo(at(i).dx, at(i).dy, mid.dx, mid.dy);
    }
    final last = at(points.length - 1);
    return path..lineTo(last.dx, last.dy);
  }
}

/// Правки фото перед отправкой: кадрирование, поворот и рисунок.
class ChatPhotoEdit {
  /// Кадрирование — доли кадра исходника до [rotation]; `null` — весь кадр.
  final Rect? crop;

  /// Поворот по часовой стрелке после кадрирования: 0 / 90 / 180 / 270.
  final int rotation;
  final List<ChatPhotoStroke> strokes;

  const ChatPhotoEdit({this.crop, this.rotation = 0, this.strokes = const []});

  bool get isEmpty => crop == null && rotation == 0 && strokes.isEmpty;
}

/// Рисует линии [strokes] в кадре исходника размера [size].
void paintChatPhotoStrokes(Canvas canvas, Size size, List<ChatPhotoStroke> strokes) {
  for (final stroke in strokes) {
    final paint = Paint()
      ..color = stroke.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke.width * size.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    canvas.drawPath(stroke.path(size), paint);
  }
}

/// Применяет [edit] к фото [source] и сохраняет результат (PNG, длинная
/// сторона — не больше [ChatPhotoCompression.hd]; дальше его сжимает
/// [prepareChatPhoto], как любое фото). Исходник не меняется.
Future<String> renderChatPhoto(String source, ChatPhotoEdit edit) async {
  final codec = await ui.instantiateImageCodec(await File(source).readAsBytes());
  final image = (await codec.getNextFrame()).image;
  codec.dispose();
  final ui.Image result;
  try {
    result = await applyChatPhotoEdit(image, edit);
  } finally {
    image.dispose();
  }
  try {
    final bytes = await result.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) throw StateError('png encode failed');
    final dir = Directory(p.join((await getTemporaryDirectory()).path, 'photo_edits'));
    await dir.create(recursive: true);
    final file = File(p.join(dir.path, '${DateTime.now().microsecondsSinceEpoch}.png'));
    await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file.path;
  } finally {
    result.dispose();
  }
}

/// Картинка [image] с правками [edit]: кадрирование, рисунок, поворот;
/// длинная сторона — не больше [maxSide].
Future<ui.Image> applyChatPhotoEdit(ui.Image image, ChatPhotoEdit edit, {int maxSide = ChatPhotoCompression.hd}) async {
  final sourceSize = Size(image.width.toDouble(), image.height.toDouble());
  final crop = edit.crop ?? const Rect.fromLTWH(0, 0, 1, 1);
  final area = Rect.fromLTRB(
    crop.left * sourceSize.width,
    crop.top * sourceSize.height,
    crop.right * sourceSize.width,
    crop.bottom * sourceSize.height,
  );
  final scale = math.min(1.0, maxSide / math.max(area.width, area.height));
  final width = math.max(1, (area.width * scale).round());
  final height = math.max(1, (area.height * scale).round());
  final turned = edit.rotation % 180 != 0;
  final outWidth = turned ? height : width;
  final outHeight = turned ? width : height;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas
    ..translate(outWidth / 2, outHeight / 2)
    ..rotate(edit.rotation * math.pi / 180)
    ..translate(-width / 2, -height / 2)
    ..scale(width / area.width, height / area.height)
    ..translate(-area.left, -area.top)
    ..clipRect(area);
  canvas.drawImage(image, Offset.zero, Paint()..filterQuality = FilterQuality.high);
  paintChatPhotoStrokes(canvas, sourceSize, edit.strokes);
  final picture = recorder.endRecording();
  try {
    return await picture.toImage(outWidth, outHeight);
  } finally {
    picture.dispose();
  }
}
