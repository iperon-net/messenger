import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../repositories/repositories.dart';
import 'settings_language_state.dart';

class SettingsLanguageCubit extends Cubit<SettingsLanguageState> {
  SettingsLanguageCubit() : super(const SettingsLanguageState());

  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();

  Future<void> setLocale({required AppLocale locale}) async {
    LocaleSettings.setLocale(locale);
    await repositories.settingsDevice.setLocale(locale: locale);
    emit(state.copyWith(locale: locale));
  }

}
