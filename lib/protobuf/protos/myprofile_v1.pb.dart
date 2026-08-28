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

class MyProfileEdit_Request extends $pb.GeneratedMessage {
  factory MyProfileEdit_Request({
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

  MyProfileEdit_Request._();

  factory MyProfileEdit_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MyProfileEdit_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MyProfileEdit.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'firstName', protoName: 'firstName')
    ..aOS(2, _omitFieldNames ? '' : 'lastName', protoName: 'lastName')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'birthDate', protoName: 'birthDate', subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'aboutMe', protoName: 'aboutMe')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileEdit_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileEdit_Request copyWith(void Function(MyProfileEdit_Request) updates) =>
      super.copyWith((message) => updates(message as MyProfileEdit_Request)) as MyProfileEdit_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MyProfileEdit_Request create() => MyProfileEdit_Request._();
  @$core.override
  MyProfileEdit_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MyProfileEdit_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MyProfileEdit_Request>(create);
  static MyProfileEdit_Request? _defaultInstance;

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

class MyProfileEdit_Response extends $pb.GeneratedMessage {
  factory MyProfileEdit_Response() => create();

  MyProfileEdit_Response._();

  factory MyProfileEdit_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MyProfileEdit_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MyProfileEdit.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileEdit_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileEdit_Response copyWith(void Function(MyProfileEdit_Response) updates) =>
      super.copyWith((message) => updates(message as MyProfileEdit_Response)) as MyProfileEdit_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MyProfileEdit_Response create() => MyProfileEdit_Response._();
  @$core.override
  MyProfileEdit_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MyProfileEdit_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MyProfileEdit_Response>(create);
  static MyProfileEdit_Response? _defaultInstance;
}

class MyProfileEdit extends $pb.GeneratedMessage {
  factory MyProfileEdit() => create();

  MyProfileEdit._();

  factory MyProfileEdit.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MyProfileEdit.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MyProfileEdit',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileEdit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyProfileEdit copyWith(void Function(MyProfileEdit) updates) =>
      super.copyWith((message) => updates(message as MyProfileEdit)) as MyProfileEdit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MyProfileEdit create() => MyProfileEdit._();
  @$core.override
  MyProfileEdit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MyProfileEdit getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MyProfileEdit>(create);
  static MyProfileEdit? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
