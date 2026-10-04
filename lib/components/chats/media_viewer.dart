import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  const ChatMediaItem({required this.message, required this.index, required this.kind, required this.localPath});

  /// Общий тег Hero миниатюры в пузыре и страницы просмотрщика.
  Object get heroTag => chatMediaHeroTag(message, index);

  static List<ChatMediaItem> of(List<models.Message> messages) => [
    for (final m in messages)
      if (!m.service)
        if (m.isAlbum)
          for (final (i, media) in m.media.indexed) ChatMediaItem(message: m, index: i, kind: media.kind, localPath: media.localPath)
        else if (m.kind == models.MessageKind.photo || m.kind == models.MessageKind.video)
          ChatMediaItem(message: m, index: 0, kind: m.kind, localPath: m.localPath),
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

/// Полноэкранный просмотр всех фото/видео чата ([messages]), начиная с
/// [index]-го медиа сообщения [message]: листание вбок, щипок и двойной тап —
/// зум, свайп вниз/вверх — закрыть, тап — спрятать/показать панели.
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

  @override
  void dispose() {
    _pages.dispose();
    _dragBack.dispose();
    super.dispose();
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
                    }),
                    itemBuilder: (context, i) => _ZoomablePage(
                      item: widget.items[i],
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
                    if (m.text.isNotEmpty)
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
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(m.text, maxLines: 6, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16)),
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
  final ValueChanged<bool> onZoomChanged;

  const _ZoomablePage({required this.item, required this.onZoomChanged});

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
    final video = item.kind == models.MessageKind.video;
    final Widget media = item.localPath.isNotEmpty && !video
        ? Image.file(File(item.localPath), fit: BoxFit.contain)
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
