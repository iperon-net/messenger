import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

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

  /// Фон экрана блокировки (`ScreenLock`): в светлой теме — системный
  /// `systemGroupedBackground`, в тёмной — фирменный `scaffoldBackgroundColor`.
  static Color screenLockBackground(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    return isDark
        ? Color.lerp(
            CupertinoDynamicColor.resolve(CupertinoTheme.of(context).primaryColor, context),
            CupertinoColors.darkBackgroundGray,
            0.5,
          )!
        : Color.lerp(
            CupertinoDynamicColor.resolve(CupertinoTheme.of(context).primaryColor, context),
            CupertinoColors.darkBackgroundGray,
            0.5,
          )!;
  }

  /// Общая конфигурация клавиатуры `ScreenLock`: фон кнопок — тот же
  /// `scaffoldBackgroundColor`, но чуть другим оттенком (светлее фона в тёмной
  /// теме, темнее — в светлой), цифры окрашены в `primaryColor` темы.
  static KeyPadConfig screenLockKeyPad(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    // final scaffoldColor = CupertinoDynamicColor.resolve(CupertinoTheme.of(context).scaffoldBackgroundColor, context);
    // final keyPadColor = Color.lerp(scaffoldColor, isDark ? CupertinoColors.extraLightBackgroundGray : CupertinoColors.black, 0.6)!;

    return KeyPadConfig(
      buttonConfig: KeyPadButtonConfig(
        buttonStyle: ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(color: CupertinoDynamicColor.resolve(CupertinoTheme.of(context).primaryColor, context), width: 0.5),
          ),
          shape: const WidgetStatePropertyAll(CircleBorder()),
        ),
        backgroundColor: isDark
            ? CupertinoTheme.of(context).primaryColor.withAlpha(40)
            : CupertinoTheme.of(context).primaryColor.withAlpha(40),
      ),
      // buttonConfig: KeyPadButtonConfig(backgroundColor: keyPadColor, foregroundColor: CupertinoTheme.of(context).primaryColor),
    );
  }

  /// Цвет иконки/цифр `ScreenLock` (например, иконки биометрии): в светлой теме —
  /// `primaryColor`, в тёмной — `systemGroupedBackground`.
  static Color screenLockForeground(BuildContext context) => CupertinoDynamicColor.withBrightness(
    color: CupertinoTheme.of(context).primaryColor,
    darkColor: CupertinoColors.systemGroupedBackground,
  ).resolveFrom(context);

  /// Полная конфигурация `ScreenLockConfig` с общим фоном.
  static ScreenLockConfig screenLockConfig(BuildContext context) =>
      ScreenLockConfig.defaultConfig.copyWith(backgroundColor: screenLockBackground(context));
}
