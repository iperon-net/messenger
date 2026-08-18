import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/repositories.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart';
import '../../api.dart';
import '../../protobuf.dart';

import 'settings_device_sessions_state.dart';

class SettingsDeviceSessionsCubit extends Cubit<SettingsDeviceSessionsState> {
  SettingsDeviceSessionsCubit() : super(SettingsDeviceSessionsState(deviceSessions: []));

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();

  StreamSubscription<Uint8List>? _subscription;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    final deviceSessions = await repositories.deviceSessions.getAll();
    final currentSessionID = auth.session.sessionID;

    emit(
      state.copyWith(
        status: Status.success,
        deviceSessions: deviceSessions
            .map((session) => session.copyWith(isCurrent: listEquals(session.sessionID, currentSessionID)))
            .toList(),
      ),
    );

    // Подписываемся до отправки запроса, чтобы не пропустить ответ, если он
    // придёт быстро.
    _subscription = api.on(MessageType.DEVICE_SESSIONS).listen((payload) {
      if (isClosed) return;

      final response = DeviceSessions_Response.fromBuffer(payload);
      final currentSessionID = auth.session.sessionID;
      List<DeviceSessionsModel> deviceSessions = <DeviceSessionsModel>[];

      for (final item in response.results) {
        final sessionID = Uint8List.fromList(item.sessionID);
        deviceSessions.add(
          DeviceSessionsModel(
            sessionID: sessionID,
            isCurrent: listEquals(sessionID, currentSessionID),
            updateAt: item.updateAt.toDateTime(),
            deviceModel: item.deviceModel,
            os: item.os,
            osVersion: item.osVersion,
            appVersion: item.appVersion,
            appBuildNumber: item.appBuildNumber,
            locationEnglish: item.locationEnglish,
            locationRussian: item.locationRussian,
          ),
        );
      }
      emit(state.copyWith(status: Status.success, deviceSessions: deviceSessions));
    });

    // sendEncoded может ждать готовности стрима (до отправки Subscribe), поэтому
    // экран мог закрыться за время await — не эмитим в закрытый кубит.
    await api.sendEncoded(MessageType.DEVICE_SESSIONS, DeviceSessions_Request().writeToBuffer());
    if (isClosed) return;

    emit(state.copyWith(status: Status.success));
  }

  Future<void> terminate(List<Uint8List> sessionID) async {
    emit(state.copyWith(requestStatus: Status.loading));
    await api.unaryEncoded(MessageType.DEVICE_SESSIONS_TERMINATE, DeviceSessionsTerminate_Request(sessionID: sessionID).writeToBuffer());
    emit(state.copyWith(requestStatus: Status.success));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
