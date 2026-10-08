import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_info_material.dart';
import 'chat_material.dart';
import 'chats_new_material.dart';
import 'community_common.dart';

/// `/chats/chat/:id` (Android): у сообщества своей ленты нет — вместо окна
/// чата его страница (профиль организации + чаты сообщества, см.
/// [CommunityChatsMaterial]), у остальных — окно чата.
class ChatScreenMaterial extends StatefulWidget {
  const ChatScreenMaterial({super.key});

  @override
  State<ChatScreenMaterial> createState() => _ChatScreenMaterialState();
}

class _ChatScreenMaterialState extends State<ChatScreenMaterial> {
  /// Тип запоминается: сообщество удалили / покинули — страница остаётся до
  /// перехода в список, а не превращается в пустое окно чата.
  models.ChatType? _type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (previous, current) => previous.chat?.type != current.chat?.type || previous.status != current.status,
      builder: (context, state) {
        _type = state.chat?.type ?? _type;
        if (_type == null && state.status == Status.initialization) return const Scaffold();
        return _type == models.ChatType.community ? const ChatInfoMaterial() : const ChatMaterial();
      },
    );
  }
}

/// Чаты сообщества на его странице: канал объявлений, группы и каналы по
/// темам. Где мы участник — превью последнего сообщения и непрочитанные, где
/// нет — число участников и «Вступить» (закрытая тема — заявка). Админу —
/// «Создать группу / канал» (чаты создаются только внутри сообщества).
class CommunityChatsMaterial extends StatelessWidget {
  final models.Chat community;
  final List<models.Chat> chats;
  final Color card;

  const CommunityChatsMaterial({super.key, required this.community, required this.chats, required this.card});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок и подпись — как у карточек форм («Новое», «Изменить»).
        createHeaderMaterial(context, t.screenChatInfo.communityChats),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: card,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final chat in chats) _ChatRow(chat: chat),
              if (community.canManage) ...[
                ListTile(
                  leading: _CreateIcon(icon: HugeIcons.strokeRoundedUserGroup, color: scheme.primary),
                  title: Text(t.screenChatInfo.createGroup, style: TextStyle(color: scheme.primary)),
                  onTap: () => context.push('/chats/new/group/info?community=${community.id}'),
                ),
                ListTile(
                  leading: _CreateIcon(icon: HugeIcons.strokeRoundedMegaphone01, color: scheme.primary),
                  title: Text(t.screenChatInfo.createChannel, style: TextStyle(color: scheme.primary)),
                  onTap: () => context.push('/chats/new/channel?community=${community.id}'),
                ),
              ],
            ],
          ),
        ),
        createNoteMaterial(context, t.screenChatInfo.communityChatsFooter),
      ],
    );
  }
}

class _ChatRow extends StatelessWidget {
  final models.Chat chat;

  const _ChatRow({required this.chat});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    final row = communityChatRow(t, chat);
    return ListTile(
      leading: ChatAvatar(chat: chat, size: 40, accentColor: scheme.primary, accentForeground: scheme.onPrimary),
      title: Row(
        children: [
          Flexible(child: Text(row.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
          if (chat.joinMode == models.ChatJoinMode.request) ...[
            const SizedBox(width: 4),
            HugeIcon(icon: HugeIcons.strokeRoundedSquareLock02, size: 15, color: scheme.onSurfaceVariant),
          ],
          if (chat.joinMode == models.ChatJoinMode.admins) ...[
            const SizedBox(width: 4),
            HugeIcon(icon: HugeIcons.strokeRoundedViewOff, size: 15, color: scheme.onSurfaceVariant),
          ],
          if (chat.muted) ...[
            const SizedBox(width: 4),
            HugeIcon(icon: HugeIcons.strokeRoundedNotificationOff01, size: 15, color: scheme.onSurfaceVariant),
          ],
        ],
      ),
      subtitle: Text(row.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: _trailing(context, t, scheme),
      onTap: () => context.push('/chats/chat/${chat.id}'),
    );
  }

  Widget? _trailing(BuildContext context, Translations t, ColorScheme scheme) {
    if (chat.isMember) {
      if (!chat.hasUnread) return null;
      return Badge(
        backgroundColor: chat.muted ? scheme.outline : scheme.primary,
        textColor: chat.muted ? scheme.surface : scheme.onPrimary,
        label: chat.unreadCount > 0 ? Text(ChatTileContent.badge(chat.unreadCount)) : null,
      );
    }
    if (chat.joinRequested) return Text(t.screenChatInfo.requestPending, style: TextStyle(color: scheme.onSurfaceVariant));
    // В скрытую самому не вступить — добавляют админы (её видят только они).
    if (chat.joinMode == models.ChatJoinMode.admins) return null;
    return FilledButton.tonal(onPressed: () => context.read<ChatCubit>().joinCommunityChat(chat), child: Text(t.screenChatInfo.join));
  }
}

class _CreateIcon extends StatelessWidget {
  final List<List<dynamic>> icon;
  final Color color;

  const _CreateIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
    alignment: Alignment.center,
    child: HugeIcon(icon: icon, size: 20, color: color),
  );
}
