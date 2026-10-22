import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;

import '../../chats/edit_media.dart';
import '../../chats/media_prepare.dart' show thumbhashToBmp;
import '../../chats/video_prepare.dart' show ChatVideoCancelled;
import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_common.dart';

/// Скрепка в режиме «Изменить» (как в Telegram): у текстового — добавить фото /
/// видео (альбомом до лимита) или файл, у одиночного — заменить его, у
/// альбома — заменить элемент [index] (тап по миниатюре в шапке правки;
/// без него — подсказка, что выбрать). Новое — в превью над полем ввода, на
/// сервер уходит по «Сохранить».
Future<void> pickEditAttachments(BuildContext context, {int index = -1}) async {
  final cubit = context.read<ChatCubit>();
  final editing = cubit.state.editing;
  if (editing == null || !cubit.canEditMedia) return;
  final t = context.t.screenChat;
  final mode = editMediaMode(editing);
  if (mode == EditMediaMode.album && index < 0) return showChatToast(context, t.editMediaAlbumHint);
  if (!checkNewcomer(context, media: true)) return;
  final result = await showToolbarAttachments(
    context,
    // В альбом — только фото и видео.
    tabs: [ToolbarAttachmentTabKind.gallery, if (mode != EditMediaMode.album) ToolbarAttachmentTabKind.file],
    media: ToolbarAttachmentMediaType.all,
    multiSelect: mode == EditMediaMode.add,
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
  if (mode == EditMediaMode.album && !items.any((i) => i.isMedia)) return showChatToast(context, t.editMediaAlbumOnlyMedia);
  final List<models.MessageMedia> prepared;
  try {
    prepared = await prepareEditAttachments(context, items);
  } on ChatVideoCancelled {
    return;
  }
  if (!context.mounted) return;
  final picked = cubit.addEditMedia(prepared, index: mode == EditMediaMode.album ? index : 0);
  if (picked == null) return;
  if (picked.rejected) {
    showChatToast(context, t.editMediaAlbumOnlyMedia);
  } else if (picked.truncated) {
    showChatToast(context, t.editMediaLimit(n: models.Message.maxAlbum));
  }
}

/// Правка сообщения с вложениями (или с новыми): «Сохранить» и с пустым
/// текстом — подпись может быть пустой.
bool editCaptionMayBeEmpty(ChatState state) {
  final editing = state.editing;
  return editing != null && (state.editMedia != null || messageMediaCount(editing) > 0);
}

/// Цвета [EditMediaStrip] — от платформы.
class EditMediaStripStyle {
  final Color accent;
  final Color secondary;
  final Color placeholder;

  const EditMediaStripStyle({required this.accent, required this.secondary, required this.placeholder});
}

/// Шапка правки с вложениями (над полем ввода, под «Редактирование»):
/// миниатюры итогового списка. Исходное — тап заменяет (у альбома — этот
/// элемент), новое — с акцентной рамкой и ×, который отменяет замену /
/// убирает добавленное. Пока правка сохраняется — полоса загрузки.
class EditMediaStrip extends StatelessWidget {
  final ChatState state;
  final EditMediaStripStyle style;

  const EditMediaStrip({super.key, required this.state, required this.style});

  static const _size = 52.0;

  @override
  Widget build(BuildContext context) {
    final editing = state.editing;
    if (editing == null) return const SizedBox.shrink();
    final count = messageMediaCount(editing);
    final draft = state.editMedia ?? const models.EditMedia();
    final progress = state.editUploadProgress;
    final canPick = context.read<ChatCubit>().canEditMedia;
    // У текстового без добавленного и у того, что не меняется, — нечего показать.
    if ((count == 0 && draft.isEmpty) || (!canPick && progress == null && draft.isEmpty)) return const SizedBox.shrink();
    final t = context.t.screenChat;
    final slots = editMediaSlots(count, draft);
    final busy = progress != null;

    Widget tile(int i, EditMediaSlot slot) {
      final fresh = slot.fresh;
      final Widget thumb = fresh != null ? _freshThumb(fresh) : _originalThumb(editing, slot.original);
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: SizedBox(
          width: _size,
          height: _size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  // Тап по исходному (и по уже заменённому) — заменить на другое.
                  onTap: busy || !canPick || i >= count ? null : () => pickEditAttachments(context, index: i),
                  child: Semantics(
                    button: i < count,
                    label: i < count ? t.editMediaReplaceItem : null,
                    child: DecoratedBox(
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: fresh != null ? Border.all(color: style.accent, width: 2) : null,
                      ),
                      child: ClipRRect(borderRadius: BorderRadius.circular(8), child: thumb),
                    ),
                  ),
                ),
              ),
              if (fresh == null && canPick && !busy && i < count)
                const Positioned(right: 3, bottom: 3, child: _Badge(icon: FontAwesomeIcons.arrowsRotate)),
              if (fresh != null && !busy)
                Positioned(
                  right: -4,
                  top: -4,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => i < count
                        ? context.read<ChatCubit>().removeEditMedia(replaced: i)
                        : context.read<ChatCubit>().removeEditMedia(added: i - count),
                    child: Semantics(
                      button: true,
                      label: t.editMediaUndo,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(color: style.accent, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: const FaIcon(FontAwesomeIcons.xmark, size: 11, color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: _size + 4,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 4, right: 4),
              children: [for (final (i, slot) in slots.indexed) tile(i, slot)],
            ),
          ),
          if (progress != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(
                  height: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(color: style.accent.withValues(alpha: 0.2)),
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: ColoredBox(color: style.accent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _freshThumb(models.MessageMedia media) => switch (media.kind) {
    models.MessageKind.photo when media.localPath.isNotEmpty => Image.file(File(media.localPath), fit: BoxFit.cover, cacheWidth: 160),
    models.MessageKind.video when media.thumbPath.isNotEmpty => _video(
      Image.file(File(media.thumbPath), fit: BoxFit.cover, cacheWidth: 160),
    ),
    models.MessageKind.photo ||
    models.MessageKind.video => chatMediaPlaceholder(media.localPath, video: media.kind == models.MessageKind.video, iconSize: 18),
    _ => _file(p.basename(media.localPath)),
  };

  Widget _originalThumb(models.Message message, int index) {
    if (message.media.isEmpty) {
      return message.kind == models.MessageKind.file
          ? _file(message.fileName)
          : chatMediaPlaceholder(message.id, video: message.kind == models.MessageKind.video, iconSize: 18);
    }
    final media = message.media[index];
    final video = media.kind == models.MessageKind.video;
    final path = video ? media.thumbPath : media.localPath;
    final Widget image;
    if (path.isNotEmpty) {
      image = ChatMediaImage(path: path, thumbhash: media.thumbhash, cacheWidth: 160);
    } else {
      final preview = thumbhashToBmp(media.thumbhash);
      image = preview != null
          ? Image.memory(preview, fit: BoxFit.cover, gaplessPlayback: true)
          : chatMediaPlaceholder('${message.id}-$index', video: video, iconSize: 18);
    }
    return video ? _video(image) : image;
  }

  Widget _video(Widget image) => Stack(
    fit: StackFit.expand,
    children: [
      image,
      const Center(child: FaIcon(FontAwesomeIcons.circlePlay, size: 18, color: Color(0xE6FFFFFF))),
    ],
  );

  Widget _file(String name) => ColoredBox(
    color: style.placeholder,
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.solidFile, size: 16, color: style.secondary),
          const SizedBox(height: 2),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 9, color: style.secondary),
          ),
        ],
      ),
    ),
  );
}

/// Значок «заменить» на миниатюре исходного вложения.
class _Badge extends StatelessWidget {
  final FaIconData icon;

  const _Badge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(color: Color(0x99000000), shape: BoxShape.circle),
      alignment: Alignment.center,
      child: FaIcon(icon, size: 9, color: const Color(0xFFFFFFFF)),
    );
  }
}
