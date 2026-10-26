import 'dart:async';
import 'dart:io';

import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../device_performance.dart';
import '../di.dart';
import '../logger.dart';
import '../models.dart' as models;
import '../network_usage.dart';
import '../settings.dart';
import 'big_emoji.dart';

/// Анимированные эмодзи — Google Noto Animated Emoji (Lottie, CC BY 4.0) через
/// пакет animated_emoji (данные и имена). Анимируем только крупные эмодзи и
/// реакцию в момент выбора; в тексте и в панели — обычные.
///
/// Откуда: популярные — в приложении ([bundledAnimatedEmoji], ассеты пакета в
/// pubspec), остальные — с нашего CDN (`Settings.animatedEmojiUrl`, копия
/// набора) с кэшем на диске. С серверов Google не грузим: они бы видели, кому
/// какой эмодзи пришёл.
class AnimatedEmojiStore {
  AnimatedEmojiStore._();

  /// id Noto (код точек через «_», напр. `2764_fe0f`) → данные, вместе с
  /// вариантами оттенков кожи.
  static final Map<String, AnimatedEmojiData> _byID = {
    for (final emoji in AnimatedEmojis.values)
      for (final variant in emoji.variations) variant.id: variant,
  };

  /// Анимация для одного эмодзи (графемного кластера); `null` — нет такой.
  /// Селектор вида U+FE0F в тексте бывает и не бывает — пробуем оба.
  static AnimatedEmojiData? lookup(String emoji) {
    final runes = emoji.runes.toList();
    if (runes.isEmpty) return null;
    String id(Iterable<int> codes) => codes.map((c) => c.toRadixString(16)).join('_');
    final candidates = [
      id(runes),
      id(runes.where((c) => c != 0xFE0F)),
      if (runes.length == 1) id([runes.first, 0xFE0F]),
    ];
    for (final candidate in candidates) {
      final data = _byID[candidate];
      if (data != null) return data;
    }
    return null;
  }

  /// Анимации для всех эмодзи [text] — только если она есть у каждого (иначе
  /// `null`: смесь анимированных и статичных выглядит странно).
  static List<AnimatedEmojiData>? forText(String text) {
    final result = <AnimatedEmojiData>[];
    for (final cluster in text.characters) {
      if (cluster.trim().isEmpty) continue;
      final data = lookup(cluster);
      if (data == null) return null;
      result.add(data);
    }
    return result.isEmpty ? null : result;
  }

  static final _loads = <String, Future<LottieComposition?>>{};
  static Directory? _dir;

  /// Анимация, уже загруженная в память (без ожидания — для первого кадра).
  static final _ready = <String, LottieComposition>{};

  static LottieComposition? ready(AnimatedEmojiData data) => _ready[data.name];

  /// Загрузка (ассет / файл кэша / CDN); `null` — не вышло (статичный эмодзи).
  /// Неудача забывается через минуту — повторим позже, а не на каждый кадр.
  static Future<LottieComposition?> load(AnimatedEmojiData data) {
    final name = data.name;
    return _loads.putIfAbsent(name, () async {
      try {
        final composition = await LottieComposition.fromBytes(await _bytes(name));
        _ready[name] = composition;
        return composition;
      } catch (error, stackTrace) {
        getIt.get<Logger>().handle(error, stackTrace);
        Timer(const Duration(minutes: 1), () => _loads.remove(name));
        return null;
      }
    });
  }

  static Future<Uint8List> _bytes(String name) async {
    if (bundledAnimatedEmoji.contains(name)) {
      final asset = await rootBundle.load('packages/animated_emoji/lottie/$name.json');
      return asset.buffer.asUint8List();
    }
    final dir = _dir ??= Directory(p.join((await getApplicationSupportDirectory()).path, 'emoji', 'noto'));
    final file = File(p.join(dir.path, '$name.json'));
    if (await file.exists()) return file.readAsBytes();

    final url = Uri.parse('${getIt.get<Settings>().animatedEmojiUrl}$name.json');
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
    try {
      final response = await (await client.getUrl(url)).close();
      if (response.statusCode != HttpStatus.ok) throw HttpException('animated emoji: ${response.statusCode}', uri: url);
      final bytes = await consolidateHttpClientResponseBytes(response);
      NetworkUsage.instance.add(models.TrafficCategory.other, received: bytes.length);
      await dir.create(recursive: true);
      // Во временный и переименованием — недокачанный файл не останется.
      final tmp = File('${file.path}.part');
      await tmp.writeAsBytes(bytes, flush: true);
      await tmp.rename(file.path);
      return bytes;
    } finally {
      client.close();
    }
  }
}

/// Популярные (встроены в приложение — без сети и сразу). Имена файлов пакета;
/// тот же список — ассетами в pubspec.yaml.
const bundledAnimatedEmoji = {
  'redHeart', 'thumbsUp', 'joy', 'fire', 'partyPopper', 'heartEyes', 'cry', 'loudlyCrying', //
  'grin', 'smile', 'foldedHands', 'clap', 'mouthOpen', 'screaming', 'rofl', 'kissingHeart', //
  'heartFace', 'thinkingFace', 'sunglassesFace', 'ok', 'oneHundred', 'rage', 'partyingFace', 'grinSweat', //
  'mindBlown', 'starStruck', 'sleep', 'seeNoEvilMonkey', 'brokenHeart', 'sparkles', 'eyes', 'wink', //
  'hugFace', 'winkyTongue', 'pleading', 'laughing', 'grinning', 'thumbsDown', 'handshake', 'muscle', //
};

/// Крупные эмодзи сообщения анимацией: один раз при появлении, тап — ещё раз
/// (с лёгкой вибрацией). Нет анимации у какого-то эмодзи или она ещё не
/// загружена — обычный крупный текст.
class AnimatedBigEmoji extends StatefulWidget {
  final String text;
  final TextStyle style;

  const AnimatedBigEmoji({super.key, required this.text, required this.style});

  @override
  State<AnimatedBigEmoji> createState() => _AnimatedBigEmojiState();
}

class _AnimatedBigEmojiState extends State<AnimatedBigEmoji> with TickerProviderStateMixin {
  List<AnimatedEmojiData>? _emoji;
  List<LottieComposition>? _compositions;
  final _controllers = <AnimationController>[];

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  @override
  void didUpdateWidget(AnimatedBigEmoji oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) _resolve();
  }

  Future<void> _resolve() async {
    // Слабое устройство / энергосбережение — статичные.
    final emoji = _emoji = DevicePerformance.instance.animations ? AnimatedEmojiStore.forText(widget.text) : null;
    if (emoji == null) {
      _setCompositions(null);
      return;
    }
    // Уже в памяти — сразу, без кадра со статичным.
    final ready = [for (final e in emoji) AnimatedEmojiStore.ready(e)];
    if (ready.every((c) => c != null)) {
      _setCompositions(ready.cast<LottieComposition>());
      return;
    }
    final loaded = await Future.wait(emoji.map(AnimatedEmojiStore.load));
    if (!mounted || !identical(_emoji, emoji) || loaded.any((c) => c == null)) return;
    setState(() => _setCompositions(loaded.cast<LottieComposition>()));
  }

  void _setCompositions(List<LottieComposition>? compositions) {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    _compositions = compositions;
    if (compositions == null) return;
    for (final composition in compositions) {
      _controllers.add(AnimationController(vsync: this, duration: composition.duration)..forward());
    }
  }

  void _replay() {
    if (_controllers.isEmpty) return;
    HapticFeedback.lightImpact();
    for (final controller in _controllers) {
      controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compositions = _compositions;
    if (compositions == null) return Text(widget.text, style: widget.style);
    // Глиф шрифта крупнее своего кегля — анимацию чуть больше кегля.
    final size = (widget.style.fontSize ?? bigEmojiFontSize(1)) * 1.25;
    return GestureDetector(
      onTap: _replay,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < compositions.length; i++)
            Lottie(composition: compositions[i], controller: _controllers[i], width: size, height: size),
        ],
      ),
    );
  }
}

/// Реакция, которую мы только что поставили, — её эмодзи в плашке проигрывается
/// анимацией один раз (как в Telegram). Метку ставит выбор реакции
/// (`ChatCubit.toggleReaction`), снимает плашка, когда реакция появилась.
class ReactionAnimations {
  ReactionAnimations._();

  static final _marked = <String, DateTime>{};
  static const _ttl = Duration(seconds: 10);

  static String _key(String messageID, String emoji) => '$messageID|$emoji';

  static void mark(String messageID, String emoji) {
    final now = DateTime.now();
    _marked.removeWhere((_, at) => now.difference(at) > _ttl);
    _marked[_key(messageID, emoji)] = now;
  }

  /// Была ли метка (и снять её).
  static bool consume(String messageID, String emoji) {
    final at = _marked.remove(_key(messageID, emoji));
    return at != null && DateTime.now().difference(at) <= _ttl;
  }
}

/// Эмодзи реакции в плашке: обычным текстом, а только что поставленная нами —
/// один раз анимацией того же размера.
class ReactionEmoji extends StatefulWidget {
  final String messageID;
  final String emoji;
  final bool chosen;
  final TextStyle style;

  const ReactionEmoji({super.key, required this.messageID, required this.emoji, required this.chosen, required this.style});

  @override
  State<ReactionEmoji> createState() => _ReactionEmojiState();
}

class _ReactionEmojiState extends State<ReactionEmoji> with SingleTickerProviderStateMixin {
  LottieComposition? _composition;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  void didUpdateWidget(ReactionEmoji oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chosen && (!oldWidget.chosen || oldWidget.emoji != widget.emoji)) _check();
  }

  Future<void> _check() async {
    if (!widget.chosen || !ReactionAnimations.consume(widget.messageID, widget.emoji)) return;
    if (!DevicePerformance.instance.animations) return;
    final data = AnimatedEmojiStore.lookup(widget.emoji);
    if (data == null) return;
    final composition = AnimatedEmojiStore.ready(data) ?? await AnimatedEmojiStore.load(data);
    if (composition == null || !mounted) return;
    _controller?.dispose();
    final controller = _controller = AnimationController(vsync: this, duration: composition.duration);
    setState(() => _composition = composition);
    await controller.forward().orCancel.catchError((_) {});
    if (mounted && identical(_controller, controller)) setState(() => _composition = null);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final composition = _composition;
    final text = Text(widget.emoji, style: widget.style);
    if (composition == null) return text;
    final size = (widget.style.fontSize ?? 15) * 1.3;
    // Место — как у текста (плашка не прыгает), анимация чуть крупнее поверх.
    // Positioned.fill: размер стека — только по тексту. Непозиционированный
    // OverflowBox берёт максимум ограничений, а пузырь меряется IntrinsicWidth
    // (ширина не ограничена) — «Stack requires bounded constraints», и пузырь
    // не рисовался, пока анимация не кончится.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Opacity(opacity: 0, child: text),
        Positioned.fill(
          child: OverflowBox(
            maxWidth: size,
            maxHeight: size,
            child: Lottie(composition: composition, controller: _controller, width: size, height: size),
          ),
        ),
      ],
    );
  }
}
