part of 'services.dart';

class ServiceResponse<T> {
  final T data;
  final String error;
  ServiceResponse({required this.data, this.error = ""});

  @override
  String toString() {
    return "APIResponse<$T>(${data.toString()})";
  }

}

class Auth {
  final Logger logger;
  final phoneUtil = PhoneNumberUtil.instance;

  Auth({required this.logger});

  final _logger = getIt.get<Logger>();
  final _api = getIt.get<API>();
  final _crypto = getIt.get<Crypto>();
  final _utils = getIt.get<Utils>();
  final _repositories = getIt.get<Repositories>();

  Future<ServiceResponse<bool>> confirmation({required List<int> confirmationSession}) async {

    late MetadataInfoResponse metadataInfoResponse;

    final metadataInfoResponseError = await _api.call(() async {
      metadataInfoResponse = await _api.metadata.info(MetadataInfoRequest(), options: await _api.callOptions());
    });

    if (metadataInfoResponseError.isNotEmpty){
      _logger.error(metadataInfoResponseError);
      return ServiceResponse<bool>(data: false, error: metadataInfoResponseError);
    }

    // Check fingerprint public key
    final algorithmSHA256 = Sha256();
    final hash = await algorithmSHA256.hash(metadataInfoResponse.ecdh.publicKey);
    if (Settings.publicKeyECDHFingerprint != _utils.toHex(hash.bytes)) {
      return ServiceResponse<bool>(data: false, error: "signatureVerificationError");
    }

    final (sharedSecretKey, clientPublicKey) = await _crypto.sharedSecretKey(serverPublicKey: metadataInfoResponse.ecdh.publicKey);

    final packageInfo = await _utils.packageInfo();
    final deviceInfo = await _utils.deviceInfo();

    var os = 0;
    if (deviceInfo.os == Os.iOS) {
      os = 1;
    } else if (deviceInfo.os == Os.android) {
      os = 2;
    }

    late AuthConfirmationResponse authConfirmationResponse;
    final authConfirmationResponseError = await _api.call(() async {
      final req = AuthConfirmationRequest(
        confirmationSession: confirmationSession,
        clientPublicKeyECDH: clientPublicKey.bytes,
        deviceModel: deviceInfo.deviceModel,
        os: os,
        osVersion: deviceInfo.osVersion,
        appVersion: packageInfo.appVersion,
        appBuildNumber: packageInfo.appBuildNumber,
      );
      authConfirmationResponse = await _api.auth.confirmation(req, options: await _api.callOptions());
    });
    if (authConfirmationResponseError.isNotEmpty){
      _logger.error(authConfirmationResponseError);
      return ServiceResponse<bool>(data: false, error: authConfirmationResponseError);
    }

    final secretKeyData = await sharedSecretKey.extract();

    await _repositories.users.create(
      session: authConfirmationResponse.session,
      phoneNumber: authConfirmationResponse.phoneNumber,
      userID: authConfirmationResponse.userID,
      sharedKeyID: authConfirmationResponse.sharedKeyID,
      sharedSecretKey: secretKeyData.bytes,
    );

    return ServiceResponse<bool>(data: true);
  }

}
