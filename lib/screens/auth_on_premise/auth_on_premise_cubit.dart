import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../constants.dart';
import '../../i18n/translations.g.dart';

part 'auth_on_premise_state.dart';
part 'auth_on_premise_cubit.freezed.dart';

class AuthOnPremiseCubit extends Cubit<AuthOnPremiseState> {
  AuthOnPremiseCubit() : super(AuthOnPremiseState());

  final formKey = GlobalKey<FormState>();
  final textControllerOrganizationServerUrl = TextEditingController();
  final textControllerOrganizationServerUrlKey = GlobalKey();

  // final _logger = getIt.get<Logger>();

  String? validatorOrganizationServerUrl(BuildContext context, String? value) {
    emit(state.copyWith(errorFieldOrganizationServerUrl: ""));

    if (value == null || value.isEmpty) return context.t.invalidOrganizationServerUrl;

    Uri uri;
    try {
      uri = Uri.parse(value);
    } on FormatException catch (_) {
      return context.t.invalidOrganizationServerUrl;
    } catch (err) {
      return context.t.invalidOrganizationServerUrl;
    }

    if (!uri.isAbsolute || uri.scheme != "https") return context.t.invalidOrganizationServerUrl;

    return null;
  }

  Future<void> validator(BuildContext context) async {
    emit(state.copyWith(executeStatus: Status.loading));

    if (!formKey.currentState!.validate()) {
      emit(state.copyWith(errorFieldOrganizationServerUrl: "", executeStatus: Status.success));
      return;
    }

    await Future.delayed(const Duration(seconds: 2));
    // textControllerOrganizationServerUrl.clear();
    emit(state.copyWith(errorFieldOrganizationServerUrl: "Сервер не найден sfdfsdfsdfsdfsfdf dsadadasd", executeStatus: Status.success));
  }

  void switchDebugListServers() {
    if (state.debugListServers) {
      emit(state.copyWith(debugListServers: false));
    } else {
      emit(state.copyWith(debugListServers: true));
    }
  }

}
