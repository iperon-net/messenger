import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_create_common.dart';
import 'chat_invites_common.dart';

/// «Заявки на вступление» (Android) — профиль чата → админ.
Future<void> showChatJoinRequestsMaterial(BuildContext context, String chatID) {
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider(
        create: (_) => ChatInvitesCubit()..initialization(chatID: chatID, demo: demo),
        child: const ChatJoinRequestsMaterial(),
      ),
    ),
  );
}

/// Заявки от новых к старым: имя, «о себе», когда и по какой ссылке;
/// «Принять» / «Отклонить». Несколько — в шапке меню «Принять все /
/// Отклонить все».
class ChatJoinRequestsMaterial extends StatelessWidget {
  const ChatJoinRequestsMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final tc = t.screenChatInvites;
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<ChatInvitesCubit, ChatInvitesState>(
      builder: (context, state) {
        final chat = state.chat;
        final requests = state.requests;
        return Scaffold(
          backgroundColor: scheme.surfaceContainerLow,
          appBar: AppBar(
            backgroundColor: scheme.surfaceContainerLow,
            title: Text(tc.joinRequests),
            actions: [
              if (requests.length > 1)
                PopupMenuButton<bool>(
                  onSelected: (approve) => context.read<ChatInvitesCubit>().answer(approve: approve),
                  itemBuilder: (_) => [
                    PopupMenuItem(value: true, child: Text(tc.approveAll)),
                    PopupMenuItem(
                      value: false,
                      child: Text(tc.declineAll, style: TextStyle(color: scheme.error)),
                    ),
                  ],
                ),
            ],
          ),
          body: SafeArea(
            child: requests.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(tc.requestsEmpty, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                            chat != null && chat.joinMode != models.ChatJoinMode.request ? tc.requestsOffHint : tc.requestsEmptyHint,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            for (final (i, request) in requests.indexed) ...[
                              if (i > 0) const Divider(height: 1, indent: 72),
                              _RequestTile(request: request),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _RequestTile extends StatelessWidget {
  final models.ChatJoinRequest request;

  const _RequestTile({required this.request});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final cubit = context.read<ChatInvitesCubit>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContactAvatar(
            contact: models.ChatMember(id: request.userID, name: request.name),
            size: 44,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.name, style: text.titleMedium),
                if (request.about.isNotEmpty) Text(request.about, style: text.bodyMedium),
                const SizedBox(height: 2),
                Text(joinRequestSubtitle(t, request), style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () => cubit.answer(request: request, approve: true),
                      child: Text(t.screenChatInvites.approve),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => cubit.answer(request: request, approve: false),
                      child: Text(t.screenChatInvites.decline),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
