import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Общее для «Ссылок-приглашений» и «Заявок на вступление» (Cupertino +
/// Material).

/// Полный адрес ссылки (`+код` или публичное имя).
String inviteUrl(String path) => 'https://iperon.net/$path';

/// Как ссылку показывать в списке: без схемы.
String inviteShort(String path) => 'iperon.net/$path';

void copyInvite(String path) => Clipboard.setData(ClipboardData(text: inviteUrl(path)));

Future<void> shareInvite(String path) => SharePlus.instance.share(ShareParams(text: inviteUrl(path)));

/// Срок действия ссылки — дата и время в формате локали.
String inviteDate(DateTime date) => '${DateFormat.yMd().format(date.toLocal())} ${DateFormat.Hm().format(date.toLocal())}';

/// Заголовок строки ссылки: название или сама ссылка.
String inviteTitle(models.ChatInviteLink link) => link.title.isNotEmpty ? link.title : inviteShort(link.link);

/// Вторая строка: «Вступили: 3 · осталось 7 · до 12.10.2026 18:00» /
/// «истекла» / «лимит исчерпан» / «по заявке». [warning] — ссылка не
/// работает (подсветить).
({String text, bool warning}) inviteSubtitle(Translations t, models.ChatInviteLink link, DateTime now) {
  final tc = t.screenChatInvites;
  final parts = <String>[tc.joined(n: link.usage)];
  var warning = false;
  if (link.revoked) {
    // Отозванные — только счётчик.
  } else if (link.isExpired(now)) {
    parts.add(tc.expired);
    warning = true;
  } else if (link.isExhausted) {
    parts.add(tc.exhausted);
    warning = true;
  } else {
    if (link.usageLimit > 0) parts.add(tc.left(n: link.usageLimit - link.usage));
    if (link.expireDate != null) parts.add(tc.until(date: inviteDate(link.expireDate!)));
    if (link.requestApproval) parts.add(tc.approval);
  }
  return (text: parts.join(' · '), warning: warning);
}

/// Подпись под основной ссылкой — по способу вступления.
String invitePrimaryFooter(Translations t, models.Chat chat) {
  final tc = t.screenChatInvites;
  if (chat.type == models.ChatType.channel) return tc.primaryFooterChannel;
  if (chat.joinMode == models.ChatJoinMode.request) return tc.primaryFooterRequest;
  return tc.primaryFooter;
}

/// Вторая строка заявки: «сегодня в 12:30 · по ссылке «Митап»».
String joinRequestSubtitle(Translations t, models.ChatJoinRequest request) {
  final parts = [request.date.relativeFormat(t)];
  if (request.linkTitle.isNotEmpty) parts.add(t.screenChatInvites.viaLink(title: request.linkTitle));
  return parts.join(' · ');
}

/// Пресеты срока действия в редакторе ссылки (`null` — бессрочно).
const invitePresetDurations = <Duration?>[null, Duration(hours: 1), Duration(days: 1), Duration(days: 7)];

String inviteDurationLabel(Translations t, Duration? duration) => switch (duration?.inHours) {
  null => t.screenChatInvites.expireNever,
  1 => t.screenChatInvites.expireHour,
  24 => t.screenChatInvites.expireDay,
  _ => t.screenChatInvites.expireWeek,
};

/// Пресеты лимита вступлений (0 — без ограничений).
const inviteLimits = [0, 1, 10, 50, 100];
