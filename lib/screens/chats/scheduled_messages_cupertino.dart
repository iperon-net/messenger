import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';
import 'chat_cupertino.dart';
import 'message_context_menu_cupertino.dart';

/// «Отправить позже» (iOS): дата и время колесом, не раньше текущей минуты.
/// `null` — отмена.
Future<DateTime?> showScheduleDateCupertino(BuildContext context, {DateTime? initial}) {
  final now = DateTime.now();
  final minimum = DateTime(now.year, now.month, now.day, now.hour, now.minute);
  var selected = initial != null && initial.isAfter(minimum) ? initial : minimum.add(const Duration(hours: 1));
  return showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (popupContext) => Container(
      height: 320,
      color: CupertinoColors.systemBackground.resolveFrom(popupContext),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              children: [
                CupertinoButton(
                  onPressed: () => Navigator.of(popupContext).pop(),
                  child: Text(context.t.common.cancel, style: TextStyle(color: ThemesCupertino.actionColor(context))),
                ),
                const Spacer(),
                CupertinoButton(
                  onPressed: () => Navigator.of(popupContext).pop(selected),
                  child: Text(
                    context.t.screenChat.schedule,
                    style: TextStyle(fontWeight: FontWeight.w600, color: ThemesCupertino.actionColor(context)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                use24hFormat: true,
                minimumDate: minimum,
                maximumDate: minimum.add(const Duration(days: 365)),
                initialDateTime: selected,
                onDateTimeChanged: (value) => selected = value,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Экран «Отложенные сообщения» (iOS) — значок календаря в поле ввода.
Future<void> showScheduledMessagesCupertino(BuildContext context, ChatCubit cubit) {
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const ScheduledMessagesCupertino()),
    ),
  );
}

/// Отложенные лентой по дням отправки (время в пузыре — когда уйдёт), как в
/// Telegram; удержание — контекстное меню «Отправить сейчас» / «Изменить
/// время» / «Удалить». Отложенных не осталось — экран закрывается.
class ScheduledMessagesCupertino extends StatelessWidget {
  const ScheduledMessagesCupertino({super.key});

  /// Действия в контекстном меню пузыря (удержание): меню — маршрут
  /// корневого навигатора, сначала закрываем его, потом действие.
  List<Widget> _menuActions(BuildContext context, models.Message message) {
    final t = context.t.screenChat;
    CupertinoContextMenuAction item(String action, String label, IconData icon, {bool destructive = false}) => CupertinoContextMenuAction(
      trailingIcon: icon,
      isDestructiveAction: destructive,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        _action(context, message, action);
      },
      child: Text(label),
    );
    return [
      item('now', t.sendNow, CupertinoIcons.paperplane),
      item('reschedule', t.reschedule, CupertinoIcons.calendar),
      item('delete', t.delete, CupertinoIcons.delete, destructive: true),
    ];
  }

  Future<void> _action(BuildContext context, models.Message message, String action) async {
    final t = context.t.screenChat;
    final cubit = context.read<ChatCubit>();
    switch (action) {
      case 'now':
        await cubit.sendScheduledNow(message);
      case 'reschedule':
        final date = await showScheduleDateCupertino(context, initial: message.scheduledDate);
        if (date != null) await cubit.reschedule(message, date);
      case 'delete':
        final confirmed = await showCupertinoDialog<bool>(
          context: context,
          builder: (dialogContext) => CupertinoAlertDialog(
            title: Text(t.deleteScheduledTitle),
            actions: [
              CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(t.delete),
              ),
            ],
          ),
        );
        if (confirmed ?? false) await cubit.deleteScheduled(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final dark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final barColor = ThemesCupertino.appBackground.resolveFrom(context).withValues(alpha: 0.92);
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (previous, current) => previous.scheduled.isNotEmpty && current.scheduled.isEmpty,
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent ?? false) Navigator.of(context).pop();
      },
      builder: (context, state) {
        final chat = state.chat;
        // Дата в ленте — время отправки: разделители дней и время в пузыре.
        final scheduled = [for (final m in state.scheduled) m.copyWith(date: m.scheduledDate ?? m.date)];
        return CupertinoPageScaffold(
          backgroundColor: dark ? const Color(0xFF000000) : CupertinoColors.systemGroupedBackground.resolveFrom(context),
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: barColor,
              middle: Text(t.scheduledTitle),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: ChatWallpaperLayer(dark: dark)),
              SafeArea(
                child: chat == null
                    ? const SizedBox.shrink()
                    : ChatMessagesView(
                        messages: scheduled,
                        chatType: chat.type,
                        style: ChatCupertino.bubbleStyle(context),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        // Удержание — CupertinoContextMenu (menuWrapper).
                        onLongPress: (_) {},
                        menuWrapper: (message, bubble, preview) => MessageContextMenuCupertino(
                          actions: _menuActions(context, message),
                          bubble: bubble,
                          preview: (maxWidth) => preview(maxWidth),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
