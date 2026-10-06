import 'package:flutter/widgets.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../chats/message_formatting.dart';
import '../../chats/reactions.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Общее для профиля чата (`chat_info_{cupertino,material}.dart`): вкладки
/// «Участники / Медиа / Файлы / Ссылки / Голосовые», присутствие собеседника,
/// роли. Пока UX-демо, см. docs/plans/chats-groups-channels.md, «Этап 0».

/// Что сделать в окне чата после профиля: поиск по чату или перейти к
/// сообщению [messageID].
class ChatInfoResult {
  final bool search;
  final String? messageID;

  const ChatInfoResult.search() : search = true, messageID = null;

  const ChatInfoResult.goTo(String this.messageID) : search = false;
}

enum ChatInfoTab { members, media, files, links, voice }

/// Вкладки профиля: у группы и сообщества первыми — участники.
List<ChatInfoTab> chatInfoTabs(models.Chat chat) => [
  if (chat.type == models.ChatType.group || chat.type == models.ChatType.community) ChatInfoTab.members,
  ChatInfoTab.media,
  ChatInfoTab.files,
  ChatInfoTab.links,
  ChatInfoTab.voice,
];

String chatInfoTabLabel(Translations t, ChatInfoTab tab) => switch (tab) {
  ChatInfoTab.members => t.screenChatInfo.tabMembers,
  ChatInfoTab.media => t.screenChatInfo.tabMedia,
  ChatInfoTab.files => t.screenChatInfo.tabFiles,
  ChatInfoTab.links => t.screenChatInfo.tabLinks,
  ChatInfoTab.voice => t.screenChatInfo.tabVoice,
};

/// «был(а) 5 мин. назад / в 14:20 / вчера в 14:20 / 03.10.26».
String lastSeenText(Translations t, DateTime date) {
  final now = DateTime.now();
  final local = date.toLocal();
  final diff = now.difference(local);
  final time = DateFormat.Hm().format(local);
  if (diff.inMinutes < 60) return t.screenChatInfo.lastSeenMinutes(n: diff.inMinutes.clamp(1, 59));
  final today = DateTime(now.year, now.month, now.day);
  if (!local.isBefore(today)) return t.screenChatInfo.lastSeenAt(time: time);
  if (!local.isBefore(today.subtract(const Duration(days: 1)))) return t.screenChatInfo.lastSeenYesterday(time: time);
  return t.screenChatInfo.lastSeenDate(date: DateFormat('dd.MM.yy').format(local));
}

/// Присутствие собеседника личного чата: «в сети» (активно) / «был(а) …».
({String text, bool active}) chatPresence(Translations t, models.Chat chat) {
  if (chat.online) return (text: t.screenChat.online, active: true);
  final seen = chat.lastSeen;
  return (text: seen == null ? t.screenChat.lastSeenRecently : lastSeenText(t, seen), active: false);
}

/// Подпись роли в списке участников; `null` — обычный участник с записью.
String? chatRoleLabel(Translations t, models.ChatRole role) => switch (role) {
  models.ChatRole.owner => t.screenChatInfo.roleOwner,
  models.ChatRole.admin => t.screenChatInfo.roleAdmin,
  models.ChatRole.reader => t.screenChatInfo.roleReader,
  models.ChatRole.writer => null,
};

/// Ссылки чата — из превью или первой ссылки текста, от новых к старым.
List<({models.Message message, String url, models.MessageLinkPreview? preview})> chatLinks(List<models.Message> messages) => [
  for (final m in messages.reversed)
    if (!m.service)
      if ((m.linkPreview?.url ?? firstLinkUrl(m.text, m.entities)) case final url?) (message: m, url: url, preview: m.linkPreview),
];

/// Цвета вкладок — свои у Cupertino и Material.
class ChatInfoStyle {
  final Color text;
  final Color secondary;
  final Color accent;
  final Color separator;

  const ChatInfoStyle({required this.text, required this.secondary, required this.accent, required this.separator});
}

/// Содержимое вкладки профиля. [onOpenMessage] — вернуться в чат к
/// сообщению (файл, голосовое).
class ChatInfoTabContent extends StatelessWidget {
  final ChatInfoTab tab;
  final models.Chat chat;
  final List<models.Message> messages;
  final List<models.ChatMember> members;
  final ChatInfoStyle style;
  final ValueChanged<String> onOpenMessage;

  const ChatInfoTabContent({
    super.key,
    required this.tab,
    required this.chat,
    required this.messages,
    required this.members,
    required this.style,
    required this.onOpenMessage,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return switch (tab) {
      ChatInfoTab.members => Column(
        children: [for (final m in members) _MemberRow(member: m, style: style)],
      ),
      ChatInfoTab.media => _media(context),
      ChatInfoTab.files => _list(t.screenChatInfo.emptyFiles, [
        for (final m in messages.reversed)
          if (m.kind == models.MessageKind.file) _FileRow(message: m, style: style, onTap: () => onOpenMessage(m.id)),
      ]),
      ChatInfoTab.links => _list(t.screenChatInfo.emptyLinks, [
        for (final link in chatLinks(messages)) _LinkRow(url: link.url, preview: link.preview, date: link.message.date, style: style),
      ]),
      ChatInfoTab.voice => _list(t.screenChatInfo.emptyVoice, [
        for (final m in messages.reversed)
          if (m.kind == models.MessageKind.voice) _VoiceRow(message: m, chat: chat, style: style, onTap: () => onOpenMessage(m.id)),
      ]),
    };
  }

  Widget _empty(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15, color: style.secondary),
    ),
  );

  Widget _list(String empty, List<Widget> rows) => rows.isEmpty ? _empty(empty) : Column(children: rows);

  /// Фото и видео сеткой по 3, от новых к старым; тап — просмотр.
  Widget _media(BuildContext context) {
    final items = ChatMediaItem.of(messages).reversed.toList();
    if (items.isEmpty) return _empty(context.t.screenChatInfo.emptyMedia);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        final Widget image = item.isVideo && item.thumbPath.isNotEmpty
            ? ChatMediaImage(path: item.thumbPath, thumbhash: item.thumbhash, cacheWidth: 360)
            : !item.isVideo && item.localPath.isNotEmpty
            ? ChatMediaImage(path: item.localPath, thumbhash: item.thumbhash, cacheWidth: 360)
            : chatMediaPlaceholder('${item.message.id}-${item.index}', video: item.isVideo, iconSize: 26);
        return GestureDetector(
          onTap: () => showChatMediaViewer(context, messages: messages, message: item.message, index: item.index, chatTitle: chat.title),
          child: Stack(
            fit: StackFit.expand,
            children: [
              image,
              if (item.isVideo && item.thumbPath.isNotEmpty) const Center(child: ChatVideoPlayBadge(size: 30)),
            ],
          ),
        );
      },
    );
  }
}

class _MemberRow extends StatelessWidget {
  final models.ChatMember member;
  final ChatInfoStyle style;

  const _MemberRow({required this.member, required this.style});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final role = chatRoleLabel(t, member.role);
    final seen = member.lastSeen;
    final status = member.online || member.isSelf
        ? t.screenChat.online
        : (seen == null ? t.screenChat.lastSeenRecently : lastSeenText(t, seen));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: BoringAvatar(name: member.name, type: BoringAvatarType.beam, shape: const CircleBorder()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.isSelf ? t.screenChatInfo.you : member.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, color: style.text),
                ),
                Text(
                  status,
                  maxLines: 1,
                  style: TextStyle(fontSize: 13, color: member.online || member.isSelf ? style.accent : style.secondary),
                ),
              ],
            ),
          ),
          if (role != null) Text(role, style: TextStyle(fontSize: 13, color: style.secondary)),
        ],
      ),
    );
  }
}

/// Строка с кружком-значком слева (файл, голосовое, ссылка).
class _IconRow extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final ChatInfoStyle style;
  final VoidCallback? onTap;

  const _IconRow({required this.icon, required this.title, required this.subtitle, required this.style, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: style.accent, borderRadius: BorderRadius.circular(8)),
              child: icon,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: style.text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: style.secondary),
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

String _date(DateTime date) => DateFormat('dd.MM.yy').format(date.toLocal());

class _FileRow extends StatelessWidget {
  final models.Message message;
  final ChatInfoStyle style;
  final VoidCallback onTap;

  const _FileRow({required this.message, required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = message.fileSize > 0 ? '${formatBytes(context, message.fileSize)} · ' : '';
    return _IconRow(
      icon: const FaIcon(FontAwesomeIcons.solidFile, size: 20, color: Color(0xFFFFFFFF)),
      title: message.fileName.isNotEmpty ? message.fileName : message.text,
      subtitle: '$size${_date(message.date)}',
      style: style,
      onTap: onTap,
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String url;
  final models.MessageLinkPreview? preview;
  final DateTime date;
  final ChatInfoStyle style;

  const _LinkRow({required this.url, required this.preview, required this.date, required this.style});

  @override
  Widget build(BuildContext context) {
    final host = Uri.tryParse(url)?.host ?? url;
    final title = preview?.title.isNotEmpty ?? false ? preview!.title : host;
    return _IconRow(
      icon: Text(
        host.replaceFirst('www.', '').characters.firstOrNull?.toUpperCase() ?? '#',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFFFFFFF)),
      ),
      title: title,
      subtitle: url,
      style: style,
      onTap: () {
        final uri = Uri.tryParse(url);
        if (uri != null) launchUrl(uri, mode: LaunchMode.externalApplication);
      },
    );
  }
}

class _VoiceRow extends StatelessWidget {
  final models.Message message;
  final models.Chat chat;
  final ChatInfoStyle style;
  final VoidCallback onTap;

  const _VoiceRow({required this.message, required this.chat, required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final seconds = message.duration;
    final author = message.outgoing ? t.screenChatInfo.you : (message.senderName.isNotEmpty ? message.senderName : chat.title);
    return _IconRow(
      icon: const FaIcon(FontAwesomeIcons.microphone, size: 18, color: Color(0xFFFFFFFF)),
      title: author,
      subtitle: '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')} · ${_date(message.date)}',
      style: style,
      onTap: onTap,
    );
  }
}

/// Сводка реакций для строки «Реакции»: «Все» / «Выкл.» / число выбранных.
String reactionsSummary(Translations t, models.Chat chat) => switch (chat.reactionsMode) {
  models.ChatReactionsMode.all => t.screenChatInfo.reactionsAllShort,
  models.ChatReactionsMode.none => t.screenChatInfo.reactionsNoneShort,
  models.ChatReactionsMode.some => chat.reactions.isEmpty ? t.screenChatInfo.reactionsNoneShort : '${chat.reactions.length}',
};

/// Сетка всех реакций с отметкой выбранных (настройка «Некоторые»):
/// выбранные — в кружке, остальные — бледнее.
class ReactionsGrid extends StatelessWidget {
  final List<String> selected;
  final Color highlight;
  final ValueChanged<String> onToggle;

  const ReactionsGrid({super.key, required this.selected, required this.highlight, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final emoji in allChatReactions)
          GestureDetector(
            onTap: () => onToggle(emoji),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected.contains(emoji) ? highlight.withValues(alpha: 0.18) : null,
                border: Border.all(color: selected.contains(emoji) ? highlight : const Color(0x00000000), width: 1.5),
              ),
              child: Opacity(
                opacity: selected.contains(emoji) ? 1 : 0.35,
                child: Text(emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
          ),
      ],
    );
  }
}
