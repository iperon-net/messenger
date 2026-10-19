import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grpc/grpc.dart' show StatusCode;

import '../../constants.dart';
import '../../chats/chats_data_source.dart';
import '../../chats/chats_remote_data_source.dart';
import '../../chats/chats_sync.dart';
import '../../models.dart' as models;

import 'chat_invites_state.dart';

/// Ссылки-приглашения (основная — заменить; дополнительные — создать,
/// изменить, отозвать; отозванные — удалить) и заявки на вступление (принять /
/// отклонить) для владельца и админов с правом приглашать. На сервере (подэтап
/// 3.3) это записи: без сети — «Нет соединения» ([ChatInvitesState.offlineNotice]),
/// отказ — пояснение ([ChatInvitesState.failNotice]); ничего не меняем
/// «понарошку». Ссылки видны из кэша и без сети; заявки — только с сервера:
/// не загрузились — [ChatInvitesState.requestsFailed], а не «заявок нет».
class ChatInvitesCubit extends Cubit<ChatInvitesState> {
  ChatInvitesCubit() : super(const ChatInvitesState());

  ChatsDataSource? _source;
  late String _chatID;
  final _subscriptions = <StreamSubscription<Object?>>[];
  StreamSubscription<List<models.ChatJoinRequest>>? _requestsSubscription;

  void initialization({required String chatID, required bool demo}) {
    _chatID = chatID;
    _source = chatsDataSource(demo: demo);
    final source = _source;
    if (source == null) {
      emit(state.copyWith(status: Status.success));
      return;
    }
    emit(state.copyWith(deletesRevokedSingly: source.deletesRevokedLinkSingly));
    _subscriptions.addAll([
      source.watchChats().listen((chats) {
        if (!isClosed) emit(state.copyWith(chat: chats.where((c) => c.id == chatID).firstOrNull, status: Status.success));
      }),
      source.watchInviteLinks(chatID).listen((links) {
        if (!isClosed) emit(state.copyWith(links: links));
      }),
    ]);
    _watchRequests();
  }

  void _watchRequests() {
    final source = _source;
    if (source == null) return;
    unawaited(_requestsSubscription?.cancel());
    emit(state.copyWith(requestsLoading: true));
    _requestsSubscription = source
        .watchJoinRequests(_chatID)
        .listen(
          (requests) {
            if (!isClosed) emit(state.copyWith(requests: requests, requestsLoading: false, requestsFailed: false));
          },
          // Не загрузились — прежний список (если был) и пометка, не пустота.
          onError: (Object _) {
            if (!isClosed) emit(state.copyWith(requestsLoading: false, requestsFailed: true));
          },
        );
  }

  /// «Повторить» на экране заявок.
  void retryRequests() => _watchRequests();

  /// Серверное действие: без сети — «Нет соединения», лимит частоты и отказ —
  /// пояснение. false — не выполнено.
  Future<bool> _action(Future<void>? Function() action) async {
    try {
      await action();
      return true;
    } on ChatsOfflineException {
      if (!isClosed) emit(state.copyWith(offlineNotice: state.offlineNotice + 1));
    } on ChatsFloodException {
      if (!isClosed) emit(state.copyWith(failNotice: state.failNotice + 1, failError: ''));
    } on ChatsRequestException catch (error) {
      final key = error.statusCode == StatusCode.permissionDenied && error.error != 'banned' ? 'permissionDenied' : error.error;
      if (!isClosed) emit(state.copyWith(failNotice: state.failNotice + 1, failError: key));
    }
    return false;
  }

  Future<bool> createLink({String title = '', DateTime? expireDate, int usageLimit = 0, bool requestApproval = false}) => _action(
    () => _source?.createInviteLink(
      _chatID,
      title: title.trim(),
      expireDate: expireDate,
      usageLimit: usageLimit,
      requestApproval: requestApproval,
    ),
  );

  Future<bool> editLink(
    models.ChatInviteLink link, {
    required String title,
    DateTime? expireDate,
    required int usageLimit,
    required bool requestApproval,
  }) => _action(
    () => _source?.editInviteLink(
      _chatID,
      link.id,
      title: title.trim(),
      expireDate: expireDate,
      usageLimit: usageLimit,
      requestApproval: requestApproval,
    ),
  );

  /// Отозвать; основная — заменяется новой.
  Future<bool> revokeLink(models.ChatInviteLink link) => _action(() => _source?.revokeInviteLink(_chatID, link.id));

  /// Удалить отозванную [link] (`null` — все; сервер удаляет только все сразу,
  /// см. [ChatInvitesState.deletesRevokedSingly]).
  Future<bool> deleteRevoked({models.ChatInviteLink? link}) =>
      _action(() => _source?.deleteRevokedLinks(_chatID, linkID: state.deletesRevokedSingly ? link?.id ?? '' : ''));

  /// Принять / отклонить заявку ([request] `null` — все).
  Future<bool> answer({models.ChatJoinRequest? request, required bool approve}) =>
      _action(() => _source?.answerJoinRequest(_chatID, userID: request?.userID ?? '', approve: approve));

  @override
  Future<void> close() async {
    for (final s in _subscriptions) {
      await s.cancel();
    }
    await _requestsSubscription?.cancel();
    return super.close();
  }
}
