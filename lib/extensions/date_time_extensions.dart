import 'package:intl/intl.dart';

import '../i18n/translations.g.dart';

extension RelativeDateTimeExtension on DateTime {
  /// Возвращает локализованную строку вида:
  /// - "сегодня в 12:00" — если дата совпадает с текущим днём;
  /// - "вчера в 12:00" — если дата вчерашняя;
  /// - "30.06.2026 в 12:00" — для остальных дат.
  String relativeFormat(Translations t) {
    final local = toLocal();
    final now = DateTime.now();

    final date = DateTime(local.year, local.month, local.day);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final time = DateFormat('HH:mm').format(local);

    if (date == today) {
      return t.relativeDateTimeToday(time: time);
    }
    if (date == yesterday) {
      return t.relativeDateTimeYesterday(time: time);
    }

    final dateStr = DateFormat('dd.MM.yyyy').format(local);
    return t.relativeDateTimeOther(date: dateStr, time: time);
  }
}
