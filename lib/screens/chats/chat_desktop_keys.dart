import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../platform.dart';

/// Клавиатура ленты чата на десктопе (§11 docs/plans/desktop-client.md):
/// PageUp/PageDown — страница вверх/вниз, Home/End — к старым / последним
/// сообщениям. Лента перевёрнута (reverse): вверх по экрану — вперёд по
/// offset. Фокус в поле ввода важнее — обёртка стоит выше него, и его
/// шорткаты (DefaultTextEditingShortcuts) перехватывают клавиши раньше.
class ChatDesktopKeys extends StatelessWidget {
  const ChatDesktopKeys({super.key, required this.scroll, required this.child});

  final ScrollController scroll;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!AppPlatform.isDesktop) return child;
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.pageUp): _ScrollIntent(up: true),
        SingleActivator(LogicalKeyboardKey.pageDown): _ScrollIntent(up: false),
        SingleActivator(LogicalKeyboardKey.home): _ScrollIntent(up: true, page: false, home: true),
        SingleActivator(LogicalKeyboardKey.end): _ScrollIntent(up: false, page: false),
      },
      child: Actions(actions: {_ScrollIntent: _ScrollAction(scroll)}, child: child),
    );
  }
}

/// [page] — на страницу, иначе до конца (Home — к старым, End — к последним).
class _ScrollIntent extends Intent {
  const _ScrollIntent({this.up = false, this.page = true, this.home = false});

  final bool up;
  final bool page;
  final bool home;
}

class _ScrollAction extends Action<_ScrollIntent> {
  _ScrollAction(this.scroll);

  final ScrollController scroll;

  @override
  Object? invoke(_ScrollIntent intent) {
    if (!scroll.hasClients) return null;
    final position = scroll.position;
    double target;
    if (intent.page) {
      // Вверх по экрану (к старым) — больше offset; чуть меньше страницы,
      // чтобы последняя строка осталась видна (как в браузере).
      final delta = position.viewportDimension * 0.9;
      target = intent.up ? position.pixels + delta : position.pixels - delta;
    } else {
      target = intent.home ? position.maxScrollExtent : position.minScrollExtent;
    }
    unawaited(
      position.animateTo(
        target.clamp(position.minScrollExtent, position.maxScrollExtent).toDouble(),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
      ),
    );
    return null;
  }
}
