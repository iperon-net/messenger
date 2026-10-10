import 'package:go_router/go_router.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../themes.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../components.dart';
import 'chat_actions_cupertino.dart';
import 'chat_swipe_actions.dart';
import 'chat_common.dart';

/// «Архив» (iOS): архивные чаты, те же строки и long-press-действия, что в
/// списке («Из архива» вместо «В архив»).
class ChatsArchiveCupertino extends StatelessWidget {
  const ChatsArchiveCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatsOfflineListener<ChatsCubit, ChatsState>(
      notice: (state) => state.offlineNotice,
      child: CupertinoPageScaffold(
        backgroundColor: ThemesCupertino.appBackground,
        navigationBar: AppCupertinoNavigationBar(
          child: CupertinoNavigationBar(
            previousPageTitle: '',
            automaticBackgroundVisibility: false,
            backgroundColor: ThemesCupertino.appBackground,
            middle: Text(context.t.screenChats.archive),
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<ChatsCubit, ChatsState>(
            builder: (context, state) {
              final chats = state.archived;
              if (chats.isEmpty) {
                return Center(
                  child: Text(
                    context.t.screenChats.emptyArchive,
                    style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                  ),
                );
              }
              final divider = Container(
                margin: const EdgeInsetsDirectional.only(start: ChatTileCupertino.dividerIndent),
                height: 0.5,
                color: CupertinoColors.separator.resolveFrom(context),
              );
              return SlidableAutoCloseBehavior(
                child: ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (_, _) => divider,
                  itemBuilder: (context, index) => ChatSwipeActions(
                    key: ValueKey(chats[index].id),
                    chat: chats[index],
                    enabled: true,
                    confirmDelete: () => confirmDeleteChatCupertino(context, chats[index]),
                    child: ChatContextMenuCupertino(chat: chats[index], onTap: () => context.push('/chats/chat/${chats[index].id}')),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
