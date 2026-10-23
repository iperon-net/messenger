import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import '../i18n/translations.g.dart';
import '../models.dart' as models;
import '../protobuf/protos/chats_v1.pb.dart' as pb;
import 'reactions.dart' show maxReactionsPerPost;

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

/// Пост канала шапкой ленты своей ветки комментариев (4.3): `post:<postID>` —
/// не сообщение ветки (ни ответить, ни реакции, ни правки).
const threadPostPrefix = 'post:';

String threadPostMessageID(int postID) => '$threadPostPrefix$postID';

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
  if (content.hasPoll()) return models.MessageKind.poll;
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
/// [names] — имена тех, кого добавили / исключили (меня — «вас»). [channel]
/// — служебное канала: от имени канала, без автора («Канал создан»).
String chatActionText(
  Translations t,
  pb.MessageChatAction action, {
  required bool outgoing,
  required String actor,
  List<String> names = const [],
  bool channel = false,
}) {
  final a = t.chatAction;
  final who = names.join(', ');
  if (channel) {
    switch (action.kind) {
      case pb.MessageChatAction_Kind.CREATED:
        return a.channelCreated(title: action.title);
      case pb.MessageChatAction_Kind.TITLE_CHANGED:
        return a.channelTitle(title: action.title);
      case pb.MessageChatAction_Kind.PHOTO_CHANGED:
        return a.channelPhoto;
      case pb.MessageChatAction_Kind.PHOTO_REMOVED:
        return a.channelPhotoRemoved;
      default:
    }
  }
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

/// Уведомление системного аккаунта «Iperon» → модель для кнопок под ним
/// (`null` — не оно).
models.SystemNotice? systemNoticeFromPb(pb.MessageContent content) {
  if (!content.hasSystemNotice()) return null;
  final notice = content.systemNotice;
  final kinds = models.SystemNoticeKind.values;
  final kind = notice.kind.value;
  return models.SystemNotice(
    kind: kind < kinds.length ? kinds[kind] : models.SystemNoticeKind.unknown,
    sessionID: notice.sessionID.isEmpty ? '' : idHex(notice.sessionID),
    deviceModel: notice.deviceModel,
  );
}

/// Заголовок уведомления «Iperon» — превью в списке чатов и первая строка
/// пузыря.
String systemNoticeTitle(Translations t, pb.MessageSystemNotice notice) {
  final s = t.systemNotice;
  return switch (notice.kind) {
    pb.MessageSystemNotice_Kind.NEW_LOGIN => s.newLoginTitle,
    pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_SET => s.cloudPasswordSetTitle,
    pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_CHANGED => s.cloudPasswordChangedTitle,
    pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_DISABLED => s.cloudPasswordDisabledTitle,
    pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_RESET => s.cloudPasswordResetTitle,
    pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_WRONG => s.cloudPasswordWrongTitle,
    pb.MessageSystemNotice_Kind.RECOVERY_EMAIL_SET => s.recoveryEmailSetTitle,
    pb.MessageSystemNotice_Kind.PASSKEY_ADDED => s.passkeyAddedTitle,
    pb.MessageSystemNotice_Kind.PASSKEY_REMOVED => s.passkeyRemovedTitle,
    _ => s.unknown,
  };
}

/// Текст уведомления «Iperon» (как сервисные 777000 в Telegram): заголовок
/// жирным, что произошло, затем устройство, место, IP, способ входа (что
/// известно) и подсказка «если это были не вы». [russian] — место по-русски.
({String text, List<models.MessageEntity> entities}) systemNoticeText(
  Translations t,
  pb.MessageSystemNotice notice, {
  required bool russian,
}) {
  final s = t.systemNotice;
  final title = systemNoticeTitle(t, notice);
  final body = switch (notice.kind) {
    pb.MessageSystemNotice_Kind.NEW_LOGIN => s.newLogin,
    pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_SET => s.cloudPasswordSet,
    pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_CHANGED => s.cloudPasswordChanged,
    pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_DISABLED => s.cloudPasswordDisabled,
    pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_RESET => s.cloudPasswordReset,
    pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_WRONG => s.cloudPasswordWrong,
    pb.MessageSystemNotice_Kind.RECOVERY_EMAIL_SET =>
      notice.email.isEmpty ? s.recoveryEmailSetNoEmail : s.recoveryEmailSet(email: notice.email),
    pb.MessageSystemNotice_Kind.PASSKEY_ADDED =>
      notice.passkeyLabel.isEmpty ? s.passkeyAddedNoLabel : s.passkeyAdded(label: notice.passkeyLabel),
    pb.MessageSystemNotice_Kind.PASSKEY_REMOVED => s.passkeyRemoved,
    _ => '',
  };
  if (body.isEmpty) return (text: title, entities: const []);

  final device = [
    notice.deviceModel,
    if (notice.osVersion.isNotEmpty) '${notice.os == 1 ? 'iOS' : 'Android'} ${notice.osVersion}',
  ].where((part) => part.isNotEmpty).join(', ');
  final location = russian
      ? (notice.locationRussian.isNotEmpty ? notice.locationRussian : notice.locationEnglish)
      : (notice.locationEnglish.isNotEmpty ? notice.locationEnglish : notice.locationRussian);
  final method = switch (notice.loginMethod) {
    pb.MessageSystemNotice_LoginMethod.CALL_PASSWORD => s.methodCallPassword,
    pb.MessageSystemNotice_LoginMethod.SMS => s.methodSms,
    pb.MessageSystemNotice_LoginMethod.PASSKEY => s.methodPasskey,
    pb.MessageSystemNotice_LoginMethod.YANDEX => s.methodYandex,
    _ => '',
  };
  final details = [
    if (device.isNotEmpty) s.device(value: device),
    if (notice.appVersion.isNotEmpty) s.app(value: notice.appVersion),
    if (location.isNotEmpty) s.location(value: location),
    if (notice.ip.isNotEmpty) s.ip(value: notice.ip),
    if (method.isNotEmpty) s.method(value: method),
  ];
  // Своё действие из настроек «не я» не бывает — подсказка только там, где
  // мог быть чужой.
  final hint = switch (notice.kind) {
    pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_WRONG => s.cloudPasswordWrongHint,
    pb.MessageSystemNotice_Kind.RECOVERY_EMAIL_SET || pb.MessageSystemNotice_Kind.PASSKEY_ADDED => '',
    _ => notice.sessionID.isEmpty ? '' : s.notMeHint,
  };
  final text = [title, body, if (details.isNotEmpty) details.join('\n'), if (hint.isNotEmpty) hint].join('\n\n');
  return (text: text, entities: [models.MessageEntity(type: models.MessageEntityType.bold, offset: 0, length: title.length)]);
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
///
/// Группа — только счётчики (`counts`, по первой постановке эмодзи): наши —
/// с `chosenOrder` > 0 (глазами смотрящего; в кэше — после
/// [mergeSharedReactions]).
List<models.MessageReaction> reactionsFromPb(pb.MessageReactions reactions, {required List<int> myUserID}) {
  if (reactions.counts.isNotEmpty) {
    return [
      for (final c in reactions.counts)
        if (c.count > 0) models.MessageReaction(emoji: c.emoji, count: c.count, chosen: c.chosenOrder > 0, chosenOrder: c.chosenOrder),
    ];
  }
  final chips = <String, models.MessageReaction>{};
  var mine = 0;
  for (final r in reactions.reactions) {
    final chosen = sameID(r.userID, myUserID);
    final chip = chips[r.emoji] ?? models.MessageReaction(emoji: r.emoji, count: 0);
    chips[r.emoji] = chip.copyWith(count: chip.count + 1, chosen: chip.chosen || chosen, chosenOrder: chosen ? ++mine : chip.chosenOrder);
  }
  return chips.values.toList(growable: false);
}

/// Реакции группы из общего обновления (журнал чата: `counts` без
/// `chosenOrder`) поверх сохранённых [stored]: кто изменил — [actorUserID] с
/// его набором [actorEmojis] целиком. Это я — мои теперь [actorEmojis] (в
/// этом порядке), иначе свои остаются как были. Пришло глазами смотрящего
/// (есть `chosenOrder` — History / Get / ответ SetReactions) или это личный
/// чат (полный список `reactions`) — как есть.
pb.MessageReactions mergeSharedReactions(
  pb.MessageReactions? stored,
  pb.MessageReactions incoming, {
  List<int> actorUserID = const [],
  List<String> actorEmojis = const [],
  required List<int> myUserID,
}) {
  if (incoming.counts.isEmpty || incoming.counts.any((c) => c.chosenOrder > 0)) return incoming;
  final List<String> mine;
  if (actorUserID.isNotEmpty && sameID(actorUserID, myUserID)) {
    mine = actorEmojis;
  } else {
    final chosen = [
      for (final c in stored?.counts ?? const <pb.ReactionCount>[])
        if (c.chosenOrder > 0) c,
    ]..sort((a, b) => a.chosenOrder.compareTo(b.chosenOrder));
    mine = [for (final c in chosen) c.emoji];
  }
  final result = incoming.deepCopy();
  for (final c in result.counts) {
    final order = mine.indexOf(c.emoji);
    c.chosenOrder = order >= 0 && c.count > 0 ? order + 1 : 0;
  }
  return result;
}

/// Имя «мы» в списке «кто за что» (`PollOption.voters`, как в демо):
/// экран показывает его как «Вы» текущего языка.
const pollVoterSelf = 'Вы';

/// Опрос: содержимое ([poll], верный ответ сервер из него убирает) и итоги
/// глазами смотрящего ([results]; `null` — ещё нет, например неотправленный)
/// → модель. Верный вариант и пояснение викторины — только когда итоги
/// открыты (мы проголосовали или опрос завершён) и сервер их прислал.
models.MessagePoll pollFromPb(pb.MessagePoll poll, pb.PollResults? results) {
  final r = results ?? pb.PollResults();
  final chosen = r.chosen.toSet();
  final revealed = results != null && poll.quiz && (chosen.isNotEmpty || r.closed) && r.correctOption >= 0;
  return models.MessagePoll(
    question: poll.question,
    options: [
      for (final (i, text) in poll.options.indexed)
        models.PollOption(
          text: text,
          votes: i < r.votes.length ? r.votes[i] : 0,
          chosen: chosen.contains(i),
          correct: revealed && r.correctOption == i,
        ),
    ],
    anonymous: poll.anonymous,
    multiple: poll.multiple && !poll.quiz,
    quiz: poll.quiz,
    explanation: revealed ? r.explanation : '',
    closed: r.closed,
    totalVoters: r.totalVoters,
  );
}

/// Опрос для отправки (`MessageContent.poll`): у викторины — индекс верного
/// варианта и пояснение, без мультивыбора.
pb.MessagePoll pollToPb(models.MessagePoll poll) {
  final correct = poll.options.indexWhere((o) => o.correct);
  return pb.MessagePoll(
    question: poll.question.trim(),
    options: [for (final o in poll.options) o.text.trim()],
    anonymous: poll.anonymous,
    multiple: poll.multiple && !poll.quiz,
    quiz: poll.quiz,
    correctOption: poll.quiz ? (correct < 0 ? 0 : correct) : null,
    explanation: poll.quiz && poll.explanation.trim().isNotEmpty ? poll.explanation.trim() : null,
  );
}

/// Итоги опроса из обновления поверх сохранённых [stored]. Общее (журнал
/// чата: без моего выбора и без верного ответа, пока не завершён) — мой выбор
/// остаётся, а если проголосовал я ([actorIsMe]) — теперь [actorOptions];
/// уже открытый мне верный ответ не пропадает. Глазами меня ([shared] false:
/// журнал пользователя, ответ VotePoll / ClosePoll, History / Get) — как есть.
pb.PollResults mergePollResults(
  pb.PollResults? stored,
  pb.PollResults incoming, {
  required bool shared,
  bool actorIsMe = false,
  List<int> actorOptions = const [],
}) {
  if (!shared) return incoming;
  final result = incoming.deepCopy();
  result.chosen
    ..clear()
    ..addAll(actorIsMe ? actorOptions : (stored?.chosen ?? const <int>[]));
  if (result.correctOption < 0 && stored != null && stored.correctOption >= 0 && (stored.chosen.isNotEmpty || stored.closed)) {
    result
      ..correctOption = stored.correctOption
      ..explanation = stored.explanation;
  }
  return result;
}

/// «Максимум реакций под постом» канала (`ChatInfo.maxReactions`, 1–11);
/// у группы и у старого сервера (0) — без лимита ([maxReactionsPerPost]).
int maxReactionsOf(pb.ChatInfo info) => info.type == pb.ChatType.CHAT_TYPE_CHANNEL && info.maxReactions > 0
    ? math.min(info.maxReactions, maxReactionsPerPost)
    : maxReactionsPerPost;

/// Канал (4.3): кто может комментировать — сервер → модель и обратно.
models.ChatCommentsWho commentsWhoFromPb(pb.ChatCommentsWho who) =>
    who == pb.ChatCommentsWho.CHAT_COMMENTS_WHO_SUBSCRIBERS ? models.ChatCommentsWho.subscribers : models.ChatCommentsWho.all;

pb.ChatCommentsWho commentsWhoToPb(models.ChatCommentsWho who) => switch (who) {
  models.ChatCommentsWho.all => pb.ChatCommentsWho.CHAT_COMMENTS_WHO_ALL,
  models.ChatCommentsWho.subscribers => pb.ChatCommentsWho.CHAT_COMMENTS_WHO_SUBSCRIBERS,
};

/// Комментарии поста: свежие ([incoming] — журнал канала, GetViews, ответ
/// SetCommentsClosed) поверх сохранённых [stored]: всё — из свежих, кроме
/// моего readMaxID (общий журнал его не несёт — 0) — он не уменьшается.
pb.MessageComments mergeComments(pb.MessageComments? stored, pb.MessageComments incoming) {
  if (stored == null || stored.readMaxID <= incoming.readMaxID) return incoming;
  return incoming.deepCopy()..readMaxID = stored.readMaxID;
}

/// Есть ли в ветке новое с моего чтения. Ветку ни разу не открывал (readMaxID
/// 0) — не помечаем: иначе точка горела бы у каждого поста с комментариями.
bool commentsUnreadOf(pb.MessageComments comments) => comments.readMaxID > 0 && comments.maxID > comments.readMaxID;

/// Срок (unix millis) → дата; 0 — нет.
DateTime? dateFromMillis(Int64 millis) => millis > 0 ? DateTime.fromMillisecondsSinceEpoch(millis.toInt()) : null;

/// Ветка комментариев (4.3) → модель: скрытый чат (`Chat.threadOf`, в списке
/// не показывается) — как группа, но название, аватар, медленный режим и
/// «новички» — от канала [channel] (нет в кэше — из сведений ветки), а кто
/// может писать решают настройки канала (окно чата, `ChatCubit`).
models.Chat threadChatFromPb(
  pb.ChatInfo thread, {
  pb.ChatInfo? channel,
  bool channelAdmin = false,
  String avatarPath = '',
  int unreadCount = 0,
  int slowModeUntil = 0,
  String draft = '',
  DateTime? createdAt,
}) {
  final source = channel ?? thread;
  return models.Chat(
    id: idHex(thread.chatID),
    type: models.ChatType.group,
    title: source.title,
    avatarPath: avatarPath,
    avatarThumbhash: channel?.avatarThumbhash ?? '',
    threadOf: idHex(thread.parentChatID),
    threadPostID: thread.postID.toString(),
    commentsCloseDate: dateFromMillis(thread.commentsCloseDate),
    membersCount: math.max(source.membersCount, 2),
    reactionsMode: reactionsModeFromPb(thread.reactionsMode),
    reactions: thread.reactions,
    // Медленный режим админов канала не касается (как админов группы).
    slowMode: channelAdmin ? 0 : source.slowMode,
    slowModeUntil: slowModeUntil > 0 ? DateTime.fromMillisecondsSinceEpoch(slowModeUntil) : null,
    newcomerMediaDelay: source.newcomerMediaDelay,
    noForwards: source.noForwards,
    // Писать в ветку может любой (ограничения — от канала).
    myRole: models.ChatRole.writer,
    unreadCount: unreadCount,
    draft: draft,
    createdAt: createdAt,
  );
}

/// Режим реакций группы — сервер → модель и обратно (порядок совпадает).
models.ChatReactionsMode reactionsModeFromPb(pb.ChatReactionsMode mode) => switch (mode) {
  pb.ChatReactionsMode.CHAT_REACTIONS_SOME => models.ChatReactionsMode.some,
  pb.ChatReactionsMode.CHAT_REACTIONS_NONE => models.ChatReactionsMode.none,
  _ => models.ChatReactionsMode.all,
};

pb.ChatReactionsMode reactionsModeToPb(models.ChatReactionsMode mode) => switch (mode) {
  models.ChatReactionsMode.all => pb.ChatReactionsMode.CHAT_REACTIONS_ALL,
  models.ChatReactionsMode.some => pb.ChatReactionsMode.CHAT_REACTIONS_SOME,
  models.ChatReactionsMode.none => pb.ChatReactionsMode.CHAT_REACTIONS_NONE,
};

/// ✓ / ✓✓ исходящего: прочитано, если собеседник дочитал до него
/// (`readOutboxMaxID`). В «Избранном» читать некому — всегда прочитано.
models.MessageStatus outgoingStatus({required int messageID, required int readOutboxMaxID, required bool isSelf}) =>
    isSelf || messageID <= readOutboxMaxID ? models.MessageStatus.read : models.MessageStatus.sent;

/// Сообщение сервера → `Message`. [replied] — сообщение, на которое ответили
/// (если есть в локальном кэше), [peerName] — имя собеседника (автор входящих в
/// личном чате). Группа — [nameOf]: имя участника по userID (автор и ответ),
/// [serviceText] — текст служебного группы (см. [chatActionText]). [channel]
/// — пост канала (срез 4): автора нет (fromUserID пуст), мой — по `postOut`,
/// подпись — `authorSignature`, галочек «прочитано» нет.
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
  bool channel = false,
}) {
  final outgoing = channel ? m.postOut : sameID(m.fromUserID, myUserID);
  final group = nameOf != null && !channel;
  final content = m.content;
  final kind = contentKind(content);
  final first = content.media.isEmpty ? null : content.media.first;
  final notice = content.hasSystemNotice()
      ? systemNoticeText(t, content.systemNotice, russian: LocaleSettings.currentLocale == AppLocale.ru)
      : null;
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
    senderName: outgoing || channel ? '' : (group ? nameOf(m.fromUserID) : (_isService(content) ? peerName : '')),
    senderUserID: group && !outgoing ? idHex(m.fromUserID) : '',
    pinned: pinned,
    pinnedOnlyMe: pinned && pinnedOnlyMe,
    // Опрос: текста нет — вопрос (превью, ответ, поиск по ленте); уведомление
    // «Iperon» — текст по виду (локализует клиент).
    text: content.hasChatAction()
        ? serviceText
        : (content.hasPoll() ? content.poll.question : (notice != null ? notice.text : content.text)),
    entities: notice != null ? notice.entities : [for (final e in content.entities) entityFromPb(e)],
    systemNotice: systemNoticeFromPb(content),
    outgoing: outgoing,
    status: outgoing
        ? (channel
              ? models.MessageStatus.sent
              : outgoingStatus(messageID: m.messageID.toInt(), readOutboxMaxID: readOutboxMaxID, isSelf: isSelf))
        : models.MessageStatus.read,
    authorSignature: channel ? m.authorSignature : '',
    // Просмотры поста канала (4.2): из выдачи / кэша, свежие — GetViews.
    views: channel && !_isService(m.content) ? m.views : 0,
    date: DateTime.fromMillisecondsSinceEpoch(m.date.toInt()),
    edited: m.editDate > 0,
    reply: content.hasReplyTo()
        ? replyFromPb(
            content.replyTo,
            replied: replied,
            myUserID: myUserID,
            peerName: group && replied != null ? nameOf(replied.fromUserID) : peerName,
            channel: channel,
          )
        : null,
    fileName: first?.fileName ?? '',
    fileSize: first?.size.toInt() ?? 0,
    duration: first?.duration ?? 0,
    // Волна в proto — 0..255, в модели — 0..31 (5 бит, как в Telegram).
    waveform: [for (final v in first?.waveform ?? const <int>[]) v >> 3],
    mediaUnread: m.mediaUnread,
    reactionsUnread: outgoing && m.reactionsUnread,
    mentionUnread: !outgoing && m.mentionUnread,
    poll: content.hasPoll() ? pollFromPb(content.poll, m.hasPoll() ? m.poll : null) : null,
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
    // Комментарии к посту канала (4.3): последние комментаторы — userID, их
    // фото — из кэша профилей.
    commentsCount: channel && m.hasComments() ? m.comments.count : 0,
    commenters: channel && m.hasComments() ? [for (final id in m.comments.recentUserIDs.take(3)) idHex(id)] : const [],
    commentsCloseDate: channel && m.hasComments() ? dateFromMillis(m.comments.closeDate) : null,
    commentsThreadID: channel && m.comments.threadChatID.isNotEmpty ? idHex(m.comments.threadChatID) : '',
    commentsUnread: channel && m.hasComments() && commentsUnreadOf(m.comments),
  );
}

/// Ответ: текст исходного — из кэша (нет в кэше — без текста, только цитата).
models.MessageReply replyFromPb(
  pb.MessageReplyTo r, {
  pb.ChatMessage? replied,
  required List<int> myUserID,
  String peerName = '',
  bool channel = false,
}) {
  final outgoing = replied != null && (channel ? replied.postOut : sameID(replied.fromUserID, myUserID));
  final repliedContent = replied?.content;
  final kind = repliedContent == null ? models.MessageKind.text : contentKind(repliedContent);
  final fileName = repliedContent != null && repliedContent.media.isNotEmpty ? repliedContent.media.first.fileName : '';
  final text = repliedContent == null ? '' : (repliedContent.hasPoll() ? repliedContent.poll.question : repliedContent.text);
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

/// Без fromUserID — автор запретил ссылку на аккаунт при пересылке. Пост
/// канала (4.2) — fromChatID / fromMessageID / fromSignature (и публичное имя
/// канала fromUsername — 4.4), автора нет (это не «скрыт»).
models.MessageForward forwardFromPb(pb.MessageForward f, {required List<int> myUserID}) {
  if (f.fromChatID.isNotEmpty) {
    return models.MessageForward(
      name: f.fromName,
      chatID: idHex(f.fromChatID),
      messageID: f.fromMessageID > 0 ? f.fromMessageID.toString() : '',
      signature: f.fromSignature,
      username: f.fromUsername,
    );
  }
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
  bool channel = false,
}) {
  final outgoing = channel ? m.postOut : sameID(m.fromUserID, myUserID);
  return models.ChatLastMessage(
    kind: contentKind(m.content),
    text: m.content.hasPoll()
        ? m.content.poll.question
        : (m.content.hasSystemNotice() ? systemNoticeTitle(t, m.content.systemNotice) : m.content.text),
    outgoing: outgoing,
    status: outgoing
        ? (channel
              ? models.MessageStatus.sent
              : outgoingStatus(messageID: m.messageID.toInt(), readOutboxMaxID: readOutboxMaxID, isSelf: isSelf))
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

/// Найденный глобальным поиском публичный чат (`Chats.SearchChats`) → модель
/// строки поиска: группа или канал (другие типы и пустой id — `null`),
/// название, имя, число участников, [models.Chat.isMember]; [avatarPath] —
/// скачанный аватар.
models.Chat? foundChatFromPb(pb.Chats_FoundChat found, {String avatarPath = ''}) {
  final info = found.chat;
  final type = switch (info.type) {
    pb.ChatType.CHAT_TYPE_GROUP => models.ChatType.group,
    pb.ChatType.CHAT_TYPE_CHANNEL => models.ChatType.channel,
    _ => null,
  };
  if (type == null || info.chatID.isEmpty) return null;
  return models.Chat(
    id: idHex(info.chatID),
    type: type,
    title: info.title,
    about: info.about,
    avatarPath: avatarPath,
    avatarThumbhash: info.avatarThumbhash,
    membersCount: info.membersCount,
    joinMode: joinModeFromPb(info.joinMode),
    username: info.username,
    isMember: found.member,
  );
}
