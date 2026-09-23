import 'package:flutter/services.dart' show MethodChannel;
import 'package:permission_handler/permission_handler.dart';

/// Гарантирует доступ к микрофону перед стартом звонка: если решение ещё не
/// принято — системный запрос. Permanently denied пропускаем (система диалог уже
/// не покажет). Идемпотентно и не блокирует старт звонка.
///
/// Мягкий soft-ask разрешений на самой вкладке «Звонки» вынесен в баннер
/// [PermissionBanner] (см. `CallsCubit.checkCallPermissions`/`requestCallPermissions`);
/// эта функция нужна только на кнопках «Позвонить», где микрофон обязателен.
Future<void> ensureCallMicPermission() async {
  final mic = await Permission.microphone.status;
  if (!mic.isGranted && !mic.isPermanentlyDenied) await Permission.microphone.request();
}

const _pipChannel = MethodChannel('net.iperon.messenger/call_pip');

/// Android-only: выдано ли разрешение Picture-in-Picture (мини-окно видеозвонка
/// при сворачивании). Это AppOps-разрешение — статус спрашиваем у натива. При
/// ошибке/на других платформах считаем выданным (баннер не навязываем).
Future<bool> isPipPermissionGranted() async {
  return await _pipChannel.invokeMethod<bool>('isPipPermissionGranted') ?? true;
}

/// Android-only: открывает системные настройки PiP приложения (там тумблер).
/// PiP-разрешение системным диалогом не запросить, поэтому ведём в настройки.
Future<void> openPipSettings() async {
  await _pipChannel.invokeMethod<void>('openPipSettings');
}
