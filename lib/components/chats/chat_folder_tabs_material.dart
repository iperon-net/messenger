import 'package:material_ui/material_ui.dart';

import 'chat_folder_tabs.dart';

/// Табы-папки в стиле M3 `SegmentedButton` (как фильтр на «Звонках»): контур-
/// «пилюля», выбранный сегмент залит `secondaryContainer`.
class ChatFolderTabsMaterial extends StatelessWidget {
  final List<ChatFolderTab> tabs;
  final PageController controller;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final ValueChanged<int>? onLongPress;

  const ChatFolderTabsMaterial({
    super.key,
    required this.tabs,
    required this.controller,
    required this.selectedIndex,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = Theme.of(context).textTheme.labelLarge ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    return ChatFolderTabsCore(
      tabs: tabs,
      controller: controller,
      selectedIndex: selectedIndex,
      onTap: onTap,
      onLongPress: onLongPress,
      style: ChatFolderTabsStyle(
        height: 40,
        trackColor: Colors.transparent,
        trackBorder: Border.all(color: scheme.outline),
        trackRadius: 20,
        inset: 0,
        thumbColor: scheme.secondaryContainer,
        thumbRadius: 20,
        textStyle: label.copyWith(color: scheme.onSurface),
        selectedTextStyle: label.copyWith(color: scheme.onSecondaryContainer, fontWeight: FontWeight.w600),
        badgeColor: scheme.primary,
        badgeMutedColor: scheme.outline,
        badgeTextColor: scheme.onPrimary,
      ),
    );
  }
}
