import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Свайпы по строке чата (как в Telegram): вправо — «Прочитано» и
/// «Закрепить», влево — «Выкл. звук», «Удалить», «Архив» (полный свайп влево —
/// сразу в архив / из архива).
///
/// Работают, только когда папка одна (и в «Архиве»): при нескольких папках
/// горизонтальный свайп листает папки, а действия — в меню по удержанию (см.
/// docs/plans/chats-groups-channels.md, «Папки» → «Конфликт жестов»).
class ChatSwipeActions extends StatelessWidget {
  final models.Chat chat;
  final bool enabled;
  final Widget child;

  /// Подтверждение удаления — платформенный диалог.
  final Future<bool> Function() confirmDelete;

  const ChatSwipeActions({super.key, required this.chat, required this.enabled, required this.confirmDelete, required this.child});

  /// Открытая строка закрывается, когда открывают другую.
  static const groupTag = 'chats';

  static const _blue = Color(0xFF007AFF);
  static const _green = Color(0xFF34C759);
  static const _orange = Color(0xFFFF9500);
  static const _red = Color(0xFFFF3B30);
  static const _gray = Color(0xFF8E8E93);

  /// Ширина одной кнопки — доля ширины строки.
  static const _actionExtent = 0.2;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatsCubit>();
    final t = context.t.screenChats;
    final canArchive = !chat.isSelf;

    final start = [
      _action(
        chat.hasUnread ? FontAwesomeIcons.solidEnvelopeOpen : FontAwesomeIcons.solidEnvelope,
        chat.hasUnread ? t.swipeRead : t.swipeUnread,
        _blue,
        () => cubit.setRead(chat, chat.hasUnread),
      ),
      if (!chat.archived)
        _action(FontAwesomeIcons.thumbtack, chat.pinned ? t.unpin : t.pin, _green, () => cubit.setPinned(chat, !chat.pinned)),
    ];
    final end = [
      _action(
        chat.muted ? FontAwesomeIcons.solidBell : FontAwesomeIcons.solidBellSlash,
        chat.muted ? t.swipeUnmute : t.swipeMute,
        _orange,
        () => cubit.setMuted(chat, !chat.muted),
      ),
      _action(FontAwesomeIcons.solidTrashCan, t.delete, _red, () async {
        if (await confirmDelete()) await cubit.delete(chat);
      }),
      if (canArchive)
        _action(
          FontAwesomeIcons.boxArchive,
          chat.archived ? t.swipeUnarchive : t.swipeArchive,
          _gray,
          () => cubit.setArchived(chat, !chat.archived),
        ),
    ];

    return Slidable(
      key: ValueKey('swipe_${chat.id}'),
      groupTag: groupTag,
      enabled: enabled,
      startActionPane: ActionPane(motion: const ScrollMotion(), extentRatio: _actionExtent * start.length, children: start),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: _actionExtent * end.length,
        // Полный свайп влево — архив (строка уезжает из списка).
        dismissible: canArchive ? DismissiblePane(onDismissed: () => cubit.setArchived(chat, !chat.archived)) : null,
        children: end,
      ),
      child: child,
    );
  }

  Widget _action(FaIconData icon, String label, Color color, VoidCallback onPressed) {
    return CustomSlidableAction(
      onPressed: (_) => onPressed(),
      backgroundColor: color,
      foregroundColor: const Color(0xFFFFFFFF),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          FaIcon(icon, size: 20, color: const Color(0xFFFFFFFF)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFFFFFFFF)),
            ),
          ),
        ],
      ),
    );
  }
}
