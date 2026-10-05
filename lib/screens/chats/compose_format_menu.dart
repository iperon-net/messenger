import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../../chats/message_formatting.dart';
import '../../i18n/translations.g.dart';

/// Меню форматирования по выделению в поле ввода (как в Telegram): к обычным
/// «Вырезать / Скопировать / Вставить» добавляется «Форматирование», оно открывает
/// второе меню — вертикальный список со значками: жирный, курсив, зачёркнутый,
/// спойлер, моноширинный, ссылка, цитата, обычный ([_FormatList]). Поле хранит markdown-ярлыки ([applyComposeFormat]), в
/// entities они превращаются при отправке.
///
/// Подключение: `contextMenuBuilder: menu.builder` у `CupertinoTextField` /
/// `TextField` с тем же [input].
class ComposeFormatMenu {
  final TextEditingController input;

  ComposeFormatMenu(this.input) {
    input.addListener(_onChange);
  }

  /// Открыто второе меню (форматы) для выделения [_selection].
  bool _formats = false;
  TextSelection? _selection;

  void dispose() => input.removeListener(_onChange);

  // Выделение сменилось — снова обычное меню.
  void _onChange() {
    if (_formats && input.selection != _selection) _formats = false;
  }

  Widget builder(BuildContext context, EditableTextState editable) {
    final selection = input.selection;
    if (_formats && selection.isValid && !selection.isCollapsed) {
      return _FormatList(anchors: editable.contextMenuAnchors, onSelected: (format) => _apply(context, editable, format));
    }
    final items = _items(context, editable);
    return Platform.isIOS
        ? c.CupertinoAdaptiveTextSelectionToolbar.buttonItems(anchors: editable.contextMenuAnchors, buttonItems: items)
        : m.AdaptiveTextSelectionToolbar.buttonItems(anchors: editable.contextMenuAnchors, buttonItems: items);
  }

  List<ContextMenuButtonItem> _items(BuildContext context, EditableTextState editable) {
    final selection = input.selection;
    final items = [...editable.contextMenuButtonItems];
    if (!selection.isValid || selection.isCollapsed) return items;
    final format = ContextMenuButtonItem(
      label: context.t.screenChat.format,
      onPressed: () {
        _formats = true;
        _selection = selection;
        // Перестроить меню — уже списком форматов.
        editable.hideToolbar(false);
        editable.showToolbar();
      },
    );
    // Сразу за «Вставить» (или «Скопировать», если вставлять нечего).
    final paste = items.indexWhere((i) => i.type == ContextMenuButtonType.paste);
    final at = paste >= 0 ? paste : items.indexWhere((i) => i.type == ContextMenuButtonType.copy);
    items.insert(at >= 0 ? at + 1 : items.length, format);
    return items;
  }

  Future<void> _apply(BuildContext context, EditableTextState editable, ComposeFormat format) async {
    _formats = false;
    final selection = input.selection;
    editable.hideToolbar();
    var url = '';
    if (format == ComposeFormat.link) {
      url = await _askUrl(context) ?? '';
      if (url.isEmpty) return;
    }
    final edit = applyComposeFormat((text: input.text, start: selection.start, end: selection.end), format, url: url);
    input.value = TextEditingValue(
      text: edit.text,
      selection: TextSelection(baseOffset: edit.start, extentOffset: edit.end),
    );
  }

  /// Адрес ссылки; поле заполнено ссылкой из буфера обмена, если она там есть.
  Future<String?> _askUrl(BuildContext context) async {
    final clipboard = (await Clipboard.getData(Clipboard.kTextPlain))?.text?.trim() ?? '';
    if (!context.mounted) return null;
    final field = TextEditingController(text: normalizeLinkUrl(clipboard) == null ? '' : clipboard);
    final t = context.t;
    try {
      final String? raw;
      if (Platform.isIOS) {
        raw = await c.showCupertinoDialog<String>(
          context: context,
          builder: (dialogContext) => c.CupertinoAlertDialog(
            title: Text(t.screenChat.linkTitle),
            content: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: c.CupertinoTextField(
                controller: field,
                autofocus: true,
                placeholder: 'https://',
                keyboardType: TextInputType.url,
                autocorrect: false,
                onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
              ),
            ),
            actions: [
              c.CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(t.common.cancel)),
              c.CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(dialogContext).pop(field.text),
                child: Text(t.screenChat.linkAdd),
              ),
            ],
          ),
        );
      } else {
        raw = await m.showDialog<String>(
          context: context,
          builder: (dialogContext) => m.AlertDialog(
            title: Text(t.screenChat.linkTitle),
            content: m.TextField(
              controller: field,
              autofocus: true,
              keyboardType: TextInputType.url,
              autocorrect: false,
              decoration: const m.InputDecoration(hintText: 'https://'),
              onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
            ),
            actions: [
              m.TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(t.common.cancel)),
              m.TextButton(onPressed: () => Navigator.of(dialogContext).pop(field.text), child: Text(t.screenChat.linkAdd)),
            ],
          ),
        );
      }
      return raw == null ? null : normalizeLinkUrl(raw);
    } finally {
      field.dispose();
    }
  }
}

/// Адрес для ссылки `[текст](url)`: без схемы — `https://`; `null`, если это
/// не похоже на адрес (пробелы, скобки ломают ярлык).
String? normalizeLinkUrl(String raw) {
  final value = raw.trim();
  if (value.isEmpty || value.contains(RegExp(r'[\s()]'))) return null;
  final url = RegExp(r'^https?://', caseSensitive: false).hasMatch(value) ? value : 'https://$value';
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.host.contains('.')) return null;
  return url;
}

/// Второе меню — вертикальный список форматов со значками (как контекстные
/// меню iOS / Material) над выделением, а если сверху не помещается — под ним.
class _FormatList extends StatelessWidget {
  final TextSelectionToolbarAnchors anchors;
  final ValueChanged<ComposeFormat> onSelected;

  const _FormatList({required this.anchors, required this.onSelected});

  static const _rowHeight = 44.0;
  static const _width = 220.0;
  static const _gap = 8.0;

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final mono = Platform.isIOS ? 'Menlo' : 'monospace';
    final rows = <(ComposeFormat, String, FaIconData, TextStyle)>[
      (ComposeFormat.bold, t.formatBold, FontAwesomeIcons.bold, const TextStyle(fontWeight: FontWeight.w700)),
      (ComposeFormat.italic, t.formatItalic, FontAwesomeIcons.italic, const TextStyle(fontStyle: FontStyle.italic)),
      (ComposeFormat.strike, t.formatStrike, FontAwesomeIcons.strikethrough, const TextStyle(decoration: TextDecoration.lineThrough)),
      (ComposeFormat.spoiler, t.formatSpoiler, FontAwesomeIcons.eyeSlash, const TextStyle()),
      (ComposeFormat.code, t.formatCode, FontAwesomeIcons.code, TextStyle(fontFamily: mono)),
      (ComposeFormat.link, t.formatLink, FontAwesomeIcons.link, const TextStyle()),
      (ComposeFormat.quote, t.formatQuote, FontAwesomeIcons.quoteLeft, const TextStyle()),
      (ComposeFormat.plain, t.formatPlain, FontAwesomeIcons.textSlash, const TextStyle()),
    ];
    final height = rows.length * _rowHeight;
    final padding = MediaQuery.paddingOf(context);
    final above = anchors.primaryAnchor.dy - _gap - height >= padding.top;
    final anchor = above ? anchors.primaryAnchor : (anchors.secondaryAnchor ?? anchors.primaryAnchor);
    return CustomSingleChildLayout(
      delegate: _FormatListLayout(anchor: anchor, above: above, padding: padding),
      child: SizedBox(width: _width, child: Platform.isIOS ? _cupertino(context, rows) : _material(context, rows)),
    );
  }

  Widget _cupertino(BuildContext context, List<(ComposeFormat, String, FaIconData, TextStyle)> rows) {
    final label = c.CupertinoColors.label.resolveFrom(context);
    final separator = c.CupertinoColors.separator.resolveFrom(context);
    final dark = c.CupertinoTheme.brightnessOf(context) == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 6))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: ColoredBox(
            color: dark ? const Color(0xE6252525) : const Color(0xE6F9F9F9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (index, (format, text, icon, style)) in rows.indexed)
                  _row(
                    format,
                    divider: index > 0 ? separator : null,
                    // Значок справа, как в контекстных меню iOS.
                    children: [
                      Expanded(
                        child: Text(text, style: style.copyWith(fontSize: 17, color: label)),
                      ),
                      FaIcon(icon, size: 16, color: label),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _material(BuildContext context, List<(ComposeFormat, String, FaIconData, TextStyle)> rows) {
    final scheme = m.Theme.of(context).colorScheme;
    return m.Material(
      color: scheme.surfaceContainer,
      elevation: 3,
      shadowColor: const Color(0x66000000),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (format, text, icon, style) in rows)
              m.InkWell(
                onTap: () => onSelected(format),
                child: SizedBox(
                  height: _rowHeight - 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        SizedBox(width: 24, child: FaIcon(icon, size: 16, color: scheme.onSurfaceVariant)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(text, style: style.copyWith(fontSize: 15, color: scheme.onSurface)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(ComposeFormat format, {Color? divider, required List<Widget> children}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onSelected(format),
      child: Container(
        height: _rowHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: divider == null
            ? null
            : BoxDecoration(
                border: Border(top: BorderSide(color: divider, width: 0.5)),
              ),
        child: Row(children: children),
      ),
    );
  }
}

/// Список по центру выделения по горизонтали (в пределах экрана), над
/// [anchor] или под ним.
class _FormatListLayout extends SingleChildLayoutDelegate {
  final Offset anchor;
  final bool above;
  final EdgeInsets padding;

  const _FormatListLayout({required this.anchor, required this.above, required this.padding});

  static const _margin = 8.0;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) => constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size child) {
    final x = (anchor.dx - child.width / 2).clamp(_margin, math.max(_margin, size.width - child.width - _margin)).toDouble();
    final y = above ? anchor.dy - _FormatList._gap - child.height : anchor.dy + _FormatList._gap;
    return Offset(x, y.clamp(padding.top, math.max(padding.top, size.height - child.height)).toDouble());
  }

  @override
  bool shouldRelayout(_FormatListLayout old) => anchor != old.anchor || above != old.above || padding != old.padding;
}
