// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appearance_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppearanceState {

 Status get status; String get errorMessage; ThemeColor get themeColor; ThemeColor get selectedThemeColor; DarkMode get darkMode; DarkMode get selectedDarkMode; String get action;
/// Create a copy of AppearanceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppearanceStateCopyWith<AppearanceState> get copyWith => _$AppearanceStateCopyWithImpl<AppearanceState>(this as AppearanceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppearanceState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.selectedThemeColor, selectedThemeColor) || other.selectedThemeColor == selectedThemeColor)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.selectedDarkMode, selectedDarkMode) || other.selectedDarkMode == selectedDarkMode)&&(identical(other.action, action) || other.action == action));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,themeColor,selectedThemeColor,darkMode,selectedDarkMode,action);

@override
String toString() {
  return 'AppearanceState(status: $status, errorMessage: $errorMessage, themeColor: $themeColor, selectedThemeColor: $selectedThemeColor, darkMode: $darkMode, selectedDarkMode: $selectedDarkMode, action: $action)';
}


}

/// @nodoc
abstract mixin class $AppearanceStateCopyWith<$Res>  {
  factory $AppearanceStateCopyWith(AppearanceState value, $Res Function(AppearanceState) _then) = _$AppearanceStateCopyWithImpl;
@useResult
$Res call({
 Status status, String errorMessage, ThemeColor themeColor, ThemeColor selectedThemeColor, DarkMode darkMode, DarkMode selectedDarkMode, String action
});




}
/// @nodoc
class _$AppearanceStateCopyWithImpl<$Res>
    implements $AppearanceStateCopyWith<$Res> {
  _$AppearanceStateCopyWithImpl(this._self, this._then);

  final AppearanceState _self;
  final $Res Function(AppearanceState) _then;

/// Create a copy of AppearanceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? errorMessage = null,Object? themeColor = null,Object? selectedThemeColor = null,Object? darkMode = null,Object? selectedDarkMode = null,Object? action = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,themeColor: null == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as ThemeColor,selectedThemeColor: null == selectedThemeColor ? _self.selectedThemeColor : selectedThemeColor // ignore: cast_nullable_to_non_nullable
as ThemeColor,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as DarkMode,selectedDarkMode: null == selectedDarkMode ? _self.selectedDarkMode : selectedDarkMode // ignore: cast_nullable_to_non_nullable
as DarkMode,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppearanceState].
extension AppearanceStatePatterns on AppearanceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppearanceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppearanceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppearanceState value)  $default,){
final _that = this;
switch (_that) {
case _AppearanceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppearanceState value)?  $default,){
final _that = this;
switch (_that) {
case _AppearanceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status status,  String errorMessage,  ThemeColor themeColor,  ThemeColor selectedThemeColor,  DarkMode darkMode,  DarkMode selectedDarkMode,  String action)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppearanceState() when $default != null:
return $default(_that.status,_that.errorMessage,_that.themeColor,_that.selectedThemeColor,_that.darkMode,_that.selectedDarkMode,_that.action);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status status,  String errorMessage,  ThemeColor themeColor,  ThemeColor selectedThemeColor,  DarkMode darkMode,  DarkMode selectedDarkMode,  String action)  $default,) {final _that = this;
switch (_that) {
case _AppearanceState():
return $default(_that.status,_that.errorMessage,_that.themeColor,_that.selectedThemeColor,_that.darkMode,_that.selectedDarkMode,_that.action);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc


class _AppearanceState extends AppearanceState {
  const _AppearanceState({this.status = Status.initial, this.errorMessage = "", this.themeColor = ThemeColor.blue, this.selectedThemeColor = ThemeColor.blue, this.darkMode = DarkMode.system, this.selectedDarkMode = DarkMode.system, this.action = ""}): super._();
  

@override@JsonKey() final  Status status;
@override@JsonKey() final  String errorMessage;
@override@JsonKey() final  ThemeColor themeColor;
@override@JsonKey() final  ThemeColor selectedThemeColor;
@override@JsonKey() final  DarkMode darkMode;
@override@JsonKey() final  DarkMode selectedDarkMode;
@override@JsonKey() final  String action;

/// Create a copy of AppearanceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppearanceStateCopyWith<_AppearanceState> get copyWith => __$AppearanceStateCopyWithImpl<_AppearanceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppearanceState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.selectedThemeColor, selectedThemeColor) || other.selectedThemeColor == selectedThemeColor)&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.selectedDarkMode, selectedDarkMode) || other.selectedDarkMode == selectedDarkMode)&&(identical(other.action, action) || other.action == action));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,themeColor,selectedThemeColor,darkMode,selectedDarkMode,action);

@override
String toString() {
  return 'AppearanceState(status: $status, errorMessage: $errorMessage, themeColor: $themeColor, selectedThemeColor: $selectedThemeColor, darkMode: $darkMode, selectedDarkMode: $selectedDarkMode, action: $action)';
}


}

/// @nodoc
abstract mixin class _$AppearanceStateCopyWith<$Res> implements $AppearanceStateCopyWith<$Res> {
  factory _$AppearanceStateCopyWith(_AppearanceState value, $Res Function(_AppearanceState) _then) = __$AppearanceStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, String errorMessage, ThemeColor themeColor, ThemeColor selectedThemeColor, DarkMode darkMode, DarkMode selectedDarkMode, String action
});




}
/// @nodoc
class __$AppearanceStateCopyWithImpl<$Res>
    implements _$AppearanceStateCopyWith<$Res> {
  __$AppearanceStateCopyWithImpl(this._self, this._then);

  final _AppearanceState _self;
  final $Res Function(_AppearanceState) _then;

/// Create a copy of AppearanceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? errorMessage = null,Object? themeColor = null,Object? selectedThemeColor = null,Object? darkMode = null,Object? selectedDarkMode = null,Object? action = null,}) {
  return _then(_AppearanceState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,themeColor: null == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as ThemeColor,selectedThemeColor: null == selectedThemeColor ? _self.selectedThemeColor : selectedThemeColor // ignore: cast_nullable_to_non_nullable
as ThemeColor,darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as DarkMode,selectedDarkMode: null == selectedDarkMode ? _self.selectedDarkMode : selectedDarkMode // ignore: cast_nullable_to_non_nullable
as DarkMode,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
