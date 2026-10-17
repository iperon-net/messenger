import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;

void main() {
  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);

  pb.ChatMessage pin({required List<int> from}) => pb.ChatMessage(
    chatID: List<int>.filled(12, 9),
    messageID: Int64(5),
    fromUserID: from,
    date: Int64(1000),
    content: pb.MessageContent(pin: pb.MessagePin(messageID: Int64(3))),
  );

  test('«закрепил сообщение» — служебное со ссылкой на закреплённое', () {
    final message = messageFromPb(
      pin(from: peer),
      chatID: 'c',
      myUserID: me,
      readOutboxMaxID: 0,
      isSelf: false,
      peerName: 'Анна',
    );
    expect(message.service, isTrue);
    expect(message.pinnedMessageID, '3');
    expect(message.senderName, 'Анна');
    expect(skipsUnread(pin(from: peer).content), isTrue);
  });

  test('превью в списке чатов — текст закреплённого', () {
    final pinned = pb.ChatMessage(content: pb.MessageContent(text: 'очень длинный текст закреплённого сообщения\nвторая строка'));
    final last = lastMessageFromPb(
      pin(from: me),
      myUserID: me,
      readOutboxMaxID: 0,
      isSelf: false,
      pinned: pinned,
    );
    expect(last.pin, isTrue);
    expect(last.outgoing, isTrue);
    expect(last.pinText, 'очень длинный текст закреплённ…');
    expect(lastMessageFromPb(pin(from: me), myUserID: me, readOutboxMaxID: 0, isSelf: false).pinText, '');
  });

  test('закреплено только у меня — только у закреплённого', () {
    final text = pb.ChatMessage(
      messageID: Int64(3),
      fromUserID: me,
      content: pb.MessageContent(text: 'привет'),
    );
    pinnedOnlyMe({required bool pinned, required bool onlyMe}) => messageFromPb(
      text,
      chatID: 'c',
      myUserID: me,
      readOutboxMaxID: 0,
      isSelf: false,
      pinned: pinned,
      pinnedOnlyMe: onlyMe,
    ).pinnedOnlyMe;
    expect(pinnedOnlyMe(pinned: true, onlyMe: true), isTrue);
    expect(pinnedOnlyMe(pinned: true, onlyMe: false), isFalse);
    expect(pinnedOnlyMe(pinned: false, onlyMe: true), isFalse);
  });
}
