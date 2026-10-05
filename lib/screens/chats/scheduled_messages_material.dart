import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';
import 'chat_material.dart';

/// «Отправить позже» (Android): дата, затем время. Прошедшее время —
/// через минуту. `null` — отмена.
Future<DateTime?> showScheduleDateMaterial(BuildContext context, {DateTime? initial}) async {
  final now = DateTime.now();
  final start = initial != null && initial.isAfter(now) ? initial : now.add(const Duration(hours: 1));
  final day = await showDatePicker(
    context: context,
    initialDate: start,
    firstDate: DateTime(now.year, now.month, now.day),
    lastDate: now.add(const Duration(days: 365)),
  );
  if (day == null || !context.mounted) return null;
  final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(start));
  if (time == null) return null;
  final date = DateTime(day.year, day.month, day.day, time.hour, time.minute);
  final soonest = DateTime.now().add(const Duration(minutes: 1));
  return date.isBefore(soonest) ? soonest : date;
}

/// Экран «Отложенные сообщения» (Android) — значок календаря в поле ввода.
Future<void> showScheduledMessagesMaterial(BuildContext context, ChatCubit cubit) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const ScheduledMessagesMaterial()),
    ),
  );
}

/// Отложенные лентой по дням отправки (время в пузыре — когда уйдёт), как в
/// Telegram; удержание или тап — «Отправить сейчас» / «Изменить время» /
/// «Удалить». Отложенных не осталось — экран закрывается.
class ScheduledMessagesMaterial extends StatelessWidget {
  const ScheduledMessagesMaterial({super.key});

  Future<void> _actions(BuildContext context, models.Message message) async {
    final t = context.t.screenChat;
    final cubit = context.read<ChatCubit>();
    final error = Theme.of(context).colorScheme.error;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.send), title: Text(t.sendNow), onTap: () => Navigator.of(sheetContext).pop('now')),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(t.reschedule),
              onTap: () => Navigator.of(sheetContext).pop('reschedule'),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: error),
              title: Text(t.delete, style: TextStyle(color: error)),
              onTap: () => Navigator.of(sheetContext).pop('delete'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'now':
        await cubit.sendScheduledNow(message);
      case 'reschedule':
        final date = await showScheduleDateMaterial(context, initial: message.scheduledDate);
        if (date != null) await cubit.reschedule(message, date);
      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(t.deleteScheduledTitle),
            actions: [
              TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
              TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.delete)),
            ],
          ),
        );
        if (confirmed ?? false) await cubit.deleteScheduled(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final barColor = dark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (previous, current) => previous.scheduled.isNotEmpty && current.scheduled.isEmpty,
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent ?? false) Navigator.of(context).pop();
      },
      builder: (context, state) {
        final chat = state.chat;
        // Дата в ленте — время отправки: разделители дней и время в пузыре.
        final scheduled = [for (final m in state.scheduled) m.copyWith(date: m.scheduledDate ?? m.date)];
        return Scaffold(
          backgroundColor: dark ? const Color(0xFF000000) : scheme.surfaceContainerLow,
          appBar: AppBar(backgroundColor: barColor, title: Text(t.scheduledTitle)),
          body: Stack(
            children: [
              Positioned.fill(child: ChatWallpaperLayer(dark: dark)),
              if (chat != null)
                SafeArea(
                  top: false,
                  child: ChatMessagesView(
                    messages: scheduled,
                    chatType: chat.type,
                    style: ChatMaterial.bubbleStyle(context),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    onLongPress: (message) => _actions(context, message),
                    onTap: (message) => _actions(context, message),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
