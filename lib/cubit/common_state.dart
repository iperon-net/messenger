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

  /// Доступна ли биометрия на самом устройстве в данный момент: железо
  /// поддерживает Face ID / Touch ID и хотя бы один способ реально настроен
  /// (лицо/отпечаток добавлены). Отличается от [SettingsDeviceModel.passcodeBiometric] —
  /// то пользовательский тумблер, а это фактическое состояние ОС. Кнопку
  /// биометрии на экране блокировки показываем только когда оба true.
  final bool isBiometricAvailable;

  const CommonState({
    this.status = Status.initialization,
    required this.settingsDevice,
    this.isLocked = false,
    this.autoBiometrics = true,
    this.isBiometricAvailable = false,
  });
}
