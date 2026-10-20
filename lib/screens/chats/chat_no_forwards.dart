import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;
import 'package:screen_protector/screen_protector.dart';

import '../../chats/chats_sync.dart';
import '../../components/chats/message_text.dart' show ChatContentProtection;
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import 'chat_common.dart';

/// Защита содержимого чата (как «Disable Sharing» в Telegram): пункт «Ещё» в
/// профиле, ответ на запрос снять её и защита экрана от скриншотов.

/// Подпись пункта «Ещё»: выключена — «Запретить копирование»; включил я —
/// «Разрешить»; включил собеседник — «Попросить разрешить».
String chatNoForwardsActionLabel(Translations t, {required bool noForwards, required bool mine}) {
  final tc = t.chatNoForwards;
  if (!noForwards) return tc.disable;
  return mine ? tc.allow : tc.requestAllow;
}

/// Включить / выключить защиту ([requestID] — ответ на запрос собеседника:
/// [enabled] = false — разрешить, true — отклонить). Без сети — «Нет
/// соединения» (экран чата), запрос неактуален / собеседник ограничил, кто
/// может писать / лимит частоты — объяснение.
Future<void> setChatNoForwards(BuildContext context, ChatCubit cubit, bool enabled, {String requestID = ''}) async {
  try {
    await cubit.setNoForwards(enabled, requestID: requestID);
  } on ChatsFloodException catch (error) {
    if (context.mounted) showChatsFlood(context, error.seconds);
  } on ChatsRequestException catch (error) {
    if (!context.mounted) return;
    if (error.isRequestExpired) return showChatToast(context, context.t.chatNoForwards.requestExpired);
    if (!error.isPrivacyRestricted) rethrow;
    await _notice(context, context.t.chatTtl.restricted);
  }
}

/// «Копирование и пересылка в этом чате запрещены».
void showChatNoForwardsRestricted(BuildContext context) => showChatToast(context, context.t.chatNoForwards.restricted);

Future<void> _notice(BuildContext context, String text) async {
  if (Platform.isIOS) {
    await c.showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => c.CupertinoAlertDialog(
        content: Text(text),
        actions: [c.CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok))],
      ),
    );
  } else {
    m.ScaffoldMessenger.of(context).showSnackBar(m.SnackBar(content: Text(text)));
  }
}

/// Пока [enabled] (открыт чат с защитой содержимого) — экран не попадает на
/// скриншоты и запись: Android — FLAG_SECURE окна, iOS — содержимое в
/// «защищённом» слое (на снимке — пусто). Несколько экранов сразу — счётчик:
/// защита снимается, когда закрылся последний. Тексту сообщений ниже —
/// [ChatContentProtection] (без «Копировать» у блока кода).
class ChatScreenProtector extends StatefulWidget {
  final bool enabled;
  final Widget child;

  const ChatScreenProtector({super.key, required this.enabled, required this.child});

  @override
  State<ChatScreenProtector> createState() => _ChatScreenProtectorState();
}

class _ChatScreenProtectorState extends State<ChatScreenProtector> {
  static var _active = 0;
  var _on = false;

  @override
  void initState() {
    super.initState();
    _apply(widget.enabled);
  }

  @override
  void didUpdateWidget(ChatScreenProtector oldWidget) {
    super.didUpdateWidget(oldWidget);
    _apply(widget.enabled);
  }

  @override
  void dispose() {
    _apply(false);
    super.dispose();
  }

  void _apply(bool on) {
    if (on == _on) return;
    _on = on;
    _active += on ? 1 : -1;
    if (on && _active == 1) {
      ScreenProtector.preventScreenshotOn();
    } else if (!on && _active == 0) {
      ScreenProtector.preventScreenshotOff();
    }
  }

  @override
  Widget build(BuildContext context) => ChatContentProtection(protected: widget.enabled, child: widget.child);
}
