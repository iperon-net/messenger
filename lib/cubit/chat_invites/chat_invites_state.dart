import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart' as models;

part 'chat_invites_state.mapper.dart';

/// «Ссылки-приглашения» и «Заявки на вступление» чата (профиль → админ).
@MappableClass()
class ChatInvitesState with ChatInvitesStateMappable {
  final Status status;
  final models.Chat? chat;

  /// Все ссылки, включая отозванные (разбивка — геттерами).
  final List<models.ChatInviteLink> links;

  final List<models.ChatJoinRequest> requests;

  /// Заявки грузятся (сервер — только по запросу).
  final bool requestsLoading;

  /// Заявки не загрузились (нет сети / отказ): экран говорит об этом и
  /// предлагает повторить, а не показывает «заявок нет».
  final bool requestsFailed;

  /// Отозванную ссылку можно удалить одну (демо); сервер — только все сразу.
  final bool deletesRevokedSingly;

  /// Растёт, когда действие не выполнено без сети («Нет соединения»).
  final int offlineNotice;

  /// Сервер отклонил действие: растёт на каждый отказ, [failError] — ключ.
  final int failNotice;
  final String failError;

  const ChatInvitesState({
    this.status = Status.initialization,
    this.chat,
    this.links = const [],
    this.requests = const [],
    this.requestsLoading = false,
    this.requestsFailed = false,
    this.deletesRevokedSingly = true,
    this.offlineNotice = 0,
    this.failNotice = 0,
    this.failError = '',
  });

  models.ChatInviteLink? get primary => links.where((l) => l.primary && !l.revoked).firstOrNull;

  /// Дополнительные (не отозванные) — новые выше.
  List<models.ChatInviteLink> get additional => links.where((l) => !l.primary && !l.revoked).toList();

  List<models.ChatInviteLink> get revoked => links.where((l) => l.revoked).toList();
}
