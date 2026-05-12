import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants.dart';
import '../di.dart';
import '../i18n/translations.g.dart';
import '../logger.dart';
import '../models/models.dart';

part 'main_state.dart';
part 'main_cubit.freezed.dart';

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

}
