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

  const ChatInvitesState({this.status = Status.initialization, this.chat, this.links = const [], this.requests = const []});

  models.ChatInviteLink? get primary => links.where((l) => l.primary && !l.revoked).firstOrNull;

  /// Дополнительные (не отозванные) — новые выше.
  List<models.ChatInviteLink> get additional => links.where((l) => !l.primary && !l.revoked).toList();

  List<models.ChatInviteLink> get revoked => links.where((l) => l.revoked).toList();
}
