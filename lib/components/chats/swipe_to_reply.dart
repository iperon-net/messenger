import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../full_swipe_back.dart';

/// Свайп сообщения влево — ответить (как в Telegram): пузырь уезжает за
/// пальцем, справа проявляется значок ↩; за порогом — лёгкая вибрация, и
/// при отпускании вызывается [onReply]. Вправо не тянется и жест не
/// забирает — свайп вправо закрывает чат (см. [FullSwipeBackPage]).
class SwipeToReply extends StatefulWidget {
  final Widget child;

  /// `null` — свайп выключен (канал, поиск).
  final VoidCallback? onReply;

  /// Кружок под значком и сам значок.
  final Color background;
  final Color iconColor;

  const SwipeToReply({super.key, required this.child, required this.onReply, required this.background, required this.iconColor});

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply> with SingleTickerProviderStateMixin {
  /// Сколько протянуть, чтобы сработало.
  static const _threshold = 64.0;

  /// Дальше порога пузырь тянется туго и не больше чем на столько.
  static const _limit = 96.0;
  static const _iconSize = 30.0;

  /// Смещение пузыря в пикселях (≤ 0).
  late final _offset = AnimationController.unbounded(vsync: this);
  double _drag = 0;
  bool _armed = false;

  @override
  void dispose() {
    _offset.dispose();
    super.dispose();
  }

  void _start(DragStartDetails details) {
    _offset.stop();
    _drag = -_offset.value;
  }

  void _update(DragUpdateDetails details) {
    _drag = math.max(0, _drag - details.primaryDelta!);
    final visual = _drag <= _threshold ? _drag : math.min(_limit, _threshold + (_drag - _threshold) * 0.35);
    _offset.value = -visual;
    final armed = _drag >= _threshold;
    if (armed != _armed) {
      _armed = armed;
      if (armed) HapticFeedback.lightImpact();
    }
  }

  void _end([DragEndDetails? _]) {
    if (_armed) widget.onReply?.call();
    _armed = false;
    _drag = 0;
    _offset.animateTo(0, duration: const Duration(milliseconds: 220), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    // Без [onReply] — те же виджеты, только без жеста (смена режима не
    // пересоздаёт пузырь).
    final enabled = widget.onReply != null;
    // Принимает только движение влево: вправо — жест «назад» страницы.
    return RawGestureDetector(
      gestures: {
        if (enabled)
          DirectionalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<DirectionalDragGestureRecognizer>(
            () => DirectionalDragGestureRecognizer(direction: -1, debugOwner: this),
            (recognizer) => recognizer
              ..onStart = _start
              ..onUpdate = _update
              ..onEnd = _end
              ..onCancel = _end,
          ),
      },
      child: AnimatedBuilder(
        animation: _offset,
        child: widget.child,
        builder: (context, child) {
          // Дерево одинаковое и в покое: иначе пузырь пересоздавался бы в
          // начале свайпа (терялось бы состояние меню, картинок).
          final dx = _offset.value;
          final progress = (-dx / _threshold).clamp(0.0, 1.0);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: dx == 0
                      ? const SizedBox.shrink()
                      : Opacity(
                          opacity: progress,
                          child: Transform.scale(
                            scale: 0.5 + 0.5 * progress,
                            child: Container(
                              width: _iconSize,
                              height: _iconSize,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: widget.background, shape: BoxShape.circle),
                              child: FaIcon(FontAwesomeIcons.reply, size: 14, color: widget.iconColor),
                            ),
                          ),
                        ),
                ),
              ),
              Transform.translate(offset: Offset(dx, 0), child: child),
            ],
          );
        },
      ),
    );
  }
}
