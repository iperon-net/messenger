
import 'package:talker/talker.dart';

class Logger {
  final _talker = Talker();

  Logger() {
    _talker.configure(
      settings: TalkerSettings(
        enabled: true,
        useHistory: true,
        maxHistoryItems: 1000,
        useConsoleLogs: true,
        timeFormat: TimeFormat.timeAndSeconds,
      ),
      logger: TalkerLogger(),
    );
    // _talker.debug("logger initialization");
  }

  void debug(String message) {
    _talker.debug(message);
  }

  void warning(String message) {
    _talker.warning(message);
  }

  void info(String message) {
    _talker.info(message);
  }

  void error(String message) {
    _talker.error(message);
  }

  void critical(String message) {
    _talker.critical(message);
  }

}
