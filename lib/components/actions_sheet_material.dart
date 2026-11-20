import 'dart:ui' show ImageFilter;

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
    // Роут не забирает фокус: выделение текста в сообщении остаётся видимым,
    // пока открыто меню (как в Telegram Desktop) — иначе SelectableRegion
    // очищает его при потере фокуса.
    requestFocus: false,
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

/// Оформление меню у курсора: полупрозрачная размытая карточка (frosted, как
/// системное меню macOS и в Telegram), мягкая тень без рамки, воздушные пункты
/// с иконками цвета текста, подсветка пункта под мышью — скруглённая плашка с
/// отступом от краёв.
class _ContextMenu extends StatelessWidget {
  final Widget child;

  const _ContextMenu({required this.child});

  static const width = 280.0;
  static const radius = 12.0;

  /// Полупрозрачная заливка поверх размытия — как в frosted-меню
  /// форматирования (`compose_format_menu.dart`).
  static const _surfaceDark = Color(0xE6252525);
  static const _surfaceLight = Color(0xE6F9F9F9);

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
            color: dark ? Colors.black.withValues(alpha: 0.45) : const Color(0x33000000),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Material(
            color: dark ? _surfaceDark : _surfaceLight,
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
                    minTileHeight: 44,
                    minLeadingWidth: 24,
                    horizontalTitleGap: 12,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    iconColor: scheme.onSurface,
                    titleTextStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, color: scheme.onSurface),
                  ),
                  iconTheme: theme.iconTheme.copyWith(size: 20),
                  hoverColor: scheme.onSurface.withValues(alpha: 0.07),
                ),
                child: IconTheme.merge(
                  data: const IconThemeData(size: 20),
                  child: SingleChildScrollView(padding: const EdgeInsets.all(5), child: child),
                ),
              ),
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
  static const _cursorGap = 6.0;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(constraints.biggest).deflate(const EdgeInsets.all(_margin));

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    var x = at.dx + _cursorGap;
    var y = at.dy;
    if (x + childSize.width > size.width - _margin) x = at.dx - childSize.width - _cursorGap;
    if (y + childSize.height > size.height - _margin) y = at.dy - childSize.height;
    return Offset(
      x.clamp(_margin, (size.width - childSize.width - _margin).clamp(_margin, double.infinity)),
      y.clamp(_margin, (size.height - childSize.height - _margin).clamp(_margin, double.infinity)),
    );
  }

  @override
  bool shouldRelayout(_MenuLayout oldDelegate) => oldDelegate.at != at;
}
