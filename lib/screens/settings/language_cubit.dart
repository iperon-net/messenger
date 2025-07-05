import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../secure_storage.dart';

part 'language_cubit.freezed.dart';
part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState());

  final _secureStorage = getIt.get<SecureStorage>();
  final _logger = getIt.get<Logger>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    emit(state.copyWith(status: Status.success, currentLanguage: LocaleSettings.currentLocale, selectedLanguage: LocaleSettings.currentLocale));
  }

  Future<void> changeLanguage(BuildContext context, {required AppLocale language}) async {
    emit(state.copyWith(status: Status.loading, selectedLanguage: language));

    await _secureStorage.setLanguage(value: language);
    LocaleSettings.setLocale(language);

    _logger.info("Language changed ${language.languageCode}");
    await Future.delayed(Duration(seconds: 5));
    emit(state.copyWith(status: Status.success, currentLanguage: language, selectedLanguage: language));
  }

}
