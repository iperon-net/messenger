import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;

/// Короткое уведомление «сделано» (например, «Сохранено в Избранном»): на iOS
/// — плашка под шапкой, сама исчезает через 2 с (тап — сразу); на Android —
/// SnackBar. [overlay] — плашка и на Android: экран без Scaffold (просмотр
/// медиа), где SnackBar не видно.
void showChatToast(BuildContext context, String text, {bool overlay = false}) {
  if (!Platform.isIOS && !overlay) {
    m.ScaffoldMessenger.maybeOf(context)?.showSnackBar(m.SnackBar(content: Text(text)));
    return;
  }
  final root = Overlay.maybeOf(context, rootOverlay: true);
  if (root == null) return;
  late final OverlayEntry entry;
  var removed = false;
  void remove() {
    if (removed) return;
    removed = true;
    entry.remove();
  }

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.paddingOf(context).top + 52,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: remove,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 200),
          builder: (context, value, child) => Opacity(opacity: value, child: child),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: const Color(0xE6303030), borderRadius: BorderRadius.circular(12)),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 15, decoration: TextDecoration.none),
            ),
          ),
        ),
      ),
    ),
  );
  root.insert(entry);
  Timer(const Duration(seconds: 2), remove);
}
