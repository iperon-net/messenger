import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_media.dart';

void main() {
  group('OutboxMedia', () {
    test('encode → decode', () {
      const media = [OutboxMedia(path: 'a.jpg'), OutboxMedia(path: 'b.mp4', thumb: 'b_thumb.jpg')];
      final decoded = OutboxMedia.decode(OutboxMedia.encode(media));
      expect(decoded.map((m) => (m.path, m.thumb)), [('a.jpg', ''), ('b.mp4', 'b_thumb.jpg')]);
      expect(OutboxMedia.names(OutboxMedia.encode(media)), ['a.jpg', 'b.mp4', 'b_thumb.jpg']);
    });

    test('пусто и мусор — без вложений', () {
      expect(OutboxMedia.encode(const []), '');
      expect(OutboxMedia.decode(''), isEmpty);
      expect(OutboxMedia.decode('{not json'), isEmpty);
    });
  });

  test('MIME по расширению', () {
    expect(chatMediaContentType('/x/photo.JPG'), 'image/jpeg');
    expect(chatMediaContentType('voice_1.m4a'), 'audio/mp4');
    expect(chatMediaContentType('clip.mov'), 'video/quicktime');
    expect(chatMediaContentType('archive.zip'), 'application/octet-stream');
    expect(chatMediaContentType('noext'), 'application/octet-stream');
  });

  test('волна: 0..31 → 0..255', () {
    expect(waveformToPb([0, 1, 31, 40, -3]), [0, 8, 248, 248, 0]);
  });

  test('прогресс загрузки — доли файлов', () {
    expect(uploadedBytes(done: 0, current: 1000, sent: 0, total: 1016), 0);
    expect(uploadedBytes(done: 0, current: 1000, sent: 508, total: 1016), 500);
    expect(uploadedBytes(done: 2000, current: 1000, sent: 1016, total: 1016), 3000);
    expect(uploadedBytes(done: 2000, current: 1000, sent: 0, total: 0), 2000);
  });
}
