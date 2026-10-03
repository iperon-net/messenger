import 'package:material_ui/material_ui.dart';

import 'chat_folder_tabs.dart';

/// Табы-папки (Android): тональная дорожка без контура с небольшим скруглением,
/// выбранный сегмент залит `secondaryContainer`.
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
        // Без контура: дорожка — тональная заливка, скругление умеренное.
        trackColor: scheme.surfaceContainerHighest,
        trackRadius: 12,
        inset: 3,
        thumbColor: scheme.secondaryContainer,
        thumbRadius: 9,
        textStyle: label.copyWith(color: scheme.onSurface),
        selectedTextStyle: label.copyWith(color: scheme.onSecondaryContainer, fontWeight: FontWeight.w600),
        badgeColor: scheme.primary,
        badgeMutedColor: scheme.outline,
        badgeTextColor: scheme.onPrimary,
      ),
    );
  }
}
