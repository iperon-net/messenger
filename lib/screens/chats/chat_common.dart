import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Общее для окна чата на обеих платформах (`chat_cupertino.dart` /
/// `chat_material.dart`).

/// Подзаголовок шапки: «печатает…», «был(а) недавно», «N участников» /
/// «N подписчиков». Счётчики в демо — псевдослучайные, стабильные по id.
({String text, bool active}) chatSubtitle(Translations t, models.Chat chat) {
  if (chat.typing.isNotEmpty) {
    return (text: chat.type == models.ChatType.private ? t.screenChats.typing : t.screenChats.typingName(name: chat.typing), active: true);
  }
  final seed = chat.id.hashCode.abs();
  return switch (chat.type) {
    models.ChatType.private when chat.isSelf => (text: '', active: false),
    models.ChatType.private => (text: t.screenChat.lastSeenRecently, active: false),
    models.ChatType.group || models.ChatType.community => (text: t.screenChat.members(n: 3 + seed % 60), active: false),
    models.ChatType.channel => (text: t.screenChat.subscribers(n: 1200 + seed % 90000), active: false),
  };
}

/// Скрепка: фото/видео из галереи, камера или файл → отправка в чат.
Future<void> pickAndSendAttachments(BuildContext context) async {
  final cubit = context.read<ChatCubit>();
  final result = await showToolbarAttachments(
    context,
    tabs: const [ToolbarAttachmentTabKind.gallery, ToolbarAttachmentTabKind.camera, ToolbarAttachmentTabKind.file],
    media: ToolbarAttachmentMediaType.all,
    multiSelect: true,
  );
  switch (result) {
    case ToolbarAttachmentImageResult(:final file, :final source):
      await _send(cubit, file.path, asFile: source == ToolbarAttachmentTabKind.file);
    case ToolbarAttachmentMultiImageResult(:final files):
      for (final file in files) {
        await _send(cubit, file.path);
      }
    case ToolbarAttachmentEmojiResult() || ToolbarAttachmentLinkResult() || null:
      break;
  }
}

const _videoExtensions = {'.mp4', '.mov', '.m4v', '.3gp', '.webm', '.mkv'};
const _imageExtensions = {'.jpg', '.jpeg', '.png', '.heic', '.heif', '.webp', '.gif'};

Future<void> _send(ChatCubit cubit, String path, {bool asFile = false}) async {
  final ext = p.extension(path).toLowerCase();
  final kind = asFile && !_imageExtensions.contains(ext)
      ? models.MessageKind.file
      : _videoExtensions.contains(ext)
      ? models.MessageKind.video
      : _imageExtensions.contains(ext)
      ? models.MessageKind.photo
      : models.MessageKind.file;
  await cubit.sendMedia(kind: kind, localPath: path, fileName: p.basename(path));
}

/// Плашка над полем ввода: «Ответ Анне: …» / «Редактирование: …».
({String title, String text})? composeBanner(Translations t, ChatState state) {
  final message = state.editing ?? state.reply;
  if (message == null) return null;
  final text = message.text.isNotEmpty ? message.text : messageKindLabel(t, message.kind);
  if (state.editing != null) return (title: t.screenChat.editing, text: text.replaceAll('\n', ' '));
  final name = message.outgoing ? t.screenChat.you : (message.senderName.isNotEmpty ? message.senderName : state.chat?.title ?? '');
  return (title: name, text: text.replaceAll('\n', ' '));
}
