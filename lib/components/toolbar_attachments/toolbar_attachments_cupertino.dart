import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'toolbar_attachments.dart';

/// Cupertino-лист выбора источника медиа. Раскрывается свайпом вверх
/// ([DraggableScrollableSheet]); сверху — «хват», кнопка закрытия и
/// центрированный заголовок таба; внизу — переключатель табов (скрыт, если
/// таб один). Тело каждого таба — точка расширения под конкретный процесс.
class ToolbarAttachmentsCupertino extends StatefulWidget {
  final List<ToolbarAttachmentTabKind> tabs;
  final ToolbarAttachmentTabKind initial;
  final double minChildSize;
  final double maxChildSize;
  final ValueChanged<ToolbarAttachmentResult>? onResult;

  const ToolbarAttachmentsCupertino({
    required this.tabs,
    required this.initial,
    required this.minChildSize,
    required this.maxChildSize,
    this.onResult,
    super.key,
  });

  @override
  State<ToolbarAttachmentsCupertino> createState() => _ToolbarAttachmentsCupertinoState();
}

class _ToolbarAttachmentsCupertinoState extends State<ToolbarAttachmentsCupertino> {
  late ToolbarAttachmentTabKind _selected = widget.initial;

  /// Управляет высотой листа: нужен, чтобы «хват» (он вне скролла) мог тянуть
  /// лист собственным жестом и закрывать его свайпом вниз.
  final _sheetController = DraggableScrollableController();

  /// Нижний «пол» — ниже [minChildSize], чтобы лист можно было стянуть вниз
  /// для закрытия. В покое лист туда не встаёт (см. `snap`/`snapSizes`).
  double get _floor => widget.minChildSize * 0.7;

  /// Порог закрытия: если отпустить ниже него — лист скрывается.
  double get _dismissBelow => (_floor + widget.minChildSize) / 2;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  // ─── Драг «хвата» ─────────────────────────────────────────────────────────

  /// Тянем лист вслед за пальцем в пределах [_floor..max] — «пол» ниже
  /// [minChildSize] даёт визуальную обратную связь при стягивании вниз.
  void _onHandleDrag(DragUpdateDetails d) {
    if (!_sheetController.isAttached) return;
    final screenH = MediaQuery.sizeOf(context).height;
    final next = _sheetController.size - (d.primaryDelta ?? 0) / screenH;
    _sheetController.jumpTo(next.clamp(_floor, widget.maxChildSize));
  }

  /// По отпусканию: если стянули/бросили вниз ниже порога — закрыть лист; иначе
  /// «прилипнуть» к ближайшему из двух состояний (60% / 90%).
  void _onHandleDragEnd(DragEndDetails d) {
    if (!_sheetController.isAttached) return;
    final v = d.primaryVelocity ?? 0; // > 0 — палец идёт вниз
    final size = _sheetController.size;
    final mid = (widget.minChildSize + widget.maxChildSize) / 2;

    // Закрываем: резкий флинг вниз или медленно стянули ниже порога.
    if ((v > 300 && size < mid) || size <= _dismissBelow) {
      Navigator.pop(context);
      return;
    }

    final target = v < -300
        ? widget.maxChildSize
        : v > 300
        ? widget.minChildSize
        : (size < mid ? widget.minChildSize : widget.maxChildSize);
    _sheetController.animateTo(target, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  /// Единая точка возврата результата: дёргает callback и закрывает лист.
  ///
  /// Вызывайте из тела таба, когда процесс завершён:
  /// ```dart
  /// _finish(ToolbarAttachmentImageResult(xfile, ToolbarAttachmentTabKind.gallery));
  /// _finish(const ToolbarAttachmentEmojiResult('😀'));
  /// _finish(const ToolbarAttachmentLinkResult('https://example.com/pic.png'));
  /// ```
  ///
  /// Если нужно эмитить события, не закрывая лист (например, мультивыбор), —
  /// зовите `widget.onResult?.call(result)` напрямую, а `Navigator.pop` — только
  /// по кнопке «Готово».
  void _finish(ToolbarAttachmentResult result) {
    widget.onResult?.call(result);
    Navigator.pop(context, result);
  }

  // ─── Метаданные табов (иконка/заголовок) ──────────────────────────────────

  FaIconData _icon(ToolbarAttachmentTabKind kind) => switch (kind) {
    ToolbarAttachmentTabKind.camera => FontAwesomeIcons.camera,
    ToolbarAttachmentTabKind.gallery => FontAwesomeIcons.images,
    ToolbarAttachmentTabKind.file => FontAwesomeIcons.folder,
    ToolbarAttachmentTabKind.emoji => FontAwesomeIcons.faceSmile,
    ToolbarAttachmentTabKind.link => FontAwesomeIcons.link,
  };

  String _label(BuildContext context, ToolbarAttachmentTabKind kind) => switch (kind) {
    ToolbarAttachmentTabKind.camera => context.t.screenMyProfile.takePhoto,
    ToolbarAttachmentTabKind.gallery => context.t.screenMyProfile.chooseFromGallery,
    ToolbarAttachmentTabKind.file => context.t.screenMyProfile.chooseFile,
    ToolbarAttachmentTabKind.emoji => context.t.screenMyProfile.chooseEmoji,
    ToolbarAttachmentTabKind.link => context.t.screenMyProfile.chooseLink,
  };

  // ─── Хедер таба (по центру, под линией свайпа) ────────────────────────────

  /// Кастомный хедер выбранного таба. Для галереи — пример-селектор альбома.
  Widget _tabHeader(BuildContext context) {
    final style = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: CupertinoColors.label.resolveFrom(context));
    if (_selected == ToolbarAttachmentTabKind.gallery) {
      return GestureDetector(
        onTap: () async {
          // TODO: открыть выбор альбома, дождаться выбранного и обновить хедер:
          //   final album = await pickAlbum(context);
          //   if (album != null && mounted) setState(() => _album = album);
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
  /// case ToolbarAttachmentTabKind.file:
  ///   return ListView.builder(
  ///     shrinkWrap: true,
  ///     physics: const NeverScrollableScrollPhysics(), // внешний скролл — у листа
  ///     itemCount: _files.length,
  ///     itemBuilder: (context, i) => CupertinoListTile(
  ///       title: Text(_files[i].name),
  ///       onTap: () async {
  ///         final xfile = await _files[i].toXFile();
  ///         _finish(ToolbarAttachmentImageResult(xfile, ToolbarAttachmentTabKind.file));
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
      case ToolbarAttachmentTabKind.emoji:
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
                  onTap: () => _finish(ToolbarAttachmentEmojiResult(e)),
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

      case ToolbarAttachmentTabKind.camera:
      case ToolbarAttachmentTabKind.gallery:
        // Заглушка-пример: открыть нативный пикер. Замени на свой процесс
        // (например, встроенную сетку картинок) и вызови _finish(ToolbarAttachmentImageResult(...)).
        return Text("dddd");
      // photo_manager

      // return _placeholder(
      //   context,
      //   onTap: () async {
      //     final image = await ImagePicker().pickImage(
      //       source: _selected == ToolbarAttachmentTabKind.camera ? ImageSource.camera : ImageSource.gallery,
      //       imageQuality: 85,
      //       maxWidth: 1024,
      //     );
      //     if (image != null && mounted) _finish(ToolbarAttachmentImageResult(image, _selected));
      //   },
      // );

      case ToolbarAttachmentTabKind.file:
      case ToolbarAttachmentTabKind.link:
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

  Widget _segmentTab(BuildContext context, ToolbarAttachmentTabKind kind) {
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
      controller: _sheetController,
      initialChildSize: widget.minChildSize,
      // «Пол» ниже min нужен только для стягивания к закрытию; snap держит лист
      // в покое строго на 60%/90%, поэтому на «полу» он не застревает.
      minChildSize: _floor,
      maxChildSize: widget.maxChildSize,
      snap: true,
      snapSizes: [widget.minChildSize, widget.maxChildSize],
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: ThemesCupertino.groupedBackground.resolveFrom(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Вся верхняя зона (хват + шапка) тянет лист вертикальным жестом
                // и закрывает свайпом вниз. Она вне скролла, поэтому сам
                // DraggableScrollableSheet её драг не ловит — вешаем свой.
                // Тапы по кнопке закрытия/селектору альбома продолжают работать:
                // вертикальный драг и тап — разные распознаватели.
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: _onHandleDrag,
                  onVerticalDragEnd: _onHandleDragEnd,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                    ],
                  ),
                ),
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
