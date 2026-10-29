import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../chats/photo_edit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import 'gesture_exclusion.dart';
import 'media_crop.dart';

/// Редактор фото перед отправкой (как в Telegram): карандаш (цвет, толщина,
/// «Отменить») и кадрирование (свободно или с соотношением сторон) с
/// поворотом на 90°. Тёмный полноэкранный, как редактор видео; [accent] —
/// цвет «Готово» и включённых инструментов, [onAccent] — текст на его заливке.
///
/// Правки ([initial]) накладываются на исходник [path] заново при каждом
/// открытии — рисунок и рамку можно поменять. Результат: правки и путь к
/// готовому фото (оба `null` — «как в исходнике») или `null` — отмена без
/// изменений.
Future<({ChatPhotoEdit? edit, String? path})?> showChatPhotoEditor(
  BuildContext context, {
  required String path,
  ChatPhotoEdit? initial,
  required Color accent,
  Color onAccent = const Color(0xFFFFFFFF),
}) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<({ChatPhotoEdit? edit, String? path})>(
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, _) => _PhotoEditor(path: path, initial: initial, accent: accent, onAccent: onAccent),
      transitionsBuilder: (context, animation, _, child) => FadeTransition(opacity: animation, child: child),
    ),
  );
}

enum _Mode { view, draw, crop }

class _PhotoEditor extends StatefulWidget {
  final String path;
  final ChatPhotoEdit? initial;
  final Color accent;
  final Color onAccent;

  const _PhotoEditor({required this.path, required this.initial, required this.accent, required this.onAccent});

  @override
  State<_PhotoEditor> createState() => _PhotoEditorState();
}

class _PhotoEditorState extends State<_PhotoEditor> {
  /// Цвета карандаша.
  static const _colors = [
    Color(0xFFFF453A),
    Color(0xFFFF9F0A),
    Color(0xFFFFD60A),
    Color(0xFF32D74B),
    Color(0xFF0A84FF),
    Color(0xFFBF5AF2),
    Color(0xFFFFFFFF),
    Color(0xFF000000),
  ];

  /// Толщина линии на экране, логические пиксели.
  static const _widths = [3.0, 6.0, 12.0];

  /// Длинная сторона картинки для экрана (готовое фото — из исходника).
  static const _previewSide = 2048;

  ui.Image? _image;
  bool _failed = false;
  bool _saving = false;

  _Mode _mode = _Mode.view;
  Rect? _crop;
  int _rotation = 0;
  int _aspect = 0;
  late final List<ChatPhotoStroke> _strokes = [...?widget.initial?.strokes];
  int _color = 0;
  int _width = 1;

  /// Палец, которым сейчас рисуют (второй игнорируется).
  int? _pointer;

  /// Перерисовка линий во время рисования — без перестройки экрана.
  final _strokesChanged = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _crop = widget.initial?.crop;
    _rotation = widget.initial?.rotation ?? 0;
    _load();
  }

  Future<void> _load() async {
    try {
      final buffer = await ui.ImmutableBuffer.fromUint8List(await File(widget.path).readAsBytes());
      final codec = await ui.instantiateImageCodecWithSize(
        buffer,
        getTargetSize: (width, height) {
          final scale = math.min(1.0, _previewSide / math.max(width, height));
          return ui.TargetImageSize(width: (width * scale).round(), height: (height * scale).round());
        },
      );
      final image = (await codec.getNextFrame()).image;
      codec.dispose();
      if (!mounted) return image.dispose();
      setState(() => _image = image);
    } catch (e, s) {
      getIt.get<Logger>().handle(e, s, 'photo editor: ${widget.path}');
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _image?.dispose();
    _strokesChanged.dispose();
    super.dispose();
  }

  double get _sourceAspect {
    final image = _image;
    return image == null || image.height == 0 ? 1 : image.width / image.height;
  }

  bool get _frameEdited => _crop != null || _rotation != 0;

  bool get _edited => _frameEdited || _strokes.isNotEmpty;

  double? get _lockedRatio => MediaCrop.lockedRatio(_aspect, crop: _crop, rotation: _rotation, sourceAspect: _sourceAspect);

  void _setMode(_Mode mode) {
    setState(() {
      _mode = _mode == mode ? _Mode.view : mode;
      _crop = MediaCrop.normalized(_crop);
    });
    HapticFeedback.selectionClick();
  }

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

  void _undo() {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.removeLast());
    HapticFeedback.selectionClick();
  }

  void _reset() {
    setState(() {
      // В режиме инструмента «Сбросить» — только его правки.
      if (_mode != _Mode.crop) _strokes.clear();
      if (_mode != _Mode.draw) {
        _crop = null;
        _rotation = 0;
        _aspect = 0;
      }
    });
  }

  bool get _canReset => switch (_mode) {
    _Mode.view => _edited,
    _Mode.draw => _strokes.isNotEmpty,
    _Mode.crop => _frameEdited,
  };

  Future<void> _done() async {
    if (_saving) return;
    if (_image == null || !_edited) return Navigator.of(context).pop((edit: null, path: null));
    final edit = ChatPhotoEdit(crop: MediaCrop.normalized(_crop), rotation: _rotation, strokes: List.of(_strokes));
    setState(() => _saving = true);
    try {
      final path = await renderChatPhoto(widget.path, edit);
      if (mounted) Navigator.of(context).pop((edit: edit, path: path));
    } catch (e, s) {
      getIt.get<Logger>().handle(e, s, 'photo editor render: ${widget.path}');
      if (mounted) setState(() => _saving = false);
    }
  }

  void _strokeStart(PointerDownEvent event, Size size) {
    if (_pointer != null || size.width <= 0) return;
    _pointer = event.pointer;
    setState(() {
      _strokes.add(
        ChatPhotoStroke(color: _colors[_color], width: _widths[_width] / size.width, points: [_toFrame(event.localPosition, size)]),
      );
    });
  }

  void _strokeMove(PointerMoveEvent event, Size size) {
    if (event.pointer != _pointer || _strokes.isEmpty) return;
    _strokes.last.points.add(_toFrame(event.localPosition, size));
    _strokesChanged.value++;
  }

  void _strokeEnd(PointerEvent event) {
    if (event.pointer == _pointer) _pointer = null;
  }

  static Offset _toFrame(Offset local, Size size) => Offset(local.dx / size.width, local.dy / size.height);

  /// Кадр исходника целиком с рисунком; [draw] — рисовать по нему пальцем.
  Widget _frame({bool draw = false}) {
    final frame = Stack(
      fit: StackFit.expand,
      children: [
        RawImage(image: _image, fit: BoxFit.fill, filterQuality: FilterQuality.medium),
        CustomPaint(painter: _StrokesPainter(_strokes, repaint: _strokesChanged)),
      ],
    );
    if (!draw) return frame;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (e) => _strokeStart(e, size),
          onPointerMove: (e) => _strokeMove(e, size),
          onPointerUp: _strokeEnd,
          onPointerCancel: _strokeEnd,
          child: frame,
        );
      },
    );
  }

  Widget _canvas() {
    if (_mode == _Mode.crop) {
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
                    _frame(),
                    MediaCropOverlay(rect: _crop ?? MediaCrop.full, ratio: _lockedRatio, onChanged: (rect) => setState(() => _crop = rect)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    final reframed = ChatVideoReframe(
      crop: _crop,
      rotation: _rotation,
      sourceAspect: _sourceAspect,
      child: _frame(draw: _mode == _Mode.draw),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Center(child: _mode == _Mode.draw ? SystemGestureExclusion(child: reframed) : reframed),
    );
  }

  /// Толщина и цвет карандаша.
  Widget _palette() {
    const white = Color(0xFFFFFFFF);
    return SizedBox(
      height: 80,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (var i = 0; i < _widths.length; i++)
                _Swatch(
                  selected: i == _width,
                  ring: widget.accent,
                  onTap: () {
                    setState(() => _width = i);
                    HapticFeedback.selectionClick();
                  },
                  child: Container(
                    width: _widths[i] + 4,
                    height: _widths[i] + 4,
                    decoration: const BoxDecoration(color: white, shape: BoxShape.circle),
                  ),
                ),
              Container(width: 1, height: 24, margin: const EdgeInsets.symmetric(horizontal: 8), color: const Color(0x4DFFFFFF)),
              for (var i = 0; i < _colors.length; i++)
                _Swatch(
                  selected: i == _color,
                  ring: white,
                  onTap: () {
                    setState(() => _color = i);
                    HapticFeedback.selectionClick();
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _colors[i],
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x66FFFFFF), width: 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    const white = Color(0xFFFFFFFF);
    const disabled = Color(0x66FFFFFF);
    final textStyle = DefaultTextStyle.of(context).style.copyWith(color: white, decoration: TextDecoration.none, fontSize: 15);
    final ready = _image != null;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: const Color(0xFF000000),
        child: DefaultTextStyle(
          style: textStyle,
          child: SafeArea(
            child: Column(
              children: [
                // Шапка: отмена и «Готово».
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
                      const Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _done,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            t.common.done,
                            style: TextStyle(
                              color: _saving ? widget.accent.withValues(alpha: 0.4) : widget.accent,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _failed
                      ? Center(child: Text(t.screenChat.photoEditFailed))
                      : !ready
                      ? const SizedBox.shrink()
                      : _canvas(),
                ),
                if (ready) ...[
                  if (_mode == _Mode.crop)
                    MediaAspectChips(selected: _aspect, accent: widget.accent, onAccent: widget.onAccent, onSelected: _setAspect)
                  else if (_mode == _Mode.draw)
                    _palette()
                  else
                    const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (_mode == _Mode.draw)
                          MediaEditToolButton(
                            icon: FontAwesomeIcons.reply,
                            label: t.screenChat.photoUndo,
                            color: _strokes.isEmpty ? disabled : white,
                            onTap: _strokes.isEmpty ? null : _undo,
                          ),
                        if (_mode == _Mode.crop)
                          MediaEditToolButton(
                            icon: FontAwesomeIcons.rotateLeft,
                            label: t.screenChat.videoRotate,
                            color: white,
                            onTap: _rotate,
                          ),
                        MediaEditToolButton(
                          icon: FontAwesomeIcons.pen,
                          label: t.screenChat.photoDraw,
                          color: _mode == _Mode.draw ? widget.accent : white,
                          onTap: () => _setMode(_Mode.draw),
                        ),
                        MediaEditToolButton(
                          icon: FontAwesomeIcons.cropSimple,
                          label: t.screenChat.videoCrop,
                          color: _mode == _Mode.crop || _frameEdited ? widget.accent : white,
                          onTap: () => _setMode(_Mode.crop),
                        ),
                        MediaEditToolButton(
                          icon: FontAwesomeIcons.arrowRotateLeft,
                          label: t.screenChat.videoReset,
                          color: _canReset ? white : disabled,
                          onTap: _canReset ? _reset : null,
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

/// Кружок выбора в палитре; выбранный — в кольце [ring].
class _Swatch extends StatelessWidget {
  final bool selected;
  final Color ring;
  final VoidCallback onTap;
  final Widget child;

  const _Swatch({required this.selected, required this.ring, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: selected ? ring : const Color(0x00000000), width: 2),
        ),
        child: child,
      ),
    );
  }
}

class _StrokesPainter extends CustomPainter {
  final List<ChatPhotoStroke> strokes;

  _StrokesPainter(this.strokes, {super.repaint});

  @override
  void paint(Canvas canvas, Size size) => paintChatPhotoStrokes(canvas, size, strokes);

  // Линии меняются на месте — перерисовка по [repaint] и при перестройке.
  @override
  bool shouldRepaint(_StrokesPainter old) => true;
}
