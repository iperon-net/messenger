import '../../bootstrap/bootstrap_config.dart';
import '../../client_config.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../settings.dart';
import '../../utils.dart';

/// Подпись строки «Адреса серверов»: номер bootstrap-файла (0 — ещё не
/// загружался, адреса из сборки), окружение активного аккаунта и его адрес.
String bootstrapConfigInfo(Translations t) {
  final settings = getIt.get<Settings>();
  return t.screenDeveloper.bootstrapConfigInfo(
    serial: BootstrapConfig.file.serial,
    environment: settings.environment,
    address: '${settings.apiHost}:${settings.apiPort}',
  );
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

/// Скачивает bootstrap-файл (`config.json`) мимо интервала и возвращает текст
/// итога для показа (Cupertino — диалог, Material — SnackBar). Без сети — сразу
/// «нет соединения», без попытки.
Future<String> refreshBootstrapConfig(Translations t) async {
  if (!await getIt.get<Utils>().hasNetwork()) return t.common.noConnectionTitle;
  return switch (await BootstrapConfig.refresh(force: true)) {
    true => t.screenDeveloper.bootstrapConfigUpdated,
    false => t.screenDeveloper.bootstrapConfigUnchanged,
    null => t.screenDeveloper.bootstrapConfigError,
  };
}
