import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';
import 'package:convert/convert.dart' as convertor;

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf/protos/auth_v1.pb.dart';
import '../../protobuf/protos/models.pbenum.dart' as grpc_models;


part 'auth_callpassword_state.dart';
part 'auth_callpassword_cubit.freezed.dart';

class AuthCallpasswordCubit extends Cubit<AuthCallpasswordState> {
  AuthCallpasswordCubit() : super(const AuthCallpasswordState());

  final _api = getIt.get<API>();
  final _logger = getIt.get<Logger>();

  late ResponseStream<AuthCallPasswordCheckResponse> streamCallPassword;
  late StreamSubscription<AuthCallPasswordCheckResponse> subscriptionCallPassword;

  Future<void> callPassword({
    required String callPasswordSession,
    required double timeout,
  }) async {
    _logger.info("callPasswordSession=$callPasswordSession");
    emit(state.copyWith(status: Status.loading, error: "", confirmationSession: []));

    streamCallPassword = _api.auth.callPasswordCheck(
      AuthCallPasswordCheckRequest(callPasswordSession: convertor.hex.decode(callPasswordSession)),
      options: await _api.callOptions(timeout: timeout),
    );

    subscriptionCallPassword = streamCallPassword.listen((onData) {
      if (onData.status == grpc_models.Status.success && onData.timer > 0) {
        emit(state.copyWith(status: Status.success, tickerSecond: onData.timer.toInt()));
      } else if (onData.status == grpc_models.Status.error) {
        if (onData.errorMessage.isNotEmpty) emit(state.copyWith(status: Status.success, error: onData.errorMessage));
      } else if (onData.status == grpc_models.Status.success) {
        emit(state.copyWith(
          status: Status.success,
          confirmationSession: onData.confirmationSession,
        ));

        // onData.hasCloudPassword;
        // onData.isBlocked;
      }

    }, onError: (error) async {
      error as GrpcError;

      _logger.error("${error.codeName}, ${error.message}");
      emit(state.copyWith(error: "internalServerError"));
    }, cancelOnError: true);

  }

  void setTickerSecond(int tickerSecond) {
    emit(state.copyWith(tickerSecond: tickerSecond));
  }

}
