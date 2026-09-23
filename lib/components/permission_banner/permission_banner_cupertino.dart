import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:hugeicons/hugeicons.dart';

/// Cupertino-реализация мягкого баннера-объяснения ([PermissionBanner]).
/// Выделенный блок с закруглением и цветной подложкой — лёгкий тон акцентного
/// `primaryColor` темы (подстраивается под тему автоматически).
class PermissionBannerCupertino extends StatelessWidget {
  /// Иконка HugeIcons (`HugeIcons.strokeRounded*`) — сырые данные пути.
  final List<List<dynamic>> icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final VoidCallback onDismiss;

  const PermissionBannerCupertino({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.onDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final accent = CupertinoTheme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      decoration: BoxDecoration(color: accent.withAlpha(28), borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(icon: icon, size: 28, strokeWidth: 2, color: accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(message, style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
                const SizedBox(height: 10),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: onAction,
                  child: Text(actionLabel, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(4),
            minimumSize: Size.zero,
            onPressed: onDismiss,
            child: Icon(CupertinoIcons.xmark, size: 18, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
        ],
      ),
    );
  }
}
