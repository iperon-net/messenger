// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_language_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsLanguageState {

 Status get status; String get error;
/// Create a copy of SettingsLanguageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsLanguageStateCopyWith<SettingsLanguageState> get copyWith => _$SettingsLanguageStateCopyWithImpl<SettingsLanguageState>(this as SettingsLanguageState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsLanguageState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,error);

@override
String toString() {
  return 'SettingsLanguageState(status: $status, error: $error)';
}


}

/// @nodoc
abstract mixin class $SettingsLanguageStateCopyWith<$Res>  {
  factory $SettingsLanguageStateCopyWith(SettingsLanguageState value, $Res Function(SettingsLanguageState) _then) = _$SettingsLanguageStateCopyWithImpl;
@useResult
$Res call({
 Status status, String error
});




}
/// @nodoc
class _$SettingsLanguageStateCopyWithImpl<$Res>
    implements $SettingsLanguageStateCopyWith<$Res> {
  _$SettingsLanguageStateCopyWithImpl(this._self, this._then);

  final SettingsLanguageState _self;
  final $Res Function(SettingsLanguageState) _then;

/// Create a copy of SettingsLanguageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? error = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsLanguageState].
extension SettingsLanguageStatePatterns on SettingsLanguageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsLanguageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsLanguageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsLanguageState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsLanguageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsLanguageState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsLanguageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status status,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsLanguageState() when $default != null:
return $default(_that.status,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status status,  String error)  $default,) {final _that = this;
switch (_that) {
case _SettingsLanguageState():
return $default(_that.status,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc


class _SettingsLanguageState implements SettingsLanguageState {
  const _SettingsLanguageState({this.status = Status.initialization, this.error = ""});
  

@override@JsonKey() final  Status status;
@override@JsonKey() final  String error;

/// Create a copy of SettingsLanguageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsLanguageStateCopyWith<_SettingsLanguageState> get copyWith => __$SettingsLanguageStateCopyWithImpl<_SettingsLanguageState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsLanguageState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,error);

@override
String toString() {
  return 'SettingsLanguageState(status: $status, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SettingsLanguageStateCopyWith<$Res> implements $SettingsLanguageStateCopyWith<$Res> {
  factory _$SettingsLanguageStateCopyWith(_SettingsLanguageState value, $Res Function(_SettingsLanguageState) _then) = __$SettingsLanguageStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, String error
});




}
/// @nodoc
class __$SettingsLanguageStateCopyWithImpl<$Res>
    implements _$SettingsLanguageStateCopyWith<$Res> {
  __$SettingsLanguageStateCopyWithImpl(this._self, this._then);

  final _SettingsLanguageState _self;
  final $Res Function(_SettingsLanguageState) _then;

/// Create a copy of SettingsLanguageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? error = null,}) {
  return _then(_SettingsLanguageState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
