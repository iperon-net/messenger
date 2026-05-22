import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_language_state.mapper.dart';

@MappableClass()
class SettingsLanguageState with SettingsLanguageStateMappable {
  final Status status;
  final String error;

  const SettingsLanguageState({
    this.status = Status.initialization,
    this.error = "",
  });
}
