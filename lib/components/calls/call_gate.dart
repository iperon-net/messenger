import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../calls.dart';
import '../../di.dart';
import '../../logger.dart';

/// Слушатель звонков в шелле: подписан на [Calls.snapshots] и открывает
/// полноэкранный `/call` на входящий/исходящий звонок, а по завершении —
/// закрывает его. Живёт под роутером (обёрнут вокруг `navigationShell`), поэтому
/// у него есть валидный контекст для навигации на корневом навигаторе.
///
/// Провайдится один раз в обоих шеллах (см. `routers.dart`), чтобы входящий
/// ловился на любой вкладке.
class CallGate extends StatefulWidget {
  final Widget child;

  const CallGate({required this.child, super.key});

  @override
  State<CallGate> createState() => _CallGateState();
}

class _CallGateState extends State<CallGate> {
  final _calls = getIt.get<Calls>();
  final _logger = getIt.get<Logger>();

  StreamSubscription<CallSnapshot>? _sub;
  StreamSubscription<void>? _focusSub;

  // Открыт ли сейчас `/call` в стеке навигации. Синхронизируется через future
  // от push(): когда экран закрывают (в т.ч. свайпом-назад при живом звонке),
  // future завершается и флаг сбрасывается — тогда тап по ongoing-нотификации
  // сможет открыть экран заново.
  bool _routeOpen = false;

  // Был ли звонок активен на прошлом снимке — чтобы авто-открывать `/call`
  // только на переходе в активное состояние (начало звонка), а не переоткрывать
  // после того, как пользователь сам свернул экран во время звонка.
  bool _wasActive = false;

  @override
  void initState() {
    super.initState();
    _sync(_calls.snapshot);
    _sub = _calls.snapshots.listen(_sync);
    // Тап по ongoing-нотификации звонка (Android) — переоткрываем `/call`.
    _focusSub = _calls.focusRequests.listen((_) => _openCall());
  }

  void _sync(CallSnapshot snapshot) {
    // Входящий (`incoming`) НЕ открывает наш экран: в foreground его ведёт
    // системная звонилка (CallKit/ConnectionService) с системным рингтоном, а не
    // наш `CallView` (см. Calls.incomingRings / CallPush). Свой экран поднимаем
    // только с момента принятия (`connecting`/`active`) или на исходящий.
    final active = switch (snapshot.status) {
      CallStatus.idle || CallStatus.ended || CallStatus.incoming => false,
      _ => true,
    };

    // Авто-открытие только на переходе не-активный → активный (старт звонка).
    if (active && !_wasActive) {
      _logger.info('call_gate: sync -> active (status=${snapshot.status}), opening /call (routeOpen=$_routeOpen)');
      _openCall();
    }
    _wasActive = active;

    if ((snapshot.status == CallStatus.ended || snapshot.status == CallStatus.idle) && _routeOpen) {
      // Звонок завершён (ended) или уже сброшен в idle (см. Calls._scheduleIdleReset)
      // — сразу закрываем экран звонка, не задерживаясь на «завершён»: пользователь
      // возвращается туда, где был, а не «попадает» на экран звонилки после
      // разговора. Обрабатываем и idle, т.к. звонок с локскрина/фона мог
      // завершиться, пока приложение не рисовало кадры, и pop по ended не отработал.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_routeOpen) return;
        final router = GoRouter.of(context);
        if (router.canPop()) router.pop();
      });
    }
  }

  /// Открывает `/call`, если звонок активен и экран ещё не показан. Отслеживает
  /// закрытие через future от push().
  void _openCall() {
    if (_routeOpen) {
      _logger.info('call_gate: openCall skipped (already open)');
      return;
    }
    final status = _calls.snapshot.status;
    // incoming ведёт системная звонилка — свой экран не открываем (см. [_sync]).
    if (status == CallStatus.idle || status == CallStatus.ended || status == CallStatus.incoming) {
      _logger.info('call_gate: openCall skipped (status=$status)');
      return;
    }

    _routeOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _logger.warning('call_gate: openCall aborted (not mounted)');
        _routeOpen = false;
        return;
      }
      _logger.info('call_gate: pushing /call');
      final future = GoRouter.of(context).push('/call');
      // Когда экран звонка закрыт (pop / свайп-назад), сбрасываем флаг, чтобы
      // его можно было открыть снова из шторки при живом звонке.
      future.whenComplete(() {
        _logger.info('call_gate: /call route closed');
        _routeOpen = false;
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _focusSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
