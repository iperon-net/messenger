import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

export 'chat_tile_cupertino.dart';
export 'chat_tile_material.dart';

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

  /// Приоритет как в Telegram: «печатает…» → черновик → последнее сообщение.
  static ChatPreview preview(Translations t, models.Chat chat) {
    final s = t.screenChats;
    if (chat.typing.isNotEmpty) {
      return ChatPreview(ChatPreviewKind.typing, chat.type == models.ChatType.private ? s.typing : s.typingName(name: chat.typing));
    }
    if (chat.draft.isNotEmpty) return ChatPreview(ChatPreviewKind.draft, chat.draft, prefix: s.draft);

    final message = chat.lastMessage;
    if (message == null) return const ChatPreview(ChatPreviewKind.message, '');
    final media = switch (message.kind) {
      models.MessageKind.text => '',
      models.MessageKind.photo => s.photo,
      models.MessageKind.video => s.video,
      models.MessageKind.file => s.file,
      models.MessageKind.voice => s.voice,
      models.MessageKind.poll => '📊 ${t.screenChat.poll}',
    };
    final text = message.text.isNotEmpty ? (message.kind == models.MessageKind.poll ? '📊 ${message.text}' : message.text) : media;
    final showSender = chat.type == models.ChatType.group || chat.type == models.ChatType.community;
    return ChatPreview(ChatPreviewKind.message, text, prefix: showSender ? message.senderName : '');
  }

  /// Иконка типа перед названием (у личных чатов нет).
  static FaIconData? typeIcon(models.Chat chat) => switch (chat.type) {
    models.ChatType.private => null,
    models.ChatType.group => FontAwesomeIcons.userGroup,
    models.ChatType.channel => FontAwesomeIcons.bullhorn,
    models.ChatType.community => FontAwesomeIcons.layerGroup,
  };

  /// Галочки исходящего: ⏱ / ✓ / ✓✓. `null` — не наше сообщение (или черновик).
  static FaIconData? statusIcon(models.Chat chat) {
    final message = chat.lastMessage;
    if (message == null || !message.outgoing || chat.draft.isNotEmpty) return null;
    return switch (message.status) {
      models.MessageStatus.pending => FontAwesomeIcons.clock,
      models.MessageStatus.sent => FontAwesomeIcons.check,
      models.MessageStatus.read => FontAwesomeIcons.checkDouble,
    };
  }

  static String badge(int count) => count > 999 ? '999+' : '$count';
}
