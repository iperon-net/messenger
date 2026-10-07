import 'package:cupertino_ui/cupertino_ui.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_folders_common.dart';
import 'chats_new_cupertino.dart';

/// Выбор чатов в папку (iOS): «Добавить чаты» ([include]) или «Исключить
/// чаты». Сверху — типы чатов, ниже — чаты с поиском. «Готово» отдаёт папку с
/// новыми правилами (см. [withPickedChats]); закрыли — `null`.
Future<models.ChatFolder?> showChatFolderChatsCupertino(
  BuildContext context, {
  required models.ChatFolder folder,
  required bool include,
  required List<models.Chat> chats,
}) {
  return Navigator.of(context).push<models.ChatFolder>(
    FullSwipeBackRoute(
      builder: (_) => ChatFolderChatsCupertino(folder: folder, include: include, chats: chats),
    ),
  );
}

class ChatFolderChatsCupertino extends StatefulWidget {
  final models.ChatFolder folder;
  final bool include;

  /// Чаты, из которых выбираем (`ChatFoldersState.pickable`).
  final List<models.Chat> chats;

  const ChatFolderChatsCupertino({super.key, required this.folder, required this.include, required this.chats});

  @override
  State<ChatFolderChatsCupertino> createState() => _ChatFolderChatsCupertino();
}

class _ChatFolderChatsCupertino extends State<ChatFolderChatsCupertino> {
  final _searchController = TextEditingController();
  String _query = '';

  late final Set<ChatFolderRule> _rules = {
    for (final rule in ChatFolderRule.of(include: widget.include))
      if (rule.isSet(widget.folder)) rule,
  };

  late final List<String> _chatIDs = [...(widget.include ? widget.folder.includeChatIDs : widget.folder.excludeChatIDs)];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleChat(String id) => setState(() => _chatIDs.contains(id) ? _chatIDs.remove(id) : _chatIDs.add(id));

  void _toggleRule(ChatFolderRule rule) => setState(() => _rules.contains(rule) ? _rules.remove(rule) : _rules.add(rule));

  void _done() => Navigator.of(context).pop(withPickedChats(widget.folder, include: widget.include, rules: _rules, chatIDs: _chatIDs));

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final s = t.screenChatFolders;
    final primary = CupertinoTheme.of(context).primaryColor;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);
    final query = _query.trim().toLowerCase();
    final chats = query.isEmpty
        ? widget.chats
        : widget.chats.where((chat) => ChatTileContent.title(t, chat).toLowerCase().contains(query)).toList();
    final selected = _rules.length + _chatIDs.length;

    Widget check(bool value) => Icon(
      value ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
      color: value ? primary : CupertinoColors.systemGrey3.resolveFrom(context),
      size: 26,
    );

    Widget section({String? header, required List<Widget> children}) => CupertinoListSection.insetGrouped(
      header: header == null ? null : createHeaderCupertino(header),
      backgroundColor: background,
      decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
      children: children,
    );

    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.include ? s.addChats : s.excludeChats),
              if (selected > 0)
                Text(
                  s.selected(n: selected),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: secondary),
                ),
            ],
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _done,
            child: Text(
              t.common.done,
              style: TextStyle(fontWeight: FontWeight.w600, color: ThemesCupertino.navActionColor(context)),
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SearchFieldCupertino(
                controller: _searchController,
                placeholder: s.search,
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            if (query.isEmpty)
              section(
                header: s.chatTypes,
                children: [
                  for (final rule in ChatFolderRule.of(include: widget.include))
                    CupertinoListTile(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leadingSize: 40,
                      leading: ChatFolderRuleIcon(rule: rule),
                      title: Text(rule.label(t)),
                      trailing: check(_rules.contains(rule)),
                      onTap: () => _toggleRule(rule),
                    ),
                ],
              ),
            if (chats.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  s.nothingFound,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: secondary),
                ),
              )
            else
              section(
                header: s.chats,
                children: [
                  for (final chat in chats)
                    CupertinoListTile(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leadingSize: 40,
                      leading: ChatAvatar(chat: chat, accentColor: primary, size: 40),
                      title: Text(ChatTileContent.title(t, chat)),
                      trailing: check(_chatIDs.contains(chat.id)),
                      onTap: () => _toggleChat(chat.id),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
