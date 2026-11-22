import 'package:cupertino_ui/cupertino_ui.dart';

import '../split_layout.dart';
import '../themes.dart';

/// Вкладка на iPad (см. [SplitLayout]): на широком окне слева [list] (под ним
/// таб-бар `HomeCupertino` — отсюда нижний отступ списка), справа [child] —
/// навигатор правой панели; на узком (Slide Over, Split View) — только [child],
/// как на iPhone. [selected] — что открыто справа, для подсветки строки
/// (см. [SplitSelection]).
class SplitViewCupertino extends StatelessWidget {
  final Widget list;
  final Widget child;
  final String selected;

  const SplitViewCupertino({super.key, required this.list, required this.child, this.selected = ''});

  @override
  Widget build(BuildContext context) {
    if (!SplitLayout.isWide(context)) return SplitPaneScope(child: child);
    final media = MediaQuery.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: SplitLayout.listWidth(media.size.width),
          child: MediaQuery(
            // Горизонтальные инсеты окна (на складном iPhone справа ~100 pt —
            // полоса статуса/камеры) относятся к краю ОКНА; правый край колонки
            // списка — середина экрана, инсет туда не относится. На iPhone он
            // всегда был 0, поэтому здесь это никогда не проявлялось. Нижний
            // (домашний индикатор) остаётся — он у края снизу, под обеими
            // панелями; высота нижнего бара не резервируется, когда на этом
            // экране вместо бара вертикальный рейл (SplitLayout.duoRail).
            data: media.copyWith(
              padding: media.padding.copyWith(
                bottom: media.padding.bottom + (SplitLayout.duoRail(context) ? 0 : SplitLayout.tabBarHeight),
                left: 0,
                right: 0,
              ),
            ),
            child: SplitSelection(id: selected, child: list),
          ),
        ),
        ColoredBox(color: CupertinoColors.separator.resolveFrom(context), child: const SizedBox(width: 0.5)),
        Expanded(child: SplitPaneScope(child: child)),
      ],
    );
  }
}

/// Корень правой панели, пока справа ничего не открыто: «Выберите чат» и т.п.
class SplitEmptyCupertino extends StatelessWidget {
  final String text;
  final CupertinoDynamicColor background;

  const SplitEmptyCupertino({super.key, required this.text, this.background = ThemesCupertino.appBackground});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
        ),
      ),
    );
  }
}
