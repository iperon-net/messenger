import 'package:dart_mappable/dart_mappable.dart';
import 'package:messenger/i18n/translations.g.dart';

import '../../constants.dart';
import '../../models.dart' as models;

part 'settings_state.mapper.dart';

@MappableClass()
class SettingsState with SettingsStateMappable {
  final Status status;
  final String error;
  final bool logout;
  final int deviceSessionsCount;
  final List<models.DeviceSession> deviceSessions;
  final AppLocale locale;
  final bool isCurrent;

  const SettingsState({
    this.status = Status.initialization,
    this.error = "",
    this.logout = false,
    this.deviceSessionsCount = 0,
    this.deviceSessions = const [],
    this.locale = AppLocale.en,
    this.isCurrent = false,
  });
}
