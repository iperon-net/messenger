// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User implements DiagnosticableTreeMixin {

 String get userID; String get phoneNumber; List<int> get session; List<SharedKey> get sharedKeys;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'User'))
    ..add(DiagnosticsProperty('userID', userID))..add(DiagnosticsProperty('phoneNumber', phoneNumber))..add(DiagnosticsProperty('session', session))..add(DiagnosticsProperty('sharedKeys', sharedKeys));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.userID, userID) || other.userID == userID)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&const DeepCollectionEquality().equals(other.session, session)&&const DeepCollectionEquality().equals(other.sharedKeys, sharedKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userID,phoneNumber,const DeepCollectionEquality().hash(session),const DeepCollectionEquality().hash(sharedKeys));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'User(userID: $userID, phoneNumber: $phoneNumber, session: $session, sharedKeys: $sharedKeys)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String userID, String phoneNumber, List<int> session, List<SharedKey> sharedKeys
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userID = null,Object? phoneNumber = null,Object? session = null,Object? sharedKeys = null,}) {
  return _then(_self.copyWith(
userID: null == userID ? _self.userID : userID // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as List<int>,sharedKeys: null == sharedKeys ? _self.sharedKeys : sharedKeys // ignore: cast_nullable_to_non_nullable
as List<SharedKey>,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userID,  String phoneNumber,  List<int> session,  List<SharedKey> sharedKeys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.userID,_that.phoneNumber,_that.session,_that.sharedKeys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userID,  String phoneNumber,  List<int> session,  List<SharedKey> sharedKeys)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.userID,_that.phoneNumber,_that.session,_that.sharedKeys);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc
@JsonSerializable()

class _User extends User with DiagnosticableTreeMixin {
  const _User({this.userID = "", this.phoneNumber = "", final  List<int> session = const [], final  List<SharedKey> sharedKeys = const []}): _session = session,_sharedKeys = sharedKeys,super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@JsonKey() final  String userID;
@override@JsonKey() final  String phoneNumber;
 final  List<int> _session;
@override@JsonKey() List<int> get session {
  if (_session is EqualUnmodifiableListView) return _session;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_session);
}

 final  List<SharedKey> _sharedKeys;
@override@JsonKey() List<SharedKey> get sharedKeys {
  if (_sharedKeys is EqualUnmodifiableListView) return _sharedKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedKeys);
}


/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'User'))
    ..add(DiagnosticsProperty('userID', userID))..add(DiagnosticsProperty('phoneNumber', phoneNumber))..add(DiagnosticsProperty('session', session))..add(DiagnosticsProperty('sharedKeys', sharedKeys));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.userID, userID) || other.userID == userID)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&const DeepCollectionEquality().equals(other._session, _session)&&const DeepCollectionEquality().equals(other._sharedKeys, _sharedKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userID,phoneNumber,const DeepCollectionEquality().hash(_session),const DeepCollectionEquality().hash(_sharedKeys));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'User(userID: $userID, phoneNumber: $phoneNumber, session: $session, sharedKeys: $sharedKeys)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String userID, String phoneNumber, List<int> session, List<SharedKey> sharedKeys
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userID = null,Object? phoneNumber = null,Object? session = null,Object? sharedKeys = null,}) {
  return _then(_User(
userID: null == userID ? _self.userID : userID // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,session: null == session ? _self._session : session // ignore: cast_nullable_to_non_nullable
as List<int>,sharedKeys: null == sharedKeys ? _self._sharedKeys : sharedKeys // ignore: cast_nullable_to_non_nullable
as List<SharedKey>,
  ));
}


}


/// @nodoc
mixin _$SharedKey implements DiagnosticableTreeMixin {

 String get sharedKeyID; List<int> get sharedKey; DateTime? get expiredAt;
/// Create a copy of SharedKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedKeyCopyWith<SharedKey> get copyWith => _$SharedKeyCopyWithImpl<SharedKey>(this as SharedKey, _$identity);

  /// Serializes this SharedKey to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SharedKey'))
    ..add(DiagnosticsProperty('sharedKeyID', sharedKeyID))..add(DiagnosticsProperty('sharedKey', sharedKey))..add(DiagnosticsProperty('expiredAt', expiredAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedKey&&(identical(other.sharedKeyID, sharedKeyID) || other.sharedKeyID == sharedKeyID)&&const DeepCollectionEquality().equals(other.sharedKey, sharedKey)&&(identical(other.expiredAt, expiredAt) || other.expiredAt == expiredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sharedKeyID,const DeepCollectionEquality().hash(sharedKey),expiredAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SharedKey(sharedKeyID: $sharedKeyID, sharedKey: $sharedKey, expiredAt: $expiredAt)';
}


}

/// @nodoc
abstract mixin class $SharedKeyCopyWith<$Res>  {
  factory $SharedKeyCopyWith(SharedKey value, $Res Function(SharedKey) _then) = _$SharedKeyCopyWithImpl;
@useResult
$Res call({
 String sharedKeyID, List<int> sharedKey, DateTime? expiredAt
});




}
/// @nodoc
class _$SharedKeyCopyWithImpl<$Res>
    implements $SharedKeyCopyWith<$Res> {
  _$SharedKeyCopyWithImpl(this._self, this._then);

  final SharedKey _self;
  final $Res Function(SharedKey) _then;

/// Create a copy of SharedKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sharedKeyID = null,Object? sharedKey = null,Object? expiredAt = freezed,}) {
  return _then(_self.copyWith(
sharedKeyID: null == sharedKeyID ? _self.sharedKeyID : sharedKeyID // ignore: cast_nullable_to_non_nullable
as String,sharedKey: null == sharedKey ? _self.sharedKey : sharedKey // ignore: cast_nullable_to_non_nullable
as List<int>,expiredAt: freezed == expiredAt ? _self.expiredAt : expiredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedKey].
extension SharedKeyPatterns on SharedKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedKey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedKey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedKey value)  $default,){
final _that = this;
switch (_that) {
case _SharedKey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedKey value)?  $default,){
final _that = this;
switch (_that) {
case _SharedKey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sharedKeyID,  List<int> sharedKey,  DateTime? expiredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedKey() when $default != null:
return $default(_that.sharedKeyID,_that.sharedKey,_that.expiredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sharedKeyID,  List<int> sharedKey,  DateTime? expiredAt)  $default,) {final _that = this;
switch (_that) {
case _SharedKey():
return $default(_that.sharedKeyID,_that.sharedKey,_that.expiredAt);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc
@JsonSerializable()

class _SharedKey extends SharedKey with DiagnosticableTreeMixin {
  const _SharedKey({this.sharedKeyID = "", final  List<int> sharedKey = const [], this.expiredAt}): _sharedKey = sharedKey,super._();
  factory _SharedKey.fromJson(Map<String, dynamic> json) => _$SharedKeyFromJson(json);

@override@JsonKey() final  String sharedKeyID;
 final  List<int> _sharedKey;
@override@JsonKey() List<int> get sharedKey {
  if (_sharedKey is EqualUnmodifiableListView) return _sharedKey;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedKey);
}

@override final  DateTime? expiredAt;

/// Create a copy of SharedKey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedKeyCopyWith<_SharedKey> get copyWith => __$SharedKeyCopyWithImpl<_SharedKey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedKeyToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SharedKey'))
    ..add(DiagnosticsProperty('sharedKeyID', sharedKeyID))..add(DiagnosticsProperty('sharedKey', sharedKey))..add(DiagnosticsProperty('expiredAt', expiredAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedKey&&(identical(other.sharedKeyID, sharedKeyID) || other.sharedKeyID == sharedKeyID)&&const DeepCollectionEquality().equals(other._sharedKey, _sharedKey)&&(identical(other.expiredAt, expiredAt) || other.expiredAt == expiredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sharedKeyID,const DeepCollectionEquality().hash(_sharedKey),expiredAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SharedKey(sharedKeyID: $sharedKeyID, sharedKey: $sharedKey, expiredAt: $expiredAt)';
}


}

/// @nodoc
abstract mixin class _$SharedKeyCopyWith<$Res> implements $SharedKeyCopyWith<$Res> {
  factory _$SharedKeyCopyWith(_SharedKey value, $Res Function(_SharedKey) _then) = __$SharedKeyCopyWithImpl;
@override @useResult
$Res call({
 String sharedKeyID, List<int> sharedKey, DateTime? expiredAt
});




}
/// @nodoc
class __$SharedKeyCopyWithImpl<$Res>
    implements _$SharedKeyCopyWith<$Res> {
  __$SharedKeyCopyWithImpl(this._self, this._then);

  final _SharedKey _self;
  final $Res Function(_SharedKey) _then;

/// Create a copy of SharedKey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sharedKeyID = null,Object? sharedKey = null,Object? expiredAt = freezed,}) {
  return _then(_SharedKey(
sharedKeyID: null == sharedKeyID ? _self.sharedKeyID : sharedKeyID // ignore: cast_nullable_to_non_nullable
as String,sharedKey: null == sharedKey ? _self._sharedKey : sharedKey // ignore: cast_nullable_to_non_nullable
as List<int>,expiredAt: freezed == expiredAt ? _self.expiredAt : expiredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
