import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/app_cubit.dart';
import '../../cubit/constants.dart';
import '../../di.dart';
import '../../secure_storage.dart';

part 'appearance_cubit.freezed.dart';
part 'appearance_state.dart';

class AppearanceCubit extends Cubit<AppearanceState> {
  AppearanceCubit() : super(const AppearanceState());

  final _secureStorage = getIt.get<SecureStorage>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    final darkModeStorage = await _secureStorage.read(key: "darkMode");

    DarkMode darkMode = DarkMode.system;

    if (darkModeStorage == "disabled"){
      darkMode = DarkMode.disabled;
    } else if (darkModeStorage == "alwaysOn"){
      darkMode = DarkMode.alwaysOn;
    }
    emit(state.copyWith(status: Status.success, darkMode: darkMode));
  }

  Future<void> changeDarkMode(DarkMode darkMode) async {
    emit(state.copyWith(status: Status.loading));
    await _secureStorage.write(key: "darkMode", value: darkMode.name);
    emit(state.copyWith(status: Status.success, darkMode: darkMode));
  }

}
