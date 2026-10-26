import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../split_layout.dart';
import '../../chats/media_prepare.dart' show thumbhashImage;
import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import '../chats/chat_actions_cupertino.dart';
import '../chats/chat_common.dart';
import '../chats/chat_info_common.dart';
import '../chats/chat_info_cupertino.dart';
import '../chats/chat_mute.dart';
import '../chats/chat_no_forwards.dart';
import '../chats/chat_ttl.dart';
import '../chats/secret_chat_common.dart';
import '../home/contacts_add_cupertino.dart';
import 'profile_common.dart';

/// Профиль пользователя (iOS) — один экран, откуда бы его ни открыли:
/// Контакты, Звонки, участник группы, упоминание или шапка личного чата
/// ([fromChat], тогда cubit чата — от окна чата, а результат — [ChatInfoResult]).
/// Данные человека — [ProfileCubit]; если с ним уже есть переписка (локально),
/// ещё и секции чата: «Звук», «Ещё» (автоудаление, защита, удалить),
/// вкладки медиа.
class ProfileCupertino extends StatelessWidget {
  final bool fromChat;

  const ProfileCupertino({super.key, this.fromChat = false});

  @override
  Widget build(BuildContext context) {
    if (fromChat) return const _ProfileView(fromChat: true, hasChat: true);
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.chatID != current.chatID || previous.chatResolved != current.chatResolved,
      builder: (context, state) {
        // Чат ищется в локальной БД (миллисекунды) — не рисуем профиль без
        // его секций, чтобы он не перестроился у пользователя на глазах.
        if (!state.chatResolved) {
          return CupertinoPageScaffold(backgroundColor: ThemesCupertino.groupedBackground, child: const SizedBox.shrink());
        }
        if (state.chatID.isEmpty) return const _ProfileView(fromChat: false, hasChat: false);
        return BlocProvider<ChatCubit>(
          key: ValueKey(state.chatID),
          create: (context) => ChatCubit()
            ..initialization(
              chatID: state.chatID,
              demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
              // Профиль переписку не читает — только показывает её секции.
              markRead: false,
            ),
          child: const _ProfileView(fromChat: false, hasChat: true),
        );
      },
    );
  }
}

class _ProfileView extends StatefulWidget {
  final bool fromChat;

  /// В дереве есть [ChatCubit] личного чата.
  final bool hasChat;

  const _ProfileView({required this.fromChat, required this.hasChat});

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  ChatInfoTab? _tab;

  /// Hero аватара в шапке и в полноэкранном просмотре.
  final _avatarHero = Object();

  /// «Начать секретный чат» в «Ещё» (проверка асинхронная: флаги и Premium
  /// из кэша).
  bool _secretAvailable = false;

  @override
  void initState() {
    super.initState();
    final userID = context.read<ProfileCubit>().state.userID;
    if (!profileIsSelf(userID) && !profileIsSystem(userID)) {
      secretChatAvailable(userID).then((available) {
        if (mounted && available != _secretAvailable) setState(() => _secretAvailable = available);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profile) => widget.hasChat
          ? BlocBuilder<ChatCubit, ChatState>(builder: (context, chatState) => _build(context, profile, chatState))
          : _build(context, profile, null),
    );
  }

  /// «Сообщение»: из окна чата — назад в него, иначе — личный чат (новый
  /// создаёт сервер); вернулись — переписка могла появиться.
  Future<void> _message(BuildContext context, ProfileState profile) async {
    if (widget.fromChat) {
      Navigator.of(context).pop();
      return;
    }
    final cubit = context.read<ProfileCubit>();
    await openPrivateChatWith(context, profileHex(profile.userID));
    if (!cubit.isClosed) await cubit.resolveChat();
  }

  /// Чат удалён: из окна чата — в список, иначе остаёмся в профиле без
  /// секций чата.
  Future<void> _afterDelete(BuildContext context, ProfileCubit profileCubit, models.Chat chat) async {
    if (widget.fromChat) {
      if (context.mounted) context.go(chatLeaveRoute(chat));
    } else {
      await profileCubit.resolveChat();
    }
  }

  Future<void> _delete(BuildContext context, models.Chat chat) async {
    final chatCubit = context.read<ChatCubit>();
    final profileCubit = context.read<ProfileCubit>();
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
    if (!(confirmed ?? false)) return;
    // Без сети чат не удалён — остаёмся (cubit покажет «Нет соединения»).
    if (!await chatCubit.deleteChat()) return;
    if (context.mounted) await _afterDelete(context, profileCubit, chat);
  }

  /// Заблокировать (с подтверждением) / разблокировать. Серверная операция:
  /// без сети — общий алерт, ничего не меняем.
  Future<void> _setBlocked(BuildContext context, ProfileState profile, bool blocked) async {
    final cubit = context.read<ProfileCubit>();
    if (blocked) {
      final t = context.t.screenProfile;
      final confirmed = await showCupertinoDialog<bool>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: Text(t.blockTitle(name: profile.displayName)),
          content: Text(t.blockMessage),
          actions: [
            CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
            CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.block)),
          ],
        ),
      );
      if (!(confirmed ?? false)) return;
    }
    if (!await cubit.setBlocked(blocked) && context.mounted) await showNoConnectionAlert(context);
  }

  /// «Изменить» (контакт) / «Добавить в контакты»: форма контакта (как в
  /// Контактах), затем добавить / переименовать / удалить.
  Future<void> _editContact(BuildContext context, ProfileState profile) async {
    final input = await Navigator.of(context).push<ContactAddInput>(
      FullSwipeBackRoute(
        builder: (_) => ContactsAddCupertino(
          initial: profileContactInitial(profile),
          edit: profile.isContact,
          removable: profile.isContact && profileContactRemovable(profile),
        ),
      ),
    );
    if (input == null || !context.mounted) return;
    final t = context.t;
    final result = await profileApplyContact(t, profile, input);
    if (!context.mounted) return;
    if (result.noConnection) {
      await showNoConnectionAlert(context);
    } else if (result.error case final error?) {
      await showCupertinoDialog<void>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          content: Text(error),
          actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(t.common.done))],
        ),
      );
    }
  }

  /// Пункты «Ещё»: «Добавить в контакты» (не контакт, номер известен), секретный чат, автоудаление и защита содержимого (есть
  /// переписка), «Скрыть профиль», удалить чат («у обоих / только у меня» —
  /// меню от той же кнопки).
  List<ChatInfoMoreItem> _moreItems(BuildContext context, ProfileState profile, models.Chat? chat) {
    if (profileIsSelf(profile.userID)) return const [];
    final t = context.t;
    final chatCubit = chat == null ? null : context.read<ChatCubit>();
    final profileCubit = context.read<ProfileCubit>();
    // «Iperon» — только удалить чат (новое уведомление вернёт его).
    if (profileIsSystem(profile.userID)) {
      return [
        if (chat != null && chatCubit != null)
          ChatInfoMoreItem(
            title: chatLeaveLabel(t, chat),
            icon: CupertinoIcons.delete,
            destructive: true,
            onTap: () => _delete(context, chat),
          ),
      ];
    }
    return [
      if (!profile.isContact && profile.phoneNumber.isNotEmpty)
        ChatInfoMoreItem(
          title: t.screenContacts.addToContacts,
          icon: CupertinoIcons.person_badge_plus,
          onTap: () => _editContact(context, profile),
        ),
      if (_secretAvailable)
        ChatInfoMoreItem(title: t.secretChat.start, icon: CupertinoIcons.lock, onTap: () => startSecretChat(context, profile.userID)),
      if (chat != null && chatCubit != null) ...[
        ChatInfoMoreItem(
          title: t.chatTtl.titleLong,
          subtitle: chatTTLLabel(t, chat.ttlPeriod),
          icon: CupertinoIcons.timer,
          submenu: chatTTLMenuCupertino(context, chat.ttlPeriod, (period) => setChatTTL(context, chatCubit, period)),
        ),
        ChatInfoMoreItem(
          title: chatNoForwardsActionLabel(t, noForwards: chat.noForwards, mine: chat.noForwardsMine),
          icon: chat.noForwards ? CupertinoIcons.lock_open : CupertinoIcons.lock_shield,
          onTap: () => setChatNoForwards(context, chatCubit, !chat.noForwards),
        ),
      ],
      ChatInfoMoreItem(
        title: t.screenProfile.hideProfile,
        icon: CupertinoIcons.eye_slash,
        onTap: () => context.push('${profileRoute(context, profileHex(profile.userID))}/hide'),
      ),
      ChatInfoMoreItem(
        title: profile.blocked ? t.screenProfile.unblock : t.screenProfile.block,
        icon: profile.blocked ? CupertinoIcons.hand_raised_slash : CupertinoIcons.hand_raised,
        destructive: !profile.blocked,
        onTap: () => _setBlocked(context, profile, !profile.blocked),
      ),
      if (chat != null && chatCubit != null)
        ChatInfoMoreItem(
          title: chatLeaveLabel(t, chat),
          icon: CupertinoIcons.delete,
          destructive: true,
          submenu: chatDeleteScoped(chat)
              ? scopeMenuCupertino(context, (forEveryone) async {
                  if (!await chatCubit.deleteChat(forEveryone: forEveryone)) return;
                  if (context.mounted) await _afterDelete(context, profileCubit, chat);
                })
              : null,
          onTap: () => _delete(context, chat),
        ),
    ];
  }

  Widget _section(BuildContext context, List<Widget> children) => CupertinoListSection.insetGrouped(
    clipBehavior: Clip.antiAlias,
    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
    decoration: BoxDecoration(
      color: ThemesCupertino.groupedCard.resolveFrom(context),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    children: children,
  );

  /// Строка данных: значение (копируется по тапу — пузырёк «Скопировать») и
  /// подпись под ним.
  Widget _field(
    BuildContext context, {
    required Color color,
    required List<List<dynamic>> icon,
    required String value,
    required String label,
    String? copy,
    int maxLines = 1,
  }) => CopyTooltip(
    value: copy ?? value,
    label: context.t.screenProfile.copy,
    child: CupertinoListTileIcon(
      color: color,
      hugeIcon: icon,
      title: Text(value, maxLines: maxLines, overflow: TextOverflow.ellipsis),
      subtitle: Text(label),
      onTab: null,
    ),
  );

  /// Аватар: есть фото — тап открывает его во весь экран.
  Widget _avatar(BuildContext context, ProfileState profile, String name) {
    final preview = thumbhashImage(profile.avatarThumbhash);
    return SizedBox(
      width: 96,
      height: 96,
      child: profileIsSystem(profile.userID)
          ? SystemAccountAvatar(
              size: 96,
              background: CupertinoTheme.of(context).primaryColor,
              foreground: ThemesCupertino.onAccent(context),
            )
          : profile.avatarBytes != null
          ? GestureDetector(
              onTap: () => showAvatarViewer(context, bytes: profile.avatarBytes!, heroTag: _avatarHero, title: name),
              child: Hero(
                tag: _avatarHero,
                child: ClipOval(
                  child: Image.memory(
                    profile.avatarBytes!,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    // Декодируем под размер слота, а не в полный битмап исходной
                    // (крупной) аватарки.
                    cacheWidth: (96 * MediaQuery.devicePixelRatioOf(context)).round(),
                    cacheHeight: (96 * MediaQuery.devicePixelRatioOf(context)).round(),
                  ),
                ),
              ),
            )
          // Фото ещё качается — размытое превью вместо заглушки.
          : preview != null
          ? ClipOval(
              child: Image(image: preview, width: 96, height: 96, fit: BoxFit.cover, gaplessPlayback: true),
            )
          : AnimatedBoringAvatar(
              name: profile.boringAvatarHash,
              type: profile.boringAvatarType,
              shape: const CircleBorder(),
              curve: Curves.bounceIn,
              duration: const Duration(seconds: 1),
            ),
    );
  }

  Widget _build(BuildContext context, ProfileState profile, ChatState? chatState) {
    final t = context.t;
    final primary = CupertinoTheme.of(context).primaryColor;
    final action = ThemesCupertino.actionColor(context);
    final label = CupertinoColors.label.resolveFrom(context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final chat = chatState?.chat;
    final self = profileIsSelf(profile.userID);
    final system = profileIsSystem(profile.userID);
    final name = profile.displayName.isNotEmpty ? profile.displayName : (chat == null ? '' : ChatTileContent.title(t, chat));
    // Из окна чата — его подзаголовок («печатает…» тоже), иначе — присутствие.
    final subtitle = self
        ? null
        : (system
              ? (text: t.systemNotice.subtitle, active: false)
              : (chat != null ? chatSubtitle(t, chat) : userPresence(t, online: profile.online, lastSeen: profile.lastSeen)));
    final tabs = chat == null ? const <ChatInfoTab>[] : chatInfoTabs(chat);
    final tab = tabs.contains(_tab) ? _tab! : (tabs.firstOrNull ?? ChatInfoTab.media);
    final moreItems = _moreItems(context, profile, chat);
    final birthDate = profile.birthDate;
    final username = profile.username.isEmpty || profile.username.startsWith('@') ? profile.username : '@${profile.username}';
    final style = ChatInfoStyle(
      text: label,
      secondary: secondary,
      accent: primary,
      onAccent: ThemesCupertino.onAccent(context),
      separator: CupertinoColors.separator.resolveFrom(context),
      action: action,
    );

    return CupertinoPageScaffold(
      backgroundColor: background,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          // iPad: корень правой панели — без «назад», список слева.
          automaticallyImplyLeading: !context.isSplitPaneRoot,
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          backgroundColor: background,
          border: null,
          // Контакт — «Изменить»: имя, как я его записал, или удалить.
          trailing: profile.isContact && !self
              ? NavBarButtonCupertino(NavBarAction.edit, onPressed: () => _editContact(context, profile))
              : null,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            const SizedBox(height: 4),
            Center(child: _avatar(context, profile, name)),
            if (name.isNotEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: label),
                ),
              ),
            ],
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
            if (profile.userID.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Из окна чата писать и так есть где — там вместо «Сообщения» «Поиск».
                    if (!widget.fromChat)
                      ChatInfoActionButton(
                        icon: HugeIcons.strokeRoundedMessage01,
                        label: t.screenChatInfo.message,
                        color: action,
                        onTap: () => _message(context, profile),
                      ),
                    // Заблокированному и «Iperon» не звоним (сервер и так не пропустит).
                    if (!self && !system && !profile.blocked) ...[
                      ChatInfoActionButton(
                        icon: HugeIcons.strokeRoundedCall02,
                        label: t.screenChatInfo.call,
                        color: action,
                        onTap: () => profileCall(profile.userID, video: false),
                      ),
                      ChatInfoActionButton(
                        icon: HugeIcons.strokeRoundedVideo01,
                        label: t.screenChatInfo.video,
                        color: action,
                        onTap: () => profileCall(profile.userID, video: true),
                      ),
                    ],
                    if (chat != null)
                      ChatInfoActionButton(
                        // Значок — текущее состояние: звук включён / выключен.
                        icon: chat.muted ? HugeIcons.strokeRoundedNotificationOff01 : HugeIcons.strokeRoundedNotification01,
                        // Заглушён на время — «до 18:30» вместо «Звук».
                        label: chat.muted && chat.mutedUntil != null ? chatMutedUntilLabel(t, chat.mutedUntil!) : t.screenChatInfo.sound,
                        color: action,
                        onTap: () => context.read<ChatCubit>().setMuted(false),
                        menuChildren: chatMuteMenuCupertino(context, chat),
                      ),
                    if (widget.fromChat)
                      ChatInfoActionButton(
                        icon: HugeIcons.strokeRoundedSearch01,
                        label: t.screenChatInfo.search,
                        color: action,
                        onTap: () => Navigator.of(context).pop(const ChatInfoResult.search()),
                      ),
                    if (moreItems.isNotEmpty) ChatInfoMoreButton(label: t.screenChatInfo.more, color: action, items: moreItems),
                  ],
                ),
              ),
            if (profile.phoneNumber.isNotEmpty || profile.aboutMe.isNotEmpty || username.isNotEmpty || birthDate != null)
              _section(context, [
                if (profile.phoneNumber.isNotEmpty)
                  _field(
                    context,
                    color: const Color(0xFF34C759),
                    icon: HugeIcons.strokeRoundedSmartPhone01,
                    value: profile.phoneNumber,
                    label: t.screenProfile.mobilePhone,
                  ),
                if (profile.aboutMe.isNotEmpty)
                  _field(
                    context,
                    color: const Color(0xFF1368E6),
                    icon: HugeIcons.strokeRoundedInformationCircle,
                    value: profile.aboutMe,
                    label: t.screenChatInfo.about,
                    maxLines: 6,
                  ),
                if (username.isNotEmpty)
                  _field(
                    context,
                    color: const Color(0xFF049A40),
                    icon: HugeIcons.strokeRoundedAt,
                    value: username,
                    label: t.screenChatInfo.username,
                  ),
                if (birthDate != null)
                  _field(
                    context,
                    color: const Color(0xFFFF9500),
                    icon: HugeIcons.strokeRoundedBirthdayCake,
                    value: profileBirthDateText(t, birthDate, hideYear: profile.hideBirthYear),
                    label: t.screenProfile.birthDate,
                  ),
              ]),
            if (profile.blocked)
              _section(context, [
                CupertinoListTile(
                  title: Text(t.screenProfile.unblock, style: TextStyle(color: action)),
                  subtitle: Text(t.screenProfile.blockedNote),
                  onTap: () => _setBlocked(context, profile, false),
                ),
              ]),
            // Вкладки — полосой над карточкой (как в профиле чата), содержимое — карточкой.
            if (chat != null && chatState != null && tabs.isNotEmpty) ...[
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
                child: Padding(
                  // Сетка медиа — до краёв карточки, списки — с отступом сверху.
                  padding: EdgeInsets.symmetric(vertical: tab == ChatInfoTab.media ? 0 : 6),
                  child: ChatInfoTabContent(
                    tab: tab,
                    chat: chat,
                    messages: chatState.messages,
                    members: chatState.members,
                    style: style,
                    // Из окна чата — назад к сообщению, иначе — открыть чат.
                    onOpenMessage: (id) =>
                        widget.fromChat ? Navigator.of(context).pop(ChatInfoResult.goTo(id)) : openChat(context, '/chats/chat/${chat.id}'),
                  ),
                ),
              ),
            ],
            SizedBox(height: 32 + MediaQuery.paddingOf(context).bottom),
          ],
        ),
      ),
    );
  }
}
