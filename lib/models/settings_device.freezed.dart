// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsDevice implements DiagnosticableTreeMixin {

 String get language; SettingsDeviceDarkMode get darkMode; SettingsDeviceThemeColor get themeColor; String get passCode; int get passCodeTtl; int get passCodeTimer; int get passCodeLock;
/// Create a copy of SettingsDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsDeviceCopyWith<SettingsDevice> get copyWith => _$SettingsDeviceCopyWithImpl<SettingsDevice>(this as SettingsDevice, _$identity);

  /// Serializes this SettingsDevice to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SettingsDevice'))
    ..add(DiagnosticsProperty('language', language))..add(DiagnosticsProperty('darkMode', darkMode))..add(DiagnosticsProperty('themeColor', themeColor))..add(DiagnosticsProperty('passCode', passCode))..add(DiagnosticsProperty('passCodeTtl', passCodeTtl))..add(DiagnosticsProperty('passCodeTimer', passCodeTimer))..add(DiagnosticsProperty('passCodeLock', passCodeLock));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsDevice&&(identical(other.language, language) || other.language == language)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.passCode, passCode) || other.passCode == passCode)&&(identical(other.passCodeTtl, passCodeTtl) || other.passCodeTtl == passCodeTtl)&&(identical(other.passCodeTimer, passCodeTimer) || other.passCodeTimer == passCodeTimer)&&(identical(other.passCodeLock, passCodeLock) || other.passCodeLock == passCodeLock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language,darkMode,themeColor,passCode,passCodeTtl,passCodeTimer,passCodeLock);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsDevice(language: $language, darkMode: $darkMode, themeColor: $themeColor, passCode: $passCode, passCodeTtl: $passCodeTtl, passCodeTimer: $passCodeTimer, passCodeLock: $passCodeLock)';
}


}

/// @nodoc
abstract mixin class $SettingsDeviceCopyWith<$Res>  {
  factory $SettingsDeviceCopyWith(SettingsDevice value, $Res Function(SettingsDevice) _then) = _$SettingsDeviceCopyWithImpl;
@useResult
$Res call({
 String language, SettingsDeviceDarkMode darkMode, SettingsDeviceThemeColor themeColor, String passCode, int passCodeTtl, int passCodeTimer, int passCodeLock
});




}
/// @nodoc
class _$SettingsDeviceCopyWithImpl<$Res>
    implements $SettingsDeviceCopyWith<$Res> {
  _$SettingsDeviceCopyWithImpl(this._self, this._then);

  final SettingsDevice _self;
  final $Res Function(SettingsDevice) _then;

/// Create a copy of SettingsDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? language = null,Object? darkMode = null,Object? themeColor = null,Object? passCode = null,Object? passCodeTtl = null,Object? passCodeTimer = null,Object? passCodeLock = null,}) {
  return _then(_self.copyWith(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as SettingsDeviceDarkMode,themeColor: null == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as SettingsDeviceThemeColor,passCode: null == passCode ? _self.passCode : passCode // ignore: cast_nullable_to_non_nullable
as String,passCodeTtl: null == passCodeTtl ? _self.passCodeTtl : passCodeTtl // ignore: cast_nullable_to_non_nullable
as int,passCodeTimer: null == passCodeTimer ? _self.passCodeTimer : passCodeTimer // ignore: cast_nullable_to_non_nullable
as int,passCodeLock: null == passCodeLock ? _self.passCodeLock : passCodeLock // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsDevice].
extension SettingsDevicePatterns on SettingsDevice {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsDevice() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsDevice value)  $default,){
final _that = this;
switch (_that) {
case _SettingsDevice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsDevice value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsDevice() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String language,  SettingsDeviceDarkMode darkMode,  SettingsDeviceThemeColor themeColor,  String passCode,  int passCodeTtl,  int passCodeTimer,  int passCodeLock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsDevice() when $default != null:
return $default(_that.language,_that.darkMode,_that.themeColor,_that.passCode,_that.passCodeTtl,_that.passCodeTimer,_that.passCodeLock);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String language,  SettingsDeviceDarkMode darkMode,  SettingsDeviceThemeColor themeColor,  String passCode,  int passCodeTtl,  int passCodeTimer,  int passCodeLock)  $default,) {final _that = this;
switch (_that) {
case _SettingsDevice():
return $default(_that.language,_that.darkMode,_that.themeColor,_that.passCode,_that.passCodeTtl,_that.passCodeTimer,_that.passCodeLock);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SettingsDevice extends SettingsDevice with DiagnosticableTreeMixin {
  const _SettingsDevice({required this.language, required this.darkMode, required this.themeColor, required this.passCode, required this.passCodeTtl, required this.passCodeTimer, required this.passCodeLock}): super._();
  factory _SettingsDevice.fromJson(Map<String, dynamic> json) => _$SettingsDeviceFromJson(json);

@override final  String language;
@override final  SettingsDeviceDarkMode darkMode;
@override final  SettingsDeviceThemeColor themeColor;
@override final  String passCode;
@override final  int passCodeTtl;
@override final  int passCodeTimer;
@override final  int passCodeLock;

/// Create a copy of SettingsDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsDeviceCopyWith<_SettingsDevice> get copyWith => __$SettingsDeviceCopyWithImpl<_SettingsDevice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsDeviceToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SettingsDevice'))
    ..add(DiagnosticsProperty('language', language))..add(DiagnosticsProperty('darkMode', darkMode))..add(DiagnosticsProperty('themeColor', themeColor))..add(DiagnosticsProperty('passCode', passCode))..add(DiagnosticsProperty('passCodeTtl', passCodeTtl))..add(DiagnosticsProperty('passCodeTimer', passCodeTimer))..add(DiagnosticsProperty('passCodeLock', passCodeLock));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsDevice&&(identical(other.language, language) || other.language == language)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.passCode, passCode) || other.passCode == passCode)&&(identical(other.passCodeTtl, passCodeTtl) || other.passCodeTtl == passCodeTtl)&&(identical(other.passCodeTimer, passCodeTimer) || other.passCodeTimer == passCodeTimer)&&(identical(other.passCodeLock, passCodeLock) || other.passCodeLock == passCodeLock));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language,darkMode,themeColor,passCode,passCodeTtl,passCodeTimer,passCodeLock);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsDevice(language: $language, darkMode: $darkMode, themeColor: $themeColor, passCode: $passCode, passCodeTtl: $passCodeTtl, passCodeTimer: $passCodeTimer, passCodeLock: $passCodeLock)';
}


}

/// @nodoc
abstract mixin class _$SettingsDeviceCopyWith<$Res> implements $SettingsDeviceCopyWith<$Res> {
  factory _$SettingsDeviceCopyWith(_SettingsDevice value, $Res Function(_SettingsDevice) _then) = __$SettingsDeviceCopyWithImpl;
@override @useResult
$Res call({
 String language, SettingsDeviceDarkMode darkMode, SettingsDeviceThemeColor themeColor, String passCode, int passCodeTtl, int passCodeTimer, int passCodeLock
});




}
/// @nodoc
class __$SettingsDeviceCopyWithImpl<$Res>
    implements _$SettingsDeviceCopyWith<$Res> {
  __$SettingsDeviceCopyWithImpl(this._self, this._then);

  final _SettingsDevice _self;
  final $Res Function(_SettingsDevice) _then;

/// Create a copy of SettingsDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? language = null,Object? darkMode = null,Object? themeColor = null,Object? passCode = null,Object? passCodeTtl = null,Object? passCodeTimer = null,Object? passCodeLock = null,}) {
  return _then(_SettingsDevice(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as SettingsDeviceDarkMode,themeColor: null == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as SettingsDeviceThemeColor,passCode: null == passCode ? _self.passCode : passCode // ignore: cast_nullable_to_non_nullable
as String,passCodeTtl: null == passCodeTtl ? _self.passCodeTtl : passCodeTtl // ignore: cast_nullable_to_non_nullable
as int,passCodeTimer: null == passCodeTimer ? _self.passCodeTimer : passCodeTimer // ignore: cast_nullable_to_non_nullable
as int,passCodeLock: null == passCodeLock ? _self.passCodeLock : passCodeLock // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
