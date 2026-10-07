import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import 'chats_new_material.dart';

/// «Заблокированные» (Android) — профиль группы → админ.
Future<void> showChatBannedMaterial(BuildContext context, ChatCubit cubit) {
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const ChatBannedMaterial()),
    ),
  );
}

/// Заблокированные участники; справа — «Разблокировать».
class ChatBannedMaterial extends StatelessWidget {
  const ChatBannedMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: scheme.surfaceContainerLow,
          appBar: AppBar(backgroundColor: scheme.surfaceContainerLow, title: Text(t.screenChatInfo.banned)),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(top: 8),
              children: [
                if (state.banned.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 8),
                    child: Text(
                      t.screenChatInfo.bannedEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  )
                else
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (final member in state.banned)
                          Row(
                            children: [
                              Expanded(child: ContactTileMaterial(contact: member)),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: TextButton(
                                  onPressed: () => context.read<ChatCubit>().unbanMember(member),
                                  child: Text(t.screenChatInfo.unban),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                createNoteMaterial(context, t.screenChatInfo.bannedFooter),
              ],
            ),
          ),
        );
      },
    );
  }
}
