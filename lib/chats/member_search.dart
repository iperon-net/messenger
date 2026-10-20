import '../models.dart' as models;

/// Поиск по участникам чата (профиль → «Участники», выбор модератора). Имена
/// на сервере зашифрованы, поэтому сервер ищет только по открытому
/// `@username` (по началу), а по имени — клиент, среди тех, чьи имена у него
/// есть: админы, недавно активные, контакты (см. «Участники больших
/// сообществ» в docs/plans/chats-groups-channels.md).

/// Запрос без пробелов по краям и в нижнем регистре; пусто — поиска нет.
String normalizeMemberQuery(String query) => query.trim().toLowerCase();

/// [member] подходит под [query] (уже [normalizeMemberQuery]): «@…» — только
/// по началу username; иначе ещё и по началу любого слова имени, если имя
/// можно искать ([byName]).
bool memberMatches(models.ChatMember member, String query, {required bool byName}) {
  if (query.isEmpty) return true;
  final username = member.username.toLowerCase();
  if (query.startsWith('@')) {
    final name = query.substring(1);
    return name.isNotEmpty && username.startsWith(name);
  }
  if (username.isNotEmpty && username.startsWith(query)) return true;
  if (!byName) return false;
  final name = member.name.toLowerCase();
  return name.startsWith(query) || name.split(RegExp(r'\s+')).any((word) => word.startsWith(query));
}

/// Локальный список (например, «Заблокированные»), где имена известны все:
/// подходящие под [query] по имени или `@username`.
List<models.ChatMember> filterMembers(List<models.ChatMember> members, String query) {
  final q = normalizeMemberQuery(query);
  if (q.isEmpty) return members;
  return [
    for (final m in members)
      if (memberMatches(m, q, byName: true)) m,
  ];
}
