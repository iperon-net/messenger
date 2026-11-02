import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/models/emoji_status.dart';

void main() {
  test('emoji status expires and mutes only with a duration', () {
    final expiresAt = DateTime.now().add(const Duration(hours: 4));

    expect(const EmojiStatus(emoji: '😴', doNotDisturb: true).active, isTrue);
    expect(const EmojiStatus(emoji: '😴', doNotDisturb: true).mutes, isFalse);
    expect(EmojiStatus(emoji: '😴', expiresAt: expiresAt).mutes, isFalse);
    expect(EmojiStatus(emoji: '😴', expiresAt: expiresAt, doNotDisturb: true).mutes, isTrue);

    final expired = EmojiStatus(emoji: '😴', expiresAt: DateTime.now().subtract(const Duration(seconds: 1)), doNotDisturb: true);
    expect(expired.active, isFalse);
    expect(expired.mutes, isFalse);
    expect(expired.toProto(), isNull);
  });
}
