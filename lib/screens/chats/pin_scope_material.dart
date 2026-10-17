import 'package:material_ui/material_ui.dart';

import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_actions_material.dart';
import 'chat_common.dart';

/// Закрепить ([pin]) / открепить сообщение, [allCount] — «Открепить все».
/// Личный чат ([chatDeleteScoped]) — шторка «У меня» / «У меня и собеседника»
/// ([pickScopeMaterial]); иначе закреп сразу (в «Избранном» — у себя),
/// открепление — с подтверждением. Результат — forEveryone, `null` — отмена.
Future<bool?> askPinScopeMaterial(BuildContext context, models.Chat chat, {required bool pin, int? allCount}) async {
  final t = context.t.screenChat;
  final title = pin ? t.pinTitle : (allCount != null ? t.unpinAllTitle : t.unpinTitle);
  if (chatDeleteScoped(chat)) return pickScopeMaterial(context, title: title, destructive: !pin);
  if (pin) return !chat.isSelf;
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.cancel)),
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.unpin)),
      ],
    ),
  );
}
