import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Сроки комментариев канала, в секундах; 0 — без ограничения. Одни и те же
/// варианты у «Срока комментирования» (сколько после публикации можно
/// комментировать, `Chat.commentsTimeLimit`) и «Подписки не менее» (сколько
/// нужно быть подписанным, `Chat.commentsMinSubscription`).
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

String commentsWhoLabel(Translations t, models.ChatCommentsWho who) => switch (who) {
  models.ChatCommentsWho.all => t.screenNewChat.commentsWhoAll,
  models.ChatCommentsWho.subscribers => t.screenNewChat.commentsWhoSubscribers,
};

/// Момент для «… с {time}»: «18:30» (сегодня) / «9.10, 18:30».
String untilTimeLabel(DateTime until) {
  final local = until.toLocal();
  final now = DateTime.now();
  final today = local.year == now.year && local.month == now.month && local.day == now.day;
  final time = DateFormat.Hm().format(local);
  return today ? time : '${DateFormat.Md().format(local)}, $time';
}

/// «Комментировать можно с 18:30» (сегодня) / «… с 9.10, 18:30».
String commentsWaitLabel(Translations t, DateTime until) => t.screenChat.commentsWaitUntil(time: untilTimeLabel(until));

/// «Новичкам — без ссылок и медиа»: 0 — «Выкл.», иначе срок.
String newcomerMediaLabel(Translations t, int seconds) => seconds <= 0 ? t.screenNewChat.newcomerMediaOff : commentsLimitLabel(t, seconds);

/// Android: выбор срока — нижний лист с отметкой текущего (на iOS —
/// выпадающее меню прямо у строки, `CupertinoMenuAnchor`). `null` — закрыли.
/// [label] — подпись варианта (по умолчанию [commentsLimitLabel]).
Future<int?> pickCommentsLimit(BuildContext context, int current, {required String title, String Function(int value)? label}) {
  final t = context.t;
  return _pick(
    context,
    title: title,
    values: commentsLimitOptions,
    current: current,
    label: label ?? (value) => commentsLimitLabel(t, value),
    icon: (value) => value == 0 ? m.Icons.all_inclusive : m.Icons.schedule,
  );
}

/// Android: «Кто может комментировать».
Future<models.ChatCommentsWho?> pickCommentsWho(BuildContext context, models.ChatCommentsWho current) {
  final t = context.t;
  return _pick(
    context,
    title: t.screenNewChat.commentsWho,
    values: models.ChatCommentsWho.values,
    current: current,
    label: (value) => commentsWhoLabel(t, value),
    icon: (value) => value == models.ChatCommentsWho.all ? m.Icons.public : m.Icons.how_to_reg_outlined,
  );
}

Future<T?> _pick<T>(
  BuildContext context, {
  required String title,
  required List<T> values,
  required T current,
  required String Function(T value) label,
  required IconData Function(T value) icon,
}) {
  return m.showModalBottomSheet<T>(
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
              child: Text(title, style: m.Theme.of(sheetContext).textTheme.titleMedium),
            ),
            for (final value in values)
              m.ListTile(
                leading: m.Icon(icon(value)),
                title: Text(label(value)),
                trailing: value == current ? m.Icon(m.Icons.check, color: m.Theme.of(sheetContext).colorScheme.primary) : null,
                onTap: () => Navigator.of(sheetContext).pop(value),
              ),
          ],
        ),
      ),
    ),
  );
}
