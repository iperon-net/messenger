// This is a generated file - do not edit.
//
// Generated from protos/myprofile_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class MyProfile_Request extends $pb.GeneratedMessage {
  factory MyProfile_Request() => create();

  MyProfile_Request._();

  factory MyProfile_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MyProfile_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MyProfile.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfile_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfile_Request copyWith(void Function(MyProfile_Request) updates) =>
      super.copyWith((message) => updates(message as MyProfile_Request)) as MyProfile_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MyProfile_Request create() => MyProfile_Request._();
  @$core.override
  MyProfile_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MyProfile_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MyProfile_Request>(create);
  static MyProfile_Request? _defaultInstance;
}

class MyProfile_Response extends $pb.GeneratedMessage {
  factory MyProfile_Response({
    $core.String? firstName,
    $core.String? lastName,
    $0.Timestamp? birthDate,
    $core.String? aboutMe,
  }) {
    final result = create();
    if (firstName != null) result.firstName = firstName;
    if (lastName != null) result.lastName = lastName;
    if (birthDate != null) result.birthDate = birthDate;
    if (aboutMe != null) result.aboutMe = aboutMe;
    return result;
  }

  MyProfile_Response._();

  factory MyProfile_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MyProfile_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MyProfile.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'firstName', protoName: 'firstName')
    ..aOS(2, _omitFieldNames ? '' : 'lastName', protoName: 'lastName')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'birthDate', protoName: 'birthDate', subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'aboutMe', protoName: 'aboutMe')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfile_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfile_Response copyWith(void Function(MyProfile_Response) updates) =>
      super.copyWith((message) => updates(message as MyProfile_Response)) as MyProfile_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MyProfile_Response create() => MyProfile_Response._();
  @$core.override
  MyProfile_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MyProfile_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MyProfile_Response>(create);
  static MyProfile_Response? _defaultInstance;

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
  $0.Timestamp get birthDate => $_getN(2);
  @$pb.TagNumber(3)
  set birthDate($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBirthDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearBirthDate() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureBirthDate() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get aboutMe => $_getSZ(3);
  @$pb.TagNumber(4)
  set aboutMe($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAboutMe() => $_has(3);
  @$pb.TagNumber(4)
  void clearAboutMe() => $_clearField(4);
}

class MyProfile extends $pb.GeneratedMessage {
  factory MyProfile() => create();

  MyProfile._();

  factory MyProfile.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MyProfile.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MyProfile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfile copyWith(void Function(MyProfile) updates) => super.copyWith((message) => updates(message as MyProfile)) as MyProfile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MyProfile create() => MyProfile._();
  @$core.override
  MyProfile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MyProfile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MyProfile>(create);
  static MyProfile? _defaultInstance;
}

class MyProfileUpdate_Request extends $pb.GeneratedMessage {
  factory MyProfileUpdate_Request({
    $core.String? firstName,
    $core.String? lastName,
    $0.Timestamp? birthDate,
    $core.String? aboutMe,
  }) {
    final result = create();
    if (firstName != null) result.firstName = firstName;
    if (lastName != null) result.lastName = lastName;
    if (birthDate != null) result.birthDate = birthDate;
    if (aboutMe != null) result.aboutMe = aboutMe;
    return result;
  }

  MyProfileUpdate_Request._();

  factory MyProfileUpdate_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MyProfileUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MyProfileUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'firstName', protoName: 'firstName')
    ..aOS(2, _omitFieldNames ? '' : 'lastName', protoName: 'lastName')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'birthDate', protoName: 'birthDate', subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'aboutMe', protoName: 'aboutMe')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileUpdate_Request copyWith(void Function(MyProfileUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as MyProfileUpdate_Request)) as MyProfileUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MyProfileUpdate_Request create() => MyProfileUpdate_Request._();
  @$core.override
  MyProfileUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MyProfileUpdate_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MyProfileUpdate_Request>(create);
  static MyProfileUpdate_Request? _defaultInstance;

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
  $0.Timestamp get birthDate => $_getN(2);
  @$pb.TagNumber(3)
  set birthDate($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBirthDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearBirthDate() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureBirthDate() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get aboutMe => $_getSZ(3);
  @$pb.TagNumber(4)
  set aboutMe($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAboutMe() => $_has(3);
  @$pb.TagNumber(4)
  void clearAboutMe() => $_clearField(4);
}

class MyProfileUpdate_Response extends $pb.GeneratedMessage {
  factory MyProfileUpdate_Response() => create();

  MyProfileUpdate_Response._();

  factory MyProfileUpdate_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MyProfileUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MyProfileUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileUpdate_Response copyWith(void Function(MyProfileUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as MyProfileUpdate_Response)) as MyProfileUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MyProfileUpdate_Response create() => MyProfileUpdate_Response._();
  @$core.override
  MyProfileUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MyProfileUpdate_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MyProfileUpdate_Response>(create);
  static MyProfileUpdate_Response? _defaultInstance;
}

class MyProfileUpdate extends $pb.GeneratedMessage {
  factory MyProfileUpdate() => create();

  MyProfileUpdate._();

  factory MyProfileUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MyProfileUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MyProfileUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileUpdate copyWith(void Function(MyProfileUpdate) updates) =>
      super.copyWith((message) => updates(message as MyProfileUpdate)) as MyProfileUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MyProfileUpdate create() => MyProfileUpdate._();
  @$core.override
  MyProfileUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MyProfileUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MyProfileUpdate>(create);
  static MyProfileUpdate? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
