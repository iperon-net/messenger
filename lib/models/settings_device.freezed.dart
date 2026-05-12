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

 AppLocale? get locate; SettingsDeviceDarkMode get darkMode; dynamic get themeColor;@BoolConverter() bool get blurTaskSwitchingEnable;
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
    ..add(DiagnosticsProperty('locate', locate))..add(DiagnosticsProperty('darkMode', darkMode))..add(DiagnosticsProperty('themeColor', themeColor))..add(DiagnosticsProperty('blurTaskSwitchingEnable', blurTaskSwitchingEnable));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsDevice&&(identical(other.locate, locate) || other.locate == locate)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&const DeepCollectionEquality().equals(other.themeColor, themeColor)&&(identical(other.blurTaskSwitchingEnable, blurTaskSwitchingEnable) || other.blurTaskSwitchingEnable == blurTaskSwitchingEnable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,locate,darkMode,const DeepCollectionEquality().hash(themeColor),blurTaskSwitchingEnable);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsDevice(locate: $locate, darkMode: $darkMode, themeColor: $themeColor, blurTaskSwitchingEnable: $blurTaskSwitchingEnable)';
}


}

/// @nodoc
abstract mixin class $SettingsDeviceCopyWith<$Res>  {
  factory $SettingsDeviceCopyWith(SettingsDevice value, $Res Function(SettingsDevice) _then) = _$SettingsDeviceCopyWithImpl;
@useResult
$Res call({
 AppLocale? locate, SettingsDeviceDarkMode darkMode, dynamic themeColor,@BoolConverter() bool blurTaskSwitchingEnable
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
@pragma('vm:prefer-inline') @override $Res call({Object? locate = freezed,Object? darkMode = null,Object? themeColor = freezed,Object? blurTaskSwitchingEnable = null,}) {
  return _then(_self.copyWith(
locate: freezed == locate ? _self.locate : locate // ignore: cast_nullable_to_non_nullable
as AppLocale?,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as SettingsDeviceDarkMode,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as dynamic,blurTaskSwitchingEnable: null == blurTaskSwitchingEnable ? _self.blurTaskSwitchingEnable : blurTaskSwitchingEnable // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppLocale? locate,  SettingsDeviceDarkMode darkMode,  dynamic themeColor, @BoolConverter()  bool blurTaskSwitchingEnable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsDevice() when $default != null:
return $default(_that.locate,_that.darkMode,_that.themeColor,_that.blurTaskSwitchingEnable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppLocale? locate,  SettingsDeviceDarkMode darkMode,  dynamic themeColor, @BoolConverter()  bool blurTaskSwitchingEnable)  $default,) {final _that = this;
switch (_that) {
case _SettingsDevice():
return $default(_that.locate,_that.darkMode,_that.themeColor,_that.blurTaskSwitchingEnable);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingsDevice extends SettingsDevice with DiagnosticableTreeMixin {
  const _SettingsDevice({this.locate, this.darkMode = SettingsDeviceDarkMode.system, this.themeColor = SettingsDeviceThemeColor.blue, @BoolConverter() this.blurTaskSwitchingEnable = false}): super._();
  factory _SettingsDevice.fromJson(Map<String, dynamic> json) => _$SettingsDeviceFromJson(json);

@override final  AppLocale? locate;
@override@JsonKey() final  SettingsDeviceDarkMode darkMode;
@override@JsonKey() final  dynamic themeColor;
@override@JsonKey()@BoolConverter() final  bool blurTaskSwitchingEnable;

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
    ..add(DiagnosticsProperty('locate', locate))..add(DiagnosticsProperty('darkMode', darkMode))..add(DiagnosticsProperty('themeColor', themeColor))..add(DiagnosticsProperty('blurTaskSwitchingEnable', blurTaskSwitchingEnable));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsDevice&&(identical(other.locate, locate) || other.locate == locate)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&const DeepCollectionEquality().equals(other.themeColor, themeColor)&&(identical(other.blurTaskSwitchingEnable, blurTaskSwitchingEnable) || other.blurTaskSwitchingEnable == blurTaskSwitchingEnable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,locate,darkMode,const DeepCollectionEquality().hash(themeColor),blurTaskSwitchingEnable);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsDevice(locate: $locate, darkMode: $darkMode, themeColor: $themeColor, blurTaskSwitchingEnable: $blurTaskSwitchingEnable)';
}


}

/// @nodoc
abstract mixin class _$SettingsDeviceCopyWith<$Res> implements $SettingsDeviceCopyWith<$Res> {
  factory _$SettingsDeviceCopyWith(_SettingsDevice value, $Res Function(_SettingsDevice) _then) = __$SettingsDeviceCopyWithImpl;
@override @useResult
$Res call({
 AppLocale? locate, SettingsDeviceDarkMode darkMode, dynamic themeColor,@BoolConverter() bool blurTaskSwitchingEnable
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
@override @pragma('vm:prefer-inline') $Res call({Object? locate = freezed,Object? darkMode = null,Object? themeColor = freezed,Object? blurTaskSwitchingEnable = null,}) {
  return _then(_SettingsDevice(
locate: freezed == locate ? _self.locate : locate // ignore: cast_nullable_to_non_nullable
as AppLocale?,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as SettingsDeviceDarkMode,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as dynamic,blurTaskSwitchingEnable: null == blurTaskSwitchingEnable ? _self.blurTaskSwitchingEnable : blurTaskSwitchingEnable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
