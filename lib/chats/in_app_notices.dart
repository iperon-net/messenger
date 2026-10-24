import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../auth.dart';
import '../di.dart';
import '../logger.dart';
import '../models.dart' as models;
import '../protobuf.dart' as pb;
import '../protobuf/protos/chats_v1.pb.dart' show ThreadReply;
import '../repositories.dart';
import 'chats_mapping.dart' show contentKind, idHex;
import 'chats_remote_data_source.dart';
import 'chats_replies.dart';
import 'chats_sync.dart';
import 'secret/secret_chats_list.dart';
import 'secret/secret_chats_sync.dart';
import '../account_scope.dart';

/// Баннер о новом сообщении поверх приложения ([InAppNotices]).
@immutable
class InAppNotice {
  /// Чат как в списке: заголовок, аватар, последнее сообщение.
  final models.Chat chat;

  /// Окно чата: пока оно открыто, баннер о нём не показывается; туда ведёт тап.
  final String route;

  /// Ещё экраны, где баннер не нужен (ответ в «Ответах», 4.6: открыт экран
  /// «Ответы» или сама ветка).
  final List<String> alsoOpenAt;

  /// От локально скрытого профиля — без имени, текста и аватара, тап ведёт в
  /// список чатов (как у пуша, см. `PushManager._fromHiddenUser`).
  final bool anonymous;

  /// Текст сообщения («Уведомления → Показывать текст»); иначе «Новое сообщение».
  final bool showPreview;

  const InAppNotice({required this.chat, required this.route, this.alsoOpenAt = const [], this.anonymous = false, this.showPreview = true});
}

/// Новые сообщения, о которых показать баннер, пока приложение открыто (как
/// in-app уведомления в Telegram): системные уведомления в foreground не
/// показываются (сервер не будит онлайн-сессии, клиент глушит остаток), и без
/// баннера сообщение в другой чат проходило бы незамеченным.
///
/// Источник — новые входящие, пришедшие вживую по стриму ([ChatsSync.incoming],
/// [SecretChatsSync.incoming]); догон после подключения баннеров не даёт.
/// Правила — как у пушей: заглушённый чат молчит (упоминание в группе пробивает
/// «Без звука»), выключенный тип чатов в «Уведомлениях» тоже, без «Показывать
/// текст» — «Новое сообщение». Где показывать (не в открытом чате, не в списке)
/// решает экранный слой (`InAppNoticeHost`).
class InAppNotices {
  InAppNotices._();

  static InAppNotices get instance => AccountScope.current.resolve(InAppNotices._);

  Logger get _logger => getIt.get<Logger>();
  Repositories get _repositories => getIt.get<Repositories>();
  Auth get _auth => getIt.get<Auth>();

  late final _out = StreamController<InAppNotice>.broadcast(onListen: _start, onCancel: _stop);

  Stream<InAppNotice> get notices => _out.stream;

  StreamSubscription<ChatsIncoming>? _chats;
  StreamSubscription<({Uint8List chatID, int randomID})>? _secret;
  StreamSubscription<ThreadReply>? _replies;

  void _start() {
    _chats = ChatsSync.instance.incoming.listen((event) => _enqueue(event.chatID, () => _fromChat(event)));
    _replies = ChatsSync.instance.repliesIncoming.listen((reply) => _enqueue(models.repliesChatID, () => _fromReply(reply)));
    _secret = SecretChatsSync.instance.incoming.listen((event) {
      final id = secretChatListID(event.chatID);
      _enqueue(id, () => _fromSecret(id, event.randomID));
    });
  }

  Future<void> _stop() async {
    await _chats?.cancel();
    await _secret?.cancel();
    await _replies?.cancel();
    _chats = null;
    _secret = null;
    _replies = null;
  }

  /// Очередь сборки по чатам: пачка сообщений в один чат — один баннер (о
  /// последнем), чтение списка — не на каждое.
  final _pending = <String, Future<InAppNotice?> Function()>{};
  var _draining = false;

  void _enqueue(String chatID, Future<InAppNotice?> Function() build) {
    _pending.remove(chatID);
    _pending[chatID] = build;
    if (_draining) return;
    _draining = true;
    unawaited(_drain());
  }

  Future<void> _drain() async {
    while (_pending.isNotEmpty) {
      final key = _pending.keys.first;
      final build = _pending.remove(key)!;
      try {
        final notice = await build();
        if (notice != null && !_out.isClosed) _out.add(notice);
      } catch (error, stackTrace) {
        _logger.handle(error, stackTrace);
      }
    }
    _draining = false;
  }

  /// Уже показанные (чат:сообщение) — упоминание, пришедшее отдельным
  /// обновлением, не повторяет баннер.
  final _shown = Queue<String>();
  static const _shownLimit = 100;

  void _remember(String key) {
    _shown.add(key);
    if (_shown.length > _shownLimit) _shown.removeFirst();
  }

  Future<InAppNotice?> _fromChat(ChatsIncoming event) async {
    final key = '${event.chatID}:${event.messageID}';
    if (_shown.contains(key)) return null;
    final chat = await ChatsRemoteDataSource.instance.loadChat(event.chatID);
    if (chat == null || chat.isSelf) return null;
    if (chat.muted && !event.mentioned) return null;
    // Пока собирали, прочитали (открыли чат, прочитали на другом устройстве).
    if (chat.unreadCount == 0 && chat.unreadMentions == 0) return null;
    final scope = await _scope(chat);
    if (scope != null && !scope.enabled) return null;
    final hidden = await _repositories.hiddenProfiles.hashByHex();
    _remember(key);
    return InAppNotice(
      chat: chat,
      route: '/chats/chat/${chat.id}',
      anonymous: hidden.containsKey(chat.peerUserID) || hidden.containsKey(event.fromUserID),
      showPreview: scope?.showPreviews ?? true,
    );
  }

  /// Новый ответ в «Ответах» (4.6) — как сообщение в другом чате, по правилам
  /// «Каналы» в «Уведомлениях» (заглушения у «Ответов» нет). Тап — ветка на
  /// этом комментарии; не показывается на экране «Ответы» и в самой ветке.
  Future<InAppNotice?> _fromReply(ThreadReply reply) async {
    final key = '${models.repliesChatID}:${reply.replyID}';
    if (_shown.contains(key)) return null;
    final chat = await ChatsReplies.instance.loadChat();
    // Пока собирали, прочитали (на экране «Ответы» или на другом устройстве).
    if (chat == null || chat.unreadCount == 0) return null;
    final message = reply.message;
    final settings = await _settings();
    final scope = settings != null && settings.hasChannels() ? settings.channels : null;
    if (scope != null && !scope.enabled) return null;
    final hidden = await _repositories.hiddenProfiles.hashByHex();
    final author = idHex(message.fromUserID);
    final names = await ChatsReplies.names([Uint8List.fromList(message.fromUserID)]);
    _remember(key);
    final channelID = idHex(reply.channelID);
    return InAppNotice(
      // Строка «Ответы» с этим ответом последним («Имя: текст»).
      chat: chat.copyWith(
        lastMessage: chat.lastMessage?.copyWith(
          kind: contentKind(message.content),
          text: message.content.hasPoll() ? message.content.poll.question : message.content.text,
          senderName: names[author] ?? '',
          date: DateTime.fromMillisecondsSinceEpoch(message.date.toInt()),
        ),
      ),
      route: '/chats/comments/$channelID/${reply.postID}?message=${message.messageID}',
      alsoOpenAt: ['/chats/replies', '/chats/chat/${idHex(message.chatID)}', '/chats/comments/$channelID/${reply.postID}'],
      anonymous: hidden.containsKey(author),
      showPreview: scope?.showPreviews ?? true,
    );
  }

  Future<InAppNotice?> _fromSecret(String id, int randomID) async {
    final key = '$id:$randomID';
    if (_shown.contains(key)) return null;
    final chats = await watchSecretChats().first.timeout(const Duration(seconds: 5));
    final chat = chats.where((c) => c.id == id).firstOrNull;
    if (chat == null || chat.unreadCount == 0) return null;
    final scope = await _scope(chat);
    if (scope != null && !scope.enabled) return null;
    final hidden = await _repositories.hiddenProfiles.hashByHex();
    _remember(key);
    return InAppNotice(
      chat: chat,
      route: '/chats/secret/${id.substring(secretChatIDPrefix.length)}',
      anonymous: hidden.containsKey(chat.peerUserID),
      showPreview: scope?.showPreviews ?? true,
    );
  }

  /// Настройки уведомлений (общие для устройств, кэш в SQLite); null — ещё
  /// не приходили.
  Future<pb.NotifySettings_Response?> _settings() async {
    final buffer = await _repositories.notifySettings.get(userID: _auth.session.userID);
    return buffer == null ? null : pb.NotifySettings_Response.fromBuffer(buffer);
  }

  /// Настройка уведомлений типа чатов (общая для устройств, кэш в SQLite);
  /// null — ещё не приходила (по умолчанию всё включено, как на сервере).
  Future<pb.NotifySettings_ScopeSettings?> _scope(models.Chat chat) async {
    final settings = await _settings();
    if (settings == null) return null;
    return switch (chat.type) {
      models.ChatType.private => settings.hasPrivateChats() ? settings.privateChats : null,
      models.ChatType.group || models.ChatType.community => settings.hasGroups() ? settings.groups : null,
      models.ChatType.channel => settings.hasChannels() ? settings.channels : null,
    };
  }
}
