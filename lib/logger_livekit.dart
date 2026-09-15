import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:logging/logging.dart' as logging;
import 'package:talker/talker.dart';

import 'di.dart';
import 'logger.dart';

/// Кастомный talker-лог для записей LiveKit (`package:logging`) — чтобы они
/// выделялись цветом/заголовком в экране «Логи» и попадали в экспорт логов.
class LiveKitLog extends TalkerLog {
  LiveKitLog(String super.message);

  static String get getTitle => 'livekit';
  static String get getKey => 'livekit_log_key';
  static AnsiPen get getPen => AnsiPen()..magenta();

  @override
  String get title => getTitle;

  @override
  String get key => getKey;

  @override
  AnsiPen get pen => getPen;
}

bool _attached = false;

/// Заворачивает подробные логи LiveKit SDK (`package:logging`, логгер `livekit`)
/// в наш talker на уровне FINE. Это единственный способ увидеть на устройстве
/// диагностику ICE: список ICE/TURN-серверов из `JoinResponse`, флаг `forceRelay`
/// и переходы `iceConnectionState` (checking → failed). После этого они видны в
/// экране «Логи» и уходят в экспорт логов (экран «Разработчик»).
///
/// Идемпотентна. Вызывается один раз на старте после регистрации зависимостей
/// (см. main.dart), когда [Logger] уже доступен в `get_it`.
void attachLiveKitLogging() {
  if (_attached) return;
  _attached = true;

  // Нужно для пер-логгерных уровней и собственного onRecord у именованного
  // логгера (без этого работает только Logger.root.level).
  logging.hierarchicalLoggingEnabled = true;
  lk.setLoggingLevel(lk.LoggerLevel.kFINE);

  final logger = getIt.get<Logger>();
  // LiveKit пишет через один именованный логгер `Logger('livekit')` — слушаем
  // именно его (точечно, без шума от прочих логгеров приложения/фреймворка).
  logging.Logger('livekit').onRecord.listen((record) {
    final message = record.message;
    if (record.level >= logging.Level.SEVERE) {
      logger.error('[livekit] $message');
    } else if (record.level >= logging.Level.WARNING) {
      logger.warning('[livekit] $message');
    } else {
      logger.logCustom(LiveKitLog(message));
    }
  });
}
