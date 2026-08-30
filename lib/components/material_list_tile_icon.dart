import 'package:material_ui/material_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Material-аналог [CupertinoListTileIcon]: плитка списка настроек с цветной
/// квадратной иконкой слева. `additionalInfo` показывается перед шевроном
/// (аналог `CupertinoListTile.additionalInfo`), шеврон рисуется при `isTrailing`.
class MaterialListTileIcon extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? additionalInfo;
  final Color color;
  final FaIconData icon;
  final bool isTrailing;
  final Future<void> Function()? onTab;

  const MaterialListTileIcon({
    required this.title,
    this.subtitle,
    this.additionalInfo,
    this.isTrailing = false,
    required this.color,
    required this.icon,
    required this.onTab,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final trailing = <Widget>[
      if (additionalInfo != null)
        DefaultTextStyle.merge(
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          child: additionalInfo!,
        ),
      if (isTrailing) Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
    ];

    return ListTile(
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Center(child: FaIcon(icon, size: 16, color: const Color(0xFFFFFFFF))),
      ),
      onTap: onTab == null ? null : () => onTab!(),
      title: title,
      subtitle: subtitle,
      trailing: trailing.isEmpty ? null : Row(mainAxisSize: MainAxisSize.min, spacing: 6, children: trailing),
    );
  }
}
