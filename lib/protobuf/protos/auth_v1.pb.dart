// This is a generated file - do not edit.
//
// Generated from protos/auth_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'models.pbenum.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AuthCallPassword_Request extends $pb.GeneratedMessage {
  factory AuthCallPassword_Request({
    $core.String? phoneNumber,
  }) {
    final result = create();
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    return result;
  }

  AuthCallPassword_Request._();

  factory AuthCallPassword_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCallPassword_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCallPassword.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPassword_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPassword_Request copyWith(void Function(AuthCallPassword_Request) updates) =>
      super.copyWith((message) => updates(message as AuthCallPassword_Request)) as AuthCallPassword_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCallPassword_Request create() => AuthCallPassword_Request._();
  @$core.override
  AuthCallPassword_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCallPassword_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCallPassword_Request>(create);
  static AuthCallPassword_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phoneNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set phoneNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhoneNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoneNumber() => $_clearField(1);
}

class AuthCallPassword_Response extends $pb.GeneratedMessage {
  factory AuthCallPassword_Response({
    $core.List<$core.int>? callPasswordSession,
    $core.double? timeout,
    $core.String? confirmationPhoneNumber,
  }) {
    final result = create();
    if (callPasswordSession != null) result.callPasswordSession = callPasswordSession;
    if (timeout != null) result.timeout = timeout;
    if (confirmationPhoneNumber != null) result.confirmationPhoneNumber = confirmationPhoneNumber;
    return result;
  }

  AuthCallPassword_Response._();

  factory AuthCallPassword_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCallPassword_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCallPassword.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'callPasswordSession', $pb.PbFieldType.OY, protoName: 'callPasswordSession')
    ..aD(2, _omitFieldNames ? '' : 'timeout', fieldType: $pb.PbFieldType.OF)
    ..aOS(3, _omitFieldNames ? '' : 'confirmationPhoneNumber', protoName: 'confirmationPhoneNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPassword_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPassword_Response copyWith(void Function(AuthCallPassword_Response) updates) =>
      super.copyWith((message) => updates(message as AuthCallPassword_Response)) as AuthCallPassword_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCallPassword_Response create() => AuthCallPassword_Response._();
  @$core.override
  AuthCallPassword_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCallPassword_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCallPassword_Response>(create);
  static AuthCallPassword_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get callPasswordSession => $_getN(0);
  @$pb.TagNumber(1)
  set callPasswordSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallPasswordSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallPasswordSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get timeout => $_getN(1);
  @$pb.TagNumber(2)
  set timeout($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimeout() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeout() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get confirmationPhoneNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set confirmationPhoneNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConfirmationPhoneNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfirmationPhoneNumber() => $_clearField(3);
}

class AuthCallPassword extends $pb.GeneratedMessage {
  factory AuthCallPassword() => create();

  AuthCallPassword._();

  factory AuthCallPassword.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCallPassword.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCallPassword',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPassword clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPassword copyWith(void Function(AuthCallPassword) updates) =>
      super.copyWith((message) => updates(message as AuthCallPassword)) as AuthCallPassword;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCallPassword create() => AuthCallPassword._();
  @$core.override
  AuthCallPassword createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCallPassword getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCallPassword>(create);
  static AuthCallPassword? _defaultInstance;
}

class AuthCallPasswordConfirmation_Request extends $pb.GeneratedMessage {
  factory AuthCallPasswordConfirmation_Request({
    $core.List<$core.int>? callPasswordSession,
  }) {
    final result = create();
    if (callPasswordSession != null) result.callPasswordSession = callPasswordSession;
    return result;
  }

  AuthCallPasswordConfirmation_Request._();

  factory AuthCallPasswordConfirmation_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCallPasswordConfirmation_Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCallPasswordConfirmation.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'callPasswordSession', $pb.PbFieldType.OY, protoName: 'callPasswordSession')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordConfirmation_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordConfirmation_Request copyWith(void Function(AuthCallPasswordConfirmation_Request) updates) =>
      super.copyWith((message) => updates(message as AuthCallPasswordConfirmation_Request)) as AuthCallPasswordConfirmation_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordConfirmation_Request create() => AuthCallPasswordConfirmation_Request._();
  @$core.override
  AuthCallPasswordConfirmation_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordConfirmation_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCallPasswordConfirmation_Request>(create);
  static AuthCallPasswordConfirmation_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get callPasswordSession => $_getN(0);
  @$pb.TagNumber(1)
  set callPasswordSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallPasswordSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallPasswordSession() => $_clearField(1);
}

class AuthCallPasswordConfirmation_Response extends $pb.GeneratedMessage {
  factory AuthCallPasswordConfirmation_Response({
    $0.AuthCallPasswordStatus? authCallPasswordStatus,
    $fixnum.Int64? timer,
    $core.String? errorMessage,
    $core.List<$core.int>? confirmationSession,
    $core.bool? hasTwoStepVerification,
    $core.bool? isBlocked,
  }) {
    final result = create();
    if (authCallPasswordStatus != null) result.authCallPasswordStatus = authCallPasswordStatus;
    if (timer != null) result.timer = timer;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (hasTwoStepVerification != null) result.hasTwoStepVerification = hasTwoStepVerification;
    if (isBlocked != null) result.isBlocked = isBlocked;
    return result;
  }

  AuthCallPasswordConfirmation_Response._();

  factory AuthCallPasswordConfirmation_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCallPasswordConfirmation_Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCallPasswordConfirmation.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<$0.AuthCallPasswordStatus>(1, _omitFieldNames ? '' : 'authCallPasswordStatus',
        protoName: 'authCallPasswordStatus', enumValues: $0.AuthCallPasswordStatus.values)
    ..aInt64(2, _omitFieldNames ? '' : 'timer')
    ..aOS(3, _omitFieldNames ? '' : 'errorMessage', protoName: 'errorMessage')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..aOB(5, _omitFieldNames ? '' : 'hasTwoStepVerification', protoName: 'hasTwoStepVerification')
    ..aOB(6, _omitFieldNames ? '' : 'isBlocked', protoName: 'isBlocked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordConfirmation_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordConfirmation_Response copyWith(void Function(AuthCallPasswordConfirmation_Response) updates) =>
      super.copyWith((message) => updates(message as AuthCallPasswordConfirmation_Response)) as AuthCallPasswordConfirmation_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordConfirmation_Response create() => AuthCallPasswordConfirmation_Response._();
  @$core.override
  AuthCallPasswordConfirmation_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordConfirmation_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCallPasswordConfirmation_Response>(create);
  static AuthCallPasswordConfirmation_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $0.AuthCallPasswordStatus get authCallPasswordStatus => $_getN(0);
  @$pb.TagNumber(1)
  set authCallPasswordStatus($0.AuthCallPasswordStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthCallPasswordStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthCallPasswordStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timer => $_getI64(1);
  @$pb.TagNumber(2)
  set timer($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimer() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimer() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get errorMessage => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorMessage($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasErrorMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get confirmationSession => $_getN(3);
  @$pb.TagNumber(4)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConfirmationSession() => $_has(3);
  @$pb.TagNumber(4)
  void clearConfirmationSession() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get hasTwoStepVerification => $_getBF(4);
  @$pb.TagNumber(5)
  set hasTwoStepVerification($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHasTwoStepVerification() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasTwoStepVerification() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isBlocked => $_getBF(5);
  @$pb.TagNumber(6)
  set isBlocked($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsBlocked() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsBlocked() => $_clearField(6);
}

/// Call Password Check
class AuthCallPasswordConfirmation extends $pb.GeneratedMessage {
  factory AuthCallPasswordConfirmation() => create();

  AuthCallPasswordConfirmation._();

  factory AuthCallPasswordConfirmation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCallPasswordConfirmation.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCallPasswordConfirmation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordConfirmation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordConfirmation copyWith(void Function(AuthCallPasswordConfirmation) updates) =>
      super.copyWith((message) => updates(message as AuthCallPasswordConfirmation)) as AuthCallPasswordConfirmation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordConfirmation create() => AuthCallPasswordConfirmation._();
  @$core.override
  AuthCallPasswordConfirmation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordConfirmation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCallPasswordConfirmation>(create);
  static AuthCallPasswordConfirmation? _defaultInstance;
}

class AuthModerationApplicationStore_Request extends $pb.GeneratedMessage {
  factory AuthModerationApplicationStore_Request({
    $core.String? phoneNumber,
  }) {
    final result = create();
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    return result;
  }

  AuthModerationApplicationStore_Request._();

  factory AuthModerationApplicationStore_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthModerationApplicationStore_Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthModerationApplicationStore.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStore_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStore_Request copyWith(void Function(AuthModerationApplicationStore_Request) updates) =>
      super.copyWith((message) => updates(message as AuthModerationApplicationStore_Request)) as AuthModerationApplicationStore_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStore_Request create() => AuthModerationApplicationStore_Request._();
  @$core.override
  AuthModerationApplicationStore_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStore_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthModerationApplicationStore_Request>(create);
  static AuthModerationApplicationStore_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phoneNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set phoneNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhoneNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoneNumber() => $_clearField(1);
}

class AuthModerationApplicationStore_Response extends $pb.GeneratedMessage {
  factory AuthModerationApplicationStore_Response({
    $core.List<$core.int>? moderationApplicationStoreSession,
    $core.String? phoneNumber,
  }) {
    final result = create();
    if (moderationApplicationStoreSession != null) result.moderationApplicationStoreSession = moderationApplicationStoreSession;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    return result;
  }

  AuthModerationApplicationStore_Response._();

  factory AuthModerationApplicationStore_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthModerationApplicationStore_Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthModerationApplicationStore.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'moderationApplicationStoreSession', $pb.PbFieldType.OY,
        protoName: 'moderationApplicationStoreSession')
    ..aOS(2, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStore_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStore_Response copyWith(void Function(AuthModerationApplicationStore_Response) updates) =>
      super.copyWith((message) => updates(message as AuthModerationApplicationStore_Response)) as AuthModerationApplicationStore_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStore_Response create() => AuthModerationApplicationStore_Response._();
  @$core.override
  AuthModerationApplicationStore_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStore_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthModerationApplicationStore_Response>(create);
  static AuthModerationApplicationStore_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get moderationApplicationStoreSession => $_getN(0);
  @$pb.TagNumber(1)
  set moderationApplicationStoreSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasModerationApplicationStoreSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearModerationApplicationStoreSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get phoneNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set phoneNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhoneNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhoneNumber() => $_clearField(2);
}

/// Moderation application store
class AuthModerationApplicationStore extends $pb.GeneratedMessage {
  factory AuthModerationApplicationStore() => create();

  AuthModerationApplicationStore._();

  factory AuthModerationApplicationStore.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthModerationApplicationStore.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthModerationApplicationStore',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStore clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStore copyWith(void Function(AuthModerationApplicationStore) updates) =>
      super.copyWith((message) => updates(message as AuthModerationApplicationStore)) as AuthModerationApplicationStore;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStore create() => AuthModerationApplicationStore._();
  @$core.override
  AuthModerationApplicationStore createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStore getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthModerationApplicationStore>(create);
  static AuthModerationApplicationStore? _defaultInstance;
}

class AuthModerationApplicationStoreConfirmation_Request extends $pb.GeneratedMessage {
  factory AuthModerationApplicationStoreConfirmation_Request({
    $core.List<$core.int>? moderationApplicationStoreSession,
    $core.String? verificationCode,
  }) {
    final result = create();
    if (moderationApplicationStoreSession != null) result.moderationApplicationStoreSession = moderationApplicationStoreSession;
    if (verificationCode != null) result.verificationCode = verificationCode;
    return result;
  }

  AuthModerationApplicationStoreConfirmation_Request._();

  factory AuthModerationApplicationStoreConfirmation_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthModerationApplicationStoreConfirmation_Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthModerationApplicationStoreConfirmation.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'moderationApplicationStoreSession', $pb.PbFieldType.OY,
        protoName: 'moderationApplicationStoreSession')
    ..aOS(2, _omitFieldNames ? '' : 'verificationCode', protoName: 'verificationCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStoreConfirmation_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStoreConfirmation_Request copyWith(void Function(AuthModerationApplicationStoreConfirmation_Request) updates) =>
      super.copyWith((message) => updates(message as AuthModerationApplicationStoreConfirmation_Request))
          as AuthModerationApplicationStoreConfirmation_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStoreConfirmation_Request create() => AuthModerationApplicationStoreConfirmation_Request._();
  @$core.override
  AuthModerationApplicationStoreConfirmation_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStoreConfirmation_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthModerationApplicationStoreConfirmation_Request>(create);
  static AuthModerationApplicationStoreConfirmation_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get moderationApplicationStoreSession => $_getN(0);
  @$pb.TagNumber(1)
  set moderationApplicationStoreSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasModerationApplicationStoreSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearModerationApplicationStoreSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get verificationCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set verificationCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVerificationCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearVerificationCode() => $_clearField(2);
}

class AuthModerationApplicationStoreConfirmation_Response extends $pb.GeneratedMessage {
  factory AuthModerationApplicationStoreConfirmation_Response({
    $core.List<$core.int>? confirmationSession,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    return result;
  }

  AuthModerationApplicationStoreConfirmation_Response._();

  factory AuthModerationApplicationStoreConfirmation_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthModerationApplicationStoreConfirmation_Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthModerationApplicationStoreConfirmation.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStoreConfirmation_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStoreConfirmation_Response copyWith(
          void Function(AuthModerationApplicationStoreConfirmation_Response) updates) =>
      super.copyWith((message) => updates(message as AuthModerationApplicationStoreConfirmation_Response))
          as AuthModerationApplicationStoreConfirmation_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStoreConfirmation_Response create() => AuthModerationApplicationStoreConfirmation_Response._();
  @$core.override
  AuthModerationApplicationStoreConfirmation_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStoreConfirmation_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthModerationApplicationStoreConfirmation_Response>(create);
  static AuthModerationApplicationStoreConfirmation_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);
}

class AuthModerationApplicationStoreConfirmation extends $pb.GeneratedMessage {
  factory AuthModerationApplicationStoreConfirmation() => create();

  AuthModerationApplicationStoreConfirmation._();

  factory AuthModerationApplicationStoreConfirmation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthModerationApplicationStoreConfirmation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthModerationApplicationStoreConfirmation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStoreConfirmation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthModerationApplicationStoreConfirmation copyWith(void Function(AuthModerationApplicationStoreConfirmation) updates) =>
      super.copyWith((message) => updates(message as AuthModerationApplicationStoreConfirmation))
          as AuthModerationApplicationStoreConfirmation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStoreConfirmation create() => AuthModerationApplicationStoreConfirmation._();
  @$core.override
  AuthModerationApplicationStoreConfirmation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthModerationApplicationStoreConfirmation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthModerationApplicationStoreConfirmation>(create);
  static AuthModerationApplicationStoreConfirmation? _defaultInstance;
}

class AuthConfirmation_Request extends $pb.GeneratedMessage {
  factory AuthConfirmation_Request({
    $core.List<$core.int>? confirmationSession,
    $core.List<$core.int>? publicKeySharedKey,
    $core.List<$core.int>? publicKeySalt,
    $core.String? deviceModel,
    $core.int? os,
    $core.String? osVersion,
    $core.String? appVersion,
    $core.String? appBuildNumber,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (publicKeySharedKey != null) result.publicKeySharedKey = publicKeySharedKey;
    if (publicKeySalt != null) result.publicKeySalt = publicKeySalt;
    if (deviceModel != null) result.deviceModel = deviceModel;
    if (os != null) result.os = os;
    if (osVersion != null) result.osVersion = osVersion;
    if (appVersion != null) result.appVersion = appVersion;
    if (appBuildNumber != null) result.appBuildNumber = appBuildNumber;
    return result;
  }

  AuthConfirmation_Request._();

  factory AuthConfirmation_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthConfirmation_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthConfirmation.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'publicKeySharedKey', $pb.PbFieldType.OY, protoName: 'publicKeySharedKey')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'publicKeySalt', $pb.PbFieldType.OY, protoName: 'publicKeySalt')
    ..aOS(4, _omitFieldNames ? '' : 'deviceModel', protoName: 'deviceModel')
    ..aI(5, _omitFieldNames ? '' : 'os')
    ..aOS(6, _omitFieldNames ? '' : 'osVersion', protoName: 'osVersion')
    ..aOS(7, _omitFieldNames ? '' : 'appVersion', protoName: 'appVersion')
    ..aOS(8, _omitFieldNames ? '' : 'appBuildNumber', protoName: 'appBuildNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthConfirmation_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthConfirmation_Request copyWith(void Function(AuthConfirmation_Request) updates) =>
      super.copyWith((message) => updates(message as AuthConfirmation_Request)) as AuthConfirmation_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthConfirmation_Request create() => AuthConfirmation_Request._();
  @$core.override
  AuthConfirmation_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthConfirmation_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthConfirmation_Request>(create);
  static AuthConfirmation_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get publicKeySharedKey => $_getN(1);
  @$pb.TagNumber(2)
  set publicKeySharedKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublicKeySharedKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKeySharedKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get publicKeySalt => $_getN(2);
  @$pb.TagNumber(3)
  set publicKeySalt($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPublicKeySalt() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublicKeySalt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get deviceModel => $_getSZ(3);
  @$pb.TagNumber(4)
  set deviceModel($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeviceModel() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeviceModel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get os => $_getIZ(4);
  @$pb.TagNumber(5)
  set os($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOs() => $_has(4);
  @$pb.TagNumber(5)
  void clearOs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get osVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set osVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOsVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearOsVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get appVersion => $_getSZ(6);
  @$pb.TagNumber(7)
  set appVersion($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAppVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearAppVersion() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get appBuildNumber => $_getSZ(7);
  @$pb.TagNumber(8)
  set appBuildNumber($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAppBuildNumber() => $_has(7);
  @$pb.TagNumber(8)
  void clearAppBuildNumber() => $_clearField(8);
}

class AuthConfirmation_Response extends $pb.GeneratedMessage {
  factory AuthConfirmation_Response({
    $core.List<$core.int>? sessionID,
    $core.List<$core.int>? session,
    $core.List<$core.int>? ciphertextSharedKey,
    $core.List<$core.int>? ciphertextSalt,
    $core.List<$core.int>? signatureSharedKey,
    $core.List<$core.int>? signatureSalt,
    $core.List<$core.int>? userID,
    $core.String? phoneNumber,
  }) {
    final result = create();
    if (sessionID != null) result.sessionID = sessionID;
    if (session != null) result.session = session;
    if (ciphertextSharedKey != null) result.ciphertextSharedKey = ciphertextSharedKey;
    if (ciphertextSalt != null) result.ciphertextSalt = ciphertextSalt;
    if (signatureSharedKey != null) result.signatureSharedKey = signatureSharedKey;
    if (signatureSalt != null) result.signatureSalt = signatureSalt;
    if (userID != null) result.userID = userID;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    return result;
  }

  AuthConfirmation_Response._();

  factory AuthConfirmation_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthConfirmation_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthConfirmation.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'sessionID', $pb.PbFieldType.OY, protoName: 'sessionID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'session', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'ciphertextSharedKey', $pb.PbFieldType.OY, protoName: 'ciphertextSharedKey')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'ciphertextSalt', $pb.PbFieldType.OY, protoName: 'ciphertextSalt')
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'signatureSharedKey', $pb.PbFieldType.OY, protoName: 'signatureSharedKey')
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'signatureSalt', $pb.PbFieldType.OY, protoName: 'signatureSalt')
    ..a<$core.List<$core.int>>(7, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aOS(8, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthConfirmation_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthConfirmation_Response copyWith(void Function(AuthConfirmation_Response) updates) =>
      super.copyWith((message) => updates(message as AuthConfirmation_Response)) as AuthConfirmation_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthConfirmation_Response create() => AuthConfirmation_Response._();
  @$core.override
  AuthConfirmation_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthConfirmation_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthConfirmation_Response>(create);
  static AuthConfirmation_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sessionID => $_getN(0);
  @$pb.TagNumber(1)
  set sessionID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get session => $_getN(1);
  @$pb.TagNumber(2)
  set session($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSession() => $_has(1);
  @$pb.TagNumber(2)
  void clearSession() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get ciphertextSharedKey => $_getN(2);
  @$pb.TagNumber(3)
  set ciphertextSharedKey($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCiphertextSharedKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearCiphertextSharedKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get ciphertextSalt => $_getN(3);
  @$pb.TagNumber(4)
  set ciphertextSalt($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCiphertextSalt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCiphertextSalt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get signatureSharedKey => $_getN(4);
  @$pb.TagNumber(5)
  set signatureSharedKey($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSignatureSharedKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearSignatureSharedKey() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get signatureSalt => $_getN(5);
  @$pb.TagNumber(6)
  set signatureSalt($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSignatureSalt() => $_has(5);
  @$pb.TagNumber(6)
  void clearSignatureSalt() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.int> get userID => $_getN(6);
  @$pb.TagNumber(7)
  set userID($core.List<$core.int> value) => $_setBytes(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUserID() => $_has(6);
  @$pb.TagNumber(7)
  void clearUserID() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get phoneNumber => $_getSZ(7);
  @$pb.TagNumber(8)
  set phoneNumber($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPhoneNumber() => $_has(7);
  @$pb.TagNumber(8)
  void clearPhoneNumber() => $_clearField(8);
}

/// Confirmation
class AuthConfirmation extends $pb.GeneratedMessage {
  factory AuthConfirmation() => create();

  AuthConfirmation._();

  factory AuthConfirmation.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthConfirmation.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthConfirmation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthConfirmation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthConfirmation copyWith(void Function(AuthConfirmation) updates) =>
      super.copyWith((message) => updates(message as AuthConfirmation)) as AuthConfirmation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthConfirmation create() => AuthConfirmation._();
  @$core.override
  AuthConfirmation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthConfirmation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthConfirmation>(create);
  static AuthConfirmation? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
