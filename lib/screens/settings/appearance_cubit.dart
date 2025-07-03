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

    final themeStorage = await _secureStorage.read(key: "theme");
    AppTheme theme = AppTheme.system;

    if (themeStorage == "light"){
      theme = AppTheme.light;
    } else if (themeStorage == "dark"){
      theme = AppTheme.dark;
    } else if (themeStorage == "system"){
      theme = AppTheme.system;
    }
    emit(state.copyWith(status: Status.success, theme: theme));
  }


  void changeThemeMode(AppTheme theme) async {
    emit(state.copyWith(theme: theme));
  }


}
