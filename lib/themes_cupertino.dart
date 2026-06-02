import 'package:flutter/cupertino.dart';

class ThemesCupertino {

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
