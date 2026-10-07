import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_folder_chats_cupertino.dart';
import 'chat_folders_common.dart';
import 'chats_new_cupertino.dart';

/// Новая папка ([folder] `null`) / изменить папку (iOS). Без [cubit] — открыто
/// не с экрана «Папки» (long-press по табу): заводим свой [ChatFoldersCubit].
Future<void> showChatFolderEditCupertino(BuildContext context, {ChatFoldersCubit? cubit, models.ChatFolder? folder}) {
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  final child = ChatFolderEditCupertino(folder: folder);
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
class ChatFolderEditCupertino extends StatefulWidget {
  final models.ChatFolder? folder;

  const ChatFolderEditCupertino({super.key, this.folder});

  @override
  State<ChatFolderEditCupertino> createState() => _ChatFolderEditCupertino();
}

class _ChatFolderEditCupertino extends State<ChatFolderEditCupertino> {
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
      await showCupertinoDialog<void>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          content: Text(error),
          actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok))],
        ),
      );
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
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.screenChats.deleteFolderTitle(title: folder.title)),
        content: Text(t.screenChats.deleteFolderMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(t.common.cancel)),
          CupertinoDialogAction(
            isDestructiveAction: true,
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
    final discard = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(s.discardTitle),
        content: Text(s.discardMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(s.discard)),
        ],
      ),
    );
    if ((discard ?? false) && mounted) Navigator.of(context).pop();
  }

  Future<void> _pick({required bool include}) async {
    final result = await showChatFolderChatsCupertino(
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
    final primary = CupertinoTheme.of(context).primaryColor;
    final action = ThemesCupertino.actionColor(context);
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);
    final state = context.watch<ChatFoldersCubit>().state;

    Widget section({String? header, String? footer, required List<Widget> children}) => CupertinoListSection.insetGrouped(
      header: header == null ? null : createHeaderCupertino(header),
      footer: footer == null ? null : createNoteCupertino(footer),
      backgroundColor: background,
      decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
      children: children,
    );

    Widget remove(VoidCallback onPressed) => CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(32, 32),
      onPressed: onPressed,
      child: Icon(CupertinoIcons.minus_circle_fill, color: CupertinoColors.destructiveRed.resolveFrom(context), size: 24),
    );

    // Все строки секций — с ведущей ячейкой 40 (как у аватаров чатов), чтобы
    // значки действий, правил и аватары стояли в одну колонку.
    Widget tile({required Widget leading, required Widget title, Widget? trailing, VoidCallback? onTap}) => CupertinoListTile(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leadingSize: 40,
      leading: leading,
      title: title,
      trailing: trailing,
      onTap: onTap,
    );

    Widget addRow(String title, IconData icon, VoidCallback onTap) => tile(
      leading: Icon(icon, color: action, size: 28),
      title: Text(
        title,
        style: TextStyle(color: action, fontSize: AppFontSizes.body),
      ),
      onTap: onTap,
    );

    List<Widget> rows({required bool include}) {
      final ids = include ? _folder.includeChatIDs : _folder.excludeChatIDs;
      return [
        for (final rule in ChatFolderRule.of(include: include))
          if (rule.isSet(_folder))
            tile(
              leading: ChatFolderRuleIcon(rule: rule),
              title: Text(rule.label(t)),
              trailing: remove(() => setState(() => _folder = rule.set(_folder, false))),
            ),
        for (final id in ids)
          if (state.chat(id) case final chat?)
            tile(
              leading: ChatAvatar(chat: chat, accentColor: primary, accentForeground: ThemesCupertino.onAccent(context), size: 40),
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
      child: CupertinoPageScaffold(
        backgroundColor: ThemesCupertino.groupedBackground,
        navigationBar: AppCupertinoNavigationBar(
          child: CupertinoNavigationBar(
            previousPageTitle: '',
            automaticBackgroundVisibility: false,
            backgroundColor: ThemesCupertino.groupedBackground,
            middle: Text(widget.folder == null ? s.newFolder : s.editFolder),
            // Всегда активна и белая в тёмной теме (как «Готово» в навбарах);
            // без изменений просто закрывает экран.
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _save,
              child: Text(
                widget.folder == null ? s.create : t.common.save,
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
              section(
                header: s.name,
                children: [
                  CupertinoTextField.borderless(
                    controller: _titleController,
                    placeholder: s.name,
                    maxLength: 20,
                    autofocus: widget.folder == null,
                    style: const TextStyle(fontSize: AppFontSizes.body),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ],
              ),
              section(
                header: s.included,
                footer: s.includedFooter,
                children: [addRow(s.addChats, CupertinoIcons.add_circled, () => _pick(include: true)), ...rows(include: true)],
              ),
              section(
                header: s.excluded,
                footer: s.excludedFooter,
                children: [addRow(s.excludeChats, CupertinoIcons.minus_circle, () => _pick(include: false)), ...rows(include: false)],
              ),
              if (widget.folder != null)
                section(
                  children: [
                    CupertinoListTile(
                      title: Text(s.deleteFolder, style: TextStyle(color: CupertinoColors.destructiveRed.resolveFrom(context))),
                      onTap: _delete,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
