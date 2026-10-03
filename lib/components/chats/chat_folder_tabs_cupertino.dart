import 'package:cupertino_ui/cupertino_ui.dart';

import 'chat_folder_tabs.dart';

/// Табы-папки в стиле `CupertinoSlidingSegmentedControl` (как фильтр на
/// «Звонках»): серая дорожка, белый бегунок с тенью.
class ChatFolderTabsCupertino extends StatelessWidget {
  final List<ChatFolderTab> tabs;
  final PageController controller;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final ValueChanged<int>? onLongPress;

  const ChatFolderTabsCupertino({
    super.key,
    required this.tabs,
    required this.controller,
    required this.selectedIndex,
    required this.onTap,
    this.onLongPress,
  });

  static const _thumbColor = CupertinoDynamicColor.withBrightness(color: Color(0xFFFFFFFF), darkColor: Color(0xFF636366));

  @override
  Widget build(BuildContext context) {
    final label = CupertinoColors.label.resolveFrom(context);
    return ChatFolderTabsCore(
      tabs: tabs,
      controller: controller,
      selectedIndex: selectedIndex,
      onTap: onTap,
      onLongPress: onLongPress,
      style: ChatFolderTabsStyle(
        height: 32,
        trackColor: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        trackRadius: 9,
        inset: 2,
        thumbColor: _thumbColor.resolveFrom(context),
        thumbRadius: 7,
        thumbShadow: const [
          BoxShadow(color: Color(0x1F000000), offset: Offset(0, 3), blurRadius: 8),
          BoxShadow(color: Color(0x0A000000), offset: Offset(0, 3), blurRadius: 1),
        ],
        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: label),
        selectedTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: label),
        badgeColor: CupertinoTheme.of(context).primaryColor,
        badgeMutedColor: CupertinoColors.systemGrey.resolveFrom(context),
        badgeTextColor: CupertinoColors.white,
      ),
    );
  }
}
