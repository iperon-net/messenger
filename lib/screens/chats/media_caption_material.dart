import 'package:material_ui/material_ui.dart';

import '../../i18n/translations.g.dart';
import 'chat_common.dart';

/// Превью выбранных вложений с полем подписи (Android): лента миниатюр,
/// подпись, «Отправить». Возвращает подпись или `null` — отмена.
Future<String?> showMediaCaptionMaterial(BuildContext context, List<AttachmentDraft> items, {String initialCaption = ''}) {
  return showModalBottomSheet<String>(
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(t.selected(n: widget.items.length), style: Theme.of(context).textTheme.titleMedium),
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
              padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _caption,
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
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: scheme.primary,
                    onPressed: () => Navigator.of(context).pop(_caption.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
