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

  ThemeData theme({required ColorThemeModel colorTheme, required Brightness brightness}) {
    final colorScheme = ColorScheme.fromSeed(seedColor: seed(colorTheme), brightness: brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      listTileTheme: ListTileThemeData(iconColor: colorScheme.primary),
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
