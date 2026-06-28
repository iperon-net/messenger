import 'package:bloc/bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messenger/constants.dart';
import 'package:messenger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../di.dart';
import '../../models.dart' as models;
import '../../utils.dart';
import 'contacts_state.dart';

// class СontactResult extends Contact {
//   Contact(String name) : super(name);
// }

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(const ContactsState());

  final _logger = getIt.get<Logger>();
  final _utils = getIt.get<Utils>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.success, permissionStatus: await Permission.contacts.status));
    _logger.debug("contacts initialization");
    await request();

    // late MetadataInfoResponse metadataInfoResponse;
    //
    // final metadataInfoResponseError = await _api.call(() async {
    //   metadataInfoResponse = await _api.metadata.info(MetadataInfoRequest(), options: await _api.callOptions());
    // });
    // if (metadataInfoResponseError.isNotEmpty){
    //   _logger.error(metadataInfoResponseError);
    //   return;
    // }
    //
    // _crypto.voprf.setServerPublicKey(metadataInfoResponse.voprf.publicKey);
    // final blindData = _crypto.voprf.blind(utf8.encode("hello word!"));
    // _logger.debug(blindData.blindedElement);

  }

  Future<void> openSettings() async {
    await openAppSettings();
  }

  Future<void> request() async {
    final requestResult =  await Permission.contacts.request();
    if (requestResult.isGranted || requestResult.isLimited) {
      await parse();
    }
  }

  Future<void> parse() async {
    final contacts = await FlutterContacts.getAll(properties: {ContactProperty.phone, ContactProperty.name});

    final result = <models.Contact>[];
    for (final contact in contacts) {
      final phoneNumbers = <models.ContactPhoneNumber>[];

      for (var phone in contact.phones) {
        final phoneNumber = _utils.phoneNormalization(phoneNumber: phone.number.replaceAll(RegExp(r'\D'), ''));
        if (phoneNumber.e164.isEmpty) continue;

        phoneNumbers.add(models.ContactPhoneNumber(
          international: phoneNumber.international,
          national: phoneNumber.national,
          e164: phoneNumber.e164,
          rfc3966: phoneNumber.rfc3966,
        ));
      }

      if (phoneNumbers.isEmpty) continue;
      if (contact.id == null) continue;

      result.add(models.Contact(
        contactID: contact.id ?? "",
        phoneNumbers: phoneNumbers,
        firstName: contact.name?.first ?? "",
        lastName: contact.name?.last ?? "",
      ));

    }

    for (final item in result) {
      _logger.debug(item);
    }

  }



}
