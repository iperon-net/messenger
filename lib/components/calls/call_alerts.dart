import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart' show showModalBottomSheet, FilledButton, Icons;

import '../../i18n/translations.g.dart';

/// Уведомление, объясняющее, что исходящий звонок отклонён серверным гейтом
/// приватности (абонент принимает звонки только от контактов, а нас у него в
/// книге нет). Вызывается из [CallGate] по терминальному снимку звонка с
/// [CallEndReason.notAllowed]. Случай «нет сети» — общий [showNoConnectionAlert].
///
/// Платформенное ветвление как во всём scaffolding (см. `main.dart`): iOS —
/// `CupertinoAlertDialog`, Android — нижняя плашка `showModalBottomSheet`.
Future<void> showCallNotAllowed(BuildContext context) {
  final t = context.t.screenCall;
  return _showCallAlert(context, title: t.notAllowedTitle, message: t.notAllowedMessage, androidIcon: Icons.lock_outline);
}

Future<void> _showCallAlert(BuildContext context, {required String title, required String message, required IconData androidIcon}) {
  if (Platform.isIOS) {
    return showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(padding: const EdgeInsets.only(top: 8), child: Text(message)),
        actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.done))],
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
            Icon(androidIcon, size: 40),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(context.t.common.done)),
          ],
        ),
      ),
    ),
  );
}
