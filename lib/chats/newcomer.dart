// «Новичкам — без ссылок и медиа» (см. docs/plans/chats-groups-channels.md,
// «Антиспам»): только что вступившие пишут только текст — так спам-бот не
// может сразу прийти со ссылкой или картинкой.

import '../models.dart' as models;
import 'message_formatting.dart';

/// Голый домен без `https://` / `www.` («promo.ru/x», «сайт.рф») — в ленте он
/// не кликабелен, но спамеры пишут именно так. Только популярные зоны, чтобы
/// «node.js» и «т.е.» не считались ссылкой.
final _bareDomain = RegExp(
  r'(?<![\p{L}\p{N}_.@-])[\p{L}\p{N}-]+(?:\.[\p{L}\p{N}-]+)*\.'
  r'(?:com|net|org|info|biz|pro|ru|su|рф|io|me|ly|gg|cc|co|to|tv|ws|xyz|top|site|online|shop|store|club|link|app|dev|vip|win|bet|casino)'
  r'(?![\p{L}\p{N}_-])',
  caseSensitive: false,
  unicode: true,
);

/// Текст без ссылок: явных `[текст](url)`, найденных в тексте (`https://…`,
/// `www.…`) и голых доменов.
bool isLinkFree(String text, List<models.MessageEntity> entities) => firstLinkUrl(text, entities) == null && !_bareDomain.hasMatch(text);

/// Сообщение, которое новичок может отправить / переслать: текст без ссылок.
bool newcomerAllows(models.Message message) => message.kind == models.MessageKind.text && isLinkFree(message.text, message.entities);
