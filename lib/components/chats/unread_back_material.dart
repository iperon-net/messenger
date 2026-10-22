import 'package:material_ui/material_ui.dart';

import 'chat_tile.dart';

/// «Назад» в окне чата со счётчиком непрочитанных других чатов (см.
/// `UnreadBackCount`); null — счётчика нет, AppBar ставит обычную стрелку.
Widget? unreadBackButtonMaterial(int count) =>
    count <= 0 ? null : Badge(label: Text(ChatTileContent.badge(count)), offset: const Offset(-2, 4), child: const BackButton());
