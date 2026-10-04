import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Узоры обоев чатов — `assets/wallpapers/<id>.svg` (генерируются скриптом
/// `tool/wallpapers/generate.py`); [chatWallpaperNone] — только цвет.
const chatWallpaperNone = 'none';
const chatWallpaperPatterns = [chatWallpaperNone, 'chat', 'space', 'nature', 'music', 'geometry', 'food'];
const chatWallpaperDefaultPattern = 'chat';

/// Цвета обоев: тон (hue) и насыщенность; светлый и тёмный вариант считаются
/// из них (см. [ChatWallpaperColors.of]).
const _palette = <(double hue, double saturation)>[
  (210, 0.55), // голубой
  (150, 0.40), // зелёный
  (185, 0.45), // бирюзовый
  (265, 0.40), // фиолетовый
  (330, 0.45), // розовый
  (28, 0.60), // оранжевый
  (48, 0.65), // жёлтый
  (220, 0.08), // серый
];

int get chatWallpaperColorCount => _palette.length;

/// Готовые цвета обоев под тему: градиент фона сверху вниз и цвет узора.
class ChatWallpaperColors {
  final Color top;
  final Color bottom;
  final Color pattern;

  const ChatWallpaperColors({required this.top, required this.bottom, required this.pattern});

  static ChatWallpaperColors of(int index, {required bool dark}) {
    final (hue, saturation) = _palette[index.clamp(0, _palette.length - 1)];
    Color hsl(double h, double s, double l, [double a = 1]) => HSLColor.fromAHSL(a, h % 360, s.clamp(0, 1), l).toColor();
    if (dark) {
      return ChatWallpaperColors(
        top: hsl(hue, saturation * 0.55, 0.15),
        bottom: hsl(hue + 15, saturation * 0.55, 0.09),
        pattern: hsl(hue, saturation * 0.8, 0.72, 0.12),
      );
    }
    return ChatWallpaperColors(
      top: hsl(hue, saturation * 0.9, 0.87),
      bottom: hsl(hue + 15, saturation * 0.8, 0.78),
      pattern: hsl(hue, saturation, 0.3, 0.18),
    );
  }
}

/// Обои окна чата: градиент выбранного цвета + повторяющийся узор, свои для
/// светлой и тёмной темы ([dark]). [tileScale] — размер плитки узора (в
/// превью — мельче).
class ChatWallpaper extends StatefulWidget {
  final String pattern;
  final int colorIndex;
  final bool dark;
  final double tileScale;

  const ChatWallpaper({super.key, required this.pattern, required this.colorIndex, required this.dark, this.tileScale = 0.9});

  @override
  State<ChatWallpaper> createState() => _ChatWallpaperState();
}

class _ChatWallpaperState extends State<ChatWallpaper> {
  /// Разобранные SVG — одни на всё приложение.
  static final _cache = <String, Future<PictureInfo>>{};
  static final _loaded = <String, PictureInfo>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(ChatWallpaper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pattern != widget.pattern) _load();
  }

  void _load() {
    final pattern = widget.pattern;
    if (pattern == chatWallpaperNone || _loaded.containsKey(pattern)) return;
    _cache
        .putIfAbsent(pattern, () => vg.loadPicture(SvgAssetLoader('assets/wallpapers/$pattern.svg'), null))
        .then((info) {
          _loaded[pattern] = info;
          if (mounted) setState(() {});
        })
        .catchError((Object _) {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = ChatWallpaperColors.of(widget.colorIndex, dark: widget.dark);
    final picture = _loaded[widget.pattern];
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [colors.top, colors.bottom]),
      ),
      child: picture == null
          ? const SizedBox.expand()
          // Свой слой: лента сообщений над обоями перерисовывается при прокрутке,
          // узор — нет.
          : RepaintBoundary(
              child: CustomPaint(
                size: Size.infinite,
                painter: _PatternPainter(picture: picture, color: colors.pattern, scale: widget.tileScale),
              ),
            ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final PictureInfo picture;
  final Color color;
  final double scale;

  _PatternPainter({required this.picture, required this.color, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final tile = picture.size * scale;
    if (tile.isEmpty) return;
    // Узор чёрный — перекрашиваем в цвет темы (с прозрачностью) одним слоем.
    canvas.saveLayer(Offset.zero & size, Paint()..colorFilter = ui.ColorFilter.mode(color, BlendMode.srcIn));
    for (var y = 0.0; y < size.height; y += tile.height) {
      for (var x = 0.0; x < size.width; x += tile.width) {
        canvas
          ..save()
          ..translate(x, y)
          ..scale(scale)
          ..drawPicture(picture.picture)
          ..restore();
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PatternPainter oldDelegate) =>
      oldDelegate.picture != picture || oldDelegate.color != color || oldDelegate.scale != scale;
}
