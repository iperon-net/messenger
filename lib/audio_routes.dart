import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:livekit_client/livekit_client.dart';

import 'di.dart';
import 'logger.dart';

/// Тип аудио-маршрута (куда идёт звук звонка). Платформенно-нейтральный —
/// нативная сторона (Android `AudioDeviceInfo.type`) маппится в него, а UI по
/// нему выбирает иконку/подпись.
enum AudioRouteType {
  earpiece,
  speaker,
  wiredHeadset,
  bluetooth,
  hearingAid,
  car,
  unknown;

  static AudioRouteType fromName(String? name) {
    return AudioRouteType.values.firstWhere((t) => t.name == name, orElse: () => AudioRouteType.unknown);
  }
}

/// Один доступный аудио-выход звонка. [id] — нативный идентификатор устройства
/// (на Android — `AudioDeviceInfo.id`), по нему делается [AudioRoutes.select].
/// [productName] — «сырое» имя устройства от системы (напр. модель гарнитуры),
/// может быть пустым; UI обычно показывает локализованную подпись по [type], а
/// [productName] добавляет уточнением.
class AudioRoute {
  final String id;
  final AudioRouteType type;
  final String productName;
  final bool active;

  const AudioRoute({required this.id, required this.type, required this.productName, required this.active});

  factory AudioRoute.fromMap(Map<dynamic, dynamic> map) => AudioRoute(
    id: (map['id'] ?? '').toString(),
    type: AudioRouteType.fromName(map['type'] as String?),
    productName: (map['productName'] as String?) ?? '',
    active: (map['active'] as bool?) ?? false,
  );

  @override
  bool operator ==(Object other) =>
      other is AudioRoute && other.id == id && other.type == type && other.productName == productName && other.active == active;

  @override
  int get hashCode => Object.hash(id, type, productName, active);
}

/// Выбор аудио-выхода звонка на **Android** (свой нативный список поверх
/// `AudioManager.getAvailableCommunicationDevices`/`setCommunicationDevice`,
/// API 31+). На iOS выбор маршрута делает системный `AVRoutePickerView` (см.
/// `RoutePickerButton`), поэтому здесь методы iOS — no-op/пустой список.
///
/// Важно: маршрутом на Android в норме владеет audioswitch LiveKit (он держит
/// автоматический выбор по `preferredDeviceList`). Наш ручной
/// `setCommunicationDevice` перебивает его до следующего пересчёта audioswitch
/// (hot-plug/переконфигурация), а чтобы они не «спорили», [select] дополнительно
/// подравнивает предпочтение динамика в LiveKit (`setSpeakerOutputPreferred`) —
/// см. нативный `AudioDevicesHandler`. Требует проверки на реальных устройствах.
class AudioRoutes {
  AudioRoutes._();

  static final AudioRoutes instance = AudioRoutes._();

  static const _method = MethodChannel('net.iperon.messenger/audio_devices');
  static const _events = EventChannel('net.iperon.messenger/audio_devices_events');

  Logger get _logger => getIt.get<Logger>();

  /// true только там, где работает наш нативный список (Android). На iOS —
  /// нативный `AVRoutePickerView`, здесь false.
  bool get isSupported => Platform.isAndroid;

  /// Текущий список доступных выходов (первый актуальный снимок). Пустой на iOS
  /// или при ошибке.
  Future<List<AudioRoute>> list() async {
    if (!isSupported) return const [];
    try {
      final raw = await _method.invokeListMethod<Map<dynamic, dynamic>>('list');
      return (raw ?? const []).map(AudioRoute.fromMap).toList(growable: false);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
      return const [];
    }
  }

  /// Выбирает выход [route]. Сначала подравнивает предпочтение динамика в LiveKit
  /// (`setSpeakerOutputPreferred`), чтобы его audioswitch не тянул маршрут
  /// обратно, затем ставит устройство нативно (`setCommunicationDevice`).
  Future<void> select(AudioRoute route) async {
    if (!isSupported) return;
    try {
      final isSpeaker = route.type == AudioRouteType.speaker;
      await AudioManager.instance.setSpeakerOutputPreferred(isSpeaker, force: isSpeaker);
      await _method.invokeMethod<void>('select', {'id': route.id});
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  /// Поток обновлений списка выходов: приходит при подключении/отключении
  /// устройств и при смене активного маршрута, пока есть подписчик. Пустой на
  /// iOS.
  Stream<List<AudioRoute>> get changes {
    if (!isSupported) return const Stream.empty();
    return _events.receiveBroadcastStream().map((event) {
      final list = (event as List<dynamic>?) ?? const [];
      return list.cast<Map<dynamic, dynamic>>().map(AudioRoute.fromMap).toList(growable: false);
    });
  }
}
