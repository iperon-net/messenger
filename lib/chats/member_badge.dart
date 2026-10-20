import '../models.dart' as models;

/// Подпись отправителя в пузыре группы справа от имени (как в Telegram):
/// звание владельца / админа, без звания — [owner] («владелец») / [admin]
/// («админ»); у остальных участников — пусто. Данные — только из локального
/// кэша участников (`ChatsDataSource.members`): кого там нет — без подписи,
/// сервер ради неё не спрашиваем.
String senderBadge(models.ChatMember member, {required String owner, required String admin}) {
  if (member.role != models.ChatRole.owner && member.role != models.ChatRole.admin) return '';
  if (member.rank.trim().isNotEmpty) return member.rank.trim();
  return member.role == models.ChatRole.owner ? owner : admin;
}

/// [senderBadge] известных участников: userID → подпись (только непустые).
Map<String, String> senderBadges(Iterable<models.ChatMember> members, {required String owner, required String admin}) => {
  for (final member in members)
    if (senderBadge(member, owner: owner, admin: admin) case final badge when badge.isNotEmpty) member.id: badge,
};
