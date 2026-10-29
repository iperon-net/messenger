import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/screens/report/report_common.dart';

void main() {
  const peer = '6a8764735a6cd5300e7b2e95';
  const chatID = '6ae304025418f910eb6968cc';

  models.Message message(String id, {bool outgoing = false}) =>
      models.Message(id: id, chatID: chatID, outgoing: outgoing, date: DateTime(2026));

  test('чат: только чужие серверные сообщения', () {
    const chat = models.Chat(id: chatID, type: models.ChatType.group, title: 'Группа');
    final target = ReportTarget.fromChat(chat, messages: [message('7'), message('8', outgoing: true), message('local-1')])!;
    expect(target.chatID, idBytes(chatID));
    expect(target.userID, isEmpty);
    expect(target.messageIDs, [7]);
  });

  test('секретный чат — на собеседника без содержимого', () {
    const chat = models.Chat(
      id: 'secret:$chatID',
      type: models.ChatType.private,
      title: 'Секрет',
      peerUserID: peer,
      secretStatus: models.SecretChatStatus.ready,
    );
    final target = ReportTarget.fromChat(chat, messages: [message('7')])!;
    expect(target.userID, idBytes(peer));
    expect(target.chatID, isEmpty);
    expect(target.messageIDs, isEmpty);
  });

  test('Избранное, «Iperon» и демо — некуда', () {
    expect(ReportTarget.fromChat(const models.Chat(id: chatID, type: models.ChatType.private, title: '', isSelf: true)), isNull);
    expect(
      ReportTarget.fromChat(const models.Chat(id: chatID, type: models.ChatType.private, title: '', peerUserID: models.systemUserID)),
      isNull,
    );
    expect(ReportTarget.fromChat(const models.Chat(id: 'demo-1', type: models.ChatType.group, title: '')), isNull);
  });
}
