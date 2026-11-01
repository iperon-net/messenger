import 'package:flutter/services.dart';

import '../../account_scope.dart';
import '../../bootstrap/bootstrap_config.dart';
import '../../calls.dart';
import '../../di.dart';
import '../../repositories.dart';

/// Слот аккаунта для экрана «Разработчик» (этап 3.1 мультиаккаунта — до
/// настоящего списка аккаунтов в «Настройках»).
/// [phone] — номер (или «без входа»), [detail] — окружение и начало
/// accountID, [title] — всё одной строкой.
typedef DeveloperAccountSlot = ({String accountID, String phone, String detail, String title, bool signedIn, bool active});

/// Слоты из `device.db`: номер (или «без входа»), окружение и активный ли.
Future<List<DeveloperAccountSlot>> developerAccountSlots({required String signedOut}) async {
  final slots = await getIt.get<DeviceRepositories>().accounts.all();
  final result = <DeveloperAccountSlot>[];
  for (final slot in slots) {
    final phone = slot.phoneNumber.isEmpty ? signedOut : '+${slot.phoneNumber}';
    final environment = slot.environment.isNotEmpty ? slot.environment : BootstrapConfig.defaultEnvironment;
    final detail = '$environment · ${slot.accountID.substring(0, 6)}';
    result.add((
      accountID: slot.accountID,
      phone: phone,
      detail: detail,
      title: '$phone · $detail',
      signedIn: slot.phoneNumber.isNotEmpty,
      active: slot.accountID == AccountScope.current.accountID,
    ));
  }
  return result;
}

/// Во время звонка аккаунт не переключить.
bool developerCanSwitchAccount() {
  final status = getIt.get<Calls>().snapshot.status;
  return status == CallStatus.idle || status == CallStatus.ended;
}

/// Окружения, в которых можно завести слот («Добавить аккаунт · staging»): из
/// bootstrap-файла и сборки.
List<String> developerEnvironments() => BootstrapConfig.environments;

/// Переключиться на слот [accountID] или завести новый в окружении
/// [environment] (откроется вход на его сервере).
Future<void> developerSwitchAccount({String? accountID, String? environment}) async {
  HapticFeedback.selectionClick();
  final target = accountID ?? await getIt.get<DeviceRepositories>().accounts.createSlot(environment: environment);
  await switchAccount(target);
}
