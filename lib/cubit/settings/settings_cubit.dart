import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:messenger/repositories.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../api.dart';
import '../../protobuf.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final repositories = getIt.get<Repositories>();

  StreamSubscription<Uint8List>? _subscription;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    final deviceSessions = await repositories.deviceSessions.getAll();
    emit(state.copyWith(status: Status.loading, countDeviceSessions: deviceSessions.length));

    _subscription = api.on(MessageType.DEVICE_SESSIONS).listen((payload) {
      if (isClosed) return;

      final response = DeviceSessions_Response.fromBuffer(payload);
      emit(state.copyWith(status: Status.success, countDeviceSessions: response.results.length));
    });

    // sendEncoded может ждать готовности стрима — за время await кубит мог
    // закрыться, поэтому не эмитим в закрытый кубит.
    await api.sendEncoded(MessageType.DEVICE_SESSIONS, DeviceSessions_Request().writeToBuffer());
    if (isClosed) return;

    emit(state.copyWith(status: Status.success));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
