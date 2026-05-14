import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/protobuf/protos/auth_v1.pb.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../cubit/main_cubit.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../repositories/repositories.dart';
import '../../services/services.dart';

part 'auth_sms_state.dart';
part 'auth_sms_cubit.freezed.dart';

class AuthSmsCubit extends Cubit<AuthSmsState> {
  AuthSmsCubit() : super(const AuthSmsState());

  final _logger = getIt.get<Logger>();
  final _api = getIt.get<API>();
  final _services = getIt.get<Services>();
  final _repositories = getIt.get<Repositories>();

  Future<bool> smsCheck(BuildContext context, {required List<int> smsSession , required String verificationCode}) async {
    _logger.debug(verificationCode);

     late AuthSMSCheckResponse authSMSCheckResponse;

    final authSMSCheckResponseError = await _api.call(() async {
      final req = AuthSMSCheckRequest(smsSession: smsSession, verificationCode: verificationCode);
      authSMSCheckResponse = await _api.auth.sMSCheck(req, options: await _api.callOptions());
    });

    if (context.mounted && authSMSCheckResponseError.isNotEmpty) {
      _logger.error(authSMSCheckResponseError);
      return false;
    }

    final serviceResponseConfirmation = await _services.auth.confirmation(confirmationSession: authSMSCheckResponse.confirmationSession);

    _logger.debug(serviceResponseConfirmation.error.isNotEmpty);

    if (serviceResponseConfirmation.error.isNotEmpty) {
      return false;
    }

    final user = await _repositories.users.getActive();
    _logger.debug(user);

    if (context.mounted){
      context.read<MainCubit>().setUser(user: user);
      context.go("/");
    }

    return true;
  }

}
