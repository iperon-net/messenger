import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
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
    return Scaffold(
      appBar: AppBar(
        // Непрочитанные в других чатах — счётчик у «назад» (как в окне чата).
        leading: unreadBackButtonMaterial(unreadBack),
        title: Text(context.t.screenChats.replies),
      ),
      body: SafeArea(
        top: false,
        child: RepliesFeed(
          style: ChatMaterial.bubbleStyle(context),
          secondary: scheme.onSurfaceVariant,
          progress: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5)),
        ),
      ),
    );
  }
}
