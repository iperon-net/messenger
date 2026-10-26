import 'package:material_ui/material_ui.dart';

import '../platform.dart';

/// Где последний раз нажали мышью (десктоп): там открывается контекстное меню.
/// Пишет `Listener` в корне приложения (`app_material.dart`).
abstract final class DesktopPointer {
  static Offset? last;
}

/// Меню действий (Android / десктоп): на телефоне — шторка снизу, на десктопе —
/// контекстное меню у курсора (правый клик), как в Telegram Desktop. [builder]
/// тот же для обоих — список `ListTile`, выбор закрывает через
/// `Navigator.of(context).pop(value)`.
Future<T?> showActionsMaterial<T>({required BuildContext context, required WidgetBuilder builder, bool isScrollControlled = false}) {
  final at = DesktopPointer.last;
  if (!AppPlatform.isDesktop || at == null) {
    return showModalBottomSheet<T>(context: context, showDragHandle: true, isScrollControlled: isScrollControlled, builder: builder);
  }
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 140),
    pageBuilder: (menuContext, _, _) => CustomSingleChildLayout(
      delegate: _MenuLayout(at),
      child: _ContextMenu(child: builder(menuContext)),
    ),
    // Как системное меню: быстро проявляется и чуть «вырастает».
    transitionBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(scale: Tween(begin: 0.96, end: 1.0).animate(curved), child: child),
      );
    },
  );
}

/// Оформление меню у курсора: скруглённая карточка с тонкой рамкой и мягкой
/// тенью, компактные пункты с приглушёнными иконками, подсветка пункта под
/// мышью — скруглённая плашка с отступом от краёв (как в macOS и Telegram
/// Desktop).
class _ContextMenu extends StatelessWidget {
  final Widget child;

  const _ContextMenu({required this.child});

  static const width = 260.0;
  static const radius = 12.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.45 : 0.14),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.3 : 0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: dark ? scheme.surfaceContainerHigh : scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: dark ? 0.5 : 0.7), width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: width,
          child: Theme(
            data: theme.copyWith(
              dividerTheme: DividerThemeData(space: 9, thickness: 0.5, indent: 12, endIndent: 12, color: scheme.outlineVariant),
              listTileTheme: ListTileThemeData(
                dense: true,
                visualDensity: VisualDensity.compact,
                minVerticalPadding: 0,
                minTileHeight: 34,
                minLeadingWidth: 20,
                horizontalTitleGap: 10,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                iconColor: scheme.onSurfaceVariant,
                titleTextStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 14, color: scheme.onSurface),
              ),
              iconTheme: theme.iconTheme.copyWith(size: 18),
              hoverColor: scheme.onSurface.withValues(alpha: 0.07),
            ),
            child: IconTheme.merge(
              data: const IconThemeData(size: 18),
              child: SingleChildScrollView(padding: const EdgeInsets.all(5), child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// У курсора: вправо-вниз от него, а не влезает — влево / вверх, с отступом от
/// краёв окна.
class _MenuLayout extends SingleChildLayoutDelegate {
  final Offset at;

  const _MenuLayout(this.at);

  static const _margin = 8.0;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(constraints.biggest).deflate(const EdgeInsets.all(_margin));

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    var x = at.dx;
    var y = at.dy;
    if (x + childSize.width > size.width - _margin) x = at.dx - childSize.width;
    if (y + childSize.height > size.height - _margin) y = at.dy - childSize.height;
    return Offset(
      x.clamp(_margin, (size.width - childSize.width - _margin).clamp(_margin, double.infinity)),
      y.clamp(_margin, (size.height - childSize.height - _margin).clamp(_margin, double.infinity)),
    );
  }

  @override
  bool shouldRelayout(_MenuLayout oldDelegate) => oldDelegate.at != at;
}
