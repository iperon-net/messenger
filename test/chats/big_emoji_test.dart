import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/big_emoji.dart';

void main() {
  test('только эмодзи — их число', () {
    expect(bigEmojiCount('😀'), 1);
    expect(bigEmojiCount('👍🏽❤️'), 2);
    expect(bigEmojiCount(' 👨‍👩‍👧 🇷🇺 1️⃣ '), 3);
    expect(bigEmojiCount('🏴󠁧󠁢󠁳󠁣󠁴󠁿'), 1);
  });

  test('текст, цифры и больше трёх — не крупные', () {
    expect(bigEmojiCount('привет 😀'), 0);
    expect(bigEmojiCount('1'), 0);
    expect(bigEmojiCount('#'), 0);
    expect(bigEmojiCount('😀😀😀😀'), 0);
    expect(bigEmojiCount(''), 0);
    expect(bigEmojiCount('   '), 0);
  });
}
