import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

import 'mapper.dart';

part 'call_log.mapper.dart';

/// Направление звонка в журнале недавних. [incoming] — нам звонили, [outgoing] —
/// мы звонили. «Пропущенный» — это не направление, а флаг [CallLog.missed]
/// (входящий, на который не ответили).
@MappableEnum()
enum CallDirection { incoming, outgoing }

/// Запись журнала звонков (таблица `callLogs`). Пишется локально при завершении
/// звонка (см. `Calls._recordCallLog`) — сервер историю звонков не хранит.
/// Отображаемое имя фиксируется снимком на момент звонка (кэш профиля мог быть
/// пуст/устареть), а аватар подтягивается «вживую» по [userID] через
/// `UserAvatar`.
@MappableClass(includeCustomMappers: [Uint8ListMapper(), BoolMapper(), EpochDateTimeMapper()])
class CallLog with CallLogMappable {
  /// Локальный автоинкрементный идентификатор строки (ключ удаления).
  final int id;

  /// callId звонка (имя комнаты LiveKit) — для диагностики/дедупа.
  final String callID;

  /// userID собеседника (сырые байты ObjectID) — сид аватара и переход в профиль.
  final Uint8List userID;

  /// Имя собеседника на момент звонка (снимок из кэша профиля); пусто, если
  /// профиль был неизвестен — тогда UI показывает «Неизвестный».
  final String displayName;

  final CallDirection direction;

  /// Видеозвонок (иначе аудио).
  final bool video;

  /// Пропущенный: входящий, на который не ответили (и не отклонили сами).
  /// Такие строки выделяются красным.
  final bool missed;

  /// Длительность разговора в секундах; `0`, если звонок не состоялся
  /// (не ответили/отменили).
  final int durationSeconds;

  /// Момент завершения звонка (epoch-millis в БД).
  final DateTime createdAt;

  const CallLog({
    this.id = 0,
    this.callID = '',
    required this.userID,
    this.displayName = '',
    this.direction = CallDirection.outgoing,
    this.video = false,
    this.missed = false,
    this.durationSeconds = 0,
    required this.createdAt,
  });
}
