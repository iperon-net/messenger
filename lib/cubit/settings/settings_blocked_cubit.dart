import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../models.dart' as models;
import '../../protobuf.dart';
import '../../protobuf/protos/chats_v1.pb.dart' as pb;
import '../../peer_names.dart';
import '../../privacy_blocks.dart';
import '../../repositories.dart';
import '../../utils.dart';
import 'settings_blocked_state.dart';

/// «Заблокированные»: список из кэша настроек приватности (виден и без сети),
/// следит за его изменениями (блокировки с другого устройства, из профиля) и
/// при открытии запрашивает свежий снимок. Блокируют из профиля пользователя
/// или здесь — «Заблокировать пользователя» с выбором из чатов и контактов.
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

  /// Кого можно заблокировать: собеседники личных чатов (сначала свежие, как в
  /// списке чатов), затем остальные контакты в Iperon по имени — без меня,
  /// уже заблокированных и локально скрытых профилей. Всё из кэша (без сети).
  Future<List<BlockedUser>> candidates() async {
    final repositories = getIt.get<Repositories>();
    final utils = getIt.get<Utils>();
    final me = getIt.get<Auth>().session.userID;
    final skip = {
      utils.bytesToHex(Uint8List.fromList(me)),
      // «Iperon» не блокируют.
      models.systemUserID,
      ...await PrivacyBlocks.hexes(),
      ...(await repositories.hiddenProfiles.hashByHex()).keys,
    };

    final dialogs = (await repositories.chats.dialogs(userID: me)).where((d) => d.type == pb.ChatType.CHAT_TYPE_PRIVATE.value).toList()
      ..sort((a, b) => b.topMessageDate.compareTo(a.topMessageDate));
    final fromChats = <BlockedUser>[];
    for (final dialog in dialogs) {
      final peer = dialog.peerUserID;
      if (peer == null || !skip.add(utils.bytesToHex(peer))) continue;
      fromChats.add(BlockedUser(userID: peer, name: await peerDisplayName(peer)));
    }

    final fromContacts = <BlockedUser>[];
    for (final contact in await repositories.contacts.getAll()) {
      final userID = contact.userID;
      if (userID == null || userID.isEmpty || !skip.add(utils.bytesToHex(Uint8List.fromList(userID)))) continue;
      fromContacts.add(BlockedUser(userID: Uint8List.fromList(userID), name: await peerDisplayName(userID)));
    }
    fromContacts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return [...fromChats, ...fromContacts].where((u) => u.name.isNotEmpty).toList(growable: false);
  }

  /// Заблокировать (выбранного в [candidates]); не вышло — «Нет соединения».
  Future<void> block(List<int> userID) async {
    if (!await PrivacyBlocks.setBlocked(userID, true) && !isClosed) {
      emit(state.copyWith(offlineNotice: state.offlineNotice + 1));
    }
  }

  /// Разблокировать; не вышло — «Нет соединения».
  /// `false` — не разблокировали (нет сети: экран покажет «Нет соединения»).
  Future<bool> unblock(BlockedUser user) async {
    final ok = await PrivacyBlocks.setBlocked(user.userID, false);
    if (!ok && !isClosed) emit(state.copyWith(offlineNotice: state.offlineNotice + 1));
    return ok;
  }

  @override
  Future<void> close() {
    _changes?.cancel();
    _profiles?.cancel();
    return super.close();
  }
}
