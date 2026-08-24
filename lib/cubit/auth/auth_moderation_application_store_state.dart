import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'auth_moderation_application_store_state.mapper.dart';

@MappableClass()
class AuthModerationApplicationStoreState with AuthModerationApplicationStoreStateMappable {
  final Status status;
  final Status networkStatus;
  final String error;
  final String redirectURI;

  final Uint8List moderationApplicationStoreSession;
  final String phoneNumber;

  AuthModerationApplicationStoreState({
    this.status = Status.initialization,
    this.networkStatus = Status.initialization,
    this.error = "",
    this.redirectURI = "",

    Uint8List? moderationApplicationStoreSession,
    this.phoneNumber = "",
  }) : moderationApplicationStoreSession = moderationApplicationStoreSession ?? Uint8List(0);
}
