import 'dart:ui';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart' show Colors;

/// Нативный вид iOS-контекстного меню для служебной плашки: реплика плашки
/// на её месте, фон затемнён и размыт, рядом — «Удалить».
///
/// Своя реализация вместо `CupertinoContextMenu`: механика decoy на
/// устройстве сдвигала ряды ленты, а позиция реплики здесь берётся из
/// `GlobalKey` строки в момент нажатия — всегда актуальная
/// (docs/plans/02-delete-service-messages.md, шаг 7).
///
/// Возврат — `true`, выбрано «Удалить»; иначе `false` (мимо пунктов).
Future<bool> showPillContextMenu(BuildContext context, {required Widget pill, required Rect rect, required String deleteLabel}) async {
  final deleted = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: deleteLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (dialogContext, animation, secondary) => Stack(
      children: [
        // Фон: затемнение с размытием; прозрачен для касаний — мимо меню
        // закрывает баръер маршрута.
        Positioned.fill(
          child: IgnorePointer(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black26),
            ),
          ),
        ),
        // Реплика плашки на её месте (перекрывает оригинал точно).
        Positioned.fromRect(rect: rect, child: pill),
        // «Удалить» — под репликой, если помещается, иначе над ней.
        Positioned(
          left: rect.left,
          width: rect.width,
          top: _actionsBelow(context, rect) ? rect.bottom + 12 : null,
          bottom: _actionsBelow(context, rect) ? null : MediaQuery.sizeOf(context).height - rect.top + 12,
          child: Container(
            decoration: BoxDecoration(
              color: CupertinoColors.tertiarySystemBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 6))],
            ),
            child: ClipRSuperellipse(
              borderRadius: BorderRadius.circular(14),
              child: CupertinoContextMenuAction(
                trailingIcon: CupertinoIcons.delete,
                isDestructiveAction: true,
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(deleteLabel),
              ),
            ),
          ),
        ),
      ],
    ),
    transitionBuilder: (context, animation, secondary, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    ),
  );

  return deleted ?? false;
}

/// «Удалить» ставится под репликой, если для него есть место до низа экрана,
/// иначе над репликой.
bool _actionsBelow(BuildContext context, Rect rect) {
  return rect.bottom + 12 + 44 < MediaQuery.sizeOf(context).height - MediaQuery.paddingOf(context).bottom;
}
