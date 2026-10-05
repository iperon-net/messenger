import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../../chats/message_formatting.dart';
import '../../i18n/translations.g.dart';

/// Меню форматирования по выделению в поле ввода (как в Telegram): к обычным
/// «Вырезать / Скопировать / Вставить» добавляется «Формат», он открывает
/// второе меню — жирный, курсив, зачёркнутый, спойлер, моноширинный, ссылка,
/// цитата, обычный. Поле хранит markdown-ярлыки ([applyComposeFormat]), в
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
    final items = _items(context, editable);
    return Platform.isIOS
        ? c.CupertinoAdaptiveTextSelectionToolbar.buttonItems(anchors: editable.contextMenuAnchors, buttonItems: items)
        : m.AdaptiveTextSelectionToolbar.buttonItems(anchors: editable.contextMenuAnchors, buttonItems: items);
  }

  List<ContextMenuButtonItem> _items(BuildContext context, EditableTextState editable) {
    final t = context.t.screenChat;
    final selection = input.selection;
    if (!selection.isValid || selection.isCollapsed) return editable.contextMenuButtonItems;
    if (!_formats) {
      return [
        ...editable.contextMenuButtonItems,
        ContextMenuButtonItem(
          label: t.format,
          onPressed: () {
            _formats = true;
            _selection = selection;
            // Перестроить меню — уже со списком форматов.
            editable.hideToolbar(false);
            editable.showToolbar();
          },
        ),
      ];
    }
    ContextMenuButtonItem item(String label, ComposeFormat format) =>
        ContextMenuButtonItem(label: label, onPressed: () => _apply(context, editable, format));
    return [
      item(t.formatBold, ComposeFormat.bold),
      item(t.formatItalic, ComposeFormat.italic),
      item(t.formatStrike, ComposeFormat.strike),
      item(t.formatSpoiler, ComposeFormat.spoiler),
      item(t.formatCode, ComposeFormat.code),
      item(t.formatLink, ComposeFormat.link),
      item(t.formatQuote, ComposeFormat.quote),
      item(t.formatPlain, ComposeFormat.plain),
    ];
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
