import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../chats/in_app_notices.dart';
import '../../desktop.dart';
import '../../i18n/translations.g.dart';
import '../../platform.dart';
import '../chats/chat_tile.dart';

export '../../chats/in_app_notices.dart' show InAppNotice;

/// Тексты баннера — общие для Cupertino и Material.
abstract final class InAppNoticeContent {
  static String title(Translations t, InAppNotice notice) =>
      notice.anonymous ? t.inAppNotice.appName : ChatTileContent.title(t, notice.chat);

  /// Последнее сообщение, как в строке списка («Анна: текст» в группе), без
  /// черновика и «печатает…».
  static String text(Translations t, InAppNotice notice) {
    if (notice.anonymous || !notice.showPreview) return t.inAppNotice.newMessage;
    final preview = ChatTileContent.preview(t, notice.chat.copyWith(draft: '', typing: const []));
    final text = preview.text.isEmpty ? t.inAppNotice.newMessage : preview.text;
    return preview.prefix.isEmpty ? text : '${preview.prefix}: $text';
  }
}

/// Слой баннеров [InAppNotices] над всем приложением (в `builder` корня, под
/// код-паролем не монтируется): выезжает сверху, через 5 с уезжает сам, смахивается
/// вверх, тап открывает чат (как в Telegram). Новое сообщение заменяет показанное.
/// Не показывается в фоне, в самом чате и в списке чатов (строка и так
/// поднимается наверх), на входе и в звонке. Оформление — [card].
class InAppNoticeHost extends StatefulWidget {
  final GoRouter router;
  final Widget Function(BuildContext context, InAppNotice notice) card;

  const InAppNoticeHost({super.key, required this.router, required this.card});

  @override
  State<InAppNoticeHost> createState() => _InAppNoticeHostState();
}

class _InAppNoticeHostState extends State<InAppNoticeHost> with SingleTickerProviderStateMixin {
  static const _visible = Duration(seconds: 5);

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
    reverseDuration: const Duration(milliseconds: 200),
  );
  late final _slide = Tween(
    begin: const Offset(0, -2),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic));

  StreamSubscription<InAppNotice>? _subscription;
  InAppNotice? _notice;
  Timer? _timer;

  /// Смещение пальцем (только вверх).
  double _drag = 0;

  @override
  void initState() {
    super.initState();
    _subscription = InAppNotices.instance.notices.listen(_show);
    widget.router.routerDelegate.addListener(_onRoute);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    widget.router.routerDelegate.removeListener(_onRoute);
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  String get _location => widget.router.routerDelegate.currentConfiguration.uri.path;

  bool _allowed(InAppNotice notice) {
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) return false;
    final location = _location;
    if (location == '/chats' || location == '/chats/archive') return false;
    if (location == '/call' || location == '/auth' || location.startsWith('/auth/')) return false;
    return !_inChat(location, notice);
  }

  bool _inChat(String location, InAppNotice notice) =>
      [notice.route, ...notice.alsoOpenAt].any((route) => location == route || location.startsWith('$route/'));

  /// Открыли чат показанного баннера (или ушли туда, где баннеров нет) — убрать.
  void _onRoute() {
    final notice = _notice;
    if (notice != null && !_controller.isDismissed && !_allowed(notice)) _hide();
  }

  void _show(InAppNotice notice) {
    if (!mounted) return;
    // Десктоп: окно не в фокусе — системное уведомление вместо баннера (его не
    // увидят), как в Telegram Desktop.
    if (AppPlatform.isDesktop && WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      final t = context.t;
      final chat = notice.chat;
      unawaited(
        Desktop.showNotification(
          id: '${chat.id}:${(chat.lastMessage?.date ?? DateTime.now()).millisecondsSinceEpoch}',
          title: InAppNoticeContent.title(t, notice),
          body: InAppNoticeContent.text(t, notice),
          route: notice.anonymous ? '/chats' : notice.route,
          thread: notice.anonymous ? null : chat.id,
        ),
      );
      return;
    }
    if (!_allowed(notice)) return;
    setState(() {
      _notice = notice;
      _drag = 0;
    });
    _controller.forward();
    _restartTimer();
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = Timer(_visible, _hide);
  }

  Future<void> _hide() async {
    _timer?.cancel();
    await _controller.reverse();
    if (mounted && _controller.isDismissed) setState(() => _notice = null);
  }

  void _open() {
    final notice = _notice;
    if (notice == null) return;
    unawaited(_hide());
    widget.router.go(notice.anonymous ? '/chats' : notice.route);
  }

  void _onDragEnd(DragEndDetails details) {
    if (_drag < -24 || (details.primaryVelocity ?? 0) < -300) {
      unawaited(_hide());
      return;
    }
    setState(() => _drag = 0);
    _restartTimer();
  }

  @override
  Widget build(BuildContext context) {
    final notice = _notice;
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 6,
      left: 8,
      right: 8,
      child: notice == null
          ? const SizedBox.shrink()
          : SlideTransition(
              position: _slide,
              child: Transform.translate(
                offset: Offset(0, math.min(_drag, 0)),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _open,
                  onVerticalDragStart: (_) => _timer?.cancel(),
                  onVerticalDragUpdate: (details) => setState(() => _drag += details.delta.dy),
                  onVerticalDragEnd: _onDragEnd,
                  child: widget.card(context, notice),
                ),
              ),
            ),
    );
  }
}
