// This is a generated file - do not edit.
//
// Generated from protos/cloud_password_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AuthCloudPassword_Request extends $pb.GeneratedMessage {
  factory AuthCloudPassword_Request({
    $core.List<$core.int>? confirmationSession,
    $core.List<$core.int>? pwHash,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (pwHash != null) result.pwHash = pwHash;
    return result;
  }

  AuthCloudPassword_Request._();

  factory AuthCloudPassword_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPassword_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPassword.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'pwHash', $pb.PbFieldType.OY, protoName: 'pwHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPassword_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPassword_Request copyWith(void Function(AuthCloudPassword_Request) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPassword_Request)) as AuthCloudPassword_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPassword_Request create() => AuthCloudPassword_Request._();
  @$core.override
  AuthCloudPassword_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPassword_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPassword_Request>(create);
  static AuthCloudPassword_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get pwHash => $_getN(1);
  @$pb.TagNumber(2)
  set pwHash($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPwHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearPwHash() => $_clearField(2);
}

class AuthCloudPassword_Response extends $pb.GeneratedMessage {
  factory AuthCloudPassword_Response({
    $core.bool? success,
    $core.String? error,
    $core.int? attemptsLeft,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    if (attemptsLeft != null) result.attemptsLeft = attemptsLeft;
    return result;
  }

  AuthCloudPassword_Response._();

  factory AuthCloudPassword_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPassword_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPassword.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..aI(3, _omitFieldNames ? '' : 'attemptsLeft', protoName: 'attemptsLeft')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPassword_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPassword_Response copyWith(void Function(AuthCloudPassword_Response) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPassword_Response)) as AuthCloudPassword_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPassword_Response create() => AuthCloudPassword_Response._();
  @$core.override
  AuthCloudPassword_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPassword_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPassword_Response>(create);
  static AuthCloudPassword_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);

  /// Сколько попыток осталось до инвалидации confirmationSession.
  @$pb.TagNumber(3)
  $core.int get attemptsLeft => $_getIZ(2);
  @$pb.TagNumber(3)
  set attemptsLeft($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAttemptsLeft() => $_has(2);
  @$pb.TagNumber(3)
  void clearAttemptsLeft() => $_clearField(3);
}

/// Второй шаг входа: проверка облачного пароля по confirmationSession.
class AuthCloudPassword extends $pb.GeneratedMessage {
  factory AuthCloudPassword() => create();

  AuthCloudPassword._();

  factory AuthCloudPassword.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPassword.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPassword',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPassword clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPassword copyWith(void Function(AuthCloudPassword) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPassword)) as AuthCloudPassword;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPassword create() => AuthCloudPassword._();
  @$core.override
  AuthCloudPassword createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPassword getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPassword>(create);
  static AuthCloudPassword? _defaultInstance;
}

class AuthCloudPasswordRecovery_Request extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRecovery_Request({
    $core.List<$core.int>? confirmationSession,
    $core.String? email,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (email != null) result.email = email;
    return result;
  }

  AuthCloudPasswordRecovery_Request._();

  factory AuthCloudPasswordRecovery_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRecovery_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRecovery.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecovery_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecovery_Request copyWith(void Function(AuthCloudPasswordRecovery_Request) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRecovery_Request)) as AuthCloudPasswordRecovery_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecovery_Request create() => AuthCloudPasswordRecovery_Request._();
  @$core.override
  AuthCloudPasswordRecovery_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecovery_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRecovery_Request>(create);
  static AuthCloudPasswordRecovery_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);

  /// Email, введённый пользователем. Код шлётся только если совпадает с
  /// привязанным подтверждённым адресом аккаунта; иначе сервер молчит, но ответ
  /// тот же — чтобы нельзя было перебором узнать чужие email в базе.
  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);
}

class AuthCloudPasswordRecovery_Response extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRecovery_Response({
    $core.String? maskedEmail,
    $core.String? error,
  }) {
    final result = create();
    if (maskedEmail != null) result.maskedEmail = maskedEmail;
    if (error != null) result.error = error;
    return result;
  }

  AuthCloudPasswordRecovery_Response._();

  factory AuthCloudPasswordRecovery_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRecovery_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRecovery.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'maskedEmail', protoName: 'maskedEmail')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecovery_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecovery_Response copyWith(void Function(AuthCloudPasswordRecovery_Response) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRecovery_Response)) as AuthCloudPasswordRecovery_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecovery_Response create() => AuthCloudPasswordRecovery_Response._();
  @$core.override
  AuthCloudPasswordRecovery_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecovery_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRecovery_Response>(create);
  static AuthCloudPasswordRecovery_Response? _defaultInstance;

  /// Маскированный email (напр. "k***@gmail.com") для показа пользователю.
  @$pb.TagNumber(1)
  $core.String get maskedEmail => $_getSZ(0);
  @$pb.TagNumber(1)
  set maskedEmail($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaskedEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaskedEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
}

/// «Забыли пароль?»: отправка кода восстановления на привязанный email.
class AuthCloudPasswordRecovery extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRecovery() => create();

  AuthCloudPasswordRecovery._();

  factory AuthCloudPasswordRecovery.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRecovery.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRecovery',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecovery clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecovery copyWith(void Function(AuthCloudPasswordRecovery) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRecovery)) as AuthCloudPasswordRecovery;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecovery create() => AuthCloudPasswordRecovery._();
  @$core.override
  AuthCloudPasswordRecovery createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecovery getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRecovery>(create);
  static AuthCloudPasswordRecovery? _defaultInstance;
}

class AuthCloudPasswordRecoveryConfirm_Request extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRecoveryConfirm_Request({
    $core.List<$core.int>? confirmationSession,
    $core.String? code,
    $core.List<$core.int>? newPwHash,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (code != null) result.code = code;
    if (newPwHash != null) result.newPwHash = newPwHash;
    return result;
  }

  AuthCloudPasswordRecoveryConfirm_Request._();

  factory AuthCloudPasswordRecoveryConfirm_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRecoveryConfirm_Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRecoveryConfirm.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'newPwHash', $pb.PbFieldType.OY, protoName: 'newPwHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecoveryConfirm_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecoveryConfirm_Request copyWith(void Function(AuthCloudPasswordRecoveryConfirm_Request) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRecoveryConfirm_Request)) as AuthCloudPasswordRecoveryConfirm_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecoveryConfirm_Request create() => AuthCloudPasswordRecoveryConfirm_Request._();
  @$core.override
  AuthCloudPasswordRecoveryConfirm_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecoveryConfirm_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRecoveryConfirm_Request>(create);
  static AuthCloudPasswordRecoveryConfirm_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get newPwHash => $_getN(2);
  @$pb.TagNumber(3)
  set newPwHash($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewPwHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewPwHash() => $_clearField(3);
}

class AuthCloudPasswordRecoveryConfirm_Response extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRecoveryConfirm_Response({
    $core.bool? success,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    return result;
  }

  AuthCloudPasswordRecoveryConfirm_Response._();

  factory AuthCloudPasswordRecoveryConfirm_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRecoveryConfirm_Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRecoveryConfirm.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecoveryConfirm_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecoveryConfirm_Response copyWith(void Function(AuthCloudPasswordRecoveryConfirm_Response) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRecoveryConfirm_Response))
          as AuthCloudPasswordRecoveryConfirm_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecoveryConfirm_Response create() => AuthCloudPasswordRecoveryConfirm_Response._();
  @$core.override
  AuthCloudPasswordRecoveryConfirm_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecoveryConfirm_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRecoveryConfirm_Response>(create);
  static AuthCloudPasswordRecoveryConfirm_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
}

/// Подтверждение восстановления: код из письма + новый пароль (pre-hash).
class AuthCloudPasswordRecoveryConfirm extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRecoveryConfirm() => create();

  AuthCloudPasswordRecoveryConfirm._();

  factory AuthCloudPasswordRecoveryConfirm.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRecoveryConfirm.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRecoveryConfirm',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecoveryConfirm clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRecoveryConfirm copyWith(void Function(AuthCloudPasswordRecoveryConfirm) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRecoveryConfirm)) as AuthCloudPasswordRecoveryConfirm;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecoveryConfirm create() => AuthCloudPasswordRecoveryConfirm._();
  @$core.override
  AuthCloudPasswordRecoveryConfirm createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRecoveryConfirm getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRecoveryConfirm>(create);
  static AuthCloudPasswordRecoveryConfirm? _defaultInstance;
}

class CloudPasswordInfo_Request extends $pb.GeneratedMessage {
  factory CloudPasswordInfo_Request() => create();

  CloudPasswordInfo_Request._();

  factory CloudPasswordInfo_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordInfo_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordInfo.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordInfo_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordInfo_Request copyWith(void Function(CloudPasswordInfo_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordInfo_Request)) as CloudPasswordInfo_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordInfo_Request create() => CloudPasswordInfo_Request._();
  @$core.override
  CloudPasswordInfo_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordInfo_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordInfo_Request>(create);
  static CloudPasswordInfo_Request? _defaultInstance;
}

class CloudPasswordInfo_Response extends $pb.GeneratedMessage {
  factory CloudPasswordInfo_Response({
    $core.bool? isEnabled,
    $core.String? maskedEmail,
    $core.bool? isEmailVerified,
  }) {
    final result = create();
    if (isEnabled != null) result.isEnabled = isEnabled;
    if (maskedEmail != null) result.maskedEmail = maskedEmail;
    if (isEmailVerified != null) result.isEmailVerified = isEmailVerified;
    return result;
  }

  CloudPasswordInfo_Response._();

  factory CloudPasswordInfo_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordInfo_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordInfo.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isEnabled', protoName: 'isEnabled')
    ..aOS(2, _omitFieldNames ? '' : 'maskedEmail', protoName: 'maskedEmail')
    ..aOB(3, _omitFieldNames ? '' : 'isEmailVerified', protoName: 'isEmailVerified')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordInfo_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordInfo_Response copyWith(void Function(CloudPasswordInfo_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordInfo_Response)) as CloudPasswordInfo_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordInfo_Response create() => CloudPasswordInfo_Response._();
  @$core.override
  CloudPasswordInfo_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordInfo_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordInfo_Response>(create);
  static CloudPasswordInfo_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isEnabled => $_getBF(0);
  @$pb.TagNumber(1)
  set isEnabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get maskedEmail => $_getSZ(1);
  @$pb.TagNumber(2)
  set maskedEmail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaskedEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaskedEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isEmailVerified => $_getBF(2);
  @$pb.TagNumber(3)
  set isEmailVerified($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsEmailVerified() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsEmailVerified() => $_clearField(3);
}

/// Текущее состояние облачного пароля для экрана настроек.
class CloudPasswordInfo extends $pb.GeneratedMessage {
  factory CloudPasswordInfo() => create();

  CloudPasswordInfo._();

  factory CloudPasswordInfo.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordInfo.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordInfo copyWith(void Function(CloudPasswordInfo) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordInfo)) as CloudPasswordInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordInfo create() => CloudPasswordInfo._();
  @$core.override
  CloudPasswordInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordInfo>(create);
  static CloudPasswordInfo? _defaultInstance;
}

class CloudPasswordSet_Request extends $pb.GeneratedMessage {
  factory CloudPasswordSet_Request({
    $core.List<$core.int>? currentPwHash,
    $core.List<$core.int>? newPwHash,
  }) {
    final result = create();
    if (currentPwHash != null) result.currentPwHash = currentPwHash;
    if (newPwHash != null) result.newPwHash = newPwHash;
    return result;
  }

  CloudPasswordSet_Request._();

  factory CloudPasswordSet_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordSet_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordSet.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'currentPwHash', $pb.PbFieldType.OY, protoName: 'currentPwHash')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'newPwHash', $pb.PbFieldType.OY, protoName: 'newPwHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordSet_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordSet_Request copyWith(void Function(CloudPasswordSet_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordSet_Request)) as CloudPasswordSet_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordSet_Request create() => CloudPasswordSet_Request._();
  @$core.override
  CloudPasswordSet_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordSet_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordSet_Request>(create);
  static CloudPasswordSet_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get currentPwHash => $_getN(0);
  @$pb.TagNumber(1)
  set currentPwHash($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentPwHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentPwHash() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get newPwHash => $_getN(1);
  @$pb.TagNumber(2)
  set newPwHash($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewPwHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewPwHash() => $_clearField(2);
}

class CloudPasswordSet_Response extends $pb.GeneratedMessage {
  factory CloudPasswordSet_Response({
    $core.bool? success,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    return result;
  }

  CloudPasswordSet_Response._();

  factory CloudPasswordSet_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordSet_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordSet.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordSet_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordSet_Response copyWith(void Function(CloudPasswordSet_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordSet_Response)) as CloudPasswordSet_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordSet_Response create() => CloudPasswordSet_Response._();
  @$core.override
  CloudPasswordSet_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordSet_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordSet_Response>(create);
  static CloudPasswordSet_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
}

/// Установка/смена пароля. currentPwHash пуст при первичной установке.
class CloudPasswordSet extends $pb.GeneratedMessage {
  factory CloudPasswordSet() => create();

  CloudPasswordSet._();

  factory CloudPasswordSet.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordSet.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordSet copyWith(void Function(CloudPasswordSet) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordSet)) as CloudPasswordSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordSet create() => CloudPasswordSet._();
  @$core.override
  CloudPasswordSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordSet getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordSet>(create);
  static CloudPasswordSet? _defaultInstance;
}

class CloudPasswordDisable_Request extends $pb.GeneratedMessage {
  factory CloudPasswordDisable_Request({
    $core.List<$core.int>? currentPwHash,
  }) {
    final result = create();
    if (currentPwHash != null) result.currentPwHash = currentPwHash;
    return result;
  }

  CloudPasswordDisable_Request._();

  factory CloudPasswordDisable_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordDisable_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordDisable.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'currentPwHash', $pb.PbFieldType.OY, protoName: 'currentPwHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordDisable_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordDisable_Request copyWith(void Function(CloudPasswordDisable_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordDisable_Request)) as CloudPasswordDisable_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordDisable_Request create() => CloudPasswordDisable_Request._();
  @$core.override
  CloudPasswordDisable_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordDisable_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordDisable_Request>(create);
  static CloudPasswordDisable_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get currentPwHash => $_getN(0);
  @$pb.TagNumber(1)
  set currentPwHash($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentPwHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentPwHash() => $_clearField(1);
}

class CloudPasswordDisable_Response extends $pb.GeneratedMessage {
  factory CloudPasswordDisable_Response({
    $core.bool? success,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    return result;
  }

  CloudPasswordDisable_Response._();

  factory CloudPasswordDisable_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordDisable_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordDisable.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordDisable_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordDisable_Response copyWith(void Function(CloudPasswordDisable_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordDisable_Response)) as CloudPasswordDisable_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordDisable_Response create() => CloudPasswordDisable_Response._();
  @$core.override
  CloudPasswordDisable_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordDisable_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordDisable_Response>(create);
  static CloudPasswordDisable_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
}

/// Отключение облачного пароля (с проверкой текущего).
class CloudPasswordDisable extends $pb.GeneratedMessage {
  factory CloudPasswordDisable() => create();

  CloudPasswordDisable._();

  factory CloudPasswordDisable.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordDisable.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordDisable',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordDisable clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordDisable copyWith(void Function(CloudPasswordDisable) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordDisable)) as CloudPasswordDisable;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordDisable create() => CloudPasswordDisable._();
  @$core.override
  CloudPasswordDisable createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordDisable getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordDisable>(create);
  static CloudPasswordDisable? _defaultInstance;
}

class CloudPasswordEmailSet_Request extends $pb.GeneratedMessage {
  factory CloudPasswordEmailSet_Request({
    $core.List<$core.int>? currentPwHash,
    $core.String? email,
  }) {
    final result = create();
    if (currentPwHash != null) result.currentPwHash = currentPwHash;
    if (email != null) result.email = email;
    return result;
  }

  CloudPasswordEmailSet_Request._();

  factory CloudPasswordEmailSet_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordEmailSet_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordEmailSet.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'currentPwHash', $pb.PbFieldType.OY, protoName: 'currentPwHash')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailSet_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailSet_Request copyWith(void Function(CloudPasswordEmailSet_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordEmailSet_Request)) as CloudPasswordEmailSet_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailSet_Request create() => CloudPasswordEmailSet_Request._();
  @$core.override
  CloudPasswordEmailSet_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailSet_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordEmailSet_Request>(create);
  static CloudPasswordEmailSet_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get currentPwHash => $_getN(0);
  @$pb.TagNumber(1)
  set currentPwHash($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentPwHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentPwHash() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);
}

class CloudPasswordEmailSet_Response extends $pb.GeneratedMessage {
  factory CloudPasswordEmailSet_Response({
    $core.bool? success,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    return result;
  }

  CloudPasswordEmailSet_Response._();

  factory CloudPasswordEmailSet_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordEmailSet_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordEmailSet.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailSet_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailSet_Response copyWith(void Function(CloudPasswordEmailSet_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordEmailSet_Response)) as CloudPasswordEmailSet_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailSet_Response create() => CloudPasswordEmailSet_Response._();
  @$core.override
  CloudPasswordEmailSet_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailSet_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordEmailSet_Response>(create);
  static CloudPasswordEmailSet_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
}

/// Привязка/смена email: шлёт код верификации на новый адрес.
class CloudPasswordEmailSet extends $pb.GeneratedMessage {
  factory CloudPasswordEmailSet() => create();

  CloudPasswordEmailSet._();

  factory CloudPasswordEmailSet.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordEmailSet.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordEmailSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailSet copyWith(void Function(CloudPasswordEmailSet) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordEmailSet)) as CloudPasswordEmailSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailSet create() => CloudPasswordEmailSet._();
  @$core.override
  CloudPasswordEmailSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailSet getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordEmailSet>(create);
  static CloudPasswordEmailSet? _defaultInstance;
}

class CloudPasswordEmailVerify_Request extends $pb.GeneratedMessage {
  factory CloudPasswordEmailVerify_Request({
    $core.String? code,
  }) {
    final result = create();
    if (code != null) result.code = code;
    return result;
  }

  CloudPasswordEmailVerify_Request._();

  factory CloudPasswordEmailVerify_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordEmailVerify_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordEmailVerify.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailVerify_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailVerify_Request copyWith(void Function(CloudPasswordEmailVerify_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordEmailVerify_Request)) as CloudPasswordEmailVerify_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailVerify_Request create() => CloudPasswordEmailVerify_Request._();
  @$core.override
  CloudPasswordEmailVerify_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailVerify_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordEmailVerify_Request>(create);
  static CloudPasswordEmailVerify_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);
}

class CloudPasswordEmailVerify_Response extends $pb.GeneratedMessage {
  factory CloudPasswordEmailVerify_Response({
    $core.bool? success,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    return result;
  }

  CloudPasswordEmailVerify_Response._();

  factory CloudPasswordEmailVerify_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordEmailVerify_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordEmailVerify.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailVerify_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailVerify_Response copyWith(void Function(CloudPasswordEmailVerify_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordEmailVerify_Response)) as CloudPasswordEmailVerify_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailVerify_Response create() => CloudPasswordEmailVerify_Response._();
  @$core.override
  CloudPasswordEmailVerify_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailVerify_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordEmailVerify_Response>(create);
  static CloudPasswordEmailVerify_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
}

/// Подтверждение email кодом из письма.
class CloudPasswordEmailVerify extends $pb.GeneratedMessage {
  factory CloudPasswordEmailVerify() => create();

  CloudPasswordEmailVerify._();

  factory CloudPasswordEmailVerify.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordEmailVerify.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordEmailVerify',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailVerify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordEmailVerify copyWith(void Function(CloudPasswordEmailVerify) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordEmailVerify)) as CloudPasswordEmailVerify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailVerify create() => CloudPasswordEmailVerify._();
  @$core.override
  CloudPasswordEmailVerify createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordEmailVerify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordEmailVerify>(create);
  static CloudPasswordEmailVerify? _defaultInstance;
}

class CloudPasswordVerify_Request extends $pb.GeneratedMessage {
  factory CloudPasswordVerify_Request({
    $core.List<$core.int>? pwHash,
  }) {
    final result = create();
    if (pwHash != null) result.pwHash = pwHash;
    return result;
  }

  CloudPasswordVerify_Request._();

  factory CloudPasswordVerify_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordVerify_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordVerify.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'pwHash', $pb.PbFieldType.OY, protoName: 'pwHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordVerify_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordVerify_Request copyWith(void Function(CloudPasswordVerify_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordVerify_Request)) as CloudPasswordVerify_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordVerify_Request create() => CloudPasswordVerify_Request._();
  @$core.override
  CloudPasswordVerify_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordVerify_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordVerify_Request>(create);
  static CloudPasswordVerify_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get pwHash => $_getN(0);
  @$pb.TagNumber(1)
  set pwHash($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPwHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearPwHash() => $_clearField(1);
}

class CloudPasswordVerify_Response extends $pb.GeneratedMessage {
  factory CloudPasswordVerify_Response({
    $core.bool? success,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    return result;
  }

  CloudPasswordVerify_Response._();

  factory CloudPasswordVerify_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordVerify_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordVerify.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordVerify_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordVerify_Response copyWith(void Function(CloudPasswordVerify_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordVerify_Response)) as CloudPasswordVerify_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordVerify_Response create() => CloudPasswordVerify_Response._();
  @$core.override
  CloudPasswordVerify_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordVerify_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordVerify_Response>(create);
  static CloudPasswordVerify_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
}

/// Проверка текущего пароля для «разблокировки» раздела настроек (когда пароль
/// установлен). Успех открывает меню; неверный — ошибка.
class CloudPasswordVerify extends $pb.GeneratedMessage {
  factory CloudPasswordVerify() => create();

  CloudPasswordVerify._();

  factory CloudPasswordVerify.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordVerify.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordVerify',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordVerify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordVerify copyWith(void Function(CloudPasswordVerify) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordVerify)) as CloudPasswordVerify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordVerify create() => CloudPasswordVerify._();
  @$core.override
  CloudPasswordVerify createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordVerify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordVerify>(create);
  static CloudPasswordVerify? _defaultInstance;
}

class CloudPasswordRecoverySend_Request extends $pb.GeneratedMessage {
  factory CloudPasswordRecoverySend_Request() => create();

  CloudPasswordRecoverySend_Request._();

  factory CloudPasswordRecoverySend_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordRecoverySend_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordRecoverySend.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRecoverySend_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRecoverySend_Request copyWith(void Function(CloudPasswordRecoverySend_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordRecoverySend_Request)) as CloudPasswordRecoverySend_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordRecoverySend_Request create() => CloudPasswordRecoverySend_Request._();
  @$core.override
  CloudPasswordRecoverySend_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordRecoverySend_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordRecoverySend_Request>(create);
  static CloudPasswordRecoverySend_Request? _defaultInstance;
}

class CloudPasswordRecoverySend_Response extends $pb.GeneratedMessage {
  factory CloudPasswordRecoverySend_Response({
    $core.String? maskedEmail,
    $core.String? error,
  }) {
    final result = create();
    if (maskedEmail != null) result.maskedEmail = maskedEmail;
    if (error != null) result.error = error;
    return result;
  }

  CloudPasswordRecoverySend_Response._();

  factory CloudPasswordRecoverySend_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordRecoverySend_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordRecoverySend.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'maskedEmail', protoName: 'maskedEmail')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRecoverySend_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRecoverySend_Response copyWith(void Function(CloudPasswordRecoverySend_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordRecoverySend_Response)) as CloudPasswordRecoverySend_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordRecoverySend_Response create() => CloudPasswordRecoverySend_Response._();
  @$core.override
  CloudPasswordRecoverySend_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordRecoverySend_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordRecoverySend_Response>(create);
  static CloudPasswordRecoverySend_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get maskedEmail => $_getSZ(0);
  @$pb.TagNumber(1)
  set maskedEmail($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaskedEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaskedEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
}

/// Восстановление в настройках: отправка кода на уже привязанный (подтверждённый)
/// email, когда пользователь забыл облачный пароль.
class CloudPasswordRecoverySend extends $pb.GeneratedMessage {
  factory CloudPasswordRecoverySend() => create();

  CloudPasswordRecoverySend._();

  factory CloudPasswordRecoverySend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordRecoverySend.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordRecoverySend',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRecoverySend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRecoverySend copyWith(void Function(CloudPasswordRecoverySend) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordRecoverySend)) as CloudPasswordRecoverySend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordRecoverySend create() => CloudPasswordRecoverySend._();
  @$core.override
  CloudPasswordRecoverySend createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordRecoverySend getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordRecoverySend>(create);
  static CloudPasswordRecoverySend? _defaultInstance;
}

class CloudPasswordReset_Request extends $pb.GeneratedMessage {
  factory CloudPasswordReset_Request({
    $core.String? code,
    $core.List<$core.int>? newPwHash,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (newPwHash != null) result.newPwHash = newPwHash;
    return result;
  }

  CloudPasswordReset_Request._();

  factory CloudPasswordReset_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordReset_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordReset.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'newPwHash', $pb.PbFieldType.OY, protoName: 'newPwHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordReset_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordReset_Request copyWith(void Function(CloudPasswordReset_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordReset_Request)) as CloudPasswordReset_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordReset_Request create() => CloudPasswordReset_Request._();
  @$core.override
  CloudPasswordReset_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordReset_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordReset_Request>(create);
  static CloudPasswordReset_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get newPwHash => $_getN(1);
  @$pb.TagNumber(2)
  set newPwHash($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewPwHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewPwHash() => $_clearField(2);
}

class CloudPasswordReset_Response extends $pb.GeneratedMessage {
  factory CloudPasswordReset_Response({
    $core.bool? success,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    return result;
  }

  CloudPasswordReset_Response._();

  factory CloudPasswordReset_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordReset_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordReset.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordReset_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordReset_Response copyWith(void Function(CloudPasswordReset_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordReset_Response)) as CloudPasswordReset_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordReset_Response create() => CloudPasswordReset_Response._();
  @$core.override
  CloudPasswordReset_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordReset_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordReset_Response>(create);
  static CloudPasswordReset_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
}

/// Сброс пароля по коду из письма (после CloudPasswordRecoverySend). Ставит новый
/// пароль без знания старого и ОЧИЩАЕТ email (его нужно привязать заново).
class CloudPasswordReset extends $pb.GeneratedMessage {
  factory CloudPasswordReset() => create();

  CloudPasswordReset._();

  factory CloudPasswordReset.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordReset.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordReset',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordReset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordReset copyWith(void Function(CloudPasswordReset) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordReset)) as CloudPasswordReset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordReset create() => CloudPasswordReset._();
  @$core.override
  CloudPasswordReset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordReset getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordReset>(create);
  static CloudPasswordReset? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
