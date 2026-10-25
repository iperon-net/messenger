import 'package:flutter/widgets.dart';

/// Ограничивает ширину контента на широком экране (iPad, планшет, Split View
/// на всю ширину) и ставит его по центру: формы и списки не растягиваются на
/// 1000+ точек. Уже [maxWidth] — ничего не меняет (телефон), высота остаётся
/// жёсткой, так что `Expanded` / `ListView` внутри ведут себя как раньше.
class ReadableWidth extends StatelessWidget {
  const ReadableWidth({super.key, this.maxWidth = 480, required this.child});

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final extra = constraints.maxWidth - maxWidth;
      if (!constraints.hasBoundedWidth || extra <= 0) return child;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: extra / 2),
        child: child,
      );
    },
  );
}
