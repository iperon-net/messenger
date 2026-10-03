import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Поиск на вкладках «Чаты», «Звонки», «Контакты» уезжает вместе со списком,
/// как в Telegram. Шапка (поиск + то, что под ним: баннер, табы/фильтр) лежит
/// поверх списка и сдвигается вверх ровно на его прокрутку, но не дальше
/// высоты поиска — остальное прилипает к верху. Отпустили палец на полпути —
/// список доезжает до «поиск виден целиком» или «спрятан целиком».
///
/// Списков может быть несколько (папки чатов в `PageView`): у каждого свой
/// `ScrollController` по ключу ([searchListController]); при смене списка
/// новый выравнивается под текущее положение шапки ([onSearchListChanged]),
/// чтобы она не прыгала. Общая логика для Cupertino и Material.
mixin SearchHideOnScroll<T extends StatefulWidget> on State<T> {
  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  /// Насколько шапка уехала вверх: 0 — поиск виден, [_searchHeight] — спрятан.
  final _collapse = ValueNotifier<double>(0);

  /// Полная высота шапки — отступ сверху у списков.
  final _headerHeight = ValueNotifier<double>(0);
  double _searchHeight = 0;
  final _scrollControllers = <String, ScrollController>{};

  @override
  void dispose() {
    searchController.dispose();
    searchFocus.dispose();
    _collapse.dispose();
    _headerHeight.dispose();
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Контроллер списка [key]; новый стартует под текущее положение шапки.
  ScrollController searchListController([String key = '']) =>
      _scrollControllers.putIfAbsent(key, () => ScrollController(initialScrollOffset: _collapse.value));

  /// Сменился активный список (папка в `PageView`): подгоняем его под шапку.
  void onSearchListChanged(String key) {
    final controller = _scrollControllers[key];
    if (controller == null || !controller.hasClients) return;
    if (controller.offset < _searchHeight) {
      controller.jumpTo(_collapse.value);
    } else {
      _collapse.value = _searchHeight;
    }
  }

  /// Для `NotificationListener<ScrollNotification>` над списком (или над
  /// `PageView` списков): горизонтальные уведомления игнорируются.
  bool onSearchScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) return false;
    if (notification is ScrollUpdateNotification) {
      _collapse.value = metrics.pixels.clamp(0, _searchHeight);
    } else if (notification is ScrollEndNotification) {
      final pixels = metrics.pixels;
      if (pixels > 0 && pixels < _searchHeight) {
        final position = Scrollable.maybeOf(notification.context!)?.position;
        final target = pixels < _searchHeight / 2 ? 0.0 : _searchHeight;
        // Не из обработчика уведомления: позиция ещё завершает активность.
        Future.microtask(() => position?.animateTo(target, duration: const Duration(milliseconds: 200), curve: Curves.easeOutCubic));
      }
    }
    return false;
  }

  /// Тело вкладки: [body] (список/списки) на всю высоту, поверх — шапка из
  /// [search] (уезжает и гаснет) и [header] (едет следом и прилипает к верху).
  /// [background] — непрозрачный фон шапки, под которым проезжают строки.
  /// Списки внутри [body] берут контроллер из [searchListController] и отступ
  /// сверху из [belowSearchHeader].
  Widget searchHideOnScrollBody({required Color background, required Widget search, List<Widget> header = const [], required Widget body}) {
    return Stack(
      children: [
        Positioned.fill(
          child: NotificationListener<ScrollMetricsNotification>(
            // Список укоротился (поиск, фильтр) — позиция поджалась без
            // ScrollUpdate; без этого шапка могла остаться полуспрятанной. Только
            // открываем: соседняя папка, построенная при свайпе, не должна прятать.
            onNotification: (notification) {
              final metrics = notification.metrics;
              if (metrics.axis == Axis.vertical && metrics.pixels < _collapse.value) {
                _collapse.value = metrics.pixels.clamp(0, _searchHeight);
              }
              return false;
            },
            child: NotificationListener<ScrollNotification>(onNotification: onSearchScroll, child: body),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<double>(
            valueListenable: _collapse,
            builder: (context, collapse, child) => Transform.translate(offset: Offset(0, -collapse), child: child),
            child: ColoredBox(
              color: background,
              child: _MeasureSize(
                onChange: (size) => _headerHeight.value = size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MeasureSize(
                      onChange: (size) => _searchHeight = size.height,
                      child: ValueListenableBuilder<double>(
                        valueListenable: _collapse,
                        builder: (context, collapse, child) =>
                            Opacity(opacity: _searchHeight == 0 ? 1 : (1 - collapse / _searchHeight).clamp(0, 1), child: child),
                        child: search,
                      ),
                    ),
                    ...header,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Отступ сверху под шапку — для списков и пустых/загрузочных состояний.
  Widget belowSearchHeader(Widget Function(double top) builder) {
    return ValueListenableBuilder<double>(valueListenable: _headerHeight, builder: (context, top, _) => builder(top));
  }

  /// [child] (заглушка, индикатор загрузки) по центру области под шапкой.
  /// Прокручивать тут нечего, поэтому шапка возвращается целиком.
  Widget belowSearchHeaderCentered(Widget child) {
    if (_collapse.value != 0) WidgetsBinding.instance.addPostFrameCallback((_) => _collapse.value = 0);
    return belowSearchHeader(
      (top) => Padding(
        padding: EdgeInsets.only(top: top),
        child: Center(child: child),
      ),
    );
  }
}

/// Сообщает размер ребёнка после каждой раскладки, где он поменялся.
class _MeasureSize extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onChange;

  const _MeasureSize({required this.onChange, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderMeasureSize(onChange);

  @override
  void updateRenderObject(BuildContext context, _RenderMeasureSize renderObject) => renderObject.onChange = onChange;
}

class _RenderMeasureSize extends RenderProxyBox {
  ValueChanged<Size> onChange;
  Size? _last;

  _RenderMeasureSize(this.onChange);

  @override
  void performLayout() {
    super.performLayout();
    if (size == _last) return;
    _last = size;
    // Колбэк меняет ValueNotifier'ы — не во время раскладки.
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(size));
  }
}
