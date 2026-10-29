import '../../chats/chats_mapping.dart';
import '../../chats/chats_sync.dart';
import '../../chats/reports.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

export '../../chats/reports.dart' show ReportReason;

/// На что жалоба: человек ([userID]) или чат ([chatID]) с сообщениями
/// [messageIDs] (серверные номера).
class ReportTarget {
  final List<int> userID;
  final List<int> chatID;
  final List<int> messageIDs;

  const ReportTarget.user(this.userID) : chatID = const [], messageIDs = const [];

  const ReportTarget.chat(this.chatID, {this.messageIDs = const []}) : userID = const [];

  /// Из чата: секретный — жалоба на собеседника без содержимого (сервер его
  /// не знает), остальные — на чат с выбранными сообщениями. `null` — не на
  /// что (Избранное, «Iperon», демо без серверных ID).
  static ReportTarget? fromChat(models.Chat chat, {List<models.Message> messages = const []}) {
    if (chat.isSelf || chat.isSystem) return null;
    if (chat.isSecret) {
      final peer = idBytes(chat.peerUserID);
      return peer.isEmpty ? null : ReportTarget.user(peer);
    }
    final chatID = idBytes(chat.id);
    if (chatID.isEmpty) return null;
    final ids = [
      for (final message in messages)
        if (!message.outgoing && int.tryParse(message.id) != null) int.parse(message.id),
    ];

    return ReportTarget.chat(chatID, messageIDs: ids);
  }
}

/// Причины по порядку (как в Telegram: частые сверху).
const reportReasons = ReportReason.values;

String reportReasonLabel(Translations t, ReportReason reason) {
  final r = t.report.reasons;

  return switch (reason) {
    ReportReason.spam => r.spam,
    ReportReason.violence => r.violence,
    ReportReason.pornography => r.pornography,
    ReportReason.childAbuse => r.childAbuse,
    ReportReason.drugs => r.drugs,
    ReportReason.personalData => r.personalData,
    ReportReason.fake => r.fake,
    ReportReason.copyright => r.copyright,
    ReportReason.other => r.other,
  };
}

/// Отправляет жалобу; `null` — ушла, иначе текст ошибки для показа (нет сети,
/// лимит, отказ).
Future<String?> submitReport(Translations t, ReportTarget target, ReportReason reason, String comment) async {
  try {
    await sendReport(userID: target.userID, chatID: target.chatID, messageIDs: target.messageIDs, reason: reason, comment: comment);
    return null;
  } on ChatsOfflineException {
    return t.report.offline;
  } on ChatsFloodException {
    return t.report.flood;
  } on ReportException {
    return t.report.failed;
  }
}
