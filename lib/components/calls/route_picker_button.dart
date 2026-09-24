import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';

/// iOS: круглая кнопка выбора аудио-выхода звонка — обёртка над нативным
/// `AVRoutePickerView` (см. ios/Runner/RoutePickerViewFactory.swift). По тапу
/// система сама показывает список маршрутов (iPhone / Speaker / Bluetooth /
/// CarPlay / AirPlay). Стилизована как [_CircleButton] на экране звонка: тот же
/// круг 68×68 и подпись снизу.
///
/// Собственную иконку AirPlay нативного вида прячем (передаём прозрачный tint) и
/// поверх рисуем ту же иконку динамика, что и на Android
/// ([HugeIcons.strokeRoundedVolumeHigh]) — для единообразия. HugeIcon обёрнут в
/// [IgnorePointer], чтобы тап проходил на нативный `AVRoutePickerView` под ним и
/// открывал системный пикер.
class RoutePickerButton extends StatelessWidget {
  final String label;

  /// Фон круга (как у обычных кнопок управления).
  final Color backgroundColor;

  /// Цвет накладываемой иконки динамика.
  final Color iconColor;
  final Color activeIconColor;
  final Color labelColor;

  const RoutePickerButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.activeIconColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Иконка динамика (как на Android) — рисуется ПОД нативным видом.
              // На iOS UiKitView композитится поверх Flutter-виджетов, поэтому
              // порядок важен: иконка снизу видна сквозь прозрачный пикер.
              HugeIcon(icon: HugeIcons.strokeRoundedVolumeHigh, color: iconColor, size: 28),
              // Нативный AVRoutePickerView во всю область круга — сверху, ловит
              // тап и открывает системный список маршрутов. Полностью прозрачный:
              // фон .clear (в Swift), собственную иконку гасим прозрачным tint'ом.
              const Positioned.fill(
                child: UiKitView(
                  viewType: 'net.iperon.messenger/route_picker',
                  creationParams: {'tint': 0x00000000, 'activeTint': 0x00000000},
                  creationParamsCodec: StandardMessageCodec(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: labelColor, fontSize: 13)),
      ],
    );
  }
}
