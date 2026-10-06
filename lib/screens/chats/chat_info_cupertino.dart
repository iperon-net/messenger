import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';

import '../../chats/reactions.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';
import 'chat_create_form_cupertino.dart';
import 'chat_invite_links_cupertino.dart';
import 'chat_join_requests_cupertino.dart';
import 'chat_info_common.dart';

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
                        child: ChatAvatar(chat: chat, size: 96, accentColor: primary),
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
                                label: t.screenChatInfo.sound,
                                color: action,
                                onTap: () => context.read<ChatCubit>().setMuted(!chat.muted),
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
                        ]),
                      // Вкладки и их содержимое — одной карточкой, как секции выше.
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                              child: CupertinoSlidingSegmentedControl<ChatInfoTab>(
                                groupValue: tab,
                                onValueChanged: (value) => setState(() => _tab = value),
                                children: {
                                  for (final item in tabs)
                                    item: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                                      child: Text(
                                        chatInfoTabLabel(t, item),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                },
                              ),
                            ),
                            Padding(
                              // Сетка медиа — до краёв карточки, списки — с отступом сверху.
                              padding: EdgeInsets.only(top: tab == ChatInfoTab.media ? 4 : 0),
                              child: ChatInfoTabContent(
                                tab: tab,
                                chat: chat,
                                messages: state.messages,
                                members: state.members,
                                style: ChatInfoStyle(
                                  text: label,
                                  secondary: secondary,
                                  accent: primary,
                                  separator: CupertinoColors.separator.resolveFrom(context),
                                ),
                                onOpenMessage: (id) => Navigator.of(context).pop(ChatInfoResult.goTo(id)),
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
                  footer: Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Text(
                      t.reactionsFooter,
                      style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                    ),
                  ),
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
                    header: Text(t.reactionsPick.toUpperCase()),
                    children: [
                      Padding(
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
