// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_sms_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthSmsState {

 Status get status; String get error;
/// Create a copy of AuthSmsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSmsStateCopyWith<AuthSmsState> get copyWith => _$AuthSmsStateCopyWithImpl<AuthSmsState>(this as AuthSmsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSmsState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,error);

@override
String toString() {
  return 'AuthSmsState(status: $status, error: $error)';
}


}

/// @nodoc
abstract mixin class $AuthSmsStateCopyWith<$Res>  {
  factory $AuthSmsStateCopyWith(AuthSmsState value, $Res Function(AuthSmsState) _then) = _$AuthSmsStateCopyWithImpl;
@useResult
$Res call({
 Status status, String error
});




}
/// @nodoc
class _$AuthSmsStateCopyWithImpl<$Res>
    implements $AuthSmsStateCopyWith<$Res> {
  _$AuthSmsStateCopyWithImpl(this._self, this._then);

  final AuthSmsState _self;
  final $Res Function(AuthSmsState) _then;

/// Create a copy of AuthSmsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? error = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthSmsState].
extension AuthSmsStatePatterns on AuthSmsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthSmsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthSmsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthSmsState value)  $default,){
final _that = this;
switch (_that) {
case _AuthSmsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthSmsState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthSmsState() when $default != null:
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
case _AuthSmsState() when $default != null:
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
case _AuthSmsState():
return $default(_that.status,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc


class _AuthSmsState implements AuthSmsState {
  const _AuthSmsState({this.status = Status.initialization, this.error = ""});
  

@override@JsonKey() final  Status status;
@override@JsonKey() final  String error;

/// Create a copy of AuthSmsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthSmsStateCopyWith<_AuthSmsState> get copyWith => __$AuthSmsStateCopyWithImpl<_AuthSmsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthSmsState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,error);

@override
String toString() {
  return 'AuthSmsState(status: $status, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AuthSmsStateCopyWith<$Res> implements $AuthSmsStateCopyWith<$Res> {
  factory _$AuthSmsStateCopyWith(_AuthSmsState value, $Res Function(_AuthSmsState) _then) = __$AuthSmsStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, String error
});




}
/// @nodoc
class __$AuthSmsStateCopyWithImpl<$Res>
    implements _$AuthSmsStateCopyWith<$Res> {
  __$AuthSmsStateCopyWithImpl(this._self, this._then);

  final _AuthSmsState _self;
  final $Res Function(_AuthSmsState) _then;

/// Create a copy of AuthSmsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? error = null,}) {
  return _then(_AuthSmsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
