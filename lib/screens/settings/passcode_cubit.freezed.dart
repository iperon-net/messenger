// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'passcode_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PasscodeState {

 Status get status; String get errorMessage; String get passCode;
/// Create a copy of PasscodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasscodeStateCopyWith<PasscodeState> get copyWith => _$PasscodeStateCopyWithImpl<PasscodeState>(this as PasscodeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasscodeState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.passCode, passCode) || other.passCode == passCode));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,passCode);

@override
String toString() {
  return 'PasscodeState(status: $status, errorMessage: $errorMessage, passCode: $passCode)';
}


}

/// @nodoc
abstract mixin class $PasscodeStateCopyWith<$Res>  {
  factory $PasscodeStateCopyWith(PasscodeState value, $Res Function(PasscodeState) _then) = _$PasscodeStateCopyWithImpl;
@useResult
$Res call({
 Status status, String errorMessage, String passCode
});




}
/// @nodoc
class _$PasscodeStateCopyWithImpl<$Res>
    implements $PasscodeStateCopyWith<$Res> {
  _$PasscodeStateCopyWithImpl(this._self, this._then);

  final PasscodeState _self;
  final $Res Function(PasscodeState) _then;

/// Create a copy of PasscodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? errorMessage = null,Object? passCode = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,passCode: null == passCode ? _self.passCode : passCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PasscodeState].
extension PasscodeStatePatterns on PasscodeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PasscodeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PasscodeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PasscodeState value)  $default,){
final _that = this;
switch (_that) {
case _PasscodeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PasscodeState value)?  $default,){
final _that = this;
switch (_that) {
case _PasscodeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status status,  String errorMessage,  String passCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PasscodeState() when $default != null:
return $default(_that.status,_that.errorMessage,_that.passCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status status,  String errorMessage,  String passCode)  $default,) {final _that = this;
switch (_that) {
case _PasscodeState():
return $default(_that.status,_that.errorMessage,_that.passCode);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc


class _PasscodeState extends PasscodeState {
  const _PasscodeState({this.status = Status.initial, this.errorMessage = "", this.passCode = ""}): super._();
  

@override@JsonKey() final  Status status;
@override@JsonKey() final  String errorMessage;
@override@JsonKey() final  String passCode;

/// Create a copy of PasscodeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PasscodeStateCopyWith<_PasscodeState> get copyWith => __$PasscodeStateCopyWithImpl<_PasscodeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasscodeState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.passCode, passCode) || other.passCode == passCode));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,passCode);

@override
String toString() {
  return 'PasscodeState(status: $status, errorMessage: $errorMessage, passCode: $passCode)';
}


}

/// @nodoc
abstract mixin class _$PasscodeStateCopyWith<$Res> implements $PasscodeStateCopyWith<$Res> {
  factory _$PasscodeStateCopyWith(_PasscodeState value, $Res Function(_PasscodeState) _then) = __$PasscodeStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, String errorMessage, String passCode
});




}
/// @nodoc
class __$PasscodeStateCopyWithImpl<$Res>
    implements _$PasscodeStateCopyWith<$Res> {
  __$PasscodeStateCopyWithImpl(this._self, this._then);

  final _PasscodeState _self;
  final $Res Function(_PasscodeState) _then;

/// Create a copy of PasscodeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? errorMessage = null,Object? passCode = null,}) {
  return _then(_PasscodeState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,passCode: null == passCode ? _self.passCode : passCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
