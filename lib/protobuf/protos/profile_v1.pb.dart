// This is a generated file - do not edit.
//
// Generated from protos/profile_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'models.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Profile_Request extends $pb.GeneratedMessage {
  factory Profile_Request() => create();

  Profile_Request._();

  factory Profile_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Profile_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Profile.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile_Request copyWith(void Function(Profile_Request) updates) =>
      super.copyWith((message) => updates(message as Profile_Request)) as Profile_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Profile_Request create() => Profile_Request._();
  @$core.override
  Profile_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Profile_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Profile_Request>(create);
  static Profile_Request? _defaultInstance;
}

class Profile_Response extends $pb.GeneratedMessage {
  factory Profile_Response({
    $core.String? firstName,
    $core.String? lastName,
    $0.Date? dateBirth,
    $core.String? aboutMe,
  }) {
    final result = create();
    if (firstName != null) result.firstName = firstName;
    if (lastName != null) result.lastName = lastName;
    if (dateBirth != null) result.dateBirth = dateBirth;
    if (aboutMe != null) result.aboutMe = aboutMe;
    return result;
  }

  Profile_Response._();

  factory Profile_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Profile_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Profile.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'firstName', protoName: 'firstName')
    ..aOS(2, _omitFieldNames ? '' : 'lastName', protoName: 'lastName')
    ..aOM<$0.Date>(3, _omitFieldNames ? '' : 'dateBirth', protoName: 'dateBirth', subBuilder: $0.Date.create)
    ..aOS(4, _omitFieldNames ? '' : 'aboutMe', protoName: 'aboutMe')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile_Response copyWith(void Function(Profile_Response) updates) =>
      super.copyWith((message) => updates(message as Profile_Response)) as Profile_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Profile_Response create() => Profile_Response._();
  @$core.override
  Profile_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Profile_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Profile_Response>(create);
  static Profile_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get firstName => $_getSZ(0);
  @$pb.TagNumber(1)
  set firstName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFirstName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFirstName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastName => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastName() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastName() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Date get dateBirth => $_getN(2);
  @$pb.TagNumber(3)
  set dateBirth($0.Date value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDateBirth() => $_has(2);
  @$pb.TagNumber(3)
  void clearDateBirth() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Date ensureDateBirth() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get aboutMe => $_getSZ(3);
  @$pb.TagNumber(4)
  set aboutMe($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAboutMe() => $_has(3);
  @$pb.TagNumber(4)
  void clearAboutMe() => $_clearField(4);
}

class Profile extends $pb.GeneratedMessage {
  factory Profile() => create();

  Profile._();

  factory Profile.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Profile.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Profile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile copyWith(void Function(Profile) updates) => super.copyWith((message) => updates(message as Profile)) as Profile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Profile create() => Profile._();
  @$core.override
  Profile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Profile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Profile>(create);
  static Profile? _defaultInstance;
}

class ProfileEdit_Request extends $pb.GeneratedMessage {
  factory ProfileEdit_Request({
    $core.String? firstName,
    $core.String? lastName,
    $0.Date? dateBirth,
    $core.String? aboutMe,
  }) {
    final result = create();
    if (firstName != null) result.firstName = firstName;
    if (lastName != null) result.lastName = lastName;
    if (dateBirth != null) result.dateBirth = dateBirth;
    if (aboutMe != null) result.aboutMe = aboutMe;
    return result;
  }

  ProfileEdit_Request._();

  factory ProfileEdit_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProfileEdit_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProfileEdit.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'firstName', protoName: 'firstName')
    ..aOS(2, _omitFieldNames ? '' : 'lastName', protoName: 'lastName')
    ..aOM<$0.Date>(3, _omitFieldNames ? '' : 'dateBirth', protoName: 'dateBirth', subBuilder: $0.Date.create)
    ..aOS(4, _omitFieldNames ? '' : 'aboutMe', protoName: 'aboutMe')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileEdit_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileEdit_Request copyWith(void Function(ProfileEdit_Request) updates) =>
      super.copyWith((message) => updates(message as ProfileEdit_Request)) as ProfileEdit_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProfileEdit_Request create() => ProfileEdit_Request._();
  @$core.override
  ProfileEdit_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProfileEdit_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProfileEdit_Request>(create);
  static ProfileEdit_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get firstName => $_getSZ(0);
  @$pb.TagNumber(1)
  set firstName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFirstName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFirstName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastName => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastName() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastName() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Date get dateBirth => $_getN(2);
  @$pb.TagNumber(3)
  set dateBirth($0.Date value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDateBirth() => $_has(2);
  @$pb.TagNumber(3)
  void clearDateBirth() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Date ensureDateBirth() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get aboutMe => $_getSZ(3);
  @$pb.TagNumber(4)
  set aboutMe($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAboutMe() => $_has(3);
  @$pb.TagNumber(4)
  void clearAboutMe() => $_clearField(4);
}

class ProfileEdit_Response extends $pb.GeneratedMessage {
  factory ProfileEdit_Response() => create();

  ProfileEdit_Response._();

  factory ProfileEdit_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProfileEdit_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProfileEdit.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileEdit_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileEdit_Response copyWith(void Function(ProfileEdit_Response) updates) =>
      super.copyWith((message) => updates(message as ProfileEdit_Response)) as ProfileEdit_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProfileEdit_Response create() => ProfileEdit_Response._();
  @$core.override
  ProfileEdit_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProfileEdit_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProfileEdit_Response>(create);
  static ProfileEdit_Response? _defaultInstance;
}

class ProfileEdit extends $pb.GeneratedMessage {
  factory ProfileEdit() => create();

  ProfileEdit._();

  factory ProfileEdit.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProfileEdit.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProfileEdit',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileEdit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileEdit copyWith(void Function(ProfileEdit) updates) => super.copyWith((message) => updates(message as ProfileEdit)) as ProfileEdit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProfileEdit create() => ProfileEdit._();
  @$core.override
  ProfileEdit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProfileEdit getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProfileEdit>(create);
  static ProfileEdit? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
