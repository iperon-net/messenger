import 'dart:typed_data';

import 'di.dart';
import 'protobuf.dart';
import 'repositories.dart';
import 'utils.dart';

/// Имя человека по общему правилу ([Utils.composeNameLines]: как я его записал
/// → имя из профиля → @username → номер) из локальных кэшей — контактов
/// (облачный главнее книжного) и профилей. Без сети, мгновенно.
///
/// [fresh] — только что пришедший `PROFILE` (его могли ещё не записать в
/// `profiles`): поля профиля берутся из него.
Future<List<String>> peerNameLines(List<int> userID, {Profile_Response? fresh}) async {
  if (userID.isEmpty) return const [];
  final repositories = getIt.get<Repositories>();
  final utils = getIt.get<Utils>();

  final contactNames = await repositories.contacts.namesByUserID(
    toHex: (id) => utils.bytesToHex(Uint8List.fromList(id)),
    userIDs: [userID],
  );
  final String firstName, lastName, username, rawPhone;
  if (fresh != null) {
    (firstName, lastName, username, rawPhone) = (fresh.firstName, fresh.lastName, fresh.username, fresh.phoneNumber);
  } else {
    final profile = await repositories.profiles.getByUserID(userID: userID);
    (firstName, lastName, username, rawPhone) = (profile.fistName, profile.lastName, profile.username, profile.phoneNumber);
  }
  var phone = utils.phoneNormalization(phoneNumber: rawPhone).international;
  if (phone.isEmpty) phone = rawPhone;
  if (phone.isEmpty) phone = await repositories.contacts.phoneByUserID(userID) ?? '';

  return utils.composeNameLines(
    contactName: contactNames.values.firstOrNull ?? '',
    firstName: firstName,
    lastName: lastName,
    phoneNumber: phone,
    username: username,
  );
}

/// [peerNameLines] одной строкой.
Future<String> peerDisplayName(List<int> userID, {Profile_Response? fresh}) async => (await peerNameLines(userID, fresh: fresh)).join(' ');
