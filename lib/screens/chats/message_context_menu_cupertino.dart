import 'dart:math' as math;

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/rendering.dart';

import '../../components/chats/message_double_tap.dart';

/// Пузырь сообщения с `CupertinoContextMenu`. Превью открытого меню —
/// тот же пузырь той же ширины, что в ленте (ширину запоминаем при раскладке),
/// ужатый под выданный меню прямоугольник. Длинное сообщение в превью не
/// ужимается по высоте (меню отдаёт превью почти весь экран — текст мельчал и
/// «уезжал», а действия сжимались), а обрезается снизу, чтобы под ним
/// поместились действия, — как в Telegram.
class MessageContextMenuCupertino extends StatefulWidget {
  final List<Widget> actions;
  final Widget bubble;
  final Widget Function(double maxWidth) preview;

  const MessageContextMenuCupertino({super.key, required this.actions, required this.bubble, required this.preview});

  @override
  State<MessageContextMenuCupertino> createState() => MessageContextMenuCupertinoCupertinoState();
}

class MessageContextMenuCupertinoCupertinoState extends State<MessageContextMenuCupertino> {
  /// Размер пузыря в ленте (в покое): по нему — раскладка «приподнятого»
  /// пузыря и превью меню.
  Size? _size;

  /// Анимация «нажатия» меню (до открытия — его `AnimationController`).
  AnimationController? _press;

  /// Отпустили, не дождавшись меню (обычный тап, первый из двойного), —
  /// сразу на место. Меню на касании прячет пузырь в ленте и поднимает его
  /// копию в оверлей, а на отпускании плавно откатывает: пузырь мигал бы на
  /// каждом тапе (и на двойном — до реакции).
  void _onPressStatus(AnimationStatus status) {
    if (status == AnimationStatus.reverse) _press?.reset();
  }

  /// Двойной тап (реакция), а «нажатие» уже началось — тоже на место.
  void _cancelPress() {
    if (_press case final press? when press.value > 0 && press.value < CupertinoContextMenu.animationOpensAt) {
      press.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu.builder(
      enableHapticFeedback: true,
      actions: widget.actions,
      builder: (context, animation) {
        if (animation is AnimationController && !identical(animation, _press)) {
          _press = animation..addStatusListener(_onPressStatus);
        }
        final size = _size;
        if (animation.value < CupertinoContextMenu.animationOpensAt || size == null) {
          // Пока меню закрывается, пузырь зажат в свой прежний размер; если за
          // это время он вырос (поставили реакцию из меню — добавилась строка
          // реакций), без OverflowBox — «RenderFlex overflowed». В ленте
          // (высота не ограничена) размер — по пузырю.
          // «Нажатие»: меню растягивает прямоугольник пузыря (×1,02–1,15) и
          // раскладывает его заново — длинный текст переносился бы по-другому
          // и «ездил». Поэтому раскладка — по прежней ширине, а растягивается
          // картинка (Transform). Дерево одно и то же в покое и при нажатии —
          // состояние пузыря (двойной тап) не пересоздаётся. Размер — только в
          // покое: растянутый исказил бы и ширину превью меню.
          final pressed = animation.value > 0;
          return _SizeReporter(
            onSize: (value) {
              if (!pressed) _size = value;
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Копия в оверлее — в точном прямоугольнике меню; в ленте ширина
                // свободная — там как в покое.
                final lifted = pressed && size != null && constraints.hasTightWidth && size.width > 0;
                return ClipRect(
                  child: Transform.scale(
                    scale: lifted ? constraints.maxWidth / size.width : 1,
                    alignment: Alignment.topCenter,
                    child: OverflowBox(
                      minWidth: lifted ? size.width : null,
                      maxWidth: lifted ? size.width : null,
                      minHeight: 0,
                      maxHeight: double.infinity,
                      alignment: Alignment.topCenter,
                      fit: OverflowBoxFit.deferToChild,
                      child: MessageMenuPress(cancel: _cancelPress, child: widget.bubble),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: _maxPreviewHeight(context, widget.actions.length)),
            child: ClipRect(
              child: OverflowBox(
                minHeight: 0,
                maxHeight: double.infinity,
                alignment: Alignment.topCenter,
                fit: OverflowBoxFit.deferToChild,
                child: widget.preview(size.width),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Высота экрана без безопасных зон, отступов меню (сверху, между превью и
/// действиями, снизу — по 20) и самих действий (43 на строку, как у
/// `CupertinoContextMenuAction`).
double _maxPreviewHeight(BuildContext context, int actions) {
  final media = MediaQuery.of(context);
  return math.max(120.0, media.size.height - media.padding.vertical - 3 * 20 - actions * 44);
}

/// Сообщает размер ребёнка после каждой раскладки (без GlobalKey: превью
/// меню строится одновременно в ленте и в оверлее).
class _SizeReporter extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onSize;

  const _SizeReporter({required this.onSize, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSizeReporter(onSize);

  @override
  void updateRenderObject(BuildContext context, _RenderSizeReporter renderObject) => renderObject.onSize = onSize;
}

class _RenderSizeReporter extends RenderProxyBox {
  ValueChanged<Size> onSize;

  _RenderSizeReporter(this.onSize);

  @override
  void performLayout() {
    super.performLayout();
    onSize(size);
  }
}
