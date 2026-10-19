import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../device_performance.dart';

/// Эффект «рассыпания в пыль» при удалении (как в Telegram): снимок элемента
/// бьётся на частицы-кусочки, они волной слева направо уносятся вверх-вправо и
/// гаснут. Рисуется в оверлее поверх экрана, поэтому сам элемент можно сразу
/// убрать из списка — соседние строки подъезжают под пылью.
///
/// Порядок: [DustEffect.capture] ДО удаления (пока элемент на экране), само
/// удаление (серверное — может не пройти), при успехе — [DustEffect.play]; при
/// неудаче — [DustSnapshot.dispose].
abstract final class DustEffect {
  static const duration = Duration(milliseconds: 1100);

  /// Снимок ближайшего [DustSource] под [context] (сам элемент или его
  /// потомок). `null` — элемента нет на экране, слабое устройство или снимок
  /// не удался: тогда просто без эффекта.
  static Future<DustSnapshot?> capture(BuildContext? context) async {
    if (context == null || !context.mounted || !DevicePerformance.instance.animations) return null;
    final boundary = _find(context.findRenderObject());
    if (boundary == null || !boundary.attached || !boundary.hasSize || boundary.size.isEmpty) return null;
    try {
      // Строка ещё не перерисована (нажатие кнопки и т.п.) — ждём кадр, иначе
      // снимок устаревший (в debug — assert).
      var dirty = false;
      assert(() {
        dirty = boundary.debugNeedsPaint;
        return true;
      }());
      if (dirty) await SchedulerBinding.instance.endOfFrame;
      if (!context.mounted || !boundary.attached) return null;
      final ratio = math.min(View.of(context).devicePixelRatio, 2.0);
      final rect = boundary.localToGlobal(Offset.zero) & boundary.size;
      final image = await boundary.toImage(pixelRatio: ratio);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (bytes == null) {
        image.dispose();
        return null;
      }
      return DustSnapshot._(image, bytes, rect, ratio);
    } catch (_) {
      return null;
    }
  }

  /// Снимки сразу нескольких ([contexts] — отмеченные сообщения).
  static Future<List<DustSnapshot>> captureAll(Iterable<BuildContext?> contexts) async {
    final result = <DustSnapshot>[];
    for (final context in contexts) {
      final snapshot = await capture(context);
      if (snapshot != null) result.add(snapshot);
    }
    return result;
  }

  /// Рассыпать [snapshots] в оверлее над [context]. Снимки освобождаются по
  /// окончании.
  static void play(BuildContext context, List<DustSnapshot> snapshots) {
    if (!context.mounted) {
      for (final s in snapshots) {
        s.dispose();
      }
      return;
    }
    playIn(Overlay.of(context, rootOverlay: true), snapshots);
  }

  /// То же в заранее взятом [overlay] — когда сам элемент (и его context) к
  /// этому моменту уже убран из дерева.
  static void playIn(OverlayState overlay, List<DustSnapshot> snapshots) {
    if (snapshots.isEmpty) return;
    if (!overlay.mounted) {
      for (final s in snapshots) {
        s.dispose();
      }
      return;
    }
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    final origin = overlayBox == null ? Offset.zero : overlayBox.localToGlobal(Offset.zero);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => IgnorePointer(
        child: _DustLayer(
          snapshots: snapshots,
          origin: origin,
          onDone: () {
            entry.remove();
            entry.dispose();
            for (final s in snapshots) {
              s.dispose();
            }
          },
        ),
      ),
    );
    overlay.insert(entry);
  }

  static _RenderDustSource? _find(RenderObject? object) {
    if (object == null) return null;
    if (object is _RenderDustSource) return object;
    _RenderDustSource? found;
    object.visitChildren((child) => found ??= _find(child));
    return found;
  }
}

/// Элемент списка, который рассыпается, когда его удаляют: [builder] получает
/// `dissolve(action)` — снимок, [action] (`false` — не удалось, остаётся без
/// эффекта), при успехе — пыль на его месте.
class DustDismiss extends StatefulWidget {
  final Widget Function(BuildContext context, Future<void> Function(Future<bool> Function() action) dissolve) builder;

  const DustDismiss({super.key, required this.builder});

  @override
  State<DustDismiss> createState() => _DustDismissState();
}

class _DustDismissState extends State<DustDismiss> {
  final _key = GlobalKey();

  Future<void> _dissolve(Future<bool> Function() action) async {
    // Оверлей — заранее: после удаления этой строки её context уже не жив.
    final overlay = Overlay.of(context, rootOverlay: true);
    final snapshot = await DustEffect.capture(_key.currentContext);
    final ok = await action();
    if (snapshot == null) return;
    if (ok) {
      DustEffect.playIn(overlay, [snapshot]);
    } else {
      snapshot.dispose();
    }
  }

  @override
  Widget build(BuildContext context) => DustSource(key: _key, child: widget.builder(context, _dissolve));
}

/// Что рассыпается: оборачивает элемент (пузырь сообщения, строку списка),
/// [DustEffect.capture] снимает именно его. Это и граница перерисовки.
class DustSource extends SingleChildRenderObjectWidget {
  const DustSource({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderDustSource();
}

class _RenderDustSource extends RenderRepaintBoundary {}

/// Снимок элемента: картинка, её пиксели (где прозрачно — частиц нет) и место
/// на экране.
class DustSnapshot {
  DustSnapshot._(this.image, this._bytes, this.rect, this.ratio);

  final ui.Image image;
  final ByteData _bytes;
  final Rect rect;
  final double ratio;

  bool _disposed = false;

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    image.dispose();
  }

  /// Непрозрачен ли пиксель снимка под точкой [x], [y] (логические, от угла).
  bool _opaqueAt(double x, double y) {
    final px = (x * ratio).floor().clamp(0, image.width - 1);
    final py = (y * ratio).floor().clamp(0, image.height - 1);
    return _bytes.getUint8((py * image.width + px) * 4 + 3) > 24;
  }
}

/// Частицы одного снимка: кусочек снимка [src] (пиксели), исходное место
/// (логическое, от угла снимка), куда летит, когда стартует и сколько живёт
/// (доли общей длительности).
class _Particles {
  _Particles(this.snapshot, math.Random random) {
    final w = snapshot.rect.width;
    final h = snapshot.rect.height;
    // Кусочки 2.3 pt (≈ +20% частиц к 2.5), но не больше ~10800 на снимок
    // (длинное сообщение).
    final cell = math.max(2.3, math.sqrt(w * h / 10800));
    final r = snapshot.ratio;
    final xs = <double>[], ys = <double>[], dx = <double>[], dy = <double>[], start = <double>[], life = <double>[], src = <double>[];
    for (var y = 0.0; y < h; y += cell) {
      for (var x = 0.0; x < w; x += cell) {
        if (!snapshot._opaqueAt(x + cell / 2, y + cell / 2)) continue;
        xs.add(x);
        ys.add(y);
        // Вверх и вправо, с разбросом.
        dx.add(-12 + random.nextDouble() * 70);
        dy.add(-(18 + random.nextDouble() * 70));
        // Волна слева направо + небольшой разброс по старту.
        start.add(0.4 * (x / math.max(w, 1)) + random.nextDouble() * 0.08);
        // Старт ≤ 0.48 + жизнь ≤ 0.5 — к концу анимации погасли все.
        life.add(0.3 + random.nextDouble() * 0.2);
        src.addAll([
          x * r,
          y * r,
          math.min((x + cell) * r, snapshot.image.width.toDouble()),
          math.min((y + cell) * r, snapshot.image.height.toDouble()),
        ]);
      }
    }
    this.cell = cell;
    count = xs.length;
    _x = Float32List.fromList(xs);
    _y = Float32List.fromList(ys);
    _dx = Float32List.fromList(dx);
    _dy = Float32List.fromList(dy);
    _start = Float32List.fromList(start);
    _life = Float32List.fromList(life);
    rects = Float32List.fromList(src);
    transforms = Float32List(count * 4);
    colors = Int32List(count);
  }

  final DustSnapshot snapshot;
  late final double cell;
  late final int count;
  late final Float32List _x, _y, _dx, _dy, _start, _life;
  late final Float32List rects;
  late final Float32List transforms;
  late final Int32List colors;

  /// Раскладка на кадр [t] (0..1): до старта кусочек на месте, потом летит с
  /// замедлением, уменьшается и гаснет. [origin] — сдвиг оверлея.
  void layout(double t, Offset origin) {
    final base = snapshot.rect.topLeft - origin;
    final scaleToImage = 1 / snapshot.ratio;
    for (var i = 0; i < count; i++) {
      final p = ((t - _start[i]) / _life[i]).clamp(0.0, 1.0);
      final eased = 1 - (1 - p) * (1 - p);
      // Чуть «вихрем»: боковое покачивание по ходу полёта.
      final wobble = math.sin(p * math.pi * 2 + i) * 4 * p;
      final scale = (1 - 0.55 * p) * scaleToImage;
      final j = i * 4;
      transforms[j] = scale;
      transforms[j + 1] = 0;
      transforms[j + 2] = base.dx + _x[i] + _dx[i] * eased + wobble;
      transforms[j + 3] = base.dy + _y[i] + _dy[i] * eased;
      final alpha = ((1 - p) * 255).round();
      colors[i] = (alpha << 24) | 0x00FFFFFF;
    }
  }
}

class _DustLayer extends StatefulWidget {
  final List<DustSnapshot> snapshots;
  final Offset origin;
  final VoidCallback onDone;

  const _DustLayer({required this.snapshots, required this.origin, required this.onDone});

  @override
  State<_DustLayer> createState() => _DustLayerState();
}

class _DustLayerState extends State<_DustLayer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: DustEffect.duration);
  late final List<_Particles> _particles;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _particles = [for (final s in widget.snapshots) _Particles(s, random)];
    _controller.forward().whenCompleteOrCancel(() {
      // Убрать оверлей можно только вне кадра сборки.
      SchedulerBinding.instance.addPostFrameCallback((_) => widget.onDone());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(child: CustomPaint(painter: _DustPainter(_particles, _controller, widget.origin)));
}

class _DustPainter extends CustomPainter {
  _DustPainter(this.particles, this.animation, this.origin) : super(repaint: animation);

  final List<_Particles> particles;
  final Animation<double> animation;
  final Offset origin;

  static final _paint = Paint()..filterQuality = FilterQuality.low;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;
    for (final p in particles) {
      if (p.count == 0) continue;
      p.layout(t, origin);
      canvas.drawRawAtlas(p.snapshot.image, p.transforms, p.rects, p.colors, BlendMode.modulate, null, _paint);
    }
  }

  @override
  bool shouldRepaint(_DustPainter oldDelegate) => false;
}
