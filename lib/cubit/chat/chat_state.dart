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

  const ChatState({this.status = Status.initialization, this.chat, this.messages = const [], this.reply, this.editing});
}
