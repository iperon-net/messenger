import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/repositories/repositories.dart';

import '../../cubit/constants.dart';
import '../di.dart';
import '../models/models.dart' as models;

part 'app_cubit.freezed.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());
  final _repositories = getIt.get<Repositories>();
  final _logger = getIt.get<Logger>();

  Future<void> initialization() async {
    final getAllSettings = await _repositories.settingsDevice.getAllSettings();
    _logger.debug("getAllSettings = $getAllSettings");

    emit(state.copyWith(
      passCode: getAllSettings.passCode,
      passCodeTtl: getAllSettings.passCodeTtl,
      passCodeTimer: getAllSettings.passCodeTimer,
      viewTaskSwitchingEnable: 1,
    ));
  }

  Future<void> setPassCodeTtl(int value) async {
    await _repositories.settingsDevice.setPassCodeTtl(value);
    emit(state.copyWith(passCodeTtl: value));
  }

  Future<void> setPassCode(String value) async {
    await _repositories.settingsDevice.setPassCode(value);
    emit(state.copyWith(passCode: value));
  }

  Future<void> setPassCodeTimer(int value) async {
    await _repositories.settingsDevice.setPassCodeTimer(value);
    emit(state.copyWith(passCodeTimer: value));
  }

  Future<void> changeDarkMode(models.SettingsDeviceDarkMode value) async {
    emit(state.copyWith(status: Status.success, darkMode: value));
  }

  Future<void> changeThemeColor(models.SettingsDeviceThemeColor value) async {
    emit(state.copyWith(status: Status.success, themeColor: value));
  }

  Future<void> viewTaskSwitching(bool value) async {
    emit(state.copyWith(viewTaskSwitching: value));
  }


}
