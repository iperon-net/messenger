import 'package:bloc/bloc.dart';

import '../i18n/translations.g.dart';
import '../models/models.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState(
    settingsDevice: SettingsDevice(),
    user: User(),
    session: Session(),
  ));

  Future<void> initialization({
    required SettingsDevice settingsDevice,
    required User user,
    required Session session,
  }) async {
    emit(state.copyWith(settingsDevice: settingsDevice, user: user, session: session));
  }

  Future<void> setActive({required User user, required Session session}) async {
    emit(state.copyWith(user: user));
  }

  Future<void> setLocale({required AppLocale locale}) async {
    final settingsDevice = state.settingsDevice.copyWith(locale: locale);
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
