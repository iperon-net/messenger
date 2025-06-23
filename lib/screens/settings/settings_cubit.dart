import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../cubit/constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../secure_storage.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());
  final logger = getIt.get<Logger>();
  final secureStorage = getIt.get<SecureStorage>();

  Future<void> loading() async {
    emit(state.copyWith(status: Status.loading));

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String languageName = "English";
    if (LocaleSettings.currentLocale == AppLocale.ru) languageName = "Русский";

    emit(state.copyWith(
      versionApplication: packageInfo.version.toString(),
      languageName: languageName,
      status: Status.success,
    ));
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
    emit(state.copyWith(status: Status.loading));

    await Future.delayed(Duration(seconds: 5));

    LocaleSettings.setLocale(language);

    String languageName = "English";
    secureStorage.write(key: "language", value: "en");

    if (language == AppLocale.ru){
      secureStorage.write(key: "language", value: "ru");
      languageName = "Русский";
    }

    emit(state.copyWith(status: Status.success, languageName: languageName));
  }

}
