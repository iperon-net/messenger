import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_media_cleanup.dart';
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;

void main() {
  // Ссылка на файл ищется по байтам cdnID внутри сохранённого protobuf.
  test('cdnID найден в сериализованном содержимом сообщения', () {
    final cdnID = List<int>.generate(12, (i) => i + 100);
    final other = List<int>.generate(12, (i) => 200 - i);
    final content = pb.MessageContent(
      text: 'фото',
      media: [pb.MessageMedia(cdnID: cdnID, width: 10, height: 10)],
    ).writeToBuffer();
    expect(ChatsMediaCleanup.containsBytes(content, cdnID), isTrue);
    expect(ChatsMediaCleanup.containsBytes(content, other), isFalse);
    expect(ChatsMediaCleanup.containsBytes(const [], cdnID), isFalse);
  });
}
