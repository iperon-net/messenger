import 'package:bloc/bloc.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:messenger/di.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../protobuf/protos/auth_v1.pb.dart';
import '../../utils.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  final phoneUtil = PhoneNumberUtil.instance;

  final _logger = getIt.get<Logger>();
  final _utils = getIt.get<Utils>();
  final _api = getIt.get<API>();

  Future<void> initialization() async {
    emit(AuthState());

    final packageInfo = await _utils.packageInfo();
    emit(state.copyWith(version: "v${packageInfo.appVersion}"));
  }

  // Validator phone number
  String? validatorPhoneNumber(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return context.t.enterYourMobilePhoneNumber;

    PhoneNumber phoneNumber;
    try {
      phoneNumber = phoneUtil.parse(value, "");
    } catch (err) {
      _logger.error(err);
      return context.t.enterYourMobilePhoneNumber;
    }

    final PhoneNumberType type = phoneUtil.getNumberType(phoneNumber);

    if (type != PhoneNumberType.mobile) {
      return context.t.currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators;
    }

    if (state.error.isNotEmpty) return state.error;
    return null;
  }

  // Validator
  Future<void> validator(BuildContext context, GlobalKey<FormState> formKey, TextEditingController phoneNumberController) async {
    emit(AuthState(status: Status.loading));

    if (!formKey.currentState!.validate()) {
      emit(state.copyWith(status: Status.success));
      return;
    }

    PhoneNumber phoneNumber;
    try {
      phoneNumber = phoneUtil.parse(phoneNumberController.text, "");
    } catch (err) {
      if (context.mounted) emit(state.copyWith(error: context.t.enterYourMobilePhoneNumber, status: Status.success));
      formKey.currentState!.validate();
      return;
    }

    late AuthCallPasswordResponse authCallPasswordResponse;

    final authCallPasswordResponseError = await _api.call(() async {
      final req = AuthCallPasswordRequest(phoneNumber: "${phoneNumber.countryCode}${phoneNumber.nationalNumber}");
      authCallPasswordResponse = await _api.auth.callPassword(req, options: await _api.callOptions());
    });

    if (context.mounted && authCallPasswordResponseError.isNotEmpty) {
      emit(state.copyWith(error: context.t[authCallPasswordResponseError] ?? context.t.unknownError, status: Status.success));
      formKey.currentState!.validate();
      return;
    }

    emit(state.copyWith(
      status: Status.success,
      callPasswordSession: authCallPasswordResponse.callPasswordSession,
      confirmationPhoneNumber: authCallPasswordResponse.confirmationPhoneNumber,
      timeout: authCallPasswordResponse.timeout,
    ));

    _logger.info("phone number raw ${phoneNumberController.text}");

    return;
  }

}
