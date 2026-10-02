import '../../api.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../push.dart';

/// Отправляет тестовый push на все устройства пользователя (PUSH_TEST) и
/// возвращает текст итога для показа (Cupertino — диалог, Material — SnackBar).
/// Используется обоими экранами «Разработчик». Перед отправкой досинхронизирует
/// токены, чтобы свежий APNs/FCM-токен этого устройства успел попасть на сервер.
///
/// [encrypted] — через серверный конвейер (очередь + зашифрованный `p`): Android
/// расшифровывает и показывает нативно, на iOS до Notification Service Extension
/// (этап 3) показывается фолбэк-текст.
Future<String> sendTestPush(Translations t, {bool encrypted = false}) async {
  try {
    final push = getIt.get<PushManager>();
    await push.syncTokens();

    final (status, response) = await push.sendTestPush(encrypted: encrypted);
    if (status.status != APIStatus.success || response == null) {
      final error = (t[status.error] as String?) ?? status.error;
      return t.screenDeveloper.testPushError(error: error);
    }
    if (response.queued) return t.screenDeveloper.testPushQueued;
    if (response.apnsSent + response.fcmSent + response.failed == 0) {
      return t.screenDeveloper.testPushNoTokens;
    }
    return t.screenDeveloper.testPushSent(apns: response.apnsSent, fcm: response.fcmSent, failed: response.failed);
  } catch (error, stackTrace) {
    getIt.get<Logger>().handle(error, stackTrace);
    return t.screenDeveloper.testPushError(error: error.toString());
  }
}
