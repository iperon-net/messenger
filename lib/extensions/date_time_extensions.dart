import 'package:intl/intl.dart';

import '../i18n/translations.g.dart';

extension RelativeDateTimeExtension on DateTime {
  /// Возвращает локализованную строку вида:
  /// - "сегодня в 12:00" — если дата совпадает с текущим днём;
  /// - "вчера в 12:00" — если дата вчерашняя;
  /// - "30.06.2026 в 12:00" — для остальных дат.
  ///
  /// Форматы даты и времени берутся из активной локали intl
  /// (`Intl.defaultLocale`, выставляется в `Utils.applyLocale`), поэтому,
  /// например, en_US даёт "8/22/2026, 2:30 PM", а en_GB — "22/08/2026, 14:30".
  String relativeFormat(Translations t) {
    final local = toLocal();
    final now = DateTime.now();

    final date = DateTime(local.year, local.month, local.day);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final time = DateFormat.jm().format(local);

    if (date == today) {
      return t.dateTime.relativeDateTimeToday(time: time);
    }
    if (date == yesterday) {
      return t.dateTime.relativeDateTimeYesterday(time: time);
    }

    final dateStr = DateFormat.yMd().format(local);
    return t.dateTime.relativeDateTimeOther(date: dateStr, time: time);
  }
}
