import 'package:bloc/bloc.dart';
import 'package:convert/convert.dart' as convertor;
import 'package:cryptography/cryptography.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:messenger/repositories/repositories.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../crypto.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf/protos/auth_v1.pb.dart';
import '../../protobuf/protos/metadata_v1.pb.dart';
import '../../settings.dart';
import '../../utils.dart';

part 'auth_confirmation_cubit.freezed.dart';
part 'auth_confirmation_state.dart';


class AuthConfirmationCubit extends Cubit<AuthConfirmationState> {
  AuthConfirmationCubit() : super(const AuthConfirmationState());

  final _logger = getIt.get<Logger>();
  final _api = getIt.get<API>();
  final _crypto = getIt.get<Crypto>();
  final _utils = getIt.get<Utils>();
  final _repositories = getIt.get<Repositories>();

  Future<void> initialization({required String confirmationSession}) async {
    emit(state.copyWith(error: ""));

    late MetadataInfoResponse metadataInfoResponse;

    final metadataInfoResponseError = await _api.call(() async {
      metadataInfoResponse = await _api.metadata.info(MetadataInfoRequest(), options: await _api.callOptions());
    });

    if (metadataInfoResponseError.isNotEmpty){
      emit(state.copyWith(error: metadataInfoResponseError));
      return;
    }

    // Check fingerprint public key
    final algorithmSHA256 = Sha256();
    final hash = await algorithmSHA256.hash(metadataInfoResponse.ecdh.publicKey);
    if (Settings.publicKeyECDHFingerprint != _utils.toHex(hash.bytes)) {
      _logger.error("invalid fingerprint");
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
        confirmationSession: convertor.hex.decode(confirmationSession),
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
      emit(state.copyWith(error: authConfirmationResponseError));
      return;
    }

    _logger.debug("${authConfirmationResponse.toProto3Json()}");

    final secretKeyData = await sharedSecretKey.extract();

    await _repositories.users.create(
      session: authConfirmationResponse.session,
      phoneNumber: authConfirmationResponse.phoneNumber,
      userID: authConfirmationResponse.userID,
      sharedKeyID: authConfirmationResponse.sharedKeyID,
      sharedSecretKey: secretKeyData.bytes,
    );

    emit(state.copyWith(status: Status.success));
  }

}
