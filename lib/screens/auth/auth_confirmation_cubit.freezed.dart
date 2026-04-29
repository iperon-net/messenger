// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_confirmation_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthConfirmationState {

 Status get status; String get error;
/// Create a copy of AuthConfirmationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthConfirmationStateCopyWith<AuthConfirmationState> get copyWith => _$AuthConfirmationStateCopyWithImpl<AuthConfirmationState>(this as AuthConfirmationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthConfirmationState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,error);

@override
String toString() {
  return 'AuthConfirmationState(status: $status, error: $error)';
}


}

/// @nodoc
abstract mixin class $AuthConfirmationStateCopyWith<$Res>  {
  factory $AuthConfirmationStateCopyWith(AuthConfirmationState value, $Res Function(AuthConfirmationState) _then) = _$AuthConfirmationStateCopyWithImpl;
@useResult
$Res call({
 Status status, String error
});




}
/// @nodoc
class _$AuthConfirmationStateCopyWithImpl<$Res>
    implements $AuthConfirmationStateCopyWith<$Res> {
  _$AuthConfirmationStateCopyWithImpl(this._self, this._then);

  final AuthConfirmationState _self;
  final $Res Function(AuthConfirmationState) _then;

/// Create a copy of AuthConfirmationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? error = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthConfirmationState].
extension AuthConfirmationStatePatterns on AuthConfirmationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthConfirmationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthConfirmationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthConfirmationState value)  $default,){
final _that = this;
switch (_that) {
case _AuthConfirmationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthConfirmationState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthConfirmationState() when $default != null:
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
case _AuthConfirmationState() when $default != null:
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
case _AuthConfirmationState():
return $default(_that.status,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc


class _AuthConfirmationState implements AuthConfirmationState {
  const _AuthConfirmationState({this.status = Status.initialization, this.error = ""});
  

@override@JsonKey() final  Status status;
@override@JsonKey() final  String error;

/// Create a copy of AuthConfirmationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthConfirmationStateCopyWith<_AuthConfirmationState> get copyWith => __$AuthConfirmationStateCopyWithImpl<_AuthConfirmationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthConfirmationState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,error);

@override
String toString() {
  return 'AuthConfirmationState(status: $status, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AuthConfirmationStateCopyWith<$Res> implements $AuthConfirmationStateCopyWith<$Res> {
  factory _$AuthConfirmationStateCopyWith(_AuthConfirmationState value, $Res Function(_AuthConfirmationState) _then) = __$AuthConfirmationStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, String error
});




}
/// @nodoc
class __$AuthConfirmationStateCopyWithImpl<$Res>
    implements _$AuthConfirmationStateCopyWith<$Res> {
  __$AuthConfirmationStateCopyWithImpl(this._self, this._then);

  final _AuthConfirmationState _self;
  final $Res Function(_AuthConfirmationState) _then;

/// Create a copy of AuthConfirmationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? error = null,}) {
  return _then(_AuthConfirmationState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
