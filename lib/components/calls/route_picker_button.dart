import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../i18n/translations.g.dart';

/// iOS: круглая кнопка выбора аудио-выхода звонка — обёртка над нативным
/// `AVRoutePickerView` (см. AppDelegate.RoutePickerViewFactory). По тапу система
/// сама показывает список маршрутов (iPhone / Speaker / Bluetooth / CarPlay /
/// AirPlay). Стилизована как `_CircleButton` на экране звонка: круг 68×68 и
/// подпись снизу.
///
/// Иконка/подпись фиксированы (динамик) — для единообразия с Android и чтобы не
/// зависеть от отслеживания активного маршрута. Собственную иконку AirPlay
/// нативного вида гасим (прозрачный tint), сам вид кладём ПОВЕРХ прозрачным слоем
/// — на iOS UiKitView композитится над Flutter-виджетами, поэтому наша иконка
/// снизу видна сквозь него, а тап попадает на нативный пикер.
class RoutePickerButton extends StatelessWidget {
  /// Фон круга (как у обычных кнопок управления).
  final Color backgroundColor;

  /// Цвет иконки и подписи.
  final Color iconColor;
  final Color labelColor;

  const RoutePickerButton({super.key, required this.backgroundColor, required this.iconColor, required this.labelColor});

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
              // Иконка динамика — рисуется ПОД нативным видом (см. док класса про
              // порядок композитинга UiKitView на iOS).
              HugeIcon(icon: HugeIcons.strokeRoundedSpeaker, color: iconColor, size: 28),
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
        Text(context.t.screenCall.audioOutput, style: TextStyle(color: labelColor, fontSize: 13)),
      ],
    );
  }
}
