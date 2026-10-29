import 'package:material_ui/material_ui.dart';

import 'emoji_panel.dart';

/// Эмодзи на десктопе (как в Telegram Desktop): кнопка справа в поле ввода
/// открывает окошко над ней, у правого края; лента и поле ввода не сдвигаются,
/// фокус остаётся в поле — эмодзи встаёт у курсора, можно сразу печатать
/// дальше. Закрывается кнопкой, кликом мимо и Esc ([controller] —
/// `ComposeDesktopKeys.onEscape` в чате).
class DesktopEmojiButton extends StatefulWidget {
  final OverlayPortalController controller;
  final TextEditingController input;
  final EmojiPanelStyle style;
  final String tooltip;

  const DesktopEmojiButton({super.key, required this.controller, required this.input, required this.style, required this.tooltip});

  static const _width = 352.0;
  static const _height = 380.0;

  @override
  State<DesktopEmojiButton> createState() => _DesktopEmojiButtonState();
}

class _DesktopEmojiButtonState extends State<DesktopEmojiButton> {
  final _link = LayerLink();

  /// Кнопка и окошко — одна область: клик по кнопке не считается «мимо».
  final _region = Object();

  /// Курсор до нажатия: кнопка стоит в самом поле, и клик по ней переносит
  /// курсор к краю поля — возвращаем прежний.
  TextSelection? _selection;

  void _toggle() {
    final selection = _selection;
    if (selection != null && selection.isValid) widget.input.selection = selection;
    if (widget.controller.isShowing) {
      widget.controller.hide();
    } else {
      widget.controller.show();
    }
    setState(() {});
  }

  void _hide() {
    if (!widget.controller.isShowing) return;
    widget.controller.hide();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final open = widget.controller.isShowing;
    return TapRegion(
      groupId: _region,
      onTapOutside: (_) => _hide(),
      child: CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
          controller: widget.controller,
          overlayChildBuilder: (context) => CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.topRight,
            followerAnchor: Alignment.bottomRight,
            offset: const Offset(8, -14),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TapRegion(
                groupId: _region,
                // Клики по окошку — «внутри поля»: иначе поле ввода теряет
                // фокус при каждом выборе эмодзи.
                child: TextFieldTapRegion(
                  child: _Popup(input: widget.input, style: widget.style),
                ),
              ),
            ),
          ),
          child: Listener(
            onPointerDown: (_) => _selection = widget.input.selection,
            child: IconButton(
              icon: Icon(open ? Icons.emoji_emotions : Icons.emoji_emotions_outlined),
              color: open ? widget.style.accent : widget.style.icon,
              tooltip: widget.tooltip,
              onPressed: _toggle,
            ),
          ),
        ),
      ),
    );
  }
}

class _Popup extends StatelessWidget {
  final TextEditingController input;
  final EmojiPanelStyle style;

  const _Popup({required this.input, required this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(12);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.45 : 0.14),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: style.background,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: dark ? 0.5 : 0.7), width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: DesktopEmojiButton._width,
          height: DesktopEmojiButton._height,
          // Окошко не у низа экрана — отступ «над полоской домой» не нужен.
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: emojiPickerView(context, input: input, style: style, height: DesktopEmojiButton._height, columns: 8),
          ),
        ),
      ),
    );
  }
}
