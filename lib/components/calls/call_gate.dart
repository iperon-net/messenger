import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../calls.dart';
import '../../di.dart';

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
    final active = snapshot.status != CallStatus.idle && snapshot.status != CallStatus.ended;

    // Авто-открытие только на переходе idle/ended → активный (старт звонка).
    if (active && !_wasActive) _openCall();
    _wasActive = active;

    if (snapshot.status == CallStatus.ended && _routeOpen) {
      // Даём короткую паузу, чтобы пользователь увидел причину завершения,
      // затем закрываем экран звонка.
      Timer(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        if (!_routeOpen) return;
        final router = GoRouter.of(context);
        if (router.canPop()) router.pop();
      });
    }
  }

  /// Открывает `/call`, если звонок активен и экран ещё не показан. Отслеживает
  /// закрытие через future от push().
  void _openCall() {
    if (_routeOpen) return;
    final status = _calls.snapshot.status;
    if (status == CallStatus.idle || status == CallStatus.ended) return;

    _routeOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _routeOpen = false;
        return;
      }
      final future = GoRouter.of(context).push('/call');
      // Когда экран звонка закрыт (pop / свайп-назад), сбрасываем флаг, чтобы
      // его можно было открыть снова из шторки при живом звонке.
      future.whenComplete(() => _routeOpen = false);
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
