import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/demo/chats_demo_data_source.dart';
import 'package:messenger/models.dart' as models;

/// Сквозные настройки сообщества в его чатах (демо): владелец, админы и
/// блокировки сообщества действуют во всех его чатах.
void main() {
  final source = ChatsDemoDataSource.instance;

  Future<models.Chat> chat(String id) async => (await source.watchChats().first).firstWhere((c) => c.id == id);

  models.ChatMember? find(List<models.ChatMember> members, String id) => members.where((m) => m.id == id).firstOrNull;

  test('админы и владелец сообщества — в его чатах, менять их там нельзя', () async {
    final community = await source.members('coffee');
    final inChat = await source.members('coffee_guests');
    for (final m in community.where((m) => m.role == models.ChatRole.owner || m.role == models.ChatRole.admin)) {
      final there = find(inChat, m.id);
      expect(there, isNotNull, reason: m.name);
      expect(there!.role, m.role);
      expect(there.rights, m.rights);
      expect(there.fromCommunity, isTrue);
    }

    final admin = community.firstWhere((m) => m.role == models.ChatRole.admin && !m.isSelf);
    await source.removeAdmin('coffee_guests', admin.id);
    await source.setAdmin('coffee_guests', admin.id, rights: const models.ChatAdminRights());
    expect(find(await source.members('coffee_guests'), admin.id)!.rights, admin.rights);
  });

  test('новый админ сообщества сразу админ во всех его чатах', () async {
    final changed = source.watchMembersChanged('coffee_staff').first;
    final writer = (await source.members('coffee')).firstWhere((m) => m.role == models.ChatRole.writer);
    await source.setAdmin('coffee', writer.id, rights: models.ChatAdminRights.standard, rank: 'бариста');
    await changed;
    for (final id in ['coffee_news', 'coffee_staff', 'coffee_guests']) {
      final there = find(await source.members(id), writer.id);
      expect(there?.role, models.ChatRole.admin, reason: id);
      expect(there?.rank, 'бариста', reason: id);
      expect(there?.fromCommunity, isTrue, reason: id);
    }
    await source.removeAdmin('coffee', writer.id);
    final there = find(await source.members('coffee_guests'), writer.id);
    expect(there?.fromCommunity ?? false, isFalse);
  });

  test('блокировка в чате сообщества — во всём сообществе', () async {
    final target = (await source.members('coffee_guests')).firstWhere((m) => !m.fromCommunity && !m.isSelf);
    await source.removeMember('coffee_guests', target.id, ban: true);
    for (final id in ['coffee', 'coffee_news', 'coffee_staff', 'coffee_guests']) {
      expect(find(await source.members(id), target.id), isNull, reason: id);
    }
    expect(find(await source.banned('coffee'), target.id), isNotNull);
    expect(find(await source.banned('coffee_staff'), target.id), isNotNull);

    await source.unbanMember('coffee_guests', target.id);
    expect(find(await source.banned('coffee'), target.id), isNull);
  });

  test('исключение из чата сообщества оставляет в сообществе, из сообщества — убирает отовсюду', () async {
    final target = (await source.members('coffee_guests')).firstWhere((m) => !m.fromCommunity && !m.isSelf);
    final inCommunity = find(await source.members('coffee'), target.id) != null;
    await source.removeMember('coffee_guests', target.id);
    expect(find(await source.members('coffee_guests'), target.id), isNull);
    expect(find(await source.members('coffee'), target.id) != null, inCommunity);
    expect(await source.banned('coffee_guests'), isNot(contains(predicate<models.ChatMember>((m) => m.id == target.id))));

    final other = (await source.members('coffee_staff')).firstWhere((m) => !m.fromCommunity && !m.isSelf);
    if (find(await source.members('coffee'), other.id) != null) {
      await source.removeMember('coffee', other.id);
      expect(find(await source.members('coffee_staff'), other.id), isNull);
    }
  });

  test('передача владения сообществом — владелец всех его чатов', () async {
    // У чата сообщества владение не передаётся.
    final admin = (await source.members('coffee_guests')).firstWhere((m) => m.role == models.ChatRole.admin && m.fromCommunity);
    await source.transferOwnership('coffee_guests', admin.id);
    expect((await chat('coffee_guests')).myRole, models.ChatRole.owner);

    await source.transferOwnership('coffee', admin.id);
    for (final id in ['coffee_news', 'coffee_staff', 'coffee_guests']) {
      expect((await chat(id)).myRole, models.ChatRole.admin, reason: id);
      final members = await source.members(id);
      expect(find(members, admin.id)?.role, models.ChatRole.owner, reason: id);
      expect(members.where((m) => m.role == models.ChatRole.owner), hasLength(1), reason: id);
    }
  });

  test('модератор темы: без назначения админов и без блокировки в сообществе', () async {
    // «Соседи» ЖК: мы модератор (не админ сообщества).
    final members = await source.members('district_neighbors');
    final me = members.firstWhere((m) => m.isSelf);
    expect(me.role, models.ChatRole.admin);
    expect(me.fromCommunity, isFalse);
    expect(me.rights.addAdmins, isFalse);

    final target = members.firstWhere((m) => !m.isSelf && m.role == models.ChatRole.writer);
    await source.removeMember('district_neighbors', target.id, ban: true);
    expect(find(await source.members('district_neighbors'), target.id), isNotNull);
    expect(find(await source.banned('district'), target.id), isNull);

    // Админ сообщества назначает модератора — право назначать админов не выдаётся.
    final candidate = (await source.members('coffee_guests')).firstWhere((m) => !m.fromCommunity && m.role == models.ChatRole.writer);
    await source.setAdmin('coffee_guests', candidate.id, rights: models.ChatAdminRights.all);
    final moderator = find(await source.members('coffee_guests'), candidate.id)!;
    expect(moderator.role, models.ChatRole.admin);
    expect(moderator.fromCommunity, isFalse);
    expect(moderator.rights.addAdmins, isFalse);
  });

  test('настройки по умолчанию — от сообщества на лету, пока не заданы свои', () async {
    await source.setSlowMode('kuksu', 60);
    expect((await chat('kuksu_guests')).slowMode, 60);

    // Своё значение — сообщество больше не влияет.
    await source.setSlowMode('kuksu_guests', 10);
    await source.setSlowMode('kuksu', 300);
    final own = await chat('kuksu_guests');
    expect(own.slowMode, 10);
    expect(own.overrides, contains(models.ChatInheritedSetting.slowMode));

    // Совпало с сообществом — снова от него.
    await source.setSlowMode('kuksu_guests', 300);
    expect((await chat('kuksu_guests')).overrides, isEmpty);
    await source.setSlowMode('kuksu', 0);
    expect((await chat('kuksu_guests')).slowMode, 0);

    // Реакции и сброс к сообществу.
    await source.setChatReactions('kuksu_guests', models.ChatReactionsMode.none, const []);
    await source.setChatReactions('kuksu', models.ChatReactionsMode.some, const ['👍', '🔥']);
    expect((await chat('kuksu_guests')).reactionsMode, models.ChatReactionsMode.none);
    expect((await chat('kuksu_news')).reactions, ['👍', '🔥']);
    await source.resetToCommunity('kuksu_guests');
    expect((await chat('kuksu_guests')).reactionsMode, models.ChatReactionsMode.some);
  });

  test('выход и повторное вступление не возвращают исключённых', () async {
    final target = (await source.members('devs_chat')).firstWhere((m) => !m.fromCommunity && !m.isSelf);
    await source.removeMember('devs_chat', target.id);
    await source.delete('devs_chat');
    expect((await source.members('devs_chat')).any((m) => m.isSelf), isFalse);
    await source.joinChat('devs_chat');
    final members = await source.members('devs_chat');
    expect(find(members, target.id), isNull);
    expect(members.any((m) => m.isSelf), isTrue);
  });

  test('большой список — страницами: админы первыми, затем по активности', () async {
    final first = await source.membersPage('coffee_guests');
    expect(first.members, hasLength(50));
    expect(first.nextCursor, isNotEmpty);
    expect(first.total, greaterThanOrEqualTo(150));
    final staff = first.members.takeWhile((m) => m.role == models.ChatRole.owner || m.role == models.ChatRole.admin).length;
    expect(staff, greaterThan(0));
    expect(first.members.skip(staff).any((m) => m.role == models.ChatRole.owner || m.role == models.ChatRole.admin), isFalse);

    final second = await source.membersPage('coffee_guests', cursor: first.nextCursor);
    expect(second.members, hasLength(50));
    expect({for (final m in first.members) m.id}.intersection({for (final m in second.members) m.id}), isEmpty);

    // «Известных» — не весь список (у «Вакансий» Flutter Russia — 3900).
    expect((await source.members('devs_jobs')).length, lessThan(300));
  });

  test('скрытый список сообщества: не админу — только владелец и админы', () async {
    // Flutter Russia: список скрыт, мы обычный участник.
    final devs = await chat('devs_chat');
    expect(devs.membersHidden, isTrue);
    final page = await source.membersPage('devs_chat');
    expect(page.nextCursor, isEmpty);
    expect(page.members.every((m) => m.role == models.ChatRole.owner || m.role == models.ChatRole.admin), isTrue);
  });
}
