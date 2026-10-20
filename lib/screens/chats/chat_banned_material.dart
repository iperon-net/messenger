import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../chats/member_search.dart';
import 'chats_new_material.dart';

/// «Заблокированные» (Android) — профиль группы → админ.
Future<void> showChatBannedMaterial(BuildContext context, ChatCubit cubit) {
  // Список — только с сервера: освежаем при открытии (без сети — пометка).
  unawaited(cubit.loadMembers());
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const ChatBannedMaterial()),
    ),
  );
}

/// Заблокированные участники: поиск по имени / @username, справа —
/// «Разблокировать» (строка рассыпается в пыль).
class ChatBannedMaterial extends StatefulWidget {
  const ChatBannedMaterial({super.key});

  @override
  State<ChatBannedMaterial> createState() => _ChatBannedMaterialState();
}

class _ChatBannedMaterialState extends State<ChatBannedMaterial> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final found = filterMembers(state.banned, _query);
        return Scaffold(
          backgroundColor: scheme.surfaceContainerLow,
          appBar: AppBar(backgroundColor: scheme.surfaceContainerLow, title: Text(t.screenChatInfo.banned)),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(top: 8),
              children: [
                if (state.banned.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: t.screenChatInfo.membersSearch,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ),
                if (found.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 8),
                    child: Text(
                      state.banned.isNotEmpty
                          ? t.screenChatInfo.membersNotFound
                          : (state.bannedLoadFailed ? t.screenChatInfo.bannedLoadFailed : t.screenChatInfo.bannedEmpty),
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
                        for (final member in found)
                          DustDismiss(
                            key: ValueKey(member.id),
                            builder: (context, dissolve) => Row(
                              children: [
                                Expanded(child: ContactTileMaterial(contact: member)),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: IconButton(
                                    tooltip: t.screenChatInfo.unban,
                                    onPressed: () {
                                      final cubit = context.read<ChatCubit>();
                                      dissolve(() => cubit.unbanMember(member));
                                    },
                                    icon: HugeIcon(icon: HugeIcons.strokeRoundedDelete02, color: scheme.primary),
                                  ),
                                ),
                              ],
                            ),
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
