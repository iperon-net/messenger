import 'package:bloc/bloc.dart';
import 'package:convert/convert.dart' as convertor;
import 'package:cryptography/cryptography.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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

const publicKeyDigestCheck = "0123041447180d6308df2c8ea6c1d1cce851a1e65dacf406776e296c63145d46";

class AuthConfirmationCubit extends Cubit<AuthConfirmationState> {
  AuthConfirmationCubit() : super(const AuthConfirmationState());

  final _logger = getIt.get<Logger>();
  final _api = getIt.get<API>();
  final _crypto = getIt.get<Crypto>();
  final _utils = getIt.get<Utils>();

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
    _logger.debug(sharedSecretKey);

    late AuthConfirmationResponse authConfirmationResponse;
    final authConfirmationResponseError = await _api.call(() async {
      final req = AuthConfirmationRequest(confirmationSession: convertor.hex.decode(confirmationSession), clientPublicKeyECDH: clientPublicKey.bytes);
      authConfirmationResponse = await _api.auth.confirmation(req, options: await _api.callOptions());
    });

    if (authConfirmationResponseError.isNotEmpty){
      emit(state.copyWith(error: authConfirmationResponseError));
      return;
    }

    // _logger.debug(authConfirmationResponse.phoneNumber);
    _logger.debug(authConfirmationResponse.session);
    _logger.debug(authConfirmationResponse.location.englishName);
    _logger.debug(authConfirmationResponse.location.russianName);
    _logger.debug(await sharedSecretKey.extractBytes());

    _logger.debug("initialization");

  }

}
