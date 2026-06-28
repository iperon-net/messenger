import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../repositories/repositories.dart';
import '../../syncer.dart';
import '../../models.dart' as models;
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  final repositories = getIt.get<Repositories>();
  final syncer = getIt.get<Syncer>();
  final logger = getIt.get<Logger>();

  StreamSubscription<List<models.DeviceSession>>? _deviceSessionsSubscription;

  Future<void> initialization() async {
    final controller = syncer.getController();
    await syncer.deviceSessions.getAllSessionRequest(controller: controller, seq: syncer.seq, session: syncer.session);

    _deviceSessionsSubscription ??= syncer.deviceSessions.controllerDeviceSessions.stream.listen((deviceSessions) {
      emit(state.copyWith(deviceCount: deviceSessions.length));
    });

  }

  Future<void> setLocale({required AppLocale locale}) async {
    emit(state.copyWith(locale: locale));
  }

  Future<void> logout() async {
    final controller = syncer.getController();
    await syncer.auth.logoutRequest(controller: controller, seq: syncer.seq, session: syncer.session);
    emit(state.copyWith(logout: true));
  }

  @override
  Future<void> close() {
    _deviceSessionsSubscription?.cancel();
    return super.close();
  }

}
