import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../protobuf.dart';
import '../../peer_names.dart';
import '../../privacy_blocks.dart';
import 'settings_blocked_state.dart';

/// «Заблокированные»: список из кэша настроек приватности (виден и без сети),
/// следит за его изменениями (блокировки с другого устройства, из профиля) и
/// при открытии запрашивает свежий снимок. Блокируют из профиля пользователя.
class SettingsBlockedCubit extends Cubit<SettingsBlockedState> {
  SettingsBlockedCubit() : super(const SettingsBlockedState());

  StreamSubscription<void>? _changes;
  StreamSubscription<Uint8List>? _profiles;

  /// Чьи профили уже запросили (имени нет в кэше) — по разу за экран.
  final _requested = <String>{};

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    _changes = PrivacyBlocks.changes().listen((_) => unawaited(_load()));
    // Пришёл профиль заблокированного — его имя в строку.
    _profiles = getIt.get<API>().on(MessageType.PROFILE).listen((payload) async {
      final response = Profile_Response.fromBuffer(payload);
      if (!state.users.any((u) => listEquals(u.userID, response.userID))) return;
      // Из самого ответа: в кэш профилей его могли ещё не записать.
      final name = await peerDisplayName(response.userID, fresh: response);
      if (isClosed) return;
      emit(
        state.copyWith(
          users: [for (final u in state.users) listEquals(u.userID, response.userID) ? BlockedUser(userID: u.userID, name: name) : u],
        ),
      );
    });
    await _load();
    unawaited(PrivacyBlocks.refresh());
  }

  Future<void> _load() async {
    final ids = await PrivacyBlocks.list();
    final users = [for (final id in ids) BlockedUser(userID: id, name: await peerDisplayName(id))];
    if (isClosed) return;
    emit(state.copyWith(status: Status.success, users: users));
    // Имени нет (не контакт, профиль ещё не кэшировался) — спросим профиль.
    final api = getIt.get<API>();
    for (final user in users) {
      if (user.name.isNotEmpty || !_requested.add(user.userID.join(','))) continue;
      unawaited(api.sendEncoded(MessageType.PROFILE, Profile_Request(userID: user.userID).writeToBuffer()));
    }
  }

  /// Разблокировать; не вышло — «Нет соединения».
  Future<void> unblock(BlockedUser user) async {
    if (!await PrivacyBlocks.setBlocked(user.userID, false) && !isClosed) {
      emit(state.copyWith(offlineNotice: state.offlineNotice + 1));
    }
  }

  @override
  Future<void> close() {
    _changes?.cancel();
    _profiles?.cancel();
    return super.close();
  }
}
