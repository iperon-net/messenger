import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import '../models.dart' as models;
import '../protobuf/protos/chats_v1.pb.dart' as pb;

/// Маппинг «сервер (chats_v1.proto) → клиентские модели» и обратно для
/// [ChatsRemoteDataSource]: экраны работают с теми же `Chat`/`Message`, что
/// и в демо. Чистые функции без БД и сети — их проверяют тесты.

/// ObjectID (12 байт) → строковый id клиента (hex в нижнем регистре).
String idHex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

/// Обратно к [idHex]. Не hex (например, `local:…` у сообщения из outbox) —
/// пустой массив.
Uint8List idBytes(String hex) {
  if (hex.length.isOdd || !RegExp(r'^[0-9a-fA-F]*$').hasMatch(hex)) return Uint8List(0);
  return Uint8List.fromList([for (var i = 0; i < hex.length; i += 2) int.parse(hex.substring(i, i + 2), radix: 16)]);
}

/// id отложенного, принятого сервером: `scheduled:<scheduledID>`.
const scheduledMessagePrefix = 'scheduled:';

String scheduledMessageID(int scheduledID) => '$scheduledMessagePrefix$scheduledID';

/// scheduledID по id отложенного; `null` — не с сервера (из outbox).
int? scheduledIDOf(String messageID) =>
    messageID.startsWith(scheduledMessagePrefix) ? int.tryParse(messageID.substring(scheduledMessagePrefix.length)) : null;

/// id сообщения из outbox (ещё не дошло до сервера): `local:<randomID>`.
const localMessagePrefix = 'local:';

String localMessageID(int randomID) => '$localMessagePrefix$randomID';

/// randomID сообщения из outbox по его id; `null` — сообщение с сервера.
int? randomIDOfLocal(String messageID) =>
    messageID.startsWith(localMessagePrefix) ? int.tryParse(messageID.substring(localMessagePrefix.length)) : null;

/// `messageID` сервера по id клиента; `null` — не серверное (outbox).
int? serverMessageID(String messageID) => messageID.startsWith(localMessagePrefix) ? null : int.tryParse(messageID);

/// «Навсегда» у `Dialog.mutedUntil` — max int64.
final int mutedForever = Int64.MAX_VALUE.toInt();

/// Даты дальше этой — «навсегда» (у `DateTime` есть предел, max int64 в него не
/// влезает).
const _maxDateMillis = 8640000000000000;

/// `Dialog.mutedUntil` → `Chat.muted` / `Chat.mutedUntil` (`null` при muted —
/// навсегда). Срок истёк — уведомления снова включены.
({bool muted, DateTime? until}) mutedFromPb(int mutedUntil, DateTime now) {
  if (mutedUntil <= 0) return (muted: false, until: null);
  if (mutedUntil >= _maxDateMillis) return (muted: true, until: null);
  final until = DateTime.fromMillisecondsSinceEpoch(mutedUntil);
  return until.isAfter(now) ? (muted: true, until: until) : (muted: false, until: null);
}

/// Обратно: [until] `null` — навсегда.
int mutedToPb(bool muted, DateTime? until) => !muted ? 0 : (until?.millisecondsSinceEpoch ?? mutedForever);

models.MessageEntity entityFromPb(pb.MessageEntity e) {
  final types = models.MessageEntityType.values;
  return models.MessageEntity(
    type: e.type.value < types.length ? types[e.type.value] : models.MessageEntityType.bold,
    offset: e.offset,
    length: e.length,
    url: e.url,
    userID: e.userID.isEmpty ? '' : idHex(e.userID),
    expandable: e.expandable,
  );
}

/// Порядок `MessageEntityType` совпадает с `MessageEntity.Type` в proto.
pb.MessageEntity entityToPb(models.MessageEntity e) => pb.MessageEntity(
  type: pb.MessageEntity_Type.valueOf(e.type.index),
  offset: e.offset,
  length: e.length,
  url: e.url,
  userID: e.userID.isEmpty ? null : idBytes(e.userID),
  expandable: e.expandable,
);

models.MessageKind kindFromPb(pb.MessageKind kind) => switch (kind) {
  pb.MessageKind.MESSAGE_KIND_PHOTO => models.MessageKind.photo,
  pb.MessageKind.MESSAGE_KIND_VIDEO => models.MessageKind.video,
  pb.MessageKind.MESSAGE_KIND_FILE => models.MessageKind.file,
  pb.MessageKind.MESSAGE_KIND_VOICE => models.MessageKind.voice,
  pb.MessageKind.MESSAGE_KIND_POLL => models.MessageKind.poll,
  _ => models.MessageKind.text,
};

/// Вид сообщения по содержимому: первое вложение задаёт вид (альбом — по
/// первому элементу), без вложений — текст.
models.MessageKind contentKind(pb.MessageContent content) {
  if (content.hasCall()) return models.MessageKind.call;
  return content.media.isEmpty ? models.MessageKind.text : kindFromPb(content.media.first.kind);
}

/// Звонок из содержимого (`null` — не звонок).
models.MessageCall? callFromPb(pb.MessageContent content) {
  if (!content.hasCall()) return null;
  final call = content.call;
  final outcome = call.outcome.value;
  return models.MessageCall(
    video: call.video,
    outcome: outcome < models.CallOutcome.values.length ? models.CallOutcome.values[outcome] : models.CallOutcome.ended,
    duration: call.duration,
  );
}

/// Входящее, которое не считается непрочитанным: звонок, кроме пропущенного,
/// и «закрепил сообщение» (как на сервере, `noUnread`).
bool skipsUnread(pb.MessageContent content) => content.hasPin() || (content.hasCall() && callFromPb(content)?.unanswered != true);

/// Текст закреплённого для «закрепил «…»»: подпись / текст, у файла — имя,
/// у остального — пусто (тогда подпись вида — на стороне экрана).
String pinSnippet(pb.ChatMessage? pinned) {
  if (pinned == null) return '';
  final content = pinned.content;
  var text = content.text;
  if (text.isEmpty && content.media.isNotEmpty && content.media.first.kind == pb.MessageKind.MESSAGE_KIND_FILE) {
    text = content.media.first.fileName;
  }
  text = text.replaceAll('\n', ' ');
  return text.length > 30 ? '${text.substring(0, 30).trimRight()}…' : text;
}

/// Реакции сервера (кто, чем, когда — от ранних к поздним) → чипы под
/// сообщением: по эмодзи в порядке первой постановки, с числом; наши —
/// [models.MessageReaction.chosen] с порядком нашей постановки.
List<models.MessageReaction> reactionsFromPb(pb.MessageReactions reactions, {required List<int> myUserID}) {
  final chips = <String, models.MessageReaction>{};
  var mine = 0;
  for (final r in reactions.reactions) {
    final chosen = sameID(r.userID, myUserID);
    final chip = chips[r.emoji] ?? models.MessageReaction(emoji: r.emoji, count: 0);
    chips[r.emoji] = chip.copyWith(count: chip.count + 1, chosen: chip.chosen || chosen, chosenOrder: chosen ? ++mine : chip.chosenOrder);
  }
  return chips.values.toList(growable: false);
}

/// ✓ / ✓✓ исходящего: прочитано, если собеседник дочитал до него
/// (`readOutboxMaxID`). В «Избранном» читать некому — всегда прочитано.
models.MessageStatus outgoingStatus({required int messageID, required int readOutboxMaxID, required bool isSelf}) =>
    isSelf || messageID <= readOutboxMaxID ? models.MessageStatus.read : models.MessageStatus.sent;

/// Сообщение сервера → `Message`. [replied] — сообщение, на которое ответили
/// (если есть в локальном кэше), [peerName] — имя собеседника (автор входящих в
/// личном чате).
models.Message messageFromPb(
  pb.ChatMessage m, {
  required String chatID,
  required List<int> myUserID,
  required int readOutboxMaxID,
  required bool isSelf,
  pb.ChatMessage? replied,
  String peerName = '',
  bool pinned = false,
  bool pinnedOnlyMe = false,
}) {
  final outgoing = sameID(m.fromUserID, myUserID);
  final content = m.content;
  final kind = contentKind(content);
  final first = content.media.isEmpty ? null : content.media.first;
  return models.Message(
    id: m.messageID.toString(),
    chatID: chatID,
    kind: kind,
    // «Закрепил сообщение» — служебная плашка (тап — к закреплённому).
    service: content.hasPin(),
    pinnedMessageID: content.hasPin() ? content.pin.messageID.toString() : '',
    senderName: content.hasPin() && !outgoing ? peerName : '',
    pinned: pinned,
    pinnedOnlyMe: pinned && pinnedOnlyMe,
    text: content.text,
    entities: [for (final e in content.entities) entityFromPb(e)],
    outgoing: outgoing,
    status: outgoing
        ? outgoingStatus(messageID: m.messageID.toInt(), readOutboxMaxID: readOutboxMaxID, isSelf: isSelf)
        : models.MessageStatus.read,
    date: DateTime.fromMillisecondsSinceEpoch(m.date.toInt()),
    edited: m.editDate > 0,
    reply: content.hasReplyTo() ? replyFromPb(content.replyTo, replied: replied, myUserID: myUserID, peerName: peerName) : null,
    fileName: first?.fileName ?? '',
    fileSize: first?.size.toInt() ?? 0,
    duration: first?.duration ?? 0,
    // Волна в proto — 0..255, в модели — 0..31 (5 бит, как в Telegram).
    waveform: [for (final v in first?.waveform ?? const <int>[]) v >> 3],
    mediaUnread: m.mediaUnread,
    reactionsUnread: outgoing && m.reactionsUnread,
    media: [
      if (kind == models.MessageKind.photo || kind == models.MessageKind.video)
        for (final media in content.media)
          models.MessageMedia(
            kind: kindFromPb(media.kind),
            width: media.width,
            height: media.height,
            size: media.size.toInt(),
            thumbhash: media.thumbhash,
            spoiler: media.spoiler,
            duration: media.duration,
          ),
    ],
    forward: content.hasForward() ? forwardFromPb(content.forward, myUserID: myUserID) : null,
    silent: m.silent,
    phoneCall: callFromPb(content),
    reactions: m.hasReactions() ? reactionsFromPb(m.reactions, myUserID: myUserID) : const [],
  );
}

/// Ответ: текст исходного — из кэша (нет в кэше — без текста, только цитата).
models.MessageReply replyFromPb(pb.MessageReplyTo r, {pb.ChatMessage? replied, required List<int> myUserID, String peerName = ''}) {
  final outgoing = replied != null && sameID(replied.fromUserID, myUserID);
  final repliedContent = replied?.content;
  final kind = repliedContent == null ? models.MessageKind.text : contentKind(repliedContent);
  final fileName = repliedContent != null && repliedContent.media.isNotEmpty ? repliedContent.media.first.fileName : '';
  final text = repliedContent?.text ?? '';
  return models.MessageReply(
    messageID: r.messageID.toString(),
    // Как в ChatCubit._takeReply: у своего — пусто («Вы»), у входящего в
    // личном чате — имя собеседника.
    senderName: outgoing || replied == null ? '' : peerName,
    text: kind == models.MessageKind.file && text.isEmpty ? fileName : text,
    kind: kind,
    quote: r.quoteText.isEmpty
        ? null
        : models.MessageQuote(text: r.quoteText, entities: [for (final e in r.quoteEntities) entityFromPb(e)], offset: r.quoteOffset),
  );
}

/// Без fromUserID — автор запретил ссылку на аккаунт при пересылке.
models.MessageForward forwardFromPb(pb.MessageForward f, {required List<int> myUserID}) {
  final self = f.fromUserID.isNotEmpty && sameID(f.fromUserID, myUserID);
  return models.MessageForward(
    name: f.fromName,
    self: self,
    userID: f.fromUserID.isEmpty || self ? '' : idHex(f.fromUserID),
    hidden: f.fromUserID.isEmpty,
  );
}

/// Содержимое отправляемого текстового сообщения. [reply] — id исходного (с
/// цитатой, если отвечают на фрагмент).
pb.MessageContent textContent({
  required String text,
  List<models.MessageEntity> entities = const [],
  models.MessageReply? reply,
  bool linkPreview = true,
}) {
  final replyID = reply == null ? null : serverMessageID(reply.messageID);
  final quote = reply?.quote;
  return pb.MessageContent(
    text: text,
    entities: [for (final e in entities) entityToPb(e)],
    replyTo: replyID == null
        ? null
        : pb.MessageReplyTo(
            messageID: Int64(replyID),
            quoteText: quote?.text,
            quoteEntities: quote == null ? null : [for (final e in quote.entities) entityToPb(e)],
            quoteOffset: quote?.offset,
          ),
    noLinkPreview: linkPreview ? null : true,
  );
}

/// Последнее сообщение для строки списка чатов. [pinned] — закреплённое
/// (у служебного «закрепил сообщение», если есть в кэше).
models.ChatLastMessage lastMessageFromPb(
  pb.ChatMessage m, {
  required List<int> myUserID,
  required int readOutboxMaxID,
  required bool isSelf,
  pb.ChatMessage? pinned,
}) {
  final outgoing = sameID(m.fromUserID, myUserID);
  return models.ChatLastMessage(
    kind: contentKind(m.content),
    text: m.content.text,
    outgoing: outgoing,
    status: outgoing
        ? outgoingStatus(messageID: m.messageID.toInt(), readOutboxMaxID: readOutboxMaxID, isSelf: isSelf)
        : models.MessageStatus.read,
    date: DateTime.fromMillisecondsSinceEpoch(m.date.toInt()),
    phoneCall: callFromPb(m.content),
    pin: m.content.hasPin(),
    pinText: m.content.hasPin() ? pinSnippet(pinned) : '',
  );
}

/// Один ли это ObjectID (userID / chatID).
bool sameID(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// id «Все чаты» — у сервера её нет, у клиента всегда первая.
const allChatsFolderID = 'all';

/// Папки с сервера (снимок `ChatFolders`) → список экранов: «Все чаты»
/// первой, затем мои по порядку (id папки — номер с сервера строкой).
List<models.ChatFolder> foldersFromPb(pb.ChatFolders? folders) => [
  const models.ChatFolder(id: allChatsFolderID, isAll: true),
  for (final f in folders?.folders ?? const <pb.ChatFolder>[])
    models.ChatFolder(
      id: '${f.id}',
      title: f.title,
      includeContacts: f.includeContacts,
      includeNonContacts: f.includeNonContacts,
      includeGroups: f.includeGroups,
      includeChannels: f.includeChannels,
      includeCommunities: f.includeCommunities,
      includeChatIDs: [for (final id in f.includeChatIDs) idHex(id)],
      excludeChatIDs: [for (final id in f.excludeChatIDs) idHex(id)],
      excludeMuted: f.excludeMuted,
      excludeRead: f.excludeRead,
    ),
];

/// Номер папки на сервере; новая (id ещё локальный) — 0.
int folderIDToPb(String id) => int.tryParse(id) ?? 0;

/// Папка для `SaveFolder`. Чаты, которых ещё нет на сервере (не ObjectID), —
/// не уходят.
pb.ChatFolder folderToPb(models.ChatFolder folder) {
  List<List<int>> ids(List<String> chatIDs) => [
    for (final id in chatIDs)
      if (idBytes(id) case final bytes when bytes.length == 12) bytes,
  ];
  return pb.ChatFolder(
    id: folderIDToPb(folder.id),
    title: folder.title,
    includeContacts: folder.includeContacts,
    includeNonContacts: folder.includeNonContacts,
    includeGroups: folder.includeGroups,
    includeChannels: folder.includeChannels,
    includeCommunities: folder.includeCommunities,
    includeChatIDs: ids(folder.includeChatIDs),
    excludeChatIDs: ids(folder.excludeChatIDs),
    excludeMuted: folder.excludeMuted,
    excludeRead: folder.excludeRead,
  );
}
