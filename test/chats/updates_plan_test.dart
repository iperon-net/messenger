import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/updates_plan.dart';
import 'package:messenger/i18n/translations.g.dart';
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

  group('planChatUpdates — журналы групп', () {
    ({String chatID, int chatPts}) u(String chatID, int chatPts) => (chatID: chatID, chatPts: chatPts);

    test('порядок по chatPts внутри чата, чаты независимы', () {
      final plan = planChatUpdates({'a': 5, 'b': 1}, [u('a', 7), u('b', 2), u('a', 6), u('b', 3)]);
      expect(plan.chats['a']!.apply, [2, 0]);
      expect(plan.chats['a']!.pts, 7);
      expect(plan.chats['b']!.apply, [1, 3]);
      expect(plan.chats['b']!.pts, 3);
      expect(plan.gaps, isEmpty);
      expect(plan.unknown, isEmpty);
    });

    test('повтор (ответ + push) — пропуск', () {
      final plan = planChatUpdates({'a': 7}, [u('a', 6), u('a', 7)]);
      expect(plan.chats['a']!.apply, isEmpty);
      expect(plan.chats['a']!.pts, 7);
      expect(plan.chats['a']!.gap, isFalse);
    });

    test('дыра в одном чате не мешает другому', () {
      final plan = planChatUpdates({'a': 5, 'b': 1}, [u('a', 6), u('a', 8), u('b', 2)]);
      expect(plan.chats['a']!.apply, [0]);
      expect(plan.chats['a']!.pts, 6);
      expect(plan.gaps, ['a']);
      expect(plan.chats['b']!.apply, [2]);
      expect(plan.chats['b']!.gap, isFalse);
    });

    test('группа неизвестна (dialogNew ещё не пришёл) — не применяем', () {
      final plan = planChatUpdates({'a': 0}, [u('x', 1), u('a', 1), u('x', 2)]);
      expect(plan.unknown, [0, 2]);
      expect(plan.chats.keys, ['a']);
      expect(plan.chats['a']!.apply, [1]);
    });

    test('новая группа с pts 0 — с первого', () {
      final plan = planChatUpdates({'a': 0}, [u('a', 2), u('a', 1)]);
      expect(plan.chats['a']!.apply, [1, 0]);
      expect(plan.chats['a']!.pts, 2);
    });

    test('дыра сразу — догон, ничего не применено', () {
      final plan = planChatUpdates({'a': 3}, [u('a', 5)]);
      expect(plan.chats['a']!.apply, isEmpty);
      expect(plan.chats['a']!.pts, 3);
      expect(plan.gaps, ['a']);
    });
  });

  group('служебные группы', () {
    late Translations t;
    setUpAll(() async => t = await AppLocale.ru.build());

    test('текст по виду и автору', () {
      final created = pb.MessageChatAction(kind: pb.MessageChatAction_Kind.CREATED, title: 'Дача');
      expect(chatActionText(t, created, outgoing: true, actor: 'Анна'), 'Вы создали группу «Дача»');
      expect(chatActionText(t, created, outgoing: false, actor: 'Анна'), 'Анна создал(а) группу «Дача»');
      final added = pb.MessageChatAction(kind: pb.MessageChatAction_Kind.ADDED);
      expect(chatActionText(t, added, outgoing: false, actor: 'Анна', names: ['Олег', 'вас']), 'Анна добавил(а) Олег, вас');
      final left = pb.MessageChatAction(kind: pb.MessageChatAction_Kind.LEFT);
      expect(chatActionText(t, left, outgoing: false, actor: 'Олег'), 'Олег вышел(а) из группы');
      final title = pb.MessageChatAction(kind: pb.MessageChatAction_Kind.TITLE_CHANGED, title: 'Дом');
      expect(chatActionText(t, title, outgoing: true, actor: ''), 'Вы изменили название группы на «Дом»');
      final photo = pb.MessageChatAction(kind: pb.MessageChatAction_Kind.PHOTO_REMOVED);
      expect(chatActionText(t, photo, outgoing: false, actor: 'Анна'), 'Анна удалил(а) фото группы');
    });

    test('служебное группы — плашка и считается непрочитанным', () {
      final content = pb.MessageContent(chatAction: pb.MessageChatAction(kind: pb.MessageChatAction_Kind.LEFT));
      expect(skipsUnread(content), isFalse);
      final message = messageFromPb(
        pb.ChatMessage(messageID: Int64(2), fromUserID: List<int>.filled(12, 2), content: content),
        chatID: 'g',
        myUserID: List<int>.filled(12, 1),
        readOutboxMaxID: 0,
        isSelf: false,
        nameOf: (_) => 'Олег',
        serviceText: 'Олег вышел(а) из группы',
      );
      expect(message.service, isTrue);
      expect(message.text, 'Олег вышел(а) из группы');
    });

    test('сообщение в группе: автор по userID, ответ — тоже', () {
      final me = List<int>.filled(12, 1);
      final anna = List<int>.filled(12, 2);
      final oleg = List<int>.filled(12, 3);
      String nameOf(List<int> userID) => sameID(userID, anna) ? 'Анна' : 'Олег';
      final replied = pb.ChatMessage(
        messageID: Int64(1),
        fromUserID: oleg,
        content: pb.MessageContent(text: 'исходное'),
      );
      final message = messageFromPb(
        pb.ChatMessage(
          messageID: Int64(2),
          fromUserID: anna,
          content: textContent(
            text: 'ответ',
            reply: const models.MessageReply(messageID: '1', senderName: ''),
          ),
        ),
        chatID: 'g',
        myUserID: me,
        readOutboxMaxID: 0,
        isSelf: false,
        replied: replied,
        nameOf: nameOf,
      );
      expect(message.senderName, 'Анна');
      expect(message.senderUserID, idHex(anna));
      expect(message.reply?.senderName, 'Олег');
      final mine = messageFromPb(
        pb.ChatMessage(
          messageID: Int64(3),
          fromUserID: me,
          content: pb.MessageContent(text: 'моё'),
        ),
        chatID: 'g',
        myUserID: me,
        readOutboxMaxID: 3,
        isSelf: false,
        nameOf: nameOf,
      );
      expect(mine.senderName, isEmpty);
      expect(mine.senderUserID, isEmpty);
      expect(mine.status, models.MessageStatus.read);
    });

    test('роль с сервера', () {
      expect(roleFromPb(pb.ChatRole.CHAT_ROLE_OWNER), models.ChatRole.owner);
      expect(roleFromPb(pb.ChatRole.CHAT_ROLE_WRITER), models.ChatRole.writer);
      expect(roleFromPb(pb.ChatRole.CHAT_ROLE_NONE), models.ChatRole.writer);
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
