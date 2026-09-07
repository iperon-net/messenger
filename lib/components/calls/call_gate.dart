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
  bool _routeOpen = false;

  @override
  void initState() {
    super.initState();
    _sync(_calls.snapshot);
    _sub = _calls.snapshots.listen(_sync);
  }

  void _sync(CallSnapshot snapshot) {
    final active = snapshot.status != CallStatus.idle && snapshot.status != CallStatus.ended;

    if (active && !_routeOpen) {
      _routeOpen = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) GoRouter.of(context).push('/call');
      });
      return;
    }

    if (snapshot.status == CallStatus.ended && _routeOpen) {
      // Даём короткую паузу, чтобы пользователь увидел причину завершения,
      // затем закрываем экран звонка.
      Timer(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        if (!_routeOpen) return;
        _routeOpen = false;
        final router = GoRouter.of(context);
        if (router.canPop()) router.pop();
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
