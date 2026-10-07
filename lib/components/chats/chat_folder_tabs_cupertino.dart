import 'package:cupertino_ui/cupertino_ui.dart';

import 'chat_folder_tabs.dart';

/// Табы-папки в стиле `CupertinoSlidingSegmentedControl` (как фильтр на
/// «Звонках»): серая дорожка, белый бегунок с тенью. С [contextActions] по
/// удержанию таба открывается нативное контекстное меню (`CupertinoContextMenu`):
/// таб «приподнимается» карточкой, фон размывается, под ним — действия.
class ChatFolderTabsCupertino extends StatelessWidget {
  final List<ChatFolderTab> tabs;

  /// `null` — без `PageView`: бегунок анимированно переезжает к [selectedIndex].
  final PageController? controller;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  /// Действия меню для таба (`CupertinoContextMenuAction`); пустой список —
  /// у таба нет меню.
  final List<Widget> Function(int index)? contextActions;

  const ChatFolderTabsCupertino({
    super.key,
    required this.tabs,
    this.controller,
    required this.selectedIndex,
    required this.onTap,
    this.contextActions,
  });

  static const _thumbColor = CupertinoDynamicColor.withBrightness(color: Color(0xFFFFFFFF), darkColor: Color(0xFF636366));

  @override
  Widget build(BuildContext context) {
    final label = CupertinoColors.label.resolveFrom(context);
    final thumb = _thumbColor.resolveFrom(context);
    return ChatFolderTabsCore(
      tabs: tabs,
      controller: controller,
      selectedIndex: selectedIndex,
      onTap: onTap,
      segmentWrapper: contextActions == null ? null : (index, tappable, content) => _menu(index, tappable, content, thumb),
      style: ChatFolderTabsStyle(
        height: 32,
        trackColor: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        trackRadius: 9,
        inset: 2,
        thumbColor: thumb,
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

  Widget _menu(int index, Widget tappable, Widget content, Color thumb) {
    final actions = contextActions!(index);
    if (actions.isEmpty) return tappable;
    return CupertinoContextMenu.builder(
      enableHapticFeedback: true,
      actions: actions,
      builder: (context, animation) {
        // До animationOpensAt — «нажатие» (таб как на дорожке), после —
        // открытое превью: таб карточкой цвета бегунка.
        if (animation.value < CupertinoContextMenu.animationOpensAt) return tappable;
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: DecoratedBox(
            decoration: BoxDecoration(color: thumb, borderRadius: BorderRadius.circular(10)),
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4), child: content),
          ),
        );
      },
    );
  }
}
