import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'di.dart';
import 'logger.dart';

/// Класс производительности устройства (как в Telegram): по нему тяжёлые
/// эффекты (анимированные эмодзи и т.п.) упрощаются или выключаются.
enum PerformanceClass { low, average, high }

/// Класс производительности: железо (память, ядра, частота, версия ОС — канал
/// `net.iperon.messenger/device_performance`, натив: DevicePerformance.kt /
/// AppDelegate.swift) + режим энергосбережения (тогда — [PerformanceClass.low]
/// на любом устройстве). Меняется (энергосбережение включили / выключили) —
/// [notifyListeners].
class DevicePerformance extends ChangeNotifier {
  DevicePerformance._();

  static final DevicePerformance instance = DevicePerformance._();

  static const _channel = MethodChannel('net.iperon.messenger/device_performance');

  /// По железу; до [init] и без канала — мощное (как было до класса).
  PerformanceClass get hardware => _hardware;
  PerformanceClass _hardware = PerformanceClass.high;

  /// Включён режим энергосбережения.
  bool get powerSave => _powerSave;
  bool _powerSave = false;

  /// Действующий класс: энергосбережение — слабое.
  PerformanceClass get current => _powerSave ? PerformanceClass.low : _hardware;

  /// Анимации по кругу (сетка эмодзи) — только на мощных и средних.
  bool get loopAnimations => current != PerformanceClass.low;

  /// Анимации вообще (крупные эмодзи, реакции) — не на слабых.
  bool get animations => current != PerformanceClass.low;

  AppLifecycleListener? _lifecycle;

  /// Один раз на старте. Без натива (тесты, другая платформа) — мощное.
  Future<void> init() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'powerSave') _setPowerSave(call.arguments == true);
    });
    // Пропущенное уведомление (приложение было выгружено из памяти) — сверяем
    // на возврате.
    _lifecycle ??= AppLifecycleListener(onResume: _refresh);
    await _refresh();
  }

  Future<void> _refresh() async {
    try {
      final info = await _channel.invokeMapMethod<String, Object?>('info');
      if (info == null) return;
      final hardware = classify(info, android: Platform.isAndroid);
      final powerSave = info['powerSave'] == true;
      if (hardware != _hardware || powerSave != _powerSave) {
        _hardware = hardware;
        _powerSave = powerSave;
        getIt.get<Logger>().info('performance: ${hardware.name}${powerSave ? ' (power save)' : ''} $info');
        notifyListeners();
      }
    } on MissingPluginException {
      // Нет натива — остаёмся мощным.
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
    }
  }

  void _setPowerSave(bool value) {
    if (value == _powerSave) return;
    _powerSave = value;
    notifyListeners();
  }

  /// Класс по признакам железа. Android — по памяти, ядрам, частоте и версии
  /// (пороги — как у Telegram, `SharedConfig.measureDevicePerformanceClass`,
  /// вместо memoryClass — общий объём памяти) и заявленному
  /// media performance class; iOS — по памяти (≤ 3 ГБ — iPhone 8 / X / XR / 11 —
  /// средние; слабых среди iOS 15+ почти нет).
  @visibleForTesting
  static PerformanceClass classify(Map<String, Object?> info, {required bool android}) {
    const gb = 1024 * 1024 * 1024;
    final ram = (info['ram'] as num?)?.toDouble() ?? 0;
    final cores = (info['cores'] as num?)?.toInt() ?? 0;
    if (!android) {
      if (ram > 0 && ram < 2.5 * gb) return PerformanceClass.low;
      if (ram > 0 && ram < 3.5 * gb) return PerformanceClass.average;
      return PerformanceClass.high;
    }
    final lowRam = info['lowRam'] == true;
    final mhz = ((info['maxFreqKHz'] as num?)?.toInt() ?? 0) ~/ 1000;
    final mediaClass = (info['mediaClass'] as num?)?.toInt() ?? 0;
    // Заявленный класс производительности (Android 12+): 33+ — флагман.
    if (mediaClass >= 33) return PerformanceClass.high;
    if (lowRam || (ram > 0 && ram < 3 * gb) || cores <= 2 || (cores <= 4 && mhz > 0 && mhz <= 1600)) {
      return PerformanceClass.low;
    }
    if (mediaClass >= 31) return PerformanceClass.average;
    if ((ram > 0 && ram < 6 * gb) || cores < 8 || (mhz > 0 && mhz <= 2055)) return PerformanceClass.average;
    return PerformanceClass.high;
  }
}
