import 'package:material_ui/material_ui.dart';

import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Закрепить ([pin]) / открепить сообщение, [allCount] — «Открепить все».
/// Личный чат — как в Telegram, галочка «Для собеседника» (по умолчанию
/// стоит); иначе закреп сразу (в «Избранном» — у себя), открепление — с
/// подтверждением. Результат — forEveryone, `null` — отмена.
Future<bool?> askPinScopeMaterial(BuildContext context, models.Chat chat, {required bool pin, int? allCount}) async {
  final t = context.t.screenChat;
  final private = chat.type == models.ChatType.private && !chat.isSelf;
  if (pin && !private) return !chat.isSelf;
  final title = pin ? t.pinTitle : (allCount != null ? t.unpinAllTitle(n: allCount) : t.unpinTitle);
  var forBoth = true;
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setDialogState) => AlertDialog(
        title: Text(title),
        content: private
            ? CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                horizontalTitleGap: 4,
                value: forBoth,
                onChanged: (value) => setDialogState(() => forBoth = value ?? false),
                title: Text(t.forPeer),
              )
            : null,
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(forBoth || !private), child: Text(pin ? t.pin : t.unpin)),
        ],
      ),
    ),
  );
}
