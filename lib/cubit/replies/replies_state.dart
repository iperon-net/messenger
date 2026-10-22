import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart' as models;

part 'replies_state.mapper.dart';

/// Экран «Ответы» (подэтап 4.6): лента ответов на мои комментарии и
/// упоминаний меня в ветках комментариев, только чтение.
@MappableClass()
class RepliesState with RepliesStateMappable {
  final Status status;

  /// От старых к новым (внизу — самый новый, как в чате).
  final List<models.ChatReply> replies;

  /// На сервере есть ещё более старые (дозагрузка вверх).
  final bool hasOlder;

  /// Идёт дозагрузка старых.
  final bool loadingOlder;

  const RepliesState({this.status = Status.initialization, this.replies = const [], this.hasOlder = true, this.loadingOlder = false});
}
