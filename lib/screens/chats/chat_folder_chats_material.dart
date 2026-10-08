import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_folders_common.dart';
import 'chats_new_material.dart';

/// Выбор чатов в папку (Android): «Добавить чаты» ([include]) или «Исключить
/// чаты». Сверху — типы чатов, ниже — чаты с поиском. Галочка отдаёт папку с
/// новыми правилами (см. [withPickedChats]); закрыли — `null`.
Future<models.ChatFolder?> showChatFolderChatsMaterial(
  BuildContext context, {
  required models.ChatFolder folder,
  required bool include,
  required List<models.Chat> chats,
}) {
  return Navigator.of(context).push<models.ChatFolder>(
    FullSwipeBackRoute(
      builder: (_) => ChatFolderChatsMaterial(folder: folder, include: include, chats: chats),
    ),
  );
}

class ChatFolderChatsMaterial extends StatefulWidget {
  final models.ChatFolder folder;
  final bool include;

  /// Чаты, из которых выбираем (`ChatFoldersState.pickable`).
  final List<models.Chat> chats;

  const ChatFolderChatsMaterial({super.key, required this.folder, required this.include, required this.chats});

  @override
  State<ChatFolderChatsMaterial> createState() => _ChatFolderChatsMaterial();
}

class _ChatFolderChatsMaterial extends State<ChatFolderChatsMaterial> {
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
    final scheme = Theme.of(context).colorScheme;
    final query = _query.trim().toLowerCase();
    final chats = query.isEmpty
        ? widget.chats
        : widget.chats.where((chat) => ChatTileContent.title(t, chat).toLowerCase().contains(query)).toList();
    final selected = _rules.length + _chatIDs.length;

    Widget card(List<Widget> children) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: scheme.surfaceContainerLow,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.include ? s.addChats : s.excludeChats),
            if (selected > 0)
              Text(
                s.selected(n: selected),
                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(tooltip: t.common.done, onPressed: _done, child: const Icon(Icons.check)),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(bottom: 88),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: SearchFieldMaterial(
                controller: _searchController,
                hintText: s.search,
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            if (query.isEmpty) ...[
              createHeaderMaterial(context, s.chatTypes),
              card([
                for (final rule in ChatFolderRule.of(include: widget.include))
                  MaterialListTileIcon(
                    title: Text(rule.label(t)),
                    color: rule.color,
                    icon: rule.icon,
                    trailing: Checkbox(value: _rules.contains(rule), onChanged: (_) => _toggleRule(rule)),
                    onTab: () async => _toggleRule(rule),
                  ),
              ]),
            ],
            if (chats.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  s.nothingFound,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              )
            else ...[
              createHeaderMaterial(context, s.chats),
              card([
                for (final chat in chats)
                  ListTile(
                    leading: ChatAvatar(chat: chat, accentColor: scheme.primary, accentForeground: scheme.onPrimary, size: 40),
                    title: Text(ChatTileContent.title(t, chat)),
                    trailing: Checkbox(value: _chatIDs.contains(chat.id), onChanged: (_) => _toggleChat(chat.id)),
                    onTap: () => _toggleChat(chat.id),
                  ),
              ]),
            ],
          ],
        ),
      ),
    );
  }
}
