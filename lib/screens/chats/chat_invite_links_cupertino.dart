import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_invite_link_edit_cupertino.dart';
import 'chat_invites_common.dart';
import 'chats_new_cupertino.dart';

/// «Ссылки-приглашения» (iOS) — профиль чата → админ.
Future<void> showChatInviteLinksCupertino(BuildContext context, String chatID) {
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider(
        create: (_) => ChatInvitesCubit()..initialization(chatID: chatID, demo: demo),
        child: const ChatInviteLinksCupertino(),
      ),
    ),
  );
}

/// Основная ссылка (копировать / поделиться / заменить) или публичная,
/// дополнительные ссылки (создать; тап — копировать, поделиться, изменить,
/// отозвать) и отозванные (удалить).
class ChatInviteLinksCupertino extends StatelessWidget {
  const ChatInviteLinksCupertino({super.key});

  void _copy(String path) {
    copyInvite(path);
    HapticFeedback.selectionClick();
  }

  Future<bool> _confirm(BuildContext context, {required String title, required String message, required String action}) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(action)),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _replace(BuildContext context, models.ChatInviteLink link) async {
    final t = context.t.screenChatInvites;
    final cubit = context.read<ChatInvitesCubit>();
    if (await _confirm(context, title: t.replaceTitle, message: t.replaceMessage, action: t.replace)) await cubit.revokeLink(link);
  }

  Future<void> _linkActions(BuildContext context, models.ChatInviteLink link) async {
    final t = context.t.screenChatInvites;
    final cubit = context.read<ChatInvitesCubit>();
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(inviteShort(link.link)),
        actions: [
          if (link.revoked)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(sheetContext).pop('delete'),
              child: Text(t.delete),
            )
          else ...[
            CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop('copy'), child: Text(t.copy)),
            CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop('share'), child: Text(t.share)),
            CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop('edit'), child: Text(t.edit)),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(sheetContext).pop('revoke'),
              child: Text(t.revoke),
            ),
          ],
        ],
        cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(context.t.common.cancel)),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'copy':
        _copy(link.link);
      case 'share':
        await shareInvite(link.link);
      case 'edit':
        await showChatInviteLinkEditCupertino(context, cubit, link: link);
      case 'revoke':
        if (await _confirm(context, title: t.revokeTitle, message: t.revokeMessage, action: t.revoke)) await cubit.revokeLink(link);
      case 'delete':
        await cubit.deleteRevoked(link: link);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final action = ThemesCupertino.actionColor(context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final destructive = CupertinoColors.destructiveRed.resolveFrom(context);
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);

    Widget section({String? header, String? footer, required List<Widget> children}) => CupertinoListSection.insetGrouped(
      header: header == null ? null : createHeaderCupertino(header),
      footer: footer == null ? null : createNoteCupertino(footer),
      backgroundColor: background,
      decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
      children: children,
    );

    Widget linkIcon(bool active) => Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF34C759) : CupertinoColors.systemGrey.resolveFrom(context),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const HugeIcon(icon: HugeIcons.strokeRoundedLink01, color: Color(0xFFFFFFFF), size: 18),
    );

    Widget linkTile(models.ChatInviteLink link, DateTime now) {
      final subtitle = inviteSubtitle(t, link, now);
      return CupertinoListTile(
        leadingSize: 36,
        leading: linkIcon(link.isActive(now)),
        title: Text(inviteTitle(link)),
        subtitle: Text(subtitle.text, style: TextStyle(color: subtitle.warning ? destructive : secondary)),
        onTap: () => _linkActions(context, link),
      );
    }

    return BlocBuilder<ChatInvitesCubit, ChatInvitesState>(
      builder: (context, state) {
        final chat = state.chat;
        final now = DateTime.now();
        final primaryLink = state.primary;
        final public = chat != null && chat.username.isNotEmpty;
        final path = public ? chat.username : primaryLink?.link;

        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(t.screenChatInvites.inviteLinks),
            ),
          ),
          child: chat == null
              ? const SizedBox.shrink()
              : SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      if (chat.joinMode == models.ChatJoinMode.admins)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          child: createNoteCupertino(t.screenChatInvites.adminsOnlyNote),
                        ),
                      if (path != null)
                        section(
                          header: public ? t.screenChatInvites.publicLink : t.screenChatInvites.primaryLink,
                          footer: public ? t.screenChatInvites.publicLinkFooter : invitePrimaryFooter(t, chat),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  GestureDetector(
                                    onTap: () => _copy(path),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        inviteShort(path),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: AppFontSizes.body, color: CupertinoColors.label.resolveFrom(context)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CupertinoButton.filled(
                                          sizeStyle: CupertinoButtonSize.medium,
                                          onPressed: () => _copy(path),
                                          child: Text(t.screenChatInvites.copy),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: CupertinoButton.filled(
                                          sizeStyle: CupertinoButtonSize.medium,
                                          onPressed: () => shareInvite(path),
                                          child: Text(t.screenChatInvites.share),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (!public && primaryLink != null)
                              CupertinoListTile(
                                title: Text(t.screenChatInvites.replace, style: TextStyle(color: destructive)),
                                onTap: () => _replace(context, primaryLink),
                              ),
                          ],
                        ),
                      section(
                        header: t.screenChatInvites.additionalHeader,
                        footer: t.screenChatInvites.additionalFooter,
                        children: [
                          CupertinoListTile(
                            leadingSize: 36,
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(color: action.withValues(alpha: 0.12), shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Icon(CupertinoIcons.add, color: action, size: 20),
                            ),
                            title: Text(t.screenChatInvites.createLink, style: TextStyle(color: action)),
                            onTap: () => showChatInviteLinkEditCupertino(context, context.read<ChatInvitesCubit>()),
                          ),
                          for (final link in state.additional) linkTile(link, now),
                        ],
                      ),
                      if (state.revoked.isNotEmpty)
                        section(
                          header: t.screenChatInvites.revokedHeader,
                          children: [
                            CupertinoListTile(
                              title: Text(t.screenChatInvites.deleteAllRevoked, style: TextStyle(color: destructive)),
                              onTap: () => context.read<ChatInvitesCubit>().deleteRevoked(),
                            ),
                            for (final link in state.revoked) linkTile(link, now),
                          ],
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
