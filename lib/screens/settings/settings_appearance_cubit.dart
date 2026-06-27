import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di.dart';
import '../../models.dart';
import '../../repositories/repositories.dart';
import 'settings_appearance_state.dart';

class SettingsAppearanceCubit extends Cubit<SettingsAppearanceState> {
  SettingsAppearanceCubit() : super(const SettingsAppearanceState());

  final repositories = getIt.get<Repositories>();

  Future<void> setColorTheme({required SettingsDeviceColorTheme colorTheme}) async {
    await repositories.settingsDevice.setColorTheme(colorTheme);
    emit(state.copyWith(colorTheme: colorTheme));
  }

  Future<void> setDarkMode({required SettingsDeviceDarkMode darkMode}) async {
    await repositories.settingsDevice.setDarkMode(darkMode);
    emit(state.copyWith(darkMode: darkMode));
  }

}
