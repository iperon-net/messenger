import 'package:flutter/services.dart';

import '../../account_scope.dart';
import '../../bootstrap/bootstrap_config.dart';
import '../../calls.dart';
import '../../di.dart';
import '../../repositories.dart';

/// Слот аккаунта для экрана «Разработчик» (этап 3.1 мультиаккаунта — до
/// настоящего списка аккаунтов в «Настройках»).
typedef DeveloperAccountSlot = ({String accountID, String title, bool active});

/// Слоты из `device.db`: номер (или «без входа»), окружение и активный ли.
Future<List<DeveloperAccountSlot>> developerAccountSlots({required String signedOut}) async {
  final slots = await getIt.get<DeviceRepositories>().accounts.all();
  return [
    for (final slot in slots)
      (
        accountID: slot.accountID,
        title: [
          slot.phoneNumber.isEmpty ? signedOut : '+${slot.phoneNumber}',
          slot.environment.isNotEmpty ? slot.environment : BootstrapConfig.defaultEnvironment,
          slot.accountID.substring(0, 6),
        ].join(' · '),
        active: slot.accountID == AccountScope.current.accountID,
      ),
  ];
}

/// Во время звонка аккаунт не переключить.
bool developerCanSwitchAccount() {
  final status = getIt.get<Calls>().snapshot.status;
  return status == CallStatus.idle || status == CallStatus.ended;
}

/// Окружения, в которых можно завести слот («Новый слот · staging»): из
/// bootstrap-файла и сборки.
List<String> developerEnvironments() => BootstrapConfig.environments;

/// Переключиться на слот [accountID] или завести новый в окружении
/// [environment] (откроется вход на его сервере).
Future<void> developerSwitchAccount({String? accountID, String? environment}) async {
  HapticFeedback.selectionClick();
  final target = accountID ?? await getIt.get<DeviceRepositories>().accounts.createSlot(environment: environment);
  await switchAccount(target);
}
