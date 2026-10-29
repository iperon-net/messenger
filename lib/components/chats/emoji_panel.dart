import 'dart:async';
import 'dart:math' as math;

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart'
    show Material, MaterialType, IconButton, Icons, Icon, TextField, InputDecoration, InputBorder, TabController;
import 'package:lottie/lottie.dart';
import 'package:flutter/widgets.dart';

import '../../chats/animated_emoji.dart';
import '../../chats/emoji_filter.dart';
import '../../device_performance.dart';
import '../../i18n/translations.g.dart';

/// Панель эмодзи вместо клавиатуры (как в Telegram): кнопка в поле ввода
/// переключает клавиатуру ↔ панель. Высота панели — последней высоты
/// клавиатуры, а пока клавиатура уезжает / выезжает, панель занимает только
/// остаток — поле ввода не прыгает.
class EmojiPanelController extends ChangeNotifier with WidgetsBindingObserver {
  EmojiPanelController({required this.focus}) {
    focus.addListener(_onFocus);
    FocusManager.instance.addListener(_onPrimaryFocus);
    WidgetsBinding.instance.addObserver(this);
  }

  /// Фокус поля ввода: получило фокус (тап по полю) — панель уступает клавиатуре.
  final FocusNode focus;

  /// Панель показана.
  bool get open => _open;
  bool _open = false;

  /// Высота последней показанной клавиатуры (логические пиксели).
  double get height => _height;
  double _height = 300;

  /// Максимум insets с последнего «клавиатура скрыта»: во время анимации
  /// клавиатура проходит промежуточные высоты — запоминаем только полную.
  double _shownMax = 0;

  /// Переход панель → клавиатура: место держим, пока клавиатура не выехала.
  bool _toKeyboard = false;
  Timer? _toKeyboardTimeout;

  /// Сколько сейчас занимает клавиатура (сырые insets окна: Scaffold прячет их от тела).
  double get _keyboard {
    final view = WidgetsBinding.instance.platformDispatcher.implicitView;
    if (view == null) return 0;
    return view.viewInsets.bottom / view.devicePixelRatio;
  }

  /// Открыт поиск в панели: фокус в её поле, клавиатура поднята — панель
  /// (строка результатов + поле поиска) стоит над клавиатурой своей высоты.
  bool get searching {
    if (!_open) return false;
    final primary = FocusManager.instance.primaryFocus;
    return primary != null && primary != focus && primary is! FocusScopeNode;
  }

  void _onPrimaryFocus() {
    if (_open) notifyListeners();
  }

  /// Высота области под полем ввода: панель / остаток при смене.
  double get reserved {
    if (!_open && !_toKeyboard) return 0;
    return math.max(0, _height - _keyboard);
  }

  /// Кнопка в поле ввода: панель ↔ клавиатура.
  void toggle() {
    if (_open) {
      showKeyboard();
    } else {
      _toKeyboard = false;
      _open = true;
      focus.unfocus();
      notifyListeners();
    }
  }

  /// Закрыть панель и открыть клавиатуру (место держим до её появления).
  void showKeyboard() {
    if (!_open) return;
    _open = false;
    _toKeyboard = true;
    _toKeyboardTimeout?.cancel();
    _toKeyboardTimeout = Timer(const Duration(milliseconds: 600), _endToKeyboard);
    notifyListeners();
    if (!focus.hasFocus) focus.requestFocus();
  }

  /// Закрыть без клавиатуры (назад, отправка из режима выделения и т.п.).
  void close() {
    if (!_open && !_toKeyboard) return;
    _open = false;
    _endToKeyboard();
  }

  void _endToKeyboard() {
    _toKeyboardTimeout?.cancel();
    _toKeyboard = false;
    notifyListeners();
  }

  void _onFocus() {
    if (focus.hasFocus && _open) showKeyboard();
  }

  @override
  void didChangeMetrics() {
    final keyboard = _keyboard;
    if (keyboard <= 0) {
      _shownMax = 0;
    } else if (keyboard > _shownMax) {
      _shownMax = keyboard;
      if (_shownMax > 150) _height = _shownMax;
    }
    if (_toKeyboard && keyboard >= _height - 1) {
      _endToKeyboard();
      return;
    }
    if (_open || _toKeyboard) notifyListeners();
  }

  @override
  void dispose() {
    _toKeyboardTimeout?.cancel();
    focus.removeListener(_onFocus);
    FocusManager.instance.removeListener(_onPrimaryFocus);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// Цвета панели под платформу (Cupertino / Material).
class EmojiPanelStyle {
  final Color background;
  final Color icon;
  final Color accent;

  /// Текст поля поиска (подсказка — [icon]).
  final Color text;
  final bool cupertino;

  const EmojiPanelStyle({required this.background, required this.icon, required this.accent, required this.text, required this.cupertino});
}

/// Место под полем ввода: панель эмодзи (вставляет в [input] у курсора) или
/// остаток высоты, пока клавиатура выезжает. Назад (Android) — закрывает панель.
class EmojiPanel extends StatelessWidget {
  final EmojiPanelController controller;
  final TextEditingController input;
  final EmojiPanelStyle style;

  const EmojiPanel({super.key, required this.controller, required this.input, required this.style});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final height = controller.reserved;
        return PopScope(
          canPop: !controller.open,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) controller.close();
          },
          // Поиск: своя высота (результаты + поле) над клавиатурой. Тот же
          // SizedBox (height: null) — состояние панели (открытый поиск) не
          // теряется при смене.
          child: SizedBox(
            height: controller.searching ? null : height,
            child: controller.open ? _picker(context, controller.height) : null,
          ),
        );
      },
    );
  }

  Widget _picker(BuildContext context, double height) => emojiPickerView(context, input: input, style: style, height: height);
}

/// Сетка эмодзи с группами, поиском и «стереть»; вставляет в [input] у
/// курсора. [columns] — столбцов (по умолчанию по ширине экрана, не меньше 8).
Widget emojiPickerView(
  BuildContext context, {
  required TextEditingController input,
  required EmojiPanelStyle style,
  required double height,
  int? columns,
}) {
  final locale = LocaleSettings.currentLocale.languageCode;
  // Значки групп в полосе — помельче (полоса ниже).
  return IconTheme.merge(
    data: const IconThemeData(size: 21),
    child: EmojiPicker(
      textEditingController: input,
      // Своя сетка: отклик на нажатие и предпросмотр по удержанию.
      customWidget: (config, state, showSearchBar) => _PanelEmojiView(config, state, showSearchBar, style: style),
      onBackspacePressed: () => HapticFeedback.selectionClick(),
      config: Config(
        height: height,
        locale: Locale(locale),
        // Без ЛГБТ-флагов и однополых пар / семей (см. isHiddenEmoji).
        emojiSet: filteredEmojiSet,
        checkPlatformCompatibility: true,
        emojiViewConfig: EmojiViewConfig(
          // На телефоне 8, на iPad / планшете — по ширине, а не 8 огромных.
          columns: columns ?? math.max(8, MediaQuery.sizeOf(context).width ~/ 50),
          // https://github.com/flutter/flutter/issues/28894 — на iOS глифы мельче.
          emojiSizeMax: 28 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.2 : 1.0),
          backgroundColor: style.background,
          buttonMode: style.cupertino ? ButtonMode.CUPERTINO : ButtonMode.MATERIAL,
          recentsLimit: 32,
          noRecents: const SizedBox.shrink(),
        ),
        skinToneConfig: SkinToneConfig(dialogBackgroundColor: style.background, indicatorColor: style.icon, rememberSkinTone: true),
        categoryViewConfig: CategoryViewConfig(
          // Полоса групп ниже и без разделительной линии.
          tabBarHeight: 36,
          dividerColor: const Color(0x00000000),
          backgroundColor: style.background,
          indicatorColor: style.accent,
          iconColor: style.icon,
          iconColorSelected: style.accent,
          backspaceColor: style.accent,
        ),
        bottomActionBarConfig: BottomActionBarConfig(
          backgroundColor: style.background,
          buttonColor: style.background,
          buttonIconColor: style.icon,
          // Лупа и «стереть» — не у самого края: отступ от углов и над
          // полоской «домой» (панель доходит до низа экрана).
          customBottomActionBar: (config, state, showSearchView) => ColoredBox(
            color: style.background,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.paddingOf(context).bottom),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SearchButton(config, showSearchView, style.icon),
                  BackspaceButton(config, state.onBackspacePressed, state.onBackspaceLongPressed, style.icon),
                ],
              ),
            ),
          ),
        ),
        searchViewConfig: SearchViewConfig(
          backgroundColor: style.background,
          buttonIconColor: style.icon,
          hintText: context.t.screenChat.emojiSearch,
          inputTextStyle: TextStyle(color: style.text, fontSize: 16),
          hintTextStyle: TextStyle(color: style.icon, fontSize: 16),
          customSearchView: (config, state, showEmojiView) => _PanelSearchView(config, state, showEmojiView, style: style),
        ),
      ),
    ),
  );
}

/// Поиск в панели: результаты сеткой до [_rows] строк (в стандартном — одна
/// строка), под ними поле поиска цветов темы.
class _PanelSearchView extends SearchView {
  final EmojiPanelStyle style;

  const _PanelSearchView(super.config, super.state, super.showEmojiView, {required this.style});

  @override
  _PanelSearchViewState createState() => _PanelSearchViewState();
}

class _PanelSearchViewState extends SearchViewState<_PanelSearchView> {
  static const _rows = 3;

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final search = widget.config.searchViewConfig;
    return LayoutBuilder(
      builder: (context, constraints) {
        final emojiSize = widget.config.emojiViewConfig.getEmojiSize(constraints.maxWidth);
        final boxSize = widget.config.emojiViewConfig.getEmojiBoxSize(constraints.maxWidth);
        final columns = widget.config.emojiViewConfig.columns;
        final rows = math.min(_rows, math.max(1, (results.length / columns).ceil()));
        return ColoredBox(
          color: style.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: rows * boxSize + 8,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns),
                  itemCount: results.length,
                  itemBuilder: (context, index) => buildEmoji(results[index], emojiSize, boxSize),
                ),
              ),
              Material(
                type: MaterialType.transparency,
                child: Row(
                  children: [
                    IconButton(onPressed: widget.showEmojiView, color: style.icon, icon: const Icon(Icons.arrow_back)),
                    Expanded(
                      child: TextField(
                        onChanged: onTextInputChanged,
                        focusNode: focusNode,
                        style: search.inputTextStyle,
                        cursorColor: style.accent,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: search.hintText,
                          hintStyle: search.hintTextStyle,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Сетка панели — как стандартная (`DefaultEmojiPickerView` пакета), но со
/// своими ячейками [_PanelEmojiCell].
class _PanelEmojiView extends EmojiPickerView {
  final EmojiPanelStyle style;

  const _PanelEmojiView(super.config, super.state, super.showSearchBar, {required this.style});

  @override
  State<_PanelEmojiView> createState() => _PanelEmojiViewState();
}

class _PanelEmojiViewState extends State<_PanelEmojiView> with SingleTickerProviderStateMixin, SkinToneOverlayStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  final _scrollController = ScrollController();
  final _utils = EmojiPickerUtils();
  String? _rememberedSkinTone;

  /// Сетка прокручивается (на средних устройствах анимации в это время стоят).
  final _scrolling = ValueNotifier(false);

  @override
  void initState() {
    final target = widget.state.currentCategory ?? widget.config.categoryViewConfig.initCategory;
    final index = math.max(0, widget.state.categoryEmoji.indexWhere((e) => e.category == target));
    _tabController = TabController(initialIndex: index, length: widget.state.categoryEmoji.length, vsync: this);
    _pageController = PageController(initialPage: index)..addListener(closeSkinToneOverlay);
    _scrollController.addListener(closeSkinToneOverlay);
    widget.state.categoryNavigationNotifier.addListener(_onCategoryNavigation);
    if (widget.config.skinToneConfig.rememberSkinTone) {
      _utils.getRememberedSkinTone().then((tone) {
        if (mounted && tone != null) setState(() => _rememberedSkinTone = tone);
      });
    }
    super.initState();
  }

  void _onCategoryNavigation() {
    final target = widget.state.categoryNavigationNotifier.value;
    if (target == null) return;
    final index = widget.state.categoryEmoji.indexWhere((e) => e.category == target);
    if (index != -1 && index != _pageController.page?.round()) _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    widget.state.categoryNavigationNotifier.removeListener(_onCategoryNavigation);
    closeSkinToneOverlay();
    _pageController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    _scrolling.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    return LayoutBuilder(
      builder: (context, constraints) {
        final emojiSize = config.emojiViewConfig.getEmojiSize(constraints.maxWidth);
        final boxSize = config.emojiViewConfig.getEmojiBoxSize(constraints.maxWidth);
        return EmojiContainer(
          color: config.emojiViewConfig.backgroundColor,
          buttonMode: config.emojiViewConfig.buttonMode,
          child: ClipRect(
            child: Column(
              children: [
                DefaultCategoryView(config, widget.state, _tabController, _pageController),
                Flexible(
                  child: PageView.builder(
                    itemCount: widget.state.categoryEmoji.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      _tabController.animateTo(index, duration: config.categoryViewConfig.tabIndicatorAnimDuration);
                      widget.state.onCategoryChanged?.call(widget.state.categoryEmoji[index].category);
                    },
                    itemBuilder: (context, index) => _page(emojiSize, boxSize, widget.state.categoryEmoji[index]),
                  ),
                ),
                config.bottomActionBarConfig.customBottomActionBar!(config, widget.state, widget.showSearchBar),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _page(double emojiSize, double boxSize, CategoryEmoji category) {
    if (category.category == Category.RECENT && category.emoji.isEmpty) return const SizedBox.shrink();
    final config = widget.config;
    final grid = GridView.builder(
      key: const Key('emojiScrollView'),
      controller: _scrollController,
      primary: false,
      padding: config.emojiViewConfig.gridPadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: config.emojiViewConfig.columns),
      itemCount: category.emoji.length,
      itemBuilder: (context, index) {
        final emoji = _utils.applyDisplaySkinTone(category.emoji[index], config.skinToneConfig, _rememberedSkinTone);
        final tones = emoji.hasSkinTone && config.skinToneConfig.enabled;
        return addSkinToneTargetIfAvailable(
          hasSkinTone: emoji.hasSkinTone,
          linkKey: category.category.name + emoji.emoji,
          child: _PanelEmojiCell(
            // Состояние (отклик) — за эмодзи, а не за позицией: «Недавние» перестраиваются.
            key: ValueKey(emoji.emoji),
            emoji: emoji,
            emojiSize: emojiSize,
            boxSize: boxSize,
            style: widget.style,
            skinToneIndicator: tones ? config.skinToneConfig.indicatorColor : null,
            onSelected: () => _select(category.category, emoji),
            scrolling: _scrolling,
            // С оттенками — удержание открывает выбор оттенка (как было).
            onSkinTones: tones ? (position) => _openSkinTones(position, emoji, emojiSize, category) : null,
          ),
        );
      },
    );
    // Начало / конец прокрутки — для паузы анимаций на средних устройствах.
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) _scrolling.value = true;
        if (notification is ScrollEndNotification) _scrolling.value = false;
        return false;
      },
      child: grid,
    );
  }

  void _openSkinTones(Offset position, Emoji emoji, double emojiSize, CategoryEmoji category) {
    closeSkinToneOverlay();
    showSkinToneOverlay(position, emoji, emojiSize, category, widget.config, _select, links[category.category.name + emoji.emoji]!);
  }

  void _select(Category? category, Emoji emoji) {
    if (widget.config.skinToneConfig.rememberSkinTone && emoji.hasSkinTone) {
      final tone = _utils.extractSkinTone(emoji);
      if (tone != _rememberedSkinTone) {
        _utils.setRememberedSkinTone(tone);
        setState(() => _rememberedSkinTone = tone);
      }
    }
    widget.state.onEmojiSelected(category, emoji);
    closeSkinToneOverlay();
  }
}

/// Ячейка эмодзи: нажатие — эмодзи «пружинит» (с лёгкой вибрацией) и
/// вставляется; удержание — крупный предпросмотр над ячейкой (анимацией Noto,
/// если она есть), отпустил — закрывается, ничего не вставляя. У эмодзи с оттенками кожи
/// удержание открывает выбор оттенка.
class _PanelEmojiCell extends StatefulWidget {
  final Emoji emoji;
  final double emojiSize;
  final double boxSize;
  final EmojiPanelStyle style;
  final Color? skinToneIndicator;
  final VoidCallback onSelected;
  final void Function(Offset position)? onSkinTones;

  /// Сетка прокручивается.
  final ValueListenable<bool> scrolling;

  const _PanelEmojiCell({
    required this.scrolling,
    super.key,
    required this.emoji,
    required this.emojiSize,
    required this.boxSize,
    required this.style,
    required this.skinToneIndicator,
    required this.onSelected,
    required this.onSkinTones,
  });

  @override
  State<_PanelEmojiCell> createState() => _PanelEmojiCellState();
}

class _PanelEmojiCellState extends State<_PanelEmojiCell> with TickerProviderStateMixin {
  /// Встроенная анимация (40 популярных): крутится по кругу, пока ячейка на
  /// экране (как в Telegram); нажатие — «пружинка» и для неё. Остальные —
  /// обычный глиф.
  LottieComposition? _composition;
  AnimationController? _animation;

  @override
  void initState() {
    super.initState();
    // Слабое устройство / энергосбережение — без анимаций в сетке.
    if (!DevicePerformance.instance.loopAnimations) return;
    final data = AnimatedEmojiStore.lookup(widget.emoji.emoji);
    if (data == null || !bundledAnimatedEmoji.contains(data.name)) return;
    widget.scrolling.addListener(_onScrolling);
    final ready = AnimatedEmojiStore.ready(data);
    if (ready != null) {
      _animate(ready);
    } else {
      AnimatedEmojiStore.load(data).then((composition) {
        if (mounted && composition != null) setState(() => _animate(composition));
      });
    }
  }

  void _animate(LottieComposition composition) {
    _composition = composition;
    _animation = AnimationController(vsync: this, duration: composition.duration);
    _onScrolling();
  }

  /// Среднее устройство — во время прокрутки анимации стоят.
  void _onScrolling() {
    final animation = _animation;
    if (animation == null) return;
    final pause = widget.scrolling.value && DevicePerformance.instance.current == PerformanceClass.average;
    if (pause) {
      animation.stop();
    } else if (!animation.isAnimating) {
      animation.repeat();
    }
  }

  late final _bounce = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
  late final _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.35).chain(CurveTween(curve: Curves.easeOut)), weight: 40),
    TweenSequenceItem(tween: Tween<double>(begin: 1.35, end: 1).chain(CurveTween(curve: Curves.elasticOut)), weight: 60),
  ]).animate(_bounce);
  OverlayEntry? _preview;

  void _tap() {
    HapticFeedback.selectionClick();
    _bounce.forward(from: 0);
    widget.onSelected();
  }

  void _longPressStart(LongPressStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    if (widget.onSkinTones case final onSkinTones?) {
      onSkinTones(position);
      return;
    }
    HapticFeedback.lightImpact();
    _showPreview(position, box.size);
  }

  void _showPreview(Offset position, Size cell) {
    _hidePreview();
    const size = 112.0;
    final screen = MediaQuery.sizeOf(context);
    final left = (position.dx + cell.width / 2 - size / 2).clamp(8.0, screen.width - size - 8);
    final top = math.max(MediaQuery.paddingOf(context).top + 8, position.dy - size - 8);
    final entry = _preview = OverlayEntry(
      builder: (context) => Positioned(
        left: left,
        top: top,
        child: IgnorePointer(
          child: _EmojiPreview(emoji: widget.emoji.emoji, size: size, style: widget.style),
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  void _hidePreview() {
    _preview?.remove();
    _preview = null;
  }

  @override
  void dispose() {
    _hidePreview();
    widget.scrolling.removeListener(_onScrolling);
    _bounce.dispose();
    _animation?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final composition = _composition;
    final Widget text = composition != null
        ? Lottie(
            composition: composition,
            controller: _animation,
            width: widget.emojiSize * 1.2,
            height: widget.emojiSize * 1.2,
            // Десятки по кругу: кэш команд отрисовки — меньше работы на кадр.
            renderCache: RenderCache.drawingCommands,
          )
        : Text(
            widget.emoji.emoji,
            textScaler: TextScaler.noScaling,
            style: DefaultEmojiTextStyle.copyWith(fontSize: widget.emojiSize, inherit: true),
          );
    final indicator = widget.skinToneIndicator;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _tap,
      onLongPressStart: _longPressStart,
      // Отпустил — только закрыть: удержание — просмотр, не выбор.
      onLongPressEnd: (_) => _hidePreview(),
      onLongPressCancel: _hidePreview,
      child: SizedBox(
        width: widget.boxSize,
        height: widget.boxSize,
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: indicator == null
                  ? text
                  : DecoratedBox(
                      decoration: TriangleDecoration(color: indicator, size: 8),
                      child: text,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Карточка предпросмотра: анимация Noto (крутится, пока держат) или крупный
/// статичный эмодзи, если анимации нет / ещё грузится.
class _EmojiPreview extends StatefulWidget {
  final String emoji;
  final double size;
  final EmojiPanelStyle style;

  const _EmojiPreview({required this.emoji, required this.size, required this.style});

  @override
  State<_EmojiPreview> createState() => _EmojiPreviewState();
}

class _EmojiPreviewState extends State<_EmojiPreview> {
  LottieComposition? _composition;

  @override
  void initState() {
    super.initState();
    final data = AnimatedEmojiStore.lookup(widget.emoji);
    if (data == null) return;
    _composition = AnimatedEmojiStore.ready(data);
    if (_composition == null) {
      AnimatedEmojiStore.load(data).then((composition) {
        if (mounted && composition != null) setState(() => _composition = composition);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inner = widget.size - 24;
    final composition = _composition;
    return Container(
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.style.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 16, offset: Offset(0, 4))],
      ),
      child: composition != null
          ? Lottie(composition: composition, width: inner, height: inner)
          : Text(
              widget.emoji,
              textScaler: TextScaler.noScaling,
              style: DefaultEmojiTextStyle.copyWith(fontSize: inner * 0.8, inherit: true),
            ),
    );
  }
}
