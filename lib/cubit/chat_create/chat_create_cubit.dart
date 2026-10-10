import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../chats/chats_data_source.dart';
import '../../chats/invite_link.dart';
import '../../chats/chats_remote_data_source.dart';
import '../../chats/chats_sync.dart';
import '../../models.dart' as models;

import 'chat_create_state.dart';

/// «Новое»: личный чат с контактом, новая группа (участники → название),
/// канал и сообщество (название, описание, фото, публичный/частный). Пока
/// работает только в UX-демо (см. docs/plans/chats-groups-channels.md); на
/// сервере создание потребует сети — тогда сюда добавится гард `hasNetwork()`.
class ChatCreateCubit extends Cubit<ChatCreateState> {
  ChatCreateCubit() : super(const ChatCreateState());

  ChatsDataSource? _source;
  Timer? _usernameTimer;

  /// Публичное имя — как у профиля (`SettingsMyProfileUsernameCubit`): одно
  /// пространство имён на пользователей и чаты.
  static final RegExp usernamePattern = RegExp(r'^[a-z0-9_]{5,24}$');

  static const titleMaxLength = 128;
  static const aboutMaxLength = 255;

  /// [type] — что создаём; [selected] — участники, выбранные на прошлом шаге
  /// (форма группы); [exclude] — кого не показывать в контактах;
  /// [communityID] — создаём внутри сообщества (по умолчанию вступление одним
  /// нажатием).
  Future<void> initialization({
    required bool demo,
    models.ChatType type = models.ChatType.private,
    List<models.ChatMember> selected = const [],
    Set<String> exclude = const {},
    String communityID = '',
  }) async {
    _source = chatsDataSource(demo: demo);
    emit(
      state.copyWith(
        status: Status.loading,
        type: type,
        selected: selected,
        inviteLink: newInviteCode(),
        communityID: communityID,
        joinMode: communityID.isNotEmpty ? models.ChatJoinMode.open : state.joinMode,
      ),
    );
    // [exclude] — уже участники («Добавить участников» в профиле группы).
    final contacts = [
      for (final c in await _source?.contacts() ?? const <models.ChatMember>[])
        if (!exclude.contains(c.id)) c,
    ];
    if (isClosed) return;
    emit(state.copyWith(status: Status.success, contacts: contacts));
  }

  /// Форма «Изменить» для [chat] (профиль чата, админ): поля — из чата.
  void edit({required bool demo, required models.Chat chat}) {
    _source = chatsDataSource(demo: demo);
    emit(
      state.copyWith(
        status: Status.success,
        type: chat.type,
        chatID: chat.id,
        communityID: chat.communityID,
        title: chat.title,
        about: chat.about,
        avatarPath: chat.avatarPath,
        coverPath: chat.coverPath,
        phone: chat.phone,
        address: chat.address,
        latitude: chat.latitude?.toString() ?? '',
        longitude: chat.longitude?.toString() ?? '',
        joinMode: chat.joinMode,
        username: chat.username,
        originalUsername: chat.username,
        usernameStatus: chat.username.isEmpty ? ChatUsernameStatus.empty : ChatUsernameStatus.available,
        inviteLink: chat.inviteLink.isNotEmpty ? chat.inviteLink : newInviteCode(),
        defaultRole: chat.defaultRole,
        commentsEnabled: chat.commentsEnabled,
        commentsTimeLimit: chat.commentsTimeLimit,
        commentsWho: chat.commentsWho,
        commentsMinSubscription: chat.commentsMinSubscription,
        newcomerMediaDelay: chat.newcomerMediaDelay,
        signMessages: chat.signMessages,
        membersHidden: chat.membersHidden,
      ),
    );
  }

  void search(String query) => emit(state.copyWith(query: query));

  void toggle(models.ChatMember member) {
    final selected = state.isSelected(member) ? state.selected.where((m) => m.id != member.id).toList() : [...state.selected, member];
    emit(state.copyWith(selected: selected));
  }

  void setAvatar(String path) => emit(state.copyWith(avatarPath: path));

  void setCover(String path) => emit(state.copyWith(coverPath: path));

  void setPhone(String value) => emit(state.copyWith(phone: value.trim()));

  void setAddress(String value) => emit(state.copyWith(address: value.trim()));

  void setLatitude(String value) => emit(state.copyWith(latitude: value));

  void setLongitude(String value) => emit(state.copyWith(longitude: value));

  void setPublic(bool isPublic) => setJoinMode(isPublic ? models.ChatJoinMode.open : models.ChatJoinMode.link);

  void setJoinMode(models.ChatJoinMode mode) {
    emit(state.copyWith(joinMode: mode));
    if (mode == models.ChatJoinMode.open) setUsername(state.username);
  }

  void setDefaultRole(models.ChatRole role) => emit(state.copyWith(defaultRole: role));

  void setCommentsEnabled(bool enabled) => emit(state.copyWith(commentsEnabled: enabled));

  void setCommentsTimeLimit(int seconds) => emit(state.copyWith(commentsTimeLimit: seconds));

  void setCommentsWho(models.ChatCommentsWho who) => emit(state.copyWith(commentsWho: who));

  void setCommentsMinSubscription(int seconds) => emit(state.copyWith(commentsMinSubscription: seconds));

  void setNewcomerMediaDelay(int seconds) => emit(state.copyWith(newcomerMediaDelay: seconds));

  void setSignMessages(bool enabled) => emit(state.copyWith(signMessages: enabled));

  void setMembersHidden(bool hidden) => emit(state.copyWith(membersHidden: hidden));

  /// Ввод публичного имени: формат сразу, занятость — с паузой (как запрос к
  /// серверу на каждую букву не шлём).
  void setUsername(String value) {
    final username = value.trim().toLowerCase();
    _usernameTimer?.cancel();
    if (username.isEmpty) {
      emit(state.copyWith(username: username, usernameStatus: ChatUsernameStatus.empty));
      return;
    }
    if (!usernamePattern.hasMatch(username)) {
      emit(state.copyWith(username: username, usernameStatus: ChatUsernameStatus.invalid));
      return;
    }
    if (state.isEdit && username == state.originalUsername) {
      emit(state.copyWith(username: username, usernameStatus: ChatUsernameStatus.available));
      return;
    }
    emit(state.copyWith(username: username, usernameStatus: ChatUsernameStatus.checking));
    _usernameTimer = Timer(const Duration(milliseconds: 400), () async {
      final available = await _source?.isUsernameAvailable(username, exceptChatID: state.chatID) ?? false;
      // Пока проверяли, имя могли поменять — ответ уже не про него.
      if (isClosed || state.username != username) return;
      emit(state.copyWith(usernameStatus: available ? ChatUsernameStatus.available : ChatUsernameStatus.taken));
    });
  }

  /// «Новое сообщение» → контакт: существующий личный чат или новый.
  Future<void> openPrivateChat(models.ChatMember contact) async {
    final source = _source;
    if (source == null) return;
    var chatID = '';
    // Новый личный чат создаёт сервер — без сети «Нет соединения».
    await _online(() async => chatID = await source.openPrivateChat(contact.id));
    if (!isClosed && chatID.isNotEmpty) emit(state.copyWith(openChatID: chatID));
  }

  /// Серверное действие без сети: не делаем вид, что получилось, — экран
  /// покажет «Нет соединения» (см. `offlineNotice`). false — не выполнено.
  Future<bool> _online(Future<void>? Function() action) async {
    try {
      await action();
      return true;
    } on ChatsOfflineException {
      if (!isClosed) emit(state.copyWith(offlineNotice: state.offlineNotice + 1));
      return false;
    }
  }

  Future<void> create({required String title, String about = ''}) async {
    final source = _source;
    if (source == null || state.creating || title.trim().isEmpty || !state.linkReady) return;
    emit(state.copyWith(creating: true));
    final chatID = await source.createChat(
      type: state.type,
      title: title.trim(),
      about: about.trim(),
      memberIDs: [for (final m in state.selected) m.id],
      username: state.isPublic ? state.username : '',
      inviteLink: state.inviteLink,
      avatarPath: state.avatarPath,
      communityID: state.communityID,
      joinMode: state.joinMode,
    );
    if (!isClosed) emit(state.copyWith(creating: false, openChatID: chatID));
  }

  /// «Изменить» → «Сохранить».
  Future<void> save({required String title, required String about}) async {
    final source = _source;
    if (source == null || state.creating || !state.isEdit || title.trim().isEmpty || !state.linkReady || !state.coordinatesValid) return;
    emit(state.copyWith(creating: true));
    await source.updateChat(
      state.chatID,
      title: title.trim(),
      about: about.trim(),
      avatarPath: state.avatarPath,
      coverPath: state.coverPath,
      phone: state.phone,
      address: state.address,
      latitude: state.latitudeValue,
      longitude: state.longitudeValue,
      joinMode: state.joinMode,
      username: state.isPublic ? state.username : '',
      inviteLink: state.inviteLink,
      defaultRole: state.defaultRole,
      commentsEnabled: state.commentsEnabled,
      commentsTimeLimit: state.commentsTimeLimit,
      commentsWho: state.commentsWho,
      commentsMinSubscription: state.commentsMinSubscription,
      newcomerMediaDelay: state.newcomerMediaDelay,
      signMessages: state.signMessages,
      membersHidden: state.membersHidden,
    );
    if (!isClosed) emit(state.copyWith(creating: false, saved: true));
  }

  @override
  Future<void> close() {
    _usernameTimer?.cancel();
    return super.close();
  }
}
