import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart' as models;

part 'chat_state.mapper.dart';

/// Состояние окна чата: сам чат (шапка, «печатает…»), его сообщения и режим
/// поля ввода (ответ / редактирование).
@MappableClass()
class ChatState with ChatStateMappable {
  final Status status;

  /// Чат из списка; `null` — не найден (удалён или демо выключено).
  final models.Chat? chat;

  /// От старых к новым.
  final List<models.Message> messages;

  /// Отвечаем на это сообщение — над полем ввода плашка с цитатой.
  final models.Message? reply;

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

  const ChatState({
    this.status = Status.initialization,
    this.chat,
    this.messages = const [],
    this.reply,
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
  });

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
