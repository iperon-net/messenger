import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../settings/settings_accounts_cupertino.dart';
import 'calls_tab_menu.dart';

/// Вертикальный таб-бар (рейл) на внешнем экране складного iPhone (iPhone Duo):
/// паттерн Duo «vertical controls» — вкладки уходят на край системной полосы
/// (Island + статус), освобождая высоту короткого экрана. Полоса следует за
/// поворотом устройства (портрет — справа, landscape — слева), сторона задаётся
/// родителем ([onLeft]). Экранные навбары и ввод остаются горизонтально: они
/// относятся к контенту («controls near the content they affect»). Долгий тап
/// по «Звонкам» / «Настройкам» — те же меню, что у нижнего бара ([CallsTabMenu] /
/// [AccountSwitcherCupertino] поверх соответствующих строк); обычный тап
/// проходит сквозь прозрачный оверлей к строке рейла. Родитель задаёт полосу
/// под системный статус (`Positioned(top: 0, bottom: 0, width: …)` у нужного
/// края); ширина — горизонтальный инсет safe area.
class DuoTabRail extends StatelessWidget {
  const DuoTabRail({super.key, required this.currentIndex, required this.onTap, this.onLeft = false});

  /// Круг вкладки: активная залита акцентом с белой иконкой (паттерн
  /// NavigationRail в палитре приложения), неактивная — серая иконка без круга.
  /// Диаметр под масштаб системных индикаторов полосы (Wi-Fi и статус).
  static const circleSize = 40.0;

  /// Кнопки сгруппированы в кластер по центру полосы: тап-зон кнопки 44 pt
  /// (минимум HIG), зазор между кругами 24 pt.
  static const itemSize = 44.0;
  static const itemGap = 24.0;

  /// Системная колонка статуса (время, Wi-Fi) центрируется в ~48 pt от края
  /// окна, а safe-area инсет полосы — ~84 pt (центр рейла ~42 pt): сдвигаем
  /// содержимое на 6 pt вглубь полосы, чтобы круги стояли в одну колонку с
  /// индикатором сети (замер на симуляторе; чисто визуальный сдвиг, тап-зоны
  /// не трогаем). Направление — от края рейла: справа — влево, слева — вправо.
  static const centerShift = 6.0;

  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Полоса статуса у ЛЕВОГО края (landscape сложенного устройства).
  final bool onLeft;

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenHome;
    final selected = CupertinoTheme.of(context).primaryColor;
    const unselected = CupertinoColors.inactiveGray;
    final labels = [t.contacts, t.calls, t.chats, t.settings];
    final icons = [
      HugeIcon(icon: HugeIcons.strokeRoundedUserCircle, size: 26, strokeWidth: 2),
      HugeIcon(icon: HugeIcons.strokeRoundedCall02, size: 26, strokeWidth: 2),
      UnreadTabIconCupertino(icon: HugeIcon(icon: HugeIcons.strokeRoundedChatFeedback01, size: 26, strokeWidth: 2)),
      HugeIcon(icon: HugeIcons.strokeRoundedSettings01, size: 26, strokeWidth: 2),
    ];
    // Оверлеи долгого тапа — по строкам «Звонки» (1) и «Настройки» (3).
    final overlays = {1: const CallsTabMenu(), 3: const AccountSwitcherCupertino()};

    // Панель во всю высоту полосы — от самого верха: элементы статуса (камера,
    // время, Wi-Fi) рисуются системой поверх неё, поэтому шва «обои → панель»,
    // который возникал, когда панель начиналась ниже статуса, больше нет.
    // Полоса читается единой колонкой: статус → кнопки → низ; ввод сообщения
    // у края полосы перестаёт выглядеть обрезанным. Цвет — полупрозрачный серый
    // таб-бара (обои чуть проступают, как под нижним баром). Рейл уже сидит
    // внутри системной полосы (родитель позиционирует его по инсету у нужного
    // края): SafeArea здесь повторно применил бы горизонтальные инсеты и сжал
    // строки до ширины буквы. Нужен только отступ от домашнего индикатора.
    return ColoredBox(
      color: ThemesCupertino.tabBarBackground.resolveFrom(context),
      child: Transform.translate(
        // Центр колонки кнопок — в одну линию с системным статусом: от края
        // рейла сдвигаем содержимое вглубь полосы (справа — влево, слева —
        // вправо), см. [centerShift].
        offset: Offset(onLeft ? centerShift : -centerShift, 0),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
          // Кластер из четырёх кругов по центру полосы: фиксированный зазор
          // между кнопками вместо растяжения на всю высоту.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < icons.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: i == icons.length - 1 ? 0 : itemGap),
                  child: SizedBox(
                    width: itemSize,
                    height: itemSize,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onTap(i),
                          // Иконки без подписей — на узкой полосе подписи теснились и
                          // дублировали смысл иконки; для VoiceOver подпись остаётся
                          // в семантике. Кружки-подложки не нужны — иконки сидят
                          // прямо на панели полосы.
                          child: Center(
                            child: Semantics(
                              label: labels[i],
                              child: Container(
                                width: circleSize,
                                height: circleSize,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: i == currentIndex ? selected : null),
                                child: IconTheme(
                                  data: IconThemeData(color: i == currentIndex ? CupertinoColors.white : unselected),
                                  child: icons[i],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (overlays[i] != null) Positioned.fill(child: overlays[i]!),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
