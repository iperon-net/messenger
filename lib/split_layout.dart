import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Двухпанельный режим (iPad): список чатов слева, открытый чат справа, как в
/// Telegram. Включается по типу устройства один раз при старте — от него
/// зависит дерево маршрутов (см. `Routers._chatsCupertino`), — а сколько панелей
/// показать, решает ширина окна: в Slide Over / узком Split View панель одна.
abstract final class SplitLayout {
  /// Устройство поддерживает сплит (iPad). Выставляет [detect].
  static bool enabled = false;

  /// С какой ширины окна показывать обе панели: iPad mini в портрете (744) —
  /// уже две, половина экрана в Split View (~590–700) — одна.
  static const minWidth = 700.0;

  static Future<void> detect() async {
    if (!Platform.isIOS) return;
    try {
      enabled = (await DeviceInfoPlugin().iosInfo).model.toLowerCase().contains('ipad');
    } catch (_) {
      enabled = false;
    }
  }

  /// Обе панели сейчас на экране.
  static bool isWide(BuildContext context) => enabled && MediaQuery.sizeOf(context).width >= minWidth;

  /// Ширина левой панели (список) при ширине окна [width].
  static double listWidth(double width) => (width * 0.38).clamp(320.0, 400.0);
}

/// Какой чат открыт в правой панели — чтобы список подсветил его строку.
/// Ставит `ChatsSplitCupertino` только на широком окне.
class SplitSelection extends InheritedWidget {
  /// id чата (как `models.Chat.id`); пусто — ничего не открыто.
  final String chatID;

  const SplitSelection({super.key, required this.chatID, required super.child});

  static String of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<SplitSelection>()?.chatID ?? '';

  @override
  bool updateShouldNotify(SplitSelection oldWidget) => chatID != oldWidget.chatID;
}

/// Открыть экран из списка чатов: на широком окне — в правой панели ВМЕСТО
/// открытого (`go`, как выбор строки в Telegram на iPad: стопка панели не
/// копится), иначе — поверх списка, как раньше.
Future<void> openFromList(BuildContext context, String route) async {
  if (SplitLayout.isWide(context)) return context.go(route);
  await context.push(route);
}

extension SplitLayoutPane on BuildContext {
  /// Экран — корень правой панели (сразу над «Выберите чат»): кнопка «назад»
  /// ему не нужна, список и так слева. На узком окне — false (панель одна).
  bool get isSplitPaneRoot {
    if (!SplitLayout.isWide(this)) return false;
    final settings = ModalRoute.of(this)?.settings;
    final pages = Navigator.maybeOf(this)?.widget.pages;
    return settings is Page && pages != null && pages.indexOf(settings) == 1;
  }
}

/// Открыть чат (экран правой панели) не из списка: из профиля, «Контактов»,
/// пересылки, ссылки. На iPad такие экраны живут в навигаторе вкладки «Чаты»,
/// и `push` из другой вкладки или полноэкранного профиля положил бы чат туда
/// невидимо, — поэтому `go`: вкладка «Чаты», чат в правой панели вместо
/// открытого. Изнутри «Чатов» на узком окне — `push`, как на iPhone.
Future<void> openChat(BuildContext context, String route) async {
  if (SplitLayout.enabled) {
    final location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
    final inChats = location == '/chats' || location.startsWith('/chats/');
    if (!inChats || SplitLayout.isWide(context)) return context.go(route);
  }
  await context.push(route);
}
