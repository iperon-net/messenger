import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show Brightness, CupertinoTheme;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'themes.dart';

/// Двухпанельный режим (iPad, Android-планшет), как в Telegram: в каждой вкладке слева список
/// (чаты, контакты, звонки, разделы настроек) с таб-баром под ним, справа —
/// открытый экран. Включается по типу устройства один раз при старте — от него
/// зависит дерево маршрутов (см. `Routers._common`), — а сколько панелей
/// показать, решает ширина окна: в Slide Over / узком Split View панель одна.
abstract final class SplitLayout {
  /// Устройство поддерживает сплит (iPad, Android-планшет). Выставляет [detect].
  static bool enabled = false;

  /// С какой ширины окна показывать обе панели: iPad mini в портрете (744) —
  /// уже две, половина экрана в Split View (~590–700) — одна.
  static const minWidth = 700.0;

  static Future<void> detect() async {
    try {
      if (Platform.isIOS) {
        enabled = (await DeviceInfoPlugin().iosInfo).model.toLowerCase().contains('ipad');
      } else if (Platform.isAndroid) {
        // Планшет — меньшая сторона экрана от 600dp (как sw600dp в Android).
        final view = WidgetsBinding.instance.platformDispatcher.views.first;
        final display = view.display;
        // Размер экрана Android отдаёт не всегда (-1 до первого кадра) — тогда
        // размер окна: при старте приложение на весь экран.
        final size = display.devicePixelRatio > 0 && display.size.shortestSide > 0
            ? display.size / display.devicePixelRatio
            : view.physicalSize / view.devicePixelRatio;
        enabled = size.shortestSide >= 600;
      }
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

  /// Высота панели вкладок `HomeMaterial` (NavigationBar по умолчанию).
  static const navigationBarHeightMaterial = 80.0;
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

/// Фон строки, открытой в правой панели (iPad): не серый, как у нажатой, а
/// цвета темы, как в Telegram. В светлой — акцент, приглушённый поверх [base]
/// (фона списка); в тёмной — насыщенный тон исходящих пузырей
/// (`primaryContainer`), на нём белый текст читается.
Color splitSelectedColor(BuildContext context, Color base) {
  if (CupertinoTheme.brightnessOf(context) == Brightness.dark) return ThemesCupertino.chatOutgoing(context);
  return Color.alphaBlend(CupertinoTheme.of(context).primaryColor.withValues(alpha: 0.14), base);
}

/// Фон строки списка [id], если она открыта в правой панели (iPad), иначе null.
Color? splitSelectedBackground(BuildContext context, String id, {required Color base}) =>
    id.isNotEmpty && SplitSelection.of(context) == id ? splitSelectedColor(context, base) : null;
