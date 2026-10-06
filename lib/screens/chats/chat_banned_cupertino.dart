import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chats_new_cupertino.dart';

/// «Заблокированные» (iOS) — профиль группы → админ.
Future<void> showChatBannedCupertino(BuildContext context, ChatCubit cubit) {
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const ChatBannedCupertino()),
    ),
  );
}

/// Заблокированные участники; тап — «Разблокировать».
class ChatBannedCupertino extends StatelessWidget {
  const ChatBannedCupertino({super.key});

  Future<void> _actions(BuildContext context, models.ChatMember member) async {
    final cubit = context.read<ChatCubit>();
    final unban = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(member.name),
        actions: [
          CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(true), child: Text(context.t.screenChatInfo.unban)),
        ],
        cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(context.t.common.cancel)),
      ),
    );
    if (unban ?? false) await cubit.unbanMember(member);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(t.screenChatInfo.banned),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                if (state.banned.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 40, 32, 8),
                    child: Text(
                      t.screenChatInfo.bannedEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: AppFontSizes.body, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                    ),
                  )
                else
                  CupertinoListSection.insetGrouped(
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    children: [
                      for (final member in state.banned) ContactTileCupertino(contact: member, onTap: () => _actions(context, member)),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: createNoteCupertino(t.screenChatInfo.bannedFooter),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
