import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../camera/camera.dart';
import 'toolbar_attachments.dart';

/// Cupertino-лист выбора источника медиа. Раскрывается свайпом вверх
/// ([DraggableScrollableSheet]); сверху — «хват», кнопка закрытия и
/// центрированный заголовок таба; внизу — переключатель табов (скрыт, если
/// таб один). Тело каждого таба — точка расширения под конкретный процесс.
class ToolbarAttachmentsCupertino extends StatefulWidget {
  final List<ToolbarAttachmentTabKind> tabs;
  final ToolbarAttachmentTabKind initial;
  final ToolbarAttachmentMediaType media;
  final bool multiSelect;
  final double minChildSize;
  final double maxChildSize;
  final ValueChanged<ToolbarAttachmentResult>? onResult;

  /// Шаг обработки одиночного фото прямо внутри листа (напр. кроп аватара).
  /// `null` из коллбэка — обработка отменена, лист остаётся открытым.
  final Future<XFile?> Function(XFile file)? processImage;

  const ToolbarAttachmentsCupertino({
    required this.tabs,
    required this.initial,
    required this.media,
    required this.multiSelect,
    required this.minChildSize,
    required this.maxChildSize,
    this.onResult,
    this.processImage,
    super.key,
  });

  @override
  State<ToolbarAttachmentsCupertino> createState() => _ToolbarAttachmentsCupertinoState();
}

class _ToolbarAttachmentsCupertinoState extends State<ToolbarAttachmentsCupertino> with WidgetsBindingObserver {
  late ToolbarAttachmentTabKind _selected = widget.initial;

  /// Управляет высотой листа: нужен, чтобы «хват» (он вне скролла) мог тянуть
  /// лист собственным жестом и закрывать его свайпом вниз.
  final _sheetController = DraggableScrollableController();

  // ─── Состояние галереи (photo_manager) ────────────────────────────────────

  /// Размер страницы пагинации при подгрузке ассетов по скроллу.
  static const _pageSize = 90;

  /// Все доступные альбомы (для селектора в хедере). Первый — «все фото».
  List<AssetPathEntity> _albums = [];

  /// Текущий выбранный альбом, из которого берём ассеты постранично.
  AssetPathEntity? _album;

  /// Уже загруженные ассеты (накапливаются по мере пагинации).
  final List<AssetEntity> _assets = [];

  /// Результат запроса доступа к фото; `null` — доступ ещё не запрашивали.
  PermissionState? _permission;

  /// Отмеченные в мультивыборе ассеты — по порядку отметки (для нумерации
  /// бейджей и порядка в результате). Пусто в одиночном режиме.
  final List<AssetEntity> _picked = [];

  /// id ассета, который сейчас экспортируется в файл перед возвратом результата
  /// (одиночный выбор). Пока не `null` — на плитке крутится индикатор, а
  /// повторные тапы игнорируются. Экспорт оригинала (`asset.file`) для HEIC /
  /// iCloud-фото занимает заметное время, поэтому нужен видимый фидбэк.
  String? _exportingId;

  int _page = 0;
  bool _hasMore = true;
  bool _galleryLoading = false;
  bool _galleryLoaded = false;

  /// Скролл-контроллер листа, к которому привязан слушатель пагинации.
  /// [DraggableScrollableSheet] отдаёт стабильный инстанс, привязываемся раз.
  ScrollController? _boundScroll;

  // ─── Живое превью камеры (первая плитка сетки) ────────────────────────────

  /// Контроллер живого превью камеры; `null` — доступ не выдан / камера
  /// недоступна, тогда плитка камеры не показывается.
  CameraController? _cameraController;

  /// Все доступные камеры устройства (для кнопки смены камеры).
  List<CameraDescription> _cameras = [];

  /// Индекс активной камеры в [_cameras].
  int _cameraIndex = 0;

  /// Инициализацию камеры пробуем один раз (запрос доступа + запуск).
  bool _cameraInitTried = false;

  /// Плитка камеры доступна: доступ выдан и камера хотя бы раз запустилась.
  /// Остаётся `true` во время переключения камеры (когда контроллер временно
  /// пересоздаётся), чтобы слот в сетке не исчезал и не плыли индексы.
  bool _cameraAvailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_selected == ToolbarAttachmentTabKind.gallery) _ensureGalleryLoaded();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Живое превью камеры чувствительно к прерыванию AVCaptureSession: при уходе
    // приложения в фон (в т.ч. когда поверх открывается нативная камера) сессия
    // прерывается и превью «замерзает». Поэтому освобождаем контроллер на
    // сворачивании и пересоздаём его при возврате.
    if (!_cameraAvailable) return;
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        final previous = _cameraController;
        if (previous != null) {
          setState(() => _cameraController = null);
          previous.dispose();
        }
      case AppLifecycleState.resumed:
        if (_cameraController == null) _startCamera(_cameraIndex);
      case AppLifecycleState.detached:
        break;
    }
  }

  /// Тип медиа для photo_manager, выведенный из фильтра [widget.media].
  RequestType get _requestType => switch (widget.media) {
    ToolbarAttachmentMediaType.image => RequestType.image,
    ToolbarAttachmentMediaType.video => RequestType.video,
    ToolbarAttachmentMediaType.all => RequestType.common,
  };

  /// Нижний «пол» — ниже [minChildSize], чтобы лист можно было стянуть вниз
  /// для закрытия. В покое лист туда не встаёт (см. `snap`/`snapSizes`).
  double get _floor => widget.minChildSize * 0.7;

  /// Порог закрытия: если отпустить ниже него — лист скрывается.
  double get _dismissBelow => (_floor + widget.minChildSize) / 2;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _boundScroll?.removeListener(_onSheetScroll);
    _cameraController?.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  // ─── Галерея: доступ, загрузка, пагинация ─────────────────────────────────

  /// Первичная загрузка: запрашивает доступ, берёт альбом «все фото» и первую
  /// страницу ассетов. Идемпотентна — повторные вызовы игнорируются.
  Future<void> _ensureGalleryLoaded() async {
    if (_galleryLoaded || _galleryLoading) return;
    setState(() => _galleryLoading = true);

    final ps = await PhotoManager.requestPermissionExtend();
    _permission = ps;
    // Камеру (живое превью первой плиткой) инициализируем ТОЛЬКО после того, как
    // диалог доступа к галерее закрыт: на Android два системных диалога прав
    // одновременно не показываются — второй запрос молча отклоняется. Поэтому
    // запросы разрешений нужно строго сериализовать, иначе доступ к галерее
    // приходится подтверждать лишь при повторном открытии листа.
    unawaited(_ensureCamera());
    if (!ps.hasAccess) {
      if (mounted) {
        setState(() {
          _galleryLoading = false;
          _galleryLoaded = true;
        });
      }
      return;
    }

    final all = await PhotoManager.getAssetPathList(
      type: _requestType,
      filterOption: FilterOptionGroup(orders: [const OrderOption(type: OrderOptionType.createDate, asc: false)]),
    );
    // Скрываем пустые альбомы: считаем количество (уже с учётом фильтра типа)
    // и оставляем только непустые.
    final counts = await Future.wait(all.map((a) => a.assetCountAsync));
    final albums = [
      for (var i = 0; i < all.length; i++)
        if (counts[i] > 0) all[i],
    ];
    _albums = albums;
    _album = albums.isEmpty ? null : albums.first; // первый — системный «все фото»
    final page = _album == null ? const <AssetEntity>[] : await _album!.getAssetListPaged(page: 0, size: _pageSize);

    if (!mounted) return;
    setState(() {
      _page = 0;
      _assets
        ..clear()
        ..addAll(page);
      _hasMore = page.length == _pageSize;
      _galleryLoading = false;
      _galleryLoaded = true;
    });
  }

  /// Переключение на другой альбом из селектора: сбрасывает пагинацию и
  /// перечитывает первую страницу выбранного альбома.
  Future<void> _selectAlbum(AssetPathEntity album) async {
    if (album.id == _album?.id) return;
    setState(() {
      _album = album;
      _assets.clear();
      _page = 0;
      _hasMore = true;
      _galleryLoading = true;
    });
    final page = await album.getAssetListPaged(page: 0, size: _pageSize);
    if (!mounted) return;
    setState(() {
      _assets
        ..clear()
        ..addAll(page);
      _hasMore = page.length == _pageSize;
      _galleryLoading = false;
    });
  }

  /// Открывает лист выбора альбома и применяет выбор.
  Future<void> _openAlbumPicker() async {
    if (_albums.isEmpty) return;
    final selected = await showCupertinoModalPopup<AssetPathEntity>(
      context: context,
      builder: (_) => _AlbumPickerSheet(albums: _albums, current: _album),
    );
    if (selected != null && mounted) await _selectAlbum(selected);
  }

  /// Подгружает следующую страницу ассетов (по скроллу к низу листа).
  Future<void> _loadMore() async {
    if (_galleryLoading || !_hasMore || _album == null) return;
    _galleryLoading = true;
    final next = _page + 1;
    final page = await _album!.getAssetListPaged(page: next, size: _pageSize);
    if (!mounted) return;
    setState(() {
      _page = next;
      _assets.addAll(page);
      _hasMore = page.length == _pageSize;
      _galleryLoading = false;
    });
  }

  void _bindScroll(ScrollController controller) {
    if (identical(_boundScroll, controller)) return;
    _boundScroll?.removeListener(_onSheetScroll);
    _boundScroll = controller..addListener(_onSheetScroll);
  }

  void _onSheetScroll() {
    if (_selected != ToolbarAttachmentTabKind.gallery) return;
    final c = _boundScroll;
    if (c == null || !c.hasClients) return;
    if (c.position.pixels >= c.position.maxScrollExtent - 400) _loadMore();
  }

  /// Тап по превью. В мультирежиме — переключает отметку; иначе разворачивает
  /// ассет в файл и сразу возвращает одиночный результат.
  Future<void> _pickAsset(AssetEntity asset) async {
    if (widget.multiSelect) {
      setState(() {
        final i = _picked.indexWhere((a) => a.id == asset.id);
        if (i >= 0) {
          _picked.removeAt(i);
        } else {
          _picked.add(asset);
        }
      });
      return;
    }
    // Экспорт уже идёт — игнорируем повторные тапы.
    if (_exportingId != null) return;
    setState(() => _exportingId = asset.id);
    try {
      final file = await asset.file;
      if (file == null || !mounted) return;
      await _processAndFinish(XFile(file.path), ToolbarAttachmentTabKind.gallery);
    } finally {
      if (mounted) setState(() => _exportingId = null);
    }
  }

  /// Прогоняет выбранное фото через [widget.processImage] (напр. кроп аватара) и
  /// закрывает лист с результатом. Если обработка вернула `null` (отмена) — лист
  /// остаётся открытым, пользователь возвращается в галерею.
  Future<void> _processAndFinish(XFile xfile, ToolbarAttachmentTabKind source) async {
    var file = xfile;
    final process = widget.processImage;
    if (process != null) {
      final processed = await process(file);
      if (processed == null || !mounted) return;
      file = processed;
    }
    _finish(ToolbarAttachmentImageResult(file, source));
  }

  /// Порядковый номер ассета в мультивыборе (1-based) или `null`, если не отмечен.
  int? _pickedOrder(AssetEntity asset) {
    final i = _picked.indexWhere((a) => a.id == asset.id);
    return i < 0 ? null : i + 1;
  }

  /// Возвращает все отмеченные медиа как [ToolbarAttachmentMultiImageResult].
  Future<void> _finishMulti() async {
    if (_picked.isEmpty) return;
    final files = <XFile>[];
    for (final asset in _picked) {
      final file = await asset.file;
      if (file != null) files.add(XFile(file.path));
    }
    if (!mounted || files.isEmpty) return;
    _finish(ToolbarAttachmentMultiImageResult(files));
  }

  /// Снимок с камеры (photo_manager не умеет захват — открываем собственный
  /// полноэкранный экран камеры [openCamera]).
  Future<void> _takePhoto() async {
    final image = await openCamera(context);
    if (image != null && mounted) await _processAndFinish(image, ToolbarAttachmentTabKind.camera);
  }

  /// Однократно запрашивает доступ к камере и запускает живое превью. При отказе
  /// или недоступности камеры контроллер остаётся `null` — плитка не рисуется.
  Future<void> _ensureCamera() async {
    if (_cameraInitTried) return;
    _cameraInitTried = true;

    final status = await Permission.camera.request();
    if (!status.isGranted) return; // доступ не выдан — плитки камеры не будет

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty || !mounted) return;
      _cameras = cameras;
      // По умолчанию — фронтальная камера (если есть).
      final front = cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.front);
      await _startCamera(front >= 0 ? front : 0);
    } catch (_) {
      // Камера недоступна (занята/ошибка) — просто не показываем плитку.
    }
  }

  /// Создаёт и запускает контроллер для камеры [index] и делает её активной.
  /// Предыдущий контроллер должен быть уже освобождён вызывающей стороной.
  Future<void> _startCamera(int index) async {
    try {
      final controller = CameraController(_cameras[index], ResolutionPreset.medium, enableAudio: false);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _cameraIndex = index;
        _cameraController = controller;
        _cameraAvailable = true;
      });
    } catch (_) {
      // Камера занята/ошибка — плитка останется со спиннером до след. попытки.
    }
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

  /// Заголовок системного альбома «все фото» показываем как «Выбрать из
  /// галереи»; для остальных — их собственное имя.
  String _albumTitle(BuildContext context) {
    final album = _album;
    if (album == null || album.isAll) return _label(context, ToolbarAttachmentTabKind.gallery);
    return album.name;
  }

  /// Кастомный хедер выбранного таба. Для галереи — кликабельный селектор
  /// альбома (открывает список всех альбомов).
  Widget _tabHeader(BuildContext context) {
    final style = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: CupertinoColors.label.resolveFrom(context));
    if (_selected == ToolbarAttachmentTabKind.gallery) {
      final enabled = _albums.length > 1;
      return GestureDetector(
        onTap: enabled ? _openAlbumPicker : null,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(_albumTitle(context), style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            if (enabled) ...[
              const SizedBox(width: 4),
              FaIcon(FontAwesomeIcons.chevronDown, size: 12, color: CupertinoColors.label.resolveFrom(context)),
            ],
          ],
        ),
      );
    }
    return Text(_label(context, _selected), style: style);
  }

  /// Кнопка «Готово» для мультивыбора: активна, когда что-то отмечено; в
  /// подписи — число отмеченных медиа.
  Widget _doneButton(BuildContext context) {
    final enabled = _picked.isNotEmpty;
    final color = enabled ? CupertinoTheme.of(context).primaryColor : CupertinoColors.tertiaryLabel.resolveFrom(context);
    return GestureDetector(
      onTap: enabled ? _finishMulti : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          enabled ? '${context.t.screenMyProfile.done} (${_picked.length})' : context.t.screenMyProfile.done,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: color),
        ),
      ),
    );
  }

  /// Кнопка-иконка «Управление доступом» (iOS, «ограниченный» доступ к фото).
  /// Круглая, в стиле кнопки закрытия — стоит справа в шапке, на её высоте.
  Widget _manageAccessButton(BuildContext context) {
    return GestureDetector(
      onTap: _manageLimited,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: CupertinoColors.tertiarySystemFill.resolveFrom(context), shape: BoxShape.circle),
        child: FaIcon(FontAwesomeIcons.sliders, size: 14, color: CupertinoColors.label.resolveFrom(context)),
      ),
    );
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
        // photo_manager не делает снимки — захват через нативную камеру.
        return _placeholder(context, onTap: _takePhoto);

      case ToolbarAttachmentTabKind.gallery:
        // Галерея рендерится отдельно ленивым CustomScrollView в build()
        // (см. _galleryScrollable) — сюда не попадает.
        return const SizedBox.shrink();

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

  // ─── Тело таба «галерея» ──────────────────────────────────────────────────

  /// Ленивая сетка превью из photo_manager на слайверах: `SliverGrid` строит и
  /// переиспользует только видимые плитки (+cacheExtent), поэтому десятки фото
  /// не декодируются разом — это убирает подтормаживание при скролле. Скролл —
  /// общий контроллер листа (нужен для раскрытия свайпом), пагинация — по
  /// слушателю [_onSheetScroll].
  Widget _galleryScrollable(BuildContext context, ScrollController controller) {
    // Пустые/промежуточные состояния должны оставаться скроллящимися, чтобы
    // жест раскрытия листа продолжал работать (AlwaysScrollable + FillRemaining).
    Widget filled(Widget child) => CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [SliverFillRemaining(hasScrollBody: false, child: Center(child: child))],
    );

    // Первичная загрузка ещё идёт — крутилка.
    if (!_galleryLoaded && _galleryLoading) return filled(const CupertinoActivityIndicator());
    // Доступ не выдан.
    if (_permission != null && !_permission!.hasAccess) return filled(_galleryDenied(context));
    // Доступ есть, но фото нет (и живого превью камеры тоже) — заглушка.
    if (_assets.isEmpty && !_cameraAvailable) {
      return filled(
        Text(context.t.screenMyProfile.galleryEmpty, style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context))),
      );
    }

    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(2),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2),
            delegate: SliverChildBuilderDelegate(
              // Первая плитка — живое превью камеры (когда доступна).
              (context, i) {
                if (_cameraAvailable) {
                  if (i == 0) return _cameraTile(context);
                  return _assetTile(context, _assets[i - 1]);
                }
                return _assetTile(context, _assets[i]);
              },
              childCount: _assets.length + (_cameraAvailable ? 1 : 0),
            ),
          ),
        ),
        // Индикатор подгрузки следующей страницы.
        if (_galleryLoading && _assets.isNotEmpty)
          const SliverToBoxAdapter(
            child: Padding(padding: EdgeInsets.symmetric(vertical: 12), child: CupertinoActivityIndicator()),
          ),
      ],
    );
  }

  /// Одно превью в сетке: картинка + (в мультивыборе) бейдж с порядковым
  /// номером и — для видео — индикатор длительности.
  Widget _assetTile(BuildContext context, AssetEntity asset) {
    final order = widget.multiSelect ? _pickedOrder(asset) : null;
    return GestureDetector(
      onTap: () => _pickAsset(asset),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: AssetEntityImageProvider(asset, isOriginal: false, thumbnailSize: const ThumbnailSize.square(240)),
            fit: BoxFit.cover,
            gaplessPlayback: true,
            filterQuality: FilterQuality.low,
          ),
          // Затемняем отмеченные превью для наглядности.
          if (order != null) Container(color: CupertinoColors.black.withValues(alpha: 0.25)),
          // Индикатор экспорта выбранного фото (одиночный выбор).
          if (_exportingId == asset.id)
            Container(
              color: CupertinoColors.black.withValues(alpha: 0.35),
              alignment: Alignment.center,
              child: const CupertinoActivityIndicator(color: CupertinoColors.white, radius: 12),
            ),
          // Индикатор видео с длительностью — левый нижний угол.
          if (asset.type == AssetType.video)
            Positioned(
              left: 4,
              bottom: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.play, size: 9, color: CupertinoColors.white),
                  const SizedBox(width: 2),
                  Text(
                    _formatDuration(asset.videoDuration),
                    style: const TextStyle(fontSize: 11, color: CupertinoColors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          // Бейдж выбора — правый верхний угол.
          if (widget.multiSelect)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: order != null ? CupertinoTheme.of(context).primaryColor : CupertinoColors.black.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(color: CupertinoColors.white, width: 1.5),
                ),
                child: order != null
                    ? Text(
                        '$order',
                        style: const TextStyle(fontSize: 12, color: CupertinoColors.white, fontWeight: FontWeight.w700),
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  /// Плитка живого превью камеры (первая в сетке). Тап открывает полную
  /// нативную камеру ([_takePhoto]); живое превью здесь — только видоискатель.
  /// Превью «покрывает» квадрат: у камеры кадр альбомный, поэтому меняем
  /// местами ширину/высоту и вписываем через `BoxFit.cover`.
  Widget _cameraTile(BuildContext context) {
    final controller = _cameraController;
    // Во время переключения камеры контроллер временно `null` — показываем
    // спиннер, сохраняя плитку на месте.
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        color: CupertinoColors.black.withValues(alpha: 0.85),
        alignment: Alignment.center,
        child: const CupertinoActivityIndicator(color: CupertinoColors.white, radius: 12),
      );
    }
    final preview = controller.value.previewSize ?? const Size(1, 1);
    return GestureDetector(
      onTap: _takePhoto,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(width: preview.height, height: preview.width, child: CameraPreview(controller)),
            ),
          ),
          // Иконка камеры — сигнал, что это живой видоискатель, а не фото.
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: CupertinoColors.black.withValues(alpha: 0.35), shape: BoxShape.circle),
              child: const FaIcon(FontAwesomeIcons.camera, size: 16, color: CupertinoColors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Длительность видео как `m:ss`.
  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// iOS: открыть системный лист управления «ограниченным» набором фото и
  /// перечитать альбом после возврата.
  Future<void> _manageLimited() async {
    await PhotoManager.presentLimited();
    _galleryLoaded = false;
    await _ensureGalleryLoaded();
  }

  Widget _galleryDenied(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(FontAwesomeIcons.lock, size: 40, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          const SizedBox(height: 16),
          Text(
            context.t.screenMyProfile.galleryAccessDenied,
            textAlign: TextAlign.center,
            style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
          const SizedBox(height: 12),
          CupertinoButton(
            onPressed: PhotoManager.openSetting,
            child: Text(
              context.t.screenMyProfile.galleryOpenSettings,
              style: TextStyle(
                color: CupertinoDynamicColor.withBrightness(
                  color: CupertinoTheme.of(context).primaryColor,
                  darkColor: CupertinoColors.white,
                ).resolveFrom(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Низ: переключатель табов ─────────────────────────────────────────────

  Widget _segmentTab(BuildContext context, ToolbarAttachmentTabKind kind) {
    final isSelected = kind == _selected;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: () {
          setState(() => _selected = kind);
          if (kind == ToolbarAttachmentTabKind.gallery) _ensureGalleryLoaded();
        },
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
        _bindScroll(scrollController);
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
                              if (_selected == ToolbarAttachmentTabKind.gallery)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // «Ограниченный» доступ к фото на iOS — управление набором.
                                      if (_permission == PermissionState.limited) _manageAccessButton(context),
                                      if (_permission == PermissionState.limited && widget.multiSelect) const SizedBox(width: 8),
                                      if (widget.multiSelect) _doneButton(context),
                                    ],
                                  ),
                                ),
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
                // раскрывать лист свайпом вверх. Галерея использует свой ленивый
                // CustomScrollView (переиспользование плиток = без подтормаживаний);
                // остальные табы — простой SingleChildScrollView.
                Expanded(
                  child: _selected == ToolbarAttachmentTabKind.gallery
                      ? _galleryScrollable(context, scrollController)
                      : SingleChildScrollView(
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

/// Модальный лист выбора альбома: строки с обложкой, именем и числом фото.
/// Возвращает выбранный [AssetPathEntity] через `Navigator.pop`.
class _AlbumPickerSheet extends StatelessWidget {
  final List<AssetPathEntity> albums;
  final AssetPathEntity? current;

  const _AlbumPickerSheet({required this.albums, required this.current});

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.6;
    return Container(
      decoration: BoxDecoration(
        color: ThemesCupertino.groupedBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: albums.length,
                  separatorBuilder: (_, _) => Padding(
                    padding: const EdgeInsets.only(left: 76),
                    child: Container(height: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
                  ),
                  itemBuilder: (context, i) => _AlbumRow(album: albums[i], selected: albums[i].id == current?.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Одна строка селектора альбома. Обложку и счётчик грузит асинхронно.
class _AlbumRow extends StatelessWidget {
  final AssetPathEntity album;
  final bool selected;

  const _AlbumRow({required this.album, required this.selected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context, album),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              child: SizedBox(
                width: 48,
                height: 48,
                child: FutureBuilder<List<AssetEntity>>(
                  future: album.getAssetListRange(start: 0, end: 1),
                  builder: (context, snap) {
                    final cover = (snap.data?.isNotEmpty ?? false) ? snap.data!.first : null;
                    if (cover == null) {
                      return ColoredBox(color: CupertinoColors.tertiarySystemFill.resolveFrom(context));
                    }
                    return Image(
                      image: AssetEntityImageProvider(cover, isOriginal: false, thumbnailSize: const ThumbnailSize.square(96)),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      filterQuality: FilterQuality.low,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                album.isAll ? context.t.screenMyProfile.chooseFromGallery : album.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, color: CupertinoColors.label.resolveFrom(context)),
              ),
            ),
            const SizedBox(width: 8),
            FutureBuilder<int>(
              future: album.assetCountAsync,
              builder: (context, snap) =>
                  Text('${snap.data ?? ''}', style: TextStyle(fontSize: 15, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
            ),
            if (selected) ...[
              const SizedBox(width: 8),
              FaIcon(FontAwesomeIcons.check, size: 15, color: CupertinoTheme.of(context).primaryColor),
            ],
          ],
        ),
      ),
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
