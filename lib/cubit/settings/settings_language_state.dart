import 'package:dart_mappable/dart_mappable.dart';
import 'package:messenger/i18n/translations.g.dart';

import '../../constants.dart';

part 'settings_language_state.mapper.dart';

@MappableClass()
class SettingsLanguageState with SettingsLanguageStateMappable {
  final Status status;
  final AppLocale locale;

  const SettingsLanguageState({this.status = Status.initialization, this.locale = AppLocale.en});
}
