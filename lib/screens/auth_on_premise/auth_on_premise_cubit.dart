import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';

part 'auth_on_premise_state.dart';
part 'auth_on_premise_cubit.freezed.dart';

class AuthOnPremiseCubit extends Cubit<AuthOnPremiseState> {
  AuthOnPremiseCubit() : super(AuthOnPremiseState());

  final formKey = GlobalKey<FormState>();
  final textControllerOrganizationServerUrl = TextEditingController();
  final textFocusNodeOrganizationServerUrl = FocusNode();

  final textControllerOrganizationServerUrlKey = GlobalKey();


  final _logger = getIt.get<Logger>();

  String? validatorOrganizationServerUrl(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return context.t.invalidOrganizationServerUrl;

    Uri uri;
    try {
      uri = Uri.parse(value);
    } on FormatException catch (_) {
      return context.t.invalidOrganizationServerUrl;
    } catch (err) {
      return context.t.invalidOrganizationServerUrl;
    }

    if (!uri.isAbsolute || uri.scheme != "https") {
      return context.t.invalidOrganizationServerUrl;
    }
    return null;
  }

  Future<void> validator(BuildContext context) async {
    emit(state.copyWith(errorFieldOrganizationServerUrl: ""));

    if (!formKey.currentState!.validate()) {
      return;
    }

    _logger.debug(textControllerOrganizationServerUrl.text);

    emit(state.copyWith(errorFieldOrganizationServerUrl: "Сервер не найден"));
  }

}
