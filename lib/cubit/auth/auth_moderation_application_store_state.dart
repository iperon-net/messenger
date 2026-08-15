import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'auth_moderation_application_store_state.mapper.dart';

@MappableClass()
class AuthModerationApplicationStoreState
    with AuthModerationApplicationStoreStateMappable {
  final Status status;
  final String? error;
  final Uint8List moderationApplicationStoreSession;
  final String phoneNumber;
  final Uri? redirectURI;

  AuthModerationApplicationStoreState({
    this.status = Status.initialization,
    this.error,
    Uint8List? moderationApplicationStoreSession,
    this.phoneNumber = "",
    this.redirectURI,
  }) : moderationApplicationStoreSession =
           moderationApplicationStoreSession ?? Uint8List(0);
}
