import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../client_config.dart';
import '../../di.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../settings.dart';
import '../../utils.dart';

/// Подпись строки «Обновить Remote Config»: когда значения загружались в
/// последний раз (Firebase обновляет их не чаще раза в 24 ч).
String remoteConfigFetchedText(Translations t) {
  final remoteConfig = getIt.get<Settings>().remoteConfig;
  if (remoteConfig.lastFetchStatus == RemoteConfigFetchStatus.noFetchYet) return t.screenDeveloper.remoteConfigNever;
  return t.screenDeveloper.remoteConfigFetched(time: remoteConfig.lastFetchTime.relativeFormat(t));
}

/// Перезагружает настройки приложения с сервера (`CLIENT_CONFIG`) и
/// возвращает текст итога для показа.
Future<String> refreshServerConfig(Translations t) async {
  if (!await getIt.get<Utils>().hasNetwork()) return t.common.noConnectionTitle;
  return switch (await ClientConfigSync.fetch()) {
    true => t.screenDeveloper.serverConfigUpdated,
    false => t.screenDeveloper.serverConfigUnchanged,
    null => t.screenDeveloper.serverConfigError,
  };
}

/// Загружает Remote Config мимо интервала и возвращает текст итога для показа
/// (Cupertino — диалог, Material — SnackBar). Используется обоими экранами
/// «Разработчик». Без сети — сразу «нет соединения», без попытки.
Future<String> refreshRemoteConfig(Translations t) async {
  if (!await getIt.get<Utils>().hasNetwork()) return t.common.noConnectionTitle;
  try {
    final updated = await getIt.get<Settings>().forceFetchRemoteConfig();
    return updated ? t.screenDeveloper.remoteConfigUpdated : t.screenDeveloper.remoteConfigUnchanged;
  } on FirebaseException catch (error, stackTrace) {
    getIt.get<Logger>().handle(error, stackTrace);
    return t.screenDeveloper.remoteConfigError(error: error.message ?? error.code);
  } catch (error, stackTrace) {
    getIt.get<Logger>().handle(error, stackTrace);
    return t.screenDeveloper.remoteConfigError(error: error.toString());
  }
}
