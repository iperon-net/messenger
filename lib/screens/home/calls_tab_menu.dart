import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:material_ui/material_ui.dart';

import '../../auth.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../repositories/repositories.dart';

/// Долгий тап по вкладке «Звонки» — меню вкладки: «Очистить историю звонков»
/// (с подтверждением). Слой поверх кнопки вкладки в HomeCupertino /
/// HomeMaterial, обычный тап проходит к панели (как у выбора аккаунта на
/// «Настройках»). Журнал скрывается в БД — CallsCubit перечитает его сам
/// (`db.onChange`).
class CallsTabMenu extends StatelessWidget {
  const CallsTabMenu({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return GestureDetector(behavior: HitTestBehavior.translucent, onLongPress: () => _sheetMaterial(context));
    }
    return c.CupertinoMenuAnchor(
      consumeOutsideTaps: true,
      useRootOverlay: true,
      menuChildren: [
        c.CupertinoMenuItem(
          isDestructiveAction: true,
          trailing: const Icon(c.CupertinoIcons.delete),
          onPressed: () => _confirmCupertino(context),
          child: Text(context.t.screenCalls.clearHistory),
        ),
      ],
      builder: (context, controller, _) =>
          GestureDetector(behavior: HitTestBehavior.translucent, onLongPress: controller.open, child: const SizedBox.expand()),
    );
  }

  static Future<void> _clear() => getIt.get<Repositories>().callLogs.deleteAll(ownerID: getIt.get<Auth>().session.userID);

  Future<void> _confirmCupertino(BuildContext context) async {
    final t = context.t.screenCalls;
    final confirmed = await c.showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => c.CupertinoAlertDialog(
        title: Text(t.clearTitle),
        content: Text(t.clearMessage),
        actions: [
          c.CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          c.CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.clear)),
        ],
      ),
    );
    if (confirmed ?? false) await _clear();
  }

  Future<void> _sheetMaterial(BuildContext context) async {
    final t = context.t.screenCalls;
    final clear = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListTile(
          leading: const Icon(Icons.delete_sweep_outlined),
          title: Text(t.clearHistory),
          onTap: () => Navigator.of(sheetContext).pop(true),
        ),
      ),
    );
    if (!(clear ?? false) || !context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.clearTitle),
        content: Text(t.clearMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.clear)),
        ],
      ),
    );
    if (confirmed ?? false) await _clear();
  }
}
