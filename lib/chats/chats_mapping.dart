import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import '../i18n/translations.g.dart';
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

/// Служебное от сервера (плашка по центру ленты): закреп, автоудаление,
/// защита содержимого и запрос её снять.
bool _isPrivateService(pb.MessageContent content) =>
    content.hasPin() || content.hasTtlChanged() || content.hasNoForwards() || content.hasNoForwardsRequest();

/// Плюс служебные группы («создал группу», «добавил …», «вышел» …).
bool _isService(pb.MessageContent content) => _isPrivateService(content) || content.hasChatAction();

/// Входящее, которое не считается непрочитанным: звонок, кроме пропущенного,
/// служебные («закрепил сообщение», группы: «создал», «добавил», «вышел» …) —
/// как на сервере (`noUnread`), иначе счётчик разойдётся с серверным.
bool skipsUnread(pb.MessageContent content) => _isService(content) || (content.hasCall() && callFromPb(content)?.unanswered != true);

/// Текст служебного группы ([pb.MessageChatAction]) — плашка в ленте и превью
/// в списке. [outgoing] — сделал я («Вы …»), [actor] — имя сделавшего,
/// [names] — имена тех, кого добавили / исключили (меня — «вас»).
String chatActionText(
  Translations t,
  pb.MessageChatAction action, {
  required bool outgoing,
  required String actor,
  List<String> names = const [],
}) {
  final a = t.chatAction;
  final who = names.join(', ');
  return switch (action.kind) {
    pb.MessageChatAction_Kind.CREATED => outgoing ? a.createdYou(title: action.title) : a.created(name: actor, title: action.title),
    pb.MessageChatAction_Kind.ADDED => outgoing ? a.addedYou(names: who) : a.added(name: actor, names: who),
    pb.MessageChatAction_Kind.JOINED => outgoing ? a.joinedYou : a.joined(name: actor),
    pb.MessageChatAction_Kind.LEFT => outgoing ? a.leftYou : a.left(name: actor),
    pb.MessageChatAction_Kind.REMOVED => outgoing ? a.removedYou(names: who) : a.removed(name: actor, names: who),
    pb.MessageChatAction_Kind.TITLE_CHANGED => outgoing ? a.titleYou(title: action.title) : a.title(name: actor, title: action.title),
    pb.MessageChatAction_Kind.PHOTO_CHANGED => outgoing ? a.photoYou : a.photo(name: actor),
    pb.MessageChatAction_Kind.PHOTO_REMOVED => outgoing ? a.photoRemovedYou : a.photoRemoved(name: actor),
    pb.MessageChatAction_Kind.OWNER_CHANGED => outgoing ? a.ownerYou(names: who) : a.owner(name: actor, names: who),
    _ => '',
  };
}

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
/// личном чате). Группа — [nameOf]: имя участника по userID (автор и ответ),
/// [serviceText] — текст служебного группы (см. [chatActionText]).
models.Message messageFromPb(
  pb.ChatMessage m, {
  required String chatID,
  required List<int> myUserID,
  required int readOutboxMaxID,
  required bool isSelf,
  pb.ChatMessage? replied,
  String peerName = '',
  String Function(List<int> userID)? nameOf,
  String serviceText = '',
  bool pinned = false,
  bool pinnedOnlyMe = false,
}) {
  final outgoing = sameID(m.fromUserID, myUserID);
  final group = nameOf != null;
  final content = m.content;
  final kind = contentKind(content);
  final first = content.media.isEmpty ? null : content.media.first;
  return models.Message(
    id: m.messageID.toString(),
    chatID: chatID,
    kind: kind,
    // «Закрепил сообщение» / «изменил автоудаление» — служебная плашка (тап по
    // закрепу — к закреплённому).
    service: _isService(content),
    pinnedMessageID: content.hasPin() ? content.pin.messageID.toString() : '',
    ttlChange: content.hasTtlChanged() ? content.ttlChanged.period : null,
    noForwardsChange: content.hasNoForwards() ? content.noForwards.newValue : null,
    noForwardsPrev: content.noForwards.prevValue,
    noForwardsRequestID: content.noForwards.requestID > 0 ? content.noForwards.requestID.toString() : '',
    noForwardsRequest: content.hasNoForwardsRequest(),
    senderName: outgoing ? '' : (group ? nameOf(m.fromUserID) : (_isService(content) ? peerName : '')),
    senderUserID: group && !outgoing ? idHex(m.fromUserID) : '',
    pinned: pinned,
    pinnedOnlyMe: pinned && pinnedOnlyMe,
    text: content.hasChatAction() ? serviceText : content.text,
    entities: [for (final e in content.entities) entityFromPb(e)],
    outgoing: outgoing,
    status: outgoing
        ? outgoingStatus(messageID: m.messageID.toInt(), readOutboxMaxID: readOutboxMaxID, isSelf: isSelf)
        : models.MessageStatus.read,
    date: DateTime.fromMillisecondsSinceEpoch(m.date.toInt()),
    edited: m.editDate > 0,
    reply: content.hasReplyTo()
        ? replyFromPb(
            content.replyTo,
            replied: replied,
            myUserID: myUserID,
            peerName: group && replied != null ? nameOf(replied.fromUserID) : peerName,
          )
        : null,
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
    ttlChange: m.content.hasTtlChanged() ? m.content.ttlChanged.period : null,
    noForwardsChange: m.content.hasNoForwards() ? m.content.noForwards.newValue : null,
    noForwardsPrev: m.content.noForwards.prevValue,
    noForwardsRequest: m.content.hasNoForwardsRequest(),
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

/// Роль в группе с сервера → модель (неизвестная / не задана — «Запись»: так
/// и роль по умолчанию группы без `defaultRole`).
models.ChatRole roleFromPb(pb.ChatRole role) => switch (role) {
  pb.ChatRole.CHAT_ROLE_OWNER => models.ChatRole.owner,
  pb.ChatRole.CHAT_ROLE_ADMIN => models.ChatRole.admin,
  pb.ChatRole.CHAT_ROLE_READER => models.ChatRole.reader,
  _ => models.ChatRole.writer,
};

/// Роль модели → сервер.
pb.ChatRole roleToPb(models.ChatRole role) => switch (role) {
  models.ChatRole.owner => pb.ChatRole.CHAT_ROLE_OWNER,
  models.ChatRole.admin => pb.ChatRole.CHAT_ROLE_ADMIN,
  models.ChatRole.reader => pb.ChatRole.CHAT_ROLE_READER,
  models.ChatRole.writer => pb.ChatRole.CHAT_ROLE_WRITER,
};

/// Права админа сервера → модель (и обратно).
models.ChatAdminRights rightsFromPb(pb.ChatAdminRights r) => models.ChatAdminRights(
  changeInfo: r.changeInfo,
  postMessages: r.postMessages,
  editMessages: r.editMessages,
  deleteMessages: r.deleteMessages,
  banUsers: r.banUsers,
  inviteUsers: r.inviteUsers,
  pinMessages: r.pinMessages,
  manageCalls: r.manageCalls,
  anonymous: r.anonymous,
  addAdmins: r.addAdmins,
);

pb.ChatAdminRights rightsToPb(models.ChatAdminRights r) => pb.ChatAdminRights(
  changeInfo: r.changeInfo,
  postMessages: r.postMessages,
  editMessages: r.editMessages,
  deleteMessages: r.deleteMessages,
  banUsers: r.banUsers,
  inviteUsers: r.inviteUsers,
  pinMessages: r.pinMessages,
  manageCalls: r.manageCalls,
  anonymous: r.anonymous,
  addAdmins: r.addAdmins,
);

/// Способ вступления в группу (подэтап 3.3) — сервер → модель и обратно.
models.ChatJoinMode joinModeFromPb(pb.ChatJoinMode mode) => switch (mode) {
  pb.ChatJoinMode.CHAT_JOIN_OPEN => models.ChatJoinMode.open,
  pb.ChatJoinMode.CHAT_JOIN_REQUEST => models.ChatJoinMode.request,
  pb.ChatJoinMode.CHAT_JOIN_ADMINS => models.ChatJoinMode.admins,
  _ => models.ChatJoinMode.link,
};

pb.ChatJoinMode joinModeToPb(models.ChatJoinMode mode) => switch (mode) {
  models.ChatJoinMode.open => pb.ChatJoinMode.CHAT_JOIN_OPEN,
  models.ChatJoinMode.link => pb.ChatJoinMode.CHAT_JOIN_LINK,
  models.ChatJoinMode.request => pb.ChatJoinMode.CHAT_JOIN_REQUEST,
  models.ChatJoinMode.admins => pb.ChatJoinMode.CHAT_JOIN_ADMINS,
};

/// Путь ссылки-приглашения после `iperon.net/`: `+код` (код выдаёт сервер,
/// без плюса); пустой код — пусто.
String invitePath(String code) => code.isEmpty ? '' : '+$code';

/// Код приглашения из пути `+код` (или самого кода).
String inviteCodeOf(String path) => path.startsWith('+') ? path.substring(1) : path;

/// unix millis → дата; 0 — нет.
DateTime? _millis(Int64 value) => value == 0 ? null : DateTime.fromMillisecondsSinceEpoch(value.toInt());

/// Ссылка-приглашение с сервера → модель: id — код (как его ждут Edit /
/// Revoke), путь — `+код`.
models.ChatInviteLink inviteLinkFromPb(pb.ChatInviteLink link) => models.ChatInviteLink(
  id: link.code,
  link: invitePath(link.code),
  title: link.title,
  primary: link.primary,
  revoked: link.revoked,
  expireDate: _millis(link.expireDate),
  usageLimit: link.usageLimit,
  usage: link.usage,
  requestApproval: link.requestApproval,
  pendingCount: link.pendingCount,
  createdAt: _millis(link.createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0),
);

/// Порядок ссылок, как на сервере (`InviteLinks`): основная первой, затем
/// действующие и отозванные — каждые от новых к старым.
List<models.ChatInviteLink> sortInviteLinks(Iterable<models.ChatInviteLink> links) {
  int rank(models.ChatInviteLink l) => l.primary && !l.revoked ? 0 : (l.revoked ? 2 : 1);
  return links.toList()..sort((a, b) {
    final byRank = rank(a).compareTo(rank(b));
    return byRank != 0 ? byRank : b.createdAt.compareTo(a.createdAt);
  });
}

/// Ключ отказа «имя не по правилам» (CheckUsername `invalid`, CreateGroup /
/// EditChat INVALID_ARGUMENT).
const usernameInvalidError = 'usernameInvalid';

/// Как вступать в чужую группу из предпросмотра: нужна заявка (ссылка с
/// одобрением или режим REQUEST) — «Подать заявку», иначе — по режиму.
models.ChatJoinMode previewJoinMode(pb.ChatPreview preview) =>
    preview.requestNeeded ? models.ChatJoinMode.request : joinModeFromPb(preview.chat.joinMode);

/// Свежая страница истории предпросмотра ([fresh], от старых к новым) поверх
/// уже загруженной [loaded]: без повторов, по возрастанию messageID.
List<pb.ChatMessage> mergePreviewHistory(List<pb.ChatMessage> loaded, List<pb.ChatMessage> fresh) {
  final byID = {for (final m in loaded) m.messageID: m, for (final m in fresh) m.messageID: m};
  return byID.values.toList()..sort((a, b) => a.messageID.compareTo(b.messageID));
}

/// Заявка с сервера → модель ([name] / [about] — по общему правилу имени и из
/// профиля); ссылка — её код и название.
models.ChatJoinRequest joinRequestFromPb(pb.ChatJoinRequest request, {required String name, String about = ''}) => models.ChatJoinRequest(
  userID: idHex(request.userID),
  name: name,
  about: about,
  date: DateTime.fromMillisecondsSinceEpoch(request.date.toInt()),
  linkID: request.inviteCode,
  linkTitle: request.inviteTitle,
);

/// Что из вступления менять в `EditChat` (`null` — не трогать): способ
/// [joinMode], имя [username] (только у публичной; уход из публичной
/// освобождает его на сервере сам) и «Скрыть историю» [historyHidden]
/// (только у частной).
class EditJoinChanges {
  final pb.ChatJoinMode? joinMode;
  final String? username;
  final bool? historyHidden;

  const EditJoinChanges({this.joinMode, this.username, this.historyHidden});

  bool get isEmpty => joinMode == null && username == null && historyHidden == null;
}

EditJoinChanges editJoinChanges(
  pb.ChatInfo info, {
  required models.ChatJoinMode joinMode,
  required String username,
  required bool historyHidden,
}) {
  final mode = joinModeToPb(joinMode);
  final open = joinMode == models.ChatJoinMode.open;
  final name = username.trim().toLowerCase();
  return EditJoinChanges(
    joinMode: mode != info.joinMode ? mode : null,
    username: open && name.isNotEmpty && name != info.username.toLowerCase() ? name : null,
    historyHidden: !open && historyHidden != info.historyHidden ? historyHidden : null,
  );
}
