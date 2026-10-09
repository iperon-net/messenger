import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/read_receipts.dart';
import 'package:messenger/models.dart' as models;

void main() {
  final now = DateTime(2026, 10, 9, 12);
  final read = models.Message(
    id: 'm',
    chatID: 'c',
    outgoing: true,
    status: models.MessageStatus.read,
    date: now.subtract(const Duration(hours: 1)),
  );
  const private = models.Chat(id: 'p', type: models.ChatType.private, title: 'p');
  const group = models.Chat(id: 'g', type: models.ChatType.group, title: 'g', membersCount: readMarksMaxMembers);

  test('readReceiptsApply: своё прочитанное в личном и в группе до 100', () {
    expect(readReceiptsApply(private, read, now), isTrue);
    expect(readReceiptsApply(group, read, now), isTrue);
  });

  test('readReceiptsApply: не своё / не прочитано / сервисное — нет', () {
    expect(readReceiptsApply(private, read.copyWith(outgoing: false), now), isFalse);
    expect(readReceiptsApply(private, read.copyWith(status: models.MessageStatus.sent), now), isFalse);
    expect(readReceiptsApply(private, read.copyWith(service: true), now), isFalse);
  });

  test('readReceiptsApply: старше 7 дней — нет', () {
    final old = read.copyWith(date: now.subtract(readMarksExpire + const Duration(minutes: 1)));
    expect(readReceiptsApply(private, old, now), isFalse);
    expect(readReceiptsApply(group, old, now), isFalse);
  });

  test('readReceiptsApply: большая группа, канал, ветка, «Избранное» — нет', () {
    expect(readReceiptsApply(group.copyWith(membersCount: readMarksMaxMembers + 1), read, now), isFalse);
    expect(readReceiptsApply(group.copyWith(type: models.ChatType.channel), read, now), isFalse);
    expect(readReceiptsApply(group.copyWith(threadOf: 'ch'), read, now), isFalse);
    expect(readReceiptsApply(private.copyWith(isSelf: true), read, now), isFalse);
  });
}
