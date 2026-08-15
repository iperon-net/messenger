import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

class RepositoriesLog extends TalkerLog {
  RepositoriesLog(String super.message);

  /// Log title
  static String get getTitle => 'repositories';

  /// Log key
  static String get getKey => 'repositories_log_key';

  /// Log color
  static AnsiPen get getPen => AnsiPen()..blue();

  @override
  String get title => getTitle;

  @override
  String get key => getKey;

  @override
  AnsiPen get pen => getPen;
}

class GrpcErrorLog extends TalkerLog {
  GrpcErrorLog(String super.message);

  /// Log title
  static String get getTitle => 'grpc error';

  /// Log key
  static String get getKey => 'grpc_error_log_key';

  /// Log color
  static AnsiPen get getPen => AnsiPen()..blue();

  @override
  String get title => getTitle;

  @override
  String get key => getKey;

  @override
  AnsiPen get pen => getPen;
}

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
        enabled: kDebugMode,
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

  void logCustom(TalkerLog log) {
    _talker.logCustom(log);
  }

  Talker get talker => _talker;

  void debug(dynamic message) {
    if (kDebugMode) _talker.debug(message);
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

  void handle(Object exception, [StackTrace? stackTrace, dynamic msg]) {
    _talker.handle(exception, stackTrace, msg);
  }

}
