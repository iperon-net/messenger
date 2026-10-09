import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/rendering.dart';

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

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu.builder(
      enableHapticFeedback: true,
      actions: widget.actions,
      builder: (context, animation) {
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
                child: widget.bubble,
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
