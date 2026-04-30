// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_callpassword_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthCallpasswordState {

 Status get status; String get error; List<int> get confirmationSession; int get tickerSecond; bool get isBlocked; bool get hasCloudPassword;
/// Create a copy of AuthCallpasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthCallpasswordStateCopyWith<AuthCallpasswordState> get copyWith => _$AuthCallpasswordStateCopyWithImpl<AuthCallpasswordState>(this as AuthCallpasswordState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthCallpasswordState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.confirmationSession, confirmationSession)&&(identical(other.tickerSecond, tickerSecond) || other.tickerSecond == tickerSecond)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.hasCloudPassword, hasCloudPassword) || other.hasCloudPassword == hasCloudPassword));
}


@override
int get hashCode => Object.hash(runtimeType,status,error,const DeepCollectionEquality().hash(confirmationSession),tickerSecond,isBlocked,hasCloudPassword);

@override
String toString() {
  return 'AuthCallpasswordState(status: $status, error: $error, confirmationSession: $confirmationSession, tickerSecond: $tickerSecond, isBlocked: $isBlocked, hasCloudPassword: $hasCloudPassword)';
}


}

/// @nodoc
abstract mixin class $AuthCallpasswordStateCopyWith<$Res>  {
  factory $AuthCallpasswordStateCopyWith(AuthCallpasswordState value, $Res Function(AuthCallpasswordState) _then) = _$AuthCallpasswordStateCopyWithImpl;
@useResult
$Res call({
 Status status, String error, List<int> confirmationSession, int tickerSecond, bool isBlocked, bool hasCloudPassword
});




}
/// @nodoc
class _$AuthCallpasswordStateCopyWithImpl<$Res>
    implements $AuthCallpasswordStateCopyWith<$Res> {
  _$AuthCallpasswordStateCopyWithImpl(this._self, this._then);

  final AuthCallpasswordState _self;
  final $Res Function(AuthCallpasswordState) _then;

/// Create a copy of AuthCallpasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? error = null,Object? confirmationSession = null,Object? tickerSecond = null,Object? isBlocked = null,Object? hasCloudPassword = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,confirmationSession: null == confirmationSession ? _self.confirmationSession : confirmationSession // ignore: cast_nullable_to_non_nullable
as List<int>,tickerSecond: null == tickerSecond ? _self.tickerSecond : tickerSecond // ignore: cast_nullable_to_non_nullable
as int,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,hasCloudPassword: null == hasCloudPassword ? _self.hasCloudPassword : hasCloudPassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthCallpasswordState].
extension AuthCallpasswordStatePatterns on AuthCallpasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthCallpasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthCallpasswordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthCallpasswordState value)  $default,){
final _that = this;
switch (_that) {
case _AuthCallpasswordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthCallpasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthCallpasswordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status status,  String error,  List<int> confirmationSession,  int tickerSecond,  bool isBlocked,  bool hasCloudPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthCallpasswordState() when $default != null:
return $default(_that.status,_that.error,_that.confirmationSession,_that.tickerSecond,_that.isBlocked,_that.hasCloudPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status status,  String error,  List<int> confirmationSession,  int tickerSecond,  bool isBlocked,  bool hasCloudPassword)  $default,) {final _that = this;
switch (_that) {
case _AuthCallpasswordState():
return $default(_that.status,_that.error,_that.confirmationSession,_that.tickerSecond,_that.isBlocked,_that.hasCloudPassword);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc


class _AuthCallpasswordState implements AuthCallpasswordState {
  const _AuthCallpasswordState({this.status = Status.initialization, this.error = "", final  List<int> confirmationSession = const [], this.tickerSecond = 0, this.isBlocked = false, this.hasCloudPassword = false}): _confirmationSession = confirmationSession;
  

@override@JsonKey() final  Status status;
@override@JsonKey() final  String error;
 final  List<int> _confirmationSession;
@override@JsonKey() List<int> get confirmationSession {
  if (_confirmationSession is EqualUnmodifiableListView) return _confirmationSession;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_confirmationSession);
}

@override@JsonKey() final  int tickerSecond;
@override@JsonKey() final  bool isBlocked;
@override@JsonKey() final  bool hasCloudPassword;

/// Create a copy of AuthCallpasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthCallpasswordStateCopyWith<_AuthCallpasswordState> get copyWith => __$AuthCallpasswordStateCopyWithImpl<_AuthCallpasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthCallpasswordState&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other._confirmationSession, _confirmationSession)&&(identical(other.tickerSecond, tickerSecond) || other.tickerSecond == tickerSecond)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.hasCloudPassword, hasCloudPassword) || other.hasCloudPassword == hasCloudPassword));
}


@override
int get hashCode => Object.hash(runtimeType,status,error,const DeepCollectionEquality().hash(_confirmationSession),tickerSecond,isBlocked,hasCloudPassword);

@override
String toString() {
  return 'AuthCallpasswordState(status: $status, error: $error, confirmationSession: $confirmationSession, tickerSecond: $tickerSecond, isBlocked: $isBlocked, hasCloudPassword: $hasCloudPassword)';
}


}

/// @nodoc
abstract mixin class _$AuthCallpasswordStateCopyWith<$Res> implements $AuthCallpasswordStateCopyWith<$Res> {
  factory _$AuthCallpasswordStateCopyWith(_AuthCallpasswordState value, $Res Function(_AuthCallpasswordState) _then) = __$AuthCallpasswordStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, String error, List<int> confirmationSession, int tickerSecond, bool isBlocked, bool hasCloudPassword
});




}
/// @nodoc
class __$AuthCallpasswordStateCopyWithImpl<$Res>
    implements _$AuthCallpasswordStateCopyWith<$Res> {
  __$AuthCallpasswordStateCopyWithImpl(this._self, this._then);

  final _AuthCallpasswordState _self;
  final $Res Function(_AuthCallpasswordState) _then;

/// Create a copy of AuthCallpasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? error = null,Object? confirmationSession = null,Object? tickerSecond = null,Object? isBlocked = null,Object? hasCloudPassword = null,}) {
  return _then(_AuthCallpasswordState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,confirmationSession: null == confirmationSession ? _self._confirmationSession : confirmationSession // ignore: cast_nullable_to_non_nullable
as List<int>,tickerSecond: null == tickerSecond ? _self.tickerSecond : tickerSecond // ignore: cast_nullable_to_non_nullable
as int,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,hasCloudPassword: null == hasCloudPassword ? _self.hasCloudPassword : hasCloudPassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
