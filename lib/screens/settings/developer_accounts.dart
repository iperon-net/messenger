import 'package:flutter/services.dart';

import '../../account_scope.dart';
import '../../calls.dart';
import '../../di.dart';
import '../../repositories.dart';

/// Слот аккаунта для экрана «Разработчик» (этап 3.1 мультиаккаунта — до
/// настоящего списка аккаунтов в «Настройках»).
typedef DeveloperAccountSlot = ({String accountID, String title, bool active});

/// Слоты из `device.db`: номер (или «без входа») и активный ли.
Future<List<DeveloperAccountSlot>> developerAccountSlots({required String signedOut}) async {
  final slots = await getIt.get<DeviceRepositories>().accounts.all();
  return [
    for (final slot in slots)
      (
        accountID: slot.accountID,
        title: '${slot.phoneNumber.isEmpty ? signedOut : '+${slot.phoneNumber}'} · ${slot.accountID.substring(0, 6)}',
        active: slot.accountID == AccountScope.current.accountID,
      ),
  ];
}

/// Во время звонка аккаунт не переключить.
bool developerCanSwitchAccount() {
  final status = getIt.get<Calls>().snapshot.status;
  return status == CallStatus.idle || status == CallStatus.ended;
}

/// Переключиться на слот [accountID] (null — новый пустой слот: откроется
/// вход).
Future<void> developerSwitchAccount(String? accountID) async {
  HapticFeedback.selectionClick();
  final target = accountID ?? await getIt.get<DeviceRepositories>().accounts.createSlot();
  await switchAccount(target);
}
