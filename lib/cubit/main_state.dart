import 'package:dart_mappable/dart_mappable.dart';

import '../constants.dart';
import '../models/models.dart';

part 'main_state.mapper.dart';

@MappableClass()
class MainState with MainStateMappable {
  final Status status;
  final SettingsDevice settingsDevice;
  final User user;
  final Session session;

  const MainState({
    this.status = Status.initialization,
    required this.settingsDevice,
    required this.user,
    required this.session,
  });
}
