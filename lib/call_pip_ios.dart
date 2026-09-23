import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

/// iOS-only обёртка нативного Picture-in-Picture видеозвонка (мини-окно с видео
/// СОБЕСЕДНИКА при сворачивании приложения). Канал совпадает с `CallPipController`
/// (ios/Runner/CallPipController.m). No-op вне iOS и при любой ошибке канала —
/// PiP это улучшение, звонок из-за него падать не должен. См. docs/ios_pip_plan.md.
///
/// Модель работы: `prepare(trackId)` цепляет нативный рендерер на удалённый трек и
/// включает авто-старт PiP при сворачивании (систему просим сама открывать/
/// закрывать мини-окно). Явного start/stop из Dart нет — им управляет система.
class CallPipIos {
  const CallPipIos._();

  static const _channel = MethodChannel('net.iperon.messenger/call_pip_ios');

  /// Поддерживает ли устройство/ОС video-call PiP (iOS 15+, `isPictureInPictureSupported`).
  static Future<bool> isSupported() async {
    if (!Platform.isIOS) return false;
    try {
      return await _channel.invokeMethod<bool>('isSupported') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Готовит PiP к видео собеседника. [trackId] — id нативного трека
  /// (`VideoTrack.mediaStreamTrack.id`). Идемпотентно на нативной стороне.
  static Future<void> prepare(String trackId) async {
    if (!Platform.isIOS || trackId.isEmpty) return;
    try {
      await _channel.invokeMethod<void>('prepare', {'trackId': trackId});
    } catch (_) {}
  }

  /// Снимает PiP (завершение звонка / уход с экрана / видео пропало).
  static Future<void> teardown() async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('teardown');
    } catch (_) {}
  }
}
