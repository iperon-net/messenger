import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chats/secret/secret_chats_list.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_common.dart';

/// Общее для окна секретного чата и его экрана ключа (Cupertino + Material).

/// Куда открывать строку списка чатов: секретный — своё окно.
String chatRoute(models.Chat chat) =>
    chat.isSecret ? '/chats/secret/${chat.id.substring(secretChatIDPrefix.length)}' : '/chats/chat/${chat.id}';

/// Последнее в группе подряд идущих от одного автора — у пузыря «хвостик».
/// [messages] — по времени, старые первыми.
bool secretBubbleTail(List<models.Message> messages, int index) =>
    index == messages.length - 1 || messages[index + 1].outgoing != messages[index].outgoing;

/// Скрепка: фото / видео из галереи или файл → превью с подписью (сжатие —
/// как в обычных чатах) → отправка. Каждое вложение — отдельным сообщением,
/// подпись — у первого; текст из поля ввода [input] переносится в подпись.
Future<void> pickSecretAttachments(BuildContext context, {TextEditingController? input}) async {
  final cubit = context.read<SecretChatCubit>();
  final result = await showToolbarAttachments(
    context,
    tabs: const [ToolbarAttachmentTabKind.gallery, ToolbarAttachmentTabKind.file],
    media: ToolbarAttachmentMediaType.all,
    multiSelect: true,
  );
  final items = switch (result) {
    ToolbarAttachmentImageResult(:final file, :final source) => [
      attachmentDraft(file.path, asFile: source == ToolbarAttachmentTabKind.file),
    ],
    ToolbarAttachmentMultiImageResult(:final files, :final source) => [
      for (final file in files) attachmentDraft(file.path, asFile: source == ToolbarAttachmentTabKind.file),
    ],
    ToolbarAttachmentEmojiResult() || ToolbarAttachmentLinkResult() || ToolbarAttachmentPollResult() || null => const <AttachmentDraft>[],
  };
  if (items.isEmpty || !context.mounted) return;
  final prepared = await prepareAttachmentDrafts(context, items, input: input);
  if (prepared == null) return;
  await cubit.sendMedia(media: prepared.media, files: [for (final file in prepared.files) file.path], caption: prepared.caption);
}

/// Тап по вложению: файл — открыть, фото / видео — просмотр без «Сохранить /
/// Поделиться» (как с защитой содержимого).
Future<void> openSecretMedia(BuildContext context, SecretChatState state, models.Message message, int index) {
  if (message.kind == models.MessageKind.file) return openChatFile(context, message);
  return showChatMediaViewer(context, messages: state.messages, message: message, index: index, chatTitle: state.title, noForwards: true);
}

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
