import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/main_cubit.dart';
import '../../di.dart';
import '../../models/models.dart';
import '../../repositories/repositories.dart';

part 'settings_appearance_state.dart';
part 'settings_appearance_cubit.freezed.dart';

class SettingsAppearanceCubit extends Cubit<SettingsAppearanceState> {
  SettingsAppearanceCubit() : super(const SettingsAppearanceState());

  final repositories = getIt.get<Repositories>();

  Future<void> setColorTheme(BuildContext context, {required SettingsDeviceColorTheme colorTheme}) async {
    context.read<MainCubit>().setColorTheme(colorTheme: colorTheme);
    await repositories.settingsDevice.setColorTheme(colorTheme);
  }

  Future<void> setDarkMode(BuildContext context, {required SettingsDeviceDarkMode darkMode}) async {
    context.read<MainCubit>().setDarkMode(darkMode: darkMode);
    await repositories.settingsDevice.setDarkMode(darkMode);
  }

}
