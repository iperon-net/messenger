import 'package:dart_mappable/dart_mappable.dart';

import '../../models.dart';

part 'settings_appearance_state.mapper.dart';

@MappableClass()
class SettingsAppearanceState with SettingsAppearanceStateMappable {
  final SettingsDeviceColorTheme colorTheme;
  final SettingsDeviceDarkMode darkMode;

  const SettingsAppearanceState({
    this.colorTheme = SettingsDeviceColorTheme.blue,
    this.darkMode = SettingsDeviceDarkMode.system,
  });
}
