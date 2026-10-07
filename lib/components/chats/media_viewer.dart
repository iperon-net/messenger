import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../di.dart';
import '../../logger.dart';

import '../../chats/media_prepare.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Фото/видео чата для полноэкранного просмотра: одиночное медиа или элемент
/// альбома ([index] в [models.Message.media]).
class ChatMediaItem {
  final models.Message message;
  final int index;
  final models.MessageKind kind;
  final String localPath;
  final String thumbhash;

  /// Кадр-превью видео (пока видео не загрузилось в плеер — показываем его).
  final String thumbPath;

  /// Размеры медиа (с поворотом); 0 — неизвестно.
  final int width;
  final int height;

  const ChatMediaItem({
    required this.message,
    required this.index,
    required this.kind,
    required this.localPath,
    this.thumbhash = '',
    this.thumbPath = '',
    this.width = 0,
    this.height = 0,
  });

  bool get isVideo => kind == models.MessageKind.video;

  /// Пропорции кадра; неизвестны — 16:9.
  double get aspectRatio => width > 0 && height > 0 ? width / height : 16 / 9;

  /// Общий тег Hero миниатюры в пузыре и страницы просмотрщика.
  Object get heroTag => chatMediaHeroTag(message, index);

  static List<ChatMediaItem> of(List<models.Message> messages) => [
    for (final m in messages)
      if (!m.service)
        if (m.isAlbum)
          for (final (i, media) in m.media.indexed)
            ChatMediaItem(
              message: m,
              index: i,
              kind: media.kind,
              localPath: media.localPath,
              thumbhash: media.thumbhash,
              thumbPath: media.thumbPath,
              width: media.width,
              height: media.height,
            )
        else if (m.kind == models.MessageKind.photo || m.kind == models.MessageKind.video)
          ChatMediaItem(
            message: m,
            index: 0,
            kind: m.kind,
            localPath: m.localPath,
            thumbhash: m.media.firstOrNull?.thumbhash ?? '',
            thumbPath: m.media.firstOrNull?.thumbPath ?? '',
            width: m.media.firstOrNull?.width ?? 0,
            height: m.media.firstOrNull?.height ?? 0,
          ),
  ];
}

Object chatMediaHeroTag(models.Message message, int index) => 'chat-media-${message.id}-$index';

/// Заглушка медиа без локального файла (демо): градиент по [seed] + значок.
Widget chatMediaPlaceholder(String seed, {required bool video, double iconSize = 40}) {
  final hue = (seed.hashCode.abs() % 360).toDouble();
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [HSVColor.fromAHSV(1, hue, 0.45, 0.85).toColor(), HSVColor.fromAHSV(1, (hue + 50) % 360, 0.55, 0.65).toColor()],
      ),
    ),
    alignment: Alignment.center,
    child: FaIcon(video ? FontAwesomeIcons.circlePlay : FontAwesomeIcons.image, size: iconSize, color: const Color(0xCCFFFFFF)),
  );
}

/// Фото из файла на всю площадь (cover); пока декодируется — размытое превью
/// из ThumbHash (если есть).
class ChatMediaImage extends StatelessWidget {
  final String path;
  final String thumbhash;
  final int? cacheWidth;
  final BoxFit fit;

  const ChatMediaImage({super.key, required this.path, this.thumbhash = '', this.cacheWidth, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    final preview = thumbhashToBmp(thumbhash);
    return Image.file(
      File(path),
      fit: fit,
      cacheWidth: cacheWidth,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame != null || wasSynchronouslyLoaded || preview == null) return child;
        return Image.memory(preview, fit: fit, gaplessPlayback: true);
      },
    );
  }
}

/// Полноэкранный просмотр всех фото/видео чата ([messages]), начиная с
/// [index]-го медиа сообщения [message]: листание вбок, щипок и двойной тап —
/// зум, свайп вниз/вверх — закрыть, тап — спрятать/показать панели. Видео
/// играет сразу, как только его страница открыта; внизу — пауза и перемотка.
/// Одинаков на iOS и Android (как в Telegram), поэтому без пары
/// `*_cupertino`/`*_material`.
Future<void> showChatMediaViewer(
  BuildContext context, {
  required List<models.Message> messages,
  required models.Message message,
  required int index,
  String chatTitle = '',
}) {
  final items = ChatMediaItem.of(messages);
  final initial = items.indexWhere((i) => i.message.id == message.id && i.index == index);
  if (initial < 0) return Future.value();
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, _) => _MediaViewer(items: items, initial: initial, chatTitle: chatTitle),
      transitionsBuilder: (context, animation, _, child) => FadeTransition(opacity: animation, child: child),
    ),
  );
}

class _MediaViewer extends StatefulWidget {
  final List<ChatMediaItem> items;
  final int initial;
  final String chatTitle;

  const _MediaViewer({required this.items, required this.initial, required this.chatTitle});

  @override
  State<_MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<_MediaViewer> with SingleTickerProviderStateMixin {
  late final _pages = PageController(initialPage: widget.initial);
  late int _current = widget.initial;
  bool _chrome = true;
  bool _zoomed = false;

  // Свайп для закрытия: смещение по вертикали и возврат на место.
  double _drag = 0;
  late final AnimationController _dragBack = AnimationController(vsync: this, duration: const Duration(milliseconds: 200))
    ..addListener(() => setState(() => _drag = _dragFrom * (1 - Curves.easeOut.transform(_dragBack.value))));
  double _dragFrom = 0;

  static const _dismissDistance = 120.0;

  /// Плеер видео текущей страницы (один на просмотрщик: уходим со страницы —
  /// освобождаем).
  VideoPlayerController? _video;
  bool _wakelock = false;

  @override
  void initState() {
    super.initState();
    _openVideo();
  }

  @override
  void dispose() {
    _closeVideo();
    _pages.dispose();
    _dragBack.dispose();
    super.dispose();
  }

  void _openVideo() {
    final item = widget.items[_current];
    if (!item.isVideo || item.localPath.isEmpty || !File(item.localPath).existsSync()) return;
    final video = VideoPlayerController.file(File(item.localPath))..addListener(_onVideoTick);
    _video = video;
    video
        .initialize()
        .then((_) {
          if (!mounted || _video != video) return;
          setState(() {});
          video.play();
        })
        .catchError((Object e, StackTrace s) {
          getIt.get<Logger>().handle(e, s, 'video player');
        });
  }

  void _closeVideo() {
    final video = _video;
    _video = null;
    if (video == null) return;
    video.removeListener(_onVideoTick);
    video.dispose();
    _setWakelock(false);
  }

  /// Пока видео играет, экран не гаснет.
  void _onVideoTick() => _setWakelock(_video?.value.isPlaying ?? false);

  void _setWakelock(bool on) {
    if (on == _wakelock) return;
    _wakelock = on;
    WakelockPlus.toggle(enable: on).catchError((_) {});
  }

  void _togglePlay() {
    final video = _video;
    if (video == null || !video.value.isInitialized) return;
    if (video.value.isPlaying) {
      video.pause();
    } else {
      // Досмотрели — заново с начала.
      if (video.value.isCompleted) video.seekTo(Duration.zero);
      video.play();
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_drag.abs() > _dismissDistance || details.velocity.pixelsPerSecond.dy.abs() > 800) {
      Navigator.of(context).pop();
      return;
    }
    _dragFrom = _drag;
    _dragBack.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final item = widget.items[_current];
    final m = item.message;
    final sender = m.outgoing ? t.screenChat.you : (m.senderName.isNotEmpty ? m.senderName : widget.chatTitle);
    final fade = (1 - _drag.abs() / 400).clamp(0.0, 1.0);
    const white = Color(0xFFFFFFFF);
    final textStyle = DefaultTextStyle.of(context).style.copyWith(color: white, decoration: TextDecoration.none);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DefaultTextStyle(
        style: textStyle,
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(color: const Color(0xFF000000).withValues(alpha: fade)),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _chrome = !_chrome),
                onVerticalDragStart: _zoomed ? null : (_) => _dragBack.stop(),
                onVerticalDragUpdate: _zoomed ? null : (d) => setState(() => _drag += d.delta.dy),
                onVerticalDragEnd: _zoomed ? null : _onDragEnd,
                child: Transform.translate(
                  offset: Offset(0, _drag),
                  child: PageView.builder(
                    controller: _pages,
                    physics: _zoomed ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
                    itemCount: widget.items.length,
                    onPageChanged: (i) => setState(() {
                      _current = i;
                      _zoomed = false;
                      _closeVideo();
                      _openVideo();
                    }),
                    itemBuilder: (context, i) => _ZoomablePage(
                      item: widget.items[i],
                      video: i == _current ? _video : null,
                      onTogglePlay: _togglePlay,
                      onZoomChanged: (zoomed) {
                        if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Панели: сверху — закрыть, автор, дата, счётчик; снизу — подпись.
            IgnorePointer(
              ignoring: !_chrome,
              child: AnimatedOpacity(
                opacity: _chrome && _drag == 0 ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Column(
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x99000000), Color(0x00000000)],
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 16, 16),
                          child: Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => Navigator.of(context).pop(),
                                child: const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: FaIcon(FontAwesomeIcons.xmark, size: 22, color: white),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sender,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      m.date.relativeFormat(t),
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 13, color: Color(0xB3FFFFFF)),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.items.length > 1)
                                Text(
                                  t.screenChat.mediaCounter(current: _current + 1, total: widget.items.length),
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (m.text.isNotEmpty || _video != null)
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0x99000000), Color(0x00000000)],
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (m.text.isNotEmpty)
                                  Text(m.text, maxLines: 6, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16)),
                                if (m.text.isNotEmpty && _video != null) const SizedBox(height: 8),
                                if (_video case final video?) _VideoControls(video: video, onTogglePlay: _togglePlay),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Страница просмотрщика: щипок и двойной тап — зум, в зуме — панорама.
class _ZoomablePage extends StatefulWidget {
  final ChatMediaItem item;

  /// Плеер, если это видео и его страница текущая.
  final VideoPlayerController? video;
  final VoidCallback onTogglePlay;
  final ValueChanged<bool> onZoomChanged;

  const _ZoomablePage({required this.item, required this.onZoomChanged, required this.onTogglePlay, this.video});

  @override
  State<_ZoomablePage> createState() => _ZoomablePageState();
}

class _ZoomablePageState extends State<_ZoomablePage> with SingleTickerProviderStateMixin {
  final _transform = TransformationController();
  late final _zoomAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
  Animation<Matrix4>? _zoomTween;
  Offset _doubleTapAt = Offset.zero;

  static const _doubleTapScale = 2.5;

  @override
  void initState() {
    super.initState();
    _zoomAnimation.addListener(() {
      final tween = _zoomTween;
      if (tween != null) _transform.value = tween.value;
    });
    _zoomAnimation.addStatusListener((status) {
      if (status.isCompleted) _reportZoom();
    });
  }

  @override
  void dispose() {
    _transform.dispose();
    _zoomAnimation.dispose();
    super.dispose();
  }

  bool get _isZoomed => _transform.value.getMaxScaleOnAxis() > 1.01;

  void _reportZoom() => widget.onZoomChanged(_isZoomed);

  void _onDoubleTap() {
    final Matrix4 target;
    if (_isZoomed) {
      target = Matrix4.identity();
    } else {
      // Приближаем к точке тапа.
      final p = _doubleTapAt;
      target = Matrix4.identity()
        ..translateByDouble(-p.dx * (_doubleTapScale - 1), -p.dy * (_doubleTapScale - 1), 0, 1)
        ..scaleByDouble(_doubleTapScale, _doubleTapScale, 1, 1);
    }
    _zoomTween = Matrix4Tween(begin: _transform.value, end: target).animate(CurvedAnimation(parent: _zoomAnimation, curve: Curves.easeOut));
    _zoomAnimation.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final video = item.isVideo;
    final Widget media = item.localPath.isNotEmpty && !video
        ? ChatMediaImage(path: item.localPath, thumbhash: item.thumbhash, fit: BoxFit.contain)
        : video && item.thumbPath.isNotEmpty
        ? _VideoView(item: item, video: widget.video, onTogglePlay: widget.onTogglePlay)
        : AspectRatio(
            aspectRatio: 4 / 3,
            child: chatMediaPlaceholder('${item.message.id}-${item.index}', video: video, iconSize: 64),
          );
    return GestureDetector(
      onDoubleTapDown: (details) => _doubleTapAt = details.localPosition,
      onDoubleTap: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _transform,
        minScale: 1,
        maxScale: 5,
        // Без зума панорама не нужна — свайпы достаются листанию и закрытию.
        panEnabled: _isZoomed,
        onInteractionEnd: (_) => setState(_reportZoom),
        child: Center(
          child: Hero(tag: item.heroTag, child: media),
        ),
      ),
    );
  }
}

/// Видео на странице просмотрщика: кадр-превью, поверх — плеер, как только
/// загрузился; на паузе — ▶ по центру.
class _VideoView extends StatelessWidget {
  final ChatMediaItem item;
  final VideoPlayerController? video;
  final VoidCallback onTogglePlay;

  const _VideoView({required this.item, required this.video, required this.onTogglePlay});

  @override
  Widget build(BuildContext context) {
    final video = this.video;
    return AspectRatio(
      aspectRatio: item.aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ChatMediaImage(path: item.thumbPath, thumbhash: item.thumbhash),
          if (video == null)
            const Center(child: ChatVideoPlayBadge(size: 64))
          else
            ValueListenableBuilder(
              valueListenable: video,
              builder: (context, value, _) => Stack(
                fit: StackFit.expand,
                children: [
                  if (value.isInitialized) VideoPlayer(video),
                  if (!value.isPlaying)
                    Center(
                      child: GestureDetector(onTap: onTogglePlay, child: const ChatVideoPlayBadge(size: 64)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Панель видео внизу просмотрщика: пауза/играть, позиция, перемотка и
/// длительность.
class _VideoControls extends StatelessWidget {
  final VideoPlayerController video;
  final VoidCallback onTogglePlay;

  const _VideoControls({required this.video, required this.onTogglePlay});

  @override
  Widget build(BuildContext context) {
    const white = Color(0xFFFFFFFF);
    const timeStyle = TextStyle(fontSize: 13, color: white, fontFeatures: [FontFeature.tabularFigures()]);
    return ValueListenableBuilder(
      valueListenable: video,
      builder: (context, value, _) => Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTogglePlay,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
              child: FaIcon(value.isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play, size: 20, color: white),
            ),
          ),
          Text(chatVideoTime(value.position), style: timeStyle),
          Expanded(child: _VideoScrubber(video: video)),
          Text(chatVideoTime(value.duration), style: timeStyle),
        ],
      ),
    );
  }
}

/// Полоса позиции видео: тап или протяжка — перемотка.
class _VideoScrubber extends StatefulWidget {
  final VideoPlayerController video;

  const _VideoScrubber({required this.video});

  @override
  State<_VideoScrubber> createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<_VideoScrubber> {
  /// Позиция под пальцем (0…1) во время протяжки — полоса идёт за пальцем, не
  /// дожидаясь, пока плеер перемотает.
  double? _drag;
  bool _wasPlaying = false;

  static const _padding = 12.0;

  double _fraction(Offset local, double width) => ((local.dx - _padding) / (width - _padding * 2)).clamp(0.0, 1.0);

  void _seek(double fraction) {
    final duration = widget.video.value.duration;
    widget.video.seekTo(duration * fraction);
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.video.value;
    final total = value.duration.inMilliseconds;
    final played = _drag ?? (total > 0 ? (value.position.inMilliseconds / total).clamp(0.0, 1.0) : 0.0);
    final buffered = total > 0 && value.buffered.isNotEmpty ? (value.buffered.last.end.inMilliseconds / total).clamp(0.0, 1.0) : 0.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (d) => _seek(_fraction(d.localPosition, width)),
          onHorizontalDragStart: (d) {
            _wasPlaying = widget.video.value.isPlaying;
            widget.video.pause();
            setState(() => _drag = _fraction(d.localPosition, width));
          },
          onHorizontalDragUpdate: (d) {
            setState(() => _drag = _fraction(d.localPosition, width));
            _seek(_drag!);
          },
          onHorizontalDragEnd: (_) {
            _seek(_drag ?? played);
            setState(() => _drag = null);
            if (_wasPlaying) widget.video.play();
          },
          child: SizedBox(
            height: 36,
            child: CustomPaint(
              painter: _ScrubberPainter(played: played, buffered: buffered, dragging: _drag != null, padding: _padding),
            ),
          ),
        );
      },
    );
  }
}

class _ScrubberPainter extends CustomPainter {
  final double played;
  final double buffered;
  final bool dragging;
  final double padding;

  const _ScrubberPainter({required this.played, required this.buffered, required this.dragging, required this.padding});

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final left = padding;
    final width = size.width - padding * 2;
    final track = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(left, y), Offset(left + width, y), track..color = const Color(0x40FFFFFF));
    canvas.drawLine(Offset(left, y), Offset(left + width * buffered, y), track..color = const Color(0x66FFFFFF));
    canvas.drawLine(Offset(left, y), Offset(left + width * played, y), track..color = const Color(0xFFFFFFFF));
    canvas.drawCircle(Offset(left + width * played, y), dragging ? 8 : 6, Paint()..color = const Color(0xFFFFFFFF));
  }

  @override
  bool shouldRepaint(_ScrubberPainter old) =>
      old.played != played || old.buffered != buffered || old.dragging != dragging || old.padding != padding;
}

/// Время видео: «1:05», от часа — «1:02:05».
String chatVideoTime(Duration d) {
  final s = d.inSeconds;
  final ss = (s % 60).toString().padLeft(2, '0');
  return s >= 3600 ? '${s ~/ 3600}:${(s ~/ 60 % 60).toString().padLeft(2, '0')}:$ss' : '${s ~/ 60}:$ss';
}

/// Круглая кнопка ▶ поверх кадра-превью видео.
class ChatVideoPlayBadge extends StatelessWidget {
  final double size;

  const ChatVideoPlayBadge({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Color(0x73000000), shape: BoxShape.circle),
      child: Padding(
        padding: EdgeInsets.only(left: size * 0.06),
        child: FaIcon(FontAwesomeIcons.play, size: size * 0.38, color: const Color(0xFFFFFFFF)),
      ),
    );
  }
}

/// Кадр-превью видео в пузыре: картинка, ▶ по центру и длительность в углу.
Widget chatVideoThumb(models.MessageMedia media, {double playSize = 48, int? cacheWidth}) {
  final seconds = media.duration;
  return Stack(
    fit: StackFit.expand,
    children: [
      ChatMediaImage(path: media.thumbPath, thumbhash: media.thumbhash, cacheWidth: cacheWidth),
      Center(child: ChatVideoPlayBadge(size: playSize)),
      if (seconds > 0)
        Positioned(
          left: 6,
          bottom: 6,
          child: DecoratedBox(
            decoration: BoxDecoration(color: const Color(0x80000000), borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 12, color: Color(0xFFFFFFFF)),
              ),
            ),
          ),
        ),
    ],
  );
}
