import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../api.dart';
import '../constants.dart';
import '../di.dart';
import '../logger.dart';

import 'connection_state.dart';

/// Сводит два независимых источника в единый статус соединения для UI:
/// наличие сети (`connectivity_plus`) и состояние gRPC-стрима ([API]).
///
/// Кубит не в `get_it` (по конвенции проекта), а данные берёт из синглтона
/// [API] и из `connectivity_plus`. Держится один экземпляр на всё приложение
/// (провайдится в shell), поэтому статус общий для всех вкладок.
class ConnectionCubit extends Cubit<ConnectionState> {
  ConnectionCubit() : super(const ConnectionState());

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();

  final _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  StreamSubscription<ApiConnectionStatus>? _apiSub;

  // Последние сырые значения источников — храним, чтобы на каждый тик любого из
  // них пересчитать сводный статус по актуальному состоянию обоих.
  bool _hasNetwork = true;
  ApiConnectionStatus _apiStatus = ApiConnectionStatus.connecting;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    // Стартовые значения обоих источников.
    _apiStatus = api.connectionStatus;
    try {
      _hasNetwork = _isOnline(await _connectivity.checkConnectivity());
    } catch (error, stackTrace) {
      // Если платформа не ответила — не блокируем UI, считаем что сеть есть;
      // реальную картину дадут последующие события стрима.
      logger.handle(error, stackTrace);
      _hasNetwork = true;
    }

    _connectivitySub = _connectivity.onConnectivityChanged.listen(
      (results) {
        _hasNetwork = _isOnline(results);
        _recompute();
      },
      onError: (error, stackTrace) {
        // Плагин недоступен/сбоит (например, нативная часть ещё не
        // зарегистрирована после добавления плагина) — не роняем статус:
        // считаем, что сеть есть, реальную картину даст стрим API.
        logger.handle(error, stackTrace);
        _hasNetwork = true;
        _recompute();
      },
    );

    _apiSub = api.connectionStatusStream.listen((status) {
      _apiStatus = status;
      _recompute();
    });

    emit(state.copyWith(status: Status.success, connection: _combine()));
  }

  // connectivity_plus отдаёт список активных интерфейсов; сеть есть, если он не
  // пуст и содержит хоть что-то, кроме `none`. Это лишь наличие интерфейса, а не
  // реальная достижимость сервера — за неё отвечает [_apiStatus].
  bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  // Приоритет: нет сети > нет стрима > идёт синхронизация > норма.
  ConnectionStatusModel _combine() {
    if (!_hasNetwork) return ConnectionStatusModel.waitingForNetwork;
    switch (_apiStatus) {
      case ApiConnectionStatus.connecting:
        return ConnectionStatusModel.connecting;
      case ApiConnectionStatus.updating:
        return ConnectionStatusModel.updating;
      case ApiConnectionStatus.connected:
        return ConnectionStatusModel.connected;
    }
  }

  void _recompute() {
    final next = _combine();
    if (next == state.connection) return;
    emit(state.copyWith(connection: next));
  }

  @override
  Future<void> close() {
    // cancel() у connectivity_plus может бросить MissingPluginException, если
    // нативная часть не зарегистрирована — гасим, чтобы не сыпать в консоль.
    _connectivitySub?.cancel().catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      logger.handle(error, stackTrace);
    });
    _apiSub?.cancel();
    return super.close();
  }
}
