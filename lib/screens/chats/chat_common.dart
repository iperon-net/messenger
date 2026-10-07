import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart' as m;
import 'package:path/path.dart' as p;

import '../../chats/media_prepare.dart';
import '../../chats/message_formatting.dart';
import '../../chats/video_prepare.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../demo/chats_demo_data_source.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_create_common.dart';
import 'chat_info_common.dart';
import 'media_caption_cupertino.dart';
import 'media_caption_material.dart';
import 'poll_create_cupertino.dart';
import 'poll_create_material.dart';

/// Общее для окна чата на обеих платформах (`chat_cupertino.dart` /
/// `chat_material.dart`).

/// Подзаголовок шапки: «печатает…», «был(а) недавно», «N участников» /
/// «N подписчиков». Счётчики в демо — псевдослучайные, стабильные по id.
({String text, bool active}) chatSubtitle(Translations t, models.Chat chat) {
  if (chat.typing.isNotEmpty) {
    return (text: chat.type == models.ChatType.private ? t.screenChats.typing : t.screenChats.typingName(name: chat.typing), active: true);
  }
  // Комментарии к посту — название канала под «Комментарии».
  if (chat.isThread) return (text: chat.title, active: false);
  final seed = chat.id.hashCode.abs();
  final count = chat.membersCount > 0 ? chat.membersCount : (chat.type == models.ChatType.channel ? 1200 + seed % 90000 : 3 + seed % 60);
  return switch (chat.type) {
    models.ChatType.private when chat.isSelf => (text: '', active: false),
    models.ChatType.private => chatPresence(t, chat),
    models.ChatType.group || models.ChatType.community => (text: t.screenChat.members(n: count, count: count.grouped), active: false),
    models.ChatType.channel => (text: t.screenChat.subscribers(n: count, count: count.grouped), active: false),
  };
}

/// Опрос: «Отменить голос» — проголосовали, не викторина, не завершён.
bool canRetractVote(models.Message message) {
  final poll = message.poll;
  return poll != null && poll.voted && !poll.quiz && !poll.closed;
}

/// Опрос: «Завершить опрос» — автор или админ, пока не завершён.
bool canClosePoll(models.Chat chat, models.Message message) {
  final poll = message.poll;
  return poll != null && !poll.closed && (message.outgoing || chat.canManage);
}

/// «Завершить опрос?» — `true`, если подтвердили.
Future<bool> confirmClosePoll(BuildContext context) async {
  final t = context.t.screenChat;
  if (Platform.isIOS) {
    return await c.showCupertinoDialog<bool>(
          context: context,
          builder: (dialogContext) => c.CupertinoAlertDialog(
            title: Text(t.closePollTitle),
            content: Text(t.closePollMessage),
            actions: [
              c.CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
              c.CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(t.closePoll),
              ),
            ],
          ),
        ) ??
        false;
  }
  return await m.showDialog<bool>(
        context: context,
        builder: (dialogContext) => m.AlertDialog(
          title: Text(t.closePollTitle),
          content: Text(t.closePollMessage),
          actions: [
            m.TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
            m.TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.closePoll)),
          ],
        ),
      ) ??
      false;
}

/// Открытый опрос: «кто за что» — по вариантам, имена проголосовавших.
Future<void> showPollVoters(BuildContext context, models.MessagePoll poll) {
  final t = context.t.screenChat;
  Widget body(BuildContext sheetContext, Color secondary) => ListView(
    shrinkWrap: true,
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
    children: [
      for (final option in poll.options)
        if (option.voters.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              '${option.text} — ${t.votes(n: option.votes, count: option.votes.grouped)}',
              style: TextStyle(fontSize: 13, color: secondary),
            ),
          ),
          for (final name in option.voters)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  ContactAvatar(
                    contact: models.ChatMember(id: name, name: name),
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(name == 'Вы' ? context.t.screenChat.you : name)),
                ],
              ),
            ),
        ],
    ],
  );
  if (Platform.isIOS) {
    return c.showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7),
        decoration: BoxDecoration(
          color: c.CupertinoColors.systemBackground.resolveFrom(sheetContext),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  t.pollVoters,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: c.CupertinoColors.label.resolveFrom(sheetContext)),
                ),
              ),
              Flexible(
                child: DefaultTextStyle(
                  style: TextStyle(fontSize: 16, color: c.CupertinoColors.label.resolveFrom(sheetContext)),
                  child: body(sheetContext, c.CupertinoColors.secondaryLabel.resolveFrom(sheetContext)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return m.showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7),
        child: body(sheetContext, m.Theme.of(sheetContext).colorScheme.onSurfaceVariant),
      ),
    ),
  );
}

/// Тап по упоминанию по имени (без @username) — личный чат с человеком.
void openMentionName(BuildContext context, String userID) async {
  if (userID.isEmpty || !context.read<CommonCubit>().state.settingsDevice.chatsDemo) return;
  final chatID = await ChatsDemoDataSource.instance.openPrivateChat(userID);
  if (chatID.isNotEmpty && context.mounted) await context.push('/chats/chat/$chatID');
}

/// Кнопка внизу, когда писать нельзя: подпись (`null` — «Звук» канала) и
/// действие (`null` — неактивна: заявка уже отправлена).
(String?, VoidCallback?) channelBarAction(BuildContext context, models.Chat chat) {
  final t = context.t.screenChat;
  final cubit = context.read<ChatCubit>();
  if (chat.isMember) return (null, () => cubit.setMuted(!chat.muted));
  if (chat.joinRequested) return (t.requestSent, null);
  final label = chat.type == models.ChatType.channel
      ? t.subscribe
      : (chat.joinMode == models.ChatJoinMode.request ? t.requestJoin : t.joinGroup);
  return (label, cubit.join);
}

/// Ссылка `iperon.net/<имя>` или `iperon.net/+код` из сообщения — открыть
/// канал / группу в приложении (не подписаны — с «Подписаться» внизу).
/// `false` — не наша ссылка (`/blog`, другой сайт): открыть в браузере.
/// Недействительное приглашение — сообщение об этом.
Future<bool> openIperonLink(BuildContext context, Uri uri) async {
  final host = uri.host.toLowerCase().replaceFirst(RegExp(r'^www\.'), '');
  if (host != 'iperon.net') return false;
  final path = uri.pathSegments.firstOrNull ?? '';
  if (path.isEmpty) return false;
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  final chatID = demo ? await ChatsDemoDataSource.instance.resolveLink(path) : '';
  if (!context.mounted) return true;
  if (chatID.isNotEmpty) {
    await context.push('/chats/chat/$chatID');
    return true;
  }
  if (!path.startsWith('+')) return false;
  final text = context.t.screenChat.linkInvalid;
  if (Platform.isIOS) {
    await c.showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => c.CupertinoAlertDialog(
        content: Text(text),
        actions: [c.CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok))],
      ),
    );
  } else {
    m.ScaffoldMessenger.of(context).showSnackBar(m.SnackBar(content: Text(text)));
  }
  return true;
}

/// Выбранное вложение до отправки: путь, тип (фото / видео / файл) и, для
/// видео, правки из редактора.
class AttachmentDraft {
  final String path;
  final models.MessageKind kind;

  /// Обрезка / без звука / обложка / кадрирование (редактор видео); `null` — как есть.
  ChatVideoEdit? edit;

  AttachmentDraft(this.path, this.kind);

  bool get isMedia => kind == models.MessageKind.photo || kind == models.MessageKind.video;

  bool get isVideo => kind == models.MessageKind.video;

  Future<({String thumb, int durationMs, int width, int height})?>? _preview;
  int _previewAt = -1;

  /// Кадр-превью видео (обложка или начало отрезка) и длительность исходника;
  /// пересчитывается, только когда меняется кадр.
  Future<({String thumb, int durationMs, int width, int height})?> get videoPreview {
    final at = edit?.thumbAtMs ?? 0;
    if (_preview == null || _previewAt != at) {
      _previewAt = at;
      _preview = chatVideoPreview(path, atMs: at);
    }
    return _preview!;
  }
}

/// Итог превью перед отправкой: подпись, «Скрыть под спойлер» (меню «⋯») и
/// «HD» — видео в 1080p вместо 720p.
typedef MediaCaptionResult = ({String caption, bool spoiler, bool hd});

/// Скрепка: фото/видео из галереи, камера или файл → превью с подписью →
/// отправка. Несколько фото/видео уходят альбомом (по [models.Message.maxAlbum]
/// в сообщении), файлы — отдельными сообщениями. Подпись — у первого
/// сообщения; текст из поля ввода [input] переносится в подпись (как в Telegram).
Future<void> pickAndSendAttachments(BuildContext context, {TextEditingController? input}) async {
  final cubit = context.read<ChatCubit>();
  final chat = cubit.state.chat;
  // «Опрос» — в группах, сообществах, каналах и комментариях (не в личных).
  final polls = chat != null && chat.type != models.ChatType.private;
  final result = await showToolbarAttachments(
    context,
    tabs: [ToolbarAttachmentTabKind.gallery, ToolbarAttachmentTabKind.file, if (polls) ToolbarAttachmentTabKind.poll],
    media: ToolbarAttachmentMediaType.all,
    multiSelect: true,
  );
  if (result is ToolbarAttachmentPollResult) {
    if (!context.mounted || chat == null) return;
    final channel = chat.type == models.ChatType.channel;
    final poll = Platform.isIOS
        ? await showPollCreateCupertino(context, channel: channel)
        : await showPollCreateMaterial(context, channel: channel);
    if (poll != null) await cubit.sendPoll(poll);
    return;
  }
  final items = switch (result) {
    ToolbarAttachmentImageResult(:final file, :final source) => [_draft(file.path, asFile: source == ToolbarAttachmentTabKind.file)],
    ToolbarAttachmentMultiImageResult(:final files, :final source) => [
      for (final file in files) _draft(file.path, asFile: source == ToolbarAttachmentTabKind.file),
    ],
    ToolbarAttachmentEmojiResult() || ToolbarAttachmentLinkResult() || ToolbarAttachmentPollResult() || null => const <AttachmentDraft>[],
  };
  if (items.isEmpty || !context.mounted) return;

  final initial = input?.text ?? '';
  final sheet = Platform.isIOS
      ? await showMediaCaptionCupertino(context, items, initialCaption: initial)
      : await showMediaCaptionMaterial(context, items, initialCaption: initial);
  if (sheet == null || !context.mounted) return;
  final caption = sheet.caption;

  // Фото — параллельно; видео — по очереди, с окном прогресса и «Отмена».
  final List<models.MessageMedia> media;
  try {
    media = await _prepareMedia(
      context,
      [
        for (final i in items)
          if (i.isMedia) i,
      ],
      spoiler: sheet.spoiler,
      quality: sheet.hd ? ChatVideoQuality.hd : ChatVideoQuality.standard,
    );
  } on ChatVideoCancelled {
    return;
  }
  // Текст из поля ввода ушёл в подпись (после отмены сжатия — остаётся).
  if (initial.isNotEmpty) input?.clear();

  var pending = caption;
  String takeCaption() {
    final value = pending;
    pending = '';
    return value;
  }

  for (var start = 0; start < media.length; start += models.Message.maxAlbum) {
    final chunk = media.sublist(start, math.min(start + models.Message.maxAlbum, media.length));
    await cubit.sendMedia(
      kind: chunk.every((m) => m.kind == models.MessageKind.video) ? models.MessageKind.video : models.MessageKind.photo,
      localPath: chunk.length == 1 ? chunk.single.localPath : '',
      fileName: chunk.length == 1 ? p.basename(chunk.single.localPath) : '',
      media: chunk,
      caption: takeCaption(),
    );
  }
  for (final file in items.where((i) => !i.isMedia)) {
    await cubit.sendMedia(kind: file.kind, localPath: file.path, fileName: p.basename(file.path), caption: takeCaption());
  }
}

/// Сжатие фото и видео перед отправкой, в исходном порядке. Видео дольше —
/// если его подготовка заметна (> 0,4 с), показывается окно «Сжатие видео» с
/// прогрессом по всем видео и «Отменой» ([ChatVideoCancelled]).
Future<List<models.MessageMedia>> _prepareMedia(
  BuildContext context,
  List<AttachmentDraft> items, {
  required bool spoiler,
  required ChatVideoQuality quality,
}) async {
  final photos = [for (final item in items) item.kind == models.MessageKind.photo ? _prepare(item, spoiler: spoiler) : null];
  final result = List<models.MessageMedia?>.filled(items.length, null);
  final videos = [
    for (final (i, item) in items.indexed)
      if (item.kind == models.MessageKind.video) (i, item),
  ];
  if (videos.isNotEmpty) {
    final progress = ValueNotifier<double>(0);
    ChatVideoJob? current;
    var cancelled = false;
    final close = _showVideoProgress(
      context,
      progress,
      onCancel: () {
        cancelled = true;
        current?.cancel();
      },
    );
    try {
      for (final (n, (i, item)) in videos.indexed) {
        if (cancelled) throw const ChatVideoCancelled();
        current = ChatVideoJob();
        final video = await prepareChatVideo(
          item.path,
          quality: quality,
          edit: item.edit,
          job: current,
          onProgress: (value) => progress.value = (n + value) / videos.length,
        );
        if (cancelled) throw const ChatVideoCancelled();
        result[i] = video == null
            ? models.MessageMedia(kind: item.kind, localPath: item.path, spoiler: spoiler)
            : models.MessageMedia(
                kind: item.kind,
                localPath: video.path,
                width: video.width,
                height: video.height,
                size: video.size,
                thumbPath: video.thumbPath,
                thumbhash: video.thumbhash,
                duration: video.duration,
                spoiler: spoiler,
              );
      }
    } finally {
      close();
      progress.dispose();
    }
  }
  for (final (i, photo) in photos.indexed) {
    if (photo != null) result[i] = await photo;
  }
  return [for (final m in result) m!];
}

/// Окно «Сжатие видео» (с задержкой — короткая подготовка без мигания).
/// Возвращает функцию закрытия.
VoidCallback _showVideoProgress(BuildContext context, ValueListenable<double> progress, {required VoidCallback onCancel}) {
  BuildContext? dialogContext;
  var closed = false;
  var popped = false;
  final timer = Timer(const Duration(milliseconds: 400), () {
    if (closed || !context.mounted) return;
    final t = context.t;
    Widget percent(BuildContext context) =>
        ValueListenableBuilder<double>(valueListenable: progress, builder: (context, value, _) => Text('${(value * 100).round()}%'));
    if (Platform.isIOS) {
      c.showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          // Закрыли раньше, чем окно построилось, — закрываем сразу после.
          if (closed && !popped) {
            popped = true;
            WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
          }
          return PopScope(
            canPop: false,
            child: c.CupertinoAlertDialog(
              title: Text(t.screenChat.videoCompressing),
              content: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<double>(
                      valueListenable: progress,
                      builder: (context, value, _) => _ProgressLine(value: value, color: c.CupertinoTheme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 8),
                    percent(context),
                  ],
                ),
              ),
              actions: [c.CupertinoDialogAction(onPressed: onCancel, child: Text(t.common.cancel))],
            ),
          );
        },
      );
    } else {
      m.showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          // Закрыли раньше, чем окно построилось, — закрываем сразу после.
          if (closed && !popped) {
            popped = true;
            WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
          }
          return PopScope(
            canPop: false,
            child: m.AlertDialog(
              title: Text(t.screenChat.videoCompressing),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: progress,
                    builder: (context, value, _) => m.LinearProgressIndicator(value: value),
                  ),
                  const SizedBox(height: 12),
                  percent(context),
                ],
              ),
              actions: [m.TextButton(onPressed: onCancel, child: Text(t.common.cancel))],
            ),
          );
        },
      );
    }
  });
  return () {
    closed = true;
    timer.cancel();
    final dialog = dialogContext;
    if (dialog != null && dialog.mounted && !popped) {
      popped = true;
      Navigator.of(dialog).pop();
    }
  };
}

/// Полоска прогресса (у Cupertino своей нет).
class _ProgressLine extends StatelessWidget {
  final double value;
  final Color color;

  const _ProgressLine({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: color.withValues(alpha: 0.2)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0.0, 1.0),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

Future<models.MessageMedia> _prepare(AttachmentDraft item, {bool spoiler = false}) async {
  final photo = item.kind == models.MessageKind.photo ? await prepareChatPhoto(item.path) : null;
  if (photo == null) return models.MessageMedia(kind: item.kind, localPath: item.path, spoiler: spoiler);
  return models.MessageMedia(
    kind: item.kind,
    localPath: photo.path,
    width: photo.width,
    height: photo.height,
    size: photo.size,
    thumbPath: photo.thumbPath,
    thumbhash: photo.thumbhash,
    spoiler: spoiler,
  );
}

const _videoExtensions = {'.mp4', '.mov', '.m4v', '.3gp', '.webm', '.mkv'};
const _imageExtensions = {'.jpg', '.jpeg', '.png', '.heic', '.heif', '.webp', '.gif'};

AttachmentDraft _draft(String path, {bool asFile = false}) {
  final ext = p.extension(path).toLowerCase();
  // Из таба «Файл» — всегда файлом (фото/видео без сжатия, как в Telegram).
  final kind = asFile
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

  /// «Скрыть под спойлер» — фото/видео размыты с пылью, как уйдут в чат.
  final bool spoiler;

  const AttachmentThumb({super.key, required this.item, required this.size, this.spoiler = false});

  @override
  Widget build(BuildContext context) {
    final Widget child = switch (item.kind) {
      models.MessageKind.photo => Image.file(File(item.path), fit: BoxFit.cover, cacheWidth: (size * 3).round()),
      models.MessageKind.video => _VideoDraftThumb(item: item, size: size),
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
      child: SizedBox(
        width: size,
        height: size,
        child: IgnorePointer(
          child: MediaSpoiler(enabled: spoiler && item.isMedia, child: child),
        ),
      ),
    );
  }
}

/// Открывает редактор видео [item] (нажатие на миниатюру в листе подписи);
/// `true` — правки изменились, миниатюру нужно перерисовать.
Future<bool> editVideoDraft(BuildContext context, AttachmentDraft item, {required Color accent}) async {
  final result = await showChatVideoEditor(context, path: item.path, initial: item.edit, accent: accent);
  if (result == null) return false;
  item.edit = result.edit;
  return true;
}

/// Миниатюра видео до отправки: кадр (обложка), длительность отрезка, значок
/// «без звука» и карандаш — по нажатию открывается редактор.
class _VideoDraftThumb extends StatelessWidget {
  final AttachmentDraft item;
  final double size;

  const _VideoDraftThumb({required this.item, required this.size});

  @override
  Widget build(BuildContext context) {
    const white = Color(0xFFFFFFFF);
    final edit = item.edit;
    return FutureBuilder(
      future: item.videoPreview,
      builder: (context, snapshot) {
        final preview = snapshot.data;
        final total = preview?.durationMs ?? 0;
        final ms = edit == null ? total : (edit.endMs > 0 ? edit.endMs : total) - edit.startMs;
        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0xFF3A3A3C)),
            if (preview != null && preview.thumb.isNotEmpty)
              if (edit != null && edit.changesFrame && preview.width > 0 && preview.height > 0)
                // Кадрирование и поворот — как уйдёт в чат.
                FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: edit.frameSize(preview.width, preview.height).width,
                    height: edit.frameSize(preview.width, preview.height).height,
                    child: ChatVideoReframe(
                      crop: edit.crop,
                      rotation: edit.rotation,
                      sourceAspect: preview.width / preview.height,
                      child: Image.file(File(preview.thumb), fit: BoxFit.fill, gaplessPlayback: true),
                    ),
                  ),
                )
              else
                Image.file(File(preview.thumb), fit: BoxFit.cover, cacheWidth: (size * 3).round(), gaplessPlayback: true),
            const Positioned(
              top: 5,
              right: 5,
              child: _ThumbBadge(child: FaIcon(FontAwesomeIcons.pen, size: 10, color: white)),
            ),
            if (preview != null)
              Positioned(
                left: 5,
                bottom: 5,
                child: _ThumbBadge(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (edit?.mute ?? false) ...[
                        const FaIcon(FontAwesomeIcons.volumeXmark, size: 10, color: white),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        chatVideoTime(Duration(milliseconds: ms)),
                        style: const TextStyle(fontSize: 11, color: white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ThumbBadge extends StatelessWidget {
  final Widget child;

  const _ThumbBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: const Color(0x80000000), borderRadius: BorderRadius.circular(6)),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3), child: child),
    );
  }
}

/// Плашка над полем ввода: «Ответ Анне: …» / «Редактирование: …».
({String title, String text})? composeBanner(Translations t, ChatState state) {
  final forwarding = state.forwarding;
  if (forwarding.isNotEmpty && state.editing == null) {
    String nameOf(models.Message m) => (m.forward?.self ?? m.outgoing) ? t.screenChat.you : (m.forward?.name ?? m.senderName);
    final first = forwarding.first;
    // Одно — его текст, несколько — от кого.
    final text = forwarding.length == 1
        ? (first.text.isNotEmpty ? first.text : messageKindLabel(t, first.kind))
        : t.screenChat.forwardFrom(names: {for (final m in forwarding) nameOf(m)}.where((n) => n.isNotEmpty).join(', '));
    return (title: t.screenChat.forwardMessages(n: forwarding.length), text: text.replaceAll('\n', ' '));
  }
  final message = state.editing ?? state.reply;
  if (message == null) return null;
  final text = message.text.isNotEmpty ? message.text : messageKindLabel(t, message.kind);
  if (state.editing != null) return (title: t.screenChat.editing, text: text.replaceAll('\n', ' '));
  final name = message.outgoing ? t.screenChat.you : (message.senderName.isNotEmpty ? message.senderName : state.chat?.title ?? '');
  return (title: name, text: text.replaceAll('\n', ' '));
}

/// Прокрутка ленты сообщений к строке с ключом [key] (поиск по чату). Лента
/// строится лениво: если строки ещё нет, листаем к старым (offset растёт —
/// список перевёрнут), потом к новым, пока она не построится; затем ставим её
/// в середину экрана.
///
/// [alignment] — куда поставить строку: 0 — к низу экрана, 1 — к верху
/// (лента перевёрнута); [duration] `zero` — без анимации.
Future<void> scrollToMessage(
  ScrollController scroll,
  GlobalKey key, {
  double alignment = 0.5,
  Duration duration = const Duration(milliseconds: 250),
}) async {
  if (!scroll.hasClients) return;
  for (final older in [true, false]) {
    for (var i = 0; i < 60 && key.currentContext == null; i++) {
      final position = scroll.position;
      final step = position.viewportDimension * 0.8;
      final target = (older ? position.pixels + step : position.pixels - step).clamp(0.0, position.maxScrollExtent);
      if (target == position.pixels) break;
      scroll.jumpTo(target);
      await WidgetsBinding.instance.endOfFrame;
    }
  }
  final context = key.currentContext;
  if (context == null || !context.mounted) return;
  await Scrollable.ensureVisible(context, alignment: alignment, duration: duration, curve: Curves.easeOutCubic);
}

/// Навигация по ленте чата (как в Telegram):
/// - при открытии — к разделителю «Непрочитанные сообщения»;
/// - кнопка «вниз» ([showDown]) со счётчиком новых входящих ниже экрана
///   ([unread]); после перехода по цитате она сначала возвращает к сообщению,
///   с которого перешли;
/// - тап по цитате — к исходному сообщению с подсветкой ([flashID]);
/// - своё новое сообщение — лента прокручивается вниз.
class ChatScrollTracker extends ChangeNotifier {
  final ScrollController scroll;
  final GlobalKey Function(String id) keyFor;

  ChatScrollTracker(this.scroll, this.keyFor) {
    scroll.addListener(_onScroll);
  }

  bool showDown = false;
  int unread = 0;
  String? flashID;

  List<models.Message> _messages = const [];

  /// Входящие новее этой даты пользователь ещё не видел (счётчик на «вниз»).
  DateTime? _seenUntil;
  bool _unreadApplied = false;

  /// Откуда переходили по цитатам — «вниз» возвращает туда по очереди.
  final _returnTo = <String>[];
  Timer? _flashTimer;

  bool get _atBottom => !scroll.hasClients || scroll.offset < 40;

  @override
  void dispose() {
    scroll.removeListener(_onScroll);
    _flashTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final show = scroll.hasClients && scroll.offset > 300;
    var changed = show != showDown;
    showDown = show;
    if (_atBottom) {
      _returnTo.clear();
      changed |= _markSeen();
    }
    if (changed) notifyListeners();
  }

  /// Внизу — всё прочитано.
  bool _markSeen() {
    if (_messages.isNotEmpty) _seenUntil = _messages.last.date;
    final changed = unread != 0;
    unread = 0;
    return changed;
  }

  /// Новые сообщения / разделитель из [ChatState].
  void update(List<models.Message> messages, String? unreadFromID) {
    final previous = _messages;
    _messages = messages;
    if (messages.isEmpty) return;
    _seenUntil ??= messages.last.date;

    if (!_unreadApplied && unreadFromID != null) {
      _unreadApplied = true;
      final i = messages.indexWhere((m) => m.id == unreadFromID);
      if (i >= 0) {
        _seenUntil = i > 0 ? messages[i - 1].date : messages.first.date.subtract(const Duration(microseconds: 1));
        _recount();
        notifyListeners();
        // Разделитель — у верха экрана, после первой отрисовки ленты.
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await scrollToMessage(scroll, keyFor(ChatMessagesView.unreadDividerID), alignment: 0.95, duration: Duration.zero);
          _onScroll();
        });
        return;
      }
    }

    // Своё новое сообщение — вниз, к нему.
    final last = messages.last;
    if (previous.isNotEmpty && last.outgoing && !previous.any((m) => m.id == last.id)) {
      jumpToBottom();
    }
    if (_atBottom) {
      _markSeen();
    } else {
      _recount();
    }
    notifyListeners();
  }

  void _recount() {
    final seen = _seenUntil;
    unread = seen == null ? 0 : _messages.where((m) => !m.outgoing && !m.service && m.date.isAfter(seen)).length;
  }

  /// Тап по цитате ответа в [from] — к исходному сообщению.
  Future<void> jumpToReply(models.Message from) async {
    final id = from.reply?.messageID;
    if (id == null || !_messages.any((m) => m.id == id)) return;
    _returnTo.add(from.id);
    await _jumpTo(id);
  }

  /// Кнопка «вниз»: назад к сообщению, с которого перешли по цитате, иначе —
  /// в самый низ.
  Future<void> down() async {
    while (_returnTo.isNotEmpty) {
      final id = _returnTo.removeLast();
      if (_messages.any((m) => m.id == id)) return _jumpTo(id);
    }
    await jumpToBottom();
  }

  Future<void> jumpToBottom() async {
    if (!scroll.hasClients) return;
    // Издалека — сначала прыжок поближе, чтобы не листать всю историю.
    final near = scroll.position.viewportDimension;
    if (scroll.offset > near * 3) scroll.jumpTo(near);
    await scroll.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
  }

  /// Перейти к сообщению [id] с подсветкой (плашка закреплённых).
  Future<void> jumpTo(String id) => _jumpTo(id);

  Future<void> _jumpTo(String id) async {
    await scrollToMessage(scroll, keyFor(id));
    flashID = id;
    notifyListeners();
    _flashTimer?.cancel();
    _flashTimer = Timer(const Duration(milliseconds: 900), () {
      flashID = null;
      notifyListeners();
    });
  }
}

/// Круглая кнопка «вниз» в правом нижнем углу ленты, со счётчиком новых.
class ChatScrollDownButton extends StatelessWidget {
  final ChatScrollTracker tracker;
  final Color background;
  final Color iconColor;
  final Color badgeColor;

  const ChatScrollDownButton({
    super.key,
    required this.tracker,
    required this.background,
    required this.iconColor,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: tracker,
      builder: (context, _) {
        final visible = tracker.showDown;
        return IgnorePointer(
          ignoring: !visible,
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            child: AnimatedScale(
              scale: visible ? 1 : 0.6,
              duration: const Duration(milliseconds: 180),
              child: GestureDetector(
                onTap: tracker.down,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: background,
                        shape: BoxShape.circle,
                        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 1))],
                      ),
                      child: FaIcon(FontAwesomeIcons.chevronDown, size: 18, color: iconColor),
                    ),
                    if (tracker.unread > 0)
                      Positioned(
                        top: -9,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '${tracker.unread}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFFFFFFF)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Цвета плашки закреплённого — свои у Cupertino и Material.
class PinnedBarStyle {
  final Color background;
  final Color accent;
  final Color text;
  final Color secondary;
  final Color separator;

  const PinnedBarStyle({
    required this.background,
    required this.accent,
    required this.text,
    required this.secondary,
    required this.separator,
  });
}

/// Плашка закреплённого под шапкой (как в Telegram): слева полоска-индикатор
/// (несколько закреплённых — по сегменту на каждое, до 4), «Закреплённое
/// сообщение #N», превью фото/видео и текст. Тап — к сообщению; справа —
/// список всех закреплённых (если их несколько) или крестик «открепить».
class PinnedMessageBar extends StatelessWidget {
  static const height = 52.0;

  /// От новых к старым ([ChatState.pinnedMessages]); показывается [index]-е.
  final List<models.Message> pinned;
  final int index;
  final PinnedBarStyle style;
  final VoidCallback onTap;

  /// `null` — открепить нельзя (канал для подписчика).
  final VoidCallback? onUnpin;

  /// Экран «Закреплённые сообщения» — значок списка вместо крестика, когда
  /// закреплённых несколько.
  final VoidCallback? onList;

  const PinnedMessageBar({
    super.key,
    required this.pinned,
    required this.index,
    required this.style,
    required this.onTap,
    this.onUnpin,
    this.onList,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final i = index % pinned.length;
    final message = pinned[i];
    // Номер — от старого (#1) к новому, как в Telegram.
    final number = pinned.length - i;
    final text = message.text.isNotEmpty ? message.text : messageKindLabel(t, message.kind);
    final segments = math.min(pinned.length, 4);
    final current = (number - 1) % segments;
    final thumb = messageMediaThumb(message);
    final showList = pinned.length > 1 && onList != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: style.background,
          border: Border(bottom: BorderSide(color: style.separator, width: 0.5)),
        ),
        padding: const EdgeInsets.only(left: 14),
        child: Row(
          children: [
            SizedBox(
              width: 2.5,
              height: 34,
              child: Column(
                children: [
                  for (var s = 0; s < segments; s++) ...[
                    if (s > 0) const SizedBox(height: 2),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          // Сверху — новые: текущий сегмент считается снизу.
                          color: style.accent.withValues(alpha: segments - 1 - s == current ? 1 : 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                // По умолчанию AnimatedSwitcher центрирует — текст прижат влево.
                layoutBuilder: (current, previous) => Stack(alignment: Alignment.centerLeft, children: [...previous, ?current]),
                child: Row(
                  key: ValueKey(message.id),
                  children: [
                    if (thumb != null) ...[thumb, const SizedBox(width: 8)],
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pinned.length > 1 ? t.screenChat.pinnedNumber(n: number) : t.screenChat.pinnedTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: style.accent),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            text.replaceAll('\n', ' '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: style.text),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showList)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onList,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: FaIcon(FontAwesomeIcons.listUl, size: 17, color: style.secondary),
                ),
              )
            else if (onUnpin != null)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onUnpin,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: FaIcon(FontAwesomeIcons.xmark, size: 16, color: style.secondary),
                ),
              )
            else
              const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}

/// Обои из «Тем для чатов» (Настройки → Оформление) на всю площадь —
/// фон ленты чата и экрана «Закреплённые сообщения».
class ChatWallpaperLayer extends StatelessWidget {
  final bool dark;

  const ChatWallpaperLayer({super.key, required this.dark});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommonCubit, CommonState>(
      buildWhen: (previous, current) =>
          previous.settingsDevice.chatWallpaper != current.settingsDevice.chatWallpaper ||
          previous.settingsDevice.chatWallpaperColor != current.settingsDevice.chatWallpaperColor ||
          previous.settingsDevice.chatWallpaperIntensity != current.settingsDevice.chatWallpaperIntensity,
      builder: (context, common) => ChatWallpaper(
        pattern: common.settingsDevice.chatWallpaper,
        colorIndex: common.settingsDevice.chatWallpaperColor,
        intensity: common.settingsDevice.chatWallpaperIntensity,
        dark: dark,
      ),
    );
  }
}

/// Ссылка в набираемом тексте [raw] (markdown-ярлыки учитываются) — над
/// полем ввода плашка «Предпросмотр ссылки» с ×; `null` — ссылки нет.
String? composeLinkUrl(String raw) {
  if (!raw.contains('.')) return null;
  final (text, entities) = parseMarkdownShortcuts(raw);
  return firstLinkUrl(text, entities);
}

/// Подсказка упоминаний в поле ввода группы: «@» + начало имени или
/// @username перед курсором → участники ([suggestions]); выбор — вставляет
/// `@username ` (или имя, если username нет — запоминается для `mentionName`).
class ComposeMentions extends ChangeNotifier {
  ComposeMentions(this.input) {
    input.addListener(_update);
  }

  final TextEditingController input;

  /// Подсказка работает (группа / сообщество / комментарии).
  bool enabled = false;

  /// Участники чата (без нас).
  List<models.ChatMember> members = const [];

  /// Упомянутые по имени — уходят в `ChatCubit.send(mentions:)`.
  final _picked = <models.ChatMember>[];

  String? _query;
  int _start = 0;

  static final _pattern = RegExp(r'(?:^|\s)@([\p{L}\p{N}_]*)$', unicode: true);

  void _update() {
    String? query;
    final selection = input.selection;
    if (enabled && selection.isValid && selection.isCollapsed) {
      final before = input.text.substring(0, selection.baseOffset);
      final match = _pattern.firstMatch(before);
      if (match != null) {
        query = match.group(1)!;
        _start = selection.baseOffset - query.length - 1;
      }
    }
    if (query == _query) return;
    _query = query;
    notifyListeners();
  }

  List<models.ChatMember> get suggestions {
    final query = _query?.toLowerCase();
    if (query == null) return const [];
    bool fits(models.ChatMember m) =>
        m.username.toLowerCase().startsWith(query) || m.name.toLowerCase().split(' ').any((word) => word.startsWith(query));
    return [
      for (final m in members)
        if (!m.isSelf && fits(m)) m,
    ].take(20).toList();
  }

  void pick(models.ChatMember member) {
    final end = input.selection.baseOffset;
    if (end < _start) return;
    final insert = member.username.isNotEmpty ? '@${member.username} ' : '${member.name} ';
    if (member.username.isEmpty && !_picked.any((m) => m.id == member.id)) _picked.add(member);
    final text = input.text.replaceRange(_start, end, insert);
    input.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: _start + insert.length),
    );
  }

  /// Упомянутые по имени для отправки (и сброс).
  List<models.ChatMember> take() {
    final result = [..._picked];
    _picked.clear();
    return result;
  }

  @override
  void dispose() {
    input.removeListener(_update);
    super.dispose();
  }
}

/// Список подсказок «@» над полем ввода: аватар, имя, @username. Пусто — ничего.
class MentionSuggestions extends StatelessWidget {
  final ComposeMentions mentions;
  final Color background;
  final Color text;
  final Color secondary;
  final Color separator;

  const MentionSuggestions({
    super.key,
    required this.mentions,
    required this.background,
    required this.text,
    required this.secondary,
    required this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: mentions,
      builder: (context, _) {
        final items = mentions.suggestions;
        if (items.isEmpty) return const SizedBox.shrink();
        return Container(
          constraints: const BoxConstraints(maxHeight: 4.5 * 48),
          decoration: BoxDecoration(
            color: background,
            border: Border(top: BorderSide(color: separator, width: 0.5)),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final member = items[index];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => mentions.pick(member),
                child: SizedBox(
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        ContactAvatar(contact: member, size: 32),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            member.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: text),
                          ),
                        ),
                        if (member.username.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text('@${member.username}', style: TextStyle(fontSize: 14, color: secondary)),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
