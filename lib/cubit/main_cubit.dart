import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants.dart';
import '../i18n/translations.g.dart';
import '../models/models.dart';

part 'main_cubit.freezed.dart';
part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState(
    settingsDevice: SettingsDevice(),
    user: User(),
  ));

  Future<void> initialization({
    required SettingsDevice settingsDevice,
    required User user,
  }) async {
    emit(state.copyWith(settingsDevice: settingsDevice, user: user));
  }

  Future<void> setUser({required User user}) async {
    emit(state.copyWith(user: user));
  }

  Future<void> setLocate({required AppLocale locate}) async {
    final settingsDevice = state.settingsDevice.copyWith(locate: locate);
    emit(state.copyWith(settingsDevice: settingsDevice));
  }

  Future<void> setColorTheme({required SettingsDeviceColorTheme colorTheme}) async {
    final settingsDevice = state.settingsDevice.copyWith(colorTheme: colorTheme);
    emit(state.copyWith(settingsDevice: settingsDevice));
  }

  Future<void> setDarkMode({required SettingsDeviceDarkMode darkMode}) async {
    final settingsDevice = state.settingsDevice.copyWith(darkMode: darkMode);
    emit(state.copyWith(settingsDevice: settingsDevice));
  }

  Future<void> logout() async {
    emit(state.copyWith(user: User()));
  }

}
