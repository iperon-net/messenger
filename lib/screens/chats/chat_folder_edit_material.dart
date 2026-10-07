import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_folder_chats_material.dart';
import 'chat_folders_common.dart';
import 'chats_new_material.dart';

/// Новая папка ([folder] `null`) / изменить папку (Android). Без [cubit] —
/// открыто не с экрана «Папки» (long-press по табу): заводим свой
/// [ChatFoldersCubit].
Future<void> showChatFolderEditMaterial(BuildContext context, {ChatFoldersCubit? cubit, models.ChatFolder? folder}) {
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  final child = ChatFolderEditMaterial(folder: folder);
  return Navigator.of(context, rootNavigator: true).push<void>(
    FullSwipeBackRoute(
      builder: (_) => cubit != null
          ? BlocProvider.value(value: cubit, child: child)
          : BlocProvider(
              create: (_) => ChatFoldersCubit()..initialization(demo: demo),
              child: child,
            ),
    ),
  );
}

/// Название, «Включённые чаты» (типы + чаты) и «Исключённые чаты» (флаги +
/// чаты), у существующей — «Удалить папку». Несохранённые изменения при уходе
/// назад — с подтверждением.
class ChatFolderEditMaterial extends StatefulWidget {
  final models.ChatFolder? folder;

  const ChatFolderEditMaterial({super.key, this.folder});

  @override
  State<ChatFolderEditMaterial> createState() => _ChatFolderEditMaterial();
}

class _ChatFolderEditMaterial extends State<ChatFolderEditMaterial> {
  late final models.ChatFolder _initial = widget.folder ?? models.ChatFolder(id: ChatFoldersCubit.newFolderID());
  late models.ChatFolder _folder = _initial;
  late final TextEditingController _titleController = TextEditingController(text: _initial.title)
    ..addListener(() => setState(() => _folder = _folder.copyWith(title: _titleController.text)));

  bool get _dirty => _folder != _initial;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final error = chatFolderError(context.t, _folder);
    if (error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    await context.read<ChatFoldersCubit>().save(_folder);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final folder = widget.folder;
    if (folder == null) return;
    final t = context.t;
    final cubit = context.read<ChatFoldersCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.screenChats.deleteFolderTitle(title: folder.title)),
        content: Text(t.screenChats.deleteFolderMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(t.common.cancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.screenChats.delete),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false)) return;
    await cubit.delete(folder);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _confirmDiscard() async {
    final s = context.t.screenChatFolders;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.discardTitle),
        content: Text(s.discardMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(s.discard),
          ),
        ],
      ),
    );
    if ((discard ?? false) && mounted) Navigator.of(context).pop();
  }

  Future<void> _pick({required bool include}) async {
    final result = await showChatFolderChatsMaterial(
      context,
      folder: _folder,
      include: include,
      chats: context.read<ChatFoldersCubit>().state.pickable,
    );
    if (result != null && mounted) setState(() => _folder = result);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final s = t.screenChatFolders;
    final scheme = Theme.of(context).colorScheme;
    final state = context.watch<ChatFoldersCubit>().state;

    Widget card(List<Widget> children) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );

    Widget remove(VoidCallback onPressed) => IconButton(
      tooltip: t.screenChats.delete,
      onPressed: onPressed,
      icon: Icon(Icons.close, color: scheme.onSurfaceVariant),
    );

    Widget addRow(String title, IconData icon, VoidCallback onTap) => ListTile(
      leading: Icon(icon, color: scheme.primary),
      title: Text(title, style: TextStyle(color: scheme.primary)),
      onTap: onTap,
    );

    List<Widget> rows({required bool include}) {
      final ids = include ? _folder.includeChatIDs : _folder.excludeChatIDs;
      return [
        for (final rule in ChatFolderRule.of(include: include))
          if (rule.isSet(_folder))
            MaterialListTileIcon(
              title: Text(rule.label(t)),
              color: rule.color,
              icon: rule.icon,
              trailing: remove(() => setState(() => _folder = rule.set(_folder, false))),
              onTab: null,
            ),
        for (final id in ids)
          if (state.chat(id) case final chat?)
            ListTile(
              leading: ChatAvatar(chat: chat, accentColor: scheme.primary, accentForeground: scheme.onPrimary, size: 40),
              title: Text(ChatTileContent.title(t, chat)),
              trailing: remove(
                () => setState(
                  () => _folder = include
                      ? _folder.copyWith(includeChatIDs: _folder.includeChatIDs.where((c) => c != id).toList())
                      : _folder.copyWith(excludeChatIDs: _folder.excludeChatIDs.where((c) => c != id).toList()),
                ),
              ),
            ),
      ];
    }

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmDiscard();
      },
      child: Scaffold(
        backgroundColor: scheme.surfaceContainerLow,
        appBar: AppBar(
          backgroundColor: scheme.surfaceContainerLow,
          title: Text(widget.folder == null ? s.newFolder : s.editFolder),
          actions: [
            IconButton(
              tooltip: widget.folder == null ? s.create : t.common.save,
              onPressed: widget.folder == null || _dirty ? _save : null,
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            children: [
              card([
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _titleController,
                    maxLength: 20,
                    autofocus: widget.folder == null,
                    decoration: InputDecoration(
                      labelText: s.name,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    ),
                  ),
                ),
              ]),
              createHeaderMaterial(context, s.included),
              card([addRow(s.addChats, Icons.add_circle_outline, () => _pick(include: true)), ...rows(include: true)]),
              createNoteMaterial(context, s.includedFooter),
              createHeaderMaterial(context, s.excluded),
              card([addRow(s.excludeChats, Icons.remove_circle_outline, () => _pick(include: false)), ...rows(include: false)]),
              createNoteMaterial(context, s.excludedFooter),
              if (widget.folder != null) ...[
                const SizedBox(height: 16),
                card([
                  ListTile(
                    title: Text(s.deleteFolder, style: TextStyle(color: scheme.error)),
                    onTap: _delete,
                  ),
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
