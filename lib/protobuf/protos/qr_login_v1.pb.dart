// This is a generated file - do not edit.
//
// Generated from protos/qr_login_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'qr_login_v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'qr_login_v1.pbenum.dart';

/// Что за устройство входит — показывается на телефоне перед подтверждением.
class AuthQr_Device extends $pb.GeneratedMessage {
  factory AuthQr_Device({
    $core.String? deviceModel,
    $core.int? os,
    $core.String? osVersion,
    $core.String? appVersion,
  }) {
    final result = create();
    if (deviceModel != null) result.deviceModel = deviceModel;
    if (os != null) result.os = os;
    if (osVersion != null) result.osVersion = osVersion;
    if (appVersion != null) result.appVersion = appVersion;
    return result;
  }

  AuthQr_Device._();

  factory AuthQr_Device.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthQr_Device.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthQr.Device',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceModel', protoName: 'deviceModel')
    ..aI(2, _omitFieldNames ? '' : 'os')
    ..aOS(3, _omitFieldNames ? '' : 'osVersion', protoName: 'osVersion')
    ..aOS(4, _omitFieldNames ? '' : 'appVersion', protoName: 'appVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr_Device clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr_Device copyWith(void Function(AuthQr_Device) updates) =>
      super.copyWith((message) => updates(message as AuthQr_Device)) as AuthQr_Device;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthQr_Device create() => AuthQr_Device._();
  @$core.override
  AuthQr_Device createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthQr_Device getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthQr_Device>(create);
  static AuthQr_Device? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceModel => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceModel($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceModel() => $_clearField(1);

  /// Код ОС как в сессии: 1 iOS, 2 Android, 3 macOS, 4 Windows.
  @$pb.TagNumber(2)
  $core.int get os => $_getIZ(1);
  @$pb.TagNumber(2)
  set os($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOs() => $_has(1);
  @$pb.TagNumber(2)
  void clearOs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get osVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set osVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOsVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearOsVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get appVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set appVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAppVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearAppVersion() => $_clearField(4);
}

/// Новый токен (каждый раз — новый; старый живёт до своего срока).
class AuthQr_Create extends $pb.GeneratedMessage {
  factory AuthQr_Create({
    AuthQr_Device? device,
  }) {
    final result = create();
    if (device != null) result.device = device;
    return result;
  }

  AuthQr_Create._();

  factory AuthQr_Create.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthQr_Create.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthQr.Create',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<AuthQr_Device>(1, _omitFieldNames ? '' : 'device', subBuilder: AuthQr_Device.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr_Create clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr_Create copyWith(void Function(AuthQr_Create) updates) =>
      super.copyWith((message) => updates(message as AuthQr_Create)) as AuthQr_Create;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthQr_Create create() => AuthQr_Create._();
  @$core.override
  AuthQr_Create createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthQr_Create getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthQr_Create>(create);
  static AuthQr_Create? _defaultInstance;

  @$pb.TagNumber(1)
  AuthQr_Device get device => $_getN(0);
  @$pb.TagNumber(1)
  set device(AuthQr_Device value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => $_clearField(1);
  @$pb.TagNumber(1)
  AuthQr_Device ensureDevice() => $_ensure(0);
}

/// Состояние токена.
class AuthQr_Check extends $pb.GeneratedMessage {
  factory AuthQr_Check({
    $core.List<$core.int>? token,
  }) {
    final result = create();
    if (token != null) result.token = token;
    return result;
  }

  AuthQr_Check._();

  factory AuthQr_Check.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthQr_Check.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthQr.Check',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'token', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr_Check clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr_Check copyWith(void Function(AuthQr_Check) updates) =>
      super.copyWith((message) => updates(message as AuthQr_Check)) as AuthQr_Check;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthQr_Check create() => AuthQr_Check._();
  @$core.override
  AuthQr_Check createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthQr_Check getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthQr_Check>(create);
  static AuthQr_Check? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get token => $_getN(0);
  @$pb.TagNumber(1)
  set token($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

enum AuthQr_Request_Action { newToken, poll, notSet }

/// Pre-auth (без сессии), unary.
class AuthQr_Request extends $pb.GeneratedMessage {
  factory AuthQr_Request({
    AuthQr_Create? newToken,
    AuthQr_Check? poll,
  }) {
    final result = create();
    if (newToken != null) result.newToken = newToken;
    if (poll != null) result.poll = poll;
    return result;
  }

  AuthQr_Request._();

  factory AuthQr_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthQr_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, AuthQr_Request_Action> _AuthQr_Request_ActionByTag = {
    1: AuthQr_Request_Action.newToken,
    2: AuthQr_Request_Action.poll,
    0: AuthQr_Request_Action.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthQr.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<AuthQr_Create>(1, _omitFieldNames ? '' : 'newToken', protoName: 'newToken', subBuilder: AuthQr_Create.create)
    ..aOM<AuthQr_Check>(2, _omitFieldNames ? '' : 'poll', subBuilder: AuthQr_Check.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr_Request copyWith(void Function(AuthQr_Request) updates) =>
      super.copyWith((message) => updates(message as AuthQr_Request)) as AuthQr_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthQr_Request create() => AuthQr_Request._();
  @$core.override
  AuthQr_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthQr_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthQr_Request>(create);
  static AuthQr_Request? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  AuthQr_Request_Action whichAction() => _AuthQr_Request_ActionByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearAction() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AuthQr_Create get newToken => $_getN(0);
  @$pb.TagNumber(1)
  set newToken(AuthQr_Create value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNewToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearNewToken() => $_clearField(1);
  @$pb.TagNumber(1)
  AuthQr_Create ensureNewToken() => $_ensure(0);

  @$pb.TagNumber(2)
  AuthQr_Check get poll => $_getN(1);
  @$pb.TagNumber(2)
  set poll(AuthQr_Check value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPoll() => $_has(1);
  @$pb.TagNumber(2)
  void clearPoll() => $_clearField(2);
  @$pb.TagNumber(2)
  AuthQr_Check ensurePoll() => $_ensure(1);
}

class AuthQr_Response extends $pb.GeneratedMessage {
  factory AuthQr_Response({
    $core.List<$core.int>? token,
    $fixnum.Int64? expiresAt,
    AuthQr_Status? status,
    $core.List<$core.int>? confirmationSession,
    $core.bool? hasTwoStepVerification,
  }) {
    final result = create();
    if (token != null) result.token = token;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (status != null) result.status = status;
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (hasTwoStepVerification != null) result.hasTwoStepVerification = hasTwoStepVerification;
    return result;
  }

  AuthQr_Response._();

  factory AuthQr_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthQr_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthQr.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'token', $pb.PbFieldType.OY)
    ..aInt64(2, _omitFieldNames ? '' : 'expiresAt', protoName: 'expiresAt')
    ..aE<AuthQr_Status>(3, _omitFieldNames ? '' : 'status', enumValues: AuthQr_Status.values)
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..aOB(5, _omitFieldNames ? '' : 'hasTwoStepVerification', protoName: 'hasTwoStepVerification')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr_Response copyWith(void Function(AuthQr_Response) updates) =>
      super.copyWith((message) => updates(message as AuthQr_Response)) as AuthQr_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthQr_Response create() => AuthQr_Response._();
  @$core.override
  AuthQr_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthQr_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthQr_Response>(create);
  static AuthQr_Response? _defaultInstance;

  /// Create: токен и когда он истечёт (мс от эпохи, UTC).
  @$pb.TagNumber(1)
  $core.List<$core.int> get token => $_getN(0);
  @$pb.TagNumber(1)
  set token($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expiresAt => $_getI64(1);
  @$pb.TagNumber(2)
  set expiresAt($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpiresAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpiresAt() => $_clearField(2);

  /// Check.
  @$pb.TagNumber(3)
  AuthQr_Status get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(AuthQr_Status value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

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
}

/// Вход на десктопе по QR с телефона (docs/plans/desktop-client.md §3.4, как в
/// Telegram Desktop). Десктоп без сессии берёт одноразовый токен (AUTH_QR,
/// newToken) и показывает его QR-кодом `iperon://login?token=<base64url>`;
/// телефон, где пользователь уже вошёл, сканирует, видит, какое устройство
/// входит (AUTH_QR_CONFIRM, accept=false), и подтверждает (accept=true).
/// Десктоп опрашивает токен (AUTH_QR, poll) и, когда вход подтверждён,
/// получает confirmationSession — дальше как у Яндекса и passkey: облачный
/// пароль (если включён) и AUTH_CONFIRMATION с обменом ключами.
class AuthQr extends $pb.GeneratedMessage {
  factory AuthQr() => create();

  AuthQr._();

  factory AuthQr.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthQr.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthQr',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQr copyWith(void Function(AuthQr) updates) => super.copyWith((message) => updates(message as AuthQr)) as AuthQr;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthQr create() => AuthQr._();
  @$core.override
  AuthQr createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthQr getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthQr>(create);
  static AuthQr? _defaultInstance;
}

class AuthQrConfirm_Request extends $pb.GeneratedMessage {
  factory AuthQrConfirm_Request({
    $core.List<$core.int>? token,
    $core.bool? accept,
  }) {
    final result = create();
    if (token != null) result.token = token;
    if (accept != null) result.accept = accept;
    return result;
  }

  AuthQrConfirm_Request._();

  factory AuthQrConfirm_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthQrConfirm_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthQrConfirm.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'token', $pb.PbFieldType.OY)
    ..aOB(2, _omitFieldNames ? '' : 'accept')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQrConfirm_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQrConfirm_Request copyWith(void Function(AuthQrConfirm_Request) updates) =>
      super.copyWith((message) => updates(message as AuthQrConfirm_Request)) as AuthQrConfirm_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthQrConfirm_Request create() => AuthQrConfirm_Request._();
  @$core.override
  AuthQrConfirm_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthQrConfirm_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthQrConfirm_Request>(create);
  static AuthQrConfirm_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get token => $_getN(0);
  @$pb.TagNumber(1)
  set token($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  /// false — только показать устройство; true — подтвердить вход.
  @$pb.TagNumber(2)
  $core.bool get accept => $_getBF(1);
  @$pb.TagNumber(2)
  set accept($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccept() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccept() => $_clearField(2);
}

class AuthQrConfirm_Response extends $pb.GeneratedMessage {
  factory AuthQrConfirm_Response({
    AuthQr_Device? device,
    $core.String? locationEnglish,
    $core.String? locationRussian,
  }) {
    final result = create();
    if (device != null) result.device = device;
    if (locationEnglish != null) result.locationEnglish = locationEnglish;
    if (locationRussian != null) result.locationRussian = locationRussian;
    return result;
  }

  AuthQrConfirm_Response._();

  factory AuthQrConfirm_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthQrConfirm_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthQrConfirm.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<AuthQr_Device>(1, _omitFieldNames ? '' : 'device', subBuilder: AuthQr_Device.create)
    ..aOS(2, _omitFieldNames ? '' : 'locationEnglish', protoName: 'locationEnglish')
    ..aOS(3, _omitFieldNames ? '' : 'locationRussian', protoName: 'locationRussian')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQrConfirm_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQrConfirm_Response copyWith(void Function(AuthQrConfirm_Response) updates) =>
      super.copyWith((message) => updates(message as AuthQrConfirm_Response)) as AuthQrConfirm_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthQrConfirm_Response create() => AuthQrConfirm_Response._();
  @$core.override
  AuthQrConfirm_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthQrConfirm_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthQrConfirm_Response>(create);
  static AuthQrConfirm_Response? _defaultInstance;

  @$pb.TagNumber(1)
  AuthQr_Device get device => $_getN(0);
  @$pb.TagNumber(1)
  set device(AuthQr_Device value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => $_clearField(1);
  @$pb.TagNumber(1)
  AuthQr_Device ensureDevice() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get locationEnglish => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationEnglish($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationEnglish() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationEnglish() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationRussian => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationRussian($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationRussian() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationRussian() => $_clearField(3);
}

/// Телефон (с сессией, зашифровано): что за устройство просит войти по
/// отсканированному токену, и подтверждение входа.
class AuthQrConfirm extends $pb.GeneratedMessage {
  factory AuthQrConfirm() => create();

  AuthQrConfirm._();

  factory AuthQrConfirm.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthQrConfirm.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthQrConfirm',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQrConfirm clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthQrConfirm copyWith(void Function(AuthQrConfirm) updates) =>
      super.copyWith((message) => updates(message as AuthQrConfirm)) as AuthQrConfirm;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthQrConfirm create() => AuthQrConfirm._();
  @$core.override
  AuthQrConfirm createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthQrConfirm getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthQrConfirm>(create);
  static AuthQrConfirm? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
