import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../../chats/chats_sync.dart';
import '../../components/chats/message_bubble.dart' show chatTTLDay, chatTTLLabel;
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import 'chat_common.dart';

/// Автоудаление сообщений (как в Telegram): быстрые варианты — 1 день, 1
/// неделя, 1 месяц (31 день); «Другое…» — свой срок из [chatTTLCustomValues].
const chatTTLPresets = [chatTTLDay, 7 * chatTTLDay, 31 * chatTTLDay];

/// Свои сроки: 1–6 дней, 1–3 недели, 1–11 месяцев, 1 год (сервер принимает
/// любой кратный суткам до года).
final chatTTLCustomValues = [
  for (var d = 1; d <= 6; d++) d * chatTTLDay,
  for (var w = 1; w <= 3; w++) w * 7 * chatTTLDay,
  for (var mo = 1; mo <= 11; mo++) mo * 31 * chatTTLDay,
  365 * chatTTLDay,
];

/// Пункты выпадающего меню iOS (`CupertinoMenuAnchor`): варианты с галочкой у
/// текущего, «Другое…» (свой срок — колесо), «Выключить» (если включено).
/// [onSelected] получает новый таймер (секунды, 0 — выключить).
List<Widget> chatTTLMenuCupertino(BuildContext context, int current, ValueChanged<int> onPicked) {
  final t = context.t;
  // Тот же срок — без запроса.
  void onSelected(int period) {
    if (period != current) onPicked(period);
  }

  return [
    for (final period in chatTTLPresets)
      c.CupertinoMenuItem(
        trailing: current == period ? const Icon(c.CupertinoIcons.checkmark) : null,
        onPressed: () => onSelected(period),
        child: Text(chatTTLLabel(t, period)),
      ),
    c.CupertinoMenuItem(
      trailing: current > 0 && !chatTTLPresets.contains(current) ? const Icon(c.CupertinoIcons.checkmark) : null,
      onPressed: () async {
        final period = await pickChatTTLCustom(context, current);
        if (period != null) onSelected(period);
      },
      child: Text(current > 0 && !chatTTLPresets.contains(current) ? chatTTLLabel(t, current) : t.chatTtl.other),
    ),
    if (current > 0)
      c.CupertinoMenuItem(
        isDestructiveAction: true,
        trailing: const Icon(c.CupertinoIcons.timer),
        onPressed: () => onSelected(0),
        child: Text(t.chatTtl.turnOff),
      ),
  ];
}

/// Android: нижний лист с вариантами (галочка у текущего), «Другое…» —
/// диалог со своим сроком. `null` — закрыли.
Future<int?> pickChatTTLMaterial(BuildContext context, int current) async {
  final t = context.t;
  const other = -1;
  final picked = await m.showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      Widget option(int period, String label) => m.ListTile(
        leading: m.Icon(period == 0 ? m.Icons.timer_off_outlined : m.Icons.timer_outlined),
        title: Text(label),
        trailing: current == period ? const m.Icon(m.Icons.check) : null,
        onTap: () => Navigator.of(sheetContext).pop(period),
      );
      final custom = current > 0 && !chatTTLPresets.contains(current);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(t.chatTtl.titleLong, style: m.Theme.of(sheetContext).textTheme.titleMedium),
            ),
            option(0, t.chatTtl.off),
            for (final period in chatTTLPresets) option(period, chatTTLLabel(t, period)),
            m.ListTile(
              leading: const m.Icon(m.Icons.more_time),
              title: Text(custom ? chatTTLLabel(t, current) : t.chatTtl.other),
              trailing: custom ? const m.Icon(m.Icons.check) : null,
              onTap: () => Navigator.of(sheetContext).pop(other),
            ),
          ],
        ),
      );
    },
  );
  if (picked != other || !context.mounted) return picked;
  return pickChatTTLCustom(context, current);
}

/// Свой срок: iOS — колесо в нижней панели («Готово»), Android — диалог со
/// списком. `null` — отмена.
Future<int?> pickChatTTLCustom(BuildContext context, int current) {
  final t = context.t;
  final values = chatTTLCustomValues;
  final initial = values.contains(current) ? values.indexOf(current) : 0;
  if (Platform.isIOS) {
    var selected = initial;
    return c.showCupertinoModalPopup<int>(
      context: context,
      builder: (popupContext) => Container(
        height: 300,
        color: c.CupertinoColors.systemBackground.resolveFrom(popupContext),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                children: [
                  c.CupertinoButton(onPressed: () => Navigator.of(popupContext).pop(), child: Text(t.common.cancel)),
                  Expanded(
                    child: Text(
                      t.chatTtl.customTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  c.CupertinoButton(
                    onPressed: () => Navigator.of(popupContext).pop(values[selected]),
                    child: Text(t.chatTtl.done, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              Expanded(
                child: c.CupertinoPicker(
                  itemExtent: 36,
                  scrollController: c.FixedExtentScrollController(initialItem: initial),
                  onSelectedItemChanged: (index) => selected = index,
                  children: [for (final period in values) Center(child: Text(chatTTLLabel(t, period)))],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return m.showDialog<int>(
    context: context,
    builder: (dialogContext) => m.AlertDialog(
      title: Text(t.chatTtl.customTitle),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: SizedBox(
        width: double.maxFinite,
        height: 360,
        child: ListView(
          controller: ScrollController(initialScrollOffset: (initial * 48.0 - 144).clamp(0, double.infinity)),
          children: [
            for (final period in values)
              m.ListTile(
                title: Text(chatTTLLabel(t, period)),
                trailing: period == current ? const m.Icon(m.Icons.check) : null,
                onTap: () => Navigator.of(dialogContext).pop(period),
              ),
          ],
        ),
      ),
      actions: [m.TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(t.common.cancel))],
    ),
  );
}

/// Поменять автоудаление чата: без сети — «Нет соединения» (экран чата), лимит
/// частоты — «попробуйте через …», собеседник ограничил, кто может писать, —
/// объяснение (iOS — алерт, Android — SnackBar).
Future<void> setChatTTL(BuildContext context, ChatCubit cubit, int period) async {
  try {
    await cubit.setTTL(period);
  } on ChatsFloodException catch (error) {
    if (context.mounted) showChatsFlood(context, error.seconds);
  } on ChatsRequestException catch (error) {
    if (!error.isPrivacyRestricted || !context.mounted) rethrow;
    final text = context.t.chatTtl.restricted;
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
}
