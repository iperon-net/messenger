import 'dart:async';

import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';

import '../../audio_routes.dart';
import '../../i18n/translations.g.dart';
import 'audio_route_ui.dart';

/// Локализованная подпись маршрута. Для BT/проводной, когда система дала имя
/// устройства (модель), показываем его; иначе — обобщённое имя по типу
/// ([audioRouteTypeLabel]).
String audioRouteLabel(BuildContext context, AudioRoute route) {
  final showName = route.productName.isNotEmpty && (route.type == AudioRouteType.bluetooth || route.type == AudioRouteType.wiredHeadset);
  return showName ? route.productName : audioRouteTypeLabel(context, route.type);
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
                leading: HugeIcon(icon: audioRouteIcon(route.type), color: route.active ? colorScheme.primary : colorScheme.onSurface),
                title: Text(
                  audioRouteLabel(context, route),
                  style: TextStyle(color: route.active ? colorScheme.primary : colorScheme.onSurface),
                ),
                trailing: route.active ? HugeIcon(icon: HugeIcons.strokeRoundedTick02, color: colorScheme.primary) : null,
                onTap: () => _select(route),
              ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Android: круглая кнопка «Вывод звука» на панели управления звонком. По тапу
/// открывает [showAudioRoutesSheet]. Иконка/подпись фиксированы (динамик) — при
/// self-managed Telecom-звонке активный выход достоверно не отслеживается, а сам
/// список маршрутов с галочкой на активном показывает лист.
class AudioOutputButton extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final Color labelColor;

  const AudioOutputButton({super.key, required this.backgroundColor, required this.iconColor, required this.labelColor});

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
            decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: HugeIcon(icon: HugeIcons.strokeRoundedSpeaker, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(context.t.screenCall.audioOutput, style: TextStyle(color: labelColor, fontSize: 13)),
        ],
      ),
    );
  }
}
