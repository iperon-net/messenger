import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';
import '../models/models.dart' as models;

part 'app_cubit.freezed.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  Future<void> changeDarkMode(models.SettingsDeviceDarkMode value) async {
    emit(state.copyWith(status: Status.success, darkMode: value));
  }

  Future<void> changeThemeColor(models.SettingsDeviceThemeColor value) async {
    emit(state.copyWith(status: Status.success, themeColor: value));
  }
}
