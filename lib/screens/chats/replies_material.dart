import 'package:material_ui/material_ui.dart';

import '../../split_layout.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart' show ChatWallpaperLayer;
import 'chat_material.dart';
import 'replies_common.dart';

/// Экран «Ответы» (Android, подэтап 4.6): ответы на мои комментарии и
/// упоминания меня в ветках комментариев каналов — только чтение, тап
/// открывает ветку.
class RepliesMaterial extends StatefulWidget {
  const RepliesMaterial({super.key});

  @override
  State<RepliesMaterial> createState() => _RepliesMaterialState();
}

class _RepliesMaterialState extends State<RepliesMaterial> with UnreadBackCount {
  @override
  String get unreadChatID => models.repliesChatID;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Фон — обои чатов, как в окне чата и «Закреплённых».
    return Scaffold(
      backgroundColor: dark ? const Color(0xFF000000) : scheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: dark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color,
        // Непрочитанные в других чатах — счётчик у «назад» (как в окне чата).
        // Планшет: корень правой панели — без «назад», список слева.
        automaticallyImplyLeading: !context.isSplitPaneRoot,
        leading: context.isSplitPaneRoot ? null : unreadBackButtonMaterial(unreadBack),
        title: Text(context.t.screenChats.replies),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: ChatWallpaperLayer(dark: dark)),
          SafeArea(
            top: false,
            child: RepliesFeed(
              style: ChatMaterial.bubbleStyle(context),
              secondary: scheme.onSurfaceVariant,
              progress: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5)),
            ),
          ),
        ],
      ),
    );
  }
}
