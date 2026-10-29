import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../chats/video_prepare.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import 'gesture_exclusion.dart';
import 'media_crop.dart';
import 'media_viewer.dart';

/// Редактор видео перед отправкой (как в Telegram): обрезка по ленте кадров,
/// «без звука», обложка — текущий кадр, кадрирование (свободно или с
/// соотношением сторон) и поворот на 90°. Правки применяются при сжатии
/// ([prepareChatVideo]), исходник не меняется. Одинаков на iOS и Android
/// (тёмный полноэкранный, как просмотрщик), [accent] — цвет «Готово» и
/// включённых переключателей из темы платформы, [onAccent] — текст на
/// заливке [accent] (выбранное соотношение сторон).
///
/// Результат: правки ([ChatVideoEdit], `null` в поле — «сбросить всё»)
/// или `null` — отмена без изменений.
Future<({ChatVideoEdit? edit})?> showChatVideoEditor(
  BuildContext context, {
  required String path,
  ChatVideoEdit? initial,
  required Color accent,
  Color onAccent = const Color(0xFFFFFFFF),
}) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<({ChatVideoEdit? edit})>(
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, _) => _VideoEditor(path: path, initial: initial, accent: accent, onAccent: onAccent),
      transitionsBuilder: (context, animation, _, child) => FadeTransition(opacity: animation, child: child),
    ),
  );
}

class _VideoEditor extends StatefulWidget {
  final String path;
  final ChatVideoEdit? initial;
  final Color accent;
  final Color onAccent;

  const _VideoEditor({required this.path, required this.initial, required this.accent, required this.onAccent});

  @override
  State<_VideoEditor> createState() => _VideoEditorState();
}

class _VideoEditorState extends State<_VideoEditor> {
  late final _video = VideoPlayerController.file(File(widget.path));
  bool _ready = false;
  bool _failed = false;
  List<String> _frames = const [];

  /// Длительность исходника, мс.
  int _duration = 0;
  int _start = 0;
  int _end = 0;
  bool _mute = false;
  int? _cover;

  /// Кадрирование в долях кадра исходника до поворота ([ChatVideoEdit.crop]);
  /// `null` — весь кадр.
  Rect? _crop;

  /// Поворот по часовой стрелке, градусы.
  int _rotation = 0;

  /// Режим кадрирования: вместо ленты — рамка поверх всего кадра.
  bool _cropMode = false;

  /// Выбранное соотношение сторон рамки (индекс в [_aspects]).
  int _aspect = 0;

  /// Отрезок короче не оставляем (видео и так короче — его длина).
  int get _minLength => math.min(1000, _duration);

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _mute = initial?.mute ?? false;
    _cover = initial?.coverMs;
    _crop = initial?.crop;
    _rotation = initial?.rotation ?? 0;
    _video.addListener(_onTick);
    _video
        .initialize()
        .then((_) async {
          if (!mounted) return;
          final duration = _video.value.duration.inMilliseconds;
          setState(() {
            _ready = true;
            _duration = duration;
            _start = (initial?.startMs ?? 0).clamp(0, math.max(0, duration - _minLength));
            final end = initial?.endMs ?? 0;
            _end = end > 0 ? end.clamp(_start + _minLength, duration) : duration;
          });
          await _video.setVolume(_mute ? 0 : 1);
          await _video.seekTo(Duration(milliseconds: _start));
          await _video.play();
        })
        .catchError((Object e, StackTrace s) {
          getIt.get<Logger>().handle(e, s, 'video editor: ${widget.path}');
          if (mounted) setState(() => _failed = true);
        });
    chatVideoFrames(widget.path).then((frames) {
      if (mounted) setState(() => _frames = frames);
    });
  }

  @override
  void dispose() {
    _video.removeListener(_onTick);
    _video.dispose();
    super.dispose();
  }

  /// Играет по кругу внутри отрезка.
  void _onTick() {
    final value = _video.value;
    if (!_ready || !value.isPlaying) return;
    if (value.position.inMilliseconds >= _end || value.isCompleted) _video.seekTo(Duration(milliseconds: _start));
  }

  void _togglePlay() {
    if (!_ready) return;
    if (_video.value.isPlaying) {
      _video.pause();
    } else {
      final position = _video.value.position.inMilliseconds;
      if (position < _start || position >= _end - 50) _video.seekTo(Duration(milliseconds: _start));
      _video.play();
    }
  }

  void _toggleMute() {
    setState(() => _mute = !_mute);
    _video.setVolume(_mute ? 0 : 1);
    HapticFeedback.selectionClick();
  }

  void _setCover() {
    setState(() => _cover = _video.value.position.inMilliseconds.clamp(_start, _end));
    HapticFeedback.selectionClick();
  }

  void _reset() {
    // В режиме кадрирования «Сбросить» — только рамку и поворот.
    if (_cropMode) {
      setState(() {
        _crop = null;
        _rotation = 0;
        _aspect = 0;
      });
      return;
    }
    setState(() {
      _start = 0;
      _end = _duration;
      _mute = false;
      _cover = null;
      _crop = null;
      _rotation = 0;
      _aspect = 0;
    });
    _video.setVolume(1);
    _video.seekTo(Duration.zero);
  }

  bool get _frameEdited => _crop != null || _rotation != 0;

  bool get _edited => _start > 0 || _end < _duration || _mute || _cover != null || _frameEdited;

  /// Соотношение сторон кадра исходника, как он показывается.
  double get _sourceAspect {
    final aspect = _video.value.aspectRatio;
    return aspect > 0 ? aspect : 1;
  }

  /// Зафиксированное отношение ширины рамки к высоте в долях кадра
  /// исходника; `null` — свободно.
  double? get _lockedRatio => MediaCrop.lockedRatio(_aspect, crop: _crop, rotation: _rotation, sourceAspect: _sourceAspect);

  void _setAspect(int index) {
    setState(() => _aspect = index);
    HapticFeedback.selectionClick();
    final ratio = _lockedRatio;
    if (ratio != null) setState(() => _crop = MediaCrop.fitRatio(ratio, _crop));
  }

  void _rotate() {
    // Против часовой, как в Telegram и «Фото».
    setState(() => _rotation = (_rotation + 270) % 360);
    HapticFeedback.selectionClick();
  }

  void _toggleCropMode() {
    setState(() {
      _cropMode = !_cropMode;
      _crop = MediaCrop.normalized(_crop);
    });
    HapticFeedback.selectionClick();
  }

  void _done() {
    if (!_ready) return Navigator.of(context).pop();
    final cover = _cover;
    Navigator.of(context).pop((
      edit: _edited
          ? ChatVideoEdit(
              startMs: _start,
              endMs: _end < _duration ? _end : 0,
              mute: _mute,
              // Обложку за пределами нового отрезка не оставляем.
              coverMs: cover != null && cover >= _start && cover <= _end ? cover : null,
              crop: MediaCrop.normalized(_crop),
              rotation: _rotation,
            )
          : null,
    ));
  }

  /// Режим кадрирования: весь кадр (с поворотом) и рамка поверх.
  Widget _cropView() {
    return Padding(
      // Углы рамки — не у самого края, где жест «назад».
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Center(
        child: SystemGestureExclusion(
          // Рамка внутри поворота: жесты и рисование — в координатах исходника.
          child: RotatedBox(
            quarterTurns: _rotation ~/ 90,
            child: AspectRatio(
              aspectRatio: _sourceAspect,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoPlayer(_video),
                  MediaCropOverlay(rect: _crop ?? MediaCrop.full, ratio: _lockedRatio, onChanged: (rect) => setState(() => _crop = rect)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    const white = Color(0xFFFFFFFF);
    final textStyle = DefaultTextStyle.of(context).style.copyWith(color: white, decoration: TextDecoration.none, fontSize: 15);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: const Color(0xFF000000),
        child: DefaultTextStyle(
          style: textStyle,
          child: SafeArea(
            child: Column(
              children: [
                // Шапка: отмена, длительность отрезка, «Готово».
                SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: FaIcon(FontAwesomeIcons.xmark, size: 22, color: white),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: _ready
                              ? Text(
                                  chatVideoTime(Duration(milliseconds: _end - _start)),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontFeatures: [FontFeature.tabularFigures()]),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _done,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            t.common.done,
                            style: TextStyle(color: widget.accent, fontWeight: FontWeight.w600, fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _failed
                      ? Center(child: Text(t.screenChat.videoEditFailed))
                      : !_ready
                      ? const SizedBox.shrink()
                      : _cropMode
                      ? _cropView()
                      : GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _togglePlay,
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ChatVideoReframe(crop: _crop, rotation: _rotation, sourceAspect: _sourceAspect, child: VideoPlayer(_video)),
                                ValueListenableBuilder(
                                  valueListenable: _video,
                                  builder: (context, value, _) =>
                                      value.isPlaying ? const SizedBox.shrink() : const ChatVideoPlayBadge(size: 64),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                if (_ready && _duration > 0) ...[
                  if (_cropMode)
                    MediaAspectChips(selected: _aspect, accent: widget.accent, onAccent: widget.onAccent, onSelected: _setAspect)
                  else
                    Padding(
                      // Отступ побольше — ползунки не у самого края, где жест «назад».
                      padding: const EdgeInsets.fromLTRB(28, 16, 28, 8),
                      child: SystemGestureExclusion(
                        child: _Timeline(
                          video: _video,
                          frames: _frames,
                          duration: _duration,
                          start: _start,
                          end: _end,
                          cover: _cover,
                          minLength: _minLength,
                          onRange: (start, end) => setState(() {
                            _start = start;
                            _end = end;
                          }),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (_cropMode)
                          MediaEditToolButton(
                            icon: FontAwesomeIcons.rotateLeft,
                            label: t.screenChat.videoRotate,
                            color: white,
                            onTap: _rotate,
                          )
                        else ...[
                          MediaEditToolButton(
                            icon: _mute ? FontAwesomeIcons.volumeXmark : FontAwesomeIcons.volumeHigh,
                            label: _mute ? t.screenChat.videoMuted : t.screenChat.videoSound,
                            color: _mute ? widget.accent : white,
                            onTap: _toggleMute,
                          ),
                          MediaEditToolButton(
                            icon: FontAwesomeIcons.image,
                            label: _cover != null ? t.screenChat.videoCoverSet : t.screenChat.videoCover,
                            color: _cover != null ? widget.accent : white,
                            onTap: _setCover,
                          ),
                        ],
                        MediaEditToolButton(
                          icon: FontAwesomeIcons.cropSimple,
                          label: t.screenChat.videoCrop,
                          color: _cropMode || _frameEdited ? widget.accent : white,
                          onTap: _toggleCropMode,
                        ),
                        Builder(
                          builder: (context) {
                            final enabled = _cropMode ? _frameEdited : _edited;
                            return MediaEditToolButton(
                              icon: FontAwesomeIcons.arrowRotateLeft,
                              label: t.screenChat.videoReset,
                              color: enabled ? white : const Color(0x66FFFFFF),
                              onTap: enabled ? _reset : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Лента кадров с рамкой отрезка: ручки по краям двигают начало и конец,
/// протяжка внутри — перемотка; белая черта — текущая позиция, точка снизу —
/// обложка.
class _Timeline extends StatefulWidget {
  final VideoPlayerController video;
  final List<String> frames;
  final int duration;
  final int start;
  final int end;
  final int? cover;
  final int minLength;
  final void Function(int start, int end) onRange;

  const _Timeline({
    required this.video,
    required this.frames,
    required this.duration,
    required this.start,
    required this.end,
    required this.cover,
    required this.minLength,
    required this.onRange,
  });

  @override
  State<_Timeline> createState() => _TimelineState();
}

enum _Drag { start, end, seek }

class _TimelineState extends State<_Timeline> {
  static const _height = 52.0;
  static const _handle = 16.0;

  /// Запас попадания по ручке за её пределами.
  static const _slop = 14.0;

  _Drag? _drag;
  bool _wasPlaying = false;

  double _x(int ms, double width) => _handle + (width - _handle * 2) * ms / widget.duration;

  int _ms(double x, double width) => ((x - _handle) / (width - _handle * 2) * widget.duration).round().clamp(0, widget.duration);

  void _seek(int ms) => widget.video.seekTo(Duration(milliseconds: ms));

  void _onStart(Offset local, double width) {
    final left = _x(widget.start, width) - _handle / 2;
    final right = _x(widget.end, width) + _handle / 2;
    final dLeft = (local.dx - left).abs();
    final dRight = (local.dx - right).abs();
    _drag = dLeft <= _handle / 2 + _slop && dLeft <= dRight
        ? _Drag.start
        : dRight <= _handle / 2 + _slop
        ? _Drag.end
        : _Drag.seek;
    _wasPlaying = widget.video.value.isPlaying;
    widget.video.pause();
    _onUpdate(local, width);
  }

  void _onUpdate(Offset local, double width) {
    switch (_drag) {
      case _Drag.start:
        final start = _ms(local.dx + _handle / 2, width).clamp(0, widget.end - widget.minLength);
        if (start != widget.start) {
          widget.onRange(start, widget.end);
          _seek(start);
        }
      case _Drag.end:
        final end = _ms(local.dx - _handle / 2, width).clamp(widget.start + widget.minLength, widget.duration);
        if (end != widget.end) {
          widget.onRange(widget.start, end);
          _seek(end);
        }
      case _Drag.seek:
        _seek(_ms(local.dx, width).clamp(widget.start, widget.end));
      case null:
        break;
    }
  }

  void _onEnd() {
    // После правки границ играем отрезок с начала, перемотку — с места.
    if (_drag != _Drag.seek) _seek(widget.start);
    if (_wasPlaying || _drag != _Drag.seek) widget.video.play();
    _drag = null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (d) => _onStart(d.localPosition, width),
          onHorizontalDragUpdate: (d) => _onUpdate(d.localPosition, width),
          onHorizontalDragEnd: (_) => _onEnd(),
          onHorizontalDragCancel: _onEnd,
          onTapUp: (d) {
            _seek(_ms(d.localPosition.dx, width).clamp(widget.start, widget.end));
          },
          child: SizedBox(
            height: _height + 12,
            child: Stack(
              children: [
                // Кадры.
                Positioned(
                  left: _handle,
                  right: _handle,
                  top: 6,
                  height: _height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Row(
                      children: [
                        for (final frame in widget.frames.isEmpty ? List.filled(10, '') : widget.frames)
                          Expanded(
                            child: frame.isEmpty
                                ? const ColoredBox(color: Color(0xFF2C2C2E))
                                : Image.file(File(frame), fit: BoxFit.cover, height: _height, gaplessPlayback: true),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: ValueListenableBuilder(
                    valueListenable: widget.video,
                    builder: (context, value, _) => CustomPaint(
                      painter: _TimelinePainter(
                        start: _x(widget.start, width),
                        end: _x(widget.end, width),
                        position: _x(value.position.inMilliseconds.clamp(widget.start, widget.end), width),
                        cover: widget.cover == null ? null : _x(widget.cover!, width),
                        handle: _handle,
                        top: 6,
                        height: _height,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final double start;
  final double end;
  final double position;
  final double? cover;
  final double handle;
  final double top;
  final double height;

  const _TimelinePainter({
    required this.start,
    required this.end,
    required this.position,
    required this.cover,
    required this.handle,
    required this.top,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const white = Color(0xFFFFFFFF);
    final bottom = top + height;
    // Вне отрезка — затемнение.
    final dim = Paint()..color = const Color(0xB3000000);
    canvas.drawRect(Rect.fromLTRB(handle, top, start, bottom), dim);
    canvas.drawRect(Rect.fromLTRB(end, top, size.width - handle, bottom), dim);

    // Рамка: ручки по бокам (скруглённые снаружи) и полосы сверху и снизу.
    final frame = Paint()..color = white;
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(start - handle, top, start, bottom, topLeft: const Radius.circular(6), bottomLeft: const Radius.circular(6)),
      frame,
    );
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(end, top, end + handle, bottom, topRight: const Radius.circular(6), bottomRight: const Radius.circular(6)),
      frame,
    );
    canvas.drawRect(Rect.fromLTRB(start, top, end, top + 2.5), frame);
    canvas.drawRect(Rect.fromLTRB(start, bottom - 2.5, end, bottom), frame);

    // Насечки на ручках.
    final grip = Paint()
      ..color = const Color(0xFF1C1C1E)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final mid = top + height / 2;
    canvas.drawLine(Offset(start - handle / 2, mid - 7), Offset(start - handle / 2, mid + 7), grip);
    canvas.drawLine(Offset(end + handle / 2, mid - 7), Offset(end + handle / 2, mid + 7), grip);

    // Текущая позиция.
    final line = Paint()
      ..color = white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(position, top - 3), Offset(position, bottom + 3), line);

    // Обложка — точка под лентой.
    final cover = this.cover;
    if (cover != null) canvas.drawCircle(Offset(cover, bottom + 4), 2.5, Paint()..color = white);
  }

  @override
  bool shouldRepaint(_TimelinePainter old) =>
      old.start != start || old.end != end || old.position != position || old.cover != cover || old.height != height;
}
