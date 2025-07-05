// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_and_security_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivacyAndSecurityState {

 Status get status; String get errorMessage;
/// Create a copy of PrivacyAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivacyAndSecurityStateCopyWith<PrivacyAndSecurityState> get copyWith => _$PrivacyAndSecurityStateCopyWithImpl<PrivacyAndSecurityState>(this as PrivacyAndSecurityState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivacyAndSecurityState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage);

@override
String toString() {
  return 'PrivacyAndSecurityState(status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PrivacyAndSecurityStateCopyWith<$Res>  {
  factory $PrivacyAndSecurityStateCopyWith(PrivacyAndSecurityState value, $Res Function(PrivacyAndSecurityState) _then) = _$PrivacyAndSecurityStateCopyWithImpl;
@useResult
$Res call({
 Status status, String errorMessage
});




}
/// @nodoc
class _$PrivacyAndSecurityStateCopyWithImpl<$Res>
    implements $PrivacyAndSecurityStateCopyWith<$Res> {
  _$PrivacyAndSecurityStateCopyWithImpl(this._self, this._then);

  final PrivacyAndSecurityState _self;
  final $Res Function(PrivacyAndSecurityState) _then;

/// Create a copy of PrivacyAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivacyAndSecurityState].
extension PrivacyAndSecurityStatePatterns on PrivacyAndSecurityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivacyAndSecurityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivacyAndSecurityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivacyAndSecurityState value)  $default,){
final _that = this;
switch (_that) {
case _PrivacyAndSecurityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivacyAndSecurityState value)?  $default,){
final _that = this;
switch (_that) {
case _PrivacyAndSecurityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status status,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivacyAndSecurityState() when $default != null:
return $default(_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status status,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PrivacyAndSecurityState():
return $default(_that.status,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc


class _PrivacyAndSecurityState extends PrivacyAndSecurityState {
  const _PrivacyAndSecurityState({this.status = Status.initial, this.errorMessage = ""}): super._();
  

@override@JsonKey() final  Status status;
@override@JsonKey() final  String errorMessage;

/// Create a copy of PrivacyAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivacyAndSecurityStateCopyWith<_PrivacyAndSecurityState> get copyWith => __$PrivacyAndSecurityStateCopyWithImpl<_PrivacyAndSecurityState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivacyAndSecurityState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage);

@override
String toString() {
  return 'PrivacyAndSecurityState(status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PrivacyAndSecurityStateCopyWith<$Res> implements $PrivacyAndSecurityStateCopyWith<$Res> {
  factory _$PrivacyAndSecurityStateCopyWith(_PrivacyAndSecurityState value, $Res Function(_PrivacyAndSecurityState) _then) = __$PrivacyAndSecurityStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, String errorMessage
});




}
/// @nodoc
class __$PrivacyAndSecurityStateCopyWithImpl<$Res>
    implements _$PrivacyAndSecurityStateCopyWith<$Res> {
  __$PrivacyAndSecurityStateCopyWithImpl(this._self, this._then);

  final _PrivacyAndSecurityState _self;
  final $Res Function(_PrivacyAndSecurityState) _then;

/// Create a copy of PrivacyAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? errorMessage = null,}) {
  return _then(_PrivacyAndSecurityState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
