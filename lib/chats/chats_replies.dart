import 'dart:async';

import 'package:flutter/foundation.dart';

import '../auth.dart';
import '../di.dart';
import '../i18n/translations.g.dart';
import '../logger.dart';
import '../models.dart' as models;
import '../protobuf/protos/chats_v1.pb.dart' as pb;
import '../repositories.dart';
import 'chats_mapping.dart';
import 'chats_remote_data_source.dart';
import 'chats_sync.dart';
import '../account_scope.dart';

/// «Ответы» (подэтап 4.6, docs/plans/chats-channels.md; как Replies в
/// Telegram): ответы на мои комментарии и упоминания меня в ветках
/// комментариев каналов. Кэш ведёт [ChatsSync] (журнал пользователя
/// `Update.replies`, страницы `Messages.Replies`), здесь — чтение для экранов:
/// виртуальная строка списка чатов ([watchChat]) и лента ([watchReplies]).
/// В демо «Ответов» нет.
class ChatsReplies {
  /// Аккаунт этого сервиса: зависимости берутся из него, а не из «текущего» —
  /// после переключения аккаунта незавершённые операции не уйдут в чужой.
  final AccountScope _scope = AccountScope.current;

  ChatsReplies._();

  static ChatsReplies get instance => AccountScope.current.resolve(ChatsReplies._);

  Logger get _logger => getIt.get<Logger>();
  Repositories get _repositories => _scope.repositories;
  ChatsRepository get _store => _repositories.chats;
  ChatsSync get _sync => ChatsSync.instance;
  Auth get _auth => _scope.auth;

  /// Имена людей по общему правилу (hex userID → имя; и для баннера о
  /// новом ответе); в тестах — подмена. Источник берётся на каждый вызов:
  /// ссылка на метод запомнила бы первый аккаунт, и после переключения чтение
  /// шло бы в его закрытую базу.
  static Future<Map<String, String>> Function(List<Uint8List> userIDs) names = (userIDs) =>
      ChatsRemoteDataSource.instance.peopleNames(userIDs);

  /// Скачанный файл по cdnID; в тестах — подмена.
  @visibleForTesting
  static Future<String> Function(List<int> cdnID) cachedFile = (cdnID) => ChatsRemoteDataSource.instance.cachedFilePath(cdnID);

  static const _rowTables = [ChatsRepository.repliesTable, ChatsRepository.repliesStateTable, 'profiles', 'contacts'];
  static const _feedTables = [..._rowTables, ChatsRepository.repliesChatsTable, ChatsRepository.groupsTable];

  /// Сколько ответов ленты читаем из кэша за раз.
  static const feedLimit = 1000;

  /// Строка «Ответы» списка чатов; `null` — не показывается (ответов нет).
  Stream<models.Chat?> watchChat() => _watch(_rowTables, loadChat);

  /// Лента «Ответов» от старых к новым (внизу — самый новый, как в чате).
  Stream<List<models.ChatReply>> watchReplies() => _watch(_feedTables, loadReplies);

  /// Перечитывать [load] при изменении [tables]; по очереди, чтобы старый
  /// результат не пришёл после нового.
  Stream<T> _watch<T>(List<String> tables, Future<T> Function() load) {
    late final StreamController<T> out;
    StreamSubscription<void>? changes;
    var pending = Future<void>.value();
    void reload() {
      pending = pending
          .then((_) async {
            final value = await load();
            if (!out.isClosed) out.add(value);
          })
          .catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace));
    }

    out = StreamController<T>(
      onListen: () {
        changes = _repositories.db.onChange(tables).listen((_) => reload());
      },
      onCancel: () async {
        await changes?.cancel();
      },
    );
    return out.stream;
  }

  /// Строка «Ответы»: последний ответ «Имя: текст», дата — его, цифра —
  /// непрочитанные с сервера.
  Future<models.Chat?> loadChat() async {
    if (!_auth.isAuthorized) return null;
    final me = _sync.me;
    final newest = await _store.replies(userID: me, limit: 1);
    if (newest.isEmpty) return null;
    final state = await _store.repliesState(userID: me);
    final message = newest.first.message;
    final people = await names([Uint8List.fromList(message.fromUserID)]);
    // Автор скрыт локально — без имени и текста (как баннер и пуш).
    final hidden = (await _repositories.hiddenProfiles.hashByHex()).containsKey(idHex(message.fromUserID));
    final date = DateTime.fromMillisecondsSinceEpoch(message.date.toInt());
    return models.Chat(
      id: models.repliesChatID,
      type: models.ChatType.private,
      title: t.screenChats.replies,
      lastMessage: models.ChatLastMessage(
        kind: hidden ? models.MessageKind.text : contentKind(message.content),
        text: hidden ? t.inAppNotice.newMessage : (message.content.hasPoll() ? message.content.poll.question : message.content.text),
        senderName: hidden ? '' : people[idHex(message.fromUserID)] ?? '',
        outgoing: false,
        status: models.MessageStatus.read,
        date: date,
      ),
      unreadCount: state?.unreadCount ?? 0,
      createdAt: date,
    );
  }

  /// Ответы из кэша — от старых к новым, с именами, подписью канала и началом
  /// поста.
  Future<List<models.ChatReply>> loadReplies() async {
    if (!_auth.isAuthorized) return const [];
    final me = _sync.me;
    final rows = await _store.replies(userID: me, limit: feedLimit);
    if (rows.isEmpty) return const [];
    final readMaxID = (await _store.repliesState(userID: me))?.readMaxID ?? 0;
    final people = await names([for (final r in rows) Uint8List.fromList(r.message.fromUserID)]);
    final known = await _store.repliesChats(userID: me);
    final hiddenProfiles = await _repositories.hiddenProfiles.hashByHex();
    final channelTitles = <String, String>{};
    final postTexts = <String, String>{};
    final items = <models.ChatReply>[];
    for (final reply in rows.reversed) {
      final message = reply.message;
      final channel = idHex(reply.channelID);
      final title = channelTitles[channel] ??= await _channelTitle(me, reply.channelID, known);
      final postKey = '$channel:${reply.postID}';
      final post = postTexts[postKey] ??= await _postText(me, reply.channelID, reply.postID.toInt());
      // Автор скрыт локально — без имени, аватара, текста и медиа.
      final hidden = hiddenProfiles.containsKey(idHex(message.fromUserID));
      final media = hidden ? (path: '', thumbhash: '') : await _media(message.content);
      items.add(
        models.ChatReply(
          replyID: reply.replyID.toInt(),
          threadChatID: idHex(message.chatID),
          channelID: channel,
          authorID: hidden ? '' : idHex(message.fromUserID),
          messageID: message.messageID.toInt(),
          postID: reply.postID.toInt(),
          mention: reply.mention,
          date: DateTime.fromMillisecondsSinceEpoch(message.date.toInt()),
          authorName: hidden ? '' : people[idHex(message.fromUserID)] ?? '',
          channelTitle: title,
          postText: post,
          kind: hidden ? models.MessageKind.text : contentKind(message.content),
          text: hidden ? t.inAppNotice.newMessage : (message.content.hasPoll() ? message.content.poll.question : message.content.text),
          mediaPath: media.path,
          thumbhash: media.thumbhash,
          unread: reply.replyID > readMaxID && !reply.read,
          hidden: hidden,
        ),
      );
    }
    return items;
  }

  /// Название канала: свой кэш (подписан / читал), иначе — из ответа
  /// `Messages.Replies`.
  Future<String> _channelTitle(List<int> me, List<int> channelID, Map<String, pb.ChatInfo> known) async {
    final group = await _store.group(userID: me, chatID: channelID);
    if (group != null && group.info.title.isNotEmpty) return group.info.title;
    return known[idHex(channelID)]?.title ?? '';
  }

  /// Начало поста из кэша (текст или вид вложения); нет в кэше — пусто.
  Future<String> _postText(List<int> me, List<int> channelID, int postID) async {
    final post = await _store.message(userID: me, chatID: channelID, messageID: postID);
    if (post == null) return '';
    final content = post.content;
    if (content.hasPoll()) return content.poll.question;
    if (content.text.isNotEmpty) return content.text;
    return switch (contentKind(content)) {
      models.MessageKind.photo => t.screenChats.photo,
      models.MessageKind.video => t.screenChats.video,
      models.MessageKind.file => t.screenChats.file,
      models.MessageKind.voice => t.screenChats.voice,
      _ => '',
    };
  }

  /// Превью фото / видео: скачанный файл (у видео — обложка) или thumbhash.
  Future<({String path, String thumbhash})> _media(pb.MessageContent content) async {
    final kind = contentKind(content);
    if (content.media.isEmpty || (kind != models.MessageKind.photo && kind != models.MessageKind.video)) {
      return (path: '', thumbhash: '');
    }
    final media = content.media.first;
    final cdnID = kind == models.MessageKind.video ? media.thumbCdnID : media.cdnID;
    return (path: cdnID.isEmpty ? '' : await cachedFile(cdnID), thumbhash: media.thumbhash);
  }
}
