import 'dart:io';
import 'dart:math' as math;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show Brightness, CupertinoTheme;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'desktop.dart';
import 'platform.dart';
import 'themes.dart';

/// Двухпанельный режим (iPad, Android-планшет, десктоп, складной iPhone), как в Telegram: в каждой вкладке слева список
/// (чаты, контакты, звонки, разделы настроек) с таб-баром под ним, справа —
/// открытый экран. Включается по типу устройства один раз при старте — от него
/// зависит дерево маршрутов (см. `Routers._common`), — а сколько панелей
/// показать, решает ширина окна: в Slide Over / узком Split View панель одна.
abstract final class SplitLayout {
  /// Устройство поддерживает сплит (iPad, Android-планшет, десктоп, складной
  /// iPhone). Выставляет [detect].
  static bool enabled = false;

  /// Устройство — складной iPhone (iPhone Duo): внешний экран получает
  /// вертикальный рейл вкладок (`HomeCupertino`), внутренний — обычный split.
  /// Выставляет [detect]; на iPad, Android-планшетах и десктопе — false.
  static bool foldableIphone = false;

  /// С какой ширины окна показывать обе панели: iPad mini в портрете (744) —
  /// уже две, половина экрана в Split View (~590–700) — одна. На складном
  /// iPhone [detect] снижает порог до [duoMinWidth].
  static double minWidth = 700.0;

  /// Порог складного iPhone (iPhone Duo): портрет внутреннего экрана — 669 pt,
  /// две панели должны появляться уже там (как у системных Mail/Notes на Duo);
  /// половина side-by-side (~335 pt) — одна.
  static const duoMinWidth = 600.0;

  static Future<void> detect() async {
    try {
      if (Platform.isIOS) {
        if ((await DeviceInfoPlugin().iosInfo).model.toLowerCase().contains('ipad')) {
          enabled = true;
        } else {
          // Складной iPhone (iPhone Duo): оба дисплея tablet-класса по
          // пропорциям (внешний 466×678, внутренний 669×951 pt), у обычных
          // iPhone соотношение сторон ~0.46 в любой ориентации. Брать размер
          // дисплея, не окна: при старте сразу в side-by-side окно уже
          // наполовину. На симуляторе hw.machine — архитектура хоста, поэтому
          // геометрия, а не идентификатор модели.
          final size = _screenPoints();
          if (size != null && isDuoScreenSize(size)) {
            enabled = true;
            foldableIphone = true;
            minWidth = duoMinWidth;
          }
        }
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
      } else if (AppPlatform.isDesktop) {
        // Окно десктопа — как планшет: две панели, когда шире [minWidth].
        enabled = true;
      }
    } catch (_) {
      enabled = false;
    }
  }

  /// Логические точки дисплея (не окна): `display.size`, пока натив не отдал
  /// размер дисплея (-1 до первого кадра, как на Android), — размер окна; при
  /// старте приложение на весь экран. `null` — размер ещё неизвестен.
  static Size? _screenPoints() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final display = view.display;
    if (display.devicePixelRatio > 0 && display.size.shortestSide > 0) {
      return display.size / display.devicePixelRatio;
    }
    if (view.devicePixelRatio > 0 && view.physicalSize.shortestSide > 0) {
      return view.physicalSize / view.devicePixelRatio;
    }
    return null;
  }

  /// Дисплей tablet-класса на iPhone (складной iPhone Duo): короткая сторона
  /// от 460 pt и «квадратные» пропорции ≥ 0.6 — у обычных iPhone ~0.46 в любой
  /// ориентации. iPad отфильтрован раньше, по модели. Совпадает с геометриями
  /// внешнего дисплея Duo в обоих позах (466×678 и 678×466) и не совпадает с
  /// внутренним в side-by-side (~335×951).
  static bool isDuoScreenSize(Size points) => points.shortestSide >= 460 && points.shortestSide / points.longestSide >= 0.6;

  /// Обе панели сейчас на экране. На складном iPhone дополнительно требуем
  /// tablet-класс короткой стороны: у внешнего дисплея в landscape (678×466)
  /// ширины 678 хватает, но по HIG внешний экран всегда компактный — панель
  /// одна (+ рейл), две панели только на внутреннем дисплее (669×951 и
  /// 951×669); в side-by-side (~335×951) панель тоже одна.
  static bool isWide(BuildContext context) {
    if (!enabled) return false;
    final size = MediaQuery.sizeOf(context);
    if (size.width < minWidth) return false;
    return !foldableIphone || size.shortestSide >= duoMinWidth;
  }

  /// Активен ли вертикальный рейл вкладок ([DuoTabRail]) на этом экране:
  /// внешний экран Duo — в обеих позах, внутренний — в landscape (HIG
  /// «controls remain on the side»); внутренний portrait — HIG-исключение,
  /// горизонтальный бар под списком; side-by-side (~335×951) и все прочие
  /// устройства — без рейла. Отсюда же его знает SplitView, чтобы список не
  /// резервировал высоту под нижний бар, когда бар заменён рейлом.
  static bool duoRail(BuildContext context) {
    if (!foldableIphone) return false;
    final media = MediaQuery.of(context);
    final size = media.size;
    if (!isDuoScreenSize(size)) return false;
    // Внутренний экран в portrait: достаточно высоты для горизонтального бара.
    if (isWide(context) && size.width <= size.height) return false;
    return math.max(media.padding.left, media.padding.right) >= duoRailMinInset;
  }

  /// Минимальная ширина системной полосы, при которой рейл вкладок уместен;
  /// при неожиданно узком инсете (safe area не распознал Duo) — обычный бар.
  static const duoRailMinInset = 56.0;

  /// Ширина левой панели (список) при ширине окна [width]: на десктопе — от
  /// [minListWidth] (по умолчанию) до выставленной перетаскиванием разделителя
  /// ([listWidthOverride]), но так, чтобы правой панели осталось не меньше
  /// [minPaneWidth].
  static double listWidth(double width) {
    // Десктоп: по умолчанию — самый узкий список, шире — перетаскиванием.
    if (AppPlatform.isDesktop) {
      final custom = listWidthOverride.value ?? minListWidth;
      return custom.clamp(minListWidth, math.max(minListWidth, math.min(maxListWidth, width - minPaneWidth)));
    }
    return (width * 0.38).clamp(320.0, 400.0);
  }

  /// Ширина списка, выбранная на десктопе; `null` — по умолчанию
  /// ([minListWidth]). Хранится в настройках окна (`Desktop.listWidth`).
  static final listWidthOverride = ValueNotifier<double?>(null);

  static const minListWidth = 396.0;
  static const maxListWidth = 560.0;
  static const minPaneWidth = 380.0;

  /// Сохранённая ширина списка (main.dart, до первого кадра).
  static Future<void> loadListWidth() async {
    if (AppPlatform.isDesktop) listWidthOverride.value = await Desktop.listWidth();
  }

  /// Перетащили разделитель: [width] — новая ширина, `null` — сброс.
  static void setListWidth(double? width) => listWidthOverride.value = width;

  /// Отпустили разделитель — запомнить.
  static void saveListWidth() => Desktop.setListWidth(listWidthOverride.value);

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
