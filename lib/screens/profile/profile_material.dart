import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import '../chats/chat_actions_material.dart';
import '../chats/chat_common.dart';
import '../chats/chat_info_common.dart';
import '../chats/chat_info_material.dart';
import '../chats/chat_mute.dart';
import '../chats/chat_no_forwards.dart';
import '../chats/chat_ttl.dart';
import '../chats/secret_chat_common.dart';
import '../home/contacts_add_material.dart';
import 'profile_common.dart';

/// Профиль пользователя (Android) — один экран, откуда бы его ни открыли:
/// Контакты, Звонки, участник группы, упоминание или шапка личного чата
/// ([fromChat], тогда cubit чата — от окна чата, а результат — [ChatInfoResult]).
/// Данные человека — [ProfileCubit]; если с ним уже есть переписка (локально),
/// ещё и секции чата: «Звук», «Ещё» (автоудаление, защита, удалить),
/// вкладки медиа.
class ProfileMaterial extends StatelessWidget {
  final bool fromChat;

  const ProfileMaterial({super.key, this.fromChat = false});

  @override
  Widget build(BuildContext context) {
    if (fromChat) return const _ProfileView(fromChat: true, hasChat: true);
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.chatID != current.chatID || previous.chatResolved != current.chatResolved,
      builder: (context, state) {
        // Чат ищется в локальной БД (миллисекунды) — не рисуем профиль без
        // его секций, чтобы он не перестроился у пользователя на глазах.
        if (!state.chatResolved) {
          return Scaffold(backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow);
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
    if (!profileIsSelf(userID)) {
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

  /// Заблокировать (с подтверждением) / разблокировать. Серверная операция:
  /// без сети — общий алерт, ничего не меняем.
  Future<void> _setBlocked(BuildContext context, ProfileState profile, bool blocked) async {
    final cubit = context.read<ProfileCubit>();
    if (blocked) {
      final t = context.t.screenProfile;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(t.blockTitle(name: profile.displayName)),
          content: Text(t.blockMessage),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(t.block),
            ),
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
    final messenger = ScaffoldMessenger.of(context);
    final input = await Navigator.of(context).push<ContactAddInput>(
      FullSwipeBackRoute(
        builder: (_) => ContactsAddMaterial(
          initial: profileContactInitial(profile),
          edit: profile.isContact,
          removable: profile.isContact && profileContactRemovable(profile),
        ),
      ),
    );
    if (input == null || !context.mounted) return;
    final result = await profileApplyContact(context.t, profile, input);
    if (result.noConnection) {
      if (context.mounted) await showNoConnectionAlert(context);
    } else if (result.error case final error?) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  /// «Ещё»: шторка — «Добавить в контакты» (не контакт, номер известен), секретный чат, автоудаление и защита содержимого (есть
  /// переписка), «Скрыть профиль», удалить чат; выбор у пункта — следующей
  /// шторкой.
  Future<void> _more(BuildContext context, ProfileState profile, models.Chat? chat) async {
    final t = context.t;
    final error = Theme.of(context).colorScheme.error;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!profile.isContact && profile.phoneNumber.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.person_add_alt_outlined),
                title: Text(t.screenContacts.addToContacts),
                onTap: () => Navigator.of(sheetContext).pop('addContact'),
              ),
            if (_secretAvailable)
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(t.secretChat.start),
                onTap: () => Navigator.of(sheetContext).pop('secret'),
              ),
            if (chat != null) ...[
              ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: Text(t.chatTtl.titleLong),
                subtitle: Text(chatTTLLabel(t, chat.ttlPeriod)),
                onTap: () => Navigator.of(sheetContext).pop('ttl'),
              ),
              ListTile(
                leading: Icon(chat.noForwards ? Icons.lock_open_outlined : Icons.shield_outlined),
                title: Text(chatNoForwardsActionLabel(t, noForwards: chat.noForwards, mine: chat.noForwardsMine)),
                onTap: () => Navigator.of(sheetContext).pop('noForwards'),
              ),
            ],
            ListTile(
              leading: const Icon(Icons.visibility_off_outlined),
              title: Text(t.screenProfile.hideProfile),
              onTap: () => Navigator.of(sheetContext).pop('hide'),
            ),
            ListTile(
              leading: Icon(Icons.block, color: profile.blocked ? null : error),
              title: Text(
                profile.blocked ? t.screenProfile.unblock : t.screenProfile.block,
                style: profile.blocked ? null : TextStyle(color: error),
              ),
              onTap: () => Navigator.of(sheetContext).pop('block'),
            ),
            if (chat != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: error),
                title: Text(chatLeaveLabel(t, chat), style: TextStyle(color: error)),
                onTap: () => Navigator.of(sheetContext).pop('delete'),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'addContact':
        await _editContact(context, profile);
      case 'secret':
        await startSecretChat(context, profile.userID);
      case 'ttl':
        final cubit = context.read<ChatCubit>();
        final period = await pickChatTTLMaterial(context, chat!.ttlPeriod);
        if (period != null && period != chat.ttlPeriod && context.mounted) await setChatTTL(context, cubit, period);
      case 'noForwards':
        await setChatNoForwards(context, context.read<ChatCubit>(), !chat!.noForwards);
      case 'hide':
        await context.push('/profile/${profileHex(profile.userID)}/hide');
      case 'block':
        await _setBlocked(context, profile, !profile.blocked);
      case 'delete':
        await _delete(context, chat!);
    }
  }

  /// Удалить чат (личный — с выбором «и у собеседника»): из окна чата — в
  /// список, иначе остаёмся в профиле без секций чата.
  Future<void> _delete(BuildContext context, models.Chat chat) async {
    final chatCubit = context.read<ChatCubit>();
    final profileCubit = context.read<ProfileCubit>();
    final forEveryone = await askDeleteChatMaterial(context, chat);
    if (forEveryone == null) return;
    // Без сети чат не удалён — остаёмся (cubit покажет «Нет соединения»).
    if (!await chatCubit.deleteChat(forEveryone: forEveryone)) return;
    if (widget.fromChat) {
      if (context.mounted) context.go(chatLeaveRoute(chat));
    } else {
      await profileCubit.resolveChat();
    }
  }

  /// Строка данных: значение (копируется по тапу — пузырёк «Скопировать») и
  /// подпись под ним.
  Widget _field(
    BuildContext context, {
    required List<List<dynamic>> icon,
    required String value,
    required String label,
    String? copy,
    int maxLines = 1,
  }) => CopyTooltip(
    value: copy ?? value,
    label: context.t.screenProfile.copy,
    child: ListTile(
      leading: HugeIcon(icon: icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
      title: Text(value, maxLines: maxLines, overflow: TextOverflow.ellipsis),
      subtitle: Text(label),
    ),
  );

  /// Аватар: есть фото — тап открывает его во весь экран.
  Widget _avatar(BuildContext context, ProfileState profile, String name) => SizedBox(
    width: 96,
    height: 96,
    child: profile.avatarBytes != null
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
                  // Аватар может прийти в исходном разрешении (2000+ px, ~1 МБ).
                  // Без cacheWidth/cacheHeight движок декодирует его в полный
                  // битмап (для 2316² это ~21 МБ) на слот 96×96 — отсюда сотни мс
                  // декода и дропнутые кадры при открытии. Декодируем сразу под
                  // размер слота в физических пикселях.
                  cacheWidth: (96 * MediaQuery.devicePixelRatioOf(context)).round(),
                  cacheHeight: (96 * MediaQuery.devicePixelRatioOf(context)).round(),
                ),
              ),
            ),
          )
        : AnimatedBoringAvatar(
            name: profile.boringAvatarHash,
            type: profile.boringAvatarType,
            shape: const CircleBorder(),
            curve: Curves.bounceIn,
            duration: const Duration(seconds: 1),
          ),
  );

  Widget _build(BuildContext context, ProfileState profile, ChatState? chatState) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = dark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;
    final chat = chatState?.chat;
    final self = profileIsSelf(profile.userID);
    final name = profile.displayName.isNotEmpty ? profile.displayName : (chat == null ? '' : ChatTileContent.title(t, chat));
    // Из окна чата — его подзаголовок («печатает…» тоже), иначе — присутствие.
    final subtitle = self
        ? null
        : (chat != null ? chatSubtitle(t, chat) : userPresence(t, online: profile.online, lastSeen: profile.lastSeen));
    final tabs = chat == null ? const <ChatInfoTab>[] : chatInfoTabs(chat);
    final tab = tabs.contains(_tab) ? _tab! : (tabs.firstOrNull ?? ChatInfoTab.media);
    final birthDate = profile.birthDate;
    final username = profile.username.isEmpty || profile.username.startsWith('@') ? profile.username : '@${profile.username}';

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: scheme.surfaceContainerLow,
        scrolledUnderElevation: 0,
        actions: [
          // Контакт — «Изменить»: имя, как я его записал, или удалить.
          if (profile.isContact && !self)
            IconButton(
              tooltip: t.screenContacts.editContact,
              onPressed: () => _editContact(context, profile),
              icon: const HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02),
            ),
        ],
      ),
      body: ListView(
        children: [
          Center(child: _avatar(context, profile, name)),
          if (name.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(name, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
            ),
          ],
          if (subtitle != null && subtitle.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                subtitle.text,
                textAlign: TextAlign.center,
                style: TextStyle(color: subtitle.active ? scheme.primary : scheme.onSurfaceVariant),
              ),
            ),
          const SizedBox(height: 16),
          if (profile.userID.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Из окна чата писать и так есть где — там вместо «Сообщения» «Поиск».
                  if (!widget.fromChat)
                    ChatInfoActionButton(
                      icon: HugeIcons.strokeRoundedMessage01,
                      label: t.screenChatInfo.message,
                      color: scheme.primary,
                      background: card,
                      onTap: () => _message(context, profile),
                    ),
                  // Заблокированному не звоним (сервер и так не пропустит).
                  if (!self && !profile.blocked) ...[
                    ChatInfoActionButton(
                      icon: HugeIcons.strokeRoundedCall02,
                      label: t.screenChatInfo.call,
                      color: scheme.primary,
                      background: card,
                      onTap: () => profileCall(profile.userID, video: false),
                    ),
                    ChatInfoActionButton(
                      icon: HugeIcons.strokeRoundedVideo01,
                      label: t.screenChatInfo.video,
                      color: scheme.primary,
                      background: card,
                      onTap: () => profileCall(profile.userID, video: true),
                    ),
                  ],
                  if (chat != null)
                    ChatInfoActionButton(
                      // Значок — текущее состояние: звук включён / выключен.
                      icon: chat.muted ? HugeIcons.strokeRoundedNotificationOff01 : HugeIcons.strokeRoundedNotification01,
                      // Заглушён на время — «до 18:30» вместо «Звук».
                      label: chat.muted && chat.mutedUntil != null ? chatMutedUntilLabel(t, chat.mutedUntil!) : t.screenChatInfo.sound,
                      color: scheme.primary,
                      background: card,
                      onTap: () => toggleChatMuteMaterial(context, chat),
                    ),
                  if (widget.fromChat)
                    ChatInfoActionButton(
                      icon: HugeIcons.strokeRoundedSearch01,
                      label: t.screenChatInfo.search,
                      color: scheme.primary,
                      background: card,
                      onTap: () => Navigator.of(context).pop(const ChatInfoResult.search()),
                    ),
                  if (!self)
                    ChatInfoActionButton(
                      icon: HugeIcons.strokeRoundedMoreHorizontal,
                      label: t.screenChatInfo.more,
                      color: scheme.primary,
                      background: card,
                      onTap: () => _more(context, profile, chat),
                    ),
                ],
              ),
            ),
          if (profile.phoneNumber.isNotEmpty || profile.aboutMe.isNotEmpty || username.isNotEmpty || birthDate != null)
            Card(
              margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
              color: card,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  if (profile.phoneNumber.isNotEmpty)
                    _field(
                      context,
                      icon: HugeIcons.strokeRoundedSmartPhone01,
                      value: profile.phoneNumber,
                      label: t.screenProfile.mobilePhone,
                    ),
                  if (profile.aboutMe.isNotEmpty)
                    _field(
                      context,
                      icon: HugeIcons.strokeRoundedInformationCircle,
                      value: profile.aboutMe,
                      label: t.screenChatInfo.about,
                      maxLines: 6,
                    ),
                  if (username.isNotEmpty)
                    _field(context, icon: HugeIcons.strokeRoundedAt, value: username, label: t.screenChatInfo.username),
                  if (birthDate != null)
                    _field(
                      context,
                      icon: HugeIcons.strokeRoundedBirthdayCake,
                      value: profileBirthDateText(t, birthDate, hideYear: profile.hideBirthYear),
                      label: t.screenProfile.birthDate,
                    ),
                ],
              ),
            ),
          if (profile.blocked)
            Card(
              margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
              color: card,
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                title: Text(t.screenProfile.unblock, style: TextStyle(color: scheme.primary)),
                subtitle: Text(t.screenProfile.blockedNote),
                onTap: () => _setBlocked(context, profile, false),
              ),
            ),
          // Вкладки — полосой над карточкой (как в профиле чата), содержимое — карточкой.
          if (chat != null && chatState != null && tabs.isNotEmpty) ...[
            if (tabs.length > 1)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                child: ChatFolderTabsMaterial(
                  tabs: [for (final item in tabs) ChatFolderTab(title: chatInfoTabLabel(t, item, chat))],
                  selectedIndex: tabs.indexOf(tab),
                  onTap: (index) => setState(() => _tab = tabs[index]),
                ),
              ),
            Card(
              margin: EdgeInsets.fromLTRB(12, tabs.length > 1 ? 0 : 16, 12, 0),
              color: card,
              clipBehavior: Clip.antiAlias,
              child: ChatInfoTabContent(
                tab: tab,
                chat: chat,
                messages: chatState.messages,
                members: chatState.members,
                style: ChatInfoStyle(
                  text: scheme.onSurface,
                  secondary: scheme.onSurfaceVariant,
                  accent: scheme.primary,
                  onAccent: scheme.onPrimary,
                  separator: scheme.outlineVariant,
                ),
                // Из окна чата — назад к сообщению, иначе — открыть чат.
                onOpenMessage: (id) =>
                    widget.fromChat ? Navigator.of(context).pop(ChatInfoResult.goTo(id)) : context.push('/chats/chat/${chat.id}'),
              ),
            ),
          ],
          SizedBox(height: 24 + MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
