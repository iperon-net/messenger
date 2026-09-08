import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../i18n/translations.g.dart';

part 'settings_my_profile_username_state.mapper.dart';

@MappableClass()
class SettingsMyProfileUsernameState with SettingsMyProfileUsernameStateMappable {
  final Status status;
  final Status networkStatus;
  final String error;
  final String redirectURI;

  final String username;

  final AppLocale locale;

  const SettingsMyProfileUsernameState({
    this.status = Status.initialization,
    this.networkStatus = Status.initialization,
    this.error = "",
    this.redirectURI = "",

    this.username = "",

    this.locale = AppLocale.en,
  });
}
