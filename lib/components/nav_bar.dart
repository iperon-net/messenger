import 'package:cupertino_ui/cupertino_ui.dart';

/// Навигационная панель, у которой leading/trailing (кнопка «назад» и действия)
/// в тёмной теме окрашиваются в белый, а в светлой — сохраняют акцентный
/// `primaryColor`.
///
/// [CupertinoNavigationBar] берёт цвет действий из
/// `CupertinoTheme.of(context).primaryColor` (`actionsForegroundColor`),
/// поэтому единственный способ поменять его точечно — подсунуть навбару
/// локальный [CupertinoTheme]. Оборачиваем только сам навбар, тело экрана
/// (`CupertinoPageScaffold.child`) остаётся под глобальной темой и сохраняет
/// настоящий акцентный цвет (галочки выбора, ссылки и т.п.).
///
/// Реализует [ObstructingPreferredSizeWidget], чтобы его можно было передавать
/// напрямую в `CupertinoPageScaffold.navigationBar`.
class AppNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final CupertinoNavigationBar child;

  const AppNavigationBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final base = CupertinoTheme.of(context);

    return CupertinoTheme(
      data: base.copyWith(
        primaryColor: CupertinoDynamicColor.withBrightness(color: base.primaryColor, darkColor: CupertinoColors.white),
      ),
      child: child,
    );
  }

  @override
  Size get preferredSize => child.preferredSize;

  @override
  bool shouldFullyObstruct(BuildContext context) => child.shouldFullyObstruct(context);
}
