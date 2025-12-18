// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MainState {

 Status get loadingStatus; Status get processingStatus; String get error;
/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainStateCopyWith<MainState> get copyWith => _$MainStateCopyWithImpl<MainState>(this as MainState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainState&&(identical(other.loadingStatus, loadingStatus) || other.loadingStatus == loadingStatus)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStatus,processingStatus,error);

@override
String toString() {
  return 'MainState(loadingStatus: $loadingStatus, processingStatus: $processingStatus, error: $error)';
}


}

/// @nodoc
abstract mixin class $MainStateCopyWith<$Res>  {
  factory $MainStateCopyWith(MainState value, $Res Function(MainState) _then) = _$MainStateCopyWithImpl;
@useResult
$Res call({
 Status loadingStatus, Status processingStatus, String error
});




}
/// @nodoc
class _$MainStateCopyWithImpl<$Res>
    implements $MainStateCopyWith<$Res> {
  _$MainStateCopyWithImpl(this._self, this._then);

  final MainState _self;
  final $Res Function(MainState) _then;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingStatus = null,Object? processingStatus = null,Object? error = null,}) {
  return _then(_self.copyWith(
loadingStatus: null == loadingStatus ? _self.loadingStatus : loadingStatus // ignore: cast_nullable_to_non_nullable
as Status,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MainState].
extension MainStatePatterns on MainState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MainState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MainState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MainState value)  $default,){
final _that = this;
switch (_that) {
case _MainState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MainState value)?  $default,){
final _that = this;
switch (_that) {
case _MainState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status loadingStatus,  Status processingStatus,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MainState() when $default != null:
return $default(_that.loadingStatus,_that.processingStatus,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status loadingStatus,  Status processingStatus,  String error)  $default,) {final _that = this;
switch (_that) {
case _MainState():
return $default(_that.loadingStatus,_that.processingStatus,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Status loadingStatus,  Status processingStatus,  String error)?  $default,) {final _that = this;
switch (_that) {
case _MainState() when $default != null:
return $default(_that.loadingStatus,_that.processingStatus,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _MainState implements MainState {
  const _MainState({this.loadingStatus = Status.initialization, this.processingStatus = Status.initialization, this.error = ""});
  

@override@JsonKey() final  Status loadingStatus;
@override@JsonKey() final  Status processingStatus;
@override@JsonKey() final  String error;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainStateCopyWith<_MainState> get copyWith => __$MainStateCopyWithImpl<_MainState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainState&&(identical(other.loadingStatus, loadingStatus) || other.loadingStatus == loadingStatus)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStatus,processingStatus,error);

@override
String toString() {
  return 'MainState(loadingStatus: $loadingStatus, processingStatus: $processingStatus, error: $error)';
}


}

/// @nodoc
abstract mixin class _$MainStateCopyWith<$Res> implements $MainStateCopyWith<$Res> {
  factory _$MainStateCopyWith(_MainState value, $Res Function(_MainState) _then) = __$MainStateCopyWithImpl;
@override @useResult
$Res call({
 Status loadingStatus, Status processingStatus, String error
});




}
/// @nodoc
class __$MainStateCopyWithImpl<$Res>
    implements _$MainStateCopyWith<$Res> {
  __$MainStateCopyWithImpl(this._self, this._then);

  final _MainState _self;
  final $Res Function(_MainState) _then;

/// Create a copy of MainState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingStatus = null,Object? processingStatus = null,Object? error = null,}) {
  return _then(_MainState(
loadingStatus: null == loadingStatus ? _self.loadingStatus : loadingStatus // ignore: cast_nullable_to_non_nullable
as Status,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as Status,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
