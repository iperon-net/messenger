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
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart' as $0;

import 'models.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum Profile_Request_Identifier { userID, username, notSet }

class Profile_Request extends $pb.GeneratedMessage {
  factory Profile_Request({
    $core.List<$core.int>? userID,
    $core.String? username,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (username != null) result.username = username;
    return result;
  }

  Profile_Request._();

  factory Profile_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Profile_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Profile_Request_Identifier> _Profile_Request_IdentifierByTag = {
    1: Profile_Request_Identifier.userID,
    2: Profile_Request_Identifier.username,
    0: Profile_Request_Identifier.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Profile.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'username')
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

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  Profile_Request_Identifier whichIdentifier() => _Profile_Request_IdentifierByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearIdentifier() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);
}

class Profile_Response extends $pb.GeneratedMessage {
  factory Profile_Response({
    $core.String? firstName,
    $core.String? lastName,
    $0.Timestamp? birthDate,
    $core.String? aboutMe,
    $1.CDN? avatar,
    $core.String? username,
    $core.String? phoneNumber,
    $core.List<$core.int>? userID,
  }) {
    final result = create();
    if (firstName != null) result.firstName = firstName;
    if (lastName != null) result.lastName = lastName;
    if (birthDate != null) result.birthDate = birthDate;
    if (aboutMe != null) result.aboutMe = aboutMe;
    if (avatar != null) result.avatar = avatar;
    if (username != null) result.username = username;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (userID != null) result.userID = userID;
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
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'birthDate', protoName: 'birthDate', subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'aboutMe', protoName: 'aboutMe')
    ..aOM<$1.CDN>(5, _omitFieldNames ? '' : 'avatar', subBuilder: $1.CDN.create)
    ..aOS(6, _omitFieldNames ? '' : 'username')
    ..aOS(7, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..a<$core.List<$core.int>>(8, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
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

  @$pb.TagNumber(5)
  $1.CDN get avatar => $_getN(4);
  @$pb.TagNumber(5)
  set avatar($1.CDN value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAvatar() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvatar() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.CDN ensureAvatar() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get username => $_getSZ(5);
  @$pb.TagNumber(6)
  set username($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUsername() => $_has(5);
  @$pb.TagNumber(6)
  void clearUsername() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get phoneNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set phoneNumber($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPhoneNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearPhoneNumber() => $_clearField(7);

  /// userID владельца профиля — нужен клиенту, чтобы разложить ответ по
  /// локальному кэшу (таблица profiles) при приёме в стриме.
  @$pb.TagNumber(8)
  $core.List<$core.int> get userID => $_getN(7);
  @$pb.TagNumber(8)
  set userID($core.List<$core.int> value) => $_setBytes(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUserID() => $_has(7);
  @$pb.TagNumber(8)
  void clearUserID() => $_clearField(8);
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

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
