import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';
import 'chat_cupertino.dart';

/// Экран «Закреплённые сообщения» (iOS) — значок списка в плашке
/// закреплённого. Результат — id сообщения, к которому перейти в чате.
Future<String?> showPinnedMessagesCupertino(BuildContext context, ChatCubit cubit) {
  return Navigator.of(context).push<String>(
    CupertinoPageRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const PinnedMessagesCupertino()),
    ),
  );
}

/// Все закреплённые чата лентой, как в Telegram: тап — перейти к сообщению,
/// удержание — «Перейти» / «Открепить», внизу — «Открепить все» (в канале
/// подписчику — нет). Открепили последнее — экран закрывается.
class PinnedMessagesCupertino extends StatelessWidget {
  const PinnedMessagesCupertino({super.key});

  void _goTo(BuildContext context, models.Message message) => Navigator.of(context).pop(message.id);

  Future<void> _actions(BuildContext context, models.Message message, bool canUnpin) async {
    final t = context.t.screenChat;
    final cubit = context.read<ChatCubit>();
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(sheetContext).pop();
              _goTo(context, message);
            },
            child: Text(t.goToMessage),
          ),
          if (canUnpin)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(sheetContext).pop();
                cubit.setPinned(message, false);
              },
              child: Text(t.unpin),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(context.t.common.cancel)),
      ),
    );
  }

  Future<void> _unpinAll(BuildContext context, int count) async {
    final t = context.t.screenChat;
    final cubit = context.read<ChatCubit>();
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.unpinAllTitle(n: count)),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.unpin)),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.unpinAll();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final dark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final barColor = ThemesCupertino.appBackground.resolveFrom(context).withValues(alpha: 0.92);
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
        return CupertinoPageScaffold(
          backgroundColor: dark ? const Color(0xFF000000) : CupertinoColors.systemGroupedBackground.resolveFrom(context),
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: '',
            automaticBackgroundVisibility: false,
            backgroundColor: barColor,
            middle: Text(pinned.isEmpty ? t.pinnedAll : t.pinnedList(n: pinned.length)),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: ChatWallpaperLayer(dark: dark)),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Expanded(
                      child: chat == null
                          ? const SizedBox.shrink()
                          : ChatMessagesView(
                              messages: pinned,
                              chatType: chat.type,
                              style: ChatCupertino.bubbleStyle(context),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              onLongPress: (message) => _actions(context, message, canUnpin),
                              onTap: (message) => _goTo(context, message),
                              onMediaTap: (message, _) => _goTo(context, message),
                            ),
                    ),
                    if (canUnpin && pinned.isNotEmpty)
                      ColoredBox(
                        color: barColor,
                        child: SafeArea(
                          top: false,
                          child: SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              onPressed: () => _unpinAll(context, pinned.length),
                              child: Text(t.unpinAll, style: TextStyle(color: CupertinoColors.destructiveRed.resolveFrom(context))),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
