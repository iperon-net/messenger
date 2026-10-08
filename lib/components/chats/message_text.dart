import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../chats/message_formatting.dart';
import '../../models.dart' as models;
import 'spoiler_dust.dart';

/// Цвета разметки текста сообщения — свои у входящего и исходящего пузыря.
class MessageTextColors {
  final Color text;
  final Color link;
  final Color codeBackground;
  final Color spoiler;
  final Color quote;

  const MessageTextColors({
    required this.text,
    required this.link,
    required this.codeBackground,
    required this.spoiler,
    required this.quote,
  });
}

/// Текст сообщения: плоский текст + entities → `TextSpan` (жирный, курсив,
/// код, спойлер, ссылки, цитата), плюс авто-ссылки/упоминания/хэштеги.
/// Спойлер скрыт мерцающей «пылью» до тапа (как в Telegram), по тапу
/// раскрывается волной от пальца. [trailing] — невидимый хвост под время и
/// галочки, которые пузырь рисует поверх последней строки (как в Telegram).
class MessageText extends StatefulWidget {
  /// Ссылки внутри приложения (`iperon.net/…` — канал, группа, приглашение):
  /// вернуть `true`, если ссылку открыли сами; иначе — во внешнем браузере.
  /// Задаётся экраном чата (`openIperonLink`).
  static Future<bool> Function(BuildContext context, Uri uri)? linkHandler;

  /// Тап по упоминанию по имени (без @username) — открыть чат с [userID].
  static void Function(BuildContext context, String userID)? mentionNameHandler;

  final String text;
  final List<models.MessageEntity> entities;
  final TextStyle style;
  final MessageTextColors colors;
  final String trailing;
  final TextStyle? trailingStyle;

  /// Поиск по чату: вхождения подсвечиваются (без учёта регистра) фоном
  /// [highlightColor].
  final String highlight;
  final Color highlightColor;

  /// Подсвеченный фрагмент [start, end) — переход по цитате ответа.
  final (int, int)? mark;
  final Color markColor;

  const MessageText({
    super.key,
    required this.text,
    required this.entities,
    required this.style,
    required this.colors,
    this.trailing = '',
    this.trailingStyle,
    this.highlight = '',
    this.highlightColor = const Color(0x66FFCC00),
    this.mark,
    this.markColor = const Color(0x66FFCC00),
  });

  @override
  State<MessageText> createState() => _MessageTextState();
}

class _MessageTextState extends State<MessageText> with TickerProviderStateMixin {
  bool _spoilerRevealed = false;
  final _recognizers = <GestureRecognizer>[];

  /// Пыль спойлера: время (секунды) двигает частицы, [_reveal] — волна
  /// раскрытия от точки тапа [_revealOrigin].
  final _paragraph = GlobalKey();
  final _time = ValueNotifier<double>(0);
  late final Ticker _ticker = createTicker((elapsed) => _time.value = elapsed.inMicroseconds / 1e6);
  late final _reveal = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
    ..addListener(() => setState(() {}))
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) _ticker.stop();
    });
  Offset? _revealOrigin;
  final _dust = SpoilerDust();

  static final _monospace = Platform.isIOS ? 'Menlo' : 'monospace';

  @override
  void dispose() {
    _disposeRecognizers();
    _ticker.dispose();
    _reveal.dispose();
    _time.dispose();
    super.dispose();
  }

  void _revealSpoilers(TapUpDetails details) {
    if (_spoilerRevealed) return;
    final paragraph = _paragraph.currentContext?.findRenderObject();
    _revealOrigin = paragraph is RenderBox ? paragraph.globalToLocal(details.globalPosition) : null;
    setState(() => _spoilerRevealed = true);
    _reveal.forward();
  }

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  TapGestureRecognizer _tap(VoidCallback onTap) {
    final recognizer = TapGestureRecognizer()..onTap = onTap;
    _recognizers.add(recognizer);
    return recognizer;
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final handler = MessageText.linkHandler;
    if (handler != null && await handler(context, uri)) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String? _linkOf(models.MessageEntity e) {
    final raw = widget.text.substring(e.offset, e.end);
    return switch (e.type) {
      models.MessageEntityType.textUrl => e.url,
      models.MessageEntityType.url => raw.startsWith('http') ? raw : 'https://$raw',
      models.MessageEntityType.email => 'mailto:$raw',
      models.MessageEntityType.phone => 'tel:$raw',
      // @username — как ссылка iperon.net/username (откроется в приложении).
      models.MessageEntityType.mention => 'https://iperon.net/${raw.replaceFirst('@', '')}',
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    _disposeRecognizers();
    final text = widget.text;
    final colors = widget.colors;
    final all = [
      ...widget.entities,
      ...detectAutoEntities(text, widget.entities),
    ].where((e) => e.length > 0 && e.end <= text.length).toList();

    final bounds = <int>{0, text.length};
    for (final e in all) {
      bounds
        ..add(e.offset)
        ..add(e.end);
    }
    final found = <(int, int)>[];
    final needle = widget.highlight.trim().toLowerCase();
    if (needle.isNotEmpty) {
      final haystack = text.toLowerCase();
      for (var at = haystack.indexOf(needle); at >= 0; at = haystack.indexOf(needle, at + needle.length)) {
        found.add((at, at + needle.length));
        bounds
          ..add(at)
          ..add(at + needle.length);
      }
    }
    final mark = widget.mark;
    final marked = mark != null && mark.$1 < mark.$2 && mark.$2 <= text.length;
    if (marked) {
      bounds
        ..add(mark.$1)
        ..add(mark.$2);
    }
    final points = bounds.toList()..sort();
    final spoilers = [
      for (final e in all)
        if (e.type == models.MessageEntityType.spoiler) TextSelection(baseOffset: e.offset, extentOffset: e.end),
    ];
    // Пока спойлер скрыт (или раскрывается) — частицы шевелятся.
    final dusty = spoilers.isNotEmpty && !_reveal.isCompleted;
    if (dusty && !_ticker.isActive) _ticker.start();
    // Скрытый текст прозрачный (место под ним остаётся), при раскрытии проявляется.
    final hiddenAlpha = _spoilerRevealed ? _reveal.value : 0.0;

    final spans = <InlineSpan>[];
    for (var i = 0; i + 1 < points.length; i++) {
      final a = points[i];
      final b = points[i + 1];
      final active = all.where((e) => e.offset <= a && e.end >= b);
      var style = widget.style.copyWith(color: colors.text);
      final decorations = <TextDecoration>[];
      GestureRecognizer? recognizer;
      var hidden = false;
      bool spoilerHere(Iterable<models.MessageEntity> entities) => entities.any((e) => e.type == models.MessageEntityType.spoiler);
      for (final e in active) {
        switch (e.type) {
          case models.MessageEntityType.bold:
            style = style.copyWith(fontWeight: FontWeight.w600);
          case models.MessageEntityType.italic:
            style = style.copyWith(fontStyle: FontStyle.italic);
          case models.MessageEntityType.underline:
            decorations.add(TextDecoration.underline);
          case models.MessageEntityType.strike:
            decorations.add(TextDecoration.lineThrough);
          case models.MessageEntityType.code || models.MessageEntityType.pre:
            style = style.copyWith(fontFamily: _monospace, fontSize: (style.fontSize ?? 16) - 1, backgroundColor: colors.codeBackground);
          case models.MessageEntityType.blockquote:
            style = style.copyWith(color: colors.quote, fontStyle: FontStyle.italic);
          case models.MessageEntityType.spoiler:
            hidden = !_spoilerRevealed;
          case models.MessageEntityType.textUrl ||
              models.MessageEntityType.url ||
              models.MessageEntityType.email ||
              models.MessageEntityType.phone ||
              models.MessageEntityType.mention ||
              models.MessageEntityType.hashtag:
            style = style.copyWith(color: colors.link);
            final link = _linkOf(e);
            if (link != null) recognizer = _tap(() => _open(link));
          case models.MessageEntityType.mentionName:
            style = style.copyWith(color: colors.link);
            final handler = MessageText.mentionNameHandler;
            if (handler != null) recognizer = _tap(() => handler(context, e.userID));
        }
      }
      if (decorations.isNotEmpty) style = style.copyWith(decoration: TextDecoration.combine(decorations), decorationColor: style.color);
      if (found.any((r) => r.$1 <= a && r.$2 >= b)) style = style.copyWith(backgroundColor: widget.highlightColor);
      if (marked && mark.$1 <= a && mark.$2 >= b) style = style.copyWith(backgroundColor: widget.markColor);
      if (hidden || (spoilerHere(active) && hiddenAlpha < 1)) {
        final color = style.color ?? colors.text;
        style = style.copyWith(
          color: color.withValues(alpha: color.a * hiddenAlpha),
          decorationColor: (style.decorationColor ?? color).withValues(alpha: hiddenAlpha),
        );
        if (hidden) recognizer = _tapUp(_revealSpoilers);
      }
      spans.add(TextSpan(text: text.substring(a, b), style: style, recognizer: recognizer));
    }
    if (widget.trailing.isNotEmpty) {
      spans.add(
        TextSpan(
          text: widget.trailing,
          style: (widget.trailingStyle ?? widget.style).copyWith(color: const Color(0x00000000)),
        ),
      );
    }
    final paragraph = Text.rich(TextSpan(children: spans), key: _paragraph);
    if (!dusty) return paragraph;
    return Stack(
      children: [
        paragraph,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: SpoilerDustPainter(
                rectsOf: (_) => _spoilerRects(spoilers),
                dust: _dust,
                time: _time,
                color: colors.text,
                reveal: _reveal.value,
                origin: _revealOrigin,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Прямоугольники скрытого текста (по строкам) в координатах абзаца.
  List<Rect> _spoilerRects(List<TextSelection> ranges) {
    final render = _paragraph.currentContext?.findRenderObject();
    if (render is! RenderParagraph || !render.hasSize) return const [];
    return [
      for (final range in ranges)
        for (final box in render.getBoxesForSelection(range))
          if (box.right > box.left) box.toRect(),
    ];
  }

  TapGestureRecognizer _tapUp(GestureTapUpCallback onTapUp) {
    final recognizer = TapGestureRecognizer()..onTapUp = onTapUp;
    _recognizers.add(recognizer);
    return recognizer;
  }
}
