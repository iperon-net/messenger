import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/app_cubit.dart';
import '../../cubit/constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../secure_storage.dart';

part 'appearance_cubit.freezed.dart';
part 'appearance_state.dart';

class AppearanceCubit extends Cubit<AppearanceState> {
  AppearanceCubit() : super(const AppearanceState());

  final _secureStorage = getIt.get<SecureStorage>();
  final _logger = getIt.get<Logger>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    final darkModeStorage = await _secureStorage.read(key: "darkMode");
    final themeColorStorage = await _secureStorage.read(key: "themeColor");

    DarkMode darkMode = DarkMode.system;

    if (darkModeStorage.isNotEmpty && darkModeStorage == "disabled"){
      darkMode = DarkMode.disabled;
    } else if (darkModeStorage.isNotEmpty && darkModeStorage == "alwaysOn"){
      darkMode = DarkMode.alwaysOn;
    }

    ThemeColor themeColor = ThemeColor.blue;
    if (themeColorStorage.isNotEmpty && themeColorStorage == "blue"){
      themeColor = ThemeColor.blue;
    } else if (themeColorStorage.isNotEmpty && themeColorStorage == "green"){
      themeColor = ThemeColor.green;
    } else if (themeColorStorage.isNotEmpty && themeColorStorage == "purple"){
      themeColor = ThemeColor.purple;
    }
    emit(state.copyWith(status: Status.success, darkMode: darkMode, themeColor: themeColor));
  }

  Future<void> changeDarkMode(DarkMode darkMode) async {
    emit(state.copyWith(status: Status.loading, selectedDarkMode: darkMode, action: "darkMode"));
    await _secureStorage.setDarkMode(value: darkMode);
    await Future.delayed(Duration(seconds: 1));
    emit(state.copyWith(status: Status.success, darkMode: darkMode));
  }

  Future<void> changeThemeColor(ThemeColor themeColor) async {
    emit(state.copyWith(status: Status.loading, selectedThemeColor: themeColor, action: "themeColor"));
    await _secureStorage.setThemeColor(value: themeColor);
    await Future.delayed(Duration(seconds: 1));
    emit(state.copyWith(status: Status.success, themeColor: themeColor));
  }

}
