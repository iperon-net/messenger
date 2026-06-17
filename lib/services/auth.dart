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
  // final _crypto = getIt.get<Crypto>();
  final _utils = getIt.get<Utils>();
  final _repositories = getIt.get<Repositories>();

  final ed25519 = Ed25519();

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
    // final algorithmSHA256 = Sha256();
    // final hashECDH = await algorithmSHA256.hash(metadataInfoResponse.ecdh.publicKey);
    // if (Settings.publicKeyECDHFingerprint != _utils.toHex(hashECDH.bytes)) {
    //   return ServiceResponse<bool>(data: false, error: "signatureVerificationError");
    // }
    //
    // final (sharedSecretKey, clientPublicKey) = await _crypto.sharedSecretKey(serverPublicKey: metadataInfoResponse.ecdh.publicKey);

    final packageInfo = await _utils.packageInfo();
    final deviceInfo = await _utils.deviceInfo();

    var os = 0;
    if (deviceInfo.os == Os.iOS) {
      os = 1;
    } else if (deviceInfo.os == Os.android) {
      os = 2;
    }

    final kem = PqcKem.kyber768;

    final (publicKeyMLKem768, cipherTextSharedKey) = kem.generateKeyPair();
    final (publicKeySaltMLKem768, cipherTextSalt) = kem.generateKeyPair();

    late AuthConfirmationResponse authConfirmationResponse;
    final authConfirmationResponseError = await _api.call(() async {
      final req = AuthConfirmationRequest(
        confirmationSession: confirmationSession,
        cipherTextSharedKey: publicKeyMLKem768,
        cipherTextSalt: publicKeySaltMLKem768,
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

    final sharedKey = kem.decapsulate(cipherTextSharedKey, Uint8List.fromList(authConfirmationResponse.cipherTextSharedKey));
    final salt = kem.decapsulate(cipherTextSalt,  Uint8List.fromList(authConfirmationResponse.cipherTextSalt));

    final checkSharedKey = await ed25519.verify(
      authConfirmationResponse.cipherTextSharedKey,
      signature: Signature(
        authConfirmationResponse.signatureSharedKey,
        publicKey: SimplePublicKey(metadataInfoResponse.eddsa.publicKey, type: KeyPairType.ed25519),
      ),
    );

    final checkSharedSalt = await ed25519.verify(
      authConfirmationResponse.cipherTextSalt,
      signature: Signature(
        authConfirmationResponse.signatureSalt,
        publicKey: SimplePublicKey(metadataInfoResponse.eddsa.publicKey, type: KeyPairType.ed25519),
      ),
    );

    if (!checkSharedKey || !checkSharedSalt) {
      _logger.error("Signature verification error");
      return ServiceResponse<bool>(data: false, error: "signatureVerificationError");
    }

    // Create user or update
    await _repositories.users.createOrUpdate(userID: authConfirmationResponse.userID, phoneNumber: authConfirmationResponse.phoneNumber);

    await _repositories.sessions.deleteAndCreate(
      userID: authConfirmationResponse.userID,
      session: authConfirmationResponse.session,
      sharedKey: sharedKey,
      sharedSalt: salt,
    );

    _logger.info("ok!");
    return ServiceResponse<bool>(data: true);
  }

}
