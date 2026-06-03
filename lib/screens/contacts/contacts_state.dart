import 'package:dart_mappable/dart_mappable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';

part 'contacts_state.mapper.dart';

@MappableClass()
class ContactsState with ContactsStateMappable {
  final Status status;
  final PermissionStatus permissionStatus;

  const ContactsState({
    this.status = Status.initialization,
    this.permissionStatus = PermissionStatus.granted,
  });

}
