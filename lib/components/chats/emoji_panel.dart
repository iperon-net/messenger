import 'dart:async';
import 'dart:math' as math;

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../i18n/translations.g.dart';

/// Панель эмодзи вместо клавиатуры (как в Telegram): кнопка в поле ввода
/// переключает клавиатуру ↔ панель. Высота панели — последней высоты
/// клавиатуры, а пока клавиатура уезжает / выезжает, панель занимает только
/// остаток — поле ввода не прыгает.
class EmojiPanelController extends ChangeNotifier with WidgetsBindingObserver {
  EmojiPanelController({required this.focus}) {
    focus.addListener(_onFocus);
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

  /// Переход панель → клавиатура: место держим, пока клавиатура не выехала.
  bool _toKeyboard = false;
  Timer? _toKeyboardTimeout;

  /// Сколько сейчас занимает клавиатура (сырые insets окна: Scaffold прячет их от тела).
  double get _keyboard {
    final view = WidgetsBinding.instance.platformDispatcher.implicitView;
    if (view == null) return 0;
    return view.viewInsets.bottom / view.devicePixelRatio;
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
    if (keyboard > 150) _height = keyboard;
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// Цвета панели под платформу (Cupertino / Material).
class EmojiPanelStyle {
  final Color background;
  final Color icon;
  final Color accent;
  final bool cupertino;

  const EmojiPanelStyle({required this.background, required this.icon, required this.accent, required this.cupertino});
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
          child: SizedBox(height: height, child: controller.open ? _picker(context, controller.height) : null),
        );
      },
    );
  }

  Widget _picker(BuildContext context, double height) {
    final locale = LocaleSettings.currentLocale.languageCode;
    return EmojiPicker(
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
        ),
        searchViewConfig: SearchViewConfig(
          backgroundColor: style.background,
          buttonIconColor: style.icon,
          hintText: context.t.screenChat.emojiSearch,
        ),
      ),
    );
  }
}
