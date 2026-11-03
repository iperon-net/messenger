import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../i18n/translations.g.dart';

String accountDeletionScheduledText(Translations t, DateTime scheduled, {DateTime? now}) {
  final difference = scheduled.difference(now ?? DateTime.now());
  final remaining = difference.isNegative ? Duration.zero : difference;
  final days = remaining.inDays;
  final hours = remaining.inHours % Duration.hoursPerDay;
  final minutes = remaining.inMinutes % Duration.minutesPerHour;
  final parts = <String>[
    if (days > 0) t.accountDeletion.remainingDays(n: days),
    if (hours > 0) t.accountDeletion.remainingHours(n: hours),
    if (minutes > 0 || (days == 0 && hours == 0)) t.accountDeletion.remainingMinutes(n: minutes),
  ];
  return t.accountDeletion.scheduled(
    date: DateFormat('d MMMM y, HH:mm', LocaleSettings.currentLocale.languageCode).format(scheduled.toLocal()),
    remaining: t.accountDeletion.remaining(parts: parts.join(', ')),
  );
}

class AccountDeletionScheduledText extends StatefulWidget {
  const AccountDeletionScheduledText({super.key, required this.t, required this.scheduled, this.style, this.now = DateTime.now});

  final Translations t;
  final DateTime scheduled;
  final TextStyle? style;
  final DateTime Function() now;

  @override
  State<AccountDeletionScheduledText> createState() => _AccountDeletionScheduledTextState();
}

class _AccountDeletionScheduledTextState extends State<AccountDeletionScheduledText> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(accountDeletionScheduledText(widget.t, widget.scheduled, now: widget.now()), style: widget.style);
  }
}
