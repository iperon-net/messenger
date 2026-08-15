// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'constants.dart';

class ColorThemeModelMapper extends EnumMapper<ColorThemeModel> {
  ColorThemeModelMapper._();

  static ColorThemeModelMapper? _instance;
  static ColorThemeModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ColorThemeModelMapper._());
    }
    return _instance!;
  }

  static ColorThemeModel fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ColorThemeModel decode(dynamic value) {
    switch (value) {
      case r'blue':
        return ColorThemeModel.blue;
      case r'green':
        return ColorThemeModel.green;
      case r'purple':
        return ColorThemeModel.purple;
      case r'red':
        return ColorThemeModel.red;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ColorThemeModel self) {
    switch (self) {
      case ColorThemeModel.blue:
        return r'blue';
      case ColorThemeModel.green:
        return r'green';
      case ColorThemeModel.purple:
        return r'purple';
      case ColorThemeModel.red:
        return r'red';
    }
  }
}

extension ColorThemeModelMapperExtension on ColorThemeModel {
  String toValue() {
    ColorThemeModelMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ColorThemeModel>(this) as String;
  }
}

class DarkModeModelMapper extends EnumMapper<DarkModeModel> {
  DarkModeModelMapper._();

  static DarkModeModelMapper? _instance;
  static DarkModeModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DarkModeModelMapper._());
    }
    return _instance!;
  }

  static DarkModeModel fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  DarkModeModel decode(dynamic value) {
    switch (value) {
      case r'system':
        return DarkModeModel.system;
      case r'disabled':
        return DarkModeModel.disabled;
      case r'alwaysOn':
        return DarkModeModel.alwaysOn;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(DarkModeModel self) {
    switch (self) {
      case DarkModeModel.system:
        return r'system';
      case DarkModeModel.disabled:
        return r'disabled';
      case DarkModeModel.alwaysOn:
        return r'alwaysOn';
    }
  }
}

extension DarkModeModelMapperExtension on DarkModeModel {
  String toValue() {
    DarkModeModelMapper.ensureInitialized();
    return MapperContainer.globals.toValue<DarkModeModel>(this) as String;
  }
}

