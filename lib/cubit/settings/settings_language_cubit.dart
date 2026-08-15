import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';

import '../../repositories.dart';
import 'settings_language_state.dart';

class SettingsLanguageCubit extends Cubit<SettingsLanguageState> {
  SettingsLanguageCubit() : super(SettingsLanguageState());

  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();

  Future<void> initialization({AppLocale? locale}) async {
    emit(state.copyWith(status: Status.loading));
    logger.debug(locale);
    emit(
      state.copyWith(status: Status.success, locale: locale ?? AppLocale.en),
    );
  }

  Future<void> setLocale({required AppLocale locale}) async {
    emit(state.copyWith(status: Status.loading));
    LocaleSettings.setLocale(locale);
    await repositories.settingsDevice.setLocale(locale: locale);
    emit(state.copyWith(status: Status.success, locale: locale));
  }
}
