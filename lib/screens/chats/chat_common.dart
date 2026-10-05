import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;

import '../../chats/media_prepare.dart';
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

/// Итог превью перед отправкой: подпись и «Скрыть под спойлер» (меню «⋯»).
typedef MediaCaptionResult = ({String caption, bool spoiler});

/// Скрепка: фото/видео из галереи, камера или файл → превью с подписью →
/// отправка. Несколько фото/видео уходят альбомом (по [models.Message.maxAlbum]
/// в сообщении), файлы — отдельными сообщениями. Подпись — у первого
/// сообщения; текст из поля ввода [input] переносится в подпись (как в Telegram).
Future<void> pickAndSendAttachments(BuildContext context, {TextEditingController? input}) async {
  final cubit = context.read<ChatCubit>();
  final result = await showToolbarAttachments(
    context,
    tabs: const [ToolbarAttachmentTabKind.gallery, ToolbarAttachmentTabKind.file],
    media: ToolbarAttachmentMediaType.all,
    multiSelect: true,
  );
  final items = switch (result) {
    ToolbarAttachmentImageResult(:final file, :final source) => [_draft(file.path, asFile: source == ToolbarAttachmentTabKind.file)],
    ToolbarAttachmentMultiImageResult(:final files, :final source) => [
      for (final file in files) _draft(file.path, asFile: source == ToolbarAttachmentTabKind.file),
    ],
    ToolbarAttachmentEmojiResult() || ToolbarAttachmentLinkResult() || null => const <AttachmentDraft>[],
  };
  if (items.isEmpty || !context.mounted) return;

  final initial = input?.text ?? '';
  final sheet = Platform.isIOS
      ? await showMediaCaptionCupertino(context, items, initialCaption: initial)
      : await showMediaCaptionMaterial(context, items, initialCaption: initial);
  if (sheet == null) return;
  final caption = sheet.caption;
  // Текст из поля ввода ушёл в подпись.
  if (initial.isNotEmpty) input?.clear();

  var pending = caption;
  String takeCaption() {
    final value = pending;
    pending = '';
    return value;
  }

  // Фото сжимаем перед отправкой (параллельно); видео пока как есть.
  final media = await Future.wait([for (final i in items.where((i) => i.isMedia)) _prepare(i, spoiler: sheet.spoiler)]);
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
