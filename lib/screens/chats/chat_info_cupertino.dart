import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';

import '../../chats/reactions.dart';
import '../../chats/slow_mode.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';
import 'chat_admins_cupertino.dart';
import 'chat_banned_cupertino.dart';
import 'chat_create_form_cupertino.dart';
import 'chat_create_members_cupertino.dart';
import 'chat_invite_links_cupertino.dart';
import 'chat_join_requests_cupertino.dart';
import 'chat_info_common.dart';
import 'chat_mute.dart';
import 'chats_new_cupertino.dart';
import 'community_common.dart';
import 'community_cupertino.dart';

/// Профиль чата (iOS) — тап по шапке окна чата. Результат — что сделать в
/// чате: поиск или переход к сообщению.
Future<ChatInfoResult?> showChatInfoCupertino(BuildContext context, ChatCubit cubit) {
  return Navigator.of(context).push<ChatInfoResult>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const ChatInfoCupertino()),
    ),
  );
}

/// Аватар, название и статус, кнопки «Звук» / «Поиск», «О себе» / описание
/// и @username, для админа — «Реакции», вкладки «Участники / Медиа / Файлы /
/// Ссылки / Голосовые», внизу — «Удалить чат» / «Покинуть группу».
class ChatInfoCupertino extends StatefulWidget {
  const ChatInfoCupertino({super.key});

  @override
  State<ChatInfoCupertino> createState() => _ChatInfoCupertinoState();
}

class _ChatInfoCupertinoState extends State<ChatInfoCupertino> {
  ChatInfoTab? _tab;
  final _scroll = ScrollController();

  /// Открыта вкладка «Участники» — догружать страницы при прокрутке.
  bool _membersTab = false;

  /// Поиск по «Участникам».
  final _memberSearch = TextEditingController();

  /// Страница сообщества: панель навигации прозрачная поверх обложки, пока
  /// обложка не уехала под неё.
  bool _overCover = true;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>()
      ..loadMembers()
      ..loadMemberPage();
    _scroll.addListener(() {
      final over = _scroll.offset < CommunityCover.height - 44;
      if (over != _overCover) setState(() => _overCover = over);
      // У конца «Участников» — следующая страница.
      if (_membersTab && _scroll.position.extentAfter < 600) context.read<ChatCubit>().loadMemberPage(more: true);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _memberSearch.dispose();
    super.dispose();
  }

  Future<void> _leave(BuildContext context, models.Chat chat) async {
    final confirm = chatLeaveConfirm(context.t, chat);
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(confirm.title),
        content: confirm.message == null ? null : Text(confirm.message!),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(chatLeaveLabel(context.t, chat)),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false) || !context.mounted) return;
    // Без сети чат не удалён — остаёмся (окно чата покажет «Нет соединения»).
    if (!await context.read<ChatCubit>().deleteChat()) return;
    if (context.mounted) context.go(chatLeaveRoute(chat));
  }

  /// «Звук»: заглушённый — включить сразу, иначе — выпадающее меню
  /// «Заглушить на…».
  List<Widget>? _muteMenu(BuildContext context, models.Chat chat) {
    if (chat.muted) return null;
    final t = context.t;
    return [
      for (final value in ChatMuteFor.values)
        CupertinoMenuItem(
          isDestructiveAction: value == ChatMuteFor.forever,
          trailing: Icon(value == ChatMuteFor.forever ? CupertinoIcons.bell_slash : CupertinoIcons.clock),
          onPressed: () => context.read<ChatCubit>().setMuted(true, until: chatMuteUntil(value)),
          child: Text(chatMuteLabel(t, value)),
        ),
    ];
  }

  /// «Как в сообществе»: вернуть чату сообщества его настройки по умолчанию.
  Future<void> _resetToCommunity(BuildContext context) async {
    final t = context.t.screenChatInfo;
    final cubit = context.read<ChatCubit>();
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.communityDefaultsTitle),
        content: Text(t.communityDefaultsMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.communityDefaultsReset)),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.resetToCommunity();
  }

  /// Тап по участнику — личный чат с ним («Написать сообщение»).
  Future<void> _messageMember(BuildContext context, models.ChatMember member) async {
    if (member.isSelf) return;
    final chatID = await context.read<ChatCubit>().privateChatWith(member);
    if (chatID != null && chatID.isNotEmpty && context.mounted) {
      // Поверх профиля / сообщества — «назад» вернёт туда.
      await context.push('/chats/chat/$chatID');
    }
  }

  /// Удержание участника — контекстное меню: «Написать сообщение»; с правом
  /// назначать админов — «Назначить админом» / «Права админа»; с правом
  /// блокировать (для «Чтения» / «Записи») — роль, «Исключить», «Заблокировать».
  List<Widget> _memberMenuActions(BuildContext context, models.Chat chat, models.ChatMember member) {
    if (member.isSelf) return const [];
    final t = context.t.screenChatInfo;
    final cubit = context.read<ChatCubit>();
    final members = cubit.state.members;
    final manage = canRestrictMember(chat, members, member);
    final promote = canPromoteMember(chat, members, member);
    final ban = canBanMember(chat, members, member);
    Future<bool> confirm(String title, String message, String label) async =>
        await showCupertinoDialog<bool>(
          context: context,
          builder: (dialogContext) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
              CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(label)),
            ],
          ),
        ) ??
        false;
    return [
      rowMenuAction(context, t.sendMessage, CupertinoIcons.chat_bubble, () => _messageMember(context, member)),
      if (promote)
        rowMenuAction(
          context,
          promoteMemberLabel(context.t, chat, member),
          CupertinoIcons.star,
          () => showChatAdminRightsCupertino(context, cubit, member),
        ),
      if (manage) ...[
        rowMenuAction(
          context,
          member.role == models.ChatRole.reader ? t.allowWriting : t.makeReadOnly,
          member.role == models.ChatRole.reader ? CupertinoIcons.pencil : CupertinoIcons.eye,
          () => cubit.setMemberRole(member, member.role == models.ChatRole.reader ? models.ChatRole.writer : models.ChatRole.reader),
        ),
        rowMenuAction(context, t.removeMember, CupertinoIcons.person_badge_minus, () async {
          final text = memberRemoveConfirm(context.t, chat, member, ban: false);
          if (await confirm(text.title, text.message, t.removeMember)) {
            await cubit.removeMember(member);
          }
        }, destructive: true),
        if (ban)
          rowMenuAction(context, t.banMember, CupertinoIcons.nosign, () async {
            final text = memberRemoveConfirm(context.t, chat, member, ban: true);
            if (await confirm(text.title, text.message, t.banMember)) {
              await cubit.removeMember(member, ban: true);
            }
          }, destructive: true),
      ],
    ];
  }

  /// «Добавить участников» (админ): выбор из контактов, кроме участников.
  Future<void> _addMembers(BuildContext context) async {
    final cubit = context.read<ChatCubit>();
    final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
    final exclude = {for (final m in cubit.state.members) m.id};
    await Navigator.of(context).push<void>(
      FullSwipeBackRoute(
        builder: (routeContext) => BlocProvider(
          create: (_) => ChatCreateCubit()..initialization(demo: demo, type: models.ChatType.group, exclude: exclude),
          child: ChatCreateMembersCupertino(
            onDone: (selected) {
              Navigator.of(routeContext).pop();
              cubit.addMembers(selected);
            },
          ),
        ),
      ),
    );
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final primary = CupertinoTheme.of(context).primaryColor;
    final action = ThemesCupertino.actionColor(context);
    final label = CupertinoColors.label.resolveFrom(context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final chat = state.chat;
        final tabs = chat == null ? const <ChatInfoTab>[] : chatInfoTabs(chat);
        final tab = tabs.contains(_tab) ? _tab! : (tabs.firstOrNull ?? ChatInfoTab.media);
        _membersTab = tab == ChatInfoTab.members;
        final subtitle = chat == null ? null : chatSubtitle(t, chat);
        final community = chat?.type == models.ChatType.community;
        // У сообщества — обложка от верха экрана: пока она видна, панели нет,
        // «назад» и «Изменить» — «стёкла» поверх обложки; уехала — обычная
        // панель с названием. Фон панели чуть прозрачный — контент всегда под
        // ней, и раскладка не прыгает.
        final onCover = community && _overCover;
        final canEdit = chat != null && chat.canManage && chat.type != models.ChatType.private;
        final navBar = CupertinoNavigationBar(
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          // Обложка уехала — название сообщества в панели.
          middle: community && !onCover ? Text(chat!.title) : null,
          backgroundColor: community ? background.withValues(alpha: 0.97) : background,
          border: null,
          // «Изменить» — админу группы / канала / сообщества.
          trailing: canEdit
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => showChatEditCupertino(context, chat),
                  // У сообщества — карандаш, как на «стекле» поверх обложки.
                  child: community
                      ? Semantics(
                          label: t.common.edit,
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedPencilEdit02,
                            color: ThemesCupertino.navActionColor(context),
                            size: 22,
                          ),
                        )
                      : Text(t.common.edit, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
                )
              : null,
        );
        final header = chat == null
            ? const <Widget>[]
            : community
            ? [
                CommunityCover(
                  chat: chat,
                  subtitle: subtitle?.text ?? '',
                  accentColor: primary,
                  accentForeground: ThemesCupertino.onAccent(context),
                ),
              ]
            : [
                const SizedBox(height: 4),
                Center(
                  child: ChatAvatar(chat: chat, size: 96, accentColor: primary, accentForeground: ThemesCupertino.onAccent(context)),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    ChatTileContent.title(t, chat),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: label),
                  ),
                ),
                if (subtitle != null && subtitle.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: subtitle.active ? primary : secondary),
                    ),
                  ),
              ];
        return CupertinoPageScaffold(
          backgroundColor: background,
          navigationBar: onCover ? null : AppCupertinoNavigationBar(child: navBar),
          child: chat == null
              ? const SizedBox.shrink()
              : Stack(
                  children: [
                    SafeArea(
                      bottom: false,
                      // Обложка — от самого верха экрана, под панелью.
                      top: !community,
                      child: CustomScrollView(
                        controller: _scroll,
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        slivers: [
                          SliverList.list(
                            children: [
                              ...header,
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    // Звонок — только собеседнику личного чата (в демо
                                    // peerUserID пуст: звонить некому).
                                    if (chat.peerUserID.isNotEmpty) ...[
                                      _ActionButton(
                                        icon: HugeIcons.strokeRoundedCall02,
                                        label: t.screenChatInfo.call,
                                        color: action,
                                        onTap: () => chatInfoCall(chat, video: false),
                                      ),
                                      _ActionButton(
                                        icon: HugeIcons.strokeRoundedVideo01,
                                        label: t.screenChatInfo.video,
                                        color: action,
                                        onTap: () => chatInfoCall(chat, video: true),
                                      ),
                                    ],
                                    if (!chat.isSelf)
                                      _ActionButton(
                                        // Значок — текущее состояние: звук включён / выключен.
                                        icon: chat.muted ? HugeIcons.strokeRoundedNotificationOff01 : HugeIcons.strokeRoundedNotification01,
                                        // Заглушён на время — «до 18:30» вместо «Звук».
                                        label: chat.muted && chat.mutedUntil != null
                                            ? chatMutedUntilLabel(t, chat.mutedUntil!)
                                            : t.screenChatInfo.sound,
                                        color: action,
                                        onTap: () => context.read<ChatCubit>().setMuted(false),
                                        menuChildren: _muteMenu(context, chat),
                                      ),
                                    // У сообщества своей ленты нет — искать негде.
                                    if (!community)
                                      _ActionButton(
                                        icon: HugeIcons.strokeRoundedSearch01,
                                        label: t.screenChatInfo.search,
                                        color: action,
                                        onTap: () => Navigator.of(context).pop(const ChatInfoResult.search()),
                                      ),
                                    // Канал объявлений покидают только вместе с сообществом.
                                    if (!chat.isSelf && !chat.announcements && chat.isMember)
                                      _ActionButton(
                                        icon: chatInfoDeletes(chat)
                                            ? HugeIcons.strokeRoundedDelete02
                                            : HugeIcons.strokeRoundedSquareArrowRightExit,
                                        label: chatInfoDeletes(chat) ? t.screenChatInfo.deleteShort : t.screenChatInfo.leaveShort,
                                        color: CupertinoColors.destructiveRed.resolveFrom(context),
                                        onTap: () => _leave(context, chat),
                                      ),
                                  ],
                                ),
                              ),
                              if (chat.about.isNotEmpty || chat.linkPath.isNotEmpty || (community && communityHasContacts(chat)))
                                _section(context, [
                                  if (chat.about.isNotEmpty)
                                    CupertinoListTileIcon(
                                      color: const Color(0xFF1368E6),
                                      hugeIcon: HugeIcons.strokeRoundedInformationCircle,
                                      title: Text(chat.about, maxLines: 6),
                                      subtitle: Text(
                                        chat.type == models.ChatType.private ? t.screenChatInfo.about : t.screenChatInfo.description,
                                      ),
                                      onTab: () async => _copy(chat.about),
                                    ),
                                  // Сообщество: телефон и адрес — под описанием.
                                  if (community) ...communityContactTilesCupertino(context, chat),
                                  if (chat.linkPath.isNotEmpty)
                                    chat.type == models.ChatType.private
                                        ? CupertinoListTileIcon(
                                            color: const Color(0xFF049A40),
                                            hugeIcon: HugeIcons.strokeRoundedAt,
                                            title: Text('@${chat.username}', style: TextStyle(color: action)),
                                            subtitle: Text(t.screenChatInfo.username),
                                            onTab: () async => _copy('@${chat.username}'),
                                          )
                                        : CupertinoListTileIcon(
                                            color: const Color(0xFF049A40),
                                            hugeIcon: HugeIcons.strokeRoundedLink01,
                                            title: Text('iperon.net/${chat.linkPath}', style: TextStyle(color: action)),
                                            subtitle: Text(t.screenChatInfo.link),
                                            onTab: () async => _copy('https://iperon.net/${chat.linkPath}'),
                                          ),
                                ]),
                              if (community && !chat.isMember)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  child: CupertinoButton.filled(
                                    onPressed: chat.joinRequested ? null : () => context.read<ChatCubit>().join(),
                                    child: Text(
                                      chat.joinRequested
                                          ? t.screenChat.requestSent
                                          : (chat.joinMode == models.ChatJoinMode.request
                                                ? t.screenChat.requestJoin
                                                : t.screenChatInfo.joinCommunity),
                                      style: TextStyle(color: chat.joinRequested ? null : ThemesCupertino.onAccent(context)),
                                    ),
                                  ),
                                ),
                              if (community && chat.isMember) CommunityChatsCupertino(community: chat, chats: state.communityChats),
                              if (chat.canManage && chat.type != models.ChatType.private)
                                _section(context, [
                                  // У чатов сообщества своих ссылок и блокировок нет —
                                  // вступают и блокируются через сообщество.
                                  if (!chat.inCommunity)
                                    CupertinoListTileIcon(
                                      color: const Color(0xFF049A40),
                                      hugeIcon: HugeIcons.strokeRoundedLink01,
                                      title: Text(t.screenChatInvites.inviteLinks),
                                      isTrailing: true,
                                      onTab: () => showChatInviteLinksCupertino(context, chat.id),
                                    ),
                                  if (!chat.inCommunity || chat.joinMode == models.ChatJoinMode.request)
                                    CupertinoListTileIcon(
                                      color: const Color(0xFF1368E6),
                                      hugeIcon: HugeIcons.strokeRoundedUserAdd01,
                                      title: Text(t.screenChatInvites.joinRequests),
                                      additionalInfo: chat.pendingRequests > 0
                                          ? Container(
                                              constraints: const BoxConstraints(minWidth: 22),
                                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: CupertinoColors.systemRed.resolveFrom(context),
                                                borderRadius: BorderRadius.circular(11),
                                              ),
                                              child: Text(
                                                '${chat.pendingRequests}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 14, color: CupertinoColors.white),
                                              ),
                                            )
                                          : null,
                                      isTrailing: true,
                                      onTab: () => showChatJoinRequestsCupertino(context, chat.id),
                                    ),
                                  CupertinoListTileIcon(
                                    color: const Color(0xFFFF9500),
                                    hugeIcon: HugeIcons.strokeRoundedSmile,
                                    title: Text(t.screenChatInfo.reactions),
                                    additionalInfo: Text(reactionsSummary(t, chat)),
                                    isTrailing: true,
                                    onTab: () => Navigator.of(context).push(
                                      FullSwipeBackRoute<void>(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<ChatCubit>(),
                                          child: const ChatReactionsSettingsCupertino(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (chat.type == models.ChatType.group || chat.type == models.ChatType.community)
                                    CupertinoListTileIcon(
                                      color: const Color(0xFF34AADC),
                                      hugeIcon: HugeIcons.strokeRoundedTimer02,
                                      title: Text(t.screenChatInfo.slowMode),
                                      additionalInfo: Text(slowModeLabel(t, chat.slowMode)),
                                      isTrailing: true,
                                      onTab: () => Navigator.of(context).push(
                                        FullSwipeBackRoute<void>(
                                          builder: (_) => BlocProvider.value(
                                            value: context.read<ChatCubit>(),
                                            child: const ChatSlowModeSettingsCupertino(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  CupertinoListTileIcon(
                                    color: const Color(0xFF5856D6),
                                    hugeIcon: HugeIcons.strokeRoundedUserStar01,
                                    title: Text(t.screenChatAdmins.admins),
                                    additionalInfo: Text(
                                      '${state.members.where((m) => m.role == models.ChatRole.admin || m.role == models.ChatRole.owner).length}',
                                    ),
                                    isTrailing: true,
                                    onTab: () => showChatAdminsCupertino(context, context.read<ChatCubit>()),
                                  ),
                                  if ((chat.type == models.ChatType.group || chat.type == models.ChatType.community) && !chat.inCommunity)
                                    CupertinoListTileIcon(
                                      color: const Color(0xFFFF3B30),
                                      hugeIcon: HugeIcons.strokeRoundedUserBlock01,
                                      title: Text(t.screenChatInfo.banned),
                                      additionalInfo: state.banned.isEmpty ? null : Text('${state.banned.length}'),
                                      isTrailing: true,
                                      onTab: () => showChatBannedCupertino(context, context.read<ChatCubit>()),
                                    ),
                                  // Чат сообщества: какие настройки по умолчанию свои.
                                  if (communityOverridesText(t, chat) case final own?)
                                    CupertinoListTileIcon(
                                      color: const Color(0xFF8E8E93),
                                      hugeIcon: HugeIcons.strokeRoundedArrowTurnBackward,
                                      title: Text(t.screenChatInfo.communityDefaults),
                                      subtitle: Text(own),
                                      onTab: () => _resetToCommunity(context),
                                    ),
                                ]),
                              // Вкладки — полосой над карточкой (как папки на «Чатах»: при
                              // переполнении листается по горизонтали), содержимое — карточкой.
                              if (tabs.length > 1)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                                  child: ChatFolderTabsCupertino(
                                    tabs: [for (final item in tabs) ChatFolderTab(title: chatInfoTabLabel(t, item, chat))],
                                    selectedIndex: tabs.indexOf(tab),
                                    onTap: (index) => setState(() => _tab = tabs[index]),
                                  ),
                                ),
                            ],
                          ),
                          // Участники — ленивым списком со страницами (их могут быть
                          // сотни тысяч), остальные вкладки — карточкой целиком.
                          if (tab == ChatInfoTab.members)
                            ChatMembersSliver(
                              chat: chat,
                              members: state.memberPage,
                              loading: state.memberPageLoading,
                              query: state.memberQuery,
                              // Поиск — когда листать долго (скрытый список не админу —
                              // только админы, искать незачем).
                              search: !membersOnlyAdmins(chat) && (state.membersTotal > 20 || state.memberQuery.isNotEmpty)
                                  ? SearchFieldCupertino(
                                      controller: _memberSearch,
                                      placeholder: t.screenChatInfo.membersSearch,
                                      onChanged: context.read<ChatCubit>().searchMembers,
                                    )
                                  : null,
                              loader: const CupertinoActivityIndicator(),
                              style: ChatInfoStyle(
                                text: label,
                                secondary: secondary,
                                accent: primary,
                                onAccent: ThemesCupertino.onAccent(context),
                                separator: CupertinoColors.separator.resolveFrom(context),
                                action: action,
                              ),
                              decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.fromLTRB(20, tabs.length > 1 ? 0 : 20, 20, 0),
                              onMemberTap: (member) => _messageMember(context, member),
                              memberWrapper: (member, row) =>
                                  RowContextMenuCupertino(background: card, actions: _memberMenuActions(context, chat, member), child: row),
                              onAddMembers: chat.canManage ? () => _addMembers(context) : null,
                            )
                          else if (tabs.isNotEmpty)
                            SliverToBoxAdapter(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(20, tabs.length > 1 ? 0 : 20, 20, 0),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      // Сетка медиа — до краёв карточки, списки — с отступом сверху.
                                      padding: EdgeInsets.only(
                                        top: tab == ChatInfoTab.media ? 0 : 6,
                                        bottom: tab == ChatInfoTab.media ? 0 : 6,
                                      ),
                                      child: ChatInfoTabContent(
                                        tab: tab,
                                        chat: chat,
                                        messages: state.messages,
                                        members: state.members,
                                        style: ChatInfoStyle(
                                          text: label,
                                          secondary: secondary,
                                          accent: primary,
                                          onAccent: ThemesCupertino.onAccent(context),
                                          separator: CupertinoColors.separator.resolveFrom(context),
                                          action: action,
                                        ),
                                        onOpenMessage: (id) => Navigator.of(context).pop(ChatInfoResult.goTo(id)),
                                        onMemberTap: (member) => _messageMember(context, member),
                                        memberWrapper: (member, row) => RowContextMenuCupertino(
                                          background: card,
                                          actions: _memberMenuActions(context, chat, member),
                                          child: row,
                                        ),
                                        onAddMembers: chat.canManage ? () => _addMembers(context) : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SliverToBoxAdapter(child: SizedBox(height: 32)),
                        ],
                      ),
                    ),
                    // Светлые значки строки состояния поверх обложки.
                    if (onCover)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: MediaQuery.viewPaddingOf(context).top,
                        child: const AnnotatedRegion<SystemUiOverlayStyle>(value: SystemUiOverlayStyle.light, child: SizedBox.expand()),
                      ),
                    if (onCover)
                      Positioned(
                        top: MediaQuery.viewPaddingOf(context).top + 4,
                        left: 8,
                        right: 8,
                        child: Row(
                          children: [
                            CoverGlassButton(
                              onTap: () => Navigator.of(context).maybePop(),
                              child: const Padding(padding: EdgeInsets.only(right: 2), child: Icon(CupertinoIcons.back)),
                            ),
                            const Spacer(),
                            if (canEdit)
                              CoverGlassButton(
                                label: t.common.edit,
                                onTap: () => showChatEditCupertino(context, chat),
                                child: const HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02, color: CupertinoColors.white, size: 20),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget _section(BuildContext context, List<Widget> children) => CupertinoListSection.insetGrouped(
    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
    decoration: BoxDecoration(
      color: ThemesCupertino.groupedCard.resolveFrom(context),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    children: children,
  );
}

/// Кнопка под шапкой профиля: значок и подпись на белой плашке; все кнопки
/// ряда — одной ширины.
class _ActionButton extends StatelessWidget {
  /// HugeIcons.* (сырые данные пути, не IconData).
  final List<List<dynamic>> icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  /// Есть — по тапу выпадающее меню вместо [onTap].
  final List<Widget>? menuChildren;

  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap, this.menuChildren});

  @override
  Widget build(BuildContext context) {
    final menu = menuChildren;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: menu == null
            ? _button(context, onTap)
            : CupertinoMenuAnchor(
                menuChildren: menu,
                builder: (context, controller, child) => _button(context, () => controller.isOpen ? controller.close() : controller.open()),
              ),
      ),
    );
  }

  Widget _button(BuildContext context, VoidCallback onPressed) => CupertinoButton(
    padding: EdgeInsets.zero,
    minimumSize: Size.zero,
    onPressed: onPressed,
    child: Container(
      // CupertinoButton центрирует содержимое — без этого плашка ужималась
      // по подписи, и кнопки выходили разной ширины.
      width: double.infinity,
      // Отступы внутри — подпись не прилипает к краям плашки.
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 9),
      // Белая плашка — цвет карточек (в тёмной теме — тёмная карточка).
      decoration: BoxDecoration(color: ThemesCupertino.groupedCard.resolveFrom(context), borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(icon: icon, size: 24, strokeWidth: 1.8, color: color),
          const SizedBox(height: 4),
          // Длинная подпись ужимается, а не обрезается.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Профиль чата → «Реакции» (iOS, админ): все / некоторые (сетка эмодзи) /
/// никаких. Сохраняется сразу.
class ChatReactionsSettingsCupertino extends StatelessWidget {
  const ChatReactionsSettingsCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChatInfo;
    final primary = CupertinoTheme.of(context).primaryColor;
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final chat = state.chat;
        final cubit = context.read<ChatCubit>();
        final mode = chat?.reactionsMode ?? models.ChatReactionsMode.all;
        final selected = chat?.reactions ?? const <String>[];
        void setMode(models.ChatReactionsMode value) {
          HapticFeedback.selectionClick();
          // «Некоторые» впервые — начинаем с набора личных чатов.
          cubit.setChatReactions(value, value == models.ChatReactionsMode.some && selected.isEmpty ? privateChatReactions : selected);
        }

        Widget modeTile(models.ChatReactionsMode value, String title) => CupertinoListTile(
          title: Text(title),
          trailing: mode == value ? Icon(CupertinoIcons.checkmark_alt, color: primary) : null,
          onTap: () => setMode(value),
        );

        return CupertinoPageScaffold(
          backgroundColor: background,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: background,
              middle: Text(t.reactions),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  backgroundColor: background,
                  decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
                  footer: createNoteCupertino(t.reactionsFooter),
                  children: [
                    modeTile(models.ChatReactionsMode.all, t.reactionsAll),
                    modeTile(models.ChatReactionsMode.some, t.reactionsSome),
                    modeTile(models.ChatReactionsMode.none, t.reactionsNone),
                  ],
                ),
                if (mode == models.ChatReactionsMode.some)
                  CupertinoListSection.insetGrouped(
                    backgroundColor: background,
                    decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
                    // Заголовок — как у секций настроек (по умолчанию 20 bold).
                    header: createHeaderCupertino(t.reactionsPick),
                    children: [
                      // Во всю ширину секции — как блок выше (иначе карточка
                      // ужимается по сетке эмодзи).
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: ReactionsGrid(
                          selected: selected,
                          highlight: primary,
                          onToggle: (emoji) {
                            HapticFeedback.selectionClick();
                            cubit.setChatReactions(
                              models.ChatReactionsMode.some,
                              selected.contains(emoji)
                                  ? [
                                      for (final e in selected)
                                        if (e != emoji) e,
                                    ]
                                  : [
                                      for (final e in allChatReactions)
                                        if (selected.contains(e) || e == emoji) e,
                                    ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                if (chat?.type == models.ChatType.channel && mode != models.ChatReactionsMode.none)
                  CupertinoListSection.insetGrouped(
                    backgroundColor: background,
                    decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
                    header: createHeaderCupertino(t.maxReactions),
                    footer: createNoteCupertino(t.maxReactionsFooter),
                    children: [
                      _MaxReactionsSlider(
                        value: chat!.maxReactions,
                        onChanged: (value) => cubit.setChatReactions(mode, selected, maxReactions: value),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Ползунок «Максимум реакций под постом» (1–11): значение справа меняется
/// на ходу, сохраняется, когда палец отпущен.
class _MaxReactionsSlider extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _MaxReactionsSlider({required this.value, required this.onChanged});

  @override
  State<_MaxReactionsSlider> createState() => _MaxReactionsSliderState();
}

class _MaxReactionsSliderState extends State<_MaxReactionsSlider> {
  late double _value = widget.value.toDouble();

  @override
  void didUpdateWidget(_MaxReactionsSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _value = widget.value.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: CupertinoSlider(
              value: _value,
              min: 1,
              max: maxReactionsPerPost.toDouble(),
              divisions: maxReactionsPerPost - 1,
              onChanged: (value) {
                if (value.round() != _value.round()) HapticFeedback.selectionClick();
                setState(() => _value = value);
              },
              onChangeEnd: (value) => widget.onChanged(value.round()),
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${_value.round()}',
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: CupertinoColors.label.resolveFrom(context)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Профиль чата → «Медленный режим» (iOS, админ группы/сообщества): выкл. или
/// интервал. Сохраняется сразу.
class ChatSlowModeSettingsCupertino extends StatelessWidget {
  const ChatSlowModeSettingsCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final primary = CupertinoTheme.of(context).primaryColor;
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final current = state.chat?.slowMode ?? 0;
        return CupertinoPageScaffold(
          backgroundColor: background,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: background,
              middle: Text(t.screenChatInfo.slowMode),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  backgroundColor: background,
                  decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
                  footer: createNoteCupertino(t.screenChatInfo.slowModeFooter),
                  children: [
                    for (final seconds in slowModeOptions)
                      CupertinoListTile(
                        title: Text(slowModeLabel(t, seconds)),
                        trailing: current == seconds ? Icon(CupertinoIcons.checkmark_alt, color: primary) : null,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.read<ChatCubit>().setSlowMode(seconds);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
