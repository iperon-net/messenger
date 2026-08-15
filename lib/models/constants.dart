import 'package:dart_mappable/dart_mappable.dart';

part 'constants.mapper.dart';

@MappableEnum()
enum ColorThemeModel { blue, green, purple, red }

@MappableEnum()
enum DarkModeModel { system, disabled, alwaysOn }
