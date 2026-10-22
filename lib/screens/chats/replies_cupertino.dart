import 'package:cupertino_ui/cupertino_ui.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
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
    final background = ThemesCupertino.groupedBackground;
    return CupertinoPageScaffold(
      backgroundColor: background,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          // Непрочитанные в других чатах — «‹ 3» (как в окне чата).
          previousPageTitle: unreadBack > 0 ? ChatTileContent.badge(unreadBack) : '',
          automaticBackgroundVisibility: false,
          backgroundColor: background,
          middle: Text(context.t.screenChats.replies),
        ),
      ),
      child: SafeArea(
        child: RepliesFeed(
          style: ChatCupertino.bubbleStyle(context),
          secondary: CupertinoColors.secondaryLabel.resolveFrom(context),
          progress: const CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
