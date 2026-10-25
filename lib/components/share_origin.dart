import 'package:flutter/widgets.dart';

/// Откуда на iPad раскрывать popover «Поделиться» (`sharePositionOrigin`):
/// без него share_plus на iPad падает, на iPhone / Android значение не
/// используется. Рамка виджета [context] (кнопки); если его нет или он
/// занимает почти весь экран (контекст экрана, а не кнопки) — точка в центре.
Rect shareOrigin([BuildContext? context]) {
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final screen = view.physicalSize / view.devicePixelRatio;
  final box = context != null && context.mounted ? context.findRenderObject() : null;
  if (box is RenderBox && box.attached && box.hasSize) {
    final rect = box.localToGlobal(Offset.zero) & box.size;
    if (rect.width < screen.width / 2 || rect.height < screen.height / 2) return rect;
    return Rect.fromCenter(center: rect.center, width: 1, height: 1);
  }
  return Rect.fromCenter(center: screen.center(Offset.zero), width: 1, height: 1);
}
