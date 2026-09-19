import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../api.dart';
import '../../calls.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';
import 'calls_state.dart';

/// Кубит вкладки «Звонки». Читает локальный журнал звонков из БД и
/// перечитывает его, когда сервис [Calls] сообщает о новой записи ([Calls.callLogged])
/// — то есть после завершения любого звонка. Поиск и фильтр (все/пропущенные)
/// держит в состоянии; сами удаления идут в БД и триггерят перечитывание.
///
/// Имя собеседника в снимке [models.CallLog.displayName] мог устареть (профиль
/// изменился после звонка), поэтому актуальное имя резолвим «вживую» из кэша
/// профилей (как аватар в [UserAvatar]) в [CallsState.names] и обновляем по
/// приходящим `PROFILE`, пока вкладка открыта.
class CallsCubit extends Cubit<CallsState> {
  CallsCubit() : super(const CallsState());

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();
  final _calls = getIt.get<Calls>();

  StreamSubscription<void>? _sub;
  StreamSubscription<Uint8List>? _profileSub;

  void initialization() {
    _sub = _calls.callLogged.listen((_) => load());
    // Обновление профиля собеседника (пришло по стриму или в ответ на запрос,
    // который шлёт, например, аватар в списке) — освежаем его имя в журнале.
    _profileSub = api.on(MessageType.PROFILE).listen(_onProfile);
    load();
  }

  /// Перечитывает журнал из БД и резолвит актуальные имена из кэша профилей.
  Future<void> load() async {
    try {
      final calls = await repositories.callLogs.getAll();
      if (isClosed) return;
      final names = await _resolveNames(calls);
      if (isClosed) return;
      emit(state.copyWith(status: Status.success, calls: calls, names: names));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      if (!isClosed) emit(state.copyWith(status: Status.success));
    }
  }

  /// Актуальные имена (hex(userID) → имя) из кэша профилей по уникальным
  /// собеседникам журнала. В карту кладём только непустые имена — иначе UI сам
  /// откатится на снимок из строки, затем на «Неизвестный».
  Future<Map<String, String>> _resolveNames(List<models.CallLog> calls) async {
    final seen = <String>{};
    final names = <String, String>{};
    for (final log in calls) {
      final hex = utils.bytesToHex(log.userID);
      if (!seen.add(hex)) continue;
      try {
        final profile = await repositories.profiles.getByUserID(userID: log.userID);
        final phone = utils.phoneNormalization(phoneNumber: profile.phoneNumber);
        var name = utils.composeDisplayName(
          firstName: profile.fistName,
          lastName: profile.lastName,
          phoneNumber: phone.international,
          username: profile.username,
        );
        // Профиль ещё не в кэше или без имени/номера — берём имя/номер из
        // адресной книги по этому userID (если контакт заведён).
        if (name.isEmpty) {
          final contact = await repositories.contacts.getByUserID(log.userID);
          if (contact != null) {
            name = contact.displayName.isNotEmpty ? contact.displayName : contact.phone;
          }
        }
        if (name.isNotEmpty) names[hex] = name;
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
    }
    return names;
  }

  /// Пришёл профиль — если этот собеседник есть в журнале, обновляем его имя.
  void _onProfile(Uint8List payload) {
    if (isClosed) return;
    final Profile_Response response;
    try {
      response = Profile_Response.fromBuffer(payload);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return;
    }
    // Собеседника нет в журнале — обновлять нечего.
    final present = state.calls.any((log) => listEquals(log.userID, response.userID));
    if (!present) return;
    final hex = utils.bytesToHex(Uint8List.fromList(response.userID));

    final phone = utils.phoneNormalization(phoneNumber: response.phoneNumber);
    final name = utils.composeDisplayName(
      firstName: response.firstName,
      lastName: response.lastName,
      phoneNumber: phone.international,
      username: response.username,
    );
    if (name.isEmpty || state.names[hex] == name) return;

    emit(state.copyWith(names: {...state.names, hex: name}));
  }

  void search(String query) => emit(state.copyWith(query: query));

  void setFilter(CallsFilter filter) => emit(state.copyWith(filter: filter));

  /// Удаляет одну запись журнала.
  Future<void> delete(models.CallLog log) async {
    try {
      await repositories.callLogs.deleteByID(log.id);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    await load();
  }

  /// Очищает весь журнал.
  Future<void> clearAll() async {
    try {
      await repositories.callLogs.deleteAll();
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    await load();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _profileSub?.cancel();
    return super.close();
  }
}
