import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart' as models;

part 'secret_chat_state.mapper.dart';

/// Что показать разово (диалог / SnackBar) — счётчик меняется на каждое событие.
@MappableEnum()
enum SecretChatNotice { none, offline, notReady }

@MappableClass()
class SecretChatState with SecretChatStateMappable {
  final Status status;

  /// id чата в hex (без префикса списка).
  final String chatID;

  /// Имя собеседника по общему правилу.
  final String title;
  final String peerUserID;

  final models.SecretChatStatus secretStatus;

  /// Я начал чат.
  final bool outgoing;

  /// Эмодзи и hex отпечатка ключа; пусто — ключа ещё нет.
  final List<String> emoji;
  final String fingerprintHex;

  /// Таймер самоуничтожения новых сообщений, секунд (0 — выключен).
  final int ttl;

  /// Фото собеседника (кэш профилей); пусто — заглушка.
  final String avatarPath;

  /// Переписка по времени (старые сверху).
  final List<models.Message> messages;

  /// Рассыпаются в пыль после удаления (см. `MessageDust`).
  final List<String> vanishingIDs;

  /// Разовое уведомление: [notice] + счётчик [noticeCount].
  final SecretChatNotice notice;
  final int noticeCount;

  /// Чат удалён (с этого устройства) — экран закрывается.
  final bool removed;

  const SecretChatState({
    this.status = Status.initialization,
    this.chatID = '',
    this.title = '',
    this.peerUserID = '',
    this.secretStatus = models.SecretChatStatus.waiting,
    this.outgoing = false,
    this.emoji = const [],
    this.fingerprintHex = '',
    this.ttl = 0,
    this.avatarPath = '',
    this.messages = const [],
    this.vanishingIDs = const [],
    this.notice = SecretChatNotice.none,
    this.noticeCount = 0,
    this.removed = false,
  });

  bool get canSend => secretStatus == models.SecretChatStatus.ready;

  /// Чат как строка списка — для аватара и обоев в шапке.
  models.Chat get chat => models.Chat(
    id: chatID,
    type: models.ChatType.private,
    title: title,
    peerUserID: peerUserID,
    avatarPath: avatarPath,
    ttlPeriod: ttl,
    secretStatus: secretStatus,
  );
}
