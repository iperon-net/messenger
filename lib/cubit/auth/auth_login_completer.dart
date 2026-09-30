import 'dart:typed_data';

import 'package:grpc/grpc.dart';
import 'package:pqcrypto/pqcrypto.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';
import '../../protobuf.dart';

/// Итог завершения входа: непустой [redirectURI] — куда перейти (`/chats` при
/// успехе, `/auth` при фатальной ошибке); непустой [error] — i18n-ключ ошибки для
/// показа. Пустая строка = «не задано» (совпадает с семантикой полей state).
typedef AuthLoginCompletionResult = ({String error, String redirectURI});

/// Общая финальная последовательность входа: META_DATA_INFO → AUTH_CONFIRMATION →
/// проверка подписей ML-DSA → расшифровка ключей ML-KEM → запись сессии в SQLite →
/// [Auth.refresh]. Вынесена из [AuthCallpasswordConfirmationCubit], чтобы её мог
/// переиспользовать шаг облачного пароля ([AuthCloudPasswordCubit]) после
/// успешной проверки пароля — обе точки завершают вход идентично.
///
/// Никогда не бросает: любые ошибки (в т.ч. сбой записи в SQLite) возвращаются как
/// [AuthLoginCompletionResult], т.к. вызывается в т.ч. из onData-колбэка стрима,
/// где необработанное исключение уронило бы приложение.
class AuthLoginCompleter {
  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();
  final repositories = getIt.get<Repositories>();

  final kem = PqcKem.kyber768;
  final mlDsa65 = DilithiumParams.mlDsa65;

  Future<AuthLoginCompletionResult> complete(List<int> confirmationSession) async {
    // Meta data info
    final messageMetaDataInfoRequest = Message(messageType: MessageType.META_DATA_INFO);

    late Message metaDataResponse;
    final metaDataGrpcError = await api.call(() async {
      metaDataResponse = await api.client.unary(messageMetaDataInfoRequest);
    }, retryTransient: true);

    if (metaDataGrpcError.status == APIStatus.error) {
      return (error: metaDataGrpcError.error, redirectURI: "");
    }

    final metaData = MetadataInfo_Response.fromBuffer(metaDataResponse.message);

    final (publicKeySharedKey, privateKeySharedKey) = kem.generateKeyPair();
    final (publicKeySalt, privateKeySalt) = kem.generateKeyPair();

    final packageInfo = await utils.packageInfo();
    final deviceInfo = await utils.deviceInfo();

    final messageAuthConfirmationRequest = Message(
      messageType: MessageType.AUTH_CONFIRMATION,
      message: AuthConfirmation_Request(
        confirmationSession: confirmationSession,
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
      messageAuthConfirmationResponse = await api.client.unary(messageAuthConfirmationRequest);
    });

    if (authConfirmationGrpcError.status == APIStatus.error && authConfirmationGrpcError.statusCode == StatusCode.invalidArgument) {
      return (error: authConfirmationGrpcError.error, redirectURI: Uri.parse("/auth").toString());
    } else if (authConfirmationGrpcError.status == APIStatus.error) {
      return (error: authConfirmationGrpcError.error, redirectURI: "");
    }

    final authConfirmationResponse = AuthConfirmation_Response.fromBuffer(messageAuthConfirmationResponse.message);

    // Exchange
    // ML-DSA-65 (FIPS 204) signatures over the ML-KEM ciphertexts, verified with
    // the server's ML-DSA public key from the metadata response. MlDsa.verify
    // never throws — it returns false for any malformed/short input.
    final serverPublicKey = Uint8List.fromList(metaData.mldsa.publicKey);

    final checkSharedKey = MlDsa.verify(
      serverPublicKey,
      Uint8List.fromList(authConfirmationResponse.ciphertextSharedKey),
      Uint8List.fromList(authConfirmationResponse.signatureSharedKey),
      mlDsa65,
    );

    final checkSalt = MlDsa.verify(
      serverPublicKey,
      Uint8List.fromList(authConfirmationResponse.ciphertextSalt),
      Uint8List.fromList(authConfirmationResponse.signatureSalt),
      mlDsa65,
    );

    if (!checkSharedKey || !checkSalt) {
      logger.error('mlkem ciphertext signature verification failed');
      return (error: 'screenAuthCallpasswordConfirmation.signatureVerificationFailed', redirectURI: "");
    }

    final sharedKey = kem.decapsulate(privateKeySharedKey, Uint8List.fromList(authConfirmationResponse.ciphertextSharedKey));
    final sharedSalt = kem.decapsulate(privateKeySalt, Uint8List.fromList(authConfirmationResponse.ciphertextSalt));

    // Персистентность сессии обёрнута в try/catch: вызывается в т.ч. из
    // onData-колбэка стрима, поэтому любое исключение (например, сбой записи в
    // SQLite) улетело бы необработанным в PlatformDispatcher.onError и уронило бы
    // приложение как fatal. Вместо этого возвращаем ошибку и уводим на /auth.
    try {
      // Create or update user
      await repositories.users.createOrUpdate(userID: authConfirmationResponse.userID, phoneNumber: authConfirmationResponse.phoneNumber);

      await repositories.sessions.deleteAndCreate(
        session: authConfirmationResponse.session,
        sessionID: authConfirmationResponse.sessionID,
        userID: authConfirmationResponse.userID,
        sharedKey: sharedKey,
        sharedSalt: sharedSalt,
        createAt: DateTime.now(),
      );

      await getIt.get<Auth>().refresh();
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, "login completer: persist session failed");
      return (error: "grpcError.internalServerError", redirectURI: Uri.parse("/auth").toString());
    }

    return (error: "", redirectURI: Uri.parse("/chats").toString());
  }
}
