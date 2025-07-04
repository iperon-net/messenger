import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';
import '../di.dart';
import '../logger.dart';
import '../secure_storage.dart';

part 'app_cubit.freezed.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  final _secureStorage = getIt.get<SecureStorage>();
  final _logger = getIt.get<Logger>();

  Future<void> changeDarkMode(DarkMode darkMode) async {
    emit(state.copyWith(status: Status.success, darkMode: darkMode));
  }

  Future<void> changeThemeColor(ThemeColor themeColor) async {
    emit(state.copyWith(status: Status.success, themeColor: themeColor));
  }
}
