import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';

/// Material-аналог [CupertinoListTileIcon]: плитка списка настроек с цветной
/// квадратной иконкой слева. `additionalInfo` показывается перед шевроном
/// (аналог `CupertinoListTile.additionalInfo`), шеврон рисуется при `isTrailing`.
class MaterialListTileIcon extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? additionalInfo;
  final Widget? trailing;
  final Color color;
  // Ровно одна из иконок: [icon] — FontAwesome (основной случай), [hugeIcon] —
  // HugeIcons (тип HugeIcons.* в hugeicons 1.x — сырые данные пути, не IconData),
  // [iconAsset] — путь к SVG-ассету (бренд-иконки в своих цветах, без цветного
  // квадрата и тонирования; [color] тогда игнорируется).
  final FaIconData? icon;
  final List<List<dynamic>>? hugeIcon;
  final String? iconAsset;
  final bool isTrailing;
  final Future<void> Function()? onTab;

  const MaterialListTileIcon({
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
    final trailing = <Widget>[
      if (additionalInfo != null)
        DefaultTextStyle.merge(
          style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(14), color: Theme.of(context).colorScheme.onSurfaceVariant),
          child: additionalInfo!,
        ),
      if (isTrailing) Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
    ];

    return ListTile(
      leading: iconAsset != null
          ? Container(
              width: 28,
              height: 28,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(8)),
              child: SvgPicture.asset(iconAsset!, fit: BoxFit.contain),
            )
          : Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: hugeIcon != null
                    ? HugeIcon(icon: hugeIcon!, size: 18, strokeWidth: 2, color: const Color(0xFFFFFFFF))
                    : FaIcon(icon!, size: 16, color: const Color(0xFFFFFFFF)),
              ),
            ),
      onTap: onTab == null ? null : () => onTab!(),
      title: title,
      subtitle: subtitle,
      trailing: this.trailing ?? (trailing.isEmpty ? null : Row(mainAxisSize: MainAxisSize.min, spacing: 6, children: trailing)),
    );
  }
}
