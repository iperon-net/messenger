import 'package:flutter/widgets.dart';

import '../../chats/chats_sync.dart';

/// Непрочитанные в остальных чатах — у «назад» в окне чата (как в Telegram):
/// видно, что пишут ещё, не выходя из переписки. [unreadChatID] — id окна в
/// списке чатов (hex / `secret:<hex>`): его собственные не считаем. Читается
/// уже в `initState` — через `context.read`, не через поля экрана.
mixin UnreadBackCount<T extends StatefulWidget> on State<T> {
  String get unreadChatID;

  int unreadBack = 0;

  @override
  void initState() {
    super.initState();
    unreadBack = _count();
    ChatsSync.instance.unread.addListener(_onUnread);
  }

  @override
  void dispose() {
    ChatsSync.instance.unread.removeListener(_onUnread);
    super.dispose();
  }

  int _count() => ChatsSync.instance.unread.value.except(unreadChatID);

  void _onUnread() {
    final count = _count();
    if (count != unreadBack && mounted) setState(() => unreadBack = count);
  }
}

/// Перестраивает [builder] по общему числу непрочитанных (вкладка «Чаты»).
class UnreadTotalBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, int total) builder;

  const UnreadTotalBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ChatsUnread>(
    valueListenable: ChatsSync.instance.unread,
    builder: (context, unread, _) => builder(context, unread.total),
  );
}
