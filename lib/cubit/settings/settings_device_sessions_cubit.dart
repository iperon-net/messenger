import 'dart:async';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../syncer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_device_sessions_state.dart';

class SettingsDeviceSessionsCubit extends Cubit<SettingsDeviceSessionsState> {
  SettingsDeviceSessionsCubit() : super(const SettingsDeviceSessionsState());

  final syncer = getIt.get<Syncer>();
  final logger = getIt.get<Logger>();

  Future<void> setDeviceSessions({required List<models.DeviceSession> deviceSessions}) async {
    emit(state.copyWith(deviceSessions: deviceSessions));
  }

  // StreamSubscription<List<models.DeviceSession>>? _deviceSessionsSubscription;
  //
  // Future<void> initialization() async {
  //   final controller = syncer.getController();
  //   await syncer.deviceSessions.getAllSessionRequest(controller: controller, seq: syncer.seq, session: syncer.session);
  //
  //   _deviceSessionsSubscription ??= syncer.deviceSessions.controllerDeviceSessions.stream.listen((deviceSessions) {
  //     emit(state.copyWith(deviceSessions: deviceSessions));
  //   });
  //
  // }
  //
  // @override
  // Future<void> close() {
  //   _deviceSessionsSubscription?.cancel();
  //   return super.close();
  // }

}
