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

  final logger = getIt.get<Logger>();
  final secureStorage = getIt.get<SecureStorage>();

  Widget trailingIcon(BuildContext context, {required AppLocale language}) {
    if (LocaleSettings.currentLocale == language) {
      return Icon(
        CupertinoIcons.check_mark_circled_solid,
        color: CupertinoTheme.of(context).primaryColor,
      );
    }
    return Container();
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

    if (language == AppLocale.ru){
      secureStorage.write(key: "language", value: "ru");
    } else {
      secureStorage.write(key: "language", value: "en");
    }

    LocaleSettings.setLocale(language);
    emit(state.copyWith(status: Status.success));
  }
}
