import 'package:dart_mappable/dart_mappable.dart';

import '../constants.dart';

part 'connection_state.mapper.dart';

/// Сводный статус соединения для UI (как строка состояния в Telegram).
///
/// Приоритет при сведе́нии двух источников (см. [ConnectionCubit]):
/// сеть важнее сервера, сервер важнее синхронизации.
/// - [waitingForNetwork] — нет ни одного сетевого интерфейса (`connectivity_plus`);
/// - [connecting] — сеть есть, но gRPC-стрим ещё не установлен / переподключается;
/// - [updating] — стрим установлен, идёт разбор входящих (первичная синхронизация);
/// - [connected] — всё в норме; в этом состоянии UI показывает обычный заголовок.
enum ConnectionStatusModel { waitingForNetwork, connecting, updating, connected }

@MappableClass()
class ConnectionState with ConnectionStateMappable {
  final Status status;
  final ConnectionStatusModel connection;

  const ConnectionState({this.status = Status.initialization, this.connection = ConnectionStatusModel.connecting});
}
