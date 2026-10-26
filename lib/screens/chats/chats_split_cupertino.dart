import 'package:cupertino_ui/cupertino_ui.dart';

import '../../chats/secret/secret_chats_list.dart' show secretChatIDPrefix;
import '../../components.dart';
import 'chats_cupertino.dart';

/// Вкладка «Чаты» на iPad: список слева, окно чата (его профиль, ветки) справа —
/// см. [SplitViewCupertino]. [location] — путь текущего маршрута: по нему
/// подсвечивается открытый чат.
class ChatsSplitCupertino extends StatelessWidget {
  final String location;
  final Widget child;

  const ChatsSplitCupertino({super.key, required this.location, required this.child});

  /// id открытого чата по пути панели (`/chats/chat/<id>`, `/chats/secret/<hex>`).
  static String openChatID(String location) {
    final segments = Uri.parse(location).pathSegments;
    if (segments.length < 3 || segments[0] != 'chats') return '';
    return switch (segments[1]) {
      'chat' => segments[2],
      'secret' => '$secretChatIDPrefix${segments[2]}',
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) => SplitViewCupertino(list: const ChatsCupertino(), selected: openChatID(location), child: child);
}
