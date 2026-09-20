import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// iOS: круглая кнопка выбора аудио-выхода звонка — обёртка над нативным
/// `AVRoutePickerView` (см. ios/Runner/RoutePickerViewFactory.swift). По тапу
/// система сама показывает список маршрутов (iPhone / Speaker / Bluetooth /
/// CarPlay / AirPlay). Стилизована как [_CircleButton] на экране звонка: тот же
/// круг 68×68 и подпись снизу; иконку рисует сам нативный вид, поэтому её цвета
/// передаём через creationParams.
class RoutePickerButton extends StatelessWidget {
  final String label;

  /// Фон круга (как у обычных кнопок управления).
  final Color backgroundColor;

  /// Цвет иконки маршрута в обычном состоянии и когда активен внешний маршрут
  /// (BT/AirPlay/CarPlay) — `activeTint` у AVRoutePickerView.
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

  static int _argb(Color c) => c.toARGB32();

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
          child: SizedBox(
            width: 34,
            height: 34,
            child: UiKitView(
              viewType: 'net.iperon.messenger/route_picker',
              creationParams: {'tint': _argb(iconColor), 'activeTint': _argb(activeIconColor)},
              creationParamsCodec: const StandardMessageCodec(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: labelColor, fontSize: 13)),
      ],
    );
  }
}
