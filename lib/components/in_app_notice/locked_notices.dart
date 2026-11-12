import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../chats/in_app_notices.dart';
import '../../desktop.dart';
import '../../i18n/translations.g.dart';
import '../../platform.dart';
import 'in_app_notice_host.dart';

/// Десктоп: системные уведомления о новых сообщениях ПОД код-паролем.
/// [InAppNoticeHost] под замком не смонтирован (баннеров там не должно быть),
/// а нативных пушей на macOS нет — без этого пользователь не узнает о
/// сообщении вовсе. Шлём системные уведомления без текста сообщения:
/// заголовок — имя чата, тело — общее «Новое сообщение»; правила пушей
/// (заглушённые, скрытые профили) уже применены в [InAppNotices]. Тап
/// открывает чат — увидят после разблокировки (как на телефоне). Монтируется
/// только в ветке код-пароля в корне приложения; на мобильных пустой — там
/// уведомления приносит пуш.
class LockedNoticesDesktop extends StatefulWidget {
  const LockedNoticesDesktop({super.key});

  @override
  State<LockedNoticesDesktop> createState() => _LockedNoticesDesktopState();
}

class _LockedNoticesDesktopState extends State<LockedNoticesDesktop> {
  StreamSubscription<InAppNotice>? _subscription;

  @override
  void initState() {
    super.initState();
    if (!AppPlatform.isDesktop) return;
    _subscription = InAppNotices.instance.notices.listen(_notify);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _notify(InAppNotice notice) {
    final t = context.t;
    final chat = notice.chat;
    unawaited(
      Desktop.showNotification(
        // Тот же формат, что в [InAppNoticeHost]: замок сменился показом — не задублируем.
        id: '${chat.id}:${(chat.lastMessage?.date ?? DateTime.now()).millisecondsSinceEpoch}',
        title: InAppNoticeContent.title(t, notice),
        body: t.inAppNotice.newMessage,
        route: notice.anonymous ? '/chats' : notice.route,
        thread: notice.anonymous ? null : chat.id,
        sound: notice.sound,
        reply: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
