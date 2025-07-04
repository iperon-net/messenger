// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Contact {

 String get contactId; String get accountId; String? get userId; String get lastName; String get firstName; int get phone; int get lastVisitAt;
/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactCopyWith<Contact> get copyWith => _$ContactCopyWithImpl<Contact>(this as Contact, _$identity);

  /// Serializes this Contact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Contact&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.lastVisitAt, lastVisitAt) || other.lastVisitAt == lastVisitAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contactId,accountId,userId,lastName,firstName,phone,lastVisitAt);

@override
String toString() {
  return 'Contact(contactId: $contactId, accountId: $accountId, userId: $userId, lastName: $lastName, firstName: $firstName, phone: $phone, lastVisitAt: $lastVisitAt)';
}


}

/// @nodoc
abstract mixin class $ContactCopyWith<$Res>  {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) _then) = _$ContactCopyWithImpl;
@useResult
$Res call({
 String contactId, String accountId, String? userId, String lastName, String firstName, int phone, int lastVisitAt
});




}
/// @nodoc
class _$ContactCopyWithImpl<$Res>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._self, this._then);

  final Contact _self;
  final $Res Function(Contact) _then;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contactId = null,Object? accountId = null,Object? userId = freezed,Object? lastName = null,Object? firstName = null,Object? phone = null,Object? lastVisitAt = null,}) {
  return _then(_self.copyWith(
contactId: null == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as int,lastVisitAt: null == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Contact].
extension ContactPatterns on Contact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Contact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Contact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Contact value)  $default,){
final _that = this;
switch (_that) {
case _Contact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Contact value)?  $default,){
final _that = this;
switch (_that) {
case _Contact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contactId,  String accountId,  String? userId,  String lastName,  String firstName,  int phone,  int lastVisitAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Contact() when $default != null:
return $default(_that.contactId,_that.accountId,_that.userId,_that.lastName,_that.firstName,_that.phone,_that.lastVisitAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contactId,  String accountId,  String? userId,  String lastName,  String firstName,  int phone,  int lastVisitAt)  $default,) {final _that = this;
switch (_that) {
case _Contact():
return $default(_that.contactId,_that.accountId,_that.userId,_that.lastName,_that.firstName,_that.phone,_that.lastVisitAt);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Contact extends Contact {
  const _Contact({required this.contactId, required this.accountId, required this.userId, required this.lastName, required this.firstName, required this.phone, this.lastVisitAt = 0}): super._();
  factory _Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

@override final  String contactId;
@override final  String accountId;
@override final  String? userId;
@override final  String lastName;
@override final  String firstName;
@override final  int phone;
@override@JsonKey() final  int lastVisitAt;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactCopyWith<_Contact> get copyWith => __$ContactCopyWithImpl<_Contact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Contact&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.lastVisitAt, lastVisitAt) || other.lastVisitAt == lastVisitAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contactId,accountId,userId,lastName,firstName,phone,lastVisitAt);

@override
String toString() {
  return 'Contact(contactId: $contactId, accountId: $accountId, userId: $userId, lastName: $lastName, firstName: $firstName, phone: $phone, lastVisitAt: $lastVisitAt)';
}


}

/// @nodoc
abstract mixin class _$ContactCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$ContactCopyWith(_Contact value, $Res Function(_Contact) _then) = __$ContactCopyWithImpl;
@override @useResult
$Res call({
 String contactId, String accountId, String? userId, String lastName, String firstName, int phone, int lastVisitAt
});




}
/// @nodoc
class __$ContactCopyWithImpl<$Res>
    implements _$ContactCopyWith<$Res> {
  __$ContactCopyWithImpl(this._self, this._then);

  final _Contact _self;
  final $Res Function(_Contact) _then;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contactId = null,Object? accountId = null,Object? userId = freezed,Object? lastName = null,Object? firstName = null,Object? phone = null,Object? lastVisitAt = null,}) {
  return _then(_Contact(
contactId: null == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as int,lastVisitAt: null == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ContactTabs {

 String get contactTabsId; String get name; int get sort; bool get isSystem; String get systemName;
/// Create a copy of ContactTabs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactTabsCopyWith<ContactTabs> get copyWith => _$ContactTabsCopyWithImpl<ContactTabs>(this as ContactTabs, _$identity);

  /// Serializes this ContactTabs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactTabs&&(identical(other.contactTabsId, contactTabsId) || other.contactTabsId == contactTabsId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.systemName, systemName) || other.systemName == systemName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contactTabsId,name,sort,isSystem,systemName);

@override
String toString() {
  return 'ContactTabs(contactTabsId: $contactTabsId, name: $name, sort: $sort, isSystem: $isSystem, systemName: $systemName)';
}


}

/// @nodoc
abstract mixin class $ContactTabsCopyWith<$Res>  {
  factory $ContactTabsCopyWith(ContactTabs value, $Res Function(ContactTabs) _then) = _$ContactTabsCopyWithImpl;
@useResult
$Res call({
 String contactTabsId, String name, int sort, bool isSystem, String systemName
});




}
/// @nodoc
class _$ContactTabsCopyWithImpl<$Res>
    implements $ContactTabsCopyWith<$Res> {
  _$ContactTabsCopyWithImpl(this._self, this._then);

  final ContactTabs _self;
  final $Res Function(ContactTabs) _then;

/// Create a copy of ContactTabs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contactTabsId = null,Object? name = null,Object? sort = null,Object? isSystem = null,Object? systemName = null,}) {
  return _then(_self.copyWith(
contactTabsId: null == contactTabsId ? _self.contactTabsId : contactTabsId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as int,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,systemName: null == systemName ? _self.systemName : systemName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactTabs].
extension ContactTabsPatterns on ContactTabs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactTabs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactTabs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactTabs value)  $default,){
final _that = this;
switch (_that) {
case _ContactTabs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactTabs value)?  $default,){
final _that = this;
switch (_that) {
case _ContactTabs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contactTabsId,  String name,  int sort,  bool isSystem,  String systemName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactTabs() when $default != null:
return $default(_that.contactTabsId,_that.name,_that.sort,_that.isSystem,_that.systemName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contactTabsId,  String name,  int sort,  bool isSystem,  String systemName)  $default,) {final _that = this;
switch (_that) {
case _ContactTabs():
return $default(_that.contactTabsId,_that.name,_that.sort,_that.isSystem,_that.systemName);case _:
  throw StateError('Unexpected subclass');

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ContactTabs extends ContactTabs {
  const _ContactTabs({required this.contactTabsId, required this.name, required this.sort, this.isSystem = false, this.systemName = ""}): super._();
  factory _ContactTabs.fromJson(Map<String, dynamic> json) => _$ContactTabsFromJson(json);

@override final  String contactTabsId;
@override final  String name;
@override final  int sort;
@override@JsonKey() final  bool isSystem;
@override@JsonKey() final  String systemName;

/// Create a copy of ContactTabs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactTabsCopyWith<_ContactTabs> get copyWith => __$ContactTabsCopyWithImpl<_ContactTabs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactTabsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactTabs&&(identical(other.contactTabsId, contactTabsId) || other.contactTabsId == contactTabsId)&&(identical(other.name, name) || other.name == name)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.systemName, systemName) || other.systemName == systemName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contactTabsId,name,sort,isSystem,systemName);

@override
String toString() {
  return 'ContactTabs(contactTabsId: $contactTabsId, name: $name, sort: $sort, isSystem: $isSystem, systemName: $systemName)';
}


}

/// @nodoc
abstract mixin class _$ContactTabsCopyWith<$Res> implements $ContactTabsCopyWith<$Res> {
  factory _$ContactTabsCopyWith(_ContactTabs value, $Res Function(_ContactTabs) _then) = __$ContactTabsCopyWithImpl;
@override @useResult
$Res call({
 String contactTabsId, String name, int sort, bool isSystem, String systemName
});




}
/// @nodoc
class __$ContactTabsCopyWithImpl<$Res>
    implements _$ContactTabsCopyWith<$Res> {
  __$ContactTabsCopyWithImpl(this._self, this._then);

  final _ContactTabs _self;
  final $Res Function(_ContactTabs) _then;

/// Create a copy of ContactTabs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contactTabsId = null,Object? name = null,Object? sort = null,Object? isSystem = null,Object? systemName = null,}) {
  return _then(_ContactTabs(
contactTabsId: null == contactTabsId ? _self.contactTabsId : contactTabsId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as int,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,systemName: null == systemName ? _self.systemName : systemName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
