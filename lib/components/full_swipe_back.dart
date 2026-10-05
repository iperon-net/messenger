import 'dart:math' as math;

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/gestures.dart';

/// Горизонтальный drag, который принимает жест только в одну сторону
/// ([direction]: `1` — вправо, `-1` — влево), а при движении в обратную
/// сразу выходит из арены. Так «свайп назад» (вправо) и «свайп-ответ»
/// (влево) на одном пузыре не перехватывают друг у друга.
class DirectionalDragGestureRecognizer extends HorizontalDragGestureRecognizer {
  final double direction;

  DirectionalDragGestureRecognizer({required this.direction, super.debugOwner});

  bool _accepted = false;

  @override
  bool hasSufficientGlobalDistanceToAccept(PointerDeviceKind pointerDeviceKind, double? deviceTouchSlop) {
    return globalDistanceMoved * direction > computeHitSlop(pointerDeviceKind, gestureSettings);
  }

  @override
  void handleEvent(PointerEvent event) {
    super.handleEvent(event);
    if (!_accepted && event is PointerMoveEvent && globalDistanceMoved * direction < -computeHitSlop(event.kind, gestureSettings)) {
      resolve(GestureDisposition.rejected);
    }
  }

  @override
  void acceptGesture(int pointer) {
    _accepted = true;
    super.acceptGesture(pointer);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _accepted = false;
    super.didStopTrackingLastPointer(pointer);
  }
}

/// Страница, которую можно закрыть свайпом вправо с любого места экрана, а не
/// только от левого края (как в Telegram). Переход — сдвиг справа налево с
/// параллаксом предыдущего экрана (iOS-анимация; на Android Telegram выглядит
/// так же), поэтому одна страница для обеих платформ. Внутренние
/// горизонтальные жесты (слайдеры, горизонтальные списки, свайп-ответ влево)
/// приоритетнее: они стоят глубже и получают указатель раньше.
class FullSwipeBackPage<T> extends Page<T> {
  final Widget child;

  /// Длительность перехода; `null` — как у iOS (500 мс). На Android короче,
  /// под темп системных переходов.
  final Duration? transitionDuration;

  const FullSwipeBackPage({required this.child, this.transitionDuration, super.key, super.name, super.arguments, super.restorationId});

  @override
  Route<T> createRoute(BuildContext context) => _FullSwipeRoute<T>(page: this);
}

class _FullSwipeRoute<T> extends PageRoute<T> with CupertinoRouteTransitionMixin<T> {
  _FullSwipeRoute({required FullSwipeBackPage<T> page}) : super(settings: page);

  // Не CupertinoPageTransition.delegatedTransition: тот ведёт экран под
  // чатом (оболочку со списком чатов) по кривым и во время свайпа, а сам чат
  // идёт за пальцем линейно — список «плыл» отдельно от чата и дёргался при
  // отпускании (кривая сменялась на обратную).
  @override
  DelegatedTransitionBuilder? get delegatedTransition => _delegatedTransition;

  static Widget? _delegatedTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    bool allowSnapshotting,
    Widget? child,
  ) {
    final gesture = Navigator.maybeOf(context)?.userGestureInProgress ?? false;
    final CurvedAnimation? curve = gesture
        ? null
        : CurvedAnimation(parent: secondaryAnimation, curve: Curves.linearToEaseOut, reverseCurve: Curves.easeInToLinear);
    final position = (curve ?? secondaryAnimation).drive(_parallax);
    // Как в cupertino_ui: drive уже подписан на родителя, CurvedAnimation
    // больше не нужна.
    curve?.dispose();
    return SlideTransition(position: position, textDirection: Directionality.of(context), transformHitTests: false, child: child);
  }

  static final _parallax = Tween<Offset>(begin: Offset.zero, end: const Offset(-1 / 3, 0));

  FullSwipeBackPage<T> get _page => settings as FullSwipeBackPage<T>;

  @override
  Widget buildContent(BuildContext context) => _page.child;

  @override
  Duration get transitionDuration => _page.transitionDuration ?? super.transitionDuration;

  @override
  String? get title => null;

  @override
  bool get maintainState => true;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return CupertinoPageTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      // Во время свайпа страница идёт за пальцем линейно.
      linearTransition: popGestureInProgress,
      child: _FullSwipeBackDetector(
        enabledCallback: () => popGestureEnabled,
        onStart: () => _BackGestureController(navigator: navigator!, controller: controller!, route: this),
        child: child,
      ),
    );
  }
}

class _FullSwipeBackDetector extends StatefulWidget {
  final ValueGetter<bool> enabledCallback;
  final ValueGetter<_BackGestureController> onStart;
  final Widget child;

  const _FullSwipeBackDetector({required this.enabledCallback, required this.onStart, required this.child});

  @override
  State<_FullSwipeBackDetector> createState() => _FullSwipeBackDetectorState();
}

class _FullSwipeBackDetectorState extends State<_FullSwipeBackDetector> {
  late final _recognizer = DirectionalDragGestureRecognizer(direction: 1, debugOwner: this)
    ..onStart = _start
    ..onUpdate = _update
    ..onEnd = _end
    ..onCancel = _cancel;
  _BackGestureController? _gesture;

  @override
  void dispose() {
    _recognizer.dispose();
    // Страницу убрали посреди свайпа — навигатор не должен остаться в
    // состоянии «жест идёт».
    final gesture = _gesture;
    if (gesture != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (gesture.navigator.mounted) gesture.navigator.didStopUserGesture();
      });
    }
    super.dispose();
  }

  void _start(DragStartDetails details) => _gesture = widget.onStart();

  void _update(DragUpdateDetails details) => _gesture?.update(details.primaryDelta! / context.size!.width);

  void _end(DragEndDetails details) {
    _gesture?.end(details.velocity.pixelsPerSecond.dx / context.size!.width);
    _gesture = null;
  }

  void _cancel() {
    _gesture?.end(0);
    _gesture = null;
  }

  /// Указатель, уже отданный распознавателю полосой у края.
  int? _edgePointer;

  /// Ширина полосы у края, где жест «назад» главнее жестов страницы.
  static const _edgeWidth = 20.0;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final inset = rtl ? MediaQuery.paddingOf(context).right : MediaQuery.paddingOf(context).left;
    // Listener — родитель страницы, а не слой поверх: распознаватели внутри
    // страницы получают указатель раньше и выигрывают свои жесты (свайп
    // строки списка, слайдер, горизонтальная лента). Но у самого края, как в
    // iOS, приоритет у «назад»: там полоса поверх страницы (её Listener
    // срабатывает первым), чтобы закрыть экран можно было и со строки со
    // свайп-действиями.
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (event) {
            if (event.pointer != _edgePointer && widget.enabledCallback()) _recognizer.addPointer(event);
          },
          child: widget.child,
        ),
        PositionedDirectional(
          start: 0,
          width: math.max(inset, _edgeWidth),
          top: 0,
          bottom: 0,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              if (!widget.enabledCallback()) return;
              _edgePointer = event.pointer;
              _recognizer.addPointer(event);
            },
          ),
        ),
      ],
    );
  }
}

/// Ведёт анимацию маршрута за пальцем и по отпусканию докручивает её
/// (поведение и константы — как у штатного iOS-жеста в cupertino_ui).
class _BackGestureController {
  static const _minFlingVelocity = 1.0; // ширин экрана в секунду
  static const _droppedDuration = Duration(milliseconds: 350);

  final NavigatorState navigator;
  final AnimationController controller;
  final Route<dynamic> route;

  _BackGestureController({required this.navigator, required this.controller, required this.route}) {
    navigator.didStartUserGesture();
  }

  void update(double delta) => controller.value -= delta;

  void end(double velocity) {
    const curve = Curves.fastEaseInToSlowEaseOut;
    final bool forward;
    if (!route.isCurrent) {
      forward = route.isActive;
    } else if (velocity.abs() >= _minFlingVelocity) {
      forward = velocity <= 0;
    } else {
      forward = controller.value > 0.5;
    }

    if (forward) {
      controller.animateTo(1, duration: _droppedDuration, curve: curve);
    } else {
      if (route.isCurrent) navigator.pop();
      if (controller.isAnimating) controller.animateBack(0, duration: _droppedDuration, curve: curve);
    }

    if (controller.isAnimating) {
      late AnimationStatusListener listener;
      listener = (status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(listener);
      };
      controller.addStatusListener(listener);
    } else {
      navigator.didStopUserGesture();
    }
  }
}
