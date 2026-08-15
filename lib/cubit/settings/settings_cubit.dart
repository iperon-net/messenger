import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:messenger/repositories.dart';

import '../../auth.dart';
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
  final auth = getIt.get<Auth>();

  StreamSubscription<Uint8List>? _subscription;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    final deviceSessions = await repositories.deviceSessions.getAll();
    emit(
      state.copyWith(
        status: Status.loading,
        countDeviceSessions: deviceSessions.length,
      ),
    );

    _subscription = api.on(MessageType.DEVICE_SESSIONS).listen((payload) {
      if (isClosed) return;

      final response = DeviceSessions_Response.fromBuffer(payload);
      emit(
        state.copyWith(
          status: Status.success,
          countDeviceSessions: response.results.length,
        ),
      );
    });

    // sendEncoded может ждать готовности стрима — за время await кубит мог
    // закрыться, поэтому не эмитим в закрытый кубит.
    await api.sendEncoded(
      MessageType.DEVICE_SESSIONS,
      DeviceSessions_Request().writeToBuffer(),
    );
    if (isClosed) return;

    emit(state.copyWith(status: Status.success));
  }

  Future<void> terminate() async {
    // Снимаем текущую сессию на сервере unary-вызовом (не через стрим): unary
    // живёт в собственном request-контексте на канале, поэтому закрытие стрима
    // в auth.logout() его не отменяет — на сервере terminate доходит до конца
    // (через стрим сервер падал с "context canceled"). Запрос шифруется
    // сессионным ключом, который auth.logout() ниже обнулит, поэтому запускаем
    // его синхронно ДО logout: crypto.encode успевает прочитать текущую сессию.
    // Не ждём ответа — локальный выход не должен зависеть от сети/сервера.
    final terminateOnServer = api.unaryEncoded(
      MessageType.DEVICE_SESSIONS_TERMINATE,
      DeviceSessionsTerminate_Request(
        sessionID: [auth.session.sessionID],
      ).writeToBuffer(),
    );
    unawaited(
      terminateOnServer
          .then((status) {
            if (status.status == APIStatus.error) {
              logger.warning(
                'device session terminate on logout failed: $status',
              );
            }
          })
          .catchError((Object error, StackTrace stackTrace) {
            logger.handle(error, stackTrace);
          }),
    );

    // Локальный выход сразу: auth.logout() чистит сессию в памяти и БД и через
    // notifyListeners() уводит go_router на /auth, не дожидаясь сервера и не
    // завися от состояния стрима.
    await auth.logout();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
