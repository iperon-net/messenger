import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../call_push.dart';
import '../di.dart';
import '../i18n/translations.g.dart';

/// Показывали ли уже soft-ask разрешений звонков в этой сессии. Один показ за
/// запуск: и открытие вкладки «Звонки», и нажатие «Позвонить» проходят через
/// один гейт, чтобы не доводить диалог. Дальше решает системный статус (granted
/// короткозамыкает проверку и на следующих запусках).
bool _askedThisSession = false;

/// Единый soft-ask перед системными запросами разрешений, нужных для звонков:
/// микрофон (обе платформы) и уведомления POST_NOTIFICATIONS (только Android —
/// на iOS входящие ведёт CallKit, отдельного разрешения на уведомления он не
/// требует). Привязан к вкладке «Звонки» (первый показ) и к кнопкам «Позвонить».
///
/// Смотрит, каких разрешений ещё не хватает, и показывает ОДИН диалог с текстом
/// под набор недостающих: оба / только микрофон / только уведомления. При
/// согласии запрашивает недостающие СТРОГО последовательно — на Android два
/// системных диалога прав одновременно не показываются (второй молча
/// отклоняется). Не блокирует звонок: вызывающая сторона может стартовать его
/// сразу после.
///
/// iOS: уведомления не нужны, а Cupertino-диалог (Material `showDialog` внутри
/// `CupertinoApp` невозможен) ради одного микрофона не заводим — просто
/// прогреваем системный запрос микрофона, как было раньше.
///
/// [forCall] — вызов из кнопки «Позвонить». Микрофон обязателен для звонка,
/// поэтому даже когда soft-ask в этой сессии уже показывали (гейт закрыт), при
/// реальном вызове его всё равно до-запрашиваем — иначе после «Не сейчас» звонок
/// ушёл бы без микрофона. Уведомления остаются под гейтом (не критичны для
/// исходящего).
Future<void> ensureCallPermissions(BuildContext context, {bool forCall = false}) async {
  if (_askedThisSession) {
    if (forCall) await _requestMicIfNeeded();
    return;
  }

  if (!Platform.isAndroid) {
    _askedThisSession = true;
    await _requestMicIfNeeded();
    return;
  }

  // Android: считаем недостающие разрешения. Permanently denied исключаем —
  // системный диалог по ним уже не покажется, soft-ask'ом не навязываемся.
  final micStatus = await Permission.microphone.status;
  final needMic = !micStatus.isGranted && !micStatus.isPermanentlyDenied;
  final notifStatus = await Permission.notification.status;
  final needNotif = !notifStatus.isGranted && !notifStatus.isPermanentlyDenied;
  if (!needMic && !needNotif) return;
  if (!context.mounted) return;

  final t = context.t.screenCalls;
  final (String title, String message) = switch ((needMic, needNotif)) {
    (true, true) => (t.permissionsTitle, t.permissionsMessage),
    (false, true) => (t.notificationPermissionTitle, t.notificationPermissionMessage),
    // (true, false) — только микрофон; (false, false) недостижимо (вышли выше).
    _ => (t.permissionTitle, t.permissionMessage),
  };

  _askedThisSession = true;
  final proceed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.notNow)),
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.allowAccess)),
      ],
    ),
  );
  if (proceed != true) return;

  // Недостающие запрашиваем последовательно: сначала микрофон, затем уведомления
  // (через тот же плагин звонилки, что и раньше) — во избежание двойного
  // системного диалога на Android.
  if (needMic) await Permission.microphone.request();
  if (needNotif) await getIt.get<CallPush>().requestNotificationPermission();
}

/// Системный запрос микрофона, если решение ещё не принято. Permanently denied
/// пропускаем — система диалог уже не покажет. Идемпотентно.
Future<void> _requestMicIfNeeded() async {
  final mic = await Permission.microphone.status;
  if (!mic.isGranted && !mic.isPermanentlyDenied) await Permission.microphone.request();
}
