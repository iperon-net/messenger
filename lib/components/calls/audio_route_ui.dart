import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../audio_routes.dart';
import '../../i18n/translations.g.dart';

/// Иконка аудио-маршрута по его типу. Общая для обеих платформ (iOS
/// [RoutePickerButton], Android [AudioOutputButton]) и листа выбора — держим
/// здесь, в платформо-нейтральном файле (только hugeicons/widgets/i18n, без
/// cupertino_ui/material_ui), чтобы маппинг не расходился между вариантами.
List<List<dynamic>> audioRouteIcon(AudioRouteType type) => switch (type) {
  AudioRouteType.earpiece => HugeIcons.strokeRoundedSmartPhone01,
  AudioRouteType.speaker => HugeIcons.strokeRoundedVolumeHigh,
  AudioRouteType.wiredHeadset => HugeIcons.strokeRoundedHeadphones,
  AudioRouteType.bluetooth => HugeIcons.strokeRoundedBluetooth,
  AudioRouteType.hearingAid => HugeIcons.strokeRoundedEar,
  AudioRouteType.car => HugeIcons.strokeRoundedCar01,
  AudioRouteType.unknown => HugeIcons.strokeRoundedVolumeHigh,
};

/// Локализованная обобщённая подпись маршрута по его типу (без имени устройства).
/// Используется как подпись кнопки «Вывод звука» (iPhone / Динамик / Bluetooth /
/// …) и как generic-часть [audioRouteLabel] в листе.
String audioRouteTypeLabel(BuildContext context, AudioRouteType type) {
  final t = context.t.screenCall;
  return switch (type) {
    AudioRouteType.earpiece => t.routeEarpiece,
    AudioRouteType.speaker => t.routeSpeaker,
    AudioRouteType.wiredHeadset => t.routeWiredHeadset,
    AudioRouteType.bluetooth => t.routeBluetooth,
    AudioRouteType.hearingAid => t.routeHearingAid,
    AudioRouteType.car => t.routeCar,
    AudioRouteType.unknown => t.routeUnknown,
  };
}
