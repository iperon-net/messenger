import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/repositories/repositories.dart';

import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../streams.dart';
import '../../syncer.dart';
import 'settings_device_sessions_state.dart';

class SettingsDeviceSessionsCubit extends Cubit<SettingsDeviceSessionsState> {
  SettingsDeviceSessionsCubit() : super(const SettingsDeviceSessionsState());

  final syncer = getIt.get<Syncer>();
  final streams = getIt.get<Streams>();
  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();

  StreamSubscription<List<models.DeviceSession>>? _deviceSessionsSubscription;

  Future<void> initialization() async {
    // Сначала показываем то, что уже есть в локальной БД.
    final deviceSessions = await repositories.deviceSessions.getAll(session: syncer.session);
    emit(state.copyWith(deviceSessions: deviceSessions));

    // Подписываемся на обновления от синкера (когда сервер пришлёт новый список).
    _deviceSessionsSubscription ??= streams.controllerDeviceSessions.stream.listen((deviceSessions) {
      emit(state.copyWith(deviceSessions: deviceSessions));
    });

    // Запрашиваем у сервера актуальный список.
    await refresh();
  }

  Future<void> refresh() async {
    await syncer.deviceSessions.getAllSessionRequest();
  }

  Future<void> setDeviceSessions({required List<models.DeviceSession> deviceSessions}) async {
    emit(state.copyWith(deviceSessions: deviceSessions));
  }

  Future<void> logoutSession({required List<List<int>> sessionID}) async {
    await syncer.deviceSessions.logout(sessionID: sessionID);

    emit(state.copyWith(
      deviceSessions: state.deviceSessions
          .where((data) => !sessionID.any((id) => listEquals(id, data.sessionID)))
          .toList(),
    ));
  }

  @override
  Future<void> close() {
    _deviceSessionsSubscription?.cancel();
    return super.close();
  }

}
