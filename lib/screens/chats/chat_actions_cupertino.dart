import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_mute.dart';

/// Строка чата с нативным контекстным меню iOS по долгому нажатию (строка
/// «приподнимается», фон размывается, под превью — действия). Свайп по списку
/// занят папками, поэтому действия только здесь — см.
/// docs/plans/chats-groups-channels.md, «Папки».
class ChatContextMenuCupertino extends StatelessWidget {
  final models.Chat chat;
  final VoidCallback? onTap;

  const ChatContextMenuCupertino({super.key, required this.chat, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatsCubit>();
    final t = context.t.screenChats;

    // Меню — маршрут корневого навигатора; закрываем его сами и только потом
    // выполняем действие (иначе превью «мигнёт» уже изменённой строкой).
    CupertinoContextMenuAction action(String label, IconData icon, VoidCallback run, {bool destructive = false}) {
      return CupertinoContextMenuAction(
        trailingIcon: icon,
        isDestructiveAction: destructive,
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          run();
        },
        child: Text(label),
      );
    }

    return CupertinoContextMenu.builder(
      enableHapticFeedback: true,
      actions: [
        if (!chat.archived)
          action(
            chat.pinned ? t.unpin : t.pin,
            chat.pinned ? CupertinoIcons.pin_slash : CupertinoIcons.pin,
            () => cubit.setPinned(chat, !chat.pinned),
          ),
        action(
          chat.hasUnread ? t.markRead : t.markUnread,
          chat.hasUnread ? CupertinoIcons.chat_bubble : CupertinoIcons.chat_bubble_fill,
          () => cubit.setRead(chat, chat.hasUnread),
        ),
        action(
          chat.muted ? t.unmute : t.mute,
          chat.muted ? CupertinoIcons.bell : CupertinoIcons.bell_slash,
          // Выключить — «Заглушить на…» (после закрытия меню).
          () async {
            if (chat.muted) return cubit.setMuted(chat, false);
            final choice = await pickChatMute(context);
            if (choice != null) await cubit.setMuted(chat, true, until: chatMuteUntil(choice));
          },
        ),
        if (!chat.isSelf)
          action(
            chat.archived ? t.fromArchive : t.toArchive,
            chat.archived ? CupertinoIcons.tray_arrow_up : CupertinoIcons.archivebox,
            () => cubit.setArchived(chat, !chat.archived),
          ),
        action(t.delete, CupertinoIcons.delete, () async {
          if (await confirmDeleteChatCupertino(context, chat)) await cubit.delete(chat);
        }, destructive: true),
      ],
      builder: (context, animation) {
        // До animationOpensAt — «нажатие» (строка как в списке), после —
        // открытое превью: непрозрачная карточка со скруглением.
        final opened = animation.value >= CupertinoContextMenu.animationOpensAt;
        final radius = BorderRadiusTween(
          begin: BorderRadius.zero,
          end: BorderRadius.circular(CupertinoContextMenu.kOpenBorderRadius),
        ).animate(CurvedAnimation(parent: animation, curve: Interval(CupertinoContextMenu.animationOpensAt, 1))).value;
        final tile = ChatTileCupertino(chat: chat, onTap: opened ? null : onTap);
        if (!opened) return tile;
        return ClipRRect(
          borderRadius: radius ?? BorderRadius.zero,
          child: ColoredBox(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            // Открытое превью меню укладывается в прямоугольник, высота которого
            // чуть меньше естественной высоты строки (→ overflow колонки). Строку
            // раскладываем по ширине превью со свободной высотой и пропорционально
            // ужимаем под выданный размер.
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (!constraints.hasBoundedWidth) return tile;
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: SizedBox(width: constraints.maxWidth, child: tile),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// «Удалить чат?» — `true`, если подтвердили.
Future<bool> confirmDeleteChatCupertino(BuildContext context, models.Chat chat) async {
  final t = context.t.screenChats;
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
  return confirmed ?? false;
}

/// Действия меню папки по удержанию таба (`CupertinoContextMenu` в
/// `ChatFolderTabsCupertino`): «Прочитать все», «Удалить папку» («Все чаты» не
/// удаляется). Редактирование папок — экран «Настройки → Папки» (следующие шаги
/// демо).
List<Widget> folderContextActionsCupertino(BuildContext context, models.ChatFolder folder, String title) {
  final cubit = context.read<ChatsCubit>();
  final t = context.t.screenChats;

  // Как у ChatContextMenuCupertino: сначала закрываем меню (маршрут корневого
  // навигатора), потом действие.
  CupertinoContextMenuAction action(String label, IconData icon, VoidCallback run, {bool destructive = false}) {
    return CupertinoContextMenuAction(
      trailingIcon: icon,
      isDestructiveAction: destructive,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        run();
      },
      child: Text(label),
    );
  }

  final unread = cubit.state.unreadOf(folder).count > 0;
  return [
    if (unread) action(t.readAll, CupertinoIcons.chat_bubble_2, () => cubit.readAll(folder)),
    if (!folder.isAll)
      action(t.deleteFolder, CupertinoIcons.delete, () => _confirmDeleteFolder(context, cubit, folder, title), destructive: true),
  ];
}

Future<void> _confirmDeleteFolder(BuildContext context, ChatsCubit cubit, models.ChatFolder folder, String title) async {
  final t = context.t.screenChats;
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
