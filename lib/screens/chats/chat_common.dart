import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'media_caption_cupertino.dart';
import 'media_caption_material.dart';

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

/// Выбранное вложение до отправки: путь и тип (фото / видео / файл).
class AttachmentDraft {
  final String path;
  final models.MessageKind kind;

  const AttachmentDraft(this.path, this.kind);

  bool get isMedia => kind == models.MessageKind.photo || kind == models.MessageKind.video;
}

/// Скрепка: фото/видео из галереи, камера или файл → превью с подписью →
/// отправка. Несколько фото/видео уходят альбомом (по [models.Message.maxAlbum]
/// в сообщении), файлы — отдельными сообщениями. Подпись — у первого
/// сообщения; текст из поля ввода [input] переносится в подпись (как в Telegram).
Future<void> pickAndSendAttachments(BuildContext context, {TextEditingController? input}) async {
  final cubit = context.read<ChatCubit>();
  final result = await showToolbarAttachments(
    context,
    tabs: const [ToolbarAttachmentTabKind.gallery, ToolbarAttachmentTabKind.camera, ToolbarAttachmentTabKind.file],
    media: ToolbarAttachmentMediaType.all,
    multiSelect: true,
  );
  final items = switch (result) {
    ToolbarAttachmentImageResult(:final file, :final source) => [_draft(file.path, asFile: source == ToolbarAttachmentTabKind.file)],
    ToolbarAttachmentMultiImageResult(:final files) => [for (final file in files) _draft(file.path)],
    ToolbarAttachmentEmojiResult() || ToolbarAttachmentLinkResult() || null => const <AttachmentDraft>[],
  };
  if (items.isEmpty || !context.mounted) return;

  final initial = input?.text ?? '';
  final caption = Platform.isIOS
      ? await showMediaCaptionCupertino(context, items, initialCaption: initial)
      : await showMediaCaptionMaterial(context, items, initialCaption: initial);
  if (caption == null) return;
  // Текст из поля ввода ушёл в подпись.
  if (initial.isNotEmpty) input?.clear();

  var pending = caption;
  String takeCaption() {
    final value = pending;
    pending = '';
    return value;
  }

  final media = items.where((i) => i.isMedia).toList();
  for (var start = 0; start < media.length; start += models.Message.maxAlbum) {
    final chunk = media.sublist(start, math.min(start + models.Message.maxAlbum, media.length));
    if (chunk.length == 1) {
      await cubit.sendMedia(
        kind: chunk.single.kind,
        localPath: chunk.single.path,
        fileName: p.basename(chunk.single.path),
        caption: takeCaption(),
      );
    } else {
      await cubit.sendMedia(
        kind: chunk.every((i) => i.kind == models.MessageKind.video) ? models.MessageKind.video : models.MessageKind.photo,
        media: [for (final i in chunk) models.MessageMedia(kind: i.kind, localPath: i.path)],
        caption: takeCaption(),
      );
    }
  }
  for (final file in items.where((i) => !i.isMedia)) {
    await cubit.sendMedia(kind: file.kind, localPath: file.path, fileName: p.basename(file.path), caption: takeCaption());
  }
}

const _videoExtensions = {'.mp4', '.mov', '.m4v', '.3gp', '.webm', '.mkv'};
const _imageExtensions = {'.jpg', '.jpeg', '.png', '.heic', '.heif', '.webp', '.gif'};

AttachmentDraft _draft(String path, {bool asFile = false}) {
  final ext = p.extension(path).toLowerCase();
  final kind = asFile && !_imageExtensions.contains(ext)
      ? models.MessageKind.file
      : _videoExtensions.contains(ext)
      ? models.MessageKind.video
      : _imageExtensions.contains(ext)
      ? models.MessageKind.photo
      : models.MessageKind.file;
  return AttachmentDraft(path, kind);
}

/// Миниатюра вложения в превью перед отправкой.
class AttachmentThumb extends StatelessWidget {
  final AttachmentDraft item;
  final double size;

  const AttachmentThumb({super.key, required this.item, required this.size});

  @override
  Widget build(BuildContext context) {
    final Widget child = switch (item.kind) {
      models.MessageKind.photo => Image.file(File(item.path), fit: BoxFit.cover, cacheWidth: (size * 3).round()),
      _ => ColoredBox(
        color: const Color(0xFF3A3A3C),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              item.kind == models.MessageKind.video ? FontAwesomeIcons.circlePlay : FontAwesomeIcons.solidFile,
              size: 26,
              color: const Color(0xCCFFFFFF),
            ),
            if (item.kind == models.MessageKind.file)
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                child: Text(
                  p.basename(item.path),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: Color(0xCCFFFFFF)),
                ),
              ),
          ],
        ),
      ),
    };
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(width: size, height: size, child: child),
    );
  }
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
