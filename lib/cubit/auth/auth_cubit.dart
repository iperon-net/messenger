import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../settings.dart';
import '../../utils.dart';
import '../../protobuf.dart';

import 'auth_state.dart';

enum PhoneValidationError { empty, notAllowRegion }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();
  final settings = getIt.get<Settings>();

  final phoneUtil = PhoneNumberUtil.instance;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    // Insert code initialization

    emit(state.copyWith(status: Status.success));
  }

  PhoneValidationError? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return PhoneValidationError.empty;

    final PhoneNumber phoneNumber;
    try {
      phoneNumber = phoneUtil.parse(value, "RU");
    } catch (err) {
      logger.error(err);
      return PhoneValidationError.empty;
    }

    if (phoneUtil.getNumberType(phoneNumber) != PhoneNumberType.mobile) {
      return PhoneValidationError.notAllowRegion;
    }

    return null;
  }

  Future<void> onPressed(String phoneNumber) async {
    emit(state.copyWith(status: Status.loading, error: null));

    final phoneNumberNormalization = utils.phoneNormalization(phoneNumber: phoneNumber);

    // Workflow moderation application store
    if (settings.phoneNumberModerationApplicationStoreEnable && settings.phoneNumberModerationApplicationStore == phoneNumberNormalization.raw) {
      final messageRequest = Message(
        messageType: MessageType.AUTH_MODERATION_APPLICATION_STORE,
        message: AuthModerationApplicationStore_Request(phoneNumber: phoneNumberNormalization.raw).writeToBuffer(),
      );

      late Message response;
      final grpcError = await api.call(() async {
        response = await api.client.unary(messageRequest);
      });

      if (grpcError.status == APIStatus.error) {
        emit(state.copyWith(status: Status.success, error: grpcError.error));
        return;
      }

      final messageResponse = AuthModerationApplicationStore_Response.fromBuffer(response.message);
      final moderationApplicationStoreSession = utils.bytesToHex(Uint8List.fromList(messageResponse.moderationApplicationStoreSession));

      final phoneNormalization = utils.phoneNormalization(phoneNumber: phoneNumber);

      final uri = Uri.parse("/auth/moderation_application_store").replace(
          queryParameters: {
            "moderationApplicationStoreSession": moderationApplicationStoreSession,
            "phoneNumber": phoneNormalization.international,
          }
      );

      emit(state.copyWith(status: Status.success, error: null, redirectURI: uri));
      return;
    }

    // Workflow call password
    final messageRequest = Message(
        messageType: MessageType.AUTH_CALL_PASSWORD,
        message: AuthCallPassword_Request(phoneNumber: phoneNumberNormalization.raw).writeToBuffer(),
    );

    late Message response;
    final grpcError = await api.call(() async {
      response = await api.client.unary(messageRequest);
    });

    if (grpcError.status == APIStatus.error) {
      emit(state.copyWith(status: Status.success, error: grpcError.error));
      return;
    }

    final messageResponse = AuthCallPassword_Response.fromBuffer(response.message);
    logger.debug(messageResponse);

    final callPasswordSession = utils.bytesToHex(Uint8List.fromList(messageResponse.callPasswordSession));

    final uri = Uri.parse("/auth/call_password_confirmation").replace(
        queryParameters: {
          "callPasswordSession": callPasswordSession,
          "confirmationPhoneNumber": messageResponse.confirmationPhoneNumber,
          "timeout": messageResponse.timeout.toString(),
        }
    );

    emit(state.copyWith(status: Status.success, error: null, redirectURI: uri));
    return;
  }

}
