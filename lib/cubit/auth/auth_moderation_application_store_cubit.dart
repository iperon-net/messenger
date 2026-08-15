import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cryptography/cryptography.dart';
import 'package:grpc/grpc.dart';
import 'package:pqcrypto/pqcrypto.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import '../../utils.dart';
import '../../repositories.dart';
import '../../auth.dart';
import '../../protobuf.dart';

import 'auth_moderation_application_store_state.dart';

class AuthModerationApplicationStoreCubit
    extends Cubit<AuthModerationApplicationStoreState> {
  AuthModerationApplicationStoreCubit()
    : super(AuthModerationApplicationStoreState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();
  final repositories = getIt.get<Repositories>();

  final ed25519 = Ed25519();
  final kem = PqcKem.kyber768;

  Future<void> initialization({
    required String phoneNumber,
    required String moderationApplicationStoreSession,
  }) async {
    emit(state.copyWith(status: Status.loading));

    // Insert code initialization

    emit(
      state.copyWith(
        status: Status.success,
        phoneNumber: phoneNumber,
        moderationApplicationStoreSession: utils.hexToBytes(
          moderationApplicationStoreSession,
        ),
      ),
    );
  }

  Future<bool> onCompleted({required String verificationCode}) async {
    final packageInfo = await utils.packageInfo();
    final deviceInfo = await utils.deviceInfo();

    // Meta data info
    final messageMetaDataInfoRequest = Message(
      messageType: MessageType.META_DATA_INFO,
    );

    late Message metaDataResponse;
    final metaDataGrpcError = await api.call(() async {
      metaDataResponse = await api.client.unary(messageMetaDataInfoRequest);
    });

    if (metaDataGrpcError.status == APIStatus.error) {
      emit(
        state.copyWith(status: Status.success, error: metaDataGrpcError.error),
      );
      return true;
    }

    final metaData = MetadataInfo_Response.fromBuffer(metaDataResponse.message);

    final (publicKeySharedKey, privateKeySharedKey) = kem.generateKeyPair();
    final (publicKeySalt, privateKeySalt) = kem.generateKeyPair();

    //
    final messageAuthModerationApplicationStoreConfirmationRequest = Message(
      messageType: MessageType.AUTH_MODERATION_APPLICATION_STORE_CONFIRMATION,
      message: AuthModerationApplicationStoreConfirmation_Request(
        verificationCode: verificationCode.toString(),
        moderationApplicationStoreSession:
            state.moderationApplicationStoreSession,
      ).writeToBuffer(),
    );

    late Message messageAuthModerationApplicationStoreConfirmationResponse;
    final authModerationApplicationStoreConfirmationGrpcError = await api.call(
      () async {
        messageAuthModerationApplicationStoreConfirmationResponse = await api
            .client
            .unary(messageAuthModerationApplicationStoreConfirmationRequest);
      },
    );

    if (authModerationApplicationStoreConfirmationGrpcError.status ==
            APIStatus.error &&
        authModerationApplicationStoreConfirmationGrpcError.statusCode ==
            StatusCode.invalidArgument) {
      emit(
        state.copyWith(
          status: Status.success,
          error: authModerationApplicationStoreConfirmationGrpcError.error,
          redirectURI: Uri.parse("/auth"),
        ),
      );
      return true;
    } else if (authModerationApplicationStoreConfirmationGrpcError.status ==
        APIStatus.error) {
      emit(
        state.copyWith(
          status: Status.success,
          error: authModerationApplicationStoreConfirmationGrpcError.error,
        ),
      );
      return true;
    }

    //
    final authModerationApplicationStoreConfirmationResponse =
        AuthModerationApplicationStoreConfirmation_Response.fromBuffer(
          messageAuthModerationApplicationStoreConfirmationResponse.message,
        );

    final messageAuthConfirmationRequest = Message(
      messageType: MessageType.AUTH_CONFIRMATION,
      message: AuthConfirmation_Request(
        confirmationSession: authModerationApplicationStoreConfirmationResponse
            .confirmationSession,
        publicKeySharedKey: publicKeySharedKey,
        publicKeySalt: publicKeySalt,
        deviceModel: deviceInfo.deviceModel,
        os: deviceInfo.osCode,
        osVersion: deviceInfo.osVersion,
        appVersion: packageInfo.appVersion,
        appBuildNumber: packageInfo.appBuildNumber,
      ).writeToBuffer(),
    );

    late Message messageAuthConfirmationResponse;
    final authConfirmationGrpcError = await api.call(() async {
      messageAuthConfirmationResponse = await api.client.unary(
        messageAuthConfirmationRequest,
      );
    });

    if (authConfirmationGrpcError.status == APIStatus.error &&
        authConfirmationGrpcError.statusCode == StatusCode.invalidArgument) {
      emit(
        state.copyWith(
          status: Status.success,
          error: authConfirmationGrpcError.error,
          redirectURI: Uri.parse("/auth"),
        ),
      );
      return true;
    } else if (authConfirmationGrpcError.status == APIStatus.error) {
      emit(
        state.copyWith(
          status: Status.success,
          error: authConfirmationGrpcError.error,
        ),
      );
      return true;
    }

    final authConfirmationResponse = AuthConfirmation_Response.fromBuffer(
      messageAuthConfirmationResponse.message,
    );

    // Exchange
    final serverPublicKey = SimplePublicKey(
      metaData.eddsa.publicKey,
      type: KeyPairType.ed25519,
    );

    // Ed25519 signatures must be exactly 64 bytes; an empty/short signature
    // (e.g. missing in the server response) would otherwise make verify() throw
    // instead of returning false, crashing the flow before the check below.
    if (authConfirmationResponse.signatureSharedKey.length != 64 ||
        authConfirmationResponse.signatureSalt.length != 64) {
      logger.error('mlkem ciphertext signature has invalid length');
      emit(
        state.copyWith(
          status: Status.success,
          error: 'signature verification failed',
        ),
      );
      return true;
    }

    final checkSharedKey = await ed25519.verify(
      authConfirmationResponse.ciphertextSharedKey,
      signature: Signature(
        authConfirmationResponse.signatureSharedKey,
        publicKey: serverPublicKey,
      ),
    );

    final checkSalt = await ed25519.verify(
      authConfirmationResponse.ciphertextSalt,
      signature: Signature(
        authConfirmationResponse.signatureSalt,
        publicKey: serverPublicKey,
      ),
    );

    if (!checkSharedKey || !checkSalt) {
      logger.error('mlkem ciphertext signature verification failed');
      emit(
        state.copyWith(
          status: Status.success,
          error: 'signature verification failed',
        ),
      );
      return true;
    }

    final sharedKey = kem.decapsulate(
      privateKeySharedKey,
      Uint8List.fromList(authConfirmationResponse.ciphertextSharedKey),
    );
    final sharedSalt = kem.decapsulate(
      privateKeySalt,
      Uint8List.fromList(authConfirmationResponse.ciphertextSalt),
    );

    // Create or update user
    await repositories.users.createOrUpdate(
      userID: authConfirmationResponse.userID,
      phoneNumber: authConfirmationResponse.phoneNumber,
    );

    await repositories.sessions.deleteAndCreate(
      session: authConfirmationResponse.session,
      sessionID: authConfirmationResponse.sessionID,
      userID: authConfirmationResponse.userID,
      sharedKey: sharedKey,
      sharedSalt: sharedSalt,
      createAt: DateTime.now(),
    );

    await getIt.get<Auth>().refresh();

    emit(state.copyWith(status: Status.success));
    return false;
  }
}
