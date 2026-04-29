// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {

 Status get status; String get error; String get version; List<int> get callPasswordSession; String get confirmationPhoneNumber; double get timeout;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.callPasswordSession, callPasswordSession)&&(identical(other.confirmationPhoneNumber, confirmationPhoneNumber) || other.confirmationPhoneNumber == confirmationPhoneNumber)&&(identical(other.timeout, timeout) || other.timeout == timeout));
}


@override
int get hashCode => Object.hash(runtimeType,status,error,version,const DeepCollectionEquality().hash(callPasswordSession),confirmationPhoneNumber,timeout);

@override
String toString() {
  return 'AuthState(status: $status, error: $error, version: $version, callPasswordSession: $callPasswordSession, confirmationPhoneNumber: $confirmationPhoneNumber, timeout: $timeout)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 Status status, String error, String version, List<int> callPasswordSession, String confirmationPhoneNumber, double timeout
});




}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? error = null,Object? version = null,Object? callPasswordSession = null,Object? confirmationPhoneNumber = null,Object? timeout = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,callPasswordSession: null == callPasswordSession ? _self.callPasswordSession : callPasswordSession // ignore: cast_nullable_to_non_nullable
as List<int>,confirmationPhoneNumber: null == confirmationPhoneNumber ? _self.confirmationPhoneNumber : confirmationPhoneNumber // ignore: cast_nullable_to_non_nullable
as String,timeout: null == timeout ? _self.timeout : timeout // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status status,  String error,  String version,  List<int> callPasswordSession,  String confirmationPhoneNumber,  double timeout)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.status,_that.error,_that.version,_that.callPasswordSession,_that.confirmationPhoneNumber,_that.timeout);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status status,  String error,  String version,  List<int> callPasswordSession,  String confirmationPhoneNumber,  double timeout)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.status,_that.error,_that.version,_that.callPasswordSession,_that.confirmationPhoneNumber,_that.timeout);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc


class _AuthState implements AuthState {
  const _AuthState({this.status = Status.initialization, this.error = "", this.version = "v0.0.0", final  List<int> callPasswordSession = const [], this.confirmationPhoneNumber = "", this.timeout = 0}): _callPasswordSession = callPasswordSession;
  

@override@JsonKey() final  Status status;
@override@JsonKey() final  String error;
@override@JsonKey() final  String version;
 final  List<int> _callPasswordSession;
@override@JsonKey() List<int> get callPasswordSession {
  if (_callPasswordSession is EqualUnmodifiableListView) return _callPasswordSession;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_callPasswordSession);
}

@override@JsonKey() final  String confirmationPhoneNumber;
@override@JsonKey() final  double timeout;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._callPasswordSession, _callPasswordSession)&&(identical(other.confirmationPhoneNumber, confirmationPhoneNumber) || other.confirmationPhoneNumber == confirmationPhoneNumber)&&(identical(other.timeout, timeout) || other.timeout == timeout));
}


@override
int get hashCode => Object.hash(runtimeType,status,error,version,const DeepCollectionEquality().hash(_callPasswordSession),confirmationPhoneNumber,timeout);

@override
String toString() {
  return 'AuthState(status: $status, error: $error, version: $version, callPasswordSession: $callPasswordSession, confirmationPhoneNumber: $confirmationPhoneNumber, timeout: $timeout)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, String error, String version, List<int> callPasswordSession, String confirmationPhoneNumber, double timeout
});




}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? error = null,Object? version = null,Object? callPasswordSession = null,Object? confirmationPhoneNumber = null,Object? timeout = null,}) {
  return _then(_AuthState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,callPasswordSession: null == callPasswordSession ? _self._callPasswordSession : callPasswordSession // ignore: cast_nullable_to_non_nullable
as List<int>,confirmationPhoneNumber: null == confirmationPhoneNumber ? _self.confirmationPhoneNumber : confirmationPhoneNumber // ignore: cast_nullable_to_non_nullable
as String,timeout: null == timeout ? _self.timeout : timeout // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
