import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';

import '../../chats/reactions.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';
import 'chat_info_common.dart';

/// Профиль чата (Android) — тап по шапке окна чата. Результат — что сделать в
/// чате: поиск или переход к сообщению.
Future<ChatInfoResult?> showChatInfoMaterial(BuildContext context, ChatCubit cubit) {
  return Navigator.of(context).push<ChatInfoResult>(
    MaterialPageRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const ChatInfoMaterial()),
    ),
  );
}

/// Аватар, название и статус, кнопки «Звук» / «Поиск», «О себе» / описание
/// и @username, для админа — «Реакции», вкладки «Участники / Медиа / Файлы /
/// Ссылки / Голосовые», внизу — «Удалить чат» / «Покинуть группу».
class ChatInfoMaterial extends StatefulWidget {
  const ChatInfoMaterial({super.key});

  @override
  State<ChatInfoMaterial> createState() => _ChatInfoMaterialState();
}

class _ChatInfoMaterialState extends State<ChatInfoMaterial> {
  ChatInfoTab? _tab;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadMembers();
  }

  Future<void> _leave(BuildContext context, models.Chat chat) async {
    final t = context.t.screenChatInfo;
    final private = chat.type == models.ChatType.private;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(private ? t.deleteChatTitle(name: chat.title) : t.leaveGroupTitle(name: chat.title)),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
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

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t.screenChat.copied)));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = dark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final chat = state.chat;
        final tabs = chat == null ? const <ChatInfoTab>[] : chatInfoTabs(chat);
        final tab = tabs.contains(_tab) ? _tab! : (tabs.firstOrNull ?? ChatInfoTab.media);
        final subtitle = chat == null ? null : chatSubtitle(t, chat);
        return Scaffold(
          backgroundColor: dark ? const Color(0xFF000000) : scheme.surfaceContainerLow,
          appBar: AppBar(backgroundColor: dark ? const Color(0xFF000000) : scheme.surfaceContainerLow),
          body: chat == null
              ? const SizedBox.shrink()
              : ListView(
                  padding: EdgeInsets.only(bottom: 24 + MediaQuery.paddingOf(context).bottom),
                  children: [
                    Center(
                      child: ChatAvatar(chat: chat, size: 96, accentColor: scheme.primary),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        ChatTileContent.title(t, chat),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          if (!chat.isSelf)
                            _ActionButton(
                              // Значок — текущее состояние: звук включён / выключен.
                              icon: chat.muted ? HugeIcons.strokeRoundedNotificationOff01 : HugeIcons.strokeRoundedNotification01,
                              label: t.screenChatInfo.sound,
                              color: scheme.primary,
                              background: card,
                              onTap: () => context.read<ChatCubit>().setMuted(!chat.muted),
                            ),
                          _ActionButton(
                            icon: HugeIcons.strokeRoundedSearch01,
                            label: t.screenChatInfo.search,
                            color: scheme.primary,
                            background: card,
                            onTap: () => Navigator.of(context).pop(const ChatInfoResult.search()),
                          ),
                          if (!chat.isSelf)
                            _ActionButton(
                              icon: HugeIcons.strokeRoundedSquareArrowRightExit,
                              label: t.screenChatInfo.leaveShort,
                              color: scheme.error,
                              background: card,
                              onTap: () => _leave(context, chat),
                            ),
                        ],
                      ),
                    ),
                    if (chat.about.isNotEmpty || chat.username.isNotEmpty)
                      Card(
                        margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                        color: card,
                        child: Column(
                          children: [
                            if (chat.about.isNotEmpty)
                              ListTile(
                                leading: HugeIcon(icon: HugeIcons.strokeRoundedInformationCircle, color: scheme.onSurfaceVariant),
                                title: Text(chat.about),
                                subtitle: Text(
                                  chat.type == models.ChatType.private ? t.screenChatInfo.about : t.screenChatInfo.description,
                                ),
                                onTap: () => _copy(context, chat.about),
                              ),
                            if (chat.username.isNotEmpty)
                              chat.type == models.ChatType.private
                                  ? ListTile(
                                      leading: HugeIcon(icon: HugeIcons.strokeRoundedAt, color: scheme.onSurfaceVariant),
                                      title: Text('@${chat.username}'),
                                      subtitle: Text(t.screenChatInfo.username),
                                      onTap: () => _copy(context, '@${chat.username}'),
                                    )
                                  : ListTile(
                                      leading: HugeIcon(icon: HugeIcons.strokeRoundedLink01, color: scheme.onSurfaceVariant),
                                      title: Text('iperon.net/${chat.username}'),
                                      subtitle: Text(t.screenChatInfo.link),
                                      onTap: () => _copy(context, 'https://iperon.net/${chat.username}'),
                                    ),
                          ],
                        ),
                      ),
                    if (chat.canManage && chat.type != models.ChatType.private)
                      Card(
                        margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                        color: card,
                        child: ListTile(
                          leading: HugeIcon(icon: HugeIcons.strokeRoundedSmile, color: scheme.onSurfaceVariant),
                          title: Text(t.screenChatInfo.reactions),
                          trailing: Text(reactionsSummary(t, chat), style: TextStyle(color: scheme.onSurfaceVariant)),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  BlocProvider.value(value: context.read<ChatCubit>(), child: const ChatReactionsSettingsMaterial()),
                            ),
                          ),
                        ),
                      ),
                    Card(
                      margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                      color: card,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DefaultTabController(
                            key: ValueKey(tabs.length),
                            length: tabs.length,
                            initialIndex: tabs.indexOf(tab),
                            child: TabBar(
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              onTap: (index) => setState(() => _tab = tabs[index]),
                              tabs: [for (final item in tabs) Tab(text: chatInfoTabLabel(t, item))],
                            ),
                          ),
                          ChatInfoTabContent(
                            tab: tab,
                            chat: chat,
                            messages: state.messages,
                            members: state.members,
                            style: ChatInfoStyle(
                              text: scheme.onSurface,
                              secondary: scheme.onSurfaceVariant,
                              accent: scheme.primary,
                              separator: scheme.outlineVariant,
                            ),
                            onOpenMessage: (id) => Navigator.of(context).pop(ChatInfoResult.goTo(id)),
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
}

/// «Удалить чат» / «Покинуть группу / канал / сообщество».
String _leaveLabel(Translations t, models.Chat chat) => switch (chat.type) {
  models.ChatType.private => t.screenChatInfo.deleteChat,
  models.ChatType.group => t.screenChatInfo.leaveGroup,
  models.ChatType.channel => t.screenChatInfo.leaveChannel,
  models.ChatType.community => t.screenChatInfo.leaveCommunity,
};

/// Кнопка под шапкой профиля: значок и подпись на карточке; все кнопки ряда —
/// одной ширины.
class _ActionButton extends StatelessWidget {
  /// HugeIcons.* (сырые данные пути, не IconData).
  final List<List<dynamic>> icon;
  final String label;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.color, required this.background, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 9),
              child: Column(
                children: [
                  HugeIcon(icon: icon, size: 24, strokeWidth: 1.8, color: color),
                  const SizedBox(height: 4),
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
      ),
    );
  }
}

/// Профиль чата → «Реакции» (Android, админ): все / некоторые (сетка эмодзи)
/// / никаких. Сохраняется сразу.
class ChatReactionsSettingsMaterial extends StatelessWidget {
  const ChatReactionsSettingsMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChatInfo;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = dark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final chat = state.chat;
        final cubit = context.read<ChatCubit>();
        final mode = chat?.reactionsMode ?? models.ChatReactionsMode.all;
        final selected = chat?.reactions ?? const <String>[];
        void setMode(models.ChatReactionsMode? value) {
          if (value == null) return;
          // «Некоторые» впервые — начинаем с набора личных чатов.
          cubit.setChatReactions(value, value == models.ChatReactionsMode.some && selected.isEmpty ? privateChatReactions : selected);
        }

        return Scaffold(
          backgroundColor: dark ? const Color(0xFF000000) : scheme.surfaceContainerLow,
          appBar: AppBar(title: Text(t.reactions)),
          body: ListView(
            padding: EdgeInsets.only(bottom: 16 + MediaQuery.paddingOf(context).bottom),
            children: [
              Card(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                color: card,
                child: RadioGroup<models.ChatReactionsMode>(
                  groupValue: mode,
                  onChanged: setMode,
                  child: Column(
                    children: [
                      RadioListTile(value: models.ChatReactionsMode.all, title: Text(t.reactionsAll)),
                      RadioListTile(value: models.ChatReactionsMode.some, title: Text(t.reactionsSome)),
                      RadioListTile(value: models.ChatReactionsMode.none, title: Text(t.reactionsNone)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Text(t.reactionsFooter, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
              ),
              if (mode == models.ChatReactionsMode.some) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 6),
                  child: Text(
                    t.reactionsPick,
                    style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: card,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ReactionsGrid(
                      selected: selected,
                      highlight: scheme.primary,
                      onToggle: (emoji) => cubit.setChatReactions(
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
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
