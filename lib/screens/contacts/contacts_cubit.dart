import 'package:bloc/bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messenger/constants.dart';
import 'package:messenger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../di.dart';
import 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(const ContactsState());

  final _logger = getIt.get<Logger>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.success, permissionStatus: await Permission.contacts.status));
    _logger.debug("contacts initialization");
    await request();
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }

  Future<void> request() async {
    final requestResult =  await Permission.contacts.request();
    if (requestResult.isGranted || requestResult.isLimited) {
      final contacts = await FlutterContacts.getAll(properties: {ContactProperty.phone, ContactProperty.name});
      _logger.debug(contacts);
    }
  }

}
