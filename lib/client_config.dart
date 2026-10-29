import 'package:flutter/foundation.dart';

import 'api.dart';
import 'di.dart';
import 'logger.dart';
import 'protobuf.dart';
import 'repositories.dart';
import 'settings.dart';

/// Настройки приложения с сервера (`ClientConfig`, этап 5б
/// docs/plans/admin-panel.md) вместо Remote Config: до входа — unary
/// `CLIENT_CONFIG` ([fetch]), после — в ответе `SUBSCRIBE` и пушем
/// `CLIENT_CONFIG` по стриму ([apply] из `API._handleMessage`). Последний
/// ответ лежит в `device.db` ([ClientConfigCache], по серверу) и подхватывается
/// на старте ([loadCached]) — офлайн и до ответа сервера. Значения читаются
/// через [Settings], который уведомляет слушателей о новых.
class ClientConfigSync {
  ClientConfigSync._();

  static Settings get _settings => getIt.get<Settings>();

  /// Ключ кэша — сервер, к которому подключается приложение.
  static String get _server => '${_settings.apiHost}:${_settings.apiPort}';

  /// Кэш с прошлого запуска → [Settings.serverConfig].
  static Future<void> loadCached() async {
    try {
      final data = await getIt.get<DeviceRepositories>().clientConfig.get(_server);
      if (data != null) _settings.serverConfig = ClientConfig_Response.fromBuffer(data);
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace, 'client config: cache');
    }
  }

  /// Ответ сервера [data]: если отличается от текущего — в [Settings] и в кэш.
  /// true — что-то поменялось.
  static Future<bool> apply(List<int> data) async {
    final current = _settings.serverConfig?.writeToBuffer();
    final config = ClientConfig_Response.fromBuffer(data);
    if (current != null && listEquals(current, config.writeToBuffer())) return false;
    _settings.serverConfig = config;
    await getIt.get<DeviceRepositories>().clientConfig.put(_server, Uint8List.fromList(config.writeToBuffer()));
    getIt.get<Logger>().debug('client config: updated $config');
    return true;
  }

  /// Unary `CLIENT_CONFIG` (без входа). Null — ошибка (нет сети, старый
  /// сервер); иначе — поменялось ли что-то.
  static Future<bool?> fetch() async {
    final api = getIt.get<API>();
    late Message response;
    final status = await api.call(() async {
      response = await api.client.unary(Message(messageType: MessageType.CLIENT_CONFIG));
    }, retryTransient: true);
    if (status.status == APIStatus.error) {
      getIt.get<Logger>().debug('client config: fetch failed: $status');
      return null;
    }
    return apply(response.message);
  }
}
