import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_data_source.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/chats/users_search.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;

/// Источник для поиска: люди и группы — заданные ответы (или исключения),
/// запросы запоминаются.
class _FakeSource implements ChatsDataSource {
  List<models.ChatMember> people = const [];
  List<models.Chat> chats = const [];
  Object? peopleError;
  Object? chatsError;
  final usersQueries = <String>[];
  final chatsQueries = <String>[];
  final resolved = <String>[];

  @override
  Future<List<models.ChatMember>> searchUsers(String query) async {
    usersQueries.add(query);
    if (peopleError case final error?) throw error;
    return people;
  }

  @override
  Future<List<models.Chat>> searchChats(String query) async {
    chatsQueries.add(query);
    if (chatsError case final error?) throw error;
    return chats;
  }

  @override
  Future<String> resolveLink(String path) async {
    resolved.add(path);
    return 'preview:$path';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Глобальный поиск публичных групп: когда запрос уходит на сервер, общий
// статус секции из двух запросов, разбор ответа, тап по найденной группе.
void main() {
  const club = models.Chat(id: 'g1', type: models.ChatType.group, title: 'Клуб', username: 'club_ru', membersCount: 12, isMember: false);

  group('когда искать группы', () {
    test('обычные слова, «@имя»; не номер, не «/код-фраза», не одна буква', () {
      for (final query in ['клуб', ' Ёлки палки ', 'ab', 'a bc', '@cl', '@club_ru', 'Flutter RU']) {
        expect(UsersSearch.chatsQualify(query), isTrue, reason: query);
      }
      for (final query in ['', ' ', 'к', 'a b', '/секрет', '/', '+7 909 160-00-44', '89091600044', '@', '@c', '@клуб', '!!!']) {
        expect(UsersSearch.chatsQualify(query), isFalse, reason: query);
      }
    });

    test('слова — как на сервере: нижний регистр, ё → е, только буквы и цифры', () {
      expect(UsersSearch.words('Ёлки-ПАЛКИ, club_42!'), ['елки', 'палки', 'club', '42']);
      expect(UsersSearch.words(' ,! '), isEmpty);
    });
  });

  group('статус секции', () {
    UsersSearchPart<models.ChatMember> people(UsersSearchStatus status, [List<models.ChatMember> results = const []]) =>
        (status: status, results: results);
    UsersSearchPart<models.Chat> chats(UsersSearchStatus status, [List<models.Chat> results = const []]) =>
        (status: status, results: results);

    test('люди искались — их статус главный', () {
      expect(UsersSearch.combine(people(UsersSearchStatus.done), chats(UsersSearchStatus.offline)), UsersSearchStatus.done);
      expect(UsersSearch.combine(people(UsersSearchStatus.offline), chats(UsersSearchStatus.done, [club])), UsersSearchStatus.offline);
      expect(UsersSearch.combine(people(UsersSearchStatus.flood), null), UsersSearchStatus.flood);
    });

    test('только группы: нашлись — секция, пусто / без сети — нет секции, лимит — пояснение', () {
      expect(UsersSearch.combine(null, chats(UsersSearchStatus.done, [club])), UsersSearchStatus.done);
      expect(UsersSearch.combine(null, chats(UsersSearchStatus.done)), UsersSearchStatus.idle);
      expect(UsersSearch.combine(null, chats(UsersSearchStatus.offline)), UsersSearchStatus.idle);
      expect(UsersSearch.combine(null, chats(UsersSearchStatus.flood)), UsersSearchStatus.flood);
      expect(UsersSearch.combine(null, null), UsersSearchStatus.idle);
    });
  });

  group('поиск по мере ввода', () {
    Future<List<(UsersSearchStatus, List<models.ChatMember>, List<models.Chat>)>> run(
      _FakeSource source,
      String query, {
      bool chats = true,
    }) async {
      final events = <(UsersSearchStatus, List<models.ChatMember>, List<models.Chat>)>[];
      final search = UsersSearch(chats: chats, (status, people, found) => events.add((status, people, found)));
      search.search(source, query);
      await Future<void>.delayed(UsersSearch.delay + const Duration(milliseconds: 100));
      search.cancel();
      return events;
    }

    test('обычное слово — только группы, без «ищем…»', () async {
      final source = _FakeSource()..chats = [club];
      final events = await run(source, ' клуб ');
      expect(source.usersQueries, isEmpty);
      expect(source.chatsQueries, ['клуб']);
      expect(events.first.$1, UsersSearchStatus.idle);
      expect(events.last.$1, UsersSearchStatus.done);
      expect(events.last.$3, [club]);
    });

    test('«@имя» — и люди, и группы; без групп ([chats] = false) — только люди', () async {
      const anna = models.ChatMember(id: 'u1', name: 'Анна', username: 'anna_s');
      final source = _FakeSource()
        ..people = [anna]
        ..chats = [club];
      var events = await run(source, '@anna');
      expect(source.usersQueries, ['@anna']);
      expect(source.chatsQueries, ['@anna']);
      expect(events.first.$1, UsersSearchStatus.loading);
      expect(events.last.$2, [anna]);
      expect(events.last.$3, [club]);

      events = await run(source, '@anna', chats: false);
      expect(source.chatsQueries, ['@anna'], reason: 'на «Контактах» группы не ищем');
      expect(events.last.$3, isEmpty);
    });

    test('«/код-фраза» и одна буква — на сервер не уходят', () async {
      final source = _FakeSource();
      for (final query in ['/секрет', 'к']) {
        final events = await run(source, query);
        expect(events.single.$1, UsersSearchStatus.idle);
      }
      expect(source.usersQueries, isEmpty);
      expect(source.chatsQueries, isEmpty);
    });

    test('без сети по обычному слову — секции нет, без ошибки', () async {
      final source = _FakeSource()..chatsError = const ChatsOfflineException();
      final events = await run(source, 'клуб');
      expect(events.last.$1, UsersSearchStatus.idle);
      expect(events.last.$3, isEmpty);
    });
  });

  group('найденная группа', () {
    test('разбор ответа: группа, канал; другие типы и пустой id — мимо', () {
      final found = foundChatFromPb(
        pb.Chats_FoundChat(
          chat: pb.ChatInfo(
            chatID: List<int>.filled(12, 10),
            type: pb.ChatType.CHAT_TYPE_GROUP,
            title: 'Клуб',
            username: 'club_ru',
            membersCount: 1234,
            joinMode: pb.ChatJoinMode.CHAT_JOIN_OPEN,
          ),
          member: true,
        ),
        avatarPath: '/tmp/a.jpg',
      )!;
      expect(found.id, '0a' * 12);
      expect(found.type, models.ChatType.group);
      expect((found.title, found.username, found.membersCount), ('Клуб', 'club_ru', 1234));
      expect(found.joinMode, models.ChatJoinMode.open);
      expect(found.isMember, isTrue);
      expect(found.avatarPath, '/tmp/a.jpg');

      final channel = foundChatFromPb(
        pb.Chats_FoundChat(
          chat: pb.ChatInfo(chatID: [1], type: pb.ChatType.CHAT_TYPE_CHANNEL),
        ),
      )!;
      expect(channel.type, models.ChatType.channel);
      expect(channel.isMember, isFalse);
      expect(
        foundChatFromPb(
          pb.Chats_FoundChat(
            chat: pb.ChatInfo(chatID: [1], type: pb.ChatType.CHAT_TYPE_PRIVATE),
          ),
        ),
        isNull,
      );
      expect(foundChatFromPb(pb.Chats_FoundChat(chat: pb.ChatInfo(type: pb.ChatType.CHAT_TYPE_GROUP))), isNull);
    });

    test('тап: участник — его чат, иначе — предпросмотр по имени', () async {
      final source = _FakeSource();
      expect(await resolveFoundChat(source, club.copyWith(isMember: true)), 'g1');
      expect(source.resolved, isEmpty);
      expect(await resolveFoundChat(source, club), 'preview:club_ru');
      expect(await resolveFoundChat(source, club.copyWith(username: '')), '');
    });
  });
}
