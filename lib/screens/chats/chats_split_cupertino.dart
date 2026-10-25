import 'package:cupertino_ui/cupertino_ui.dart';

import '../../chats/secret/secret_chats_list.dart' show secretChatIDPrefix;
import '../../i18n/translations.g.dart';
import '../../split_layout.dart';
import '../../themes.dart';
import 'chats_cupertino.dart';

/// Вкладка «Чаты» на iPad (см. [SplitLayout]): на широком окне слева список,
/// справа [child] — навигатор панели (окно чата, его профиль, ветки); на узком
/// (Slide Over, Split View) — только [child], как на iPhone. [location] — путь
/// текущего маршрута: по нему подсвечивается открытый чат.
class ChatsSplitCupertino extends StatelessWidget {
  final String location;
  final Widget child;

  const ChatsSplitCupertino({super.key, required this.location, required this.child});

  /// id открытого чата по пути панели (`/chats/chat/<id>`, `/chats/secret/<hex>`).
  static String _openChatID(String location) {
    final segments = Uri.parse(location).pathSegments;
    if (segments.length < 3 || segments[0] != 'chats') return '';
    return switch (segments[1]) {
      'chat' => segments[2],
      'secret' => '$secretChatIDPrefix${segments[2]}',
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!SplitLayout.isWide(context)) return child;
    final width = SplitLayout.listWidth(MediaQuery.sizeOf(context).width);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: width,
          child: SplitSelection(chatID: _openChatID(location), child: const ChatsCupertino()),
        ),
        ColoredBox(color: CupertinoColors.separator.resolveFrom(context), child: const SizedBox(width: 0.5)),
        Expanded(child: child),
      ],
    );
  }
}

/// Корень правой панели, пока чат не выбран.
class ChatsSplitEmptyCupertino extends StatelessWidget {
  const ChatsSplitEmptyCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.appBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            context.t.screenChats.selectChat,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
        ),
      ),
    );
  }
}
