import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';

class CupertinoListTileIcon extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? additionalInfo;
  final Widget? trailing;
  final Color color;
  // Ровно одна из иконок: [icon] — FontAwesome (основной случай), [hugeIcon] —
  // HugeIcons (штриховые). HugeIcons рисуются виджетом [HugeIcon], а не [FaIcon],
  // поэтому их нельзя было передать через [icon] (тип FaIconData).
  final FaIconData? icon;
  // Тип HugeIcons.* в hugeicons 1.x — сырые данные пути (не IconData).
  final List<List<dynamic>>? hugeIcon;
  final bool isTrailing;
  final Future<void> Function()? onTab;

  const CupertinoListTileIcon({
    required this.title,
    this.subtitle,
    this.additionalInfo,
    this.trailing,
    this.isTrailing = false,
    required this.color,
    this.icon,
    this.hugeIcon,
    required this.onTab,
    super.key,
  }) : assert((icon == null) != (hugeIcon == null), 'Provide exactly one of icon or hugeIcon');

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFFFFFFFF);
    return CupertinoListTile(
      padding: EdgeInsets.all(10),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: hugeIcon != null
              ? HugeIcon(icon: hugeIcon!, size: 18, strokeWidth: 2, color: iconColor)
              : FaIcon(icon!, size: 16, color: iconColor),
        ),
      ),
      onTap: onTab,
      title: title,
      subtitle: subtitle,
      trailing: trailing ?? (isTrailing ? CupertinoListTileChevron() : null),
      additionalInfo: additionalInfo,
    );
  }
}
