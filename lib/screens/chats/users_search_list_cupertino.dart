import 'package:cupertino_ui/cupertino_ui.dart';

import '../../chats/users_search.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_create_common.dart';

/// Секция «Глобальный поиск» (люди — номер / @username, публичные группы —
/// [chats], см. [UsersSearch]) в стиле
/// списка чатов, как в Telegram: серая плашка-заголовок и строки того же
/// размера, что у чатов. Вкладка «Чаты» и «Новое сообщение»;
/// [UsersSearchStatus.idle] — секции нет.
List<Widget> usersSearchListCupertino(
  BuildContext context, {
  required UsersSearchStatus status,
  required List<models.ChatMember> results,
  required void Function(models.ChatMember member) onTap,
  List<models.Chat> chats = const [],
  void Function(models.Chat chat)? onChatTap,
}) {
  final t = context.t;
  if (status == UsersSearchStatus.idle) return const [];
  final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
  final note = switch (status) {
    UsersSearchStatus.offline => t.screenNewChat.globalSearchOffline,
    UsersSearchStatus.flood => t.screenNewChat.globalSearchFlood,
    UsersSearchStatus.done when results.isEmpty && chats.isEmpty => t.screenNewChat.globalSearchEmpty,
    _ => null,
  };
  Widget header(String text) => Container(
    color: ThemesCupertino.groupedBackground.resolveFrom(context),
    padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
    child: Text(text, style: TextStyle(fontSize: 14, color: secondary)),
  );
  // Нашлись только группы — сразу их заголовок, без пустого «Глобальный поиск».
  final onlyChats = status == UsersSearchStatus.done && results.isEmpty && chats.isNotEmpty;
  final divider = Container(
    margin: const EdgeInsetsDirectional.only(start: ChatTileCupertino.dividerIndent),
    height: 0.5,
    color: CupertinoColors.separator.resolveFrom(context),
  );
  return [
    if (!onlyChats) header(t.screenNewChat.globalSearch),
    if (status == UsersSearchStatus.loading)
      const Padding(padding: EdgeInsets.all(16), child: CupertinoActivityIndicator())
    else if (note != null)
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Text(
          note,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: secondary),
        ),
      )
    else ...[
      for (final (i, member) in results.indexed) ...[
        if (i > 0) divider,
        UserSearchTileCupertino(member: member, onTap: () => onTap(member)),
      ],
      if (chats.isNotEmpty) ...[
        header(t.screenNewChat.globalSearchGroups),
        for (final (i, chat) in chats.indexed) ...[
          if (i > 0) divider,
          FoundChatTileCupertino(chat: chat, onTap: () => onChatTap?.call(chat)),
        ],
      ],
    ],
  ];
}

/// Найденная глобальным поиском публичная группа — строка в размерах
/// [ChatTileCupertino]: аватар группы, название, ниже «@имя · N участников».
class FoundChatTileCupertino extends StatefulWidget {
  final models.Chat chat;
  final VoidCallback onTap;

  const FoundChatTileCupertino({super.key, required this.chat, required this.onTap});

  @override
  State<FoundChatTileCupertino> createState() => _FoundChatTileCupertinoState();
}

class _FoundChatTileCupertinoState extends State<FoundChatTileCupertino> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: ColoredBox(
        color: _pressed ? CupertinoColors.systemGrey5.resolveFrom(context) : const Color(0x00000000),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
          child: Row(
            children: [
              ChatAvatar(
                chat: chat,
                accentColor: CupertinoTheme.of(context).primaryColor,
                accentForeground: ThemesCupertino.onAccent(context),
                size: 49,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CupertinoColors.label.resolveFrom(context)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      foundChatSubtitle(context.t, chat),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Найденный глобальным поиском — строка в размерах [ChatTileCupertino]:
/// аватар 49, имя, ниже @username / номер.
class UserSearchTileCupertino extends StatefulWidget {
  final models.ChatMember member;
  final VoidCallback onTap;

  const UserSearchTileCupertino({super.key, required this.member, required this.onTap});

  @override
  State<UserSearchTileCupertino> createState() => UserSearchTileCupertinoState();
}

class UserSearchTileCupertinoState extends State<UserSearchTileCupertino> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.member;
    final subtitle = globalSearchSubtitle(member);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: ColoredBox(
        color: _pressed ? CupertinoColors.systemGrey5.resolveFrom(context) : const Color(0x00000000),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
          child: Row(
            children: [
              ContactAvatar(contact: member, size: 49),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CupertinoColors.label.resolveFrom(context)),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
