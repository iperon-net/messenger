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

import 'models.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// CallPassword
class AuthCallPasswordRequest extends $pb.GeneratedMessage {
  factory AuthCallPasswordRequest({
    $core.String? phoneNumber,
  }) {
    final result = create();
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    return result;
  }

  AuthCallPasswordRequest._();

  factory AuthCallPasswordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCallPasswordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthCallPasswordRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordRequest copyWith(
          void Function(AuthCallPasswordRequest) updates) =>
      super.copyWith((message) => updates(message as AuthCallPasswordRequest))
          as AuthCallPasswordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordRequest create() => AuthCallPasswordRequest._();
  @$core.override
  AuthCallPasswordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthCallPasswordRequest>(create);
  static AuthCallPasswordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phoneNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set phoneNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhoneNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoneNumber() => $_clearField(1);
}

class AuthCallPasswordResponse extends $pb.GeneratedMessage {
  factory AuthCallPasswordResponse({
    $core.List<$core.int>? callPasswordSession,
    $core.double? timeout,
    $core.String? confirmationPhoneNumber,
  }) {
    final result = create();
    if (callPasswordSession != null)
      result.callPasswordSession = callPasswordSession;
    if (timeout != null) result.timeout = timeout;
    if (confirmationPhoneNumber != null)
      result.confirmationPhoneNumber = confirmationPhoneNumber;
    return result;
  }

  AuthCallPasswordResponse._();

  factory AuthCallPasswordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCallPasswordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthCallPasswordResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'callPasswordSession', $pb.PbFieldType.OY,
        protoName: 'callPasswordSession')
    ..aD(2, _omitFieldNames ? '' : 'timeout', fieldType: $pb.PbFieldType.OF)
    ..aOS(3, _omitFieldNames ? '' : 'confirmationPhoneNumber',
        protoName: 'confirmationPhoneNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordResponse copyWith(
          void Function(AuthCallPasswordResponse) updates) =>
      super.copyWith((message) => updates(message as AuthCallPasswordResponse))
          as AuthCallPasswordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordResponse create() => AuthCallPasswordResponse._();
  @$core.override
  AuthCallPasswordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthCallPasswordResponse>(create);
  static AuthCallPasswordResponse? _defaultInstance;

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

/// Call Password Check
class AuthCallPasswordCheckRequest extends $pb.GeneratedMessage {
  factory AuthCallPasswordCheckRequest({
    $core.List<$core.int>? callPasswordSession,
  }) {
    final result = create();
    if (callPasswordSession != null)
      result.callPasswordSession = callPasswordSession;
    return result;
  }

  AuthCallPasswordCheckRequest._();

  factory AuthCallPasswordCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCallPasswordCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthCallPasswordCheckRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'callPasswordSession', $pb.PbFieldType.OY,
        protoName: 'callPasswordSession')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordCheckRequest copyWith(
          void Function(AuthCallPasswordCheckRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AuthCallPasswordCheckRequest))
          as AuthCallPasswordCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordCheckRequest create() =>
      AuthCallPasswordCheckRequest._();
  @$core.override
  AuthCallPasswordCheckRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthCallPasswordCheckRequest>(create);
  static AuthCallPasswordCheckRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get callPasswordSession => $_getN(0);
  @$pb.TagNumber(1)
  set callPasswordSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallPasswordSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallPasswordSession() => $_clearField(1);
}

class AuthCallPasswordCheckResponse extends $pb.GeneratedMessage {
  factory AuthCallPasswordCheckResponse({
    $1.Status? status,
    $fixnum.Int64? timer,
    $core.String? errorMessage,
    $core.List<$core.int>? confirmationSession,
    $core.bool? hasCloudPassword,
    $core.bool? isBlocked,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (timer != null) result.timer = timer;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (confirmationSession != null)
      result.confirmationSession = confirmationSession;
    if (hasCloudPassword != null) result.hasCloudPassword = hasCloudPassword;
    if (isBlocked != null) result.isBlocked = isBlocked;
    return result;
  }

  AuthCallPasswordCheckResponse._();

  factory AuthCallPasswordCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCallPasswordCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthCallPasswordCheckResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aE<$1.Status>(1, _omitFieldNames ? '' : 'status',
        enumValues: $1.Status.values)
    ..aInt64(2, _omitFieldNames ? '' : 'timer')
    ..aOS(3, _omitFieldNames ? '' : 'errorMessage', protoName: 'errorMessage')
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY,
        protoName: 'confirmationSession')
    ..aOB(5, _omitFieldNames ? '' : 'hasCloudPassword',
        protoName: 'hasCloudPassword')
    ..aOB(6, _omitFieldNames ? '' : 'isBlocked', protoName: 'isBlocked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCallPasswordCheckResponse copyWith(
          void Function(AuthCallPasswordCheckResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AuthCallPasswordCheckResponse))
          as AuthCallPasswordCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordCheckResponse create() =>
      AuthCallPasswordCheckResponse._();
  @$core.override
  AuthCallPasswordCheckResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCallPasswordCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthCallPasswordCheckResponse>(create);
  static AuthCallPasswordCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($1.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

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
  $core.bool get hasCloudPassword => $_getBF(4);
  @$pb.TagNumber(5)
  set hasCloudPassword($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHasCloudPassword() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasCloudPassword() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isBlocked => $_getBF(5);
  @$pb.TagNumber(6)
  set isBlocked($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsBlocked() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsBlocked() => $_clearField(6);
}

/// Confirmation
class AuthConfirmationRequest extends $pb.GeneratedMessage {
  factory AuthConfirmationRequest({
    $core.List<$core.int>? confirmationSession,
    $core.List<$core.int>? clientPublicKeyECDH,
    $core.String? deviceModel,
    $core.int? os,
    $core.String? osVersion,
    $core.String? appVersion,
    $core.String? appBuildNumber,
  }) {
    final result = create();
    if (confirmationSession != null)
      result.confirmationSession = confirmationSession;
    if (clientPublicKeyECDH != null)
      result.clientPublicKeyECDH = clientPublicKeyECDH;
    if (deviceModel != null) result.deviceModel = deviceModel;
    if (os != null) result.os = os;
    if (osVersion != null) result.osVersion = osVersion;
    if (appVersion != null) result.appVersion = appVersion;
    if (appBuildNumber != null) result.appBuildNumber = appBuildNumber;
    return result;
  }

  AuthConfirmationRequest._();

  factory AuthConfirmationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthConfirmationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthConfirmationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY,
        protoName: 'confirmationSession')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'clientPublicKeyECDH', $pb.PbFieldType.OY,
        protoName: 'clientPublicKeyECDH')
    ..aOS(3, _omitFieldNames ? '' : 'deviceModel', protoName: 'deviceModel')
    ..aI(4, _omitFieldNames ? '' : 'os')
    ..aOS(5, _omitFieldNames ? '' : 'osVersion', protoName: 'osVersion')
    ..aOS(6, _omitFieldNames ? '' : 'appVersion', protoName: 'appVersion')
    ..aOS(7, _omitFieldNames ? '' : 'appBuildNumber',
        protoName: 'appBuildNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthConfirmationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthConfirmationRequest copyWith(
          void Function(AuthConfirmationRequest) updates) =>
      super.copyWith((message) => updates(message as AuthConfirmationRequest))
          as AuthConfirmationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthConfirmationRequest create() => AuthConfirmationRequest._();
  @$core.override
  AuthConfirmationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthConfirmationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthConfirmationRequest>(create);
  static AuthConfirmationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get clientPublicKeyECDH => $_getN(1);
  @$pb.TagNumber(2)
  set clientPublicKeyECDH($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientPublicKeyECDH() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientPublicKeyECDH() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceModel => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceModel($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceModel() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceModel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get os => $_getIZ(3);
  @$pb.TagNumber(4)
  set os($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOs() => $_has(3);
  @$pb.TagNumber(4)
  void clearOs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get osVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set osVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOsVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearOsVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get appVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set appVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAppVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearAppVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get appBuildNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set appBuildNumber($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAppBuildNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearAppBuildNumber() => $_clearField(7);
}

class AuthConfirmationResponse extends $pb.GeneratedMessage {
  factory AuthConfirmationResponse({
    $core.List<$core.int>? session,
    $1.Location? location,
  }) {
    final result = create();
    if (session != null) result.session = session;
    if (location != null) result.location = location;
    return result;
  }

  AuthConfirmationResponse._();

  factory AuthConfirmationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthConfirmationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthConfirmationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'session', $pb.PbFieldType.OY)
    ..aOM<$1.Location>(2, _omitFieldNames ? '' : 'location',
        subBuilder: $1.Location.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthConfirmationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthConfirmationResponse copyWith(
          void Function(AuthConfirmationResponse) updates) =>
      super.copyWith((message) => updates(message as AuthConfirmationResponse))
          as AuthConfirmationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthConfirmationResponse create() => AuthConfirmationResponse._();
  @$core.override
  AuthConfirmationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthConfirmationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthConfirmationResponse>(create);
  static AuthConfirmationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get session => $_getN(0);
  @$pb.TagNumber(1)
  set session($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Location get location => $_getN(1);
  @$pb.TagNumber(2)
  set location($1.Location value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLocation() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocation() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Location ensureLocation() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
