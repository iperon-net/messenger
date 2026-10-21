import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../chats/chat_avatar.dart';
import '../chats/chat_tile.dart';
import 'in_app_notice_host.dart';

/// Баннер о новом сообщении (iOS): размытая плашка как у системных
/// уведомлений — аватар, название чата, текст в две строки.
class InAppNoticeCupertino extends StatelessWidget {
  final InAppNotice notice;

  const InAppNoticeCupertino({super.key, required this.notice});

  static const _background = CupertinoDynamicColor.withBrightness(color: Color(0xE6F7F7F7), darkColor: Color(0xE62C2C2E));

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accent = CupertinoTheme.of(context).primaryColor;
    final label = CupertinoColors.label.resolveFrom(context);
    final base = CupertinoTheme.of(context).textTheme.textStyle;
    final icon = notice.anonymous ? null : ChatTileContent.typeIcon(notice.chat);
    final secret = notice.chat.isSecret && !notice.anonymous;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 18, offset: Offset(0, 6))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: ColoredBox(
            color: _background.resolveFrom(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
              child: Row(
                children: [
                  notice.anonymous
                      ? SystemAccountAvatar(size: 40, background: accent, foreground: ThemesCupertino.onAccent(context))
                      : ChatAvatar(chat: notice.chat, size: 40, accentColor: accent, accentForeground: ThemesCupertino.onAccent(context)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (icon != null) ...[
                              FaIcon(icon, size: 12, color: secret ? ChatTileContent.secretColor : label),
                              const SizedBox(width: 5),
                            ],
                            Flexible(
                              child: Text(
                                InAppNoticeContent.title(t, notice),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: base.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: secret ? ChatTileContent.secretColor : label,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Text(
                          InAppNoticeContent.text(t, notice),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: base.copyWith(fontSize: 14, height: 1.25, color: label, decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
