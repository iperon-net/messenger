import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_ui/material_ui.dart';

import '../../themes.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../components.dart';
import 'chat_actions_material.dart';
import 'chat_swipe_actions.dart';

/// «Архив» (Android): архивные чаты, те же строки и long-press-действия, что в
/// списке («Из архива» вместо «В архив»).
class ChatsArchiveMaterial extends StatelessWidget {
  const ChatsArchiveMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(backgroundColor: background, title: Text(context.t.screenChats.archive)),
      body: BlocBuilder<ChatsCubit, ChatsState>(
        builder: (context, state) {
          final chats = state.archived;
          if (chats.isEmpty) return Center(child: Text(context.t.screenChats.emptyArchive));
          return SlidableAutoCloseBehavior(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) => ChatSwipeActions(
                key: ValueKey(chats[index].id),
                chat: chats[index],
                enabled: true,
                confirmDelete: () => confirmDeleteChatMaterial(context, chats[index]),
                child: ChatTileMaterial(
                  chat: chats[index],
                  onTap: () => context.push('/chats/chat/${chats[index].id}'),
                  onLongPress: () => showChatActionsMaterial(context, chats[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
