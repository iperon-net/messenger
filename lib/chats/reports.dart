import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';

import '../api.dart';
import '../di.dart';
import '../protobuf.dart' as pb;
import '../utils.dart';
import 'chats_sync.dart';

/// Причина жалобы (как `Report.Reason` в reports_v1.proto).
enum ReportReason { spam, violence, pornography, childAbuse, drugs, personalData, fake, copyright, other }

/// Жалоба отклонена сервером (неверная / нет чата / прочее) — не сетевое.
class ReportException implements Exception {
  final String error;

  const ReportException(this.error);

  @override
  String toString() => 'ReportException: $error';
}

const _reasons = {
  ReportReason.spam: pb.Report_Reason.SPAM,
  ReportReason.violence: pb.Report_Reason.VIOLENCE,
  ReportReason.pornography: pb.Report_Reason.PORNOGRAPHY,
  ReportReason.childAbuse: pb.Report_Reason.CHILD_ABUSE,
  ReportReason.drugs: pb.Report_Reason.ILLEGAL_DRUGS,
  ReportReason.personalData: pb.Report_Reason.PERSONAL_DATA,
  ReportReason.fake: pb.Report_Reason.FAKE,
  ReportReason.copyright: pb.Report_Reason.COPYRIGHT,
  ReportReason.other: pb.Report_Reason.OTHER,
};

/// Отправляет жалобу модерации (`REPORT`, этап 3 админки): на человека
/// ([userID] — профиль, секретный чат) или на чат ([chatID] — личный,
/// группа, канал) с сообщениями-доказательствами [messageIDs]. Без сети —
/// [ChatsOfflineException] (ничего не отправлено), лимит —
/// [ChatsFloodException], отказ сервера — [ReportException].
Future<void> sendReport({
  List<int> userID = const [],
  List<int> chatID = const [],
  List<int> messageIDs = const [],
  required ReportReason reason,
  String comment = '',
}) async {
  if (!await getIt.get<Utils>().hasNetwork()) throw const ChatsOfflineException();

  final request = pb.Report_Request(
    userID: userID,
    chatID: chatID,
    messageIDs: [for (final id in messageIDs) Int64(id)],
    reason: _reasons[reason],
    comment: comment.trim(),
  );
  final status = await getIt.get<API>().unaryEncoded(pb.MessageType.REPORT, request.writeToBuffer());
  if (status.status == APIStatus.success) return;

  final flood = ChatsFloodException.parse(status.statusCode, status.error);
  if (flood != null) throw flood;
  if ([StatusCode.unavailable, StatusCode.deadlineExceeded, StatusCode.unknown].contains(status.statusCode)) {
    throw const ChatsOfflineException();
  }
  throw ReportException(status.error);
}
