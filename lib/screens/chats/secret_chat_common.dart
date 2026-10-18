import 'package:flutter/widgets.dart';

import '../../chats/secret/secret_chats_list.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Общее для окна секретного чата и его экрана ключа (Cupertino + Material).

/// Куда открывать строку списка чатов: секретный — своё окно.
String chatRoute(models.Chat chat) =>
    chat.isSecret ? '/chats/secret/${chat.id.substring(secretChatIDPrefix.length)}' : '/chats/chat/${chat.id}';

/// Последнее в группе подряд идущих от одного автора — у пузыря «хвостик».
/// [messages] — по времени, старые первыми.
bool secretBubbleTail(List<models.Message> messages, int index) =>
    index == messages.length - 1 || messages[index + 1].outgoing != messages[index].outgoing;

/// Подзаголовок шапки / текст вместо поля ввода по состоянию чата.
String secretChatStatusText(Translations t, models.SecretChatStatus status, String name) => switch (status) {
  models.SecretChatStatus.waiting => t.secretChat.waitingFor(name: name),
  models.SecretChatStatus.ready => t.secretChat.title,
  models.SecretChatStatus.closed => t.secretChat.closed,
};

/// Отпечаток ключа: крупные эмодзи и hex по 8 символов в 4 строки (как
/// «Ключ шифрования» в Telegram), моноширинным.
class SecretChatFingerprintView extends StatelessWidget {
  final List<String> emoji;
  final String hex;
  final Color hexColor;

  const SecretChatFingerprintView({super.key, required this.emoji, required this.hex, required this.hexColor});

  @override
  Widget build(BuildContext context) {
    final groups = [for (var i = 0; i + 8 <= hex.length; i += 8) hex.substring(i, i + 8)];
    final lines = [for (var i = 0; i < groups.length; i += 2) groups.skip(i).take(2).join('  ')];
    return Column(
      children: [
        Text(emoji.join('  '), style: const TextStyle(fontSize: 40), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        for (final line in lines)
          Text(
            line.toUpperCase(),
            style: TextStyle(fontFamily: 'Courier', fontSize: 17, letterSpacing: 1.5, color: hexColor),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
