import 'package:flutter/widgets.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../calls.dart';
import '../../chats/chats_mapping.dart';
import '../../chats/message_formatting.dart';
import '../../chats/reactions.dart';
import '../../components.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Общее для профиля чата (`chat_info_{cupertino,material}.dart`): вкладки
/// «Участники / Медиа / Файлы / Ссылки / Голосовые», присутствие собеседника,
/// роли. Пока UX-демо, см. docs/plans/chats-groups-channels.md, «Этап 0».

/// Что сделать в окне чата после профиля: поиск по чату или перейти к
/// сообщению [messageID].
class ChatInfoResult {
  final bool search;
  final String? messageID;

  const ChatInfoResult.search() : search = true, messageID = null;

  const ChatInfoResult.goTo(String this.messageID) : search = false;
}

enum ChatInfoTab { members, media, files, links, voice }

/// Вкладки профиля: первыми — участники (у канала — подписчики, если список не
/// скрыт; админам виден всегда). Скрытый список группы / сообщества не админ
/// видит только из владельца и админов ([membersOnlyAdmins]). У сообщества
/// своей ленты нет — только участники.
List<ChatInfoTab> chatInfoTabs(models.Chat chat) => [
  if (chat.type != models.ChatType.private &&
      !chat.isThread &&
      (!chat.membersHidden || chat.canManage || chat.type != models.ChatType.channel))
    ChatInfoTab.members,
  if (chat.type != models.ChatType.community) ...[ChatInfoTab.media, ChatInfoTab.files, ChatInfoTab.links, ChatInfoTab.voice],
];

/// «Звонок» / «Видео» в профиле личного чата — как кнопки в профиле
/// пользователя (`profile_*.dart`): нет сети — разрулит [Calls.startCall].
Future<void> chatInfoCall(models.Chat chat, {required bool video}) async {
  await ensureCallMicPermission();
  await getIt.get<Calls>().startCall(toUserID: idBytes(chat.peerUserID), video: video);
}

/// Кнопка выхода в профиле: личный чат — удаляют; владелец сообщества и его
/// чатов — удаляет (у всех), остальные — покидают.
bool chatInfoDeletes(models.Chat chat) =>
    chat.type == models.ChatType.private ||
    chat.myRole == models.ChatRole.owner && (chat.type == models.ChatType.community || chat.inCommunity);

/// «Удалить чат» / «Покинуть группу / канал / сообщество» / «Удалить группу…».
String chatLeaveLabel(Translations t, models.Chat chat) => switch (chat.type) {
  models.ChatType.private => t.screenChatInfo.deleteChat,
  models.ChatType.group when chatInfoDeletes(chat) => t.screenChatInfo.deleteGroup,
  models.ChatType.channel when chatInfoDeletes(chat) => t.screenChatInfo.deleteChannel,
  models.ChatType.community when chatInfoDeletes(chat) => t.screenChatInfo.deleteCommunity,
  models.ChatType.group => t.screenChatInfo.leaveGroup,
  models.ChatType.channel => t.screenChatInfo.leaveChannel,
  models.ChatType.community => t.screenChatInfo.leaveCommunity,
};

/// Заголовок и текст подтверждения выхода / удаления.
({String title, String? message}) chatLeaveConfirm(Translations t, models.Chat chat) {
  final i = t.screenChatInfo;
  if (chat.type == models.ChatType.private) return (title: i.deleteChatTitle(name: chat.title), message: null);
  if (!chatInfoDeletes(chat)) return (title: i.leaveGroupTitle(name: chat.title), message: null);
  return (
    title: i.deleteInCommunityTitle(name: chat.title),
    message: chat.type == models.ChatType.community ? i.deleteCommunityMessage : i.deleteInCommunityMessage,
  );
}

/// Свой админ чата сообщества (не админ сообщества) — модератор темы:
/// управляет только этим чатом, других не назначает и в сообществе не
/// блокирует (см. «Настройки групп и каналов внутри сообщества» в
/// docs/plans/chats-groups-channels.md).
bool isTopicModerator(models.Chat chat, models.ChatMember member) =>
    chat.inCommunity && member.role == models.ChatRole.admin && !member.fromCommunity;

/// «Свои: медленный режим, реакции» — какие настройки чата сообщества заданы
/// свои, а не от сообщества; `null` — все от сообщества.
String? communityOverridesText(Translations t, models.Chat chat) {
  if (!chat.inCommunity || chat.overrides.isEmpty) return null;
  final i = t.screenChatInfo;
  final names = [
    for (final setting in models.ChatInheritedSetting.values)
      if (chat.overrides.contains(setting))
        switch (setting) {
          models.ChatInheritedSetting.defaultRole => i.inheritedDefaultRole,
          models.ChatInheritedSetting.slowMode => i.inheritedSlowMode,
          models.ChatInheritedSetting.reactions => i.inheritedReactions,
          models.ChatInheritedSetting.newcomerMediaDelay => i.inheritedNewcomer,
        },
  ];
  return i.communityDefaultsOwn(list: names.join(', '));
}

/// Кого можно назначить админом / модератором: не мы и не уже админы.
List<models.ChatMember> pickableMembers(List<models.ChatMember> members) => [
  for (final m in members)
    if (!m.isSelf && m.role != models.ChatRole.admin && m.role != models.ChatRole.owner) m,
];

/// Пункт меню участника: «Назначить админом / модератором» или «Права
/// админа / модератора» (в чате сообщества свои админы — модераторы темы).
String promoteMemberLabel(Translations t, models.Chat chat, models.ChatMember member) {
  final a = t.screenChatAdmins;
  if (member.role == models.ChatRole.admin) return chat.inCommunity ? a.moderatorRights : a.adminRights;
  return chat.inCommunity ? a.promoteModerator : a.promote;
}

/// «Заблокировать» [target]: в чате сообщества блокировка — во всём
/// сообществе, поэтому только его владельцу и админам (модератор темы может
/// лишь ограничить и исключить).
bool canBanMember(models.Chat chat, List<models.ChatMember> members, models.ChatMember target) =>
    canRestrictMember(chat, members, target) && (!chat.inCommunity || members.any((m) => m.isSelf && m.fromCommunity));

/// Пояснение под списком админов: у сообщества — что его админы действуют во
/// всех его чатах, у чата сообщества — что их права меняются в сообществе.
String chatAdminsFooter(Translations t, models.Chat chat) => chat.type == models.ChatType.community
    ? t.screenChatAdmins.adminsFooterOfCommunity
    : (chat.inCommunity ? t.screenChatAdmins.adminsFooterCommunity : t.screenChatAdmins.adminsFooter);

/// Подтверждение «Исключить» / «Заблокировать» участника: в чате сообщества
/// исключённый остаётся в сообществе, а блокировка — во всём сообществе.
({String title, String message}) memberRemoveConfirm(Translations t, models.Chat chat, models.ChatMember member, {required bool ban}) {
  final i = t.screenChatInfo;
  if (ban) {
    return chat.inCommunity
        ? (title: i.banInCommunityTitle(name: member.name), message: i.banInCommunityMessage)
        : (title: i.banMemberTitle(name: member.name), message: i.banMemberMessage);
  }
  return (title: i.removeMemberTitle(name: member.name), message: chat.inCommunity ? i.removeInCommunityMessage : i.removeMemberMessage);
}

/// После выхода: из чата сообщества — обратно в сообщество, иначе — в список.
String chatLeaveRoute(models.Chat chat) => chat.inCommunity ? '/chats/chat/${chat.communityID}' : '/chats';

/// Список участников скрыт, а мы не админ — видим только владельца и админов.
bool membersOnlyAdmins(models.Chat chat) => chat.membersHidden && !chat.canManage;

String chatInfoTabLabel(Translations t, ChatInfoTab tab, models.Chat chat) => switch (tab) {
  ChatInfoTab.members =>
    membersOnlyAdmins(chat)
        ? t.screenChatAdmins.admins
        : (chat.type == models.ChatType.channel ? t.screenChatInfo.tabSubscribers : t.screenChatInfo.tabMembers),
  ChatInfoTab.media => t.screenChatInfo.tabMedia,
  ChatInfoTab.files => t.screenChatInfo.tabFiles,
  ChatInfoTab.links => t.screenChatInfo.tabLinks,
  ChatInfoTab.voice => t.screenChatInfo.tabVoice,
};

/// «был(а) 5 мин. назад / в 14:20 / вчера в 14:20 / 03.10.26».
String lastSeenText(Translations t, DateTime date) {
  final now = DateTime.now();
  final local = date.toLocal();
  final diff = now.difference(local);
  final time = DateFormat.Hm().format(local);
  if (diff.inMinutes < 60) return t.screenChatInfo.lastSeenMinutes(n: diff.inMinutes.clamp(1, 59));
  final today = DateTime(now.year, now.month, now.day);
  if (!local.isBefore(today)) return t.screenChatInfo.lastSeenAt(time: time);
  if (!local.isBefore(today.subtract(const Duration(days: 1)))) return t.screenChatInfo.lastSeenYesterday(time: time);
  return t.screenChatInfo.lastSeenDate(date: DateFormat('dd.MM.yy').format(local));
}

/// Присутствие собеседника личного чата: «в сети» (активно) / «был(а) …».
({String text, bool active}) chatPresence(Translations t, models.Chat chat) {
  if (chat.online) return (text: t.screenChat.online, active: true);
  final seen = chat.lastSeen;
  return (text: seen == null ? t.screenChat.lastSeenRecently : lastSeenText(t, seen), active: false);
}

/// Подпись роли в списке участников; `null` — обычный участник с записью.
String? chatRoleLabel(Translations t, models.ChatRole role) => switch (role) {
  models.ChatRole.owner => t.screenChatInfo.roleOwner,
  models.ChatRole.admin => t.screenChatInfo.roleAdmin,
  models.ChatRole.reader => t.screenChatInfo.roleReader,
  models.ChatRole.writer => null,
};

/// Наши права в чате: владелец — все, админ — по участнику «Вы».
models.ChatAdminRights myChatRights(models.Chat chat, List<models.ChatMember> members) {
  if (chat.myRole == models.ChatRole.owner) return models.ChatAdminRights.all;
  if (chat.myRole != models.ChatRole.admin) return const models.ChatAdminRights();
  return members.where((m) => m.isSelf).firstOrNull?.effectiveRights ?? const models.ChatAdminRights();
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

/// Права админа, которые показываются для типа чата.
enum ChatAdminRight {
  changeInfo,
  postMessages,
  editMessages,
  deleteMessages,
  banUsers,
  inviteUsers,
  pinMessages,
  manageCalls,
  anonymous,
  addAdmins,
}

/// Права, которые можно выдать админу чата [chat]: модератору темы (в чате
/// сообщества) — без назначения админов.
List<ChatAdminRight> adminRightsFor(models.Chat chat) => [
  for (final right in _adminRightsOf(chat.type))
    if (!chat.inCommunity || right != ChatAdminRight.addAdmins) right,
];

List<ChatAdminRight> _adminRightsOf(models.ChatType type) => type == models.ChatType.channel
    ? const [
        ChatAdminRight.changeInfo,
        ChatAdminRight.postMessages,
        ChatAdminRight.editMessages,
        ChatAdminRight.deleteMessages,
        ChatAdminRight.inviteUsers,
        ChatAdminRight.manageCalls,
        ChatAdminRight.addAdmins,
      ]
    : const [
        ChatAdminRight.changeInfo,
        ChatAdminRight.deleteMessages,
        ChatAdminRight.banUsers,
        ChatAdminRight.inviteUsers,
        ChatAdminRight.pinMessages,
        ChatAdminRight.manageCalls,
        ChatAdminRight.anonymous,
        ChatAdminRight.addAdmins,
      ];

String adminRightLabel(Translations t, ChatAdminRight right) => switch (right) {
  ChatAdminRight.changeInfo => t.screenChatAdmins.changeInfo,
  ChatAdminRight.postMessages => t.screenChatAdmins.postMessages,
  ChatAdminRight.editMessages => t.screenChatAdmins.editMessages,
  ChatAdminRight.deleteMessages => t.screenChatAdmins.deleteMessages,
  ChatAdminRight.banUsers => t.screenChatAdmins.banUsers,
  ChatAdminRight.inviteUsers => t.screenChatAdmins.inviteUsers,
  ChatAdminRight.pinMessages => t.screenChatAdmins.pinMessages,
  ChatAdminRight.manageCalls => t.screenChatAdmins.manageCalls,
  ChatAdminRight.anonymous => t.screenChatAdmins.anonymous,
  ChatAdminRight.addAdmins => t.screenChatAdmins.addAdmins,
};

bool adminRightOf(models.ChatAdminRights rights, ChatAdminRight right) => switch (right) {
  ChatAdminRight.changeInfo => rights.changeInfo,
  ChatAdminRight.postMessages => rights.postMessages,
  ChatAdminRight.editMessages => rights.editMessages,
  ChatAdminRight.deleteMessages => rights.deleteMessages,
  ChatAdminRight.banUsers => rights.banUsers,
  ChatAdminRight.inviteUsers => rights.inviteUsers,
  ChatAdminRight.pinMessages => rights.pinMessages,
  ChatAdminRight.manageCalls => rights.manageCalls,
  ChatAdminRight.anonymous => rights.anonymous,
  ChatAdminRight.addAdmins => rights.addAdmins,
};

models.ChatAdminRights withAdminRight(models.ChatAdminRights rights, ChatAdminRight right, bool value) => switch (right) {
  ChatAdminRight.changeInfo => rights.copyWith(changeInfo: value),
  ChatAdminRight.postMessages => rights.copyWith(postMessages: value),
  ChatAdminRight.editMessages => rights.copyWith(editMessages: value),
  ChatAdminRight.deleteMessages => rights.copyWith(deleteMessages: value),
  ChatAdminRight.banUsers => rights.copyWith(banUsers: value),
  ChatAdminRight.inviteUsers => rights.copyWith(inviteUsers: value),
  ChatAdminRight.pinMessages => rights.copyWith(pinMessages: value),
  ChatAdminRight.manageCalls => rights.copyWith(manageCalls: value),
  ChatAdminRight.anonymous => rights.copyWith(anonymous: value),
  ChatAdminRight.addAdmins => rights.copyWith(addAdmins: value),
};

/// Подпись роли в списке: «звание» админа, иначе «владелец» / «админ» /
/// «только чтение».
String? memberRoleLabel(Translations t, models.ChatMember member, models.Chat chat) {
  if (member.role == models.ChatRole.admin && member.rank.isNotEmpty) return member.rank;
  if (isTopicModerator(chat, member)) return t.screenChatInfo.roleModerator;
  // Владелец и админы сообщества в его чате.
  if (member.fromCommunity && member.role == models.ChatRole.owner) return t.screenChatInfo.roleCommunityOwner;
  if (member.fromCommunity && member.role == models.ChatRole.admin) return t.screenChatInfo.roleCommunityAdmin;
  return chatRoleLabel(t, member.role);
}

/// Ссылки чата — из превью или первой ссылки текста, от новых к старым.
List<({models.Message message, String url, models.MessageLinkPreview? preview})> chatLinks(List<models.Message> messages) => [
  for (final m in messages.reversed)
    if (!m.service)
      if ((m.linkPreview?.url ?? firstLinkUrl(m.text, m.entities)) case final url?) (message: m, url: url, preview: m.linkPreview),
];

/// Цвета вкладок — свои у Cupertino и Material.
class ChatInfoStyle {
  final Color text;
  final Color secondary;
  final Color accent;
  final Color separator;

  /// Строки-действия («Добавить участников»); по умолчанию — [accent].
  final Color? action;

  /// Значки на плитках цвета [accent] (файлы, ссылки, голосовые).
  final Color onAccent;

  const ChatInfoStyle({
    required this.text,
    required this.secondary,
    required this.accent,
    required this.separator,
    this.action,
    this.onAccent = const Color(0xFFFFFFFF),
  });
}

/// Содержимое вкладки профиля. [onOpenMessage] — вернуться в чат к
/// сообщению (файл, голосовое).
class ChatInfoTabContent extends StatelessWidget {
  final ChatInfoTab tab;
  final models.Chat chat;
  final List<models.Message> messages;
  final List<models.ChatMember> members;
  final ChatInfoStyle style;
  final ValueChanged<String> onOpenMessage;

  /// Тап по участнику (меню действий); `null` — строки не нажимаются.
  final ValueChanged<models.ChatMember>? onMemberTap;

  /// «Добавить участников» первой строкой вкладки (админ); `null` — нет.
  final VoidCallback? onAddMembers;

  /// Обёртка строки участника (iOS — контекстное меню по удержанию).
  final Widget Function(models.ChatMember member, Widget row)? memberWrapper;

  const ChatInfoTabContent({
    super.key,
    required this.tab,
    required this.chat,
    required this.messages,
    required this.members,
    required this.style,
    required this.onOpenMessage,
    this.onMemberTap,
    this.onAddMembers,
    this.memberWrapper,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return switch (tab) {
      ChatInfoTab.members => Column(
        children: [
          if (onAddMembers != null) _AddMembersRow(style: style, onTap: onAddMembers!),
          for (final m in members)
            _wrapMember(m, _MemberRow(member: m, chat: chat, style: style, onTap: onMemberTap == null ? null : () => onMemberTap!(m))),
        ],
      ),
      ChatInfoTab.media => _media(context),
      ChatInfoTab.files => _list(t.screenChatInfo.emptyFiles, [
        for (final m in messages.reversed)
          if (m.kind == models.MessageKind.file) _FileRow(message: m, style: style, onTap: () => onOpenMessage(m.id)),
      ]),
      ChatInfoTab.links => _list(t.screenChatInfo.emptyLinks, [
        for (final link in chatLinks(messages)) _LinkRow(url: link.url, preview: link.preview, date: link.message.date, style: style),
      ]),
      ChatInfoTab.voice => _list(t.screenChatInfo.emptyVoice, [
        for (final m in messages.reversed)
          if (m.kind == models.MessageKind.voice) _VoiceRow(message: m, chat: chat, style: style, onTap: () => onOpenMessage(m.id)),
      ]),
    };
  }

  Widget _empty(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15, color: style.secondary),
    ),
  );

  Widget _wrapMember(models.ChatMember member, Widget row) => memberWrapper?.call(member, row) ?? row;

  Widget _list(String empty, List<Widget> rows) => rows.isEmpty ? _empty(empty) : Column(children: rows);

  /// Фото и видео сеткой по 3, от новых к старым; тап — просмотр.
  Widget _media(BuildContext context) {
    final items = ChatMediaItem.of(messages).reversed.toList();
    if (items.isEmpty) return _empty(context.t.screenChatInfo.emptyMedia);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        final Widget image = item.isVideo && item.thumbPath.isNotEmpty
            ? ChatMediaImage(path: item.thumbPath, thumbhash: item.thumbhash, cacheWidth: 360)
            : !item.isVideo && item.localPath.isNotEmpty
            ? ChatMediaImage(path: item.localPath, thumbhash: item.thumbhash, cacheWidth: 360)
            : chatMediaPlaceholder('${item.message.id}-${item.index}', video: item.isVideo, iconSize: 26);
        return GestureDetector(
          onTap: () => showChatMediaViewer(context, messages: messages, message: item.message, index: item.index, chatTitle: chat.title),
          child: Stack(
            fit: StackFit.expand,
            children: [
              image,
              if (item.isVideo && item.thumbPath.isNotEmpty) const Center(child: ChatVideoPlayBadge(size: 30)),
            ],
          ),
        );
      },
    );
  }
}

/// Вкладка «Участники» ленивым списком: строки строятся по мере прокрутки, а
/// следующая страница догружается у конца (`ChatCubit.loadMemberPage`) — в
/// сообществе участников могут быть сотни тысяч. Карточка — фоном под списком
/// ([decoration]), отступы — [margin].
class ChatMembersSliver extends StatelessWidget {
  final models.Chat chat;
  final List<models.ChatMember> members;

  /// Грузится следующая страница — внизу [loader].
  final bool loading;
  final Widget loader;
  final ChatInfoStyle style;
  final Decoration decoration;
  final EdgeInsets margin;
  final ValueChanged<models.ChatMember>? onMemberTap;
  final VoidCallback? onAddMembers;
  final Widget Function(models.ChatMember member, Widget row)? memberWrapper;

  /// Поле поиска первой строкой (`null` — без поиска) и текущий запрос: при
  /// поиске внизу — «Никого не найдено» / пояснение, как ищется.
  final Widget? search;
  final String query;

  const ChatMembersSliver({
    super.key,
    required this.chat,
    required this.members,
    required this.loading,
    required this.loader,
    required this.style,
    required this.decoration,
    required this.margin,
    this.onMemberTap,
    this.onAddMembers,
    this.memberWrapper,
    this.search,
    this.query = '',
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChatInfo;
    final searching = query.trim().isNotEmpty;
    final head = search != null ? 1 : 0;
    // «Добавить участников» — не во время поиска.
    final add = onAddMembers != null && !searching ? 1 : 0;
    // Последней строкой — пояснение: при поиске — как ищется (или «Никого не
    // найдено»), у скрытого списка не админу — что список видят админы.
    final note = searching
        ? (!loading && members.isEmpty ? '${t.membersNotFound}. ${t.membersSearchNote}' : t.membersSearchNote)
        : (membersOnlyAdmins(chat) ? t.membersHiddenNote : null);
    final notes = note == null ? 0 : 1;
    final spinner = loading ? 1 : 0;
    return SliverPadding(
      padding: margin,
      sliver: DecoratedSliver(
        decoration: decoration,
        sliver: SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          sliver: SliverList.builder(
            itemCount: head + add + members.length + spinner + notes,
            itemBuilder: (context, index) {
              if (index < head) return Padding(padding: const EdgeInsets.fromLTRB(12, 4, 12, 6), child: search);
              if (index < head + add) return _AddMembersRow(style: style, onTap: onAddMembers!);
              final i = index - head - add;
              if (i < members.length) {
                final m = members[i];
                final row = _MemberRow(member: m, chat: chat, style: style, onTap: onMemberTap == null ? null : () => onMemberTap!(m));
                return memberWrapper?.call(m, row) ?? row;
              }
              if (i == members.length && loading) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: loader),
                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                child: Text(note!, style: TextStyle(fontSize: 13, color: style.secondary)),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// «Добавить участников» — кружок с «+» и подпись цветом действия.
class _AddMembersRow extends StatelessWidget {
  final ChatInfoStyle style;
  final VoidCallback onTap;

  const _AddMembersRow({required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = style.action ?? style.accent;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: HugeIcon(icon: HugeIcons.strokeRoundedUserAdd01, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(context.t.screenChatInfo.addMembers, style: TextStyle(fontSize: 16, color: color)),
          ],
        ),
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  final models.ChatMember member;
  final models.Chat chat;
  final ChatInfoStyle style;
  final VoidCallback? onTap;

  const _MemberRow({required this.member, required this.chat, required this.style, this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final role = memberRoleLabel(t, member, chat);
    final seen = member.lastSeen;
    final status = member.online || member.isSelf
        ? t.screenChat.online
        : (seen == null ? t.screenChat.lastSeenRecently : lastSeenText(t, seen));
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: BoringAvatar(name: member.name, type: BoringAvatarType.beam, shape: const CircleBorder()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.isSelf ? t.screenChatInfo.you : member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: style.text),
                  ),
                  Text(
                    status,
                    maxLines: 1,
                    style: TextStyle(fontSize: 13, color: member.online || member.isSelf ? style.accent : style.secondary),
                  ),
                ],
              ),
            ),
            if (role != null) Text(role, style: TextStyle(fontSize: 13, color: style.secondary)),
          ],
        ),
      ),
    );
  }
}

/// Строка с кружком-значком слева (файл, голосовое, ссылка).
class _IconRow extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final ChatInfoStyle style;
  final VoidCallback? onTap;

  const _IconRow({required this.icon, required this.title, required this.subtitle, required this.style, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: style.accent, borderRadius: BorderRadius.circular(8)),
              child: icon,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: style.text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: style.secondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _date(DateTime date) => DateFormat('dd.MM.yy').format(date.toLocal());

class _FileRow extends StatelessWidget {
  final models.Message message;
  final ChatInfoStyle style;
  final VoidCallback onTap;

  const _FileRow({required this.message, required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = message.fileSize > 0 ? '${formatBytes(context, message.fileSize)} · ' : '';
    return _IconRow(
      icon: FaIcon(FontAwesomeIcons.solidFile, size: 20, color: style.onAccent),
      title: message.fileName.isNotEmpty ? message.fileName : message.text,
      subtitle: '$size${_date(message.date)}',
      style: style,
      onTap: onTap,
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String url;
  final models.MessageLinkPreview? preview;
  final DateTime date;
  final ChatInfoStyle style;

  const _LinkRow({required this.url, required this.preview, required this.date, required this.style});

  @override
  Widget build(BuildContext context) {
    final host = Uri.tryParse(url)?.host ?? url;
    final title = preview?.title.isNotEmpty ?? false ? preview!.title : host;
    return _IconRow(
      icon: Text(
        host.replaceFirst('www.', '').characters.firstOrNull?.toUpperCase() ?? '#',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: style.onAccent),
      ),
      title: title,
      subtitle: url,
      style: style,
      onTap: () {
        final uri = Uri.tryParse(url);
        if (uri != null) launchUrl(uri, mode: LaunchMode.externalApplication);
      },
    );
  }
}

class _VoiceRow extends StatelessWidget {
  final models.Message message;
  final models.Chat chat;
  final ChatInfoStyle style;
  final VoidCallback onTap;

  const _VoiceRow({required this.message, required this.chat, required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final seconds = message.duration;
    final author = message.outgoing ? t.screenChatInfo.you : (message.senderName.isNotEmpty ? message.senderName : chat.title);
    return _IconRow(
      icon: FaIcon(FontAwesomeIcons.microphone, size: 18, color: style.onAccent),
      title: author,
      subtitle: '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')} · ${_date(message.date)}',
      style: style,
      onTap: onTap,
    );
  }
}

/// Сводка реакций для строки «Реакции»: «Все» / «Выкл.» / число выбранных.
String reactionsSummary(Translations t, models.Chat chat) => switch (chat.reactionsMode) {
  models.ChatReactionsMode.all => t.screenChatInfo.reactionsAllShort,
  models.ChatReactionsMode.none => t.screenChatInfo.reactionsNoneShort,
  models.ChatReactionsMode.some => chat.reactions.isEmpty ? t.screenChatInfo.reactionsNoneShort : '${chat.reactions.length}',
};

/// Сетка всех реакций с отметкой выбранных (настройка «Некоторые»):
/// выбранные — в кружке, остальные — бледнее.
class ReactionsGrid extends StatelessWidget {
  final List<String> selected;
  final Color highlight;
  final ValueChanged<String> onToggle;

  const ReactionsGrid({super.key, required this.selected, required this.highlight, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final emoji in allChatReactions)
          GestureDetector(
            onTap: () => onToggle(emoji),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected.contains(emoji) ? highlight.withValues(alpha: 0.18) : null,
                border: Border.all(color: selected.contains(emoji) ? highlight : const Color(0x00000000), width: 1.5),
              ),
              child: Opacity(
                opacity: selected.contains(emoji) ? 1 : 0.35,
                child: Text(emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
          ),
      ],
    );
  }
}

/// Интервал медленного режима: «Выкл.» / «30 с» / «5 мин» / «1 ч».
String slowModeLabel(Translations t, int seconds) => switch (seconds) {
  0 => t.screenChatInfo.slowModeOff,
  < 60 => t.screenChatInfo.slowModeSeconds(n: seconds),
  < 3600 => t.screenChatInfo.slowModeMinutes(n: seconds ~/ 60),
  _ => t.screenChatInfo.slowModeHours(n: seconds ~/ 3600),
};
