import 'package:material_ui/material_ui.dart';

import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../platform.dart';
import 'chat_common.dart';
import 'compose_desktop_keys.dart';
import 'compose_format_menu.dart';

/// Превью выбранных вложений с полем подписи (Android): лента миниатюр,
/// подпись, «Отправить», «HD» (есть видео — 1080p вместо 720p) и
/// переключатель «Скрыть под спойлер». `null` — отмена. На десктопе — окно по
/// центру, как в Telegram Desktop: сетка миниатюр, подпись (Enter отправляет),
/// «Отмена» / «Отправить».
Future<MediaCaptionResult?> showMediaCaptionMaterial(BuildContext context, List<AttachmentDraft> items, {String initialCaption = ''}) {
  if (AppPlatform.isDesktop) {
    return showDialog<MediaCaptionResult>(
      context: context,
      builder: (_) => _MediaCaptionSheet(items: items, initialCaption: initialCaption, dialog: true),
    );
  }
  return showModalBottomSheet<MediaCaptionResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => _MediaCaptionSheet(items: items, initialCaption: initialCaption),
  );
}

class _MediaCaptionSheet extends StatefulWidget {
  final List<AttachmentDraft> items;
  final String initialCaption;
  final bool dialog;

  const _MediaCaptionSheet({required this.items, required this.initialCaption, this.dialog = false});

  @override
  State<_MediaCaptionSheet> createState() => _MediaCaptionSheetState();
}

class _MediaCaptionSheetState extends State<_MediaCaptionSheet> {
  late final _caption = TextEditingController(text: widget.initialCaption);
  late final _formatMenu = ComposeFormatMenu(_caption);
  bool _spoiler = false;
  bool _hd = false;

  bool get _hasMedia => widget.items.any((i) => i.isMedia);
  bool get _hasVideo => widget.items.any((i) => i.kind == models.MessageKind.video);

  void _send() => Navigator.of(context).pop((caption: _caption.text, spoiler: _spoiler && _hasMedia, hd: _hd && _hasVideo));

  @override
  void dispose() {
    _formatMenu.dispose();
    _caption.dispose();
    super.dispose();
  }

  /// Миниатюра; видео и фото — по нажатию в редактор (видео: обрезка, звук,
  /// обложка; фото: карандаш, кадрирование).
  Widget _thumb(AttachmentDraft item, Color accent, {double size = 96}) {
    final thumb = AttachmentThumb(item: item, size: size, spoiler: _spoiler);
    if (!item.isVideo && !item.isEditablePhoto) return thumb;
    return GestureDetector(
      // Сама миниатюра под IgnorePointer — без opaque нажатие до детектора не доходит.
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        FocusScope.of(context).unfocus();
        final onAccent = Theme.of(context).colorScheme.onPrimary;
        final changed = item.isVideo
            ? await editVideoDraft(context, item, accent: accent, onAccent: onAccent)
            : await editPhotoDraft(context, item, accent: accent, onAccent: onAccent);
        if (changed && mounted) setState(() {});
      },
      child: thumb,
    );
  }

  /// «HD» и «Скрыть под спойлер» в шапке.
  List<Widget> _toggles(Translations t, ColorScheme scheme) => [
    if (_hasVideo)
      IconButton(
        isSelected: _hd,
        icon: const Icon(Icons.hd_outlined),
        selectedIcon: const Icon(Icons.hd),
        color: _hd ? scheme.primary : null,
        tooltip: _hd ? t.screenChat.videoHdOn : t.screenChat.videoHdOff,
        onPressed: () => setState(() => _hd = !_hd),
      ),
    // Переключатель, а не пункт меню «⋮»: тот в Material 3 —
    // крупная строка с чекбоксом ради одного действия.
    if (_hasMedia)
      IconButton(
        isSelected: _spoiler,
        icon: const Icon(Icons.visibility_off_outlined),
        selectedIcon: const Icon(Icons.visibility_off),
        color: _spoiler ? scheme.primary : null,
        tooltip: t.screenChat.hideWithSpoiler,
        onPressed: () => setState(() => _spoiler = !_spoiler),
      ),
  ];

  /// Десктоп: окно по центру. Одно вложение — на всю ширину, до четырёх — в
  /// два столбца, больше — в три.
  Widget _dialog(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    final n = widget.items.length;
    final columns = n == 1 ? 1 : (n <= 4 ? 2 : 3);
    const gap = 8.0;
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(t.screenChat.selected(n: n), style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ..._toggles(t, scheme),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = (constraints.maxWidth - gap * (columns - 1)) / columns;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [for (final item in widget.items) _thumb(item, scheme.primary, size: size)],
                    );
                  },
                ),
              ),
            ),
            if (_hasVideo)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(_hd ? t.screenChat.videoHdOn : t.screenChat.videoHdOff, style: Theme.of(context).textTheme.bodySmall),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              // Enter — отправить, Shift+Enter — перенос строки, Esc закрывает окно.
              child: ComposeDesktopKeys(
                input: _caption,
                onSend: _send,
                onEditLast: () => false,
                onEscape: () => false,
                onPaste: () async => false,
                child: TextField(
                  controller: _caption,
                  contextMenuBuilder: _formatMenu.builder,
                  autofocus: true,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(hintText: t.screenChat.addCaption),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(t.common.cancel)),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: _send, child: Text(t.screenChat.send)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dialog) return _dialog(context);
    final t = context.t.screenChat;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      // Лист поднимается над клавиатурой.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(t.selected(n: widget.items.length), style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ..._toggles(context.t, scheme),
                ],
              ),
            ),
            SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: widget.items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) => _thumb(widget.items[index], scheme.primary),
              ),
            ),
            if (_hasVideo)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(_hd ? t.videoHdOn : t.videoHdOff, style: Theme.of(context).textTheme.bodySmall),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _caption,
                      contextMenuBuilder: _formatMenu.builder,
                      autofocus: true,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: t.addCaption,
                        filled: true,
                        fillColor: scheme.surfaceContainerHighest,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.send), color: scheme.primary, onPressed: _send),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
