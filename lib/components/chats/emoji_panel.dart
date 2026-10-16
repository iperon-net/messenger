import 'dart:async';
import 'dart:math' as math;

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart' show Material, MaterialType, IconButton, Icons, Icon, TextField, InputDecoration, InputBorder;
import 'package:flutter/widgets.dart';

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

  Widget _picker(BuildContext context, double height) {
    final locale = LocaleSettings.currentLocale.languageCode;
    // Значки групп в полосе — помельче (полоса ниже).
    return IconTheme.merge(
      data: const IconThemeData(size: 21),
      child: EmojiPicker(
        textEditingController: input,
        onBackspacePressed: () => HapticFeedback.selectionClick(),
        config: Config(
          height: height,
          locale: Locale(locale),
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            columns: 8,
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
