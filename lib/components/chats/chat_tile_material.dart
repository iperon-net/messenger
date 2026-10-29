import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

import '../../split_layout.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_avatar.dart';
import 'chat_tile.dart';
import 'message_bubble.dart' show failedStatusColor;
import '../../themes.dart';

/// Строка списка чатов (Android, по мотивам Telegram): аватар, название с иконкой
/// типа, дата с галочками; ниже — превью в одну строку и бейджи (упоминания,
/// непрочитанные) или скрепка закреплённого.
class ChatTileMaterial extends StatelessWidget {
  final models.Chat chat;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ChatTileMaterial({super.key, required this.chat, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final secondary = scheme.onSurfaceVariant;
    final typeIcon = ChatTileContent.typeIcon(chat);
    final statusIcon = ChatTileContent.statusIcon(chat);
    final preview = ChatTileContent.preview(t, chat);
    final date = chat.lastMessage?.date;
    final body = theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14);

    // Планшет: открытый в правой панели чат подсвечен, как в Telegram.
    final selected = SplitSelection.of(context) == chat.id;
    return Material(
      color: selected ? scheme.secondaryContainer : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        // Правый клик мышью (десктоп) — те же действия.
        onSecondaryTap: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              ChatAvatar(
                chat: chat,
                accentColor: scheme.primary,
                accentForeground: scheme.onPrimary,
                size: 46,
                onlineRingColor: theme.brightness == Brightness.dark
                    ? ThemesCupertino.groupedCard.darkColor
                    : ThemesCupertino.groupedCard.color,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  // min: в превью контекстного меню высота ограничена — без этого строка
                  // растягивается на весь экран.
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Название + иконки — во всю свободную ширину, дата прижата к правому
                        // краю (Flexible + Spacer делят место поровну, и недобранная заголовком
                        // доля оставалась пустой справа от даты).
                        Expanded(
                          child: Row(
                            children: [
                              if (typeIcon != null) ...[
                                FaIcon(typeIcon, size: 12, color: chat.isSecret ? ChatTileContent.secretColor : scheme.onSurface),
                                const SizedBox(width: 6),
                              ],
                              Flexible(
                                child: Text(
                                  ChatTileContent.title(t, chat),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: chat.isSecret ? ChatTileContent.secretColor : null,
                                  ),
                                ),
                              ),
                              if (chat.verified) VerifiedBadge(color: scheme.primary),
                              if (chat.muted) ...[const SizedBox(width: 4), FaIcon(FontAwesomeIcons.bellSlash, size: 11, color: secondary)],
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (statusIcon != null) ...[
                          FaIcon(
                            statusIcon,
                            size: 12,
                            color: statusIcon == FontAwesomeIcons.circleExclamation ? failedStatusColor : scheme.primary,
                          ),
                          const SizedBox(width: 4),
                        ],
                        if (date != null) Text(date.chatListFormat(), style: theme.textTheme.bodySmall?.copyWith(color: secondary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: preview.kind == ChatPreviewKind.typing
                              ? TypingText(preview.text, style: body.copyWith(color: scheme.primary))
                              : Text.rich(_span(preview, body, scheme), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 6),
                        _badges(scheme),
                      ],
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

  TextSpan _span(ChatPreview preview, TextStyle style, ColorScheme scheme) {
    final secondary = style.copyWith(color: scheme.onSurfaceVariant);
    return switch (preview.kind) {
      ChatPreviewKind.typing => TextSpan(
        text: preview.text,
        style: style.copyWith(color: scheme.primary),
      ),
      ChatPreviewKind.draft => TextSpan(
        children: [
          TextSpan(
            text: '${preview.prefix} ',
            style: style.copyWith(color: scheme.error),
          ),
          TextSpan(text: preview.text, style: secondary),
        ],
      ),
      // Автор в группе — в той же строке, как в Telegram для Android.
      ChatPreviewKind.message when preview.prefix.isNotEmpty => TextSpan(
        children: [
          TextSpan(
            text: '${preview.prefix}: ',
            style: style.copyWith(color: scheme.primary),
          ),
          TextSpan(text: preview.text, style: secondary),
        ],
      ),
      ChatPreviewKind.message => TextSpan(text: preview.text, style: secondary),
    };
  }

  Widget _badges(ColorScheme scheme) {
    final unreadColor = chat.muted ? scheme.outline : scheme.primary;
    final text = TextStyle(fontSize: 13, color: scheme.onPrimary, fontWeight: FontWeight.w600);
    final children = <Widget>[
      // Непрочитанные реакции на мои сообщения — красный ❤️ (как в Telegram).
      if (chat.unreadReactions > 0)
        _pill(
          child: FaIcon(FontAwesomeIcons.solidHeart, size: 11, color: scheme.onError),
          color: scheme.error,
        ),
      if (chat.unreadMentions > 0)
        _pill(
          child: Text('@', style: text),
          color: scheme.primary,
        ),
      if (chat.unreadCount > 0)
        _pill(
          child: Text(ChatTileContent.badge(chat.unreadCount), style: text),
          color: unreadColor,
        )
      else if (chat.markedUnread)
        _pill(color: unreadColor),
      if (!chat.hasUnread && chat.pinned) FaIcon(FontAwesomeIcons.thumbtack, size: 13, color: scheme.outline),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [for (final c in children) Padding(padding: const EdgeInsets.only(left: 4), child: c)],
    );
  }

  Widget _pill({Widget? child, required Color color}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(11)),
      child: child,
    );
  }
}
