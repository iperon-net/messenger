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

  /// Поиск по чату (удержание шапки): строка поиска вместо шапки, внизу —
  /// «N из M» и стрелки.
  final bool searching;
  final String searchQuery;

  /// Найденные сообщения — id, от новых к старым.
  final List<String> searchResults;

  /// Текущее найденное — индекс в [searchResults].
  final int searchIndex;

  const ChatState({
    this.status = Status.initialization,
    this.chat,
    this.messages = const [],
    this.reply,
    this.editing,
    this.searching = false,
    this.searchQuery = '',
    this.searchResults = const [],
    this.searchIndex = 0,
  });

  String? get searchCurrentID => searchResults.isEmpty ? null : searchResults[searchIndex.clamp(0, searchResults.length - 1)];
}
