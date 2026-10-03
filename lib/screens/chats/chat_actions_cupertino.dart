import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Действия над чатом по long-press (свайп по списку занят папками — см.
/// docs/plans/chats-groups-channels.md, «Папки»).
Future<void> showChatActionsCupertino(BuildContext context, models.Chat chat) async {
  final cubit = context.read<ChatsCubit>();
  final t = context.t.screenChats;

  CupertinoActionSheetAction action(BuildContext sheetContext, String label, Future<void> Function() onPressed) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.of(sheetContext).pop();
        onPressed();
      },
      child: Text(label),
    );
  }

  final delete = await showCupertinoModalPopup<bool>(
    context: context,
    builder: (sheetContext) => CupertinoActionSheet(
      title: Text(ChatTileContent.title(context.t, chat)),
      actions: [
        if (!chat.archived) action(sheetContext, chat.pinned ? t.unpin : t.pin, () => cubit.setPinned(chat, !chat.pinned)),
        action(sheetContext, chat.hasUnread ? t.markRead : t.markUnread, () => cubit.setRead(chat, chat.hasUnread)),
        action(sheetContext, chat.muted ? t.unmute : t.mute, () => cubit.setMuted(chat, !chat.muted)),
        if (!chat.isSelf) action(sheetContext, chat.archived ? t.fromArchive : t.toArchive, () => cubit.setArchived(chat, !chat.archived)),
        CupertinoActionSheetAction(isDestructiveAction: true, onPressed: () => Navigator.of(sheetContext).pop(true), child: Text(t.delete)),
      ],
      cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(context.t.common.cancel)),
    ),
  );

  if (delete != true || !context.mounted) return;
  final confirmed = await showCupertinoDialog<bool>(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(t.deleteChatTitle),
      content: Text(t.deleteChatMessage(title: ChatTileContent.title(context.t, chat))),
      actions: [
        CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
        CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.delete)),
      ],
    ),
  );
  if (confirmed ?? false) await cubit.delete(chat);
}

/// Действия над папкой по long-press на табе: «Прочитать все», «Удалить папку»
/// («Все чаты» не удаляется). Редактирование папок — экран «Настройки → Папки»
/// (следующие шаги демо).
Future<void> showFolderActionsCupertino(BuildContext context, models.ChatFolder folder, String title) async {
  final cubit = context.read<ChatsCubit>();
  final t = context.t.screenChats;

  final delete = await showCupertinoModalPopup<bool>(
    context: context,
    builder: (sheetContext) => CupertinoActionSheet(
      title: Text(title),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(sheetContext).pop();
            cubit.readAll(folder);
          },
          child: Text(t.readAll),
        ),
        if (!folder.isAll)
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(sheetContext).pop(true),
            child: Text(t.deleteFolder),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(context.t.common.cancel)),
    ),
  );

  if (delete != true || !context.mounted) return;
  final confirmed = await showCupertinoDialog<bool>(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(t.deleteFolderTitle(title: title)),
      content: Text(t.deleteFolderMessage),
      actions: [
        CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
        CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.delete)),
      ],
    ),
  );
  if (confirmed ?? false) await cubit.deleteFolder(folder);
}
