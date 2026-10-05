import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Действия над чатом по long-press (свайп по списку занят папками — см.
/// docs/plans/chats-groups-channels.md, «Папки»).
Future<void> showChatActionsMaterial(BuildContext context, models.Chat chat) async {
  final cubit = context.read<ChatsCubit>();
  final t = context.t.screenChats;

  Widget action(BuildContext sheetContext, IconData icon, String label, Future<void> Function() onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.of(sheetContext).pop();
        onTap();
      },
    );
  }

  final delete = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!chat.archived)
            action(
              sheetContext,
              chat.pinned ? Icons.push_pin_outlined : Icons.push_pin,
              chat.pinned ? t.unpin : t.pin,
              () => cubit.setPinned(chat, !chat.pinned),
            ),
          action(
            sheetContext,
            chat.hasUnread ? Icons.mark_chat_read_outlined : Icons.mark_chat_unread_outlined,
            chat.hasUnread ? t.markRead : t.markUnread,
            () => cubit.setRead(chat, chat.hasUnread),
          ),
          action(
            sheetContext,
            chat.muted ? Icons.notifications_outlined : Icons.notifications_off_outlined,
            chat.muted ? t.unmute : t.mute,
            () => cubit.setMuted(chat, !chat.muted),
          ),
          if (!chat.isSelf)
            action(
              sheetContext,
              chat.archived ? Icons.unarchive_outlined : Icons.archive_outlined,
              chat.archived ? t.fromArchive : t.toArchive,
              () => cubit.setArchived(chat, !chat.archived),
            ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Theme.of(sheetContext).colorScheme.error),
            title: Text(t.delete, style: TextStyle(color: Theme.of(sheetContext).colorScheme.error)),
            onTap: () => Navigator.of(sheetContext).pop(true),
          ),
        ],
      ),
    ),
  );

  if (delete != true || !context.mounted) return;
  if (await confirmDeleteChatMaterial(context, chat)) await cubit.delete(chat);
}

/// «Удалить чат?» — `true`, если подтвердили.
Future<bool> confirmDeleteChatMaterial(BuildContext context, models.Chat chat) async {
  final t = context.t.screenChats;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(t.deleteChatTitle),
      content: Text(t.deleteChatMessage(title: ChatTileContent.title(context.t, chat))),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.delete)),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Действия над папкой по long-press на табе: «Прочитать все», «Удалить папку»
/// («Все чаты» не удаляется).
Future<void> showFolderActionsMaterial(BuildContext context, models.ChatFolder folder, String title) async {
  final cubit = context.read<ChatsCubit>();
  final t = context.t.screenChats;

  final delete = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.mark_chat_read_outlined),
            title: Text(t.readAll),
            onTap: () {
              Navigator.of(sheetContext).pop();
              cubit.readAll(folder);
            },
          ),
          if (!folder.isAll)
            ListTile(
              leading: Icon(Icons.delete_outline, color: Theme.of(sheetContext).colorScheme.error),
              title: Text(t.deleteFolder, style: TextStyle(color: Theme.of(sheetContext).colorScheme.error)),
              onTap: () => Navigator.of(sheetContext).pop(true),
            ),
        ],
      ),
    ),
  );

  if (delete != true || !context.mounted) return;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(t.deleteFolderTitle(title: title)),
      content: Text(t.deleteFolderMessage),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.delete)),
      ],
    ),
  );
  if (confirmed ?? false) await cubit.deleteFolder(folder);
}
