// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 Status get status; String get errorMessage; String get versionApplication; String get languageName;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.versionApplication, versionApplication) || other.versionApplication == versionApplication)&&(identical(other.languageName, languageName) || other.languageName == languageName));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,versionApplication,languageName);

@override
String toString() {
  return 'SettingsState(status: $status, errorMessage: $errorMessage, versionApplication: $versionApplication, languageName: $languageName)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 Status status, String errorMessage, String versionApplication, String languageName
});




}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? errorMessage = null,Object? versionApplication = null,Object? languageName = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,versionApplication: null == versionApplication ? _self.versionApplication : versionApplication // ignore: cast_nullable_to_non_nullable
as String,languageName: null == languageName ? _self.languageName : languageName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _SettingsState extends SettingsState {
  const _SettingsState({this.status = Status.initial, this.errorMessage = "", this.versionApplication = "", this.languageName = "English"}): super._();
  

@override@JsonKey() final  Status status;
@override@JsonKey() final  String errorMessage;
@override@JsonKey() final  String versionApplication;
@override@JsonKey() final  String languageName;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.versionApplication, versionApplication) || other.versionApplication == versionApplication)&&(identical(other.languageName, languageName) || other.languageName == languageName));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage,versionApplication,languageName);

@override
String toString() {
  return 'SettingsState(status: $status, errorMessage: $errorMessage, versionApplication: $versionApplication, languageName: $languageName)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 Status status, String errorMessage, String versionApplication, String languageName
});




}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? errorMessage = null,Object? versionApplication = null,Object? languageName = null,}) {
  return _then(_SettingsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,versionApplication: null == versionApplication ? _self.versionApplication : versionApplication // ignore: cast_nullable_to_non_nullable
as String,languageName: null == languageName ? _self.languageName : languageName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
