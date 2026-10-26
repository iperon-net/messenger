import 'package:desktop_drop/desktop_drop.dart';
import 'package:material_ui/material_ui.dart';

import '../../i18n/translations.g.dart';
import '../../platform.dart';

/// Перетаскивание файлов в чат на десктопе (как в Telegram Desktop): пока файлы
/// над окном — подсказка поверх чата, отпустили — [onFiles] (превью с
/// подписью). [enabled] ложно (писать нельзя) или мобильные — только [child].
class ChatDropTarget extends StatefulWidget {
  const ChatDropTarget({super.key, required this.enabled, required this.onFiles, required this.child});

  final bool enabled;
  final void Function(List<String> paths) onFiles;
  final Widget child;

  @override
  State<ChatDropTarget> createState() => _ChatDropTargetState();
}

class _ChatDropTargetState extends State<ChatDropTarget> {
  bool _over = false;

  @override
  Widget build(BuildContext context) {
    if (!AppPlatform.isDesktop || !widget.enabled) return widget.child;
    final scheme = Theme.of(context).colorScheme;
    return DropTarget(
      onDragEntered: (_) => setState(() => _over = true),
      onDragExited: (_) => setState(() => _over = false),
      onDragDone: (details) {
        setState(() => _over = false);
        final paths = [for (final file in details.files) file.path];
        if (paths.isNotEmpty) widget.onFiles(paths);
      },
      child: Stack(
        children: [
          widget.child,
          if (_over)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.primary, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.file_upload_outlined, size: 48, color: scheme.primary),
                      const SizedBox(height: 12),
                      Text(context.t.screenChat.dropFiles, style: TextStyle(fontSize: 18, color: scheme.onSurface)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
