import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/photo_edit.dart';

/// Картинка 40×20: левая половина красная, правая синяя.
Future<ui.Image> _source() {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(const Rect.fromLTWH(0, 0, 20, 20), Paint()..color = const Color(0xFFFF0000));
  canvas.drawRect(const Rect.fromLTWH(20, 0, 20, 20), Paint()..color = const Color(0xFF0000FF));
  return recorder.endRecording().toImage(40, 20);
}

Future<Color> _pixel(ui.Image image, int x, int y) async {
  final data = (await image.toByteData())!;
  final i = (y * image.width + x) * 4;
  return Color.fromARGB(data.getUint8(i + 3), data.getUint8(i), data.getUint8(i + 1), data.getUint8(i + 2));
}

void main() {
  test('crop keeps the chosen part', () async {
    final image = await applyChatPhotoEdit(await _source(), const ChatPhotoEdit(crop: Rect.fromLTWH(0.5, 0, 0.5, 1)));
    expect((image.width, image.height), (20, 20));
    expect(await _pixel(image, 10, 10), const Color(0xFF0000FF));
  });

  test('rotation 270 turns counter-clockwise', () async {
    final image = await applyChatPhotoEdit(await _source(), const ChatPhotoEdit(rotation: 270));
    expect((image.width, image.height), (20, 40));
    // Против часовой: правая (синяя) половина уходит наверх.
    expect(await _pixel(image, 10, 10), const Color(0xFF0000FF));
    expect(await _pixel(image, 10, 30), const Color(0xFFFF0000));
  });

  test('long side is capped', () async {
    final image = await applyChatPhotoEdit(await _source(), const ChatPhotoEdit(rotation: 90), maxSide: 20);
    expect((image.width, image.height), (10, 20));
  });

  test('strokes are drawn in source coordinates', () async {
    final stroke = ChatPhotoStroke(color: const Color(0xFF00FF00), width: 0.5, points: [const Offset(0.125, 0.5)]);
    final image = await applyChatPhotoEdit(await _source(), ChatPhotoEdit(strokes: [stroke]));
    expect(await _pixel(image, 5, 10), const Color(0xFF00FF00));
    expect(await _pixel(image, 35, 10), const Color(0xFF0000FF));
  });
}
