import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';

class CupertinoListTileIcon extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? additionalInfo;
  final Widget? trailing;
  final Color color;
  // Ровно одна из иконок: [icon] — FontAwesome (основной случай), [hugeIcon] —
  // HugeIcons (штриховые), [iconAsset] — путь к SVG-ассету (бренд-иконки в своих
  // цветах). HugeIcons рисуются виджетом [HugeIcon], а не [FaIcon], поэтому их
  // нельзя было передать через [icon] (тип FaIconData). [iconAsset] рисуется во
  // всю ячейку без тонирования и цветного квадрата ([color] игнорируется).
  final FaIconData? icon;
  // Тип HugeIcons.* в hugeicons 1.x — сырые данные пути (не IconData).
  final List<List<dynamic>>? hugeIcon;
  final String? iconAsset;
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
    this.iconAsset,
    required this.onTab,
    super.key,
  }) : assert(
         (icon != null ? 1 : 0) + (hugeIcon != null ? 1 : 0) + (iconAsset != null ? 1 : 0) == 1,
         'Provide exactly one of icon, hugeIcon or iconAsset',
       );

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFFFFFFFF);
    return CupertinoListTile(
      padding: EdgeInsets.all(10),
      leading: iconAsset != null
          ? Container(
              width: 45,
              height: 45,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(8)),
              child: SvgPicture.asset(iconAsset!, fit: BoxFit.contain),
            )
          : Container(
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
