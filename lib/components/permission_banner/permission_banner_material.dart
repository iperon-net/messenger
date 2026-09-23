import 'package:material_ui/material_ui.dart';
import 'package:hugeicons/hugeicons.dart';

/// Material-реализация мягкого баннера-объяснения ([PermissionBanner]).
/// Выделенный блок `Card` в тонах `secondaryContainer` со скруглением.
class PermissionBannerMaterial extends StatelessWidget {
  /// Иконка HugeIcons (`HugeIcons.strokeRounded*`) — сырые данные пути.
  final List<List<dynamic>> icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final VoidCallback onDismiss;

  /// Подпись крестика для accessibility/тултипа. Необязательна.
  final String? dismissTooltip;

  const PermissionBannerMaterial({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.onDismiss,
    this.dismissTooltip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      color: scheme.secondaryContainer,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HugeIcon(icon: icon, size: 24, strokeWidth: 2, color: scheme.onSecondaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: scheme.onSecondaryContainer),
                      ),
                      const SizedBox(height: 4),
                      Text(message, style: TextStyle(fontSize: 13, color: scheme.onSecondaryContainer)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  color: scheme.onSecondaryContainer,
                  tooltip: dismissTooltip,
                  onPressed: onDismiss,
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: onAction, child: Text(actionLabel)),
            ),
          ],
        ),
      ),
    );
  }
}
