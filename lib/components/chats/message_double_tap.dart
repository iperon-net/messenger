import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Двойной тап по пузырю [messageID] — быстрая реакция.
///
/// Не `GestureDetector.onDoubleTap`: тот держит арену после первого касания, и
/// на iOS `CupertinoContextMenu` (обёртка пузыря) успевает начать «нажатие» —
/// прячет пузырь в ленте и поднимает его копию в оверлей, пузырь пропадает до
/// конца обратной анимации. Здесь первое касание только запоминается (в арене
/// не участвует — одиночные тапы не ждут 300 мс), а второе забирает арену сразу
/// на касании, раньше, чем меню начнёт «нажатие» (через 100 мс). Если оно всё
/// же началось с первого касания — его гасит [MessageMenuPress].
///
/// Стоит и на пузыре, и на всей строке ленты ([behavior] translucent — ловит
/// пустое место рядом с пузырём, как в Telegram): касание, уже распознанное
/// вложенным, внешний пропускает.
class MessageDoubleTap extends StatelessWidget {
  final String messageID;
  final VoidCallback? onDoubleTap;
  final HitTestBehavior? behavior;
  final Widget child;

  const MessageDoubleTap({super.key, required this.messageID, required this.onDoubleTap, this.behavior, required this.child});

  @override
  Widget build(BuildContext context) {
    final onDoubleTap = this.onDoubleTap;
    if (onDoubleTap == null) return child;
    return RawGestureDetector(
      behavior: behavior,
      gestures: {
        _DoubleTapRecognizer: GestureRecognizerFactoryWithHandlers<_DoubleTapRecognizer>(
          () => _DoubleTapRecognizer(debugOwner: this),
          (recognizer) => recognizer
            ..messageID = messageID
            ..onDoubleTap = () {
              HapticFeedback.lightImpact();
              MessageMenuPress.maybeOf(context)?.call();
              onDoubleTap();
            },
        ),
      },
      child: child,
    );
  }
}

/// Отмена начатого касанием «нажатия» меню сообщения (iOS,
/// `CupertinoContextMenu`): ставит обёртка меню над пузырём — и над копией в
/// оверлее.
class MessageMenuPress extends InheritedWidget {
  final VoidCallback cancel;

  const MessageMenuPress({super.key, required this.cancel, required super.child});

  static VoidCallback? maybeOf(BuildContext context) => context.getInheritedWidgetOfExactType<MessageMenuPress>()?.cancel;

  @override
  bool updateShouldNotify(MessageMenuPress oldWidget) => false;
}

class _DoubleTapRecognizer extends OneSequenceGestureRecognizer {
  _DoubleTapRecognizer({super.debugOwner});

  String messageID = '';
  VoidCallback? onDoubleTap;

  /// Последний одиночный тап — общий для всех экземпляров: второе касание
  /// может прийти в копию пузыря в оверлее меню, а не в тот же пузырь.
  static ({String messageID, Duration at, Offset position})? _last;

  /// Второе касание, уже распознанное (вложенным) экземпляром: внешний не
  /// должен запомнить его как новый первый тап.
  static int? _consumed;

  /// Первые касания, за которыми следим без арены.
  final _observed = <int, PointerRoute>{};

  @override
  void addAllowedPointer(PointerDownEvent event) {
    if (event.pointer == _consumed) return;
    final last = _last;
    if (last != null &&
        last.messageID == messageID &&
        event.timeStamp - last.at <= kDoubleTapTimeout &&
        (event.position - last.position).distance <= kDoubleTapSlop) {
      _last = null;
      _consumed = event.pointer;
      startTrackingPointer(event.pointer, event.transform);
      resolve(GestureDisposition.accepted);
      if (onDoubleTap case final onDoubleTap?) invokeCallback<void>('onDoubleTap', onDoubleTap);
      return;
    }
    _observe(event);
  }

  /// Тап (без сдвига и не удержание) — запомнить как первый из двух.
  void _observe(PointerDownEvent down) {
    void route(PointerEvent event) {
      // Само касание сюда тоже приходит (роутер — после арены).
      if (event is PointerDownEvent) return;
      if (event is PointerMoveEvent && (event.position - down.position).distance <= kTouchSlop) return;
      if (event is PointerUpEvent && event.timeStamp - down.timeStamp < kLongPressTimeout) {
        _last = (messageID: messageID, at: event.timeStamp, position: event.position);
      }
      _unobserve(down.pointer);
    }

    _unobserve(down.pointer);
    _observed[down.pointer] = route;
    GestureBinding.instance.pointerRouter.addRoute(down.pointer, route);
  }

  void _unobserve(int pointer) {
    final route = _observed.remove(pointer);
    if (route != null) GestureBinding.instance.pointerRouter.removeRoute(pointer, route);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent || event is PointerCancelEvent) stopTrackingPointer(event.pointer);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void dispose() {
    for (final pointer in _observed.keys.toList()) {
      _unobserve(pointer);
    }
    super.dispose();
  }

  @override
  String get debugDescription => 'message double tap';
}
