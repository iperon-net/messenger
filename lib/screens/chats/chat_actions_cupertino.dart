import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

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
          () => cubit.setMuted(chat, !chat.muted),
        ),
        if (!chat.isSelf)
          action(
            chat.archived ? t.fromArchive : t.toArchive,
            chat.archived ? CupertinoIcons.tray_arrow_up : CupertinoIcons.archivebox,
            () => cubit.setArchived(chat, !chat.archived),
          ),
        action(t.delete, CupertinoIcons.delete, () => _confirmDelete(context, cubit), destructive: true),
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

  Future<void> _confirmDelete(BuildContext context, ChatsCubit cubit) async {
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
    if (confirmed ?? false) await cubit.delete(chat);
  }
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
