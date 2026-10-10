import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../chats/chats_data_source.dart';
import '../../chats/chats_remote_data_source.dart';
import '../../demo/chats_demo_data_source.dart';
import '../../models.dart' as models;

import 'chat_invites_state.dart';

/// Ссылки-приглашения (основная — заменить; дополнительные — создать,
/// изменить, отозвать; отозванные — удалить) и заявки на вступление (принять /
/// отклонить) для админа чата. Пока только UX-демо (см.
/// docs/plans/chats-groups-channels.md); на сервере это записи — им понадобится
/// гард `hasNetwork()`.
class ChatInvitesCubit extends Cubit<ChatInvitesState> {
  ChatInvitesCubit() : super(const ChatInvitesState());

  ChatsDataSource? _source;
  late String _chatID;
  final _subscriptions = <StreamSubscription<Object?>>[];

  void initialization({required String chatID, required bool demo}) {
    _chatID = chatID;
    _source = demo ? ChatsDemoDataSource.instance : ChatsRemoteDataSource.instance;
    final source = _source;
    if (source == null) {
      emit(state.copyWith(status: Status.success));
      return;
    }
    _subscriptions.addAll([
      source.watchChats().listen((chats) {
        if (!isClosed) emit(state.copyWith(chat: chats.where((c) => c.id == chatID).firstOrNull, status: Status.success));
      }),
      source.watchInviteLinks(chatID).listen((links) {
        if (!isClosed) emit(state.copyWith(links: links));
      }),
      source.watchJoinRequests(chatID).listen((requests) {
        if (!isClosed) emit(state.copyWith(requests: requests));
      }),
    ]);
  }

  Future<void> createLink({String title = '', DateTime? expireDate, int usageLimit = 0, bool requestApproval = false}) async => _source
      ?.createInviteLink(_chatID, title: title.trim(), expireDate: expireDate, usageLimit: usageLimit, requestApproval: requestApproval);

  Future<void> editLink(
    models.ChatInviteLink link, {
    required String title,
    DateTime? expireDate,
    required int usageLimit,
    required bool requestApproval,
  }) async => _source?.editInviteLink(
    _chatID,
    link.id,
    title: title.trim(),
    expireDate: expireDate,
    usageLimit: usageLimit,
    requestApproval: requestApproval,
  );

  /// Отозвать; основная — заменяется новой.
  Future<void> revokeLink(models.ChatInviteLink link) async => _source?.revokeInviteLink(_chatID, link.id);

  Future<void> deleteRevoked({models.ChatInviteLink? link}) async => _source?.deleteRevokedLinks(_chatID, linkID: link?.id ?? '');

  /// Принять / отклонить заявку ([request] `null` — все).
  Future<void> answer({models.ChatJoinRequest? request, required bool approve}) async =>
      _source?.answerJoinRequest(_chatID, userID: request?.userID ?? '', approve: approve);

  @override
  Future<void> close() async {
    for (final s in _subscriptions) {
      await s.cancel();
    }
    return super.close();
  }
}
