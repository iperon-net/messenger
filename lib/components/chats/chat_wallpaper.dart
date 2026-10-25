import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Узоры обоев чатов — `assets/wallpapers/<id>.svg` (генерируются скриптом
/// `tool/wallpapers/generate.py`).
const chatWallpaperPatterns = ['chat', 'space', 'nature', 'music', 'geometry', 'food'];
const chatWallpaperDefaultPattern = 'chat';

/// Сохранённый узор, а неизвестный (в т.ч. прежний 'none' — «Без узора») —
/// узор по умолчанию.
String chatWallpaperPatternOf(String pattern) => chatWallpaperPatterns.contains(pattern) ? pattern : chatWallpaperDefaultPattern;

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

/// Интенсивность узора (видимость, 0–100 %): по умолчанию и пределы ползунка.
const chatWallpaperIntensityDefault = 40;
const chatWallpaperIntensityMin = 10;
const chatWallpaperIntensityMax = 100;

/// Готовые цвета обоев под тему: градиент фона сверху вниз и цвет узора.
class ChatWallpaperColors {
  final Color top;
  final Color bottom;
  final Color pattern;

  const ChatWallpaperColors({required this.top, required this.bottom, required this.pattern});

  static ChatWallpaperColors of(int index, {required bool dark, int intensity = chatWallpaperIntensityDefault}) {
    final (hue, saturation) = _palette[index.clamp(0, _palette.length - 1)];
    Color hsl(double h, double s, double l, [double a = 1]) => HSLColor.fromAHSL(a, h % 360, s.clamp(0, 1), l).toColor();
    // Непрозрачность узора при 100 %; по умолчанию (40 %) — 0.12 / 0.18.
    final alpha = intensity.clamp(0, chatWallpaperIntensityMax) / chatWallpaperIntensityMax;
    if (dark) {
      return ChatWallpaperColors(
        top: hsl(hue, saturation * 0.55, 0.15),
        bottom: hsl(hue + 15, saturation * 0.55, 0.09),
        pattern: hsl(hue, saturation * 0.8, 0.72, 0.3 * alpha),
      );
    }
    return ChatWallpaperColors(
      top: hsl(hue, saturation * 0.9, 0.87),
      bottom: hsl(hue + 15, saturation * 0.8, 0.78),
      pattern: hsl(hue, saturation, 0.3, 0.45 * alpha),
    );
  }
}

/// Обои окна чата: градиент выбранного цвета + повторяющийся узор, свои для
/// светлой и тёмной темы ([dark]). [intensity] — видимость узора в процентах,
/// [tileScale] — размер плитки узора (в превью — мельче).
class ChatWallpaper extends StatefulWidget {
  final String pattern;
  final int colorIndex;
  final bool dark;
  final int intensity;
  final double tileScale;

  const ChatWallpaper({
    super.key,
    required this.pattern,
    required this.colorIndex,
    required this.dark,
    this.intensity = chatWallpaperIntensityDefault,
    this.tileScale = 0.9,
  });

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
    final pattern = chatWallpaperPatternOf(widget.pattern);
    if (_loaded.containsKey(pattern)) return;
    _cache
        .putIfAbsent(pattern, () => vg.loadPicture(SvgAssetLoader('assets/wallpapers/$pattern.svg'), null))
        .then((info) {
          _loaded[pattern] = info;
          if (mounted) setState(() {});
        })
        .catchError((Object _) {});
  }

  /// Плитка узора уже в цвете темы, растром ([_PatternTile]); своя копия
  /// (clone) — освобождается вместе с виджетом.
  ui.Image? _tile;
  _PatternTileKey? _tileKey;

  ui.Image? _tileFor(_PatternTileKey key, PictureInfo picture) {
    if (_tileKey == key) return _tile;
    _tile?.dispose();
    _tileKey = key;
    return _tile = _PatternTile.of(key, picture)?.clone();
  }

  @override
  void dispose() {
    _tile?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ChatWallpaperColors.of(widget.colorIndex, dark: widget.dark, intensity: widget.intensity);
    final pattern = chatWallpaperPatternOf(widget.pattern);
    final picture = _loaded[pattern];
    final key = (pattern: pattern, color: colors.pattern, scale: widget.tileScale, pixelRatio: MediaQuery.devicePixelRatioOf(context));
    final tile = picture == null ? null : _tileFor(key, picture);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [colors.top, colors.bottom]),
      ),
      child: picture == null || tile == null
          ? const SizedBox.expand()
          // Свой слой: лента сообщений над обоями перерисовывается при прокрутке,
          // узор — нет.
          : RepaintBoundary(
              child: CustomPaint(
                size: Size.infinite,
                painter: _PatternPainter(tile: tile, size: picture.size * widget.tileScale),
              ),
            ),
    );
  }
}

typedef _PatternTileKey = ({String pattern, Color color, double scale, double pixelRatio});

/// Плитки узора растром: SVG — сотня с лишним штрихов на плитку, а Impeller не
/// кэширует векторную картинку между кадрами и заново строит каждый штрих на
/// всех плитках экрана в каждом кадре — переход в чат и прокрутка теряли кадры.
/// Растр рисуется один раз на узор/цвет/масштаб и дальше это одна текстура.
abstract final class _PatternTile {
  static final _cache = <_PatternTileKey, ui.Image>{};

  /// Узоров на экране одновременно немного (чат, превью в «Оформлении»).
  static const _limit = 8;

  static ui.Image? of(_PatternTileKey key, PictureInfo picture) {
    final cached = _cache.remove(key);
    if (cached != null) return _cache[key] = cached;

    final size = picture.size;
    final width = (size.width * key.scale * key.pixelRatio).round();
    final height = (size.height * key.scale * key.pixelRatio).round();
    if (width <= 0 || height <= 0) return null;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(width / size.width, height / size.height);
    // Узор чёрный — перекрашиваем в цвет темы (с прозрачностью) одним слоем.
    canvas
      ..saveLayer(Offset.zero & size, Paint()..colorFilter = ui.ColorFilter.mode(key.color, BlendMode.srcIn))
      ..drawPicture(picture.picture)
      ..restore();
    final recorded = recorder.endRecording();
    final image = recorded.toImageSync(width, height);
    recorded.dispose();

    if (_cache.length >= _limit) _cache.remove(_cache.keys.first)?.dispose();
    return _cache[key] = image;
  }
}

class _PatternPainter extends CustomPainter {
  final ui.Image tile;

  /// Размер плитки в логических пикселях.
  final Size size;

  _PatternPainter({required this.tile, required this.size});

  @override
  void paint(Canvas canvas, Size area) {
    final transform = Matrix4.diagonal3Values(size.width / tile.width, size.height / tile.height, 1);
    final paint = Paint()
      ..filterQuality = FilterQuality.low
      ..shader = ImageShader(tile, TileMode.repeated, TileMode.repeated, transform.storage);
    canvas.drawRect(Offset.zero & area, paint);
  }

  @override
  bool shouldRepaint(_PatternPainter oldDelegate) => oldDelegate.tile != tile || oldDelegate.size != size;
}
