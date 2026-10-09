import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  /// Предел строк с многоточием (цитата ответа, плашка над полем ввода);
  /// `null` — без предела.
  final int? maxLines;

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
    this.maxLines,
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
    // Блок кода и цитаты — отдельными блоками (плашка с «Копировать», полоса
    // слева, сворачивание); в превью с пределом строк — как раньше, в строку.
    if (widget.maxLines == null) {
      final blocks = _blockEntities(widget.text, widget.entities);
      if (blocks.isNotEmpty) return _MessageBlocks(source: widget, blocks: blocks);
    }
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
    final paragraph = Text.rich(
      TextSpan(children: spans),
      key: _paragraph,
      maxLines: widget.maxLines,
      overflow: widget.maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
    );
    if (!dusty) return paragraph;
    // С пределом строк спойлер может уйти за многоточие — пыль не вылезает.
    final dust = Stack(
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
    return widget.maxLines == null ? dust : ClipRect(child: dust);
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

/// Блочные entities верхнего уровня (блок кода, цитата) — по порядку, без
/// вложенных друг в друга.
List<models.MessageEntity> _blockEntities(String text, List<models.MessageEntity> entities) {
  final blocks = [
    for (final e in entities)
      if ((e.type == models.MessageEntityType.pre || e.type == models.MessageEntityType.blockquote) && e.length > 0 && e.end <= text.length)
        e,
  ]..sort((a, b) => a.offset.compareTo(b.offset));
  final result = <models.MessageEntity>[];
  for (final e in blocks) {
    if (result.isEmpty || e.offset >= result.last.end) result.add(e);
  }
  return result;
}

/// Entities внутри [start, end) — обрезаны и сдвинуты к началу участка; без
/// блочных ([skipBlocks]).
List<models.MessageEntity> _slice(List<models.MessageEntity> entities, int start, int end, {bool skipBlocks = true}) => [
  for (final e in entities)
    if (e.end > start && e.offset < end)
      if (!skipBlocks || (e.type != models.MessageEntityType.pre && e.type != models.MessageEntityType.blockquote))
        e.copyWith(
          offset: (e.offset < start ? start : e.offset) - start,
          length: (e.end > end ? end : e.end) - (e.offset < start ? start : e.offset),
        ),
];

/// Текст с блоками: обычные участки — [MessageText] в строку, блок кода —
/// моноширинная плашка с кнопкой «Копировать», цитата — с полосой слева
/// (сворачиваемая — раскрывается по тапу). Хвост под время — у последнего
/// участка.
class _MessageBlocks extends StatelessWidget {
  final MessageText source;
  final List<models.MessageEntity> blocks;

  const _MessageBlocks({required this.source, required this.blocks});

  MessageText _part(int start, int end, {TextStyle? style, String trailing = ''}) {
    final mark = source.mark;
    return MessageText(
      text: source.text.substring(start, end),
      entities: _slice(source.entities, start, end),
      style: style ?? source.style,
      colors: source.colors,
      trailing: trailing,
      trailingStyle: source.trailingStyle,
      highlight: source.highlight,
      highlightColor: source.highlightColor,
      mark: mark == null || mark.$2 <= start || mark.$1 >= end
          ? null
          : ((mark.$1 < start ? start : mark.$1) - start, (mark.$2 > end ? end : mark.$2) - start),
      markColor: source.markColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = source.text;
    final children = <Widget>[];
    var pos = 0;
    for (final (index, block) in blocks.indexed) {
      // Перевод строки вплотную к блоку — граница блока, не пустая строка.
      var end = block.offset;
      if (end > pos && text[end - 1] == '\n') end--;
      if (end > pos) children.add(_part(pos, end));
      final last = index == blocks.length - 1 && block.end >= text.length;
      if (block.type == models.MessageEntityType.pre) {
        children.add(
          _CodeBlock(
            text: text.substring(block.offset, block.end),
            colors: source.colors,
            child: _part(
              block.offset,
              block.end,
              style: source.style.copyWith(fontFamily: Platform.isIOS ? 'Menlo' : 'monospace', fontSize: (source.style.fontSize ?? 16) - 2),
            ),
          ),
        );
      } else {
        children.add(
          _QuoteBlock(
            expandable: block.expandable,
            colors: source.colors,
            text: text.substring(block.offset, block.end),
            builder: (maxLines) {
              final part = _part(block.offset, block.end);
              return maxLines == null
                  ? part
                  : MessageText(
                      text: part.text,
                      entities: part.entities,
                      style: part.style,
                      colors: part.colors,
                      highlight: part.highlight,
                      highlightColor: part.highlightColor,
                      maxLines: maxLines,
                    );
            },
          ),
        );
      }
      pos = block.end;
      if (pos < text.length && text[pos] == '\n') pos++;
      // Последний — блок: место под время отдельной строкой под ним.
      if (last && source.trailing.isNotEmpty) {
        children.add(
          Text(
            source.trailing,
            textAlign: TextAlign.right,
            style: (source.trailingStyle ?? source.style).copyWith(color: const Color(0x00000000)),
          ),
        );
      }
    }
    if (pos < text.length) children.add(_part(pos, text.length, trailing: source.trailing));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: children);
  }
}

/// Блок кода: моноширинный текст на плашке, справа сверху — «Копировать».
class _CodeBlock extends StatefulWidget {
  final String text;
  final MessageTextColors colors;
  final Widget child;

  const _CodeBlock({required this.text, required this.colors, required this.child});

  @override
  State<_CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<_CodeBlock> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    await HapticFeedback.selectionClick();
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.fromLTRB(10, 8, 36, 8),
      decoration: BoxDecoration(color: widget.colors.codeBackground, borderRadius: BorderRadius.circular(8)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          Positioned(
            top: -4,
            right: -30,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _copy,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FaIcon(_copied ? FontAwesomeIcons.check : FontAwesomeIcons.copy, size: 15, color: widget.colors.link),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Цитата: полоса слева на подложке; сворачиваемая ([expandable]) длинная —
/// до трёх строк, по тапу раскрывается (и обратно), справа внизу — стрелка.
class _QuoteBlock extends StatefulWidget {
  final bool expandable;
  final MessageTextColors colors;
  final String text;
  final Widget Function(int? maxLines) builder;

  const _QuoteBlock({required this.expandable, required this.colors, required this.text, required this.builder});

  static const collapsedLines = 3;

  @override
  State<_QuoteBlock> createState() => _QuoteBlockState();
}

class _QuoteBlockState extends State<_QuoteBlock> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.colors.link;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      // Полоса — Positioned во всю высоту (IntrinsicHeight не дружит с
      // LayoutBuilder сворачиваемой цитаты).
      child: Stack(
        children: [
          Padding(padding: const EdgeInsets.fromLTRB(11, 4, 8, 4), child: widget.expandable ? _expandable(accent) : widget.builder(null)),
          Positioned(left: 0, top: 0, bottom: 0, width: 3, child: ColoredBox(color: accent)),
        ],
      ),
    );
  }

  /// Длинная ли цитата (сворачивать ли): больше [_QuoteBlock.collapsedLines]
  /// строк или длинный текст. Без LayoutBuilder — пузырь меряется
  /// IntrinsicWidth, а LayoutBuilder интринсики не поддерживает.
  bool get _long =>
      '\n'.allMatches(widget.text).length >= _QuoteBlock.collapsedLines || widget.text.length > 40 * _QuoteBlock.collapsedLines;

  Widget _expandable(Color accent) {
    if (!_long) return widget.builder(null);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _expanded = !_expanded),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.topCenter,
              child: widget.builder(_expanded ? null : _QuoteBlock.collapsedLines),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: FaIcon(_expanded ? FontAwesomeIcons.chevronUp : FontAwesomeIcons.chevronDown, size: 12, color: accent),
          ),
        ],
      ),
    );
  }
}
