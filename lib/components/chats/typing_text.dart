import 'package:flutter/widgets.dart';

/// «печатает…» с бегущими точками (шапка чата и строка списка): текст без
/// «…» и три точки, загорающиеся по очереди. Погасшие — прозрачные, ширина
/// постоянная — строка не дёргается.
class TypingText extends StatefulWidget {
  /// Подпись, как из `ChatTileContent.typing` (с «…» на конце).
  final String text;
  final TextStyle style;

  const TypingText(this.text, {super.key, required this.style});

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    final base = text.endsWith('…') ? text.substring(0, text.length - 1) : text;
    final hidden = widget.style.copyWith(color: const Color(0x00000000));
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // 0 → 1 → 2 → 3 точки и заново.
        final shown = (_controller.value * 4).floor();
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: base),
              for (var i = 0; i < 3; i++) TextSpan(text: '.', style: i < shown ? null : hidden),
            ],
          ),
          style: widget.style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
