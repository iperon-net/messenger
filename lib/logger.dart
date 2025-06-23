import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker/talker.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

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
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(
          enableColors: Platform.isIOS ? false : true,
          maxLineWidth: 120,
        ),
      ),
    );

    Bloc.observer = TalkerBlocObserver(
      settings: TalkerBlocLoggerSettings(
        enabled: true,
        printEventFullData: true,
        printStateFullData: true,
        printChanges: true,
        printClosings: true,
        printCreations: true,
        printEvents: true,
        printTransitions: true,
      ),
      talker: _talker,
    );
  }

  Talker getTalker() {
    return _talker;
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
