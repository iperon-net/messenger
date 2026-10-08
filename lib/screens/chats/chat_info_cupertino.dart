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

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadMembers();
  }

  Future<void> _leave(BuildContext context, models.Chat chat) async {
    final t = context.t.screenChatInfo;
    final private = chat.type == models.ChatType.private;
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(private ? t.deleteChatTitle(name: chat.title) : t.leaveGroupTitle(name: chat.title)),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(_leaveLabel(context.t, chat)),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false) || !context.mounted) return;
    await context.read<ChatCubit>().deleteChat();
    if (context.mounted) context.go('/chats');
  }

  /// «Звук»: заглушённый — включить сразу, иначе — «Заглушить на…».
  Future<void> _toggleMute(BuildContext context, models.Chat chat) async {
    final cubit = context.read<ChatCubit>();
    if (chat.muted) return cubit.setMuted(false);
    final choice = await pickChatMute(context);
    if (choice != null) await cubit.setMuted(true, until: chatMuteUntil(choice));
  }

  /// Тап по участнику — личный чат с ним («Написать сообщение»).
  Future<void> _messageMember(BuildContext context, models.ChatMember member) async {
    if (member.isSelf) return;
    final chatID = await context.read<ChatCubit>().privateChatWith(member);
    if (chatID != null && chatID.isNotEmpty && context.mounted) context.go('/chats/chat/$chatID');
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
          member.role == models.ChatRole.admin ? context.t.screenChatAdmins.adminRights : context.t.screenChatAdmins.promote,
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
          if (await confirm(t.removeMemberTitle(name: member.name), t.removeMemberMessage, t.removeMember)) {
            await cubit.removeMember(member);
          }
        }, destructive: true),
        rowMenuAction(context, t.banMember, CupertinoIcons.nosign, () async {
          if (await confirm(t.banMemberTitle(name: member.name), t.banMemberMessage, t.banMember)) {
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
        final subtitle = chat == null ? null : chatSubtitle(t, chat);
        return CupertinoPageScaffold(
          backgroundColor: background,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: background,
              border: null,
              // «Изменить» — админу группы / канала / сообщества.
              trailing: chat != null && chat.canManage && chat.type != models.ChatType.private
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => showChatEditCupertino(context, chat),
                      child: Text(t.common.edit, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
                    )
                  : null,
            ),
          ),
          child: chat == null
              ? const SizedBox.shrink()
              : SafeArea(
                  bottom: false,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 32),
                    children: [
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
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            if (!chat.isSelf)
                              _ActionButton(
                                // Значок — текущее состояние: звук включён / выключен.
                                icon: chat.muted ? HugeIcons.strokeRoundedNotificationOff01 : HugeIcons.strokeRoundedNotification01,
                                // Заглушён на время — «до 18:30» вместо «Звук».
                                label: chat.muted && chat.mutedUntil != null
                                    ? chatMutedUntilLabel(t, chat.mutedUntil!)
                                    : t.screenChatInfo.sound,
                                color: action,
                                onTap: () => _toggleMute(context, chat),
                              ),
                            _ActionButton(
                              icon: HugeIcons.strokeRoundedSearch01,
                              label: t.screenChatInfo.search,
                              color: action,
                              onTap: () => Navigator.of(context).pop(const ChatInfoResult.search()),
                            ),
                            if (!chat.isSelf)
                              _ActionButton(
                                icon: HugeIcons.strokeRoundedSquareArrowRightExit,
                                label: t.screenChatInfo.leaveShort,
                                color: CupertinoColors.destructiveRed.resolveFrom(context),
                                onTap: () => _leave(context, chat),
                              ),
                          ],
                        ),
                      ),
                      if (chat.about.isNotEmpty || chat.linkPath.isNotEmpty)
                        _section(context, [
                          if (chat.about.isNotEmpty)
                            CupertinoListTileIcon(
                              color: const Color(0xFF1368E6),
                              hugeIcon: HugeIcons.strokeRoundedInformationCircle,
                              title: Text(chat.about, maxLines: 6),
                              subtitle: Text(chat.type == models.ChatType.private ? t.screenChatInfo.about : t.screenChatInfo.description),
                              onTab: () async => _copy(chat.about),
                            ),
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
                      if (chat.canManage && chat.type != models.ChatType.private)
                        _section(context, [
                          CupertinoListTileIcon(
                            color: const Color(0xFF049A40),
                            hugeIcon: HugeIcons.strokeRoundedLink01,
                            title: Text(t.screenChatInvites.inviteLinks),
                            isTrailing: true,
                            onTab: () => showChatInviteLinksCupertino(context, chat.id),
                          ),
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
                                builder: (_) =>
                                    BlocProvider.value(value: context.read<ChatCubit>(), child: const ChatReactionsSettingsCupertino()),
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
                                  builder: (_) =>
                                      BlocProvider.value(value: context.read<ChatCubit>(), child: const ChatSlowModeSettingsCupertino()),
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
                          if (chat.type == models.ChatType.group || chat.type == models.ChatType.community)
                            CupertinoListTileIcon(
                              color: const Color(0xFFFF3B30),
                              hugeIcon: HugeIcons.strokeRoundedUserBlock01,
                              title: Text(t.screenChatInfo.banned),
                              additionalInfo: state.banned.isEmpty ? null : Text('${state.banned.length}'),
                              isTrailing: true,
                              onTab: () => showChatBannedCupertino(context, context.read<ChatCubit>()),
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
                      Container(
                        margin: EdgeInsets.fromLTRB(20, tabs.length > 1 ? 0 : 20, 20, 0),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              // Сетка медиа — до краёв карточки, списки — с отступом сверху.
                              padding: EdgeInsets.only(top: tab == ChatInfoTab.media ? 0 : 6, bottom: tab == ChatInfoTab.media ? 0 : 6),
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
                    ],
                  ),
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

/// «Удалить чат» / «Покинуть группу / канал / сообщество».
String _leaveLabel(Translations t, models.Chat chat) => switch (chat.type) {
  models.ChatType.private => t.screenChatInfo.deleteChat,
  models.ChatType.group => t.screenChatInfo.leaveGroup,
  models.ChatType.channel => t.screenChatInfo.leaveChannel,
  models.ChatType.community => t.screenChatInfo.leaveCommunity,
};

/// Кнопка под шапкой профиля: значок и подпись на белой плашке; все кнопки
/// ряда — одной ширины.
class _ActionButton extends StatelessWidget {
  /// HugeIcons.* (сырые данные пути, не IconData).
  final List<List<dynamic>> icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          onPressed: onTap,
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
        ),
      ),
    );
  }
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
              ],
            ),
          ),
        );
      },
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
