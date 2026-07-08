import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/constants.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../repositories/repositories.dart';
import '../../streams.dart';
import '../../syncer.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  final repositories = getIt.get<Repositories>();
  final syncer = getIt.get<Syncer>();
  final logger = getIt.get<Logger>();
  final streams = getIt.get<Streams>();

  StreamSubscription<List<models.DeviceSession>>? _deviceSessionsSubscription;

  Future<void> initialization() async {
    final deviceSessionsCount = await repositories.cache.get(userID: syncer.session.userID, key: "deviceSessionsCount");
    if (deviceSessionsCount.isNotEmpty) {
      emit(state.copyWith(deviceSessionsCount: int.parse(utf8.decode(deviceSessionsCount))));
    }

    _deviceSessionsSubscription ??= streams.controllerDeviceSessions.stream.listen((deviceSessions) async {
      await repositories.cache.set(
          userID: syncer.session.userID,
          key: "deviceSessionsCount",
          value: utf8.encode(deviceSessions.length.toString()),
      );
      emit(state.copyWith(deviceSessionsCount: deviceSessions.length));
    });

  }

  Future<void> setLocale({required AppLocale locale}) async {
    emit(state.copyWith(locale: locale));
  }

  Future<void> logout() async {
    emit(state.copyWith(status: Status.loading));
    syncer.auth.logoutRequest();
    emit(state.copyWith(status: Status.success));
  }

  @override
  Future<void> close() {
    _deviceSessionsSubscription?.cancel();
    return super.close();
  }

}
