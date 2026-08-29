import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../i18n/translations.g.dart';
import 'media_source_sheet.dart';

/// Cupertino-лист выбора источника медиа. Раскрывается свайпом вверх
/// ([DraggableScrollableSheet]); сверху — «хват», кнопка закрытия и
/// центрированный заголовок таба; внизу — переключатель табов (скрыт, если
/// таб один). Тело каждого таба — точка расширения под конкретный процесс.
class MediaSourceSheetCupertino extends StatefulWidget {
  final List<MediaSourceTabKind> tabs;
  final MediaSourceTabKind initial;
  final double minChildSize;
  final double maxChildSize;
  final ValueChanged<MediaSourceResult>? onResult;

  const MediaSourceSheetCupertino({
    required this.tabs,
    required this.initial,
    required this.minChildSize,
    required this.maxChildSize,
    this.onResult,
    super.key,
  });

  @override
  State<MediaSourceSheetCupertino> createState() => _MediaSourceSheetCupertinoState();
}

class _MediaSourceSheetCupertinoState extends State<MediaSourceSheetCupertino> {
  late MediaSourceTabKind _selected = widget.initial;

  /// Единая точка возврата результата: дёргает callback и закрывает лист.
  ///
  /// Вызывайте из тела таба, когда процесс завершён:
  /// ```dart
  /// _finish(MediaImageResult(xfile, MediaSourceTabKind.gallery));
  /// _finish(const MediaEmojiResult('😀'));
  /// _finish(const MediaLinkResult('https://example.com/pic.png'));
  /// ```
  ///
  /// Если нужно эмитить события, не закрывая лист (например, мультивыбор), —
  /// зовите `widget.onResult?.call(result)` напрямую, а `Navigator.pop` — только
  /// по кнопке «Готово».
  void _finish(MediaSourceResult result) {
    widget.onResult?.call(result);
    Navigator.pop(context, result);
  }

  // ─── Метаданные табов (иконка/заголовок) ──────────────────────────────────

  FaIconData _icon(MediaSourceTabKind kind) => switch (kind) {
    MediaSourceTabKind.camera => FontAwesomeIcons.camera,
    MediaSourceTabKind.gallery => FontAwesomeIcons.images,
    MediaSourceTabKind.file => FontAwesomeIcons.folder,
    MediaSourceTabKind.emoji => FontAwesomeIcons.faceSmile,
    MediaSourceTabKind.link => FontAwesomeIcons.link,
  };

  String _label(BuildContext context, MediaSourceTabKind kind) => switch (kind) {
    MediaSourceTabKind.camera => context.t.screenMyProfile.takePhoto,
    MediaSourceTabKind.gallery => context.t.screenMyProfile.chooseFromGallery,
    MediaSourceTabKind.file => context.t.screenMyProfile.chooseFile,
    MediaSourceTabKind.emoji => context.t.screenMyProfile.chooseEmoji,
    MediaSourceTabKind.link => context.t.screenMyProfile.chooseLink,
  };

  // ─── Хедер таба (по центру, под линией свайпа) ────────────────────────────

  /// Кастомный хедер выбранного таба. Для галереи — пример-селектор альбома.
  Widget _tabHeader(BuildContext context) {
    final style = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: CupertinoColors.label.resolveFrom(context));
    if (_selected == MediaSourceTabKind.gallery) {
      return GestureDetector(
        onTap: () {
          // TODO: открыть выбор альбома.
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_label(context, _selected), style: style),
            const SizedBox(width: 4),
            FaIcon(FontAwesomeIcons.chevronDown, size: 12, color: CupertinoColors.label.resolveFrom(context)),
          ],
        ),
      );
    }
    return Text(_label(context, _selected), style: style);
  }

  // ─── Тело таба (точка расширения под процесс) ─────────────────────────────

  /// Тело выбранного таба. Здесь реализуется конкретный процесс (список файлов,
  /// сетка картинок/эмодзи, поле ссылки и т.д.) и по готовности вызывается
  /// [_finish] с результатом.
  ///
  /// Пример — таб «файл» со своим списком и возвратом результата:
  /// ```dart
  /// case MediaSourceTabKind.file:
  ///   return ListView.builder(
  ///     shrinkWrap: true,
  ///     physics: const NeverScrollableScrollPhysics(), // внешний скролл — у листа
  ///     itemCount: _files.length,
  ///     itemBuilder: (context, i) => CupertinoListTile(
  ///       title: Text(_files[i].name),
  ///       onTap: () async {
  ///         final xfile = await _files[i].toXFile();
  ///         _finish(MediaImageResult(xfile, MediaSourceTabKind.file));
  ///       },
  ///     ),
  ///   );
  /// ```
  ///
  /// Пример — асинхронная загрузка с индикатором (файлы храните в state класса):
  /// ```dart
  /// if (_loading) return const Center(child: CupertinoActivityIndicator());
  /// // грузите в initState/при смене таба, затем setState(() => _loading = false);
  /// ```
  Widget _tabBody(BuildContext context) {
    switch (_selected) {
      case MediaSourceTabKind.emoji:
        // Демонстрационная сетка: тап по эмодзи возвращает результат.
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final e in _demoEmoji)
                GestureDetector(
                  onTap: () => _finish(MediaEmojiResult(e)),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(e, style: const TextStyle(fontSize: 24)),
                  ),
                ),
            ],
          ),
        );

      case MediaSourceTabKind.camera:
      case MediaSourceTabKind.gallery:
        // Заглушка-пример: открыть нативный пикер. Замени на свой процесс
        // (например, встроенную сетку картинок) и вызови _finish(MediaImageResult(...)).
        return _placeholder(
          context,
          onTap: () async {
            final image = await ImagePicker().pickImage(
              source: _selected == MediaSourceTabKind.camera ? ImageSource.camera : ImageSource.gallery,
              imageQuality: 85,
              maxWidth: 1024,
            );
            if (image != null && mounted) _finish(MediaImageResult(image, _selected));
          },
        );

      case MediaSourceTabKind.file:
      case MediaSourceTabKind.link:
        // TODO: реализуй процесс таба и вызови _finish(...) с результатом.
        return _placeholder(context, onTap: () {});
    }
  }

  Widget _placeholder(BuildContext context, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: FaIcon(_icon(_selected), size: 48, color: CupertinoTheme.of(context).primaryColor),
        ),
      ),
    );
  }

  // ─── Низ: переключатель табов ─────────────────────────────────────────────

  Widget _segmentTab(BuildContext context, MediaSourceTabKind kind) {
    final isSelected = kind == _selected;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: () => setState(() => _selected = kind),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? CupertinoTheme.of(context).primaryColor : CupertinoColors.tertiarySystemFill.resolveFrom(context),
            shape: BoxShape.circle,
          ),
          child: FaIcon(_icon(kind), size: 17, color: isSelected ? CupertinoColors.white : CupertinoColors.label.resolveFrom(context)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Меню-переключатель нужен только когда табов больше одного.
    final showTabBar = widget.tabs.length > 1;
    return DraggableScrollableSheet(
      initialChildSize: widget.minChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // «Хват» — на самом верху листа.
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Фиксированная шапка: кнопка закрытия слева + заголовок по центру.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    height: 36,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(child: _tabHeader(context)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                                shape: BoxShape.circle,
                              ),
                              child: FaIcon(FontAwesomeIcons.xmark, size: 15, color: CupertinoColors.label.resolveFrom(context)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Тело таба. scrollController + AlwaysScrollable позволяют
                // раскрывать лист свайпом вверх.
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _tabBody(context),
                  ),
                ),
                // Переключатель табов внизу (горизонтальный скролл).
                if (showTabBar)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(children: [for (final kind in widget.tabs) _segmentTab(context, kind)]),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

const _demoEmoji = [
  '😀',
  '😁',
  '😂',
  '🤣',
  '😃',
  '😄',
  '😅',
  '😆',
  '😉',
  '😊',
  '😍',
  '😘',
  '😜',
  '🤪',
  '🤩',
  '🥳',
  '😎',
  '🤓',
  '🧐',
  '🤔',
  '🙃',
  '😇',
  '🥰',
  '😋',
  '😛',
  '🤗',
  '🤠',
  '😴',
  '🤤',
  '😷',
  '🤒',
  '🤕',
  '🤢',
  '🤮',
  '🥵',
  '🥶',
  '😱',
  '😭',
  '😡',
  '🤬',
];
