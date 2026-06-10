import 'package:dart_mappable/dart_mappable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '../models.dart';

part 'main_state.mapper.dart';

@MappableClass()
class MainState with MainStateMappable {
  final Status status;
  final SettingsDevice settingsDevice;
  final User user;
  final Session session;
  final PermissionStatus permissionStatusContacts;
  final PermissionStatus permissionStatusNotification;

  const MainState({
    this.status = Status.initialization,
    this.permissionStatusContacts = PermissionStatus.denied,
    this.permissionStatusNotification = PermissionStatus.denied,
    required this.settingsDevice,
    required this.user,
    required this.session,
  });
}
