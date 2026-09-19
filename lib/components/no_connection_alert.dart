import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart' show showModalBottomSheet, FilledButton, Icons;

import '../i18n/translations.g.dart';

/// Общее уведомление «нет соединения с интернетом». Показывается перед сетевой
/// операцией, когда на устройстве нет сети (см. [Utils.hasNetwork]) — вместо
/// того чтобы ждать таймаут gRPC без обратной связи. Используется и для звонков
/// (через [CallGate]), и для добавления контактов.
///
/// Платформенное ветвление как во всём scaffolding (см. `main.dart`): iOS —
/// `CupertinoAlertDialog`, Android — нижняя плашка `showModalBottomSheet`.
Future<void> showNoConnectionAlert(BuildContext context) {
  final t = context.t.common;

  if (Platform.isIOS) {
    return showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.noConnectionTitle),
        content: Padding(padding: const EdgeInsets.only(top: 8), child: Text(t.noConnectionMessage)),
        actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(t.done))],
      ),
    );
  }

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.wifi_off, size: 40),
            const SizedBox(height: 16),
            Text(
              t.noConnectionTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(t.noConnectionMessage, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(t.done)),
          ],
        ),
      ),
    ),
  );
}
