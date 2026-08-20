import 'dart:async';
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
import '../utils.dart';

import 'common_state.dart';

class CommonCubit extends Cubit<CommonState> {
  CommonCubit() : super(CommonState(settingsDevice: SettingsDeviceModel()));

  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();
  final utils = getIt.get<Utils>();

  // Должен совпадать с параметрами хеширования в SettingsPasscodeCreateCubit,
  // иначе байты введённого PIN не сойдутся с сохранённым хешем.
  final algorithm = Argon2id(parallelism: 4, memory: 10000, iterations: 3, hashLength: 32);

  // Момент ухода приложения в фон — нужен для авто-блокировки по таймауту.
  DateTime? _backgroundedAt;

  Future<void> initialization({required SettingsDeviceModel settingsDevice}) async {
    emit(state.copyWith(status: Status.loading));
    // При холодном старте блокируем экран, если passcode задан и была выставлена
    // форс-блокировка. Форс-блокировка персистится в БД и переживает перезапуск.
    bool locked = settingsDevice.passcode.isNotEmpty && settingsDevice.passcodeForceLocked;

    // Авто-блокировка по таймауту: на холодном старте блокируем НЕ всегда, а только
    // если приложение реально провело в фоне не меньше заданного таймаута. Момент
    // ухода в фон персистится (passcodeBackgroundedAt), поэтому переживает выгрузку
    // приложения из памяти iOS. Без этого при большом таймауте (напр. 5 часов)
    // блокировка ошибочно срабатывала бы при каждом «убийстве» процесса, не
    // дожидаясь таймаута — iOS выгружает приложение из памяти и старт начинается
    // заново, а прежний in-memory отсчёт времени теряется.
    if (!locked && settingsDevice.passcode.isNotEmpty && settingsDevice.passcodeAutoLock > 0 && settingsDevice.passcodeBackgroundedAt > 0) {
      final backgroundedAt = DateTime.fromMillisecondsSinceEpoch(settingsDevice.passcodeBackgroundedAt);
      final away = DateTime.now().difference(backgroundedAt);
      locked = away.inSeconds >= settingsDevice.passcodeAutoLock;
    }
    final isBiometricAvailable = await utils.isBiometricAvailable();
    // При холодном старте после принудительной блокировки биометрию сама не
    // показываем — только по кнопке. Обычная авто-блокировка биометрию разрешает.
    emit(
      state.copyWith(
        status: Status.success,
        settingsDevice: settingsDevice,
        isLocked: locked,
        autoBiometrics: !settingsDevice.passcodeForceLocked,
        isBiometricAvailable: isBiometricAvailable,
      ),
    );
  }

  /// Принудительная блокировка экрана. Флаг сохраняется в БД, поэтому блокировка
  /// сохраняется даже после того, как iOS выгрузит приложение и пользователь
  /// откроет его заново — снять её можно только вводом passcode.
  Future<void> forceLock({bool biometrics = true}) async {
    if (state.settingsDevice.passcode.isEmpty) return;
    await repositories.settingsDevice.setPasscodeForceLocked(true);
    // Перечитываем настройки из БД, а не берём их из памяти: иначе флаг
    // passcodeBiometric в state может быть устаревшим (например, включён на
    // экране настроек, но не долетел до CommonCubit) — и кнопка биометрии на
    // экране блокировки не появится, хотя FaceID/TouchID включён.
    final fresh = await repositories.settingsDevice.getAll();
    final settingsDevice = fresh.copyWith(passcodeForceLocked: true);
    final isBiometricAvailable = await utils.isBiometricAvailable();
    emit(
      state.copyWith(
        settingsDevice: settingsDevice,
        isLocked: true,
        autoBiometrics: biometrics,
        isBiometricAvailable: isBiometricAvailable,
      ),
    );
  }

  /// Приложение ушло в фон — запоминаем время для последующей проверки таймаута.
  ///
  /// Пишем только при первом уходе из foreground: на iOS уход в фон проходит
  /// цепочкой `inactive → hidden → paused`, а возврат — обратной
  /// `hidden → inactive → resumed`. Метод вызывается из всех этих не-`resumed`
  /// состояний, и без защиты `inactive`, приходящий прямо перед `resumed`, затёр
  /// бы реальное время ухода на «сейчас», обнулив измеренный интервал. Сбрасывает
  /// поле только [onAppResumed] — после проверки таймаута.
  ///
  /// Пока экран заблокирован, отметку времени не трогаем: она должна хранить
  /// момент последнего ухода в фон в РАЗблокированном состоянии, иначе при
  /// «убийстве» приложения из заблокированного состояния холодный старт пересчитал
  /// бы таймаут от свежего времени и ошибочно снял блокировку.
  void onAppBackgrounded() {
    if (state.isLocked) return;
    if (_backgroundedAt != null) return;

    _backgroundedAt = DateTime.now();

    // Персистим момент ухода в фон, чтобы пережить выгрузку приложения из памяти
    // и на холодном старте вычислить реальную длительность фона. Пишем только при
    // включённой авто-блокировке — только там отметка используется.
    if (state.settingsDevice.passcode.isNotEmpty && state.settingsDevice.passcodeAutoLock > 0) {
      unawaited(repositories.settingsDevice.setPasscodeBackgroundedAt(_backgroundedAt!.millisecondsSinceEpoch));
    }
  }

  /// Приложение вернулось на передний план. Если passcode задан и авто-блокировка
  /// включена (autoLock > 0), блокируем экран, когда в фоне провели не меньше
  /// заданного числа секунд. autoLock == 0 означает «Off» — авто-блокировки в
  /// рамках одной сессии нет (экран блокируется только при холодном старте).
  Future<void> onAppResumed() async {
    final backgroundedAt = _backgroundedAt;
    _backgroundedAt = null;

    if (state.settingsDevice.passcode.isEmpty) return;
    if (state.isLocked) return;

    final autoLock = state.settingsDevice.passcodeAutoLock;
    if (autoLock <= 0 || backgroundedAt == null) return;

    final away = DateTime.now().difference(backgroundedAt);
    if (away.inSeconds >= autoLock) {
      // Блокировка по таймауту — биометрию показываем сразу. Персистентную отметку
      // времени НЕ сбрасываем: если приложение выгрузят из памяти в заблокированном
      // состоянии, холодный старт по ней снова заблокирует экран.
      final isBiometricAvailable = await utils.isBiometricAvailable();
      emit(state.copyWith(isLocked: true, autoBiometrics: true, isBiometricAvailable: isBiometricAvailable));
    } else {
      // Остались в пределах таймаута — приложение снова активно и разблокировано.
      // Сбрасываем персистентную отметку, чтобы «убийство» процесса в foreground не
      // привело к ложной блокировке на следующем холодном старте.
      unawaited(repositories.settingsDevice.setPasscodeBackgroundedAt(0));
    }
  }

  /// Прогоняет введённый PIN через тот же Argon2id (nonce: []) и сравнивает
  /// полученный хеш с сохранённым. Ничего не эмитит — разблокировку выполняет
  /// [unlock] уже после анимации ScreenLock.
  Future<bool> verifyPasscode(String passcode) async {
    if (state.settingsDevice.passcode.isEmpty) return false;
    final secretKey = await algorithm.deriveKey(secretKey: SecretKey(utf8.encode(passcode)), nonce: []);
    final passcodeBytes = await secretKey.extractBytes();
    return listEquals(passcodeBytes, state.settingsDevice.passcode);
  }

  Future<void> unlock() async {
    // Снимаем и персистентную форс-блокировку, чтобы после ввода passcode
    // приложение больше не блокировалось при следующем запуске.
    if (state.settingsDevice.passcodeForceLocked) {
      await repositories.settingsDevice.setPasscodeForceLocked(false);
    }
    // Сбрасываем персистентный момент ухода в фон: пользователь ввёл passcode,
    // отсчёт авто-блокировки начинается заново.
    await repositories.settingsDevice.setPasscodeBackgroundedAt(0);
    final settingsDevice = state.settingsDevice.copyWith(passcodeForceLocked: false, passcodeBackgroundedAt: 0);
    emit(state.copyWith(settingsDevice: settingsDevice, isLocked: false, autoBiometrics: true));
  }

  /// Обновляет признак нахождения на экране авторизации. Вызывается из слушателя
  /// роутера в `main.dart` при каждой смене маршрута. Эмитит только при реальном
  /// изменении, чтобы не дёргать перестроение на каждую навигацию.
  void setIsAuthRoute({required bool isAuthRoute}) {
    if (state.isAuthRoute == isAuthRoute) return;
    emit(state.copyWith(isAuthRoute: isAuthRoute));
  }

  Future<void> setLocale({required AppLocale locale}) async {
    final settingsDevice = state.settingsDevice.copyWith(locale: locale);
    emit(state.copyWith(settingsDevice: settingsDevice));
  }

  Future<void> setColorTheme({required ColorThemeModel colorTheme}) async {
    final settingsDevice = state.settingsDevice.copyWith(colorTheme: colorTheme);
    emit(state.copyWith(settingsDevice: settingsDevice));
  }

  Future<void> setDarkMode({required DarkModeModel darkMode}) async {
    final settingsDevice = state.settingsDevice.copyWith(darkMode: darkMode);
    emit(state.copyWith(settingsDevice: settingsDevice));
  }

  Future<void> setIsBlurOnInactive({required bool isBlurOnInactive}) async {
    final settingsDevice = state.settingsDevice.copyWith(isBlurOnInactive: isBlurOnInactive);
    emit(state.copyWith(status: Status.success, settingsDevice: settingsDevice));
  }

  Future<void> setPasscode({required List<int> passcode}) async {
    final settingsDevice = state.settingsDevice.copyWith(passcode: passcode);
    // Изменение passcode всегда происходит внутри разблокированного приложения,
    // так что экран блокировки после этого показывать не нужно.
    emit(state.copyWith(status: Status.success, settingsDevice: settingsDevice, isLocked: false));
  }

  Future<void> setPasscodeAutoLockSeconds({required int seconds}) async {
    final settingsDevice = state.settingsDevice.copyWith(passcodeAutoLock: seconds);
    emit(state.copyWith(status: Status.success, settingsDevice: settingsDevice));
  }

  Future<void> setPasscodeBiometric({required bool biometric}) async {
    final settingsDevice = state.settingsDevice.copyWith(passcodeBiometric: biometric);
    emit(state.copyWith(status: Status.success, settingsDevice: settingsDevice));
  }
}
