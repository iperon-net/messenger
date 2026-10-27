import 'dart:async';

import 'package:livekit_client/livekit_client.dart';
import 'package:record/record.dart';

import 'di.dart';
import 'models.dart' as models;
import 'repositories.dart';

/// Микрофон и камера, выбранные на десктопе («Настройки → Общие»). Выбор хранится
/// в `settingsDevice` как id + имя: id устройства после перезагрузки бывает
/// другим, а у `record` (голосовые) и WebRTC (камера, позже звонки) id свои —
/// поэтому сначала ищем по id, потом по имени. Не нашли (устройство отключено)
/// или ничего не выбрано — системное по умолчанию (`null`).
abstract final class MediaDevices {
  /// Подключили / отключили устройство (WebRTC следит за всеми: и камеры, и
  /// микрофоны).
  static Stream<void> get changes => Hardware.instance.onDeviceChange.stream.map((_) {});

  /// Микрофоны для записи голосовых (id — как у `record`).
  static Future<List<InputDevice>> microphones(AudioRecorder recorder) => recorder.listInputDevices();

  /// Камеры (id — WebRTC).
  static Future<List<MediaDevice>> cameras() => Hardware.instance.enumerateDevices(type: 'videoinput');

  /// Выбранный микрофон среди подключённых; `null` — системный.
  static InputDevice? microphone(List<InputDevice> devices, models.SettingsDeviceModel settings) =>
      _match(devices, settings.microphoneId, settings.microphoneName, (d) => d.id, (d) => d.label);

  /// Выбранная камера среди подключённых; `null` — системная.
  static MediaDevice? camera(List<MediaDevice> devices, models.SettingsDeviceModel settings) =>
      _match(devices, settings.cameraId, settings.cameraName, (d) => d.deviceId, (d) => d.label);

  /// Микрофон для записи голосового: выбранный, если подключён; иначе `null`.
  static Future<InputDevice?> recordingMicrophone(AudioRecorder recorder, models.SettingsDeviceModel settings) async {
    if (settings.microphoneId.isEmpty && settings.microphoneName.isEmpty) return null;
    try {
      return microphone(await microphones(recorder), settings);
    } catch (_) {
      return null;
    }
  }

  /// WebRTC-id микрофона и камеры для звонка (`RoomOptions`): выбранные, если
  /// подключены; иначе `null` — системные. Микрофон ищем по имени: в
  /// настройках — id `record`, у WebRTC свои.
  static Future<({String? microphone, String? camera})> callDevices() async {
    try {
      final settings = await getIt.get<DeviceRepositories>().settingsDevice.getAll();
      if (settings.microphoneName.isEmpty && settings.cameraId.isEmpty && settings.cameraName.isEmpty) {
        return (microphone: null, camera: null);
      }
      final all = await Hardware.instance.enumerateDevices();
      final microphones = all.where((device) => device.kind == 'audioinput').toList();
      final cameras = all.where((device) => device.kind == 'videoinput').toList();
      return (
        microphone: _match(microphones, '', settings.microphoneName, (d) => d.deviceId, (d) => d.label)?.deviceId,
        camera: camera(cameras, settings)?.deviceId,
      );
    } catch (_) {
      return (microphone: null, camera: null);
    }
  }

  static T? _match<T>(List<T> devices, String id, String name, String Function(T) idOf, String Function(T) nameOf) {
    if (id.isEmpty && name.isEmpty) return null;
    for (final device in devices) {
      if (id.isNotEmpty && idOf(device) == id) return device;
    }
    for (final device in devices) {
      if (name.isNotEmpty && nameOf(device) == name) return device;
    }
    return null;
  }
}
