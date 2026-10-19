import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/rendering.dart';

import '../../components/chats/message_double_tap.dart';

/// Пузырь сообщения с `CupertinoContextMenu`. Превью открытого меню —
/// тот же пузырь той же ширины, что в ленте (ширину запоминаем при раскладке),
/// ужатый под выданный меню прямоугольник.
class MessageContextMenuCupertino extends StatefulWidget {
  final List<Widget> actions;
  final Widget bubble;
  final Widget Function(double maxWidth) preview;

  const MessageContextMenuCupertino({super.key, required this.actions, required this.bubble, required this.preview});

  @override
  State<MessageContextMenuCupertino> createState() => MessageContextMenuCupertinoCupertinoState();
}

class MessageContextMenuCupertinoCupertinoState extends State<MessageContextMenuCupertino> {
  double? _width;

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
        final width = _width;
        if (animation.value < CupertinoContextMenu.animationOpensAt || width == null) {
          // Пока меню закрывается, пузырь зажат в свой прежний размер; если за
          // это время он вырос (поставили реакцию из меню — добавилась строка
          // реакций), без OverflowBox — «RenderFlex overflowed». В ленте
          // (высота не ограничена) размер — по пузырю.
          return _SizeReporter(
            onSize: (size) => _width = size.width,
            child: ClipRect(
              child: OverflowBox(
                minHeight: 0,
                maxHeight: double.infinity,
                alignment: Alignment.topCenter,
                fit: OverflowBoxFit.deferToChild,
                child: MessageMenuPress(cancel: _cancelPress, child: widget.bubble),
              ),
            ),
          );
        }
        return FittedBox(fit: BoxFit.scaleDown, child: widget.preview(width));
      },
    );
  }
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
