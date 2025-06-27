import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../secure_storage.dart';

part 'language_cubit.freezed.dart';
part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState());

  final _secureStorage = getIt.get<SecureStorage>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    emit(state.copyWith(status: Status.success, currentLanguage: LocaleSettings.currentLocale));
  }

  /// Changes the application language and persists the selection in secure storage.
  ///
  /// This method takes a [BuildContext] and a required [AppLocale] parameter to set the application's
  /// locale. The selected language is stored in secure storage for persistence. The method also
  /// updates the state with the new language name and a success status.
  ///
  /// - [context]: The current build context.
  /// - [language]: The target locale to switch to (e.g., AppLocale.ru for Russian).
  ///
  /// Emits a loading status while the change is in progress and a success status after the process is complete.
  Future<void> changeLanguage(BuildContext context, {required AppLocale language}) async {
    emit(state.copyWith(status: Status.loading, currentLanguage: language));
    if (language == AppLocale.ru){
      _secureStorage.write(key: "language", value: "ru");
    } else {
      _secureStorage.write(key: "language", value: "en");
    }
    await Future.delayed(Duration(seconds: 5));

    LocaleSettings.setLocale(language);
    emit(state.copyWith(status: Status.success, currentLanguage: language));
  }

}
