import 'package:cupertino_ui/cupertino_ui.dart';

class ThemesCupertino {
  /// Фон сгруппированных экранов (настройки, чаты). В светлой теме совпадает с
  /// системным `systemGroupedBackground`, в тёмной вместо чёрного использует
  /// фирменный `#1b263b`.
  static const CupertinoDynamicColor groupedBackground = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF2F2F7),
    darkColor: Color(0xFF1B263B),
  );

  /// Фон карточек сгруппированных секций (`CupertinoListSection`/`FormSection`).
  /// В светлой теме — белый (как системный `secondarySystemGroupedBackground`),
  /// в тёмной — оттенок светлее фона `groupedBackground`, чтобы карточки читались.
  static const CupertinoDynamicColor groupedCard = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF27364D),
  );

  /// Фон нижнего таб-бара. В тёмной теме — темнее фона экранов
  /// (`groupedBackground`), чтобы меню визуально отделялось от контента.
  /// Альфа < 255 включает эффект размытия (blur) под баром.
  static const CupertinoDynamicColor tabBarBackground = CupertinoDynamicColor.withBrightness(
    color: Color(0xE6F9F9F9),
    darkColor: Color(0xE612192A),
  );

  CupertinoDynamicColor get blueScheme => const CupertinoDynamicColor.withBrightnessAndContrast(
    debugLabel: 'blue',
    color: Color.fromARGB(255, 56, 96, 143),
    darkColor: Color.fromARGB(255, 56, 96, 143),
    highContrastColor: Color.fromARGB(255, 0, 64, 221),
    darkHighContrastColor: Color.fromARGB(255, 64, 156, 255),
  );

  CupertinoDynamicColor get green => const CupertinoDynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemGreen',
    color: Color.fromARGB(255, 36, 138, 61),
    darkColor: Color.fromARGB(255, 36, 138, 69),
    highContrastColor: Color.fromARGB(255, 36, 138, 61),
    darkHighContrastColor: Color.fromARGB(255, 48, 219, 91),
  );
}
