import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart' as models;

part 'chat_state.mapper.dart';

/// Почему нельзя писать: ветка закрыта (срок поста вышел / админ закрыл),
/// канал «только подписчики», а мы не подписаны, или подписаны меньше
/// `Chat.commentsMinSubscription`; [privacy] — личный чат, собеседник
/// ограничил, кто может ему писать.
@MappableEnum()
enum ChatCommentsBlock { none, closed, subscribe, wait, privacy }

/// Состояние окна чата: сам чат (шапка, «печатает…»), его сообщения и режим
/// поля ввода (ответ / редактирование).
@MappableClass()
class ChatState with ChatStateMappable {
  final Status status;

  /// Чат из списка; `null` — не найден (удалён или демо выключено).
  final models.Chat? chat;

  /// От старых к новым.
  final List<models.Message> messages;

  /// Сообщество: его чаты — канал объявлений первым, затем группы и каналы
  /// (и те, где мы не участник).
  final List<models.Chat> communityChats;

  /// Группа / канал сообщества: само сообщество.
  final models.Chat? community;

  /// Отвечаем на это сообщение — над полем ввода плашка с цитатой.
  final models.Message? reply;

  /// Отвечаем не на всё [reply], а на его фрагмент («Цитировать»).
  final models.MessageQuote? replyQuote;

  /// Редактируем это сообщение — поле ввода заполнено его текстом.
  final models.Message? editing;

  /// Первое непрочитанное на момент открытия чата — над ним разделитель
  /// «Непрочитанные сообщения», к нему лента прокручивается при открытии.
  final String? unreadFromID;

  /// Режим выделения: отмеченные сообщения (по id); вместо поля ввода —
  /// «Удалить / Копировать / Переслать».
  final bool selecting;
  final List<String> selectedIDs;

  /// Пересылаемые в этот чат сообщения — плашка над полем ввода, уходят по
  /// «Отправить» (после текста, если он есть).
  final List<models.Message> forwarding;

  /// Поиск по чату (удержание шапки): строка поиска вместо шапки, внизу —
  /// «N из M» и стрелки.
  final bool searching;
  final String searchQuery;

  /// Найденные сообщения — id, от новых к старым.
  final List<String> searchResults;

  /// Текущее найденное — индекс в [searchResults].
  final int searchIndex;

  /// Отложенные сообщения («Отправить позже») — от ранних к поздним; есть —
  /// в поле ввода значок календаря.
  final List<models.Message> scheduled;

  /// × на превью ссылки над полем ввода — отправить без превью (до отправки).
  final bool linkPreviewDisabled;

  /// «Известные» участники: владелец, админы, мы и недавно активные — для
  /// прав, упоминаний и выбора (см. `ChatCubit.loadMembers`).
  final List<models.ChatMember> members;

  /// Список «Участники» в профиле — загруженные страницы (см.
  /// `ChatCubit.loadMemberPage`); [memberPageMore] — есть ещё,
  /// [memberPageLoading] — грузится, [membersTotal] — всего.
  final List<models.ChatMember> memberPage;
  final bool memberPageMore;
  final bool memberPageLoading;
  final int membersTotal;

  /// Поиск по «Участникам» (пусто — весь список).
  final String memberQuery;

  /// Заблокированные в группе — для админа (профиль → «Заблокированные»).
  final List<models.ChatMember> banned;

  /// Медленный режим: секунд до следующего сообщения (0 — можно отправлять);
  /// тикает раз в секунду, вместо кнопки отправки — обратный отсчёт.
  final int slowModeLeft;

  /// Лимит частоты отправки на сервере (флуд): секунд до следующего сообщения
  /// (0 — можно). Как [slowModeLeft], но для всех чатов сразу и только для
  /// серверных: outbox стоит и сам отправит, когда отсчёт кончится.
  final int floodLeft;

  /// Канал: посты (id), комментарии к которым уже закрыты (срок вышел или
  /// админ закрыл) — под постом замок, ветка только для чтения.
  final List<String> commentsClosedIDs;

  /// Ветка комментариев: почему нам нельзя писать (вместо поля ввода —
  /// плашка); [ChatCommentsBlock.none] — можно / не ветка.
  final ChatCommentsBlock commentsBlock;

  /// [ChatCommentsBlock.wait]: с какого момента можно комментировать.
  final DateTime? commentsWaitUntil;

  /// «Новичкам — без ссылок и медиа» действует на нас: только текст (без
  /// ссылок, медиа, файлов, голосовых, опросов). [newcomerUntil] — до когда
  /// (`null` при [newcomerRestricted] — пока не подпишемся на канал ветки).
  final bool newcomerRestricted;
  final DateTime? newcomerUntil;

  /// Растёт, когда действие не выполнено из-за отсутствия сети
  /// (`ChatsOfflineException`): экран показывает «Нет соединения».
  final int offlineNotice;

  const ChatState({
    this.status = Status.initialization,
    this.offlineNotice = 0,
    this.chat,
    this.messages = const [],
    this.communityChats = const [],
    this.community,
    this.reply,
    this.replyQuote,
    this.editing,
    this.unreadFromID,
    this.selecting = false,
    this.selectedIDs = const [],
    this.forwarding = const [],
    this.searching = false,
    this.searchQuery = '',
    this.searchResults = const [],
    this.searchIndex = 0,
    this.scheduled = const [],
    this.linkPreviewDisabled = false,
    this.members = const [],
    this.memberPage = const [],
    this.memberPageMore = false,
    this.memberPageLoading = false,
    this.membersTotal = 0,
    this.memberQuery = '',
    this.banned = const [],
    this.slowModeLeft = 0,
    this.floodLeft = 0,
    this.commentsClosedIDs = const [],
    this.commentsBlock = ChatCommentsBlock.none,
    this.commentsWaitUntil,
    this.newcomerRestricted = false,
    this.newcomerUntil,
  });

  /// Писать в ветку нельзя (закрыта / не подписаны / мало подписаны).
  bool get commentsBlocked => commentsBlock != ChatCommentsBlock.none;

  /// Закреплённые — от новых к старым (плашка показывает сначала последнее).
  List<models.Message> get pinnedMessages => [
    for (final m in messages.reversed)
      if (m.pinned && !m.service) m,
  ];

  /// Отмеченные сообщения — в порядке ленты (от старых к новым).
  List<models.Message> get selectedMessages => [
    for (final m in messages)
      if (selectedIDs.contains(m.id)) m,
  ];

  String? get searchCurrentID => searchResults.isEmpty ? null : searchResults[searchIndex.clamp(0, searchResults.length - 1)];
}
