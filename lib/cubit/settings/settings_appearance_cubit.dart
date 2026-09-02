import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../repositories.dart';

import '../../models/constants.dart';
import '../../themes.dart';
import 'settings_appearance_state.dart';

class SettingsAppearanceCubit extends Cubit<SettingsAppearanceState> {
  SettingsAppearanceCubit() : super(SettingsAppearanceState());

  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();

  Future<void> initialization({
    required ColorThemeModel colorTheme,
    required DarkModeModel darkMode,
    required bool isBlurOnInactive,
    required double fontScale,
  }) async {
    emit(state.copyWith(status: Status.loading));
    emit(
      state.copyWith(
        status: Status.success,
        colorTheme: colorTheme,
        darkMode: darkMode,
        isBlurOnInactive: isBlurOnInactive,
        fontScale: fontScale,
      ),
    );
  }

  Future<void> setColorTheme({required ColorThemeModel colorTheme}) async {
    emit(state.copyWith(status: Status.loading));
    await repositories.settingsDevice.setColorTheme(colorTheme);
    emit(state.copyWith(status: Status.success, colorTheme: colorTheme));
  }

  Future<void> setDarkMode({required DarkModeModel darkMode}) async {
    emit(state.copyWith(status: Status.loading));
    await repositories.settingsDevice.setDarkMode(darkMode);
    emit(state.copyWith(status: Status.success, darkMode: darkMode));
  }

  Future<void> setIsBlurOnInactive({required bool isBlurOnInactive}) async {
    emit(state.copyWith(status: Status.loading));
    await repositories.settingsDevice.setIsBlurOnInactive(isBlurOnInactive);
    emit(state.copyWith(status: Status.success, isBlurOnInactive: isBlurOnInactive));
  }

  Future<void> setFontScale({required double fontScale}) async {
    final clamped = AppFontSizes.clampFontScale(fontScale);
    await repositories.settingsDevice.setFontScale(clamped);
    emit(state.copyWith(status: Status.success, fontScale: clamped));
  }
}
