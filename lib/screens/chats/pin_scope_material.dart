import 'package:material_ui/material_ui.dart';

import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_actions_material.dart';
import 'chat_common.dart';

/// Закрепить ([pin]) / открепить сообщение, [allCount] — «Открепить все».
/// Личный чат ([chatDeleteScoped]) — шторка «У меня» / «У меня и собеседника»
/// ([pickScopeMaterial]); иначе закреп сразу (в «Избранном» — у себя),
/// открепление — с подтверждением. Открепление закреплённого только у меня
/// ([shared] — false; у «Открепить все» — ни одного общего) — сразу, без
/// выбора. Группа: у всех — только с правом [canForAll] (иначе только у
/// себя). Результат — forEveryone, `null` — отмена.
Future<bool?> askPinScopeMaterial(
  BuildContext context,
  models.Chat chat, {
  required bool pin,
  int? allCount,
  bool shared = true,
  bool canForAll = true,
}) async {
  final t = context.t.screenChat;
  final title = pin ? t.pinTitle : (allCount != null ? t.unpinAllTitle : t.unpinTitle);
  final group = chat.type == models.ChatType.group;
  if (!pin && chatDeleteScoped(chat) && !shared) return false;
  if (chatDeleteScoped(chat)) return pickScopeMaterial(context, title: title, destructive: !pin);
  if (pin) return !chat.isSelf && (!group || canForAll);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.cancel)),
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.unpin)),
      ],
    ),
  );
  // Группа: общий закреп снимается у всех (с правом), свой — только у себя.
  if (confirmed == null || !group) return confirmed;
  return shared && canForAll;
}
