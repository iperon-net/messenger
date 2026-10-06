import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_create_common.dart';
import 'chat_invites_common.dart';

/// «Заявки на вступление» (iOS) — профиль чата → админ.
Future<void> showChatJoinRequestsCupertino(BuildContext context, String chatID) {
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider(
        create: (_) => ChatInvitesCubit()..initialization(chatID: chatID, demo: demo),
        child: const ChatJoinRequestsCupertino(),
      ),
    ),
  );
}

/// Заявки от новых к старым: имя, «о себе», когда и по какой ссылке;
/// «Принять» / «Отклонить». Несколько — в шапке «Все» (принять / отклонить
/// все).
class ChatJoinRequestsCupertino extends StatelessWidget {
  const ChatJoinRequestsCupertino({super.key});

  Future<void> _all(BuildContext context) async {
    final t = context.t.screenChatInvites;
    final cubit = context.read<ChatInvitesCubit>();
    final approve = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(true), child: Text(t.approveAll)),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(sheetContext).pop(false),
            child: Text(t.declineAll),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(context.t.common.cancel)),
      ),
    );
    if (approve != null) await cubit.answer(approve: approve);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final tc = t.screenChatInvites;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);

    return BlocBuilder<ChatInvitesCubit, ChatInvitesState>(
      builder: (context, state) {
        final chat = state.chat;
        final requests = state.requests;
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(tc.joinRequests),
              trailing: requests.length > 1
                  ? CupertinoButton(padding: EdgeInsets.zero, onPressed: () => _all(context), child: Text(tc.all))
                  : null,
            ),
          ),
          child: SafeArea(
            child: requests.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tc.requestsEmpty,
                            style: TextStyle(
                              fontSize: AppFontSizes.value,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.label.resolveFrom(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            chat != null && chat.joinMode != models.ChatJoinMode.request ? tc.requestsOffHint : tc.requestsEmptyHint,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: AppFontSizes.caption, color: secondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      CupertinoListSection.insetGrouped(
                        backgroundColor: background,
                        decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
                        children: [for (final request in requests) _RequestTile(request: request)],
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
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
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
                Text(
                  request.name,
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                if (request.about.isNotEmpty)
                  Text(
                    request.about,
                    style: TextStyle(fontSize: AppFontSizes.listTitle, color: CupertinoColors.label.resolveFrom(context)),
                  ),
                const SizedBox(height: 2),
                Text(
                  joinRequestSubtitle(t, request),
                  style: TextStyle(fontSize: AppFontSizes.caption, color: secondary),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CupertinoButton.filled(
                      sizeStyle: CupertinoButtonSize.small,
                      onPressed: () => cubit.answer(request: request, approve: true),
                      child: Text(t.screenChatInvites.approve),
                    ),
                    const SizedBox(width: 8),
                    CupertinoButton.tinted(
                      sizeStyle: CupertinoButtonSize.small,
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
