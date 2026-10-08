import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../../i18n/translations.g.dart';

/// «Срок комментирования» канала: сколько секунд после публикации под постом
/// можно комментировать; 0 — без ограничения (см. `Chat.commentsTimeLimit`).
const commentsLimitOptions = [3600, 3 * 3600, 5 * 3600, 8 * 3600, 86400, 3 * 86400, 7 * 86400, 30 * 86400, 365 * 86400, 0];

String commentsLimitLabel(Translations t, int seconds) {
  final s = t.screenNewChat;
  return switch (seconds) {
    <= 0 => s.commentsLimitOff,
    < 86400 => s.commentsLimitHours(n: seconds ~/ 3600),
    < 7 * 86400 => s.commentsLimitDays(n: seconds ~/ 86400),
    < 30 * 86400 => s.commentsLimitWeek,
    < 365 * 86400 => s.commentsLimitMonth,
    _ => s.commentsLimitYear,
  };
}

/// Выбор срока на Android — нижний лист с отметкой текущего (на iOS —
/// выпадающее меню прямо у строки, `CupertinoMenuAnchor`). `null` — закрыли.
Future<int?> pickCommentsLimit(BuildContext context, int current) {
  final t = context.t;
  return m.showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(t.screenNewChat.commentsLimit, style: m.Theme.of(sheetContext).textTheme.titleMedium),
            ),
            for (final value in commentsLimitOptions)
              m.ListTile(
                leading: m.Icon(value == 0 ? m.Icons.all_inclusive : m.Icons.schedule),
                title: Text(commentsLimitLabel(t, value)),
                trailing: value == current ? m.Icon(m.Icons.check, color: m.Theme.of(sheetContext).colorScheme.primary) : null,
                onTap: () => Navigator.of(sheetContext).pop(value),
              ),
          ],
        ),
      ),
    ),
  );
}
