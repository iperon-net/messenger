import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../calls.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';

/// Слушатель звонков в шелле: подписан на [Calls.snapshots] и открывает
/// полноэкранный `/call` на входящий/исходящий звонок, а по завершении —
/// закрывает его. Пока звонок активен, но экран `/call` свёрнут, показывает
/// сверху зелёную полоску «вернуться к звонку» — тап переоткрывает `/call`.
/// Живёт под роутером (обёрнут вокруг `navigationShell`), поэтому у него есть
/// валидный контекст для навигации на корневом навигаторе.
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

  // Последний снимок звонка — для отрисовки полоски возврата. Обновляется в
  // [_handle] (через setState на события стрима).
  CallSnapshot _snapshot = const CallSnapshot();

  // Открыт ли сейчас `/call` в стеке навигации. Синхронизируется через future
  // от push(): когда экран закрывают (в т.ч. свайпом-назад при живом звонке),
  // future завершается и флаг сбрасывается — тогда полоска возврата (или тап по
  // ongoing-нотификации) сможет открыть экран заново.
  bool _routeOpen = false;

  // Был ли звонок активен на прошлом снимке — чтобы авто-открывать `/call`
  // только на переходе в активное состояние (начало звонка), а не переоткрывать
  // после того, как пользователь сам свернул экран во время звонка.
  bool _wasActive = false;

  @override
  void initState() {
    super.initState();
    // Начальная синхронизация без setState (билд ещё не прошёл).
    _snapshot = _calls.snapshot;
    _handle(_snapshot, initial: true);
    _sub = _calls.snapshots.listen((s) => _handle(s, initial: false));
    // Тап по ongoing-нотификации звонка (Android) — переоткрываем `/call`.
    _focusSub = _calls.focusRequests.listen((_) => _openCall());
  }

  void _handle(CallSnapshot snapshot, {required bool initial}) {
    if (!initial && mounted) {
      setState(() => _snapshot = snapshot);
    } else {
      _snapshot = snapshot;
    }

    // Входящий (`incoming`): на iOS открываем наш экран (`CallView` рисует
    // «Принять/Отклонить») — CallKit в активном foreground баннер НЕ показывает,
    // поэтому системной звонилке его не отдаём. На Android входящий в foreground
    // ведёт системная звонилка (ConnectionService) с системным рингтоном, свой
    // экран поднимаем только с принятия (`connecting`/`active`). Исходящий
    // открываем всегда. См. Calls.incomingRings / CallPush._onIncomingRing.
    final active = _isActive(snapshot.status);

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
        // За время отложенного pop мог стартовать новый звонок (быстрый повторный
        // набор): тогда `_openCall` уже был пропущен как «already open», и если
        // сейчас закрыть экран — новый звонок останется без `/call` (только полоска
        // возврата). Не закрываем: тот же экран перерисуется под новый звонок.
        if (_isActive(_snapshot.status)) return;
        final router = GoRouter.of(context);
        if (router.canPop()) router.pop();
      });
    }
  }

  // Активен ли звонок в смысле «ведём свой экран» (исходящий/соединение/разговор).
  // `idle`/`ended` — звонка нет. `incoming` активен только на iOS: там свой экран
  // (foreground CallKit-баннер не показывает); на Android входящий ведёт системная
  // звонилка, до принятия экран не открываем.
  static bool _isActive(CallStatus status) => switch (status) {
    CallStatus.idle || CallStatus.ended => false,
    CallStatus.incoming => Platform.isIOS,
    _ => true,
  };

  // Показывать ли полоску возврата: звонок активен, но экран `/call` свёрнут.
  bool get _shouldShowBanner => !_routeOpen && _isActive(_snapshot.status);

  /// Открывает `/call`, если звонок активен и экран ещё не показан. Отслеживает
  /// закрытие через future от push().
  void _openCall() {
    if (_routeOpen) {
      _logger.info('call_gate: openCall skipped (already open)');
      return;
    }
    final status = _calls.snapshot.status;
    // idle/ended — звонка нет. `incoming` открываем только на iOS (foreground-
    // входящий, см. [_isActive]); на Android его ведёт системная звонилка —
    // свой экран поднимаем лишь с принятия (connecting/active).
    if (status == CallStatus.idle || status == CallStatus.ended || (status == CallStatus.incoming && !Platform.isIOS)) {
      _logger.info('call_gate: openCall skipped (status=$status)');
      return;
    }

    _setRouteOpen(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _logger.warning('call_gate: openCall aborted (not mounted)');
        _setRouteOpen(false);
        return;
      }
      _logger.info('call_gate: pushing /call');
      final future = GoRouter.of(context).push('/call');
      // Когда экран звонка закрыт (pop / свайп-назад), сбрасываем флаг, чтобы
      // его можно было открыть снова полоской возврата при живом звонке.
      future.whenComplete(() {
        _logger.info('call_gate: /call route closed');
        _setRouteOpen(false);
      });
    });
  }

  // Меняет [_routeOpen] и перерисовывает полоску (её видимость зависит от флага).
  void _setRouteOpen(bool value) {
    if (_routeOpen == value) return;
    _routeOpen = value;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _sub?.cancel();
    _focusSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowBanner) return widget.child;
    // Полоска съедает верхний системный инсет своим SafeArea (рисуется под
    // статус-баром), поэтому у содержимого ниже убираем верхний padding —
    // иначе его собственный SafeArea добавил бы второй отступ и появился бы зазор.
    return Column(
      children: [
        _CallReturnBanner(snapshot: _snapshot, onTap: _openCall),
        Expanded(
          child: MediaQuery.removePadding(context: context, removeTop: true, child: widget.child),
        ),
      ],
    );
  }
}

/// Зелёная полоска активного звонка поверх содержимого: иконка + статус/таймер,
/// по тапу — переоткрывает `/call`. Тикает раз в секунду для таймера разговора.
class _CallReturnBanner extends StatefulWidget {
  final CallSnapshot snapshot;
  final VoidCallback onTap;

  const _CallReturnBanner({required this.snapshot, required this.onTap});

  @override
  State<_CallReturnBanner> createState() => _CallReturnBannerState();
}

class _CallReturnBannerState extends State<_CallReturnBanner> {
  // Зелёный «активного звонка» — чуть темнее системного iOS-green.
  static const _green = Color(0xFF248A3D);

  // Приглушённый (не яркий) красный — когда свой микрофон выключен.
  static const _mutedRed = Color(0xFFA6413B);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static String _formatDuration(Duration d) {
    final total = d.inSeconds < 0 ? 0 : d.inSeconds;
    final h = total ~/ 3600;
    final m = (total % 3600) ~/ 60;
    final ss = (total % 60).toString().padLeft(2, '0');
    if (h > 0) return '$h:${m.toString().padLeft(2, '0')}:$ss';
    return '$m:$ss';
  }

  // Статус-слово полоски (подчёркнутое): «Вызов» до ответа, «Идёт разговор» в
  // разговоре.
  String _statusWord(BuildContext context) {
    final t = context.t.screenCall;
    return widget.snapshot.status == CallStatus.active ? t.bannerActive : t.bannerRinging;
  }

  // Таймер разговора (пусто, пока не active) — рядом со статусом, без подчёркивания.
  String _timerText() {
    final at = widget.snapshot.connectedAt;
    if (widget.snapshot.status != CallStatus.active || at == null) return '';
    return _formatDuration(DateTime.now().difference(at));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenCall;
    const white = Color(0xFFFFFFFF);
    final timer = _timerText();
    // Индикация mute — только в разговоре: до соединения remoteMicMuted=true
    // (дорожки ещё нет), и красный/иконка вводили бы в заблуждение.
    final active = widget.snapshot.status == CallStatus.active;
    final localMuted = active && widget.snapshot.micMuted;
    final remoteMuted = active && widget.snapshot.remoteMicMuted;
    return Semantics(
      button: true,
      label: t.returnToCall,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          // Свой микрофон выключен — приглушённый красный, иначе зелёный.
          color: localMuted ? _mutedRed : _green,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              // Полоска рисуется ВЫШЕ Scaffold — там нет валидного DefaultTextStyle,
              // и Text по умолчанию получил бы дебажное жёлтое двойное подчёркивание.
              // Задаём чистый базовый стиль (в т.ч. decoration: none) для всего текста.
              child: DefaultTextStyle(
                style: const TextStyle(color: white, decoration: TextDecoration.none),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.phone, size: 15, color: white),
                    // Собеседник выключил микрофон — иконка перечёркнутого микрофона
                    // сразу после трубки.
                    if (remoteMuted) ...[const SizedBox(width: 8), const FaIcon(FontAwesomeIcons.microphoneSlash, size: 15, color: white)],
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _statusWord(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (timer.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        timer,
                        style: const TextStyle(
                          color: white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
