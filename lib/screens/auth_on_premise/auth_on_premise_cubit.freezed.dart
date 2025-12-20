// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_on_premise_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthOnPremiseState {

 Status get status; Status get executeStatus; bool get debugListServers; String get errorFieldOrganizationServerUrl; String get error;
/// Create a copy of AuthOnPremiseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthOnPremiseStateCopyWith<AuthOnPremiseState> get copyWith => _$AuthOnPremiseStateCopyWithImpl<AuthOnPremiseState>(this as AuthOnPremiseState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthOnPremiseState&&(identical(other.status, status) || other.status == status)&&(identical(other.executeStatus, executeStatus) || other.executeStatus == executeStatus)&&(identical(other.debugListServers, debugListServers) || other.debugListServers == debugListServers)&&(identical(other.errorFieldOrganizationServerUrl, errorFieldOrganizationServerUrl) || other.errorFieldOrganizationServerUrl == errorFieldOrganizationServerUrl)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,executeStatus,debugListServers,errorFieldOrganizationServerUrl,error);

@override
String toString() {
  return 'AuthOnPremiseState(status: $status, executeStatus: $executeStatus, debugListServers: $debugListServers, errorFieldOrganizationServerUrl: $errorFieldOrganizationServerUrl, error: $error)';
}


}

/// @nodoc
abstract mixin class $AuthOnPremiseStateCopyWith<$Res>  {
  factory $AuthOnPremiseStateCopyWith(AuthOnPremiseState value, $Res Function(AuthOnPremiseState) _then) = _$AuthOnPremiseStateCopyWithImpl;
@useResult
$Res call({
 Status status, Status executeStatus, bool debugListServers, String errorFieldOrganizationServerUrl, String error
});




}
/// @nodoc
class _$AuthOnPremiseStateCopyWithImpl<$Res>
    implements $AuthOnPremiseStateCopyWith<$Res> {
  _$AuthOnPremiseStateCopyWithImpl(this._self, this._then);

  final AuthOnPremiseState _self;
  final $Res Function(AuthOnPremiseState) _then;

/// Create a copy of AuthOnPremiseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? executeStatus = null,Object? debugListServers = null,Object? errorFieldOrganizationServerUrl = null,Object? error = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,executeStatus: null == executeStatus ? _self.executeStatus : executeStatus // ignore: cast_nullable_to_non_nullable
as Status,debugListServers: null == debugListServers ? _self.debugListServers : debugListServers // ignore: cast_nullable_to_non_nullable
as bool,errorFieldOrganizationServerUrl: null == errorFieldOrganizationServerUrl ? _self.errorFieldOrganizationServerUrl : errorFieldOrganizationServerUrl // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthOnPremiseState].
extension AuthOnPremiseStatePatterns on AuthOnPremiseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthOnPremiseState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthOnPremiseState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthOnPremiseState value)  $default,){
final _that = this;
switch (_that) {
case _AuthOnPremiseState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthOnPremiseState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthOnPremiseState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status status,  Status executeStatus,  bool debugListServers,  String errorFieldOrganizationServerUrl,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthOnPremiseState() when $default != null:
return $default(_that.status,_that.executeStatus,_that.debugListServers,_that.errorFieldOrganizationServerUrl,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status status,  Status executeStatus,  bool debugListServers,  String errorFieldOrganizationServerUrl,  String error)  $default,) {final _that = this;
switch (_that) {
case _AuthOnPremiseState():
return $default(_that.status,_that.executeStatus,_that.debugListServers,_that.errorFieldOrganizationServerUrl,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc


class _AuthOnPremiseState implements AuthOnPremiseState {
  const _AuthOnPremiseState({this.status = Status.initialization, this.executeStatus = Status.initialization, this.debugListServers = false, this.errorFieldOrganizationServerUrl = "", this.error = ""});
  

@override@JsonKey() final  Status status;
@override@JsonKey() final  Status executeStatus;
@override@JsonKey() final  bool debugListServers;
@override@JsonKey() final  String errorFieldOrganizationServerUrl;
@override@JsonKey() final  String error;

/// Create a copy of AuthOnPremiseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthOnPremiseStateCopyWith<_AuthOnPremiseState> get copyWith => __$AuthOnPremiseStateCopyWithImpl<_AuthOnPremiseState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthOnPremiseState&&(identical(other.status, status) || other.status == status)&&(identical(other.executeStatus, executeStatus) || other.executeStatus == executeStatus)&&(identical(other.debugListServers, debugListServers) || other.debugListServers == debugListServers)&&(identical(other.errorFieldOrganizationServerUrl, errorFieldOrganizationServerUrl) || other.errorFieldOrganizationServerUrl == errorFieldOrganizationServerUrl)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,executeStatus,debugListServers,errorFieldOrganizationServerUrl,error);

@override
String toString() {
  return 'AuthOnPremiseState(status: $status, executeStatus: $executeStatus, debugListServers: $debugListServers, errorFieldOrganizationServerUrl: $errorFieldOrganizationServerUrl, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AuthOnPremiseStateCopyWith<$Res> implements $AuthOnPremiseStateCopyWith<$Res> {
  factory _$AuthOnPremiseStateCopyWith(_AuthOnPremiseState value, $Res Function(_AuthOnPremiseState) _then) = __$AuthOnPremiseStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, Status executeStatus, bool debugListServers, String errorFieldOrganizationServerUrl, String error
});




}
/// @nodoc
class __$AuthOnPremiseStateCopyWithImpl<$Res>
    implements _$AuthOnPremiseStateCopyWith<$Res> {
  __$AuthOnPremiseStateCopyWithImpl(this._self, this._then);

  final _AuthOnPremiseState _self;
  final $Res Function(_AuthOnPremiseState) _then;

/// Create a copy of AuthOnPremiseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? executeStatus = null,Object? debugListServers = null,Object? errorFieldOrganizationServerUrl = null,Object? error = null,}) {
  return _then(_AuthOnPremiseState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,executeStatus: null == executeStatus ? _self.executeStatus : executeStatus // ignore: cast_nullable_to_non_nullable
as Status,debugListServers: null == debugListServers ? _self.debugListServers : debugListServers // ignore: cast_nullable_to_non_nullable
as bool,errorFieldOrganizationServerUrl: null == errorFieldOrganizationServerUrl ? _self.errorFieldOrganizationServerUrl : errorFieldOrganizationServerUrl // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
