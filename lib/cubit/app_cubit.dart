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

  Future<void> changeThemeMode(AppTheme theme) async {
    emit(state.copyWith(theme: theme));
    await _secureStorage.write(key: "theme", value: theme.name);
    _logger.info("The theme has been changed \"${theme.name}\"");
  }

  Future<void> loadThemeMode() async {
    final theme = await _secureStorage.read(key: "theme");
    if (theme == "system"){
      emit(state.copyWith(theme: AppTheme.system));
    } else if (theme == "light"){
      emit(state.copyWith(theme: AppTheme.light));
    } else if (theme == "dark"){
      emit(state.copyWith(theme: AppTheme.dark));
    }
  }

}
