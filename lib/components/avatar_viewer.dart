import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Полноэкранный просмотр аватара (тап по аватару в профиле): щипок и
/// двойной тап — зум, свайп вниз/вверх — закрыть, вверху — имя и «закрыть».
/// [heroTag] — тот же, что у аватара на экране: картинка «вылетает» из него.
/// Одинаков на iOS и Android (как просмотр медиа чата), поэтому без пары
/// `*_cupertino`/`*_material`.
Future<void> showAvatarViewer(BuildContext context, {required Uint8List bytes, required Object heroTag, String title = ''}) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, _) => _AvatarViewer(bytes: bytes, heroTag: heroTag, title: title),
      transitionsBuilder: (context, animation, _, child) => FadeTransition(opacity: animation, child: child),
    ),
  );
}

class _AvatarViewer extends StatefulWidget {
  final Uint8List bytes;
  final Object heroTag;
  final String title;

  const _AvatarViewer({required this.bytes, required this.heroTag, required this.title});

  @override
  State<_AvatarViewer> createState() => _AvatarViewerState();
}

class _AvatarViewerState extends State<_AvatarViewer> with TickerProviderStateMixin {
  final _zoom = TransformationController();
  bool _zoomed = false;

  // Двойной тап: зум к точке тапа и обратно — анимацией.
  late final AnimationController _zoomAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 200))
    ..addListener(() => _zoom.value = _zoomTween?.evaluate(CurveTween(curve: Curves.easeOut).animate(_zoomAnimation)) ?? _zoom.value);
  Matrix4Tween? _zoomTween;
  Offset _doubleTapAt = Offset.zero;

  // Свайп для закрытия: смещение по вертикали и возврат на место.
  double _drag = 0;
  double _dragFrom = 0;
  late final AnimationController _dragBack = AnimationController(vsync: this, duration: const Duration(milliseconds: 200))
    ..addListener(() => setState(() => _drag = _dragFrom * (1 - Curves.easeOut.transform(_dragBack.value))));

  static const _dismissDistance = 120.0;

  @override
  void initState() {
    super.initState();
    _zoom.addListener(() {
      final zoomed = _zoom.value.getMaxScaleOnAxis() > 1.01;
      if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
    });
  }

  @override
  void dispose() {
    _zoom.dispose();
    _zoomAnimation.dispose();
    _dragBack.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    const scale = 2.5;
    final target = _zoomed
        ? Matrix4.identity()
        : (Matrix4.identity()
            ..translateByDouble(-_doubleTapAt.dx * (scale - 1), -_doubleTapAt.dy * (scale - 1), 0, 1)
            ..scaleByDouble(scale, scale, 1, 1));
    _zoomTween = Matrix4Tween(begin: _zoom.value, end: target);
    _zoomAnimation.forward(from: 0);
  }

  void _onDragEnd(DragEndDetails details) {
    if (_drag.abs() > _dismissDistance || details.velocity.pixelsPerSecond.dy.abs() > 800) {
      Navigator.of(context).pop();
      return;
    }
    _dragFrom = _drag;
    _dragBack.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final fade = (1 - _drag.abs() / 400).clamp(0.0, 1.0);
    const white = Color(0xFFFFFFFF);
    final textStyle = DefaultTextStyle.of(context).style.copyWith(color: white, decoration: TextDecoration.none);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DefaultTextStyle(
        style: textStyle,
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(color: const Color(0xFF000000).withValues(alpha: fade)),
            ),
            Positioned.fill(
              child: GestureDetector(
                onDoubleTapDown: (details) => _doubleTapAt = details.localPosition,
                onDoubleTap: _onDoubleTap,
                onVerticalDragStart: _zoomed ? null : (_) => _dragBack.stop(),
                onVerticalDragUpdate: _zoomed ? null : (d) => setState(() => _drag += d.delta.dy),
                onVerticalDragEnd: _zoomed ? null : _onDragEnd,
                child: Transform.translate(
                  offset: Offset(0, _drag),
                  child: InteractiveViewer(
                    transformationController: _zoom,
                    minScale: 1,
                    maxScale: 5,
                    // Без зума панорамировать нечего — вертикальный свайп закрывает.
                    panEnabled: _zoomed,
                    child: Center(
                      child: Hero(
                        tag: widget.heroTag,
                        child: Image.memory(widget.bytes, fit: BoxFit.contain, gaplessPlayback: true),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _drag == 0 ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x99000000), Color(0x00000000)],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 16, 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: FaIcon(FontAwesomeIcons.xmark, size: 22, color: white),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
