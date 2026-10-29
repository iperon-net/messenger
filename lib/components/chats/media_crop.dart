import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../i18n/translations.g.dart';

/// Общее у редакторов видео и фото перед отправкой: рамка кадрирования,
/// пресеты соотношения сторон и кнопки панели инструментов.
abstract final class MediaCrop {
  /// Весь кадр (в долях кадра).
  static const full = Rect.fromLTWH(0, 0, 1, 1);

  /// Пресеты рамки: `null` — свободно, 0 — как у исходника, иначе ширина/высота
  /// (для вертикальной рамки — наоборот).
  static const aspects = <double?>[null, 0, 1, 4 / 3, 16 / 9];

  static String aspectLabel(Translations t, int index) => switch (index) {
    0 => t.screenChat.videoAspectFree,
    1 => t.screenChat.videoAspectOriginal,
    2 => t.screenChat.videoAspectSquare,
    3 => '4:3',
    _ => '16:9',
  };

  /// Размеры кадра после кадрирования [crop] и поворота [rotation] для
  /// исходника [width]×[height].
  static ({double width, double height}) frameSize(Rect? crop, int rotation, num width, num height) {
    final c = crop ?? full;
    final w = width * c.width;
    final h = height * c.height;
    return rotation % 180 == 0 ? (width: w, height: h) : (width: h, height: w);
  }

  /// Зафиксированное пресетом [aspect] (индекс в [aspects]) отношение ширины
  /// рамки к высоте в долях кадра исходника с соотношением сторон
  /// [sourceAspect]; `null` — свободно.
  static double? lockedRatio(int aspect, {required Rect? crop, required int rotation, required double sourceAspect}) {
    final value = aspects[aspect];
    if (value == null) return null;
    if (value == 0) return 1;
    // Ориентация — как у текущей рамки на экране (с поворотом).
    final frame = frameSize(crop, rotation, sourceAspect, 1);
    final visible = frame.height > frame.width ? 1 / value : value;
    final unrotated = rotation % 180 == 0 ? visible : 1 / visible;
    return unrotated / sourceAspect;
  }

  /// Самая большая рамка с соотношением [ratio] вокруг центра [crop].
  static Rect? fitRatio(double ratio, Rect? crop) {
    final center = (crop ?? full).center;
    final width = ratio >= 1 ? 1.0 : ratio;
    final height = ratio >= 1 ? 1 / ratio : 1.0;
    final left = (center.dx - width / 2).clamp(0.0, 1 - width);
    final top = (center.dy - height / 2).clamp(0.0, 1 - height);
    return normalized(Rect.fromLTWH(left, top, width, height));
  }

  /// Рамка почти во весь кадр — без кадрирования.
  static Rect? normalized(Rect? crop) {
    if (crop == null) return null;
    const eps = 0.005;
    final whole = crop.left < eps && crop.top < eps && crop.right > 1 - eps && crop.bottom > 1 - eps;
    return whole ? null : crop;
  }
}

/// Кнопка панели инструментов редактора: значок и подпись под ним.
class MediaEditToolButton extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const MediaEditToolButton({super.key, required this.icon, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ),
    );
  }
}

/// Пресеты соотношения сторон рамки ([MediaCrop.aspects]); [selected] —
/// выбранный, [accent] / [onAccent] — его заливка и текст.
class MediaAspectChips extends StatelessWidget {
  final int selected;
  final Color accent;
  final Color onAccent;
  final ValueChanged<int> onSelected;

  const MediaAspectChips({super.key, required this.selected, required this.accent, required this.onAccent, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SizedBox(
      height: 80,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (var i = 0; i < MediaCrop.aspects.length; i++)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: i == selected ? accent : const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      MediaCrop.aspectLabel(t, i),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: i == selected ? onAccent : null),
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

/// Кадр с правками редактора: показывает только кадрированную часть [child]
/// (кадр исходника с соотношением сторон [sourceAspect], растянутый на всю
/// площадь) и поворачивает её на [rotation]. Размер — по соотношению сторон
/// результата; используется в редакторах и в миниатюре перед отправкой.
class ChatVideoReframe extends StatelessWidget {
  final Rect? crop;
  final int rotation;
  final double sourceAspect;
  final Widget child;

  const ChatVideoReframe({super.key, required this.crop, required this.rotation, required this.sourceAspect, required this.child});

  @override
  Widget build(BuildContext context) {
    final crop = this.crop ?? MediaCrop.full;
    return RotatedBox(
      quarterTurns: rotation ~/ 90,
      child: AspectRatio(
        aspectRatio: sourceAspect * crop.width / crop.height,
        child: LayoutBuilder(
          builder: (context, box) {
            final width = box.maxWidth / crop.width;
            final height = box.maxHeight / crop.height;
            return ClipRect(
              child: Stack(
                clipBehavior: Clip.none,
                children: [Positioned(left: -crop.left * width, top: -crop.top * height, width: width, height: height, child: child)],
              ),
            );
          },
        ),
      ),
    );
  }
}

enum _CropHandle { topLeft, topRight, bottomLeft, bottomRight, left, top, right, bottom, move }

/// Рамка кадрирования поверх кадра: углы и стороны меняют размер (при
/// зафиксированном соотношении [ratio] — только углы), протяжка внутри
/// двигает рамку. [rect] и [ratio] — в долях кадра.
class MediaCropOverlay extends StatefulWidget {
  final Rect rect;
  final double? ratio;
  final ValueChanged<Rect> onChanged;

  const MediaCropOverlay({super.key, required this.rect, required this.ratio, required this.onChanged});

  @override
  State<MediaCropOverlay> createState() => _MediaCropOverlayState();
}

class _MediaCropOverlayState extends State<MediaCropOverlay> {
  /// Запас попадания по углу / стороне.
  static const _hit = 28.0;

  /// Меньше рамку не делаем, px.
  static const _minSide = 56.0;

  _CropHandle? _handle;
  Offset _last = Offset.zero;

  static double _fit(double value, double low, double high) => math.min(math.max(value, low), high);

  _CropHandle? _hitTest(Offset p, Size size) {
    final r = Rect.fromLTRB(
      widget.rect.left * size.width,
      widget.rect.top * size.height,
      widget.rect.right * size.width,
      widget.rect.bottom * size.height,
    );
    bool near(double a, double b) => (a - b).abs() <= _hit;
    final left = near(p.dx, r.left);
    final right = near(p.dx, r.right);
    final top = near(p.dy, r.top);
    final bottom = near(p.dy, r.bottom);
    if (left && top) return _CropHandle.topLeft;
    if (right && top) return _CropHandle.topRight;
    if (left && bottom) return _CropHandle.bottomLeft;
    if (right && bottom) return _CropHandle.bottomRight;
    if (widget.ratio == null) {
      final inX = p.dx > r.left && p.dx < r.right;
      final inY = p.dy > r.top && p.dy < r.bottom;
      if (left && inY) return _CropHandle.left;
      if (right && inY) return _CropHandle.right;
      if (top && inX) return _CropHandle.top;
      if (bottom && inX) return _CropHandle.bottom;
    }
    return r.contains(p) ? _CropHandle.move : null;
  }

  void _update(Offset p, Size size) {
    final handle = _handle;
    if (handle == null) return;
    final x = _fit(p.dx / size.width, 0, 1);
    final y = _fit(p.dy / size.height, 0, 1);
    final minW = math.min(1.0, _minSide / size.width);
    final minH = math.min(1.0, _minSide / size.height);
    final r = widget.rect;
    final ratio = widget.ratio;
    Rect next;
    switch (handle) {
      case _CropHandle.move:
        final d = p - _last;
        next = Rect.fromLTWH(
          _fit(r.left + d.dx / size.width, 0, 1 - r.width),
          _fit(r.top + d.dy / size.height, 0, 1 - r.height),
          r.width,
          r.height,
        );
      case _CropHandle.left:
        next = Rect.fromLTRB(_fit(x, 0, r.right - minW), r.top, r.right, r.bottom);
      case _CropHandle.right:
        next = Rect.fromLTRB(r.left, r.top, _fit(x, r.left + minW, 1), r.bottom);
      case _CropHandle.top:
        next = Rect.fromLTRB(r.left, _fit(y, 0, r.bottom - minH), r.right, r.bottom);
      case _CropHandle.bottom:
        next = Rect.fromLTRB(r.left, r.top, r.right, _fit(y, r.top + minH, 1));
      case _CropHandle.topLeft || _CropHandle.topRight || _CropHandle.bottomLeft || _CropHandle.bottomRight:
        final toRight = handle == _CropHandle.topRight || handle == _CropHandle.bottomRight;
        final toBottom = handle == _CropHandle.bottomLeft || handle == _CropHandle.bottomRight;
        // Противоположный угол стоит на месте.
        final ax = toRight ? r.left : r.right;
        final ay = toBottom ? r.top : r.bottom;
        final maxW = toRight ? 1 - ax : ax;
        final maxH = toBottom ? 1 - ay : ay;
        var w = _fit((x - ax).abs(), minW, maxW);
        var h = _fit((y - ay).abs(), minH, maxH);
        if (ratio != null) {
          // Ширина ведёт, высота — по соотношению; не влезла — наоборот.
          h = w / ratio;
          if (h > maxH || h < minH) {
            h = _fit(h, minH, maxH);
            w = math.min(h * ratio, maxW);
          }
        }
        next = Rect.fromLTWH(toRight ? ax : ax - w, toBottom ? ay : ay - h, w, h);
    }
    _last = p;
    if (next != r) widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (d) {
            _last = d.localPosition;
            setState(() => _handle = _hitTest(d.localPosition, size));
          },
          onPanUpdate: (d) => _update(d.localPosition, size),
          onPanEnd: (_) => setState(() => _handle = null),
          onPanCancel: () => setState(() => _handle = null),
          child: CustomPaint(
            size: size,
            painter: _CropPainter(
              rect: Rect.fromLTRB(
                widget.rect.left * size.width,
                widget.rect.top * size.height,
                widget.rect.right * size.width,
                widget.rect.bottom * size.height,
              ),
              active: _handle != null,
            ),
          ),
        );
      },
    );
  }
}

class _CropPainter extends CustomPainter {
  final Rect rect;

  /// Тянут рамку — сетка ярче.
  final bool active;

  const _CropPainter({required this.rect, required this.active});

  @override
  void paint(Canvas canvas, Size size) {
    const white = Color(0xFFFFFFFF);
    // Вне рамки — затемнение.
    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(Offset.zero & size)
        ..addRect(rect),
      Paint()..color = const Color(0x99000000),
    );

    // Сетка третей.
    final grid = Paint()
      ..color = active ? const Color(0xB3FFFFFF) : const Color(0x4DFFFFFF)
      ..strokeWidth = 0.8;
    for (var i = 1; i < 3; i++) {
      final x = rect.left + rect.width * i / 3;
      final y = rect.top + rect.height * i / 3;
      canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), grid);
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), grid);
    }

    canvas.drawRect(
      rect,
      Paint()
        ..color = white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Уголки.
    const length = 20.0;
    const thickness = 3.0;
    final corner = Paint()
      ..color = white
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.square;
    final inset = thickness / 2;
    final l = rect.left - inset;
    final t = rect.top - inset;
    final r = rect.right + inset;
    final b = rect.bottom + inset;
    final lx = math.min(length, rect.width / 2);
    final ly = math.min(length, rect.height / 2);
    for (final (x, y, dx, dy) in [(l, t, 1.0, 1.0), (r, t, -1.0, 1.0), (l, b, 1.0, -1.0), (r, b, -1.0, -1.0)]) {
      canvas.drawPath(
        Path()
          ..moveTo(x + dx * lx, y)
          ..lineTo(x, y)
          ..lineTo(x, y + dy * ly),
        corner,
      );
    }
  }

  @override
  bool shouldRepaint(_CropPainter old) => old.rect != rect || old.active != active;
}
