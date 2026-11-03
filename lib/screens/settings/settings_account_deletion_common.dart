import 'package:intl/intl.dart';

import '../../i18n/translations.g.dart';

String accountDeletionScheduledText(Translations t, DateTime scheduled, {DateTime? now}) {
  final remaining = scheduled.difference(now ?? DateTime.now());
  final String remainingText;
  if (remaining.inDays > 0) {
    remainingText = t.accountDeletion.remainingDays(n: remaining.inDays);
  } else if (remaining.inHours > 0) {
    remainingText = t.accountDeletion.remainingHours(n: remaining.inHours);
  } else {
    remainingText = t.accountDeletion.remainingMinutes(n: remaining.inMinutes.clamp(0, 59));
  }
  return t.accountDeletion.scheduled(date: DateFormat('d MMMM y, HH:mm').format(scheduled.toLocal()), remaining: remainingText);
}
