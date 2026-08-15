import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models/constants.dart';

part 'settings_appearance_state.mapper.dart';

@MappableClass()
class SettingsAppearanceState with SettingsAppearanceStateMappable {
  final Status status;
  final ColorThemeModel colorTheme;
  final DarkModeModel darkMode;
  final bool isBlurOnInactive;

  const SettingsAppearanceState({
    this.status = Status.initialization,
    this.colorTheme = ColorThemeModel.blue,
    this.darkMode = DarkModeModel.system,
    this.isBlurOnInactive = false,
  });
}
