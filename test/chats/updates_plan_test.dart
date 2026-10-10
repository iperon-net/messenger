import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/updates_plan.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;

/// Журнал обновлений чатов (pts): пропуск повторов, применение по порядку,
/// дыры — через GET_DIFFERENCE.
void main() {
  group('ptsAction', () {
    test('повтор — пропуск, следующий — применить, дальше — дыра', () {
      expect(ptsAction(10, 9), PtsAction.skip);
      expect(ptsAction(10, 10), PtsAction.skip);
      expect(ptsAction(10, 11), PtsAction.apply);
      expect(ptsAction(10, 13), PtsAction.gap);
    });

    test('pts 0 — вне журнала, применяется', () {
      expect(ptsAction(10, 0), PtsAction.apply);
    });
  });

  group('planUpdates', () {
    test('подряд идущие применяются, pts сдвигается', () {
      final plan = planUpdates(5, [6, 7, 8]);
      expect(plan.apply, [0, 1, 2]);
      expect(plan.pts, 8);
      expect(plan.gap, isFalse);
    });

    test('ответ и push с теми же обновлениями — второй раз ничего', () {
      final first = planUpdates(5, [6, 7], statePts: 7);
      final second = planUpdates(first.pts, [6, 7], statePts: 7);
      expect(second.apply, isEmpty);
      expect(second.pts, 7);
      expect(second.gap, isFalse);
    });

    test('неупорядоченная пачка — по возрастанию pts', () {
      final plan = planUpdates(5, [8, 6, 7]);
      expect(plan.apply, [1, 2, 0]);
      expect(plan.pts, 8);
    });

    test('дыра посреди пачки: до неё применяем, остальное — догон', () {
      final plan = planUpdates(5, [6, 8, 9]);
      expect(plan.apply, [0]);
      expect(plan.pts, 6);
      expect(plan.gap, isTrue);
    });

    test('дыра сразу', () {
      final plan = planUpdates(5, [7]);
      expect(plan.apply, isEmpty);
      expect(plan.pts, 5);
      expect(plan.gap, isTrue);
    });

    test('state.pts впереди применённого — дыра', () {
      final plan = planUpdates(5, [6], statePts: 9);
      expect(plan.apply, [0]);
      expect(plan.gap, isTrue);
    });

    test('пустая пачка с state.pts == нашему — ничего', () {
      final plan = planUpdates(5, const [], statePts: 5);
      expect(plan.apply, isEmpty);
      expect(plan.pts, 5);
      expect(plan.gap, isFalse);
    });

    test('частично повторная пачка', () {
      final plan = planUpdates(6, [5, 6, 7]);
      expect(plan.apply, [2]);
      expect(plan.pts, 7);
    });
  });

  group('маппинг', () {
    final me = List<int>.filled(12, 1);
    final peer = List<int>.filled(12, 2);

    test('hex id туда и обратно; local id — не hex', () {
      expect(idHex(idBytes('0a0b0c')), '0a0b0c');
      expect(idBytes('local:42'), isEmpty);
      expect(randomIDOfLocal(localMessageID(42)), 42);
      expect(serverMessageID(localMessageID(42)), isNull);
      expect(serverMessageID('17'), 17);
    });

    test('✓ / ✓✓ исходящего и «Избранное»', () {
      expect(outgoingStatus(messageID: 5, readOutboxMaxID: 4, isSelf: false), models.MessageStatus.sent);
      expect(outgoingStatus(messageID: 5, readOutboxMaxID: 5, isSelf: false), models.MessageStatus.read);
      expect(outgoingStatus(messageID: 5, readOutboxMaxID: 0, isSelf: true), models.MessageStatus.read);
    });

    test('mutedUntil: 0, навсегда, срок', () {
      final now = DateTime(2026, 10, 9);
      expect(mutedFromPb(0, now).muted, isFalse);
      final forever = mutedFromPb(mutedForever, now);
      expect(forever.muted, isTrue);
      expect(forever.until, isNull);
      final later = now.add(const Duration(hours: 1));
      expect(mutedFromPb(later.millisecondsSinceEpoch, now).until, later);
      expect(mutedFromPb(now.subtract(const Duration(hours: 1)).millisecondsSinceEpoch, now).muted, isFalse);
      expect(mutedToPb(true, null), mutedForever);
      expect(mutedToPb(false, later), 0);
    });

    test('сообщение: текст, разметка, ответ, исходящее', () {
      final content = textContent(
        text: 'привет мир',
        entities: const [models.MessageEntity(type: models.MessageEntityType.italic, offset: 7, length: 3)],
        reply: const models.MessageReply(messageID: '3', senderName: ''),
      );
      expect(content.entities.single.type, pb.MessageEntity_Type.ITALIC);
      expect(content.replyTo.messageID, Int64(3));

      final replied = pb.ChatMessage(
        messageID: Int64(3),
        fromUserID: peer,
        content: pb.MessageContent(text: 'исходное'),
      );
      final message = messageFromPb(
        pb.ChatMessage(messageID: Int64(4), fromUserID: me, date: Int64(1000), editDate: Int64(2000), content: content),
        chatID: 'c',
        myUserID: me,
        readOutboxMaxID: 3,
        isSelf: false,
        replied: replied,
        peerName: 'Анна',
      );
      expect(message.id, '4');
      expect(message.outgoing, isTrue);
      expect(message.status, models.MessageStatus.sent);
      expect(message.edited, isTrue);
      expect(message.entities.single.type, models.MessageEntityType.italic);
      expect(message.reply?.text, 'исходное');
      expect(message.reply?.senderName, 'Анна');
    });
  });
}
