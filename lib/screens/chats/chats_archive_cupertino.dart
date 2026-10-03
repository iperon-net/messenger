import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../themes.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../components.dart';
import 'chat_actions_cupertino.dart';

/// «Архив» (iOS): архивные чаты, те же строки и long-press-действия, что в
/// списке («Из архива» вместо «В архив»).
class ChatsArchiveCupertino extends StatelessWidget {
  const ChatsArchiveCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
            return ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, _) => divider,
              itemBuilder: (context, index) => ChatTileCupertino(
                key: ValueKey(chats[index].id),
                chat: chats[index],
                onTap: () {},
                onLongPress: () => showChatActionsCupertino(context, chats[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
