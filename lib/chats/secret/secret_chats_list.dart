import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../auth.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../peer_names.dart';
import '../../repositories.dart';
import '../../utils.dart';

/// Префикс id секретного чата в общем списке чатов (`secret:<hex>`): по нему
/// список открывает окно секретного чата, а не обычного.
const secretChatIDPrefix = 'secret:';

/// id строки списка для секретного чата.
String secretChatListID(List<int> secretChatID) => '$secretChatIDPrefix${getIt.get<Utils>().bytesToHex(Uint8List.fromList(secretChatID))}';

/// Статус для списка / шапки.
models.SecretChatStatus secretChatStatus(SecretChatLocalState state) => switch (state) {
  SecretChatLocalState.waiting || SecretChatLocalState.accepting || SecretChatLocalState.accepted => models.SecretChatStatus.waiting,
  SecretChatLocalState.committing || SecretChatLocalState.ready => models.SecretChatStatus.ready,
  SecretChatLocalState.discarded => models.SecretChatStatus.closed,
};

models.MessageStatus secretMessageStatus(SecretMessageStatus status) => switch (status) {
  SecretMessageStatus.pending => models.MessageStatus.pending,
  SecretMessageStatus.sent || SecretMessageStatus.unread => models.MessageStatus.sent,
  SecretMessageStatus.read => models.MessageStatus.read,
};

/// Секретные чаты этого устройства как строки общего списка чатов;
/// перечитываются при изменении таблиц.
Stream<List<models.Chat>> watchSecretChats() {
  final repositories = getIt.get<Repositories>();
  final utils = getIt.get<Utils>();
  late final StreamController<List<models.Chat>> out;
  StreamSubscription<void>? changes;
  var pending = Future<void>.value();

  Future<List<models.Chat>> load() async {
    final sessionID = getIt.get<Auth>().session.sessionID;
    if (sessionID.isEmpty) return const [];
    final records = await repositories.secretChats.chats(sessionID: sessionID);
    final names = <String, String>{};
    return [
      for (final record in records)
        models.Chat(
          id: secretChatListID(record.secretChatID),
          type: models.ChatType.private,
          title: names[utils.bytesToHex(record.peerUserID)] ??= await peerDisplayName(record.peerUserID),
          peerUserID: utils.bytesToHex(record.peerUserID),
          secretStatus: secretChatStatus(record.state),
          unreadCount: record.unreadCount,
          createdAt: record.createdAt,
          lastMessage: record.lastMessage == null
              ? null
              : models.ChatLastMessage(
                  text: record.lastMessage!.text,
                  outgoing: record.lastMessage!.outgoing,
                  status: secretMessageStatus(record.lastMessage!.status),
                  date: record.lastMessage!.date,
                ),
        ),
    ];
  }

  void reload() {
    pending = pending
        .then((_) async {
          final chats = await load();
          if (!out.isClosed) out.add(chats);
        })
        .catchError((Object error, StackTrace stackTrace) => getIt.get<Logger>().handle(error, stackTrace));
  }

  out = StreamController<List<models.Chat>>(
    onListen: () {
      changes = repositories.db.onChange(SecretChatsRepository.tables).listen((_) => reload());
    },
    onCancel: () => changes?.cancel(),
  );
  return out.stream;
}
