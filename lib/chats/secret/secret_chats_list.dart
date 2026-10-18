import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../auth.dart';
import '../../cdn.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../peer_names.dart';
import '../../repositories.dart';
import '../../utils.dart';
import 'secret_chats_sync.dart';

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
  SecretMessageStatus.failed => models.MessageStatus.failed,
};

/// Тип сообщения для ленты и превью в списке.
models.MessageKind secretMessageKind(SecretMessageKind kind) => switch (kind) {
  SecretMessageKind.text => models.MessageKind.text,
  SecretMessageKind.photo => models.MessageKind.photo,
  SecretMessageKind.video => models.MessageKind.video,
  SecretMessageKind.file => models.MessageKind.file,
  SecretMessageKind.voice => models.MessageKind.voice,
  SecretMessageKind.ttlChange || SecretMessageKind.screenshot => models.MessageKind.text,
};

/// Длительность таймера самоуничтожения: «Выкл», «5 секунд», «1 час»…
String secretTtlLabel(Translations t, int seconds) {
  final ts = t.secretChat;
  if (seconds <= 0) return ts.ttlOff;
  if (seconds % 604800 == 0) return ts.ttlWeeks(n: seconds ~/ 604800);
  if (seconds % 86400 == 0) return ts.ttlDays(n: seconds ~/ 86400);
  if (seconds % 3600 == 0) return ts.ttlHours(n: seconds ~/ 3600);
  if (seconds % 60 == 0) return ts.ttlMinutes(n: seconds ~/ 60);
  return ts.ttlSeconds(n: seconds);
}

/// Текст служебного сообщения («Вы установили таймер…», «Анна сделала
/// скриншот»); [name] — собеседник. Пусто — не служебное.
String secretServiceText(Translations t, SecretMessageRecord message, String name) {
  final ts = t.secretChat;
  switch (message.kind) {
    case SecretMessageKind.ttlChange:
      final period = secretTtlLabel(t, message.ttl);
      if (message.outgoing) return message.ttl > 0 ? ts.ttlServiceYou(period: period) : ts.ttlServiceYouOff;
      return message.ttl > 0 ? ts.ttlService(name: name, period: period) : ts.ttlServiceOff(name: name);
    case SecretMessageKind.screenshot:
      return message.outgoing ? ts.screenshotYou : ts.screenshot(name: name);
    default:
      return '';
  }
}

/// Фото собеседника из кэша профилей (как в обычных чатах); пусто — нет.
Future<String> secretPeerAvatar(List<int> peerUserID) async {
  try {
    final profile = await getIt.get<Repositories>().profiles.getByUserID(userID: peerUserID);
    final cdnID = profile.avatarCdnID;
    if (cdnID == null || cdnID.isEmpty) return '';
    return (await getIt.get<CDNManager>().cachedFile(Uint8List.fromList(cdnID)))?.path ?? '';
  } catch (error, stackTrace) {
    getIt.get<Logger>().handle(error, stackTrace);
    return '';
  }
}

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
    final t = LocaleSettings.instance.currentTranslations;
    return [
      for (final record in records)
        models.Chat(
          id: secretChatListID(record.secretChatID),
          type: models.ChatType.private,
          title: names[utils.bytesToHex(record.peerUserID)] ??= await peerDisplayName(record.peerUserID),
          avatarPath: await secretPeerAvatar(record.peerUserID),
          ttlPeriod: record.ttl,
          peerUserID: utils.bytesToHex(record.peerUserID),
          secretStatus: secretChatStatus(record.state),
          unreadCount: record.unreadCount,
          createdAt: record.createdAt,
          lastMessage: record.lastMessage == null
              ? null
              : models.ChatLastMessage(
                  kind: secretMessageKind(record.lastMessage!.kind),
                  text: record.lastMessage!.kind.isService
                      ? secretServiceText(t, record.lastMessage!, names[utils.bytesToHex(record.peerUserID)] ?? '')
                      : record.lastMessage!.text,
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
      // Истёкшее (таймер самоуничтожения) за время, пока приложение было
      // закрыто, — убрать и без сети; дальше таймер заводит SecretChatsSync.
      unawaited(SecretChatsSync.instance.expireNow());
    },
    onCancel: () => changes?.cancel(),
  );
  return out.stream;
}
