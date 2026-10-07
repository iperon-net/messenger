import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_invite_link_edit_material.dart';
import 'chat_invites_common.dart';
import 'chats_new_material.dart';

/// «Ссылки-приглашения» (Android) — профиль чата → админ.
Future<void> showChatInviteLinksMaterial(BuildContext context, String chatID) {
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider(
        create: (_) => ChatInvitesCubit()..initialization(chatID: chatID, demo: demo),
        child: const ChatInviteLinksMaterial(),
      ),
    ),
  );
}

/// Основная ссылка (копировать / поделиться / заменить) или публичная,
/// дополнительные ссылки (создать; тап — копировать, поделиться, изменить,
/// отозвать) и отозванные (удалить).
class ChatInviteLinksMaterial extends StatelessWidget {
  const ChatInviteLinksMaterial({super.key});

  void _copy(BuildContext context, String path) {
    copyInvite(path);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t.screenChatInvites.copied)));
  }

  Future<bool> _confirm(BuildContext context, {required String title, required String message, required String action}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(action),
          ),
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
    final error = Theme.of(context).colorScheme.error;
    Widget item(BuildContext sheetContext, List<List<dynamic>> icon, String title, String value, {bool destructive = false}) => ListTile(
      leading: HugeIcon(icon: icon, color: destructive ? error : null),
      title: Text(title, style: destructive ? TextStyle(color: error) : null),
      onTap: () => Navigator.of(sheetContext).pop(value),
    );
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (link.revoked)
              item(sheetContext, HugeIcons.strokeRoundedDelete02, t.delete, 'delete', destructive: true)
            else ...[
              item(sheetContext, HugeIcons.strokeRoundedCopy01, t.copy, 'copy'),
              item(sheetContext, HugeIcons.strokeRoundedShare08, t.share, 'share'),
              item(sheetContext, HugeIcons.strokeRoundedPencilEdit02, t.edit, 'edit'),
              item(sheetContext, HugeIcons.strokeRoundedLinkBackward, t.revoke, 'revoke', destructive: true),
            ],
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'copy':
        _copy(context, link.link);
      case 'share':
        await shareInvite(link.link);
      case 'edit':
        await showChatInviteLinkEditMaterial(context, cubit, link: link);
      case 'revoke':
        if (await _confirm(context, title: t.revokeTitle, message: t.revokeMessage, action: t.revoke)) await cubit.revokeLink(link);
      case 'delete':
        await cubit.deleteRevoked(link: link);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;

    Widget card(List<Widget> children) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );

    Widget linkIcon(bool active) => CircleAvatar(
      radius: 15,
      backgroundColor: active ? const Color(0xFF2E7D32) : scheme.outline,
      child: const HugeIcon(icon: HugeIcons.strokeRoundedLink01, color: Colors.white, size: 15),
    );

    Widget linkTile(models.ChatInviteLink link, DateTime now) {
      final subtitle = inviteSubtitle(t, link, now);
      return ListTile(
        leading: linkIcon(link.isActive(now)),
        title: Text(inviteTitle(link)),
        subtitle: Text(subtitle.text, style: TextStyle(color: subtitle.warning ? scheme.error : scheme.onSurfaceVariant)),
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

        return Scaffold(
          backgroundColor: scheme.surfaceContainerLow,
          appBar: AppBar(backgroundColor: scheme.surfaceContainerLow, title: Text(t.screenChatInvites.inviteLinks)),
          body: chat == null
              ? const SizedBox.shrink()
              : SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      if (chat.joinMode == models.ChatJoinMode.admins) createNoteMaterial(context, t.screenChatInvites.adminsOnlyNote),
                      if (path != null) ...[
                        createHeaderMaterial(context, public ? t.screenChatInvites.publicLink : t.screenChatInvites.primaryLink),
                        card([
                          // Ссылка в поле, справа — «Копировать» и «Поделиться» значками.
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              padding: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _copy(context, path),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: Text(
                                          inviteShort(path),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: t.screenChatInvites.copy,
                                    onPressed: () => _copy(context, path),
                                    icon: HugeIcon(icon: HugeIcons.strokeRoundedCopy01, color: scheme.primary, size: 21),
                                  ),
                                  IconButton(
                                    tooltip: t.screenChatInvites.share,
                                    onPressed: () => shareInvite(path),
                                    icon: HugeIcon(icon: HugeIcons.strokeRoundedShare08, color: scheme.primary, size: 21),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!public && primaryLink != null)
                            ListTile(
                              title: Text(t.screenChatInvites.replace, style: TextStyle(color: scheme.error)),
                              onTap: () => _replace(context, primaryLink),
                            ),
                        ]),
                        createNoteMaterial(context, public ? t.screenChatInvites.publicLinkFooter : invitePrimaryFooter(t, chat)),
                      ],
                      createHeaderMaterial(context, t.screenChatInvites.additionalHeader),
                      card([
                        ListTile(
                          leading: CircleAvatar(
                            radius: 15,
                            backgroundColor: scheme.primaryContainer,
                            child: Icon(Icons.add, size: 18, color: scheme.onPrimaryContainer),
                          ),
                          title: Text(t.screenChatInvites.createLink, style: TextStyle(color: scheme.primary)),
                          onTap: () => showChatInviteLinkEditMaterial(context, context.read<ChatInvitesCubit>()),
                        ),
                        for (final link in state.additional) linkTile(link, now),
                      ]),
                      createNoteMaterial(context, t.screenChatInvites.additionalFooter),
                      if (state.revoked.isNotEmpty) ...[
                        createHeaderMaterial(context, t.screenChatInvites.revokedHeader),
                        card([
                          ListTile(
                            title: Text(t.screenChatInvites.deleteAllRevoked, style: TextStyle(color: scheme.error)),
                            onTap: () => context.read<ChatInvitesCubit>().deleteRevoked(),
                          ),
                          for (final link in state.revoked) linkTile(link, now),
                        ]),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }
}
