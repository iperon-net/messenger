import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:livekit_client/livekit_client.dart';

/// iOS-only обёртка нативного Picture-in-Picture видеозвонка
/// (ios/Runner/CallPipController.m): системное мини-окно с видео СОБЕСЕДНИКА (или
/// его аватаром, когда камера выключена) при сворачивании приложения. Окно
/// открывает/закрывает сама система — из Dart только держим натив в актуальном
/// состоянии.
///
/// Владелец — сервис звонков ([Calls] в lib/calls.dart): он знает жизненный цикл
/// дорожек и обязан отцепить нативный рендерер ДО разбора комнаты
/// ([disable]/[detachTrack] с await перед `room.disconnect()`/`dispose()`), иначе
/// рендерер остался бы на треке закрытого peer connection. Экран звонка передаёт
/// лишь имя/аватар для плейсхолдера ([setPeer]).
///
/// Все вызовы идемпотентны (дедуп по последнему отправленному значению), no-op вне
/// iOS; ошибки канала глушим — PiP улучшение, звонок из-за него падать не должен.
class CallPipIos {
  const CallPipIos._();

  static const _channel = MethodChannel('net.iperon.messenger/call_pip_ios');

  static bool _enabled = false;
  static VideoTrack? _track;
  static bool _videoOff = false;
  static String? _peerName;
  static Uint8List? _peerImage;

  /// Приводит натив к желаемому состоянию: [enabled] — идёт видеозвонок (PiP
  /// разрешён), [track] — удалённая видеодорожка (null — нет, в окне плейсхолдер),
  /// [videoOff] — собеседник выключил камеру. Порядок вызовов канала сохраняется,
  /// поэтому `enable` гарантированно доходит до натива раньше `setTrack`.
  static void sync({required bool enabled, VideoTrack? track, required bool videoOff}) {
    if (!Platform.isIOS) return;
    if (!enabled) {
      if (_enabled) unawaited(disable());
      return;
    }
    if (!_enabled) {
      _enabled = true;
      _track = null;
      unawaited(_invoke('enable'));
    }
    if (!identical(track, _track)) {
      _track = track;
      unawaited(_invoke('setTrack', {'trackId': track?.mediaStreamTrack.id}));
    }
    if (videoOff != _videoOff) {
      _videoOff = videoOff;
      unawaited(_invoke('setVideoOff', {'off': videoOff}));
    }
  }

  /// Отцепляет нативный рендерер от дорожки (окно остаётся). Ждать до разбора
  /// комнаты, в которой живёт дорожка.
  static Future<void> detachTrack() async {
    if (!Platform.isIOS || _track == null) return;
    _track = null;
    await _invoke('setTrack', {'trackId': null});
  }

  /// Полностью снимает PiP: отцепляет рендерер и закрывает окно. Ждать до разбора
  /// комнаты (см. описание класса).
  static Future<void> disable() async {
    if (!Platform.isIOS || !_enabled) return;
    _enabled = false;
    _track = null;
    _videoOff = false;
    await _invoke('disable');
  }

  /// Имя и аватар собеседника для плейсхолдера (камера выключена/видео ещё нет).
  /// Без аватара натив рисует инициалы.
  static void setPeer(String name, Uint8List? image) {
    if (!Platform.isIOS) return;
    if (name == _peerName && identical(image, _peerImage)) return;
    _peerName = name;
    _peerImage = image;
    unawaited(_invoke('setPeer', {'name': name, 'image': image}));
  }

  /// Уход приложения в фон: можно ли НЕ глушить свою камеру. true — iOS 18+
  /// разрешил захват в многозадачности (PiP) и он сейчас идёт; false — камеру надо
  /// заглушить, иначе у собеседника застынет последний кадр.
  static Future<bool> keepCameraInBackground() async {
    if (!Platform.isIOS || !_enabled) return false;
    try {
      return await _channel.invokeMethod<bool>('keepCameraInBackground') ?? false;
    } catch (_) {
      return false;
    }
  }

  static void Function()? _onCameraInterrupted;
  static bool _handlerSet = false;

  /// Колбэк «система прервала захват камеры, пока приложение в фоне» (блокировка
  /// экрана, мини-окно не открылось/закрылось) — владелец глушит камеру.
  static set onCameraInterrupted(void Function()? callback) {
    _onCameraInterrupted = callback;
    if (_handlerSet || !Platform.isIOS) return;
    _handlerSet = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'cameraInterrupted') _onCameraInterrupted?.call();
      return null;
    });
  }

  static Future<void> _invoke(String method, [Object? arguments]) async {
    try {
      await _channel.invokeMethod<Object?>(method, arguments);
    } catch (_) {}
  }
}
