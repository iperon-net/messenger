import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import 'chats_material.dart';
import 'chats_split_cupertino.dart';

/// Вкладка «Чаты» на Android-планшете — как [ChatsSplitCupertino].
class ChatsSplitMaterial extends StatelessWidget {
  final String location;
  final Widget child;

  const ChatsSplitMaterial({super.key, required this.location, required this.child});

  @override
  Widget build(BuildContext context) =>
      SplitViewMaterial(list: const ChatsMaterial(), selected: ChatsSplitCupertino.openChatID(location), child: child);
}
