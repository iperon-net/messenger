import 'package:cupertino_ui/cupertino_ui.dart';

/// Пункт `CupertinoContextMenu` с вложенными пунктами — как подменю iOS: тап
/// раскрывает [children] прямо в меню под заголовком (шеврон поворачивается),
/// повторный — сворачивает. Сам меню не закрывает: это делают вложенные пункты.
class CupertinoContextSubmenuAction extends StatefulWidget {
  final Widget child;
  final List<Widget> children;
  final bool isDestructiveAction;

  const CupertinoContextSubmenuAction({super.key, required this.child, required this.children, this.isDestructiveAction = false});

  @override
  State<CupertinoContextSubmenuAction> createState() => _CupertinoContextSubmenuActionState();
}

class _CupertinoContextSubmenuActionState extends State<CupertinoContextSubmenuAction> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    // Разделитель — как между пунктами самого меню.
    final border = BoxDecoration(
      border: Border(top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.4)),
    );
    final header = CupertinoContextMenuAction(
      isDestructiveAction: widget.isDestructiveAction,
      trailingIcon: _expanded ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_right,
      onPressed: () => setState(() => _expanded = !_expanded),
      child: widget.child,
    );
    if (!_expanded) return header;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Раскрытый заголовок подсвечен, как у подменю iOS.
        ColoredBox(color: CupertinoColors.tertiarySystemFill.resolveFrom(context), child: header),
        for (final child in widget.children) DecoratedBox(decoration: border, position: DecorationPosition.foreground, child: child),
      ],
    );
  }
}
