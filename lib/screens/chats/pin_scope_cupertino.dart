import 'package:cupertino_ui/cupertino_ui.dart';

import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Закрепить ([pin]) / открепить сообщение, [allCount] — «Открепить все».
/// Личный чат — как в Telegram, «У меня и у собеседника» / «Только у меня»;
/// иначе закреп сразу (в «Избранном» — у себя), открепление — с
/// подтверждением. Открепление закреплённого только у меня ([shared] —
/// false; у «Открепить все» — ни одного общего) — сразу, без выбора.
/// Результат — forEveryone, `null` — отмена.
Future<bool?> askPinScopeCupertino(BuildContext context, models.Chat chat, {required bool pin, int? allCount, bool shared = true}) async {
  final t = context.t.screenChat;
  final private = chat.type == models.ChatType.private && !chat.isSelf;
  if (pin && !private) return !chat.isSelf;
  if (!pin && private && !shared) return false;
  final title = pin ? t.pinTitle : (allCount != null ? t.unpinAllTitle : t.unpinTitle);
  return showCupertinoDialog<bool>(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(title),
      actions: [
        if (private) ...[
          CupertinoDialogAction(
            isDefaultAction: pin,
            isDestructiveAction: !pin,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.scopeForBoth),
          ),
          CupertinoDialogAction(
            isDestructiveAction: !pin,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.scopeForMe),
          ),
        ] else
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.unpin)),
        CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.cancel)),
      ],
    ),
  );
}
