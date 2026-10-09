import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_cupertino.dart';
import 'chat_info_cupertino.dart';
import 'chats_new_cupertino.dart';
import 'community_common.dart';

/// `/chats/chat/:id` (iOS): у сообщества своей ленты нет — вместо окна чата
/// его страница (профиль организации + чаты сообщества, см.
/// [CommunityChatsCupertino]), у остальных — окно чата.
class ChatScreenCupertino extends StatefulWidget {
  const ChatScreenCupertino({super.key});

  @override
  State<ChatScreenCupertino> createState() => _ChatScreenCupertinoState();
}

class _ChatScreenCupertinoState extends State<ChatScreenCupertino> {
  /// Тип запоминается: сообщество удалили / покинули — страница остаётся до
  /// перехода в список, а не превращается в пустое окно чата.
  models.ChatType? _type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (previous, current) => previous.chat?.type != current.chat?.type || previous.status != current.status,
      builder: (context, state) {
        _type = state.chat?.type ?? _type;
        if (_type == null && state.status == Status.initialization) {
          return CupertinoPageScaffold(backgroundColor: ThemesCupertino.groupedBackground, child: const SizedBox.shrink());
        }
        return _type == models.ChatType.community ? const ChatInfoCupertino() : const ChatCupertino();
      },
    );
  }
}

/// Чаты сообщества на его странице: канал объявлений, группы и каналы по
/// темам. Где мы участник — превью последнего сообщения и непрочитанные, где
/// нет — число участников и «Вступить» (закрытая тема — заявка). Админу —
/// «Создать группу / канал» (чаты создаются только внутри сообщества).
class CommunityChatsCupertino extends StatelessWidget {
  final models.Chat community;
  final List<models.Chat> chats;

  const CommunityChatsCupertino({super.key, required this.community, required this.chats});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final action = ThemesCupertino.actionColor(context);
    return CupertinoListSection.insetGrouped(
      // Заголовок и подпись — как у секций форм («Новое», «Изменить»).
      header: createHeaderCupertino(t.screenChatInfo.communityChats),
      footer: createNoteCupertino(t.screenChatInfo.communityChatsFooter),
      backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
      decoration: BoxDecoration(
        color: ThemesCupertino.groupedCard.resolveFrom(context),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      children: [
        for (final chat in chats) _ChatRow(chat: chat),
        if (community.canManage) ...[
          CupertinoListTile(
            leadingSize: 40,
            leading: _CreateIcon(icon: HugeIcons.strokeRoundedUserGroup, color: action),
            title: Text(t.screenChatInfo.createGroup, style: TextStyle(color: action)),
            onTap: () => context.push('/chats/new/group/info?community=${community.id}'),
          ),
          CupertinoListTile(
            leadingSize: 40,
            leading: _CreateIcon(icon: HugeIcons.strokeRoundedMegaphone01, color: action),
            title: Text(t.screenChatInfo.createChannel, style: TextStyle(color: action)),
            onTap: () => context.push('/chats/new/channel?community=${community.id}'),
          ),
        ],
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
    final primary = CupertinoTheme.of(context).primaryColor;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final row = communityChatRow(t, chat);
    return CupertinoListTile(
      leadingSize: 40,
      leading: ChatAvatar(chat: chat, size: 40, accentColor: primary, accentForeground: ThemesCupertino.onAccent(context)),
      title: Row(
        children: [
          Flexible(child: Text(row.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
          if (chat.joinMode == models.ChatJoinMode.request) ...[
            const SizedBox(width: 4),
            Icon(CupertinoIcons.lock_fill, size: 13, color: secondary),
          ],
          if (chat.joinMode == models.ChatJoinMode.admins) ...[
            const SizedBox(width: 4),
            Icon(CupertinoIcons.eye_slash_fill, size: 13, color: secondary),
          ],
          if (chat.muted) ...[const SizedBox(width: 4), Icon(CupertinoIcons.bell_slash_fill, size: 13, color: secondary)],
        ],
      ),
      subtitle: Text(row.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: _trailing(context, t, primary, secondary),
      onTap: () => context.push('/chats/chat/${chat.id}'),
    );
  }

  Widget? _trailing(BuildContext context, Translations t, Color primary, Color secondary) {
    if (chat.isMember) {
      if (!chat.hasUnread) return const CupertinoListTileChevron();
      return Container(
        constraints: const BoxConstraints(minWidth: 22),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: chat.muted ? CupertinoColors.systemGrey.resolveFrom(context) : primary,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          chat.unreadCount > 0 ? ChatTileContent.badge(chat.unreadCount) : '',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: chat.muted ? CupertinoColors.white : ThemesCupertino.onAccent(context)),
        ),
      );
    }
    if (chat.joinRequested) return Text(t.screenChatInfo.requestPending, style: TextStyle(fontSize: 15, color: secondary));
    // В скрытую самому не вступить — добавляют админы (её видят только они).
    if (chat.joinMode == models.ChatJoinMode.admins) return const CupertinoListTileChevron();
    return CupertinoButton.tinted(
      sizeStyle: CupertinoButtonSize.small,
      onPressed: () => context.read<ChatCubit>().joinCommunityChat(chat),
      child: Text(t.screenChatInfo.join),
    );
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

/// Контакты заведения — строки в верхнем блоке страницы сообщества (под
/// описанием): телефон (тап — позвонить) и адрес в несколько строк (тап —
/// скопировать); есть координаты — справа у адреса иконки Яндекс Карт и 2ГИС
/// (маршрут).
List<Widget> communityContactTilesCupertino(BuildContext context, models.Chat chat) {
  final t = context.t.screenChatInfo;
  final action = ThemesCupertino.actionColor(context);
  final route = chat.latitude != null && chat.longitude != null;
  return [
    if (chat.phone.isNotEmpty)
      CupertinoListTileIcon(
        color: const Color(0xFF34C759),
        hugeIcon: HugeIcons.strokeRoundedCall02,
        title: Text(communityPhoneLabel(chat.phone), style: TextStyle(color: action)),
        subtitle: Text(t.phone),
        onTab: () => callCommunityPhone(chat.phone),
      ),
    if (chat.address.isNotEmpty || route)
      CupertinoListTileIcon(
        color: const Color(0xFFFF3B30),
        hugeIcon: HugeIcons.strokeRoundedLocation01,
        title: Text(chat.address.isNotEmpty ? chat.address : t.route, maxLines: 4),
        subtitle: Text(t.address),
        trailing: route ? CommunityRouteButtons(chat: chat) : null,
        onTab: () async {
          if (chat.address.isEmpty) return;
          await Clipboard.setData(ClipboardData(text: chat.address));
          await HapticFeedback.selectionClick();
        },
      ),
  ];
}
