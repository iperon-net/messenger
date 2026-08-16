import 'package:dart_mappable/dart_mappable.dart';

import '../constants.dart';
import '../models.dart';

part 'common_state.mapper.dart';

@MappableClass()
class CommonState with CommonStateMappable {
  final Status status;
  final SettingsDeviceModel settingsDevice;
  final bool isLocked;

  /// Разрешён ли автоматический показ биометрии при открытии экрана блокировки.
  /// true — при «мягкой» блокировке (таймаут/холодный старт): Face ID / Touch ID
  /// всплывает сразу. false — при принудительной блокировке: биометрия только по
  /// нажатию на кнопку.
  final bool autoBiometrics;

  const CommonState({
    this.status = Status.initialization,
    required this.settingsDevice,
    this.isLocked = false,
    this.autoBiometrics = true,
  });
}
