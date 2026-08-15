import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CupertinoListTileIcon extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? additionalInfo;
  final Color color;
  final FaIconData icon;
  final bool isTrailing;
  final Future<void> Function()? onTab;

  const CupertinoListTileIcon({
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
    return CupertinoListTile(
      padding: EdgeInsets.all(10),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: FaIcon(icon, size: 16, color: Color(0xFFFFFFFF))),
      ),
      onTap: onTab,
      title: title,
      subtitle: subtitle,
      trailing: isTrailing ? CupertinoListTileChevron() : null,
      additionalInfo: additionalInfo,
    );
  }
}
