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

  // iOS: только ЧТЕНИЕ активного выхода (тип) — выбор маршрута делает системный
  // AVRoutePickerView, а по этим каналам нативная сторона отдаёт текущий выход из
  // AVAudioSession.currentRoute и его смену (routeChangeNotification), чтобы
  // кнопка рисовала нужную иконку/подпись. См. AppDelegate.AudioRouteMonitor.
  static const _iosMethod = MethodChannel('net.iperon.messenger/audio_route_ios');
  static const _iosEvents = EventChannel('net.iperon.messenger/audio_route_ios_events');

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

  /// Выбирает выход [route].
  ///
  /// Ось «разговорный↔динамик» — ТОЛЬКО через LiveKit
  /// `setSpeakerOutputPreferred`: маршрутом на Android владеет его audioswitch
  /// (`LKAudioSwitchManager`), который переизбирает выход по preferred-device-list.
  /// Наш нативный `setCommunicationDevice` ходит МИМО audioswitch и
  /// рассинхронизирует его внутреннее состояние: audioswitch кэширует
  /// `selectedAudioDevice` и, если считает, что нужный выход уже выбран, делает
  /// ранний выход без переактивации (см. `AbstractAudioSwitch.selectAudioDevice`) —
  /// тогда `setCommunicationDevice(speaker)` от LiveKit не переиздаётся и «динамик
  /// не включался». Поэтому:
  ///  • динамик  → `setSpeakerOutputPreferred(true, force:true)`;
  ///  • разговорный → `setSpeakerOutputPreferred(false)` (audioswitch сам вернёт
  ///    earpiece, когда не подключена гарнитура);
  ///  • BT/проводная/слуховой аппарат — конкретное устройство одним предпочтением
  ///    не выразить, поэтому снимаем предпочтение динамика и ставим устройство
  ///    нативно (это единственный случай, где нативный путь оправдан).
  ///
  /// Компромисс: «принудительно earpiece при подключённой гарнитуре» больше не
  /// продавливаем нативно (audioswitch отдаст приоритет гарнитуре) — ради
  /// надёжного earpiece↔динамик в обычном случае.
  Future<void> select(AudioRoute route) async {
    if (!isSupported) return;
    _logger.info('audioRoutes.select ${route.type.name} id=${route.id}');
    try {
      switch (route.type) {
        case AudioRouteType.speaker:
          await AudioManager.instance.setSpeakerOutputPreferred(true, force: true);
        case AudioRouteType.earpiece:
          await AudioManager.instance.setSpeakerOutputPreferred(false);
        default:
          await AudioManager.instance.setSpeakerOutputPreferred(false);
          await _method.invokeMethod<void>('select', {'id': route.id});
      }
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

  /// iOS: тип текущего активного аудио-выхода звонка (из
  /// `AVAudioSession.currentRoute`) для выбора иконки кнопки. На других
  /// платформах — [AudioRouteType.unknown] (там активный тип берётся из [changes]).
  Future<AudioRouteType> activeRouteTypeIos() async {
    if (!Platform.isIOS) return AudioRouteType.unknown;
    try {
      final name = await _iosMethod.invokeMethod<String>('current');
      return AudioRouteType.fromName(name);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
      return AudioRouteType.unknown;
    }
  }

  /// iOS: поток смены активного выхода (`routeChangeNotification`). Пустой на
  /// других платформах.
  Stream<AudioRouteType> get activeRouteTypeChangesIos {
    if (!Platform.isIOS) return const Stream.empty();
    return _iosEvents.receiveBroadcastStream().map((event) => AudioRouteType.fromName(event as String?));
  }
}
