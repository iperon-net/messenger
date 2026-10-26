import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_common.dart';
import 'chat_folder_edit_material.dart';
import 'chat_folders_material.dart';
import 'chat_mute.dart';

/// Действия над чатом по long-press (свайп по списку занят папками — см.
/// docs/plans/chats-groups-channels.md, «Папки»).
Future<void> showChatActionsMaterial(BuildContext context, models.Chat chat) async {
  final cubit = context.read<ChatsCubit>();
  final t = context.t.screenChats;
  if (chat.isSecret) return _secretChatActionsMaterial(context, chat, cubit);
  if (chat.isReplies) return _repliesActionsMaterial(context, cubit);

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

  final delete = await showActionsMaterial<bool>(
    context: context,
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
          if (chat.unreadReactions > 0) action(sheetContext, Icons.favorite_border, t.readReactions, () => cubit.readReactions(chat)),
          action(
            sheetContext,
            chat.muted ? Icons.notifications_outlined : Icons.notifications_off_outlined,
            chat.muted ? t.unmute : t.mute,
            // Выключить — «Заглушить на…» (после закрытия листа).
            () async {
              if (chat.muted) return cubit.setMuted(chat, false);
              final choice = await pickChatMute(context);
              if (choice != null) await cubit.setMuted(chat, true, until: chatMuteUntil(choice));
            },
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
            title: Text(t.deleteChat, style: TextStyle(color: Theme.of(sheetContext).colorScheme.error)),
            onTap: () => Navigator.of(sheetContext).pop(true),
          ),
        ],
      ),
    ),
  );

  if (delete != true || !context.mounted) return;
  final forEveryone = await askDeleteChatMaterial(context, chat);
  if (forEveryone != null) await cubit.delete(chat, forEveryone: forEveryone);
}

/// «Удалить чат?» Личный (см. [chatDeleteScoped]) — шторка «У меня» / «У
/// меня и собеседника» ([pickScopeMaterial]; у собеседника история тоже
/// очищается, чат пропадает из его списка); остальные — подтверждение алертом.
/// Результат — «и у собеседника?», `null` — отмена.
Future<bool?> askDeleteChatMaterial(BuildContext context, models.Chat chat) async {
  final t = context.t.screenChats;
  if (chatDeleteScoped(chat)) return pickScopeMaterial(context, title: t.deleteChatTitle);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(t.deleteChatTitle),
      content: Text(t.deleteChatMessage(title: ChatTileContent.title(context.t, chat))),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.cancel)),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(t.delete),
        ),
      ],
    ),
  );
  return (confirmed ?? false) ? false : null;
}

/// Выбор «У меня» / «У меня и собеседника» отдельной шторкой поверх
/// закрытой шторки действий (как отдельное меню на iOS) — для личного чата
/// ([chatDeleteScoped]): удаление чата и сообщений, закрепление. Результат —
/// «и у собеседника?», `null` — отмена.
Future<bool?> pickScopeMaterial(BuildContext context, {required String title, bool destructive = true}) {
  final t = context.t.screenChats;
  return showActionsMaterial<bool>(
    context: context,
    builder: (sheetContext) {
      final color = destructive ? Theme.of(sheetContext).colorScheme.error : null;
      Widget option(IconData icon, String label, bool forEveryone) => ListTile(
        leading: Icon(icon, color: color),
        title: Text(label, style: TextStyle(color: color)),
        onTap: () => Navigator.of(sheetContext).pop(forEveryone),
      );
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(title, style: Theme.of(sheetContext).textTheme.titleMedium),
            ),
            option(Icons.person_outline, t.scopeMe, false),
            option(Icons.people_outline, t.scopeBoth, true),
          ],
        ),
      );
    },
  );
}

/// Действия над папкой по long-press на табе: у «Все чаты» — «Прочитать все»,
/// «Изменить папки»; у остальных — «Изменить папку», «Прочитать все»,
/// «Изменить порядок» (экран «Папки»), «Удалить папку».
Future<void> showFolderActionsMaterial(BuildContext context, models.ChatFolder folder, String title) async {
  final cubit = context.read<ChatsCubit>();
  final t = context.t.screenChats;

  final delete = await showActionsMaterial<bool>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!folder.isAll)
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(t.editFolder),
              onTap: () {
                Navigator.of(sheetContext).pop();
                showChatFolderEditMaterial(context, folder: folder);
              },
            ),
          ListTile(
            leading: const Icon(Icons.mark_chat_read_outlined),
            title: Text(t.readAll),
            onTap: () {
              Navigator.of(sheetContext).pop();
              cubit.readAll(folder);
            },
          ),
          ListTile(
            leading: Icon(folder.isAll ? Icons.folder_outlined : Icons.swap_vert),
            title: Text(folder.isAll ? t.editFolders : t.reorderFolders),
            onTap: () {
              Navigator.of(sheetContext).pop();
              showChatFoldersMaterial(context);
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

/// Секретный чат в списке: только удаление (закрепы, папки, архив — у
/// обычных чатов на сервере, секретный живёт только на устройстве).
Future<void> _secretChatActionsMaterial(BuildContext context, models.Chat chat, ChatsCubit cubit) async {
  final t = context.t.secretChat;
  final delete = await showActionsMaterial<bool>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: ListTile(
        leading: Icon(Icons.delete_outline, color: Theme.of(sheetContext).colorScheme.error),
        title: Text(t.delete, style: TextStyle(color: Theme.of(sheetContext).colorScheme.error)),
        onTap: () => Navigator.of(sheetContext).pop(true),
      ),
    ),
  );
  if (delete != true || !context.mounted) return;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(t.delete),
      content: Text(t.deleteConfirm),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.delete)),
      ],
    ),
  );
  if (confirmed == true) await cubit.deleteSecret(chat);
}

/// «Ответы» (4.6): только «Прочитать все».
Future<void> _repliesActionsMaterial(BuildContext context, ChatsCubit cubit) async {
  final read = await showActionsMaterial<bool>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.mark_chat_read_outlined),
            title: Text(context.t.screenChats.readAll),
            onTap: () => Navigator.of(sheetContext).pop(true),
          ),
        ],
      ),
    ),
  );
  if (read == true) await cubit.readReplies();
}
