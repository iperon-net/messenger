import 'package:cupertino_ui/cupertino_ui.dart';

import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';
import 'compose_format_menu.dart';

/// Превью выбранных вложений с полем подписи (iOS): лента миниатюр, подпись,
/// «Отправить», «HD» (есть видео — 1080p вместо 720p), в «⋯» — «Скрыть под
/// спойлер». `null` — отмена.
Future<MediaCaptionResult?> showMediaCaptionCupertino(BuildContext context, List<AttachmentDraft> items, {String initialCaption = ''}) {
  return showCupertinoModalPopup<MediaCaptionResult>(
    context: context,
    builder: (_) => _MediaCaptionSheet(items: items, initialCaption: initialCaption),
  );
}

class _MediaCaptionSheet extends StatefulWidget {
  final List<AttachmentDraft> items;
  final String initialCaption;

  const _MediaCaptionSheet({required this.items, required this.initialCaption});

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

  /// Миниатюра; видео — по нажатию в редактор (обрезка, звук, обложка).
  Widget _thumb(AttachmentDraft item, Color accent) {
    final thumb = AttachmentThumb(item: item, size: 96, spoiler: _spoiler);
    if (!item.isVideo) return thumb;
    return GestureDetector(
      // Сама миниатюра под IgnorePointer — без opaque нажатие до детектора не доходит.
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        FocusScope.of(context).unfocus();
        final onAccent = ThemesCupertino.onAccent(context);
        if (await editVideoDraft(context, item, accent: accent, onAccent: onAccent) && mounted) setState(() {});
      },
      child: thumb,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final primary = CupertinoDynamicColor.resolve(CupertinoTheme.of(context).primaryColor, context);
    final label = CupertinoColors.label.resolveFrom(context);
    return Padding(
      // Лист поднимается над клавиатурой.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                // Заголовок по центру независимо от ширины кнопок по краям.
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      t.selected(n: widget.items.length),
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: label),
                    ),
                    Row(
                      children: [
                        CupertinoButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(context.t.common.cancel, style: TextStyle(color: ThemesCupertino.actionColor(context))),
                        ),
                        const Spacer(),
                        if (_hasVideo) _hdButton(context, primary),
                        if (_hasMedia)
                          // Выпадающее меню iOS (pull-down), как у «⋯» в системных приложениях.
                          CupertinoMenuAnchor(
                            useRootOverlay: true,
                            menuChildren: [
                              CupertinoMenuItem(
                                trailing: Icon(_spoiler ? CupertinoIcons.eye : CupertinoIcons.eye_slash),
                                onPressed: () => setState(() => _spoiler = !_spoiler),
                                child: Text(_spoiler ? t.removeSpoiler : t.hideWithSpoiler),
                              ),
                            ],
                            builder: (context, controller, _) => CupertinoButton(
                              onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                              child: Icon(CupertinoIcons.ellipsis_circle, size: 26, color: ThemesCupertino.actionColor(context)),
                            ),
                          ),
                      ],
                    ),
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
                  itemBuilder: (context, index) => _thumb(widget.items[index], primary),
                ),
              ),
              if (_hasVideo)
                Text(
                  _hd ? t.videoHdOn : t.videoHdOff,
                  style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 8, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _caption,
                        contextMenuBuilder: _formatMenu.builder,
                        autofocus: true,
                        placeholder: t.addCaption,
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        style: TextStyle(fontSize: 16, color: label),
                        decoration: BoxDecoration(
                          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.only(left: 8, bottom: 2),
                      minimumSize: Size.zero,
                      onPressed: _send,
                      child: Icon(CupertinoIcons.arrow_up_circle_fill, size: 32, color: primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Значок «HD» как в WhatsApp: контур — 720p, залитый — 1080p.
  Widget _hdButton(BuildContext context, Color primary) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      onPressed: () => setState(() => _hd = !_hd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: _hd ? primary : null,
          border: Border.all(color: primary, width: 1.6),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'HD',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _hd ? ThemesCupertino.onAccent(context) : primary),
        ),
      ),
    );
  }
}
