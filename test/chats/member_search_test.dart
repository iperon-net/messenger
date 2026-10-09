import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/member_search.dart';
import 'package:messenger/demo/chats_demo_data_source.dart';
import 'package:messenger/models.dart' as models;

void main() {
  const anna = models.ChatMember(id: 'a', name: 'Анна Смирнова', username: 'anna_smirnova');
  const ivan = models.ChatMember(id: 'i', name: 'Иван Козлов');

  test('memberMatches: @username по началу, имя — только если можно', () {
    expect(memberMatches(anna, normalizeMemberQuery('  Anna '), byName: false), isTrue);
    expect(memberMatches(anna, '@anna', byName: true), isTrue);
    expect(memberMatches(anna, '@smirnova', byName: true), isFalse);
    expect(memberMatches(anna, '@', byName: true), isFalse);
    // Имя — по началу любого слова.
    expect(memberMatches(anna, 'смир', byName: true), isTrue);
    expect(memberMatches(anna, 'смир', byName: false), isFalse);
    expect(memberMatches(anna, 'ирн', byName: true), isFalse);
    expect(memberMatches(ivan, 'иван к', byName: true), isTrue);
    expect(memberMatches(ivan, '@иван', byName: true), isFalse);
    expect(memberMatches(ivan, '', byName: false), isTrue);
  });

  test('поиск в списке участников: страницами, по username — среди всех', () async {
    final source = ChatsDemoDataSource.instance;
    final all = await source.membersPage('coffee', limit: 10000);
    // Участник далеко за «известными» (200 недавно активных), но с username.
    final far = all.members.skip(260).firstWhere((m) => m.username.isNotEmpty);
    final byUsername = await source.membersPage('coffee', query: '@${far.username}');
    expect(byUsername.members.map((m) => m.id), contains(far.id));

    // По имени его не найти (имя на сервере зашифровано), если это не контакт.
    final byName = await source.membersPage('coffee', query: far.name.split(' ').last, limit: 10000);
    expect(byName.members.map((m) => m.id), isNot(contains(far.id)));
    expect(byName.members, isNotEmpty);

    final none = await source.membersPage('coffee', query: 'zzzz');
    expect(none.members, isEmpty);
    expect(none.total, 0);
  });
}
