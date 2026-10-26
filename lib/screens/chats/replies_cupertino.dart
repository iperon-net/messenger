import 'package:cupertino_ui/cupertino_ui.dart';

import '../../split_layout.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart' show ChatWallpaperLayer;
import 'chat_cupertino.dart';
import 'replies_common.dart';

/// Экран «Ответы» (iOS, подэтап 4.6): ответы на мои комментарии и упоминания
/// меня в ветках комментариев каналов — только чтение, тап открывает ветку.
class RepliesCupertino extends StatefulWidget {
  const RepliesCupertino({super.key});

  @override
  State<RepliesCupertino> createState() => _RepliesCupertinoState();
}

class _RepliesCupertinoState extends State<RepliesCupertino> with UnreadBackCount {
  @override
  String get unreadChatID => models.repliesChatID;

  @override
  Widget build(BuildContext context) {
    final dark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final background = ThemesCupertino.appBackground.resolveFrom(context).withValues(alpha: 0.92);
    // Фон — обои чатов, как в окне чата и «Закреплённых».
    return CupertinoPageScaffold(
      backgroundColor: dark ? const Color(0xFF000000) : CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          automaticallyImplyLeading: !context.isSplitPaneRoot,
          // Непрочитанные в других чатах — «‹ 3» (как в окне чата).
          previousPageTitle: unreadBack > 0 ? ChatTileContent.badge(unreadBack) : '',
          automaticBackgroundVisibility: false,
          backgroundColor: background,
          middle: Text(context.t.screenChats.replies),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: ChatWallpaperLayer(dark: dark)),
          SafeArea(
            child: RepliesFeed(
              style: ChatCupertino.bubbleStyle(context),
              secondary: CupertinoColors.secondaryLabel.resolveFrom(context),
              progress: const CupertinoActivityIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
