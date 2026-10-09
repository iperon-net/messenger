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
import '../../models.dart' as models;

/// Меню форматирования по выделению в поле ввода (как в Telegram): к обычным
/// «Вырезать / Скопировать / Вставить» добавляется «Форматирование», оно открывает
/// второе меню — вертикальный список со значками ([_FormatList]): жирный,
/// курсив, подчёркнутый, зачёркнутый, спойлер, моноширинный, блок кода,
/// ссылка, упомянуть (в группе), цитата, сворачиваемая цитата, обычный; у
/// уже стоящих — галочка, повторный выбор снимает только этот формат. Поле
/// хранит markdown-ярлыки ([applyComposeFormat]), в entities они
/// превращаются при отправке.
///
/// Подключение: `contextMenuBuilder: menu.builder` у `CupertinoTextField` /
/// `TextField` с тем же [input]; горячие клавиши (⌘/Ctrl + B, I, U, K) —
/// [shortcuts] вокруг поля.
class ComposeFormatMenu {
  final TextEditingController input;

  /// Участники чата для «Упомянуть» (пусто — пункта нет: личный чат, канал).
  final List<models.ChatMember> Function()? members;

  ComposeFormatMenu(this.input, {this.members}) {
    input.addListener(_onChange);
  }

  List<models.ChatMember> get _members => [
    for (final m in members?.call() ?? const <models.ChatMember>[])
      if (!m.isSelf) m,
  ];

  /// Горячие клавиши форматирования выделенного текста (iPad / внешняя
  /// клавиатура): ⌘ (на Android — Ctrl) + B — жирный, I — курсив, U —
  /// подчёркнутый, K — ссылка.
  Widget shortcuts(BuildContext context, {required Widget child}) {
    const keys = [
      (LogicalKeyboardKey.keyB, ComposeFormat.bold),
      (LogicalKeyboardKey.keyI, ComposeFormat.italic),
      (LogicalKeyboardKey.keyU, ComposeFormat.underline),
      (LogicalKeyboardKey.keyK, ComposeFormat.link),
    ];
    return CallbackShortcuts(
      bindings: {
        for (final (key, format) in keys) ...{
          SingleActivator(key, meta: true): () => _apply(context, null, format),
          SingleActivator(key, control: true): () => _apply(context, null, format),
        },
      },
      child: child,
    );
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
      return _FormatList(
        anchors: editable.contextMenuAnchors,
        active: activeComposeFormats((text: input.text, start: selection.start, end: selection.end)),
        mention: _members.isNotEmpty,
        onSelected: (format) => _apply(context, editable, format),
      );
    }
    final items = _items(context, editable);
    return Platform.isIOS
        ? c.CupertinoAdaptiveTextSelectionToolbar.buttonItems(anchors: editable.contextMenuAnchors, buttonItems: items)
        : m.AdaptiveTextSelectionToolbar.buttonItems(anchors: editable.contextMenuAnchors, buttonItems: items);
  }

  List<ContextMenuButtonItem> _items(BuildContext context, EditableTextState editable) {
    final selection = input.selection;
    // Только Cut / Copy / Paste — подписи всегда по-английски (короткие,
    // меню влезает без стрелки), за ними «Форматирование» на языке
    // приложения. Системные «Найти», «Поделиться», «Выбрать всё» и т. п. не
    // показываем.
    const labels = {ContextMenuButtonType.cut: 'Cut', ContextMenuButtonType.copy: 'Copy', ContextMenuButtonType.paste: 'Paste'};
    final items = [
      for (final item in editable.contextMenuButtonItems)
        if (labels[item.type] case final label?) item.copyWith(label: label),
    ];
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
    return [...items, format];
  }

  /// Применить [format] к выделению (из меню — [editable], с клавиатуры —
  /// `null`). Ссылка / упоминание, которых ещё нет, спрашивают адрес /
  /// человека; уже стоящие — снимаются.
  Future<void> _apply(BuildContext context, EditableTextState? editable, ComposeFormat format) async {
    _formats = false;
    final selection = input.selection;
    if (!selection.isValid || selection.isCollapsed) return;
    editable?.hideToolbar();
    final value = (text: input.text, start: selection.start, end: selection.end);
    final adding = !activeComposeFormats(value).contains(format);
    var url = '';
    var userID = '';
    if (format == ComposeFormat.link && adding) {
      url = await _askUrl(context) ?? '';
      if (url.isEmpty) return;
    }
    if (format == ComposeFormat.mention && adding) {
      final members = _members;
      if (members.isEmpty || !context.mounted) return;
      userID = (await _pickMember(context, members))?.id ?? '';
      if (userID.isEmpty) return;
    }
    // Пока спрашивали, текст могли поменять — применяем к прежнему выделению.
    if (input.text != value.text) return;
    final edit = applyComposeFormat(value, format, url: url, userID: userID);
    input.value = TextEditingValue(
      text: edit.text,
      selection: TextSelection(baseOffset: edit.start, extentOffset: edit.end),
    );
  }

  /// «Упомянуть»: выбор участника чата (iOS — лист снизу, Android — шторка).
  Future<models.ChatMember?> _pickMember(BuildContext context, List<models.ChatMember> members) {
    final t = context.t.screenChat;
    final height = MediaQuery.sizeOf(context).height * 0.6;
    if (Platform.isIOS) {
      return c.showCupertinoModalPopup<models.ChatMember>(
        context: context,
        builder: (sheetContext) {
          final label = c.CupertinoColors.label.resolveFrom(sheetContext);
          final secondary = c.CupertinoColors.secondaryLabel.resolveFrom(sheetContext);
          return Container(
            height: height,
            decoration: BoxDecoration(
              color: c.CupertinoColors.systemBackground.resolveFrom(sheetContext),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      t.mentionPickTitle,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: label),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final member in members)
                          c.CupertinoListTile(
                            title: Text(member.name),
                            subtitle: member.username.isEmpty ? null : Text('@${member.username}', style: TextStyle(color: secondary)),
                            onTap: () => Navigator.of(sheetContext).pop(member),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return m.showModalBottomSheet<models.ChatMember>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(t.mentionPickTitle, style: m.Theme.of(sheetContext).textTheme.titleMedium),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (final member in members)
                    m.ListTile(
                      title: Text(member.name),
                      subtitle: member.username.isEmpty ? null : Text('@${member.username}'),
                      onTap: () => Navigator.of(sheetContext).pop(member),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  /// Уже стоящие на выделении — с галочкой.
  final Set<ComposeFormat> active;

  /// Есть «Упомянуть» (в чате есть участники).
  final bool mention;

  const _FormatList({required this.anchors, required this.onSelected, required this.active, required this.mention});

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
      (ComposeFormat.underline, t.formatUnderline, FontAwesomeIcons.underline, const TextStyle(decoration: TextDecoration.underline)),
      (ComposeFormat.strike, t.formatStrike, FontAwesomeIcons.strikethrough, const TextStyle(decoration: TextDecoration.lineThrough)),
      (ComposeFormat.spoiler, t.formatSpoiler, FontAwesomeIcons.eyeSlash, const TextStyle()),
      (ComposeFormat.code, t.formatCode, FontAwesomeIcons.code, TextStyle(fontFamily: mono)),
      (ComposeFormat.pre, t.formatPre, FontAwesomeIcons.fileCode, TextStyle(fontFamily: mono)),
      (ComposeFormat.link, t.formatLink, FontAwesomeIcons.link, const TextStyle()),
      if (mention) (ComposeFormat.mention, t.formatMention, FontAwesomeIcons.at, const TextStyle()),
      (ComposeFormat.quote, t.formatQuote, FontAwesomeIcons.quoteLeft, const TextStyle()),
      (ComposeFormat.quoteExpandable, t.formatQuoteExpandable, FontAwesomeIcons.angleDown, const TextStyle()),
      (ComposeFormat.plain, t.formatPlain, FontAwesomeIcons.textSlash, const TextStyle()),
    ];
    final height = rows.length * _rowHeight;
    final padding = MediaQuery.paddingOf(context);
    final screen = MediaQuery.sizeOf(context).height;
    // Над выделением, если помещается; иначе — где места больше, с прокруткой
    // (пунктов много, а над полем ввода у открытой клавиатуры места мало).
    final spaceAbove = anchors.primaryAnchor.dy - _gap - padding.top;
    final below = anchors.secondaryAnchor ?? anchors.primaryAnchor;
    final spaceBelow = screen - MediaQuery.viewInsetsOf(context).bottom - padding.bottom - below.dy - _gap;
    final above = spaceAbove >= height || spaceAbove >= spaceBelow;
    final anchor = above ? anchors.primaryAnchor : below;
    final maxHeight = math.max(_rowHeight * 3, above ? spaceAbove : spaceBelow);
    return CustomSingleChildLayout(
      delegate: _FormatListLayout(anchor: anchor, above: above, padding: padding),
      child: SizedBox(
        width: _width,
        height: math.min(height, maxHeight),
        child: Platform.isIOS ? _cupertino(context, rows) : _material(context, rows),
      ),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (index, (format, text, icon, style)) in rows.indexed)
                    _row(
                      format,
                      divider: index > 0 ? separator : null,
                      // Галочка слева у стоящих, значок справа — как в контекстных меню iOS.
                      children: [
                        SizedBox(width: 22, child: active.contains(format) ? FaIcon(FontAwesomeIcons.check, size: 13, color: label) : null),
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
        child: SingleChildScrollView(
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
                          // Галочка у уже стоящих.
                          if (active.contains(format)) m.Icon(m.Icons.check, size: 18, color: scheme.primary),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
