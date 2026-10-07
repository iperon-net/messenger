import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';
import 'chat_material.dart';

/// Экран «Закреплённые сообщения» (Android) — значок списка в плашке
/// закреплённого. Результат — id сообщения, к которому перейти в чате.
Future<String?> showPinnedMessagesMaterial(BuildContext context, ChatCubit cubit) {
  return Navigator.of(context).push<String>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const PinnedMessagesMaterial()),
    ),
  );
}

/// Все закреплённые чата лентой, как в Telegram: тап — перейти к сообщению,
/// удержание — «Перейти» / «Открепить», внизу — «Открепить все» (в канале
/// подписчику — нет). Открепили последнее — экран закрывается.
class PinnedMessagesMaterial extends StatelessWidget {
  const PinnedMessagesMaterial({super.key});

  void _goTo(BuildContext context, models.Message message) => Navigator.of(context).pop(message.id);

  Future<void> _actions(BuildContext context, models.Message message, bool canUnpin) async {
    final t = context.t.screenChat;
    final cubit = context.read<ChatCubit>();
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.arrow_forward),
              title: Text(t.goToMessage),
              onTap: () => Navigator.of(sheetContext).pop('go'),
            ),
            if (canUnpin)
              ListTile(
                leading: const Icon(Icons.push_pin_outlined),
                title: Text(t.unpin),
                onTap: () => Navigator.of(sheetContext).pop('unpin'),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'go':
        _goTo(context, message);
      case 'unpin':
        await cubit.setPinned(message, false);
    }
  }

  Future<void> _unpinAll(BuildContext context, int count) async {
    final t = context.t.screenChat;
    final cubit = context.read<ChatCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.unpinAllTitle(n: count)),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.unpin)),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.unpinAll();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final barColor = dark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (previous, current) => previous.pinnedMessages.isNotEmpty && current.pinnedMessages.isEmpty,
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent ?? false) Navigator.of(context).pop();
      },
      builder: (context, state) {
        final chat = state.chat;
        // В ленте — от старых к новым.
        final pinned = state.pinnedMessages.reversed.toList();
        final canUnpin = chat != null && chat.type != models.ChatType.channel;
        return Scaffold(
          backgroundColor: dark ? const Color(0xFF000000) : scheme.surfaceContainerLow,
          appBar: AppBar(
            backgroundColor: barColor,
            title: Text(pinned.isEmpty ? t.pinnedAll : t.pinnedList(n: pinned.length)),
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: ChatWallpaperLayer(dark: dark)),
                    if (chat != null)
                      ChatMessagesView(
                        messages: pinned,
                        chatType: chat.type,
                        style: ChatMaterial.bubbleStyle(context),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        onLongPress: (message) => _actions(context, message, canUnpin),
                        onTap: (message) => _goTo(context, message),
                        onMediaTap: (message, _) => _goTo(context, message),
                      ),
                  ],
                ),
              ),
              if (canUnpin && pinned.isNotEmpty)
                Material(
                  color: barColor,
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(foregroundColor: scheme.error, padding: const EdgeInsets.symmetric(vertical: 16)),
                        onPressed: () => _unpinAll(context, pinned.length),
                        child: Text(t.unpinAll),
                      ),
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
