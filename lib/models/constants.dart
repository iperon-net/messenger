import 'package:dart_mappable/dart_mappable.dart';

part 'constants.mapper.dart';

@MappableEnum()
enum ColorThemeModel { blue, green, purple, orange }

@MappableEnum()
enum DarkModeModel { system, disabled, alwaysOn }
