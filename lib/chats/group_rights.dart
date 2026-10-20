import '../models.dart' as models;

/// Права в группе (подэтап 3.2, docs/plans/chats-groups.md): одна функция на
/// действие — их же зовут экраны (прячут недоступное) и тест общей таблицы
/// `test/chats/fixtures/group_rights_cases.json` (байт-в-байт как на сервере,
/// `services/chats_groups_rights.go`). Решает всё равно сервер — клиент только
/// не показывает кнопку, которая получит отказ. Владелец имеет все права
/// всегда.

/// Наши права в чате: владелец — все; админ — из диалога ([models.Chat.myRights],
/// сервер), а если их там нет (демо) — по участнику «Вы».
models.ChatAdminRights myChatRights(models.Chat chat, List<models.ChatMember> members) {
  if (chat.myRole == models.ChatRole.owner) return models.ChatAdminRights.all;
  if (chat.myRole != models.ChatRole.admin) return const models.ChatAdminRights();
  return chat.myRights ?? members.where((m) => m.isSelf).firstOrNull?.effectiveRights ?? const models.ChatAdminRights();
}

/// Можно менять роль / исключить / заблокировать [target] (только «Чтение» и
/// «Запись»; нужно право блокировать).
bool canRestrictMember(models.Chat chat, List<models.ChatMember> members, models.ChatMember target) =>
    !target.isSelf &&
    (target.role == models.ChatRole.reader || target.role == models.ChatRole.writer) &&
    myChatRights(chat, members).banUsers;

/// Можно назначить [target] админом или изменить его права: нужно право
/// назначать админов; чужого админа — только если наши права не уже его
/// (владелец — любого). Владельца и админов сообщества в его чате — нельзя
/// (их права меняются в сообществе).
bool canPromoteMember(models.Chat chat, List<models.ChatMember> members, models.ChatMember target) {
  if (target.isSelf || target.role == models.ChatRole.owner || target.fromCommunity) return false;
  final mine = myChatRights(chat, members);
  if (!mine.addAdmins) return false;
  return target.role != models.ChatRole.admin || chat.myRole == models.ChatRole.owner || mine.covers(target.rights);
}

/// «Сохранить» права [requested] админу [target]: можно его назначать и
/// выдаваемое не шире наших прав (иначе сервер — «rightsTooWide»).
bool canSetAdmin(models.Chat chat, List<models.ChatMember> members, models.ChatMember target, models.ChatAdminRights requested) =>
    canPromoteMember(chat, members, target) && myChatRights(chat, members).covers(requested);

/// «Снять админа» [target]: право назначать админов, и (мы владелец или наши
/// права не уже его).
bool canRemoveAdmin(models.Chat chat, List<models.ChatMember> members, models.ChatMember target) {
  if (target.isSelf || target.role != models.ChatRole.admin || target.fromCommunity) return false;
  final mine = myChatRights(chat, members);
  return mine.addAdmins && (chat.myRole == models.ChatRole.owner || mine.covers(target.rights));
}

/// «Изменить» (название, описание, фото, роль по умолчанию) — право
/// changeInfo.
bool canEditChatInfo(models.Chat chat, List<models.ChatMember> members) => myChatRights(chat, members).changeInfo;

/// Удалить у всех чужое сообщение — право deleteMessages.
bool canDeleteOthers(models.Chat chat, List<models.ChatMember> members) => myChatRights(chat, members).deleteMessages;

/// Закрепить / открепить у всех — право pinMessages.
bool canPinForAll(models.Chat chat, List<models.ChatMember> members) => myChatRights(chat, members).pinMessages;

/// «Заблокированные»: смотреть и разблокировать — право banUsers.
bool canUnbanMembers(models.Chat chat, List<models.ChatMember> members) => myChatRights(chat, members).banUsers;

/// Добавить заблокированного (он при этом разблокируется) — право banUsers;
/// без него сервер вернёт его в restricted.
bool canAddBanned(models.Chat chat, List<models.ChatMember> members) => myChatRights(chat, members).banUsers;

/// «Передать владение» [target]: только владелец и не себе.
bool canTransferOwnership(models.Chat chat, models.ChatMember target) => chat.myRole == models.ChatRole.owner && !target.isSelf;

/// Звание себе ([target] — мы): только владелец (админу звание задаёт
/// назначивший), не в чате сообщества.
bool canSetOwnRank(models.Chat chat, models.ChatMember target) =>
    chat.myRole == models.ChatRole.owner && target.isSelf && !target.fromCommunity;

/// «Заблокировать пользователя» в «Заблокированных» — и того, кто не в группе:
/// право блокировать.
bool canBanNonMember(models.Chat chat, List<models.ChatMember> members) => myChatRights(chat, members).banUsers;

/// Можно писать в группу: роль не ниже «Запись» (READER только читает).
bool canSendInGroup(models.ChatRole role) => role != models.ChatRole.reader;

/// Ссылки-приглашения и заявки на вступление (подэтап 3.3): право
/// приглашать (inviteUsers; владелец — всегда).
bool canInviteUsers(models.Chat chat, List<models.ChatMember> members) => myChatRights(chat, members).inviteUsers;

/// «Добавить участников» в группу: в режиме «Только админы»
/// ([models.ChatJoinMode.admins]) — с правом приглашать, в остальных — любой
/// участник.
bool canAddGroupMembers(models.Chat chat, List<models.ChatMember> members) =>
    chat.isMember && (chat.joinMode != models.ChatJoinMode.admins || canInviteUsers(chat, members));
