import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../auth.dart';
import '../../calls.dart';
import '../../components.dart';
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
