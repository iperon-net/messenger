import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../auth.dart';
import '../../calls.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../utils.dart';

/// Общее для профиля пользователя (`profile_{cupertino,material}.dart`).

/// Свой ли это профиль — на нём нет звонков и «Ещё».
bool profileIsSelf(List<int> userID) => listEquals(userID, getIt.get<Auth>().session.userID);

/// userID в hex — для маршрутов `/profile/:userID`, `/chats/...`.
String profileHex(List<int> userID) => getIt.get<Utils>().bytesToHex(Uint8List.fromList(userID));

/// «Звонок» / «Видео»: нет сети — разрулит [Calls.startCall].
Future<void> profileCall(List<int> userID, {required bool video}) async {
  await ensureCallMicPermission();
  await getIt.get<Calls>().startCall(toUserID: userID, video: video);
}

/// «9 мая 1981 (43 года)»; владелец скрыл год — только «9 мая» (без года и
/// возраста).
String profileBirthDateText(Translations t, DateTime birthDate, {required bool hideYear}) => hideYear
    ? DateFormat('d MMMM').format(birthDate)
    : '${DateFormat('d MMMM y').format(birthDate)} (${t.screenProfile.age(n: birthDate.ageInYears())})';

/// Поля формы контакта из профиля: имя, как я его записал (иначе — из
/// профиля), и номер — ключ контакта (иначе — номер из профиля).
ContactAddInput profileContactInitial(ProfileState profile) {
  final name = profile.contactName;
  final space = name.indexOf(' ');
  return ContactAddInput(
    firstName: name.isEmpty ? profile.firstName : (space < 0 ? name : name.substring(0, space)),
    lastName: name.isEmpty ? profile.lastName : (space < 0 ? '' : name.substring(space + 1)),
    phone: profile.isContact ? profile.contactPhoneE164 : profile.phoneNumber,
  );
}

/// «Удалить контакт» в форме правки — только облачный и не из телефонной книги
/// (книжный удаляют в системной книге, как и свайпом в Контактах).
bool profileContactRemovable(ProfileState profile) =>
    profile.contactCloud && !(ContactsCubit.active?.isInBook(profile.contactPhoneE164) ?? false);

/// Сохранить форму контакта из профиля: добавить / переименовать (облачный
/// контакт — переименованный книжный перекрывает имя из книги) или удалить.
/// [noConnection] — показать общий алерт «нет сети»; [error] — текст ошибки.
Future<({bool noConnection, String? error})> profileApplyContact(Translations t, ProfileState profile, ContactAddInput input) async {
  final contacts = ContactsCubit.active;
  if (contacts == null) return (noConnection: false, error: input.remove ? t.screenContacts.removeFailed : t.screenContacts.addFailed);
  if (input.remove) {
    return switch (await contacts.removeByPhone(profile.contactPhoneE164)) {
      ContactRemoveResult.removed => (noConnection: false, error: null),
      ContactRemoveResult.noConnection => (noConnection: true, error: null),
      ContactRemoveResult.failed => (noConnection: false, error: t.screenContacts.removeFailed),
    };
  }
  final result = await contacts.addByNumber(firstName: input.firstName, lastName: input.lastName, rawNumber: input.phone);
  return switch (result) {
    ContactAddResult.addedRegistered || ContactAddResult.addedPending => (noConnection: false, error: null),
    ContactAddResult.noConnection => (noConnection: true, error: null),
    ContactAddResult.invalidNumber => (noConnection: false, error: t.screenContacts.addInvalidNumber),
    ContactAddResult.limitReached => (noConnection: false, error: t.screenContacts.validationCloudLimitReached),
    ContactAddResult.failed => (noConnection: false, error: t.screenContacts.addFailed),
  };
}
