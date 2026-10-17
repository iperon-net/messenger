import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/components/chats/message_bubble.dart' show chatNoForwardsServiceText, noForwardsRequestPending;
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;

void main() {
  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);

  models.Message map(int id, pb.MessageContent content, {List<int>? from, DateTime? date}) => messageFromPb(
    pb.ChatMessage(
      chatID: List<int>.filled(12, 9),
      messageID: Int64(id),
      fromUserID: from ?? peer,
      date: Int64((date ?? DateTime.now()).millisecondsSinceEpoch),
      content: content,
    ),
    chatID: 'c',
    myUserID: me,
    readOutboxMaxID: 0,
    isSelf: false,
    peerName: 'Анна',
  );

  test('служебные защиты содержимого: текст', () async {
    final t = await AppLocale.ru.build();
    final on = map(1, pb.MessageContent(noForwards: pb.MessageNoForwards(prevValue: false, newValue: true)));
    expect(on.service, isTrue);
    expect(on.noForwardsChange, isTrue);
    String text(models.Message m) => chatNoForwardsServiceText(
      t,
      change: m.noForwardsChange,
      prev: m.noForwardsPrev,
      refusal: m.noForwardsRequestID.isNotEmpty,
      outgoing: m.outgoing,
      name: m.senderName,
    );
    expect(text(on), 'Анна запретил(а) копирование и пересылку в этом чате');
    final refused = map(
      3,
      pb.MessageContent(noForwards: pb.MessageNoForwards(prevValue: true, newValue: true, requestID: Int64(2))),
      from: me,
    );
    expect(text(refused), 'Вы отклонили запрос разрешить копирование');
    final request = map(2, pb.MessageContent(noForwardsRequest: pb.MessageNoForwardsRequest(prevValue: true)));
    expect(request.noForwardsRequest, isTrue);
    expect(text(request), 'Анна просит разрешить копирование и пересылку');
  });

  test('запрос ждёт ответа: не мой, не старше суток, без ответа в ленте', () {
    final request = map(2, pb.MessageContent(noForwardsRequest: pb.MessageNoForwardsRequest(prevValue: true)));
    expect(noForwardsRequestPending(request, [request]), isTrue);
    final answer = map(
      3,
      pb.MessageContent(noForwards: pb.MessageNoForwards(prevValue: true, requestID: Int64(2))),
      from: me,
    );
    expect(noForwardsRequestPending(request, [request, answer]), isFalse);
    final old = map(
      4,
      pb.MessageContent(noForwardsRequest: pb.MessageNoForwardsRequest(prevValue: true)),
      date: DateTime.now().subtract(const Duration(days: 2)),
    );
    expect(noForwardsRequestPending(old, [old]), isFalse);
    final mine = map(5, pb.MessageContent(noForwardsRequest: pb.MessageNoForwardsRequest(prevValue: true)), from: me);
    expect(noForwardsRequestPending(mine, [mine]), isFalse);
  });
}
