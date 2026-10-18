import 'dart:ui' show Color;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'message_bubble.dart' show callPreview, chatNoForwardsServiceText, chatTTLServiceText;

export 'chat_tile_cupertino.dart';
export 'chat_tile_material.dart';
export 'typing_text.dart';

/// Что показывать второй строкой в списке чатов.
enum ChatPreviewKind { message, draft, typing }

class ChatPreview {
  final ChatPreviewKind kind;

  /// Префикс: имя автора (группы/сообщества) или «Черновик:».
  final String prefix;

  final String text;

  const ChatPreview(this.kind, this.text, {this.prefix = ''});
}

/// Общая для Cupertino и Material логика строки списка чатов — оформление в
/// `ChatTileCupertino` / `ChatTileMaterial`.
abstract final class ChatTileContent {
  static String title(Translations t, models.Chat chat) =>
      chat.isSelf ? t.screenChats.savedMessages : (chat.isThread ? t.screenChat.commentsTitle : chat.title);

  /// «печатает…» / «Анна отправляет фото…» / «Анна и Олег печатают…»; пусто
  /// — никто ничего не делает. Общее для строки списка и шапки чата.
  static String typing(Translations t, models.Chat chat) {
    final s = t.screenChats;
    final typing = chat.typing;
    if (typing.isEmpty) return '';
    if (typing.length > 2) return s.typingMany(n: typing.length);
    if (typing.length == 2) return s.typingTwo(first: typing[0].name, second: typing[1].name);
    final one = typing.single;
    // Личный чат — без имени: собеседник один и он в шапке.
    final name = chat.type == models.ChatType.private || one.name.isEmpty ? null : one.name;
    return switch (one.activity) {
      models.ChatActivity.typing => name == null ? s.typing : s.typingName(name: name),
      models.ChatActivity.recordVoice => name == null ? s.recordingVoice : s.recordingVoiceName(name: name),
      models.ChatActivity.uploadPhoto => name == null ? s.sendingPhoto : s.sendingPhotoName(name: name),
      models.ChatActivity.uploadVideo => name == null ? s.sendingVideo : s.sendingVideoName(name: name),
      models.ChatActivity.uploadFile => name == null ? s.sendingFile : s.sendingFileName(name: name),
    };
  }

  /// Приоритет как в Telegram: «печатает…» → черновик → последнее сообщение.
  static ChatPreview preview(Translations t, models.Chat chat) {
    final s = t.screenChats;
    if (chat.typing.isNotEmpty) return ChatPreview(ChatPreviewKind.typing, typing(t, chat));
    if (chat.draft.isNotEmpty) return ChatPreview(ChatPreviewKind.draft, chat.draft, prefix: s.draft);

    final message = chat.lastMessage;
    if (message == null) {
      // Пустой секретный чат — его состояние (как в Telegram).
      if (chat.secretStatus case final status?) {
        final ts = t.secretChat;
        return ChatPreview(ChatPreviewKind.message, switch (status) {
          models.SecretChatStatus.waiting => ts.waitingFor(name: chat.title),
          models.SecretChatStatus.ready => ts.created,
          models.SecretChatStatus.closed => ts.closed,
        });
      }
      // Пустое «Избранное» — подсказка вместо пустой строки.
      return ChatPreview(ChatPreviewKind.message, chat.isSelf ? s.savedMessagesEmpty : '');
    }
    // «Изменил автоудаление» — как плашка в ленте; собеседник — по названию чата.
    if (message.noForwardsChange != null || message.noForwardsRequest) {
      final text = chatNoForwardsServiceText(
        t,
        change: message.noForwardsChange,
        prev: message.noForwardsPrev,
        refusal: message.noForwardsChange == message.noForwardsPrev,
        outgoing: message.outgoing,
        name: chat.title,
      );
      return ChatPreview(ChatPreviewKind.message, text);
    }
    if (message.ttlChange case final period?) {
      return ChatPreview(ChatPreviewKind.message, chatTTLServiceText(t, period: period, outgoing: message.outgoing, name: chat.title));
    }
    // «Закрепил сообщение» — как плашка в ленте; собеседник — по названию чата.
    if (message.pin) {
      final tc = t.screenChat;
      final text = message.outgoing
          ? (message.pinText.isEmpty ? tc.pinnedServiceYouMessage : tc.pinnedServiceYou(text: message.pinText))
          : (message.pinText.isEmpty
                ? tc.pinnedServiceMessage(name: chat.title)
                : tc.pinnedService(name: chat.title, text: message.pinText));
      return ChatPreview(ChatPreviewKind.message, text);
    }
    final media = switch (message.kind) {
      models.MessageKind.text => '',
      models.MessageKind.photo => s.photo,
      models.MessageKind.video => s.video,
      models.MessageKind.file => s.file,
      models.MessageKind.voice => s.voice,
      models.MessageKind.poll => '📊 ${t.screenChat.poll}',
      models.MessageKind.call => message.phoneCall == null ? '' : callPreview(t, outgoing: message.outgoing, call: message.phoneCall!),
    };
    final text = message.text.isNotEmpty ? (message.kind == models.MessageKind.poll ? '📊 ${message.text}' : message.text) : media;
    final showSender = chat.type == models.ChatType.group || chat.type == models.ChatType.community;
    // Сообщество: из какого его чата — «Группа › Анна».
    final prefix = [
      if (message.chatTitle.isNotEmpty) message.chatTitle,
      if (showSender && message.senderName.isNotEmpty) message.senderName,
    ];
    return ChatPreview(ChatPreviewKind.message, text, prefix: prefix.join(' › '));
  }

  /// Цвет замка и названия секретного чата (как в Telegram — зелёный).
  static const secretColor = Color(0xFF34C759);

  /// Иконка типа перед названием (у личных чатов нет).
  static FaIconData? typeIcon(models.Chat chat) => switch (chat.type) {
    _ when chat.isSecret => FontAwesomeIcons.lock,
    models.ChatType.private => null,
    models.ChatType.group => FontAwesomeIcons.userGroup,
    models.ChatType.channel => FontAwesomeIcons.bullhorn,
    models.ChatType.community => FontAwesomeIcons.layerGroup,
  };

  /// Галочки исходящего: ⏱ / ✓ / ✓✓. `null` — не наше сообщение (или черновик).
  static FaIconData? statusIcon(models.Chat chat) {
    final message = chat.lastMessage;
    // У звонка и «закрепил сообщение» галочек нет (как в Telegram).
    if (message == null || !message.outgoing || chat.draft.isNotEmpty || message.kind == models.MessageKind.call || message.pin) {
      return null;
    }
    return switch (message.status) {
      models.MessageStatus.pending => FontAwesomeIcons.clock,
      models.MessageStatus.sent => FontAwesomeIcons.check,
      models.MessageStatus.read => FontAwesomeIcons.checkDouble,
      models.MessageStatus.failed => FontAwesomeIcons.circleExclamation,
    };
  }

  static String badge(int count) => count > 999 ? '999+' : '$count';
}
