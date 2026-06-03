import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
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

    final resultPermissions = await Future.wait([
      Permission.contacts.status,
      Permission.notification.status
    ]);

    emit(state.copyWith(
      status: Status.success,
      settingsDevice: settingsDevice,
      user: user,
      session: session,
      permissionStatusContacts: resultPermissions[0],
      permissionStatusNotification: resultPermissions[1],
    ));

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
