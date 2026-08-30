import 'package:material_ui/material_ui.dart';

import '../models.dart';

/// Material-темы приложения (Android). Собираются из выбранного пользователем
/// [ColorThemeModel] через `ColorScheme.fromSeed`, аналогично тому, как
/// [ThemesCupertino] задаёт `primaryColor`. Значения seed-цветов подобраны в
/// тон Cupertino-палитре, чтобы обе платформы выглядели как одно приложение.
class ThemesMaterial {
  /// Seed-цвет для каждой цветовой темы. Совпадает с базовыми цветами
  /// [ThemesCupertino] (blue `#38608F`, green, orange) плюс системный фиолетовый.
  static Color seed(ColorThemeModel colorTheme) {
    switch (colorTheme) {
      case ColorThemeModel.green:
        return const Color.fromARGB(255, 36, 138, 61);
      case ColorThemeModel.purple:
        return const Color.fromARGB(255, 175, 82, 222);
      case ColorThemeModel.orange:
        return const Color.fromARGB(255, 204, 120, 0);
      case ColorThemeModel.blue:
        return const Color.fromARGB(255, 56, 96, 143);
    }
  }

  // Палитра поверхностей перенесена 1:1 из [ThemesCupertino], чтобы Android
  // выглядел так же, как iOS. По умолчанию `ColorScheme.fromSeed` в тёмной теме
  // даёт почти чёрные, слегка тонированные seed-цветом поверхности — здесь они
  // заменяются фирменными сине-графитовыми тонами.

  /// Фон сгруппированных экранов (страница, на которой «плавают» карточки).
  /// Cupertino `groupedBackground`: светлая `#F2F2F7`, тёмная `#1B263B`.
  static const Color _groupedBackgroundLight = Color(0xFFF2F2F7);
  static const Color _groupedBackgroundDark = Color(0xFF1B263B);

  /// Фон карточек секций (`Card`/`_group`). Cupertino `groupedCard`:
  /// светлая — белый, тёмная — оттенок светлее фона, чтобы карточки читались.
  static const Color _cardLight = Color(0xFFFFFFFF);
  static const Color _cardDark = Color(0xFF27364D);

  /// Фон нижнего нав-бара. Cupertino `tabBarBackground` (без альфа-блюра):
  /// светлая `#F9F9F9`, тёмная `#12192A` — темнее фона экранов, чтобы меню
  /// визуально отделялось от контента.
  static const Color _navBarLight = Color(0xFFF9F9F9);
  static const Color _navBarDark = Color(0xFF12192A);

  ThemeData theme({required ColorThemeModel colorTheme, required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final grouped = isDark ? _groupedBackgroundDark : _groupedBackgroundLight;
    final card = isDark ? _cardDark : _cardLight;
    final navBar = isDark ? _navBarDark : _navBarLight;

    // Базовую схему по-прежнему генерируем из seed (даёт согласованные
    // primary/secondary/error и правильные `on*`-цвета текста под яркость),
    // но все surface-токены заменяем на фирменную двухтоновую палитру:
    //   • `surface*` варианты-контейнеры → фон страницы (`grouped`);
    //   • `surface`/`surfaceBright`/`surfaceContainerLowest` → карточки (`card`).
    // Экраны берут фон по-разному (`surfaceContainer`, `surfaceContainerLow`,
    // `surfaceDim`), поэтому все «контейнерные» тона указывают на один `grouped`.
    final colorScheme = ColorScheme.fromSeed(seedColor: seed(colorTheme), brightness: brightness).copyWith(
      surface: card,
      surfaceBright: card,
      surfaceContainerLowest: card,
      surfaceContainerLow: grouped,
      surfaceContainer: grouped,
      surfaceContainerHigh: grouped,
      surfaceContainerHighest: grouped,
      surfaceDim: grouped,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: grouped,
      // Нижний нав-бар (`HomeMaterial`) — отдельный, более тёмный тон таб-бара.
      // Плоский, без тонирования по elevation, как бар Cupertino.
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: navBar,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colorScheme.primary.withAlpha(40),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        // `onSurface` инвертируется под brightness: тёмный текст в светлой теме,
        // светлый — в тёмной. `scrim` был всегда чёрным → невидим в тёмной теме.
        titleTextStyle: TextStyle(fontSize: 14, color: colorScheme.onSurface),
        // Компактные плитки настроек: меньше вертикальные отступы → ниже боксы.
        minVerticalPadding: 10,
      ),
      // AppBar — в тон карточек (`card`), плоский: без тонирования по elevation
      // при скролле, как навбар Cupertino.
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(fontSize: 18, color: colorScheme.onSurface),
        centerTitle: true,
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      // Форма скруглённых групп-«карточек» (см. `_group` на экранах настроек).
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      radioTheme: RadioThemeData(visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: colorScheme.primary,
          disabledForegroundColor: Colors.white,
          disabledBackgroundColor: colorScheme.primary,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: colorScheme.primary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: colorScheme.primary),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        labelStyle: TextStyle(color: colorScheme.primary),
        // isDense: true,
        contentPadding: EdgeInsets.all(12),
      ),
    );
  }
}
