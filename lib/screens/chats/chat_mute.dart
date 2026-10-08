import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../../i18n/translations.g.dart';

/// «Заглушить на…»: на сколько выключить уведомления чата.
enum ChatMuteFor { hour, eightHours, twoDays, forever }

/// До какого времени (`null` — навсегда).
DateTime? chatMuteUntil(ChatMuteFor value) => switch (value) {
  ChatMuteFor.hour => DateTime.now().add(const Duration(hours: 1)),
  ChatMuteFor.eightHours => DateTime.now().add(const Duration(hours: 8)),
  ChatMuteFor.twoDays => DateTime.now().add(const Duration(days: 2)),
  ChatMuteFor.forever => null,
};

String chatMuteLabel(Translations t, ChatMuteFor value) => switch (value) {
  ChatMuteFor.hour => t.screenChats.muteHour,
  ChatMuteFor.eightHours => t.screenChats.mute8Hours,
  ChatMuteFor.twoDays => t.screenChats.mute2Days,
  ChatMuteFor.forever => t.screenChats.muteForever,
};

/// «до 18:30» (сегодня) / «до 9.10, 18:30».
String chatMutedUntilLabel(Translations t, DateTime until) {
  final local = until.toLocal();
  final now = DateTime.now();
  final today = local.year == now.year && local.month == now.month && local.day == now.day;
  final time = DateFormat.Hm().format(local);
  return t.screenChats.mutedUntil(time: today ? time : '${DateFormat.Md().format(local)}, $time');
}

/// Выбор срока: iOS — action sheet (из long-press-меню списка чатов, где
/// вложенного меню нет; в профиле — выпадающее меню у «Звук»), Android —
/// нижний лист. `null` — закрыли.
Future<ChatMuteFor?> pickChatMute(BuildContext context) {
  final t = context.t;
  if (Platform.isIOS) {
    return c.showCupertinoModalPopup<ChatMuteFor>(
      context: context,
      builder: (sheetContext) => c.CupertinoActionSheet(
        title: Text(t.screenChats.muteTitle),
        actions: [
          for (final value in ChatMuteFor.values)
            c.CupertinoActionSheetAction(
              isDestructiveAction: value == ChatMuteFor.forever,
              onPressed: () => Navigator.of(sheetContext).pop(value),
              child: Text(chatMuteLabel(t, value)),
            ),
        ],
        cancelButton: c.CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(t.common.cancel)),
      ),
    );
  }
  return m.showModalBottomSheet<ChatMuteFor>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(t.screenChats.muteTitle, style: m.Theme.of(sheetContext).textTheme.titleMedium),
          ),
          for (final value in ChatMuteFor.values)
            m.ListTile(
              leading: m.Icon(value == ChatMuteFor.forever ? m.Icons.notifications_off_outlined : m.Icons.schedule),
              title: Text(chatMuteLabel(t, value)),
              onTap: () => Navigator.of(sheetContext).pop(value),
            ),
        ],
      ),
    ),
  );
}
