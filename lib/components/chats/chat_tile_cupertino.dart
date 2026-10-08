import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_avatar.dart';
import 'chat_tile.dart';
import '../../themes.dart';

/// Строка списка чатов (iOS, по мотивам Telegram): аватар, название с иконкой
/// типа и «колокольчиком», дата с галочками; ниже — превью в две строки и
/// бейджи (упоминания, непрочитанные) или скрепка закреплённого.
class ChatTileCupertino extends StatefulWidget {
  final models.Chat chat;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ChatTileCupertino({super.key, required this.chat, this.onTap, this.onLongPress});

  /// Отступ разделителя слева — под текстом, не под аватаром.
  static const dividerIndent = 78.0;

  @override
  State<ChatTileCupertino> createState() => _ChatTileCupertinoState();
}

class _ChatTileCupertinoState extends State<ChatTileCupertino> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    final t = context.t;
    final primary = CupertinoTheme.of(context).primaryColor;
    final label = CupertinoColors.label.resolveFrom(context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final typeIcon = ChatTileContent.typeIcon(chat);
    final statusIcon = ChatTileContent.statusIcon(chat);
    final preview = ChatTileContent.preview(t, chat);
    final date = chat.lastMessage?.date;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      // Без колбэка — без LongPress-распознавателя: иначе он выигрывает арену
      // у CupertinoContextMenu (ChatContextMenuCupertino) и меню не открывается.
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              _setPressed(false);
              widget.onLongPress!.call();
            },
      child: ColoredBox(
        color: _pressed ? CupertinoColors.systemGrey5.resolveFrom(context) : const Color(0x00000000),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatAvatar(chat: chat, accentColor: primary, accentForeground: ThemesCupertino.onAccent(context), size: 58),
              const SizedBox(width: 10),
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
                              if (typeIcon != null) ...[FaIcon(typeIcon, size: 12, color: label), const SizedBox(width: 5)],
                              Flexible(
                                child: Text(
                                  ChatTileContent.title(t, chat),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: label),
                                ),
                              ),
                              if (chat.muted) ...[const SizedBox(width: 4), FaIcon(FontAwesomeIcons.bellSlash, size: 11, color: secondary)],
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (statusIcon != null) ...[FaIcon(statusIcon, size: 12, color: primary), const SizedBox(width: 4)],
                        if (date != null) Text(date.chatListFormat(), style: TextStyle(fontSize: 14, color: secondary)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _preview(context, preview, label, secondary, primary)),
                        const SizedBox(width: 6),
                        Padding(padding: const EdgeInsets.only(top: 4), child: _badges(context, chat, primary, secondary)),
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

  Widget _preview(BuildContext context, ChatPreview preview, Color label, Color secondary, Color primary) {
    const style = TextStyle(fontSize: 15, height: 1.25);
    final TextSpan span = switch (preview.kind) {
      ChatPreviewKind.typing => TextSpan(
        text: preview.text,
        style: style.copyWith(color: primary),
      ),
      ChatPreviewKind.draft => TextSpan(
        children: [
          TextSpan(
            text: '${preview.prefix} ',
            style: style.copyWith(color: CupertinoColors.systemRed.resolveFrom(context)),
          ),
          TextSpan(
            text: preview.text,
            style: style.copyWith(color: secondary),
          ),
        ],
      ),
      // Автор в группе — своей строкой, как в Telegram для iOS.
      ChatPreviewKind.message when preview.prefix.isNotEmpty => TextSpan(
        children: [
          TextSpan(
            text: '${preview.prefix}\n',
            style: style.copyWith(color: label),
          ),
          TextSpan(
            text: preview.text,
            style: style.copyWith(color: secondary),
          ),
        ],
      ),
      ChatPreviewKind.message => TextSpan(
        text: preview.text,
        style: style.copyWith(color: secondary),
      ),
    };
    return SizedBox(
      // Высота ровно под две строки — строки списка одной высоты.
      height: 2 * 15 * 1.25 * MediaQuery.textScalerOf(context).scale(1),
      child: Text.rich(span, maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _badges(BuildContext context, models.Chat chat, Color primary, Color secondary) {
    final grey = CupertinoColors.systemGrey.resolveFrom(context);
    final unreadColor = chat.muted ? grey : primary;
    // На акценте — onAccent (в тёмной теме акцент светлый), на сером — белый.
    final onAccent = _badgeText.copyWith(color: ThemesCupertino.onAccent(context));
    final children = <Widget>[
      if (chat.unreadMentions > 0)
        _pill(
          child: Text('@', style: onAccent),
          color: primary,
        ),
      if (chat.unreadCount > 0)
        _pill(
          child: Text(ChatTileContent.badge(chat.unreadCount), style: chat.muted ? _badgeText : onAccent),
          color: unreadColor,
        )
      else if (chat.markedUnread)
        _pill(color: unreadColor),
      if (!chat.hasUnread && chat.pinned) FaIcon(FontAwesomeIcons.thumbtack, size: 13, color: grey),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [for (final c in children) Padding(padding: const EdgeInsets.only(left: 4), child: c)],
    );
  }

  static const _badgeText = TextStyle(fontSize: 14, color: CupertinoColors.white, fontWeight: FontWeight.w500);

  Widget _pill({Widget? child, required Color color}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }
}
