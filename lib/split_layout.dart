import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoDynamicColor;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Двухпанельный режим (iPad), как в Telegram: в каждой вкладке слева список
/// (чаты, контакты, звонки, разделы настроек) с таб-баром под ним, справа —
/// открытый экран. Включается по типу устройства один раз при старте — от него
/// зависит дерево маршрутов (см. `Routers._common`), — а сколько панелей
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

  /// Высота таб-бара (`HomeCupertino`); на широком окне он только под списком.
  static const tabBarHeight = 58.0;
}

/// Что открыто в правой панели — чтобы список подсветил свою строку: id чата
/// (как `models.Chat.id`), userID контакта / звонка (hex), раздел настроек.
/// Ставит `SplitViewCupertino` только на широком окне; пусто — ничего.
class SplitSelection extends InheritedWidget {
  final String id;

  const SplitSelection({super.key, required this.id, required super.child});

  static String of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<SplitSelection>()?.id ?? '';

  @override
  bool updateShouldNotify(SplitSelection oldWidget) => id != oldWidget.id;
}

/// Открыть экран из списка (чатов, контактов, звонков): на широком окне — в правой панели ВМЕСТО
/// открытого (`go`, как выбор строки в Telegram на iPad: стопка панели не
/// копится), иначе — поверх списка, как раньше.
Future<void> openFromList(BuildContext context, String route) async {
  if (SplitLayout.isWide(context)) return context.go(route);
  await context.push(route);
}

extension SplitLayoutPane on BuildContext {
  /// Экран — корень правой панели (сразу над заглушкой «Выберите …»): кнопка «назад»
  /// ему не нужна, список и так слева. На узком окне — false (панель одна).
  bool get isSplitPaneRoot {
    // Только навигатор правой панели: у корневого (полноэкранный `/profile`)
    // страницы тоже идут [вкладки, экран], но это не панель.
    if (!SplitLayout.isWide(this) || getInheritedWidgetOfExactType<SplitPaneScope>() == null) return false;
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

/// Метка правой панели (её навигатора) для [SplitLayoutPane.isSplitPaneRoot].
class SplitPaneScope extends InheritedWidget {
  const SplitPaneScope({super.key, required super.child});

  @override
  bool updateShouldNotify(SplitPaneScope oldWidget) => false;
}

/// Путь профиля человека: на iPad — `/<вкладка>/user/<hex>` в правой панели
/// текущей вкладки (полноэкранный `/profile` закрыл бы обе панели), иначе —
/// `/profile/<hex>`.
String profileRoute(BuildContext context, String userIDHex) {
  if (SplitLayout.enabled) {
    final segments = GoRouter.of(context).routerDelegate.currentConfiguration.uri.pathSegments;
    final tab = segments.isEmpty ? '' : segments.first;
    if (const {'chats', 'contacts', 'calls', 'settings'}.contains(tab)) return '/$tab/user/$userIDHex';
  }
  return '/profile/$userIDHex';
}

/// Открыть профиль человека из списка вкладки (контакты, звонки): на iPad — в
/// правой панели вместо открытого (см. [openFromList]).
Future<void> openProfileFromList(BuildContext context, String userIDHex) async {
  if (SplitLayout.enabled) return openFromList(context, profileRoute(context, userIDHex));
  await context.push('/profile/$userIDHex');
}

/// Фон строки списка, открытой в правой панели (iPad), — как у нажатой.
Color? splitSelectedBackground(BuildContext context, String id) => id.isNotEmpty && SplitSelection.of(context) == id
    ? const CupertinoDynamicColor.withBrightness(color: Color(0xFFE5E5EA), darkColor: Color(0xFF2C2C2E)).resolveFrom(context)
    : null;
