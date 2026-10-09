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
}
