import 'package:material_ui/material_ui.dart';

import '../../chats/users_search.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_create_common.dart';

/// Секция «Глобальный поиск» (люди — номер / @username, публичные группы —
/// [chats], см. [UsersSearch]) в стиле
/// списка чатов, как в Telegram: подпись-заголовок на фоне списка и строки
/// того же размера, что у чатов. Вкладка «Чаты» и «Новое сообщение»;
/// [UsersSearchStatus.idle] — секции нет.
List<Widget> usersSearchListMaterial(
  BuildContext context, {
  required UsersSearchStatus status,
  required List<models.ChatMember> results,
  required void Function(models.ChatMember member) onTap,
  List<models.Chat> chats = const [],
  void Function(models.Chat chat)? onChatTap,
}) {
  final t = context.t;
  if (status == UsersSearchStatus.idle) return const [];
  final scheme = Theme.of(context).colorScheme;
  final note = switch (status) {
    UsersSearchStatus.offline => t.screenNewChat.globalSearchOffline,
    UsersSearchStatus.flood => t.screenNewChat.globalSearchFlood,
    UsersSearchStatus.done when results.isEmpty && chats.isEmpty => t.screenNewChat.globalSearchEmpty,
    _ => null,
  };
  // Без своей заливки — фон тот же, что у строк результатов.
  Widget header(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Text(
      text,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: scheme.onSurfaceVariant),
    ),
  );
  // Нашлись только группы — сразу их заголовок, без пустого «Глобальный поиск».
  final onlyChats = status == UsersSearchStatus.done && results.isEmpty && chats.isNotEmpty;
  return [
    if (!onlyChats) header(t.screenNewChat.globalSearch),
    if (status == UsersSearchStatus.loading)
      const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2.5))),
      )
    else if (note != null)
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          note,
          textAlign: TextAlign.center,
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
      )
    else ...[
      for (final member in results) UserSearchTileMaterial(member: member, onTap: () => onTap(member)),
      if (chats.isNotEmpty) ...[
        header(t.screenNewChat.globalSearchGroups),
        for (final chat in chats) FoundChatTileMaterial(chat: chat, onTap: () => onChatTap?.call(chat)),
      ],
    ],
  ];
}

/// Найденная глобальным поиском публичная группа — строка в размерах
/// [ChatTileMaterial]: аватар группы, название, ниже «@имя · N участников».
class FoundChatTileMaterial extends StatelessWidget {
  final models.Chat chat;
  final VoidCallback onTap;

  const FoundChatTileMaterial({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final body = theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            ChatAvatar(chat: chat, accentColor: scheme.primary, accentForeground: scheme.onPrimary, size: 46),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    foundChatSubtitle(context.t, chat),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: body.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Найденный глобальным поиском — строка в размерах [ChatTileMaterial]:
/// аватар 46, имя, ниже @username / номер.
class UserSearchTileMaterial extends StatelessWidget {
  final models.ChatMember member;
  final VoidCallback onTap;

  const UserSearchTileMaterial({super.key, required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = globalSearchSubtitle(member);
    final body = theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            ContactAvatar(contact: member, size: 46),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: body.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
