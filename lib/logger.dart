import 'dart:io';

import 'package:flutter/foundation.dart';
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
        enabled: kDebugMode ? true : false,
        printEventFullData: false,
        printStateFullData: true,
        printChanges: true,
        printClosings: false,
        printCreations: false,
        printEvents: false,
        printTransitions: false,
      ),
      talker: _talker,
    );

    _talker.info("logger initialization");
  }

  Talker getTalker() {
    return _talker;
  }

  void debug(dynamic message) {
    _talker.debug(message);
  }

  void warning(dynamic message) {
    _talker.warning(message);
  }

  void info(dynamic message) {
    _talker.info(message);
  }

  void error(dynamic message) {
    _talker.error(message);
  }

  void critical(dynamic message) {
    _talker.critical(message);
  }

}
