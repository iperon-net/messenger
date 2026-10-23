import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/media_prepare.dart';
import 'package:thumbhash/thumbhash.dart' as th;

void main() {
  // Однотонная картинка 8×8 → настоящий ThumbHash.
  final rgba = Uint8List.fromList([
    for (var i = 0; i < 8 * 8; i++) ...[200, 120, 40, 255],
  ]);
  final thumbhash = base64Encode(th.rgbaToThumbHash(8, 8, rgba));

  test('thumbhashImage: один провайдер на строку — без повторного декода и мигания', () {
    final first = thumbhashImage(thumbhash);
    expect(first, isNotNull);
    expect(identical(thumbhashImage(thumbhash), first), isTrue);
  });

  test('thumbhashImage: пусто и мусор — null', () {
    expect(thumbhashImage(''), isNull);
    expect(thumbhashImage('не base64'), isNull);
  });
}
