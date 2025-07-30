import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:messenger/repositories/repositories.dart';

import '../../cubit/constants.dart';
import '../../di.dart';
import '../../models/models.dart' as models;

part 'appearance_cubit.freezed.dart';
part 'appearance_state.dart';

class AppearanceCubit extends Cubit<AppearanceState> {
  AppearanceCubit() : super(const AppearanceState());

  final _repositories = getIt.get<Repositories>();

  Future<void> initialization() async {
    final getAllSettings = await _repositories.settingsDevice.getAllSettings();

    emit(state.copyWith(
      status: Status.success,
      themeColor: getAllSettings.themeColor,
      selectedThemeColor: getAllSettings.themeColor,
      darkMode: getAllSettings.darkMode,
      selectedDarkMode: getAllSettings.darkMode,
    ));
  }

  Future<void> changeDarkMode(models.SettingsDeviceDarkMode darkMode) async {
    emit(state.copyWith(status: Status.loading, selectedDarkMode: darkMode, action: "darkMode"));
    await _repositories.settingsDevice.setDarkMode(darkMode);
    emit(state.copyWith(status: Status.success, darkMode: darkMode));
  }

  Future<void> changeThemeColor(models.SettingsDeviceThemeColor themeColor) async {
    emit(state.copyWith(status: Status.loading, selectedThemeColor: themeColor, action: "themeColor"));
    await _repositories.settingsDevice.setThemeColor(themeColor);
    emit(state.copyWith(status: Status.success, themeColor: themeColor));
  }

}
