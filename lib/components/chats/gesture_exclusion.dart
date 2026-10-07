import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const _channel = MethodChannel('net.iperon.messenger/system_gestures');

/// Отключает системный жест «назад» от края экрана над [child] (Android 10+):
/// иначе протяжка ползунка у края, например обрезка в редакторе видео,
/// закрывает экран вместо перетаскивания. Android даёт исключить не больше
/// 200 dp по высоте на каждый край — оборачивать только узкие полосы. На iOS
/// ничего не делает.
class SystemGestureExclusion extends StatefulWidget {
  final Widget child;

  const SystemGestureExclusion({super.key, required this.child});

  @override
  State<SystemGestureExclusion> createState() => _SystemGestureExclusionState();
}

class _SystemGestureExclusionState extends State<SystemGestureExclusion> {
  Rect? _sent;

  @override
  void dispose() {
    if (_sent != null) _send(const []);
    super.dispose();
  }

  static void _send(List<double> values) {
    _channel.invokeMethod<void>('setExclusionRects', values).catchError((_) {});
  }

  // После каждой раскладки: положение могло сдвинуться (поворот, клавиатура).
  void _update() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    if (rect == _sent) return;
    _sent = rect;
    _send([rect.left, rect.top, rect.right, rect.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) return widget.child;
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
    return widget.child;
  }
}
