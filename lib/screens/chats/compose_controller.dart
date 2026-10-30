import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../../chats/message_formatting.dart';
import '../../models.dart' as models;

/// Поле ввода сообщения с разметкой, как в Telegram: формат из меню
/// ([ComposeFormatMenu]) виден сразу — жирный жирным, ссылка цветом, — без
/// markdown-ярлыков в тексте. Поле хранит плоский [text] и [entities]; при
/// наборе они сдвигаются ([shiftComposeEntities]), ⌘Z возвращает и разметку.
///
/// Наружу (отправка, черновик, подпись к медиа) — [markdown]: тот же текст с
/// ярлыками, его разбирает `parseMarkdownShortcuts`, как и набранные руками
/// `**…**`.
class ComposeController extends TextEditingController {
  ComposeController({String markdown = ''}) {
    if (markdown.isNotEmpty) this.markdown = markdown;
  }

  List<models.MessageEntity> _entities = const [];

  /// Разметка [text] (только [composeEntityTypes]).
  List<models.MessageEntity> get entities => _entities;

  /// Разметка, с которой было значение поля, — для ⌘Z / ⌘⇧Z: история
  /// правок поля возвращает те же объекты значений, а с ними и разметку.
  final _history = Expando<List<models.MessageEntity>>();

  /// Значение, с которым текст поменялся последним (его и запомнит история
  /// правок; смена выделения создаёт новые объекты).
  TextEditingValue? _textValue;

  /// Текст с markdown-ярлыками — для отправки и черновика.
  String get markdown => toMarkdownShortcuts(text, _entities);

  /// Подставить текст с ярлыками (черновик): ярлыки становятся разметкой.
  set markdown(String value) {
    final (text, entities) = parseMarkdownShortcuts(value);
    setFormatted(text, entities);
  }

  /// Подставить [text] с разметкой [entities] (правка отправленного), каретка
  /// — в конце.
  void setFormatted(String text, List<models.MessageEntity> entities) {
    _entities = normalizeComposeEntities(text, entities);
    super.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _remember();
  }

  /// Применить [format] к выделению (см. [applyComposeFormat]).
  void applyFormat(ComposeFormat format, {String url = '', String userID = ''}) {
    final selection = this.selection;
    if (!selection.isValid || selection.isCollapsed) return;
    final edit = applyComposeFormat(
      (text: text, entities: _entities, start: selection.start, end: selection.end),
      format,
      url: url,
      userID: userID,
    );
    _entities = edit.entities;
    final next = TextSelection(baseOffset: edit.start, extentOffset: edit.end);
    if (next != selection) {
      super.value = value.copyWith(selection: next);
    } else {
      notifyListeners();
    }
    _history[_textValue ?? value] = _entities;
  }

  /// Какие форматы уже стоят на выделении.
  Set<ComposeFormat> get activeFormats {
    final selection = this.selection;
    if (!selection.isValid || selection.isCollapsed) return const {};
    return activeComposeFormats((text: text, entities: _entities, start: selection.start, end: selection.end));
  }

  @override
  set value(TextEditingValue newValue) {
    final old = value;
    if (newValue.text != old.text || newValue.composing != old.composing) {
      final restored = newValue.text != old.text ? _history[newValue] : null;
      if (restored != null) {
        _entities = restored;
      } else if (newValue.text != old.text) {
        final selection = newValue.selection;
        _entities = newValue.text.isEmpty
            ? const []
            : shiftComposeEntities(
                old.text,
                newValue.text,
                _entities,
                caret: selection.isValid && selection.isCollapsed ? selection.baseOffset : -1,
              );
      }
      super.value = newValue;
      _remember();
      return;
    }
    super.value = newValue;
  }

  void _remember() {
    _textValue = value;
    _history[value] = _entities;
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    if (_entities.isEmpty) return super.buildTextSpan(context: context, style: style, withComposing: withComposing);
    final text = this.text;
    final composing = withComposing && value.isComposingRangeValid ? value.composing : TextRange.empty;
    final accent = Platform.isIOS ? c.CupertinoTheme.of(context).primaryColor : m.Theme.of(context).colorScheme.primary;
    final ink = style?.color ?? const Color(0xFF000000);
    final points = <int>{
      0,
      text.length,
      for (final e in _entities) ...[e.offset.clamp(0, text.length), e.end.clamp(0, text.length)],
      if (!composing.isCollapsed) ...[composing.start, composing.end],
    }.toList()..sort();
    final children = <TextSpan>[];
    for (var i = 0; i + 1 < points.length; i++) {
      final (from, to) = (points[i], points[i + 1]);
      if (to <= from) continue;
      final decorations = <TextDecoration>[];
      var span = const TextStyle();
      for (final e in _entities) {
        if (e.offset > from || e.end < to) continue;
        switch (e.type) {
          case models.MessageEntityType.bold:
            span = span.copyWith(fontWeight: FontWeight.w700);
          case models.MessageEntityType.italic:
            span = span.copyWith(fontStyle: FontStyle.italic);
          case models.MessageEntityType.underline:
            decorations.add(TextDecoration.underline);
          case models.MessageEntityType.strike:
            decorations.add(TextDecoration.lineThrough);
          case models.MessageEntityType.spoiler:
            // Заметная плашка: под выделением сразу после «Спойлер» бледную не видно.
            span = span.copyWith(backgroundColor: ink.withValues(alpha: 0.35));
          case models.MessageEntityType.code || models.MessageEntityType.pre:
            span = span.copyWith(fontFamily: Platform.isIOS ? 'Menlo' : 'monospace', color: accent);
          case models.MessageEntityType.textUrl || models.MessageEntityType.mentionName:
            span = span.copyWith(color: accent);
          case models.MessageEntityType.blockquote:
            span = span.copyWith(backgroundColor: span.backgroundColor ?? accent.withValues(alpha: 0.12));
          default:
        }
      }
      if (from >= composing.start && to <= composing.end && !composing.isCollapsed) decorations.add(TextDecoration.underline);
      if (decorations.isNotEmpty) span = span.copyWith(decoration: TextDecoration.combine(decorations));
      children.add(TextSpan(text: text.substring(from, to), style: span));
    }
    return TextSpan(style: style, children: children);
  }
}
