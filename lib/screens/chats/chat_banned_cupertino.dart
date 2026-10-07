import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
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

/// Заблокированные участники; удержание — контекстное меню «Разблокировать».
class ChatBannedCupertino extends StatelessWidget {
  const ChatBannedCupertino({super.key});

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
                      for (final member in state.banned)
                        RowContextMenuCupertino(
                          background: ThemesCupertino.groupedCard.resolveFrom(context),
                          actions: [
                            rowMenuAction(
                              context,
                              t.screenChatInfo.unban,
                              CupertinoIcons.lock_open,
                              () => context.read<ChatCubit>().unbanMember(member),
                            ),
                          ],
                          child: ContactTileCupertino(contact: member),
                        ),
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
