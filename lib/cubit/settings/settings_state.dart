import 'package:dart_mappable/dart_mappable.dart';
import 'package:messenger/i18n/translations.g.dart';

import '../../constants.dart';

part 'settings_state.mapper.dart';

@MappableClass()
class SettingsState with SettingsStateMappable {
  final Status status;
  final String error;
  final bool logout;
  final int deviceCount;
  final AppLocale locale;

  const SettingsState({
    this.status = Status.initialization,
    this.error = "",
    this.logout = false,
    this.deviceCount = 0,
    this.locale = AppLocale.en,
  });
}
