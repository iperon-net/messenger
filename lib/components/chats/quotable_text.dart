import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../chats/message_quote.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Тулбар над выделением — платформенный (`CupertinoAdaptiveTextSelectionToolbar`
/// / `AdaptiveTextSelectionToolbar`).
typedef QuoteToolbarBuilder = Widget Function(BuildContext context, TextSelectionToolbarAnchors anchors, List<ContextMenuButtonItem> items);

/// Текст сообщения в меню (iOS — приподнятый пузырь, Android — шторка),
/// который можно выделить: над выделением — «Копировать | Цитировать», как в
/// Telegram. [child] — `MessageText` этого [text]; offset'ы выделения
/// считаются от его начала (невидимый хвост под время отрезается).
class QuotableText extends StatefulWidget {
  final String text;
  final List<models.MessageEntity> entities;
  final Widget child;
  final TextSelectionControls selectionControls;
  final QuoteToolbarBuilder toolbarBuilder;
  final ValueChanged<models.MessageQuote> onQuote;

  const QuotableText({
    super.key,
    required this.text,
    required this.entities,
    required this.child,
    required this.selectionControls,
    required this.toolbarBuilder,
    required this.onQuote,
  });

  @override
  State<QuotableText> createState() => QuotableTextState();
}

class QuotableTextState extends State<QuotableText> {
  final _region = GlobalKey<SelectableRegionState>();
  final _selection = SelectionListenerNotifier();

  /// Выделить весь текст и показать «Копировать | Цитировать» (Android:
  /// пункт «Цитировать» в шторке).
  void selectAll() => _region.currentState?.selectAll(SelectionChangedCause.toolbar);

  @override
  void dispose() {
    _selection.dispose();
    super.dispose();
  }

  void _quote(SelectableRegionState region) {
    final range = _selection.registered ? _selection.selection.range : null;
    region.hideToolbar();
    if (range == null) return;
    final start = math.min(range.startOffset, range.endOffset);
    final end = math.max(range.startOffset, range.endOffset);
    final quote = quoteOf(widget.text, widget.entities, start, end);
    if (quote != null) widget.onQuote(quote);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SelectableRegion(
      key: _region,
      selectionControls: widget.selectionControls,
      contextMenuBuilder: (context, region) {
        final items = <ContextMenuButtonItem>[
          for (final item in region.contextMenuButtonItems)
            if (item.type == ContextMenuButtonType.copy) item,
          ContextMenuButtonItem(label: t.screenChat.quote, onPressed: () => _quote(region)),
        ];
        return widget.toolbarBuilder(context, region.contextMenuAnchors, items);
      },
      child: SelectionListener(selectionNotifier: _selection, child: widget.child),
    );
  }
}
