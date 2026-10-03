import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Поиск на вкладках «Чаты», «Звонки», «Контакты» уезжает вместе со списком,
/// как в Telegram. Шапка (поиск + то, что под ним: баннер, табы/фильтр) лежит
/// поверх списка; поиск уезжает вверх на прокрутку вниз и гаснет, остальное
/// прилипает к верху. Спрятанный поиск возвращается, только когда список
/// докручен до начала. Отпустили палец на полпути — шапка доезжает до «поиск
/// виден целиком» или «спрятан целиком».
///
/// Списков может быть несколько (папки чатов в `PageView`), у каждого свой
/// `ScrollController` по ключу ([searchListController]). Положение шапки общее
/// для всех и при свайпе между папками не меняется: соседний список заранее
/// подгоняется под шапку, а сменившийся активный — в [onSearchListChanged].
/// Общая логика для Cupertino и Material.
mixin SearchHideOnScroll<T extends StatefulWidget> on State<T> {
  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  /// Насколько шапка уехала вверх: 0 — поиск виден, [_searchHeight] — спрятан.
  /// Инвариант: не больше прокрутки активного списка (иначе между табами и
  /// первой строкой была бы пустая полоса).
  final _collapse = ValueNotifier<double>(0);

  /// Полная высота шапки — отступ сверху у списков.
  final _headerHeight = ValueNotifier<double>(0);
  double _searchHeight = 0;
  final _scrollControllers = <String, ScrollController>{};

  /// Ключ активного списка; первым становится первый запрошенный.
  String? _activeKey;

  /// Доводка шапки, когда список стоит дальше поиска и двигать его не нужно.
  Ticker? _snapTicker;

  @override
  void dispose() {
    _snapTicker?.dispose();
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
  ScrollController searchListController([String key = '']) {
    _activeKey ??= key;
    return _scrollControllers.putIfAbsent(key, () => ScrollController(initialScrollOffset: _collapse.value));
  }

  /// Сменился активный список (папка в `PageView`). Шапку не трогаем — список
  /// подгоняем под неё (если он короткий и не докручивается — открываем шапку).
  void onSearchListChanged(String key) {
    _activeKey = key;
    final controller = _scrollControllers[key];
    if (controller == null || !controller.hasClients) return;
    final position = controller.position;
    if (position.pixels < _collapse.value) {
      final target = _collapse.value.clamp(position.minScrollExtent, position.maxScrollExtent);
      position.jumpTo(target);
      if (target < _collapse.value) _setCollapse(target.clamp(0, _searchHeight));
    }
  }

  /// Уведомление от активного списка? Соседние папки, построенные при свайпе,
  /// шапкой не управляют.
  ScrollPosition? _positionOf(Notification notification) {
    final context = switch (notification) {
      ScrollNotification(:final context) => context,
      ScrollMetricsNotification(:final context) => context,
      _ => null,
    };
    if (context == null || !context.mounted) return null;
    return Scrollable.maybeOf(context)?.position;
  }

  bool _isActive(ScrollPosition? position) {
    final controller = _scrollControllers[_activeKey];
    if (position == null || controller == null || !controller.hasClients) return true;
    return controller.positions.contains(position);
  }

  void _setCollapse(double value) {
    _snapTicker?.stop();
    _collapse.value = value;
  }

  /// Для `NotificationListener<ScrollNotification>` над списком (или над
  /// `PageView` списков): горизонтальные уведомления игнорируются.
  bool onSearchScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) return false;
    final position = _positionOf(notification);
    if (!_isActive(position)) return false;

    if (notification is ScrollStartNotification && notification.dragDetails != null) {
      _snapTicker?.stop();
    } else if (notification is ScrollUpdateNotification) {
      // Идёт доводка шапки — она сама приведёт к нужному положению.
      if (_snapTicker?.isActive ?? false) return false;
      final delta = notification.scrollDelta ?? 0;
      final collapse = _collapse.value;
      // Вниз — поиск уезжает на прокрутку; вверх — возвращается, только когда
      // начало списка доходит до шапки (до этого остаётся как был).
      final next = delta > 0 ? collapse + delta : collapse;
      _collapse.value = next.clamp(0, metrics.pixels.clamp(0, _searchHeight));
    } else if (notification is ScrollEndNotification) {
      final collapse = _collapse.value;
      if (collapse <= 0 || collapse >= _searchHeight) return false;
      final pixels = metrics.pixels;
      final target = collapse < _searchHeight / 2 ? 0.0 : _searchHeight;
      // Не из обработчика уведомления: позиция ещё завершает активность.
      Future.microtask(() {
        if ((pixels - collapse).abs() < 0.5) {
          // Шапка «сцеплена» со списком — доводим список, шапка едет за ним.
          position?.animateTo(target, duration: const Duration(milliseconds: 200), curve: Curves.easeOutCubic);
          return;
        }
        if (target > pixels) position?.animateTo(target, duration: const Duration(milliseconds: 200), curve: Curves.easeOutCubic);
        _animateCollapse(target);
      });
    }
    return false;
  }

  /// Список изменил размеры (поиск, фильтр, новые строки) — позиция могла
  /// поджаться без ScrollUpdate. Активный: держим инвариант (шапка не дальше
  /// прокрутки). Соседний (построен при свайпе): подгоняем под шапку.
  bool _onScrollMetrics(ScrollMetricsNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) return false;
    final position = _positionOf(notification);
    if (_isActive(position)) {
      if (metrics.pixels < _collapse.value) _setCollapse(metrics.pixels.clamp(0, _searchHeight));
    } else if (position != null && metrics.pixels < _collapse.value) {
      final target = _collapse.value.clamp(metrics.minScrollExtent, metrics.maxScrollExtent);
      if ((metrics.pixels - target).abs() > 0.5) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (position.hasPixels) position.jumpTo(target);
        });
      }
    }
    return false;
  }

  void _animateCollapse(double target) {
    _snapTicker?.dispose();
    final from = _collapse.value;
    const duration = Duration(milliseconds: 200);
    _snapTicker = Ticker((elapsed) {
      final t = (elapsed.inMicroseconds / duration.inMicroseconds).clamp(0.0, 1.0);
      _collapse.value = from + (target - from) * Curves.easeOutCubic.transform(t);
      if (t >= 1) _snapTicker?.stop();
    })..start();
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
            onNotification: _onScrollMetrics,
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

  /// Список под шапкой: [children] или [itemBuilder] (+ [separatorBuilder]),
  /// пусто — [empty] по центру. Снизу добивается так, чтобы список всегда
  /// прокручивался хотя бы на высоту поиска: в короткой папке (мало чатов)
  /// поиск тоже можно спрятать, и при переходе из длинной папки со
  /// спрятанным поиском он не всплывает — открыть можно, только потянув вниз.
  Widget searchListView({
    Key? key,
    String listKey = '',
    List<Widget>? children,
    int itemCount = 0,
    IndexedWidgetBuilder? itemBuilder,
    IndexedWidgetBuilder? separatorBuilder,
    Widget? empty,
  }) {
    final Widget sliver;
    if (empty != null) {
      sliver = SliverFillRemaining(hasScrollBody: false, child: Center(child: empty));
    } else if (children != null) {
      sliver = SliverList.list(children: children);
    } else if (separatorBuilder != null) {
      sliver = SliverList.separated(itemCount: itemCount, itemBuilder: itemBuilder!, separatorBuilder: separatorBuilder);
    } else {
      sliver = SliverList.builder(itemCount: itemCount, itemBuilder: itemBuilder!);
    }
    return belowSearchHeader(
      (top) => CustomScrollView(
        key: key,
        controller: searchListController(listKey),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(top: top),
            sliver: sliver,
          ),
          SliverLayoutBuilder(
            builder: (context, constraints) {
              final extra = constraints.viewportMainAxisExtent + _searchHeight - constraints.precedingScrollExtent;
              return SliverToBoxAdapter(child: SizedBox(height: extra > 0 ? extra : 0));
            },
          ),
        ],
      ),
    );
  }

  /// Отступ сверху под шапку.
  Widget belowSearchHeader(Widget Function(double top) builder) {
    return ValueListenableBuilder<double>(valueListenable: _headerHeight, builder: (context, top, _) => builder(top));
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
