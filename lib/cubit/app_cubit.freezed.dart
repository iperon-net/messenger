// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppState {

 Status get status; models.SettingsDeviceThemeColor get themeColor; models.SettingsDeviceDarkMode get darkMode; String get passCode; int get passCodeTtl; int get passCodeTimer; int get viewTaskSwitchingEnable; bool get viewTaskSwitching;
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppStateCopyWith<AppState> get copyWith => _$AppStateCopyWithImpl<AppState>(this as AppState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppState&&(identical(other.status, status) || other.status == status)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.passCode, passCode) || other.passCode == passCode)&&(identical(other.passCodeTtl, passCodeTtl) || other.passCodeTtl == passCodeTtl)&&(identical(other.passCodeTimer, passCodeTimer) || other.passCodeTimer == passCodeTimer)&&(identical(other.viewTaskSwitchingEnable, viewTaskSwitchingEnable) || other.viewTaskSwitchingEnable == viewTaskSwitchingEnable)&&(identical(other.viewTaskSwitching, viewTaskSwitching) || other.viewTaskSwitching == viewTaskSwitching));
}


@override
int get hashCode => Object.hash(runtimeType,status,themeColor,darkMode,passCode,passCodeTtl,passCodeTimer,viewTaskSwitchingEnable,viewTaskSwitching);

@override
String toString() {
  return 'AppState(status: $status, themeColor: $themeColor, darkMode: $darkMode, passCode: $passCode, passCodeTtl: $passCodeTtl, passCodeTimer: $passCodeTimer, viewTaskSwitchingEnable: $viewTaskSwitchingEnable, viewTaskSwitching: $viewTaskSwitching)';
}


}

/// @nodoc
abstract mixin class $AppStateCopyWith<$Res>  {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) _then) = _$AppStateCopyWithImpl;
@useResult
$Res call({
 Status status, models.SettingsDeviceThemeColor themeColor, models.SettingsDeviceDarkMode darkMode, String passCode, int passCodeTtl, int passCodeTimer, int viewTaskSwitchingEnable, bool viewTaskSwitching
});




}
/// @nodoc
class _$AppStateCopyWithImpl<$Res>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._self, this._then);

  final AppState _self;
  final $Res Function(AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? themeColor = null,Object? darkMode = null,Object? passCode = null,Object? passCodeTtl = null,Object? passCodeTimer = null,Object? viewTaskSwitchingEnable = null,Object? viewTaskSwitching = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,themeColor: null == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as models.SettingsDeviceThemeColor,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as models.SettingsDeviceDarkMode,passCode: null == passCode ? _self.passCode : passCode // ignore: cast_nullable_to_non_nullable
as String,passCodeTtl: null == passCodeTtl ? _self.passCodeTtl : passCodeTtl // ignore: cast_nullable_to_non_nullable
as int,passCodeTimer: null == passCodeTimer ? _self.passCodeTimer : passCodeTimer // ignore: cast_nullable_to_non_nullable
as int,viewTaskSwitchingEnable: null == viewTaskSwitchingEnable ? _self.viewTaskSwitchingEnable : viewTaskSwitchingEnable // ignore: cast_nullable_to_non_nullable
as int,viewTaskSwitching: null == viewTaskSwitching ? _self.viewTaskSwitching : viewTaskSwitching // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppState].
extension AppStatePatterns on AppState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppState value)  $default,){
final _that = this;
switch (_that) {
case _AppState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppState value)?  $default,){
final _that = this;
switch (_that) {
case _AppState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status status,  models.SettingsDeviceThemeColor themeColor,  models.SettingsDeviceDarkMode darkMode,  String passCode,  int passCodeTtl,  int passCodeTimer,  int viewTaskSwitchingEnable,  bool viewTaskSwitching)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppState() when $default != null:
return $default(_that.status,_that.themeColor,_that.darkMode,_that.passCode,_that.passCodeTtl,_that.passCodeTimer,_that.viewTaskSwitchingEnable,_that.viewTaskSwitching);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status status,  models.SettingsDeviceThemeColor themeColor,  models.SettingsDeviceDarkMode darkMode,  String passCode,  int passCodeTtl,  int passCodeTimer,  int viewTaskSwitchingEnable,  bool viewTaskSwitching)  $default,) {final _that = this;
switch (_that) {
case _AppState():
return $default(_that.status,_that.themeColor,_that.darkMode,_that.passCode,_that.passCodeTtl,_that.passCodeTimer,_that.viewTaskSwitchingEnable,_that.viewTaskSwitching);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc


class _AppState extends AppState {
  const _AppState({this.status = Status.initial, this.themeColor = models.SettingsDeviceThemeColor.blue, this.darkMode = models.SettingsDeviceDarkMode.system, this.passCode = "", this.passCodeTtl = 0, this.passCodeTimer = 0, this.viewTaskSwitchingEnable = 0, this.viewTaskSwitching = false}): super._();
  

@override@JsonKey() final  Status status;
@override@JsonKey() final  models.SettingsDeviceThemeColor themeColor;
@override@JsonKey() final  models.SettingsDeviceDarkMode darkMode;
@override@JsonKey() final  String passCode;
@override@JsonKey() final  int passCodeTtl;
@override@JsonKey() final  int passCodeTimer;
@override@JsonKey() final  int viewTaskSwitchingEnable;
@override@JsonKey() final  bool viewTaskSwitching;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStateCopyWith<_AppState> get copyWith => __$AppStateCopyWithImpl<_AppState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppState&&(identical(other.status, status) || other.status == status)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.passCode, passCode) || other.passCode == passCode)&&(identical(other.passCodeTtl, passCodeTtl) || other.passCodeTtl == passCodeTtl)&&(identical(other.passCodeTimer, passCodeTimer) || other.passCodeTimer == passCodeTimer)&&(identical(other.viewTaskSwitchingEnable, viewTaskSwitchingEnable) || other.viewTaskSwitchingEnable == viewTaskSwitchingEnable)&&(identical(other.viewTaskSwitching, viewTaskSwitching) || other.viewTaskSwitching == viewTaskSwitching));
}


@override
int get hashCode => Object.hash(runtimeType,status,themeColor,darkMode,passCode,passCodeTtl,passCodeTimer,viewTaskSwitchingEnable,viewTaskSwitching);

@override
String toString() {
  return 'AppState(status: $status, themeColor: $themeColor, darkMode: $darkMode, passCode: $passCode, passCodeTtl: $passCodeTtl, passCodeTimer: $passCodeTimer, viewTaskSwitchingEnable: $viewTaskSwitchingEnable, viewTaskSwitching: $viewTaskSwitching)';
}


}

/// @nodoc
abstract mixin class _$AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$AppStateCopyWith(_AppState value, $Res Function(_AppState) _then) = __$AppStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, models.SettingsDeviceThemeColor themeColor, models.SettingsDeviceDarkMode darkMode, String passCode, int passCodeTtl, int passCodeTimer, int viewTaskSwitchingEnable, bool viewTaskSwitching
});




}
/// @nodoc
class __$AppStateCopyWithImpl<$Res>
    implements _$AppStateCopyWith<$Res> {
  __$AppStateCopyWithImpl(this._self, this._then);

  final _AppState _self;
  final $Res Function(_AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? themeColor = null,Object? darkMode = null,Object? passCode = null,Object? passCodeTtl = null,Object? passCodeTimer = null,Object? viewTaskSwitchingEnable = null,Object? viewTaskSwitching = null,}) {
  return _then(_AppState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,themeColor: null == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as models.SettingsDeviceThemeColor,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as models.SettingsDeviceDarkMode,passCode: null == passCode ? _self.passCode : passCode // ignore: cast_nullable_to_non_nullable
as String,passCodeTtl: null == passCodeTtl ? _self.passCodeTtl : passCodeTtl // ignore: cast_nullable_to_non_nullable
as int,passCodeTimer: null == passCodeTimer ? _self.passCodeTimer : passCodeTimer // ignore: cast_nullable_to_non_nullable
as int,viewTaskSwitchingEnable: null == viewTaskSwitchingEnable ? _self.viewTaskSwitchingEnable : viewTaskSwitchingEnable // ignore: cast_nullable_to_non_nullable
as int,viewTaskSwitching: null == viewTaskSwitching ? _self.viewTaskSwitching : viewTaskSwitching // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
