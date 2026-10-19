import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_common.dart';
import 'chat_folder_edit_cupertino.dart';
import 'chat_folders_cupertino.dart';
import 'chat_mute.dart';

/// Строка чата с нативным контекстным меню iOS по долгому нажатию (строка
/// «приподнимается», фон размывается, под превью — действия). Свайп по списку
/// занят папками, поэтому действия только здесь — см.
/// docs/plans/chats-groups-channels.md, «Папки».
class ChatContextMenuCupertino extends StatelessWidget {
  final models.Chat chat;
  final VoidCallback? onTap;

  /// Подтверждение удаления от [ChatDeleteMenuAnchorCupertino] строки.
  final ChatDeleteConfirm confirmDelete;

  const ChatContextMenuCupertino({super.key, required this.chat, required this.confirmDelete, this.onTap});

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
      actions: chat.isSecret
          // Секретный живёт только на устройстве — закрепы, папки и архив у
          // него нет, только удаление.
          ? [
              action(context.t.secretChat.delete, CupertinoIcons.delete, () async {
                if (await _confirmSecretDelete(context)) await cubit.deleteSecret(chat);
              }, destructive: true),
            ]
          : [
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
              if (chat.unreadReactions > 0) action(t.readReactions, CupertinoIcons.heart, () => cubit.readReactions(chat)),
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
              // Личный — после закрытия меню отдельное меню «У меня» / «У меня и
              // собеседника» у строки; остальные — алерт.
              action(t.deleteChat, CupertinoIcons.delete, () async {
                final forEveryone = await confirmDelete(afterContextMenu: true);
                if (forEveryone != null) await cubit.delete(chat, forEveryone: forEveryone);
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

/// Пункты выпадающего меню (`CupertinoMenuAnchor`) выбора «У меня» / «У меня и
/// собеседника»: удаление чата (см. [chatDeleteScoped]) или сообщений личного
/// чата, закрепление сообщения. [onSelected] получает «и у собеседника?».
List<Widget> scopeMenuCupertino(BuildContext context, void Function(bool forEveryone) onSelected, {bool destructive = true}) {
  final t = context.t.screenChats;
  return [
    CupertinoMenuItem(
      isDestructiveAction: destructive,
      trailing: const Icon(CupertinoIcons.person),
      onPressed: () => onSelected(false),
      child: Text(t.scopeMe),
    ),
    CupertinoMenuItem(
      isDestructiveAction: destructive,
      trailing: const Icon(CupertinoIcons.person_2),
      onPressed: () => onSelected(true),
      child: Text(t.scopeBoth),
    ),
  ];
}

/// «Удалить чат?» без выбора (не [chatDeleteScoped]: «Избранное», группа,
/// канал) — подтверждение алертом. Результат — «и у собеседника?» (всегда
/// false), `null` — отмена.
Future<bool?> askDeleteChatCupertino(BuildContext context, models.Chat chat) async {
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
  return (confirmed ?? false) ? false : null;
}

/// Открыть меню [ScopeMenuAnchorCupertino]. [afterContextMenu] — зовут из
/// пункта `CupertinoContextMenu`: оно маршрут корневого навигатора поверх
/// выпадающего меню, поэтому то открывается, когда контекстное доиграет
/// закрытие. Результат — «и у собеседника?», `null` — закрыли мимо пунктов.
typedef ScopeAsk = Future<bool?> Function({bool destructive, bool afterContextMenu});

/// Подтверждение удаления чата: с выбором — меню у строки, без — алерт.
typedef ChatDeleteConfirm = Future<bool?> Function({bool afterContextMenu});

/// Длительность закрытия `CupertinoContextMenu` (`_kModalPopupTransitionDuration`
/// в cupertino_ui).
const contextMenuCloseDuration = Duration(milliseconds: 335);

/// Виджет [builder] с отдельным выпадающим меню «У меня» / «У меня и
/// собеседника» ([scopeMenuCupertino]) — открывается вызовом [ScopeAsk]: из
/// свайпа «Удалить» (у кнопки свайпа своего якоря нет) или из пункта
/// контекстного меню (после его закрытия).
class ScopeMenuAnchorCupertino extends StatefulWidget {
  final Widget Function(BuildContext context, ScopeAsk ask) builder;

  const ScopeMenuAnchorCupertino({super.key, required this.builder});

  @override
  State<ScopeMenuAnchorCupertino> createState() => _ScopeMenuAnchorCupertinoState();
}

class _ScopeMenuAnchorCupertinoState extends State<ScopeMenuAnchorCupertino> {
  final _controller = MenuController();
  Completer<bool?>? _choice;
  bool _destructive = true;

  Future<bool?> _ask({bool destructive = true, bool afterContextMenu = false}) async {
    _finish(null);
    final choice = _choice = Completer<bool?>();
    if (afterContextMenu) await Future<void>.delayed(contextMenuCloseDuration);
    // За время ожидания строку убрали или позвали снова — уже завершён.
    if (!mounted || choice.isCompleted) return choice.future;
    setState(() => _destructive = destructive);
    _controller.open();
    return choice.future;
  }

  void _finish(bool? forEveryone) {
    final choice = _choice;
    _choice = null;
    if (choice != null && !choice.isCompleted) choice.complete(forEveryone);
  }

  @override
  void dispose() {
    _finish(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoMenuAnchor(
      controller: _controller,
      // Закрыли мимо пунктов — отмена (пункт успевает ответить раньше).
      onClose: () => _finish(null),
      menuChildren: scopeMenuCupertino(context, _finish, destructive: _destructive),
      builder: (context, controller, child) => widget.builder(context, _ask),
    );
  }
}

/// Строка чата с меню удаления ([ScopeMenuAnchorCupertino]) для свайпа
/// «Удалить» и пункта «Удалить чат» контекстного меню. [builder] получает
/// подтверждение (`ChatSwipeActions.confirmDelete`): с выбором
/// ([chatDeleteScoped]) — меню у строки, без — алерт ([askDeleteChatCupertino]).
class ChatDeleteMenuAnchorCupertino extends StatelessWidget {
  final models.Chat chat;
  final Widget Function(BuildContext context, ChatDeleteConfirm confirmDelete) builder;

  const ChatDeleteMenuAnchorCupertino({super.key, required this.chat, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ScopeMenuAnchorCupertino(
      builder: (context, ask) => builder(context, ({bool afterContextMenu = false}) {
        if (!chatDeleteScoped(chat)) return askDeleteChatCupertino(context, chat);
        return ask(afterContextMenu: afterContextMenu);
      }),
    );
  }
}

/// Действия меню папки по удержанию таба (`CupertinoContextMenu` в
/// `ChatFolderTabsCupertino`): у «Все чаты» — «Прочитать все», «Изменить
/// папки»; у остальных — «Изменить папку», «Прочитать все», «Изменить порядок»
/// (экран «Папки»), «Удалить папку».
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
    if (!folder.isAll) action(t.editFolder, CupertinoIcons.pencil, () => showChatFolderEditCupertino(context, folder: folder)),
    if (unread) action(t.readAll, CupertinoIcons.chat_bubble_2, () => cubit.readAll(folder)),
    if (folder.isAll)
      action(t.editFolders, CupertinoIcons.folder, () => showChatFoldersCupertino(context))
    else ...[
      action(t.reorderFolders, CupertinoIcons.arrow_up_arrow_down, () => showChatFoldersCupertino(context)),
      action(t.deleteFolder, CupertinoIcons.delete, () => _confirmDeleteFolder(context, cubit, folder, title), destructive: true),
    ],
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

/// Подтверждение удаления секретного чата (у обоих, с перепиской).
Future<bool> _confirmSecretDelete(BuildContext context) async {
  final t = context.t.secretChat;
  final confirmed = await showCupertinoDialog<bool>(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(t.delete),
      content: Text(t.deleteConfirm),
      actions: [
        CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
        CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.delete)),
      ],
    ),
  );
  return confirmed == true;
}
