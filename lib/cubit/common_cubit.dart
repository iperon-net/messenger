import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger/repositories.dart';

import '../constants.dart';
import '../di.dart';
import '../i18n/translations.g.dart';
import '../logger.dart';
import '../models.dart';

import 'common_state.dart';

class CommonCubit extends Cubit<CommonState> {
  CommonCubit() : super(CommonState(settingsDevice: SettingsDeviceModel()));

  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();

  // Должен совпадать с параметрами хеширования в SettingsPasscodeCreateCubit,
  // иначе байты введённого PIN не сойдутся с сохранённым хешем.
  final algorithm = Argon2id(
    parallelism: 4,
    memory: 10000,
    iterations: 3,
    hashLength: 32,
  );

  // Момент ухода приложения в фон — нужен для авто-блокировки по таймауту.
  DateTime? _backgroundedAt;

  Future<void> initialization({
    required SettingsDeviceModel settingsDevice,
  }) async {
    emit(state.copyWith(status: Status.loading));
    // При холодном старте блокируем экран, если passcode задан и либо включена
    // авто-блокировка (autoLock > 0), либо ранее была выставлена форс-блокировка.
    // Форс-блокировка персистится в БД и потому переживает перезапуск приложения.
    final locked =
        settingsDevice.passcode.isNotEmpty &&
        (settingsDevice.passcodeForceLocked ||
            settingsDevice.passcodeAutoLock > 0);
    emit(
      state.copyWith(
        status: Status.success,
        settingsDevice: settingsDevice,
        isLocked: locked,
      ),
    );
  }

  /// Принудительная блокировка экрана. Флаг сохраняется в БД, поэтому блокировка
  /// сохраняется даже после того, как iOS выгрузит приложение и пользователь
  /// откроет его заново — снять её можно только вводом passcode.
  Future<void> forceLock() async {
    if (state.settingsDevice.passcode.isEmpty) return;
    await repositories.settingsDevice.setPasscodeForceLocked(true);
    final settingsDevice = state.settingsDevice.copyWith(
      passcodeForceLocked: true,
    );
    emit(state.copyWith(settingsDevice: settingsDevice, isLocked: true));
  }

  /// Приложение ушло в фон — запоминаем время для последующей проверки таймаута.
  ///
  /// Пишем только при первом уходе из foreground (`??=`): на iOS уход в фон
  /// проходит цепочкой `inactive → hidden → paused`, а возврат — обратной
  /// `hidden → inactive → resumed`. Метод вызывается из всех этих не-`resumed`
  /// состояний, и без защиты `inactive`, приходящий прямо перед `resumed`, затёр
  /// бы реальное время ухода на «сейчас», обнулив измеренный интервал. Сбрасывает
  /// поле только [onAppResumed] — после проверки таймаута.
  void onAppBackgrounded() {
    _backgroundedAt ??= DateTime.now();
  }

  /// Приложение вернулось на передний план. Если passcode задан и авто-блокировка
  /// включена (autoLock > 0), блокируем экран, когда в фоне провели не меньше
  /// заданного числа секунд. autoLock == 0 означает «Off» — авто-блокировки в
  /// рамках одной сессии нет (экран блокируется только при холодном старте).
  void onAppResumed() {
    final backgroundedAt = _backgroundedAt;
    _backgroundedAt = null;

    if (state.settingsDevice.passcode.isEmpty) return;
    if (state.isLocked) return;

    final autoLock = state.settingsDevice.passcodeAutoLock;
    if (autoLock <= 0 || backgroundedAt == null) return;

    final away = DateTime.now().difference(backgroundedAt);
    if (away.inSeconds >= autoLock) {
      emit(state.copyWith(isLocked: true));
    }
  }

  /// Прогоняет введённый PIN через тот же Argon2id (nonce: []) и сравнивает
  /// полученный хеш с сохранённым. Ничего не эмитит — разблокировку выполняет
  /// [unlock] уже после анимации ScreenLock.
  Future<bool> verifyPasscode(String passcode) async {
    if (state.settingsDevice.passcode.isEmpty) return false;
    final secretKey = await algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(passcode)),
      nonce: [],
    );
    final passcodeBytes = await secretKey.extractBytes();
    return listEquals(passcodeBytes, state.settingsDevice.passcode);
  }

  Future<void> unlock() async {
    // Снимаем и персистентную форс-блокировку, чтобы после ввода passcode
    // приложение больше не блокировалось при следующем запуске.
    if (state.settingsDevice.passcodeForceLocked) {
      await repositories.settingsDevice.setPasscodeForceLocked(false);
    }
    final settingsDevice = state.settingsDevice.copyWith(
      passcodeForceLocked: false,
    );
    emit(state.copyWith(settingsDevice: settingsDevice, isLocked: false));
  }

  Future<void> setLocale({required AppLocale locale}) async {
    final settingsDevice = state.settingsDevice.copyWith(locale: locale);
    emit(state.copyWith(settingsDevice: settingsDevice));
  }

  Future<void> setColorTheme({required ColorThemeModel colorTheme}) async {
    final settingsDevice = state.settingsDevice.copyWith(
      colorTheme: colorTheme,
    );
    emit(state.copyWith(settingsDevice: settingsDevice));
  }

  Future<void> setDarkMode({required DarkModeModel darkMode}) async {
    final settingsDevice = state.settingsDevice.copyWith(darkMode: darkMode);
    emit(state.copyWith(settingsDevice: settingsDevice));
  }

  Future<void> setIsBlurOnInactive({required bool isBlurOnInactive}) async {
    final settingsDevice = state.settingsDevice.copyWith(
      isBlurOnInactive: isBlurOnInactive,
    );
    emit(
      state.copyWith(status: Status.success, settingsDevice: settingsDevice),
    );
  }

  Future<void> setPasscode({required List<int> passcode}) async {
    final settingsDevice = state.settingsDevice.copyWith(passcode: passcode);
    // Изменение passcode всегда происходит внутри разблокированного приложения,
    // так что экран блокировки после этого показывать не нужно.
    emit(
      state.copyWith(
        status: Status.success,
        settingsDevice: settingsDevice,
        isLocked: false,
      ),
    );
  }

  Future<void> setPasscodeAutoLockSeconds({required int seconds}) async {
    final settingsDevice = state.settingsDevice.copyWith(
      passcodeAutoLock: seconds,
    );
    emit(
      state.copyWith(status: Status.success, settingsDevice: settingsDevice),
    );
  }

  Future<void> setPasscodeBiometric({required bool biometric}) async {
    final settingsDevice = state.settingsDevice.copyWith(
      passcodeBiometric: biometric,
    );
    emit(
      state.copyWith(status: Status.success, settingsDevice: settingsDevice),
    );
  }
}
