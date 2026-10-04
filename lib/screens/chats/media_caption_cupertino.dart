import 'package:cupertino_ui/cupertino_ui.dart';

import '../../i18n/translations.g.dart';
import 'chat_common.dart';

/// Превью выбранных вложений с полем подписи (iOS): лента миниатюр, подпись,
/// «Отправить». Возвращает подпись или `null` — отмена.
Future<String?> showMediaCaptionCupertino(BuildContext context, List<AttachmentDraft> items, {String initialCaption = ''}) {
  return showCupertinoModalPopup<String>(
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

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
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
                child: Row(
                  children: [
                    CupertinoButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.t.common.cancel)),
                    Expanded(
                      child: Text(
                        t.selected(n: widget.items.length),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: label),
                      ),
                    ),
                    // Симметрия с «Отмена», чтобы заголовок был по центру.
                    Opacity(
                      opacity: 0,
                      child: IgnorePointer(child: CupertinoButton(onPressed: null, child: Text(context.t.common.cancel))),
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
                  itemBuilder: (context, index) => AttachmentThumb(item: widget.items[index], size: 96),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 8, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _caption,
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
                      onPressed: () => Navigator.of(context).pop(_caption.text),
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
}
