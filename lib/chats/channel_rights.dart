import '../models.dart' as models;
import 'group_rights.dart';

/// Права в канале (подэтап 4.1, docs/plans/chats-channels.md): одна функция
/// [channelCan] — её зовут экраны (прячут недоступное) и тест общей таблицы
/// `test/chats/fixtures/channel_rights_cases.json` (байт-в-байт как на
/// сервере, `channelCan` в `services/chats_groups_rights.go`). Решает всё
/// равно сервер. Владелец имеет все права всегда; подписчик (READER) только
/// читает, ставит реакции и голосует.

/// Действие в канале — те же имена, что в общей таблице.
enum ChannelAction {
  react,
  post,
  editOwn,
  deleteOwn,
  editOthers,
  deleteOthers,
  pinForAll,
  editInfo,
  addMembers,
  removeMember,
  ban,
  unban,
  setMemberRole,
  setAdmin,
  removeAdmin,
  transferOwnership,
}

/// Может ли «Вы» в [chat] сделать [action] над [target] (null — без цели).
/// [requested] — выдаваемые права (setAdmin). Свои права — как у групп
/// ([myChatRights]: с сервера или, в демо, по участнику «Вы»).
bool channelCan(
  models.Chat chat,
  List<models.ChatMember> members,
  ChannelAction action, {
  models.ChatMember? target,
  models.ChatAdminRights requested = const models.ChatAdminRights(),
}) {
  final mine = myChatRights(chat, members);
  final owner = chat.myRole == models.ChatRole.owner;
  final self = target != null && target.isSelf;
  final other = target != null && !self;
  return switch (action) {
    ChannelAction.react => chat.isMember,
    ChannelAction.post || ChannelAction.editOwn || ChannelAction.deleteOwn => mine.postMessages,
    // Закреп у всех в канале — право править посты (как в Telegram).
    ChannelAction.editOthers || ChannelAction.pinForAll => mine.editMessages,
    ChannelAction.deleteOthers => mine.deleteMessages,
    ChannelAction.editInfo => mine.changeInfo,
    ChannelAction.addMembers => mine.inviteUsers,
    ChannelAction.removeMember || ChannelAction.ban => other && target.role == models.ChatRole.reader && mine.banUsers,
    ChannelAction.unban => mine.banUsers,
    // «Чтение» ⇄ «Запись» в канале нет: подписчик только читает.
    ChannelAction.setMemberRole => false,
    ChannelAction.setAdmin =>
      other &&
          (target.role == models.ChatRole.reader || target.role == models.ChatRole.admin) &&
          mine.addAdmins &&
          (target.role != models.ChatRole.admin || owner || mine.covers(target.rights)) &&
          mine.covers(requested),
    ChannelAction.removeAdmin => other && target.role == models.ChatRole.admin && mine.addAdmins && (owner || mine.covers(target.rights)),
    ChannelAction.transferOwnership => owner && other && (target.role == models.ChatRole.reader || target.role == models.ChatRole.admin),
  };
}

/// Пост канала [message]: можно править — свой с правом публиковать, чужой —
/// с правом править чужие.
bool canEditChannelPost(models.Chat chat, List<models.ChatMember> members, models.Message message) =>
    channelCan(chat, members, message.outgoing ? ChannelAction.editOwn : ChannelAction.editOthers);

/// Пост канала [message]: можно удалить у всех — свой с правом публиковать,
/// чужой (и служебное) — с правом удалять чужие.
bool canDeleteChannelPost(models.Chat chat, List<models.ChatMember> members, models.Message message) =>
    channelCan(chat, members, message.outgoing && !message.service ? ChannelAction.deleteOwn : ChannelAction.deleteOthers);
