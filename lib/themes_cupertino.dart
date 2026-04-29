import 'package:flutter/cupertino.dart';

class ThemesCupertino {

  CupertinoDynamicColor get blueScheme => const CupertinoDynamicColor.withBrightnessAndContrast(
    debugLabel: 'blue',
    color: Color.fromARGB(255, 56, 96, 143),
    darkColor: Color.fromARGB(255, 56, 96, 143),
    highContrastColor: Color.fromARGB(255, 0, 64, 221),
    darkHighContrastColor: Color.fromARGB(255, 64, 156, 255),
  );

}
