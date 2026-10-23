import 'dart:async';

import 'package:flutter/services.dart';

import 'di.dart';
import 'logger.dart';

/// Датчик приближения на звонке: поднёс телефон к уху — экран гаснет и не
/// нажимается щекой. Система сама этого для нашего экрана звонка не делает.
/// Здесь — только «такой звонок идёт» ([sync] из `Calls`); включён ли датчик
/// на самом деле, решает натив по текущему выходу звука (только разговорный
/// динамик): iOS — `UIDevice.isProximityMonitoringEnabled` (`CallProximity` в
/// `AppDelegate.swift`), Android — `PROXIMITY_SCREEN_OFF_WAKE_LOCK`
/// (`CallProximity.kt`).
abstract final class CallProximity {
  static const _channel = MethodChannel('net.iperon.messenger/call_proximity');
  static bool _enabled = false;

  static void sync({required bool enabled}) {
    if (_enabled == enabled) return;
    _enabled = enabled;
    unawaited(
      _channel.invokeMethod<void>('set', {'enabled': enabled}).catchError((Object error, StackTrace stackTrace) {
        getIt.get<Logger>().handle(error, stackTrace);
      }),
    );
  }
}
