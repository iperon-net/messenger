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

class AuthCloudPasswordStart_Request extends $pb.GeneratedMessage {
  factory AuthCloudPasswordStart_Request({
    $core.List<$core.int>? confirmationSession,
    $core.List<$core.int>? ke1,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (ke1 != null) result.ke1 = ke1;
    return result;
  }

  AuthCloudPasswordStart_Request._();

  factory AuthCloudPasswordStart_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordStart_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordStart.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'ke1', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordStart_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordStart_Request copyWith(void Function(AuthCloudPasswordStart_Request) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordStart_Request)) as AuthCloudPasswordStart_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordStart_Request create() => AuthCloudPasswordStart_Request._();
  @$core.override
  AuthCloudPasswordStart_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordStart_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordStart_Request>(create);
  static AuthCloudPasswordStart_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get ke1 => $_getN(1);
  @$pb.TagNumber(2)
  set ke1($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKe1() => $_has(1);
  @$pb.TagNumber(2)
  void clearKe1() => $_clearField(2);
}

class AuthCloudPasswordStart_Response extends $pb.GeneratedMessage {
  factory AuthCloudPasswordStart_Response({
    $core.List<$core.int>? ke2,
    $core.int? attemptsLeft,
  }) {
    final result = create();
    if (ke2 != null) result.ke2 = ke2;
    if (attemptsLeft != null) result.attemptsLeft = attemptsLeft;
    return result;
  }

  AuthCloudPasswordStart_Response._();

  factory AuthCloudPasswordStart_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordStart_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordStart.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'ke2', $pb.PbFieldType.OY)
    ..aI(2, _omitFieldNames ? '' : 'attemptsLeft', protoName: 'attemptsLeft')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordStart_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordStart_Response copyWith(void Function(AuthCloudPasswordStart_Response) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordStart_Response)) as AuthCloudPasswordStart_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordStart_Response create() => AuthCloudPasswordStart_Response._();
  @$core.override
  AuthCloudPasswordStart_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordStart_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordStart_Response>(create);
  static AuthCloudPasswordStart_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ke2 => $_getN(0);
  @$pb.TagNumber(1)
  set ke2($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKe2() => $_has(0);
  @$pb.TagNumber(1)
  void clearKe2() => $_clearField(1);

  /// Сколько попыток останется, если эта окажется неверной.
  @$pb.TagNumber(2)
  $core.int get attemptsLeft => $_getIZ(1);
  @$pb.TagNumber(2)
  set attemptsLeft($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAttemptsLeft() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttemptsLeft() => $_clearField(2);
}

/// Вход, шаг 1: KE1 → KE2. Каждый вызов — попытка (не больше 5 на
/// confirmationSession, плюс лимит на аккаунт).
class AuthCloudPasswordStart extends $pb.GeneratedMessage {
  factory AuthCloudPasswordStart() => create();

  AuthCloudPasswordStart._();

  factory AuthCloudPasswordStart.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordStart.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordStart copyWith(void Function(AuthCloudPasswordStart) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordStart)) as AuthCloudPasswordStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordStart create() => AuthCloudPasswordStart._();
  @$core.override
  AuthCloudPasswordStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordStart getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordStart>(create);
  static AuthCloudPasswordStart? _defaultInstance;
}

class AuthCloudPasswordFinish_Request extends $pb.GeneratedMessage {
  factory AuthCloudPasswordFinish_Request({
    $core.List<$core.int>? confirmationSession,
    $core.List<$core.int>? ke3,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (ke3 != null) result.ke3 = ke3;
    return result;
  }

  AuthCloudPasswordFinish_Request._();

  factory AuthCloudPasswordFinish_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordFinish_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordFinish.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'ke3', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordFinish_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordFinish_Request copyWith(void Function(AuthCloudPasswordFinish_Request) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordFinish_Request)) as AuthCloudPasswordFinish_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordFinish_Request create() => AuthCloudPasswordFinish_Request._();
  @$core.override
  AuthCloudPasswordFinish_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordFinish_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordFinish_Request>(create);
  static AuthCloudPasswordFinish_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get ke3 => $_getN(1);
  @$pb.TagNumber(2)
  set ke3($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKe3() => $_has(1);
  @$pb.TagNumber(2)
  void clearKe3() => $_clearField(2);
}

class AuthCloudPasswordFinish_Response extends $pb.GeneratedMessage {
  factory AuthCloudPasswordFinish_Response({
    $core.bool? success,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    return result;
  }

  AuthCloudPasswordFinish_Response._();

  factory AuthCloudPasswordFinish_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordFinish_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordFinish.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordFinish_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordFinish_Response copyWith(void Function(AuthCloudPasswordFinish_Response) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordFinish_Response)) as AuthCloudPasswordFinish_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordFinish_Response create() => AuthCloudPasswordFinish_Response._();
  @$core.override
  AuthCloudPasswordFinish_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordFinish_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordFinish_Response>(create);
  static AuthCloudPasswordFinish_Response? _defaultInstance;

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

/// Вход, шаг 2: KE3. Успех помечает confirmationSession пройденной — дальше
/// AUTH_CONFIRMATION.
class AuthCloudPasswordFinish extends $pb.GeneratedMessage {
  factory AuthCloudPasswordFinish() => create();

  AuthCloudPasswordFinish._();

  factory AuthCloudPasswordFinish.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordFinish.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordFinish',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordFinish clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordFinish copyWith(void Function(AuthCloudPasswordFinish) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordFinish)) as AuthCloudPasswordFinish;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordFinish create() => AuthCloudPasswordFinish._();
  @$core.override
  AuthCloudPasswordFinish createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordFinish getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordFinish>(create);
  static AuthCloudPasswordFinish? _defaultInstance;
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

  /// Не заполняется (раньше — маскированный email).
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
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (code != null) result.code = code;
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

/// Подтверждение восстановления кодом из письма. Успех открывает регистрацию
/// нового пароля по этой confirmationSession (AuthCloudPasswordRegister*).
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

class AuthCloudPasswordRegisterStart_Request extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRegisterStart_Request({
    $core.List<$core.int>? confirmationSession,
    $core.List<$core.int>? registrationRequest,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (registrationRequest != null) result.registrationRequest = registrationRequest;
    return result;
  }

  AuthCloudPasswordRegisterStart_Request._();

  factory AuthCloudPasswordRegisterStart_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRegisterStart_Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRegisterStart.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'registrationRequest', $pb.PbFieldType.OY, protoName: 'registrationRequest')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterStart_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterStart_Request copyWith(void Function(AuthCloudPasswordRegisterStart_Request) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRegisterStart_Request)) as AuthCloudPasswordRegisterStart_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterStart_Request create() => AuthCloudPasswordRegisterStart_Request._();
  @$core.override
  AuthCloudPasswordRegisterStart_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterStart_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRegisterStart_Request>(create);
  static AuthCloudPasswordRegisterStart_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get registrationRequest => $_getN(1);
  @$pb.TagNumber(2)
  set registrationRequest($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegistrationRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegistrationRequest() => $_clearField(2);
}

class AuthCloudPasswordRegisterStart_Response extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRegisterStart_Response({
    $core.List<$core.int>? registrationResponse,
  }) {
    final result = create();
    if (registrationResponse != null) result.registrationResponse = registrationResponse;
    return result;
  }

  AuthCloudPasswordRegisterStart_Response._();

  factory AuthCloudPasswordRegisterStart_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRegisterStart_Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRegisterStart.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'registrationResponse', $pb.PbFieldType.OY, protoName: 'registrationResponse')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterStart_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterStart_Response copyWith(void Function(AuthCloudPasswordRegisterStart_Response) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRegisterStart_Response)) as AuthCloudPasswordRegisterStart_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterStart_Response create() => AuthCloudPasswordRegisterStart_Response._();
  @$core.override
  AuthCloudPasswordRegisterStart_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterStart_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRegisterStart_Response>(create);
  static AuthCloudPasswordRegisterStart_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get registrationResponse => $_getN(0);
  @$pb.TagNumber(1)
  set registrationResponse($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRegistrationResponse() => $_has(0);
  @$pb.TagNumber(1)
  void clearRegistrationResponse() => $_clearField(1);
}

/// Новый пароль при входе (после AuthCloudPasswordRecoveryConfirm), шаг 1.
class AuthCloudPasswordRegisterStart extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRegisterStart() => create();

  AuthCloudPasswordRegisterStart._();

  factory AuthCloudPasswordRegisterStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRegisterStart.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRegisterStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterStart copyWith(void Function(AuthCloudPasswordRegisterStart) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRegisterStart)) as AuthCloudPasswordRegisterStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterStart create() => AuthCloudPasswordRegisterStart._();
  @$core.override
  AuthCloudPasswordRegisterStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterStart getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRegisterStart>(create);
  static AuthCloudPasswordRegisterStart? _defaultInstance;
}

class AuthCloudPasswordRegisterFinish_Request extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRegisterFinish_Request({
    $core.List<$core.int>? confirmationSession,
    $core.List<$core.int>? record,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (record != null) result.record = record;
    return result;
  }

  AuthCloudPasswordRegisterFinish_Request._();

  factory AuthCloudPasswordRegisterFinish_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRegisterFinish_Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRegisterFinish.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'record', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterFinish_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterFinish_Request copyWith(void Function(AuthCloudPasswordRegisterFinish_Request) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRegisterFinish_Request)) as AuthCloudPasswordRegisterFinish_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterFinish_Request create() => AuthCloudPasswordRegisterFinish_Request._();
  @$core.override
  AuthCloudPasswordRegisterFinish_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterFinish_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRegisterFinish_Request>(create);
  static AuthCloudPasswordRegisterFinish_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get record => $_getN(1);
  @$pb.TagNumber(2)
  set record($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecord() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecord() => $_clearField(2);
}

class AuthCloudPasswordRegisterFinish_Response extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRegisterFinish_Response({
    $core.bool? success,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    return result;
  }

  AuthCloudPasswordRegisterFinish_Response._();

  factory AuthCloudPasswordRegisterFinish_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRegisterFinish_Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRegisterFinish.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterFinish_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterFinish_Response copyWith(void Function(AuthCloudPasswordRegisterFinish_Response) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRegisterFinish_Response)) as AuthCloudPasswordRegisterFinish_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterFinish_Response create() => AuthCloudPasswordRegisterFinish_Response._();
  @$core.override
  AuthCloudPasswordRegisterFinish_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterFinish_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRegisterFinish_Response>(create);
  static AuthCloudPasswordRegisterFinish_Response? _defaultInstance;

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

/// Новый пароль при входе, шаг 2: запись сохраняется, confirmationSession
/// помечается пройденной — дальше AUTH_CONFIRMATION.
class AuthCloudPasswordRegisterFinish extends $pb.GeneratedMessage {
  factory AuthCloudPasswordRegisterFinish() => create();

  AuthCloudPasswordRegisterFinish._();

  factory AuthCloudPasswordRegisterFinish.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthCloudPasswordRegisterFinish.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthCloudPasswordRegisterFinish',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterFinish clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthCloudPasswordRegisterFinish copyWith(void Function(AuthCloudPasswordRegisterFinish) updates) =>
      super.copyWith((message) => updates(message as AuthCloudPasswordRegisterFinish)) as AuthCloudPasswordRegisterFinish;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterFinish create() => AuthCloudPasswordRegisterFinish._();
  @$core.override
  AuthCloudPasswordRegisterFinish createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthCloudPasswordRegisterFinish getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthCloudPasswordRegisterFinish>(create);
  static AuthCloudPasswordRegisterFinish? _defaultInstance;
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

class CloudPasswordAuthStart_Request extends $pb.GeneratedMessage {
  factory CloudPasswordAuthStart_Request({
    $core.List<$core.int>? ke1,
  }) {
    final result = create();
    if (ke1 != null) result.ke1 = ke1;
    return result;
  }

  CloudPasswordAuthStart_Request._();

  factory CloudPasswordAuthStart_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordAuthStart_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordAuthStart.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'ke1', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthStart_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthStart_Request copyWith(void Function(CloudPasswordAuthStart_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordAuthStart_Request)) as CloudPasswordAuthStart_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthStart_Request create() => CloudPasswordAuthStart_Request._();
  @$core.override
  CloudPasswordAuthStart_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthStart_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordAuthStart_Request>(create);
  static CloudPasswordAuthStart_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ke1 => $_getN(0);
  @$pb.TagNumber(1)
  set ke1($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKe1() => $_has(0);
  @$pb.TagNumber(1)
  void clearKe1() => $_clearField(1);
}

class CloudPasswordAuthStart_Response extends $pb.GeneratedMessage {
  factory CloudPasswordAuthStart_Response({
    $core.List<$core.int>? ke2,
  }) {
    final result = create();
    if (ke2 != null) result.ke2 = ke2;
    return result;
  }

  CloudPasswordAuthStart_Response._();

  factory CloudPasswordAuthStart_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordAuthStart_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordAuthStart.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'ke2', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthStart_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthStart_Response copyWith(void Function(CloudPasswordAuthStart_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordAuthStart_Response)) as CloudPasswordAuthStart_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthStart_Response create() => CloudPasswordAuthStart_Response._();
  @$core.override
  CloudPasswordAuthStart_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthStart_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordAuthStart_Response>(create);
  static CloudPasswordAuthStart_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ke2 => $_getN(0);
  @$pb.TagNumber(1)
  set ke2($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKe2() => $_has(0);
  @$pb.TagNumber(1)
  void clearKe2() => $_clearField(1);
}

/// Проверка пароля в настройках («разблокировка»), шаг 1: KE1 → KE2.
class CloudPasswordAuthStart extends $pb.GeneratedMessage {
  factory CloudPasswordAuthStart() => create();

  CloudPasswordAuthStart._();

  factory CloudPasswordAuthStart.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordAuthStart.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordAuthStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthStart copyWith(void Function(CloudPasswordAuthStart) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordAuthStart)) as CloudPasswordAuthStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthStart create() => CloudPasswordAuthStart._();
  @$core.override
  CloudPasswordAuthStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthStart getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordAuthStart>(create);
  static CloudPasswordAuthStart? _defaultInstance;
}

class CloudPasswordAuthFinish_Request extends $pb.GeneratedMessage {
  factory CloudPasswordAuthFinish_Request({
    $core.List<$core.int>? ke3,
  }) {
    final result = create();
    if (ke3 != null) result.ke3 = ke3;
    return result;
  }

  CloudPasswordAuthFinish_Request._();

  factory CloudPasswordAuthFinish_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordAuthFinish_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordAuthFinish.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'ke3', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthFinish_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthFinish_Request copyWith(void Function(CloudPasswordAuthFinish_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordAuthFinish_Request)) as CloudPasswordAuthFinish_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthFinish_Request create() => CloudPasswordAuthFinish_Request._();
  @$core.override
  CloudPasswordAuthFinish_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthFinish_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordAuthFinish_Request>(create);
  static CloudPasswordAuthFinish_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ke3 => $_getN(0);
  @$pb.TagNumber(1)
  set ke3($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKe3() => $_has(0);
  @$pb.TagNumber(1)
  void clearKe3() => $_clearField(1);
}

class CloudPasswordAuthFinish_Response extends $pb.GeneratedMessage {
  factory CloudPasswordAuthFinish_Response({
    $core.List<$core.int>? token,
  }) {
    final result = create();
    if (token != null) result.token = token;
    return result;
  }

  CloudPasswordAuthFinish_Response._();

  factory CloudPasswordAuthFinish_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordAuthFinish_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordAuthFinish.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'token', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthFinish_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthFinish_Response copyWith(void Function(CloudPasswordAuthFinish_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordAuthFinish_Response)) as CloudPasswordAuthFinish_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthFinish_Response create() => CloudPasswordAuthFinish_Response._();
  @$core.override
  CloudPasswordAuthFinish_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthFinish_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordAuthFinish_Response>(create);
  static CloudPasswordAuthFinish_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get token => $_getN(0);
  @$pb.TagNumber(1)
  set token($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

/// Проверка пароля в настройках, шаг 2: KE3 → token для действий.
class CloudPasswordAuthFinish extends $pb.GeneratedMessage {
  factory CloudPasswordAuthFinish() => create();

  CloudPasswordAuthFinish._();

  factory CloudPasswordAuthFinish.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordAuthFinish.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordAuthFinish',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthFinish clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordAuthFinish copyWith(void Function(CloudPasswordAuthFinish) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordAuthFinish)) as CloudPasswordAuthFinish;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthFinish create() => CloudPasswordAuthFinish._();
  @$core.override
  CloudPasswordAuthFinish createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordAuthFinish getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordAuthFinish>(create);
  static CloudPasswordAuthFinish? _defaultInstance;
}

class CloudPasswordRegisterStart_Request extends $pb.GeneratedMessage {
  factory CloudPasswordRegisterStart_Request({
    $core.List<$core.int>? token,
    $core.List<$core.int>? registrationRequest,
  }) {
    final result = create();
    if (token != null) result.token = token;
    if (registrationRequest != null) result.registrationRequest = registrationRequest;
    return result;
  }

  CloudPasswordRegisterStart_Request._();

  factory CloudPasswordRegisterStart_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordRegisterStart_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordRegisterStart.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'token', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'registrationRequest', $pb.PbFieldType.OY, protoName: 'registrationRequest')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterStart_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterStart_Request copyWith(void Function(CloudPasswordRegisterStart_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordRegisterStart_Request)) as CloudPasswordRegisterStart_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterStart_Request create() => CloudPasswordRegisterStart_Request._();
  @$core.override
  CloudPasswordRegisterStart_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterStart_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordRegisterStart_Request>(create);
  static CloudPasswordRegisterStart_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get token => $_getN(0);
  @$pb.TagNumber(1)
  set token($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get registrationRequest => $_getN(1);
  @$pb.TagNumber(2)
  set registrationRequest($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegistrationRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegistrationRequest() => $_clearField(2);
}

class CloudPasswordRegisterStart_Response extends $pb.GeneratedMessage {
  factory CloudPasswordRegisterStart_Response({
    $core.List<$core.int>? registrationResponse,
  }) {
    final result = create();
    if (registrationResponse != null) result.registrationResponse = registrationResponse;
    return result;
  }

  CloudPasswordRegisterStart_Response._();

  factory CloudPasswordRegisterStart_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordRegisterStart_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordRegisterStart.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'registrationResponse', $pb.PbFieldType.OY, protoName: 'registrationResponse')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterStart_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterStart_Response copyWith(void Function(CloudPasswordRegisterStart_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordRegisterStart_Response)) as CloudPasswordRegisterStart_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterStart_Response create() => CloudPasswordRegisterStart_Response._();
  @$core.override
  CloudPasswordRegisterStart_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterStart_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordRegisterStart_Response>(create);
  static CloudPasswordRegisterStart_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get registrationResponse => $_getN(0);
  @$pb.TagNumber(1)
  set registrationResponse($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRegistrationResponse() => $_has(0);
  @$pb.TagNumber(1)
  void clearRegistrationResponse() => $_clearField(1);
}

/// Установка / смена / сброс пароля, шаг 1. token не нужен, только если
/// пароля ещё нет.
class CloudPasswordRegisterStart extends $pb.GeneratedMessage {
  factory CloudPasswordRegisterStart() => create();

  CloudPasswordRegisterStart._();

  factory CloudPasswordRegisterStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordRegisterStart.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordRegisterStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterStart copyWith(void Function(CloudPasswordRegisterStart) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordRegisterStart)) as CloudPasswordRegisterStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterStart create() => CloudPasswordRegisterStart._();
  @$core.override
  CloudPasswordRegisterStart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterStart getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordRegisterStart>(create);
  static CloudPasswordRegisterStart? _defaultInstance;
}

class CloudPasswordRegisterFinish_Request extends $pb.GeneratedMessage {
  factory CloudPasswordRegisterFinish_Request({
    $core.List<$core.int>? token,
    $core.List<$core.int>? record,
  }) {
    final result = create();
    if (token != null) result.token = token;
    if (record != null) result.record = record;
    return result;
  }

  CloudPasswordRegisterFinish_Request._();

  factory CloudPasswordRegisterFinish_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordRegisterFinish_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordRegisterFinish.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'token', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'record', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterFinish_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterFinish_Request copyWith(void Function(CloudPasswordRegisterFinish_Request) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordRegisterFinish_Request)) as CloudPasswordRegisterFinish_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterFinish_Request create() => CloudPasswordRegisterFinish_Request._();
  @$core.override
  CloudPasswordRegisterFinish_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterFinish_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordRegisterFinish_Request>(create);
  static CloudPasswordRegisterFinish_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get token => $_getN(0);
  @$pb.TagNumber(1)
  set token($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get record => $_getN(1);
  @$pb.TagNumber(2)
  set record($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecord() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecord() => $_clearField(2);
}

class CloudPasswordRegisterFinish_Response extends $pb.GeneratedMessage {
  factory CloudPasswordRegisterFinish_Response({
    $core.bool? success,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    return result;
  }

  CloudPasswordRegisterFinish_Response._();

  factory CloudPasswordRegisterFinish_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordRegisterFinish_Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordRegisterFinish.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterFinish_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterFinish_Response copyWith(void Function(CloudPasswordRegisterFinish_Response) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordRegisterFinish_Response)) as CloudPasswordRegisterFinish_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterFinish_Response create() => CloudPasswordRegisterFinish_Response._();
  @$core.override
  CloudPasswordRegisterFinish_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterFinish_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordRegisterFinish_Response>(create);
  static CloudPasswordRegisterFinish_Response? _defaultInstance;

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

/// Установка / смена / сброс пароля, шаг 2. После смены выданные token'ы
/// больше не действуют.
class CloudPasswordRegisterFinish extends $pb.GeneratedMessage {
  factory CloudPasswordRegisterFinish() => create();

  CloudPasswordRegisterFinish._();

  factory CloudPasswordRegisterFinish.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudPasswordRegisterFinish.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudPasswordRegisterFinish',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterFinish clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudPasswordRegisterFinish copyWith(void Function(CloudPasswordRegisterFinish) updates) =>
      super.copyWith((message) => updates(message as CloudPasswordRegisterFinish)) as CloudPasswordRegisterFinish;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterFinish create() => CloudPasswordRegisterFinish._();
  @$core.override
  CloudPasswordRegisterFinish createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudPasswordRegisterFinish getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudPasswordRegisterFinish>(create);
  static CloudPasswordRegisterFinish? _defaultInstance;
}

class CloudPasswordDisable_Request extends $pb.GeneratedMessage {
  factory CloudPasswordDisable_Request({
    $core.List<$core.int>? token,
  }) {
    final result = create();
    if (token != null) result.token = token;
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
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'token', $pb.PbFieldType.OY)
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

  @$pb.TagNumber(2)
  $core.List<$core.int> get token => $_getN(0);
  @$pb.TagNumber(2)
  set token($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);
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

/// Отключение облачного пароля.
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
    $core.String? email,
    $core.List<$core.int>? token,
  }) {
    final result = create();
    if (email != null) result.email = email;
    if (token != null) result.token = token;
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
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'token', $pb.PbFieldType.OY)
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

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get token => $_getN(1);
  @$pb.TagNumber(3)
  set token($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(3)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(3)
  void clearToken() => $_clearField(3);
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

/// Привязка/смена email: шлёт код верификации на новый адрес. token нужен, если
/// пароль установлен (email можно привязать и до пароля).
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
  }) {
    final result = create();
    if (code != null) result.code = code;
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
}

class CloudPasswordReset_Response extends $pb.GeneratedMessage {
  factory CloudPasswordReset_Response({
    $core.bool? success,
    $core.String? error,
    $core.List<$core.int>? token,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    if (token != null) result.token = token;
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
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'token', $pb.PbFieldType.OY)
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

  @$pb.TagNumber(3)
  $core.List<$core.int> get token => $_getN(2);
  @$pb.TagNumber(3)
  set token($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearToken() => $_clearField(3);
}

/// Сброс пароля по коду из письма (после CloudPasswordRecoverySend): выдаёт
/// token, годный только для CloudPasswordRegister* (новый пароль без старого).
/// Привязанный email сохраняется.
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
