import 'package:cupertino_ui/cupertino_ui.dart';

/// Строка списка с нативным контекстным меню iOS по удержанию (строка
/// «приподнимается», фон размывается, под превью — [actions]), как у строки
/// чата (`ChatContextMenuCupertino`). Без действий — просто [child].
class RowContextMenuCupertino extends StatelessWidget {
  final Widget child;
  final List<Widget> actions;

  /// Фон открытого превью (строка в списке обычно прозрачная).
  final Color background;

  const RowContextMenuCupertino({super.key, required this.child, required this.actions, required this.background});

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return child;
    return CupertinoContextMenu.builder(
      enableHapticFeedback: true,
      actions: actions,
      builder: (context, animation) {
        // До animationOpensAt — «нажатие» (строка как в списке), после —
        // открытое превью: непрозрачная карточка со скруглением.
        if (animation.value < CupertinoContextMenu.animationOpensAt) return child;
        final radius = BorderRadiusTween(
          begin: BorderRadius.zero,
          end: BorderRadius.circular(CupertinoContextMenu.kOpenBorderRadius),
        ).animate(CurvedAnimation(parent: animation, curve: Interval(CupertinoContextMenu.animationOpensAt, 1))).value;
        return ClipRRect(
          borderRadius: radius ?? BorderRadius.zero,
          child: ColoredBox(
            color: background,
            // Превью чуть ниже естественной высоты строки — раскладываем по
            // ширине со свободной высотой и ужимаем (как у строки чата).
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (!constraints.hasBoundedWidth) return child;
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: SizedBox(width: constraints.maxWidth, child: child),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// Действие меню [RowContextMenuCupertino]: сначала закрывает меню (маршрут
/// корневого навигатора), потом выполняет [run] — иначе превью «мигнёт» уже
/// изменённой строкой, а диалоги откроются под меню.
CupertinoContextMenuAction rowMenuAction(BuildContext context, String label, IconData icon, VoidCallback run, {bool destructive = false}) {
  return CupertinoContextMenuAction(
    trailingIcon: icon,
    isDestructiveAction: destructive,
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
      run();
    },
    child: Text(label),
  );
}
