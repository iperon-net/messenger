import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

import '../../i18n/translations.g.dart';
import '../chats/chat_avatar.dart';
import '../chats/chat_tile.dart';
import 'in_app_notice_host.dart';

/// Баннер о новом сообщении (Android): приподнятая карточка сверху — аватар,
/// название чата, текст в две строки.
class InAppNoticeMaterial extends StatelessWidget {
  final InAppNotice notice;

  const InAppNoticeMaterial({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final icon = notice.anonymous ? null : ChatTileContent.typeIcon(notice.chat);
    final secret = notice.chat.isSecret && !notice.anonymous;
    return Material(
      elevation: 6,
      color: scheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
        child: Row(
          children: [
            notice.anonymous
                ? SystemAccountAvatar(size: 40, background: scheme.primary, foreground: scheme.onPrimary)
                : ChatAvatar(chat: notice.chat, size: 40, accentColor: scheme.primary, accentForeground: scheme.onPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (icon != null) ...[
                        FaIcon(icon, size: 12, color: secret ? ChatTileContent.secretColor : scheme.onSurface),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          InAppNoticeContent.title(t, notice),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(color: secret ? ChatTileContent.secretColor : scheme.onSurface),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    InAppNoticeContent.text(t, notice),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
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
