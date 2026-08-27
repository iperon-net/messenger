import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';

/// Оборачивает [child] и показывает мини-баннер («пузырёк») с надписью
/// «Скопировать» при тапе — как в iOS-контактах / Telegram. По нажатию на
/// баннер значение [value] копируется в буфер обмена, после чего вызывается
/// необязательный [onCopied] (например, чтобы показать «Скопировано»).
class CopyTooltip extends StatefulWidget {
  const CopyTooltip({super.key, required this.value, required this.label, required this.child, this.onCopied});

  /// Текст, который копируется в буфер обмена.
  final String value;

  /// Надпись на баннере (например, «Скопировать»).
  final String label;

  /// Виджет, по которому происходит тап.
  final Widget child;

  /// Вызывается после копирования (для тоста «Скопировано» и т.п.).
  final VoidCallback? onCopied;

  @override
  State<CopyTooltip> createState() => _CopyTooltipState();
}

class _CopyTooltipState extends State<CopyTooltip> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  @override
  void dispose() {
    _remove();
    super.dispose();
  }

  void _remove() {
    _entry?.remove();
    _entry = null;
  }

  void _show() {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Прозрачный барьер: тап мимо — закрыть баннер.
            Positioned.fill(
              child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: _remove),
            ),
            CompositedTransformFollower(
              link: _link,
              // Пузырёк центрируется над полем.
              targetAnchor: Alignment.topCenter,
              followerAnchor: Alignment.bottomCenter,
              offset: const Offset(0, -6),
              child: _Bubble(
                label: widget.label,
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: widget.value));
                  _remove();
                  widget.onCopied?.call();
                },
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: _show, child: widget.child),
    );
  }
}

/// Тёмный пузырёк с надписью и «хвостиком» снизу.
class _Bubble extends StatelessWidget {
  const _Bubble({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF2B2B2E);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 4))],
            ),
            child: Text(
              label,
              style: const TextStyle(color: CupertinoColors.white, fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
          // Треугольный «хвостик» пузырька.
          CustomPaint(size: const Size(14, 7), painter: _TrianglePainter(background)),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) => oldDelegate.color != color;
}
