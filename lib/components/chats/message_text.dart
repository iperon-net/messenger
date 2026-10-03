import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../chats/message_formatting.dart';
import '../../models.dart' as models;

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
/// Спойлер скрыт плашкой до тапа. [trailing] — невидимый хвост под время и
/// галочки, которые пузырь рисует поверх последней строки (как в Telegram).
class MessageText extends StatefulWidget {
  final String text;
  final List<models.MessageEntity> entities;
  final TextStyle style;
  final MessageTextColors colors;
  final String trailing;
  final TextStyle? trailingStyle;

  const MessageText({
    super.key,
    required this.text,
    required this.entities,
    required this.style,
    required this.colors,
    this.trailing = '',
    this.trailingStyle,
  });

  @override
  State<MessageText> createState() => _MessageTextState();
}

class _MessageTextState extends State<MessageText> {
  bool _spoilerRevealed = false;
  final _recognizers = <GestureRecognizer>[];

  static final _monospace = Platform.isIOS ? 'Menlo' : 'monospace';

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
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
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String? _linkOf(models.MessageEntity e) {
    final raw = widget.text.substring(e.offset, e.end);
    return switch (e.type) {
      models.MessageEntityType.textUrl => e.url,
      models.MessageEntityType.url => raw.startsWith('http') ? raw : 'https://$raw',
      models.MessageEntityType.email => 'mailto:$raw',
      models.MessageEntityType.phone => 'tel:$raw',
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
    final points = bounds.toList()..sort();

    final spans = <InlineSpan>[];
    for (var i = 0; i + 1 < points.length; i++) {
      final a = points[i];
      final b = points[i + 1];
      final active = all.where((e) => e.offset <= a && e.end >= b);
      var style = widget.style.copyWith(color: colors.text);
      final decorations = <TextDecoration>[];
      GestureRecognizer? recognizer;
      var hidden = false;
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
        }
      }
      if (decorations.isNotEmpty) style = style.copyWith(decoration: TextDecoration.combine(decorations), decorationColor: style.color);
      if (hidden) {
        style = style.copyWith(color: const Color(0x00000000), backgroundColor: colors.spoiler, decoration: TextDecoration.none);
        recognizer = _tap(() => setState(() => _spoilerRevealed = true));
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
    return Text.rich(TextSpan(children: spans));
  }
}
