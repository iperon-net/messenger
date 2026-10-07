import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Частица пыли: место в прямоугольнике строки (доли 0..1), направление и
/// скорость дрейфа, фаза мерцания.
typedef SpoilerParticle = ({double x, double y, double dx, double dy, double phase, double rate});

/// Частицы по прямоугольникам скрытого — пересоздаются, только когда
/// прямоугольники поменялись (перенос строк, другая ширина). Держать в State,
/// чтобы частицы не «перемешивались» на каждом кадре.
class SpoilerDust {
  List<Rect> _rects = const [];
  List<List<SpoilerParticle>> particles = const [];

  /// Одна частица примерно на столько квадратных пикселей.
  static const _area = 9.0;

  double _density = 1;

  List<List<SpoilerParticle>> of(List<Rect> rects, [double density = 1]) {
    if (_sameRects(rects) && density == _density) return particles;
    _density = density;
    _rects = rects;
    particles = [
      for (final (i, rect) in rects.indexed)
        _generate(rect, density, math.Random(i * 7919 + rect.width.round() * 31 + rect.height.round())),
    ];
    return particles;
  }

  bool _sameRects(List<Rect> rects) {
    if (rects.length != _rects.length) return false;
    for (var i = 0; i < rects.length; i++) {
      if ((rects[i].topLeft - _rects[i].topLeft).distance > 0.5 ||
          (rects[i].width - _rects[i].width).abs() > 0.5 ||
          (rects[i].height - _rects[i].height).abs() > 0.5) {
        return false;
      }
    }
    return true;
  }

  static List<SpoilerParticle> _generate(Rect rect, double density, math.Random random) {
    final count = (rect.width * rect.height * density / _area).clamp(4, 2500).round();
    return [
      for (var i = 0; i < count; i++)
        () {
          final angle = random.nextDouble() * math.pi * 2;
          final speed = 2 + random.nextDouble() * 5; // пикселей в секунду
          return (
            x: random.nextDouble(),
            y: random.nextDouble(),
            dx: math.cos(angle) * speed,
            dy: math.sin(angle) * speed,
            phase: random.nextDouble() * math.pi * 2,
            rate: 1.5 + random.nextDouble() * 2.5,
          );
        }(),
    ];
  }
}

/// Пыль спойлера (как в Telegram) поверх скрытого: частицы дрейфуют внутри
/// своих прямоугольников [rectsOf] и мерцают; при раскрытии ([reveal] 0→1)
/// исчезают кругом, расходящимся от [origin]. Текст — строки спойлера,
/// фото — весь кадр.
class SpoilerDustPainter extends CustomPainter {
  final List<Rect> Function(Size size) rectsOf;
  final SpoilerDust dust;
  final ValueNotifier<double> time;
  final Color color;
  final double reveal;
  final Offset? origin;

  /// Частиц на квадратный пиксель меньше на крупных картинках.
  final double density;

  SpoilerDustPainter({
    required this.rectsOf,
    required this.dust,
    this.density = 1,
    required this.time,
    required this.color,
    required this.reveal,
    required this.origin,
  }) : super(repaint: time);

  /// Уровни яркости: частицы группируются по ним, чтобы рисовать
  /// несколькими `drawRawPoints`, а не тысячей кругов.
  static const _levels = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final rects = rectsOf(size);
    final groups = dust.of(rects, density);
    final t = time.value;
    final buckets = List.generate(_levels, (_) => <double>[]);
    final radius = reveal == 0 ? 0.0 : reveal * (size.longestSide + 40);
    for (final (i, rect) in rects.indexed) {
      for (final p in groups[i]) {
        final x = rect.left + _wrap(p.x * rect.width + p.dx * t, rect.width);
        final y = rect.top + _wrap(p.y * rect.height + p.dy * t, rect.height);
        if (radius > 0 && origin != null && (Offset(x, y) - origin!).distance < radius) continue;
        final glow = 0.5 + 0.5 * math.sin(t * p.rate + p.phase);
        buckets[(glow * (_levels - 1)).round()]
          ..add(x)
          ..add(y);
      }
    }
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.4;
    for (var level = 0; level < _levels; level++) {
      if (buckets[level].isEmpty) continue;
      paint.color = color.withValues(alpha: color.a * (0.25 + 0.75 * level / (_levels - 1)));
      canvas.drawRawPoints(ui.PointMode.points, Float32List.fromList(buckets[level]), paint);
    }
  }

  static double _wrap(double value, double extent) {
    if (extent <= 0) return 0;
    final r = value % extent;
    return r < 0 ? r + extent : r;
  }

  @override
  bool shouldRepaint(SpoilerDustPainter old) => old.reveal != reveal || old.color != color || old.origin != origin;
}

/// Фото/видео под спойлером: кадр размыт, сверху мерцает пыль; тап —
/// раскрыть (размытие уходит, пыль расходится кругом от пальца), следующие
/// тапы уже открывают просмотр. [enabled] `false` — обычный кадр.
class MediaSpoiler extends StatefulWidget {
  final bool enabled;
  final Widget child;

  const MediaSpoiler({super.key, required this.enabled, required this.child});

  @override
  State<MediaSpoiler> createState() => _MediaSpoilerState();
}

class _MediaSpoilerState extends State<MediaSpoiler> with TickerProviderStateMixin {
  static const _blur = 22.0;

  final _dust = SpoilerDust();
  final _time = ValueNotifier<double>(0);
  late final Ticker _ticker = createTicker((elapsed) => _time.value = elapsed.inMicroseconds / 1e6);
  late final _reveal = AnimationController(vsync: this, duration: const Duration(milliseconds: 550))
    ..addListener(() => setState(() {}))
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) _ticker.stop();
    });
  bool _revealed = false;
  Offset? _origin;

  @override
  void dispose() {
    _ticker.dispose();
    _reveal.dispose();
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hidden = widget.enabled && !_reveal.isCompleted;
    if (hidden && !_ticker.isActive) _ticker.start();
    final progress = Curves.easeOut.transform(_reveal.value);
    final sigma = _blur * (1 - progress);
    // Дерево одно и то же до и после раскрытия — кадр (Hero, картинка) не
    // пересоздаётся.
    return ClipRect(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          ImageFiltered(
            enabled: hidden && sigma > 0.1,
            imageFilter: ui.ImageFilter.blur(sigmaX: math.max(sigma, 0.1), sigmaY: math.max(sigma, 0.1)),
            child: widget.child,
          ),
          if (hidden)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                // Тап раскрывает и не доходит до просмотра.
                onTapUp: _revealed
                    ? null
                    : (details) {
                        setState(() {
                          _revealed = true;
                          _origin = details.localPosition;
                        });
                        _reveal.forward();
                      },
                child: ColoredBox(
                  color: Color.fromRGBO(0, 0, 0, 0.12 * (1 - progress)),
                  child: CustomPaint(
                    painter: SpoilerDustPainter(
                      rectsOf: (size) => [Offset.zero & size],
                      dust: _dust,
                      time: _time,
                      color: const Color(0xFFFFFFFF),
                      density: 0.35,
                      reveal: _reveal.value,
                      origin: _origin,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
