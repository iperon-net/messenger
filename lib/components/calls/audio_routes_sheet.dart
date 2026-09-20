import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:material_ui/material_ui.dart';

import '../../audio_routes.dart';
import '../../i18n/translations.g.dart';

/// Иконка аудио-маршрута по его типу (общая для кнопки и листа).
IconData audioRouteIcon(AudioRouteType type) => switch (type) {
  AudioRouteType.earpiece => CupertinoIcons.phone_fill,
  AudioRouteType.speaker => CupertinoIcons.speaker_3_fill,
  AudioRouteType.wiredHeadset => CupertinoIcons.headphones,
  AudioRouteType.bluetooth => CupertinoIcons.bluetooth,
  AudioRouteType.hearingAid => CupertinoIcons.ear,
  AudioRouteType.car => CupertinoIcons.car_fill,
  AudioRouteType.unknown => CupertinoIcons.speaker_2_fill,
};

/// Локализованная подпись маршрута. Для BT/проводной, когда система дала имя
/// устройства (модель), показываем его; иначе — обобщённое имя по типу.
String audioRouteLabel(BuildContext context, AudioRoute route) {
  final t = context.t.screenCall;
  final generic = switch (route.type) {
    AudioRouteType.earpiece => t.routeEarpiece,
    AudioRouteType.speaker => t.routeSpeaker,
    AudioRouteType.wiredHeadset => t.routeWiredHeadset,
    AudioRouteType.bluetooth => t.routeBluetooth,
    AudioRouteType.hearingAid => t.routeHearingAid,
    AudioRouteType.car => t.routeCar,
    AudioRouteType.unknown => t.routeUnknown,
  };
  final showName = route.productName.isNotEmpty && (route.type == AudioRouteType.bluetooth || route.type == AudioRouteType.wiredHeadset);
  return showName ? route.productName : generic;
}

/// Открывает лист выбора аудио-выхода (Android). Возвращает, когда лист закрыт.
Future<void> showAudioRoutesSheet(BuildContext context) {
  return showModalBottomSheet<void>(context: context, showDragHandle: true, builder: (_) => const _AudioRoutesSheet());
}

class _AudioRoutesSheet extends StatefulWidget {
  const _AudioRoutesSheet();

  @override
  State<_AudioRoutesSheet> createState() => _AudioRoutesSheetState();
}

class _AudioRoutesSheetState extends State<_AudioRoutesSheet> {
  List<AudioRoute> _routes = const [];
  StreamSubscription<List<AudioRoute>>? _sub;

  @override
  void initState() {
    super.initState();
    // Начальный снимок + живые обновления (подключение/отключение устройств,
    // смена активного маршрута) пока лист открыт.
    unawaited(
      AudioRoutes.instance.list().then((routes) {
        if (mounted) setState(() => _routes = routes);
      }),
    );
    _sub = AudioRoutes.instance.changes.listen((routes) {
      if (mounted) setState(() => _routes = routes);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _select(AudioRoute route) async {
    await AudioRoutes.instance.select(route);
    // Активный маршрут обновится событием, но оптимистично отметим сразу.
    if (mounted) {
      setState(() {
        _routes = _routes.map((r) => AudioRoute(id: r.id, type: r.type, productName: r.productName, active: r.id == route.id)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenCall;
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(t.audioOutputTitle, style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          if (_routes.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Text(t.routeUnavailable, style: TextStyle(color: colorScheme.onSurfaceVariant)),
            )
          else
            for (final route in _routes)
              ListTile(
                leading: Icon(audioRouteIcon(route.type), color: route.active ? colorScheme.primary : colorScheme.onSurface),
                title: Text(
                  audioRouteLabel(context, route),
                  style: TextStyle(color: route.active ? colorScheme.primary : colorScheme.onSurface),
                ),
                trailing: route.active ? Icon(CupertinoIcons.check_mark, color: colorScheme.primary) : null,
                onTap: () => _select(route),
              ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Android: круглая кнопка «Вывод звука» на панели управления звонком. Иконка
/// отражает активный маршрут; по тапу открывает [showAudioRoutesSheet].
class AudioOutputButton extends StatefulWidget {
  final Color backgroundColor;
  final Color iconColor;
  final Color labelColor;

  const AudioOutputButton({super.key, required this.backgroundColor, required this.iconColor, required this.labelColor});

  @override
  State<AudioOutputButton> createState() => _AudioOutputButtonState();
}

class _AudioOutputButtonState extends State<AudioOutputButton> {
  AudioRouteType _activeType = AudioRouteType.earpiece;
  StreamSubscription<List<AudioRoute>>? _sub;

  @override
  void initState() {
    super.initState();
    unawaited(AudioRoutes.instance.list().then(_apply));
    _sub = AudioRoutes.instance.changes.listen(_apply);
  }

  void _apply(List<AudioRoute> routes) {
    if (!mounted) return;
    for (final route in routes) {
      if (route.active) {
        setState(() => _activeType = route.type);
        return;
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showAudioRoutesSheet(context),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(color: widget.backgroundColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(audioRouteIcon(_activeType), color: widget.iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(context.t.screenCall.audioOutput, style: TextStyle(color: widget.labelColor, fontSize: 13)),
        ],
      ),
    );
  }
}
