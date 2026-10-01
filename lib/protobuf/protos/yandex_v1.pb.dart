// This is a generated file - do not edit.
//
// Generated from protos/yandex_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AuthYandex_Request extends $pb.GeneratedMessage {
  factory AuthYandex_Request({
    $core.String? token,
  }) {
    final result = create();
    if (token != null) result.token = token;
    return result;
  }

  AuthYandex_Request._();

  factory AuthYandex_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthYandex_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthYandex.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthYandex_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthYandex_Request copyWith(void Function(AuthYandex_Request) updates) =>
      super.copyWith((message) => updates(message as AuthYandex_Request)) as AuthYandex_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthYandex_Request create() => AuthYandex_Request._();
  @$core.override
  AuthYandex_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthYandex_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthYandex_Request>(create);
  static AuthYandex_Request? _defaultInstance;

  /// OAuth access_token, который вернул Yandex LoginSDK.
  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

class AuthYandex_Response extends $pb.GeneratedMessage {
  factory AuthYandex_Response({
    $core.List<$core.int>? confirmationSession,
    $core.bool? hasTwoStepVerification,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (hasTwoStepVerification != null) result.hasTwoStepVerification = hasTwoStepVerification;
    return result;
  }

  AuthYandex_Response._();

  factory AuthYandex_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthYandex_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthYandex.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..aOB(2, _omitFieldNames ? '' : 'hasTwoStepVerification', protoName: 'hasTwoStepVerification')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthYandex_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthYandex_Response copyWith(void Function(AuthYandex_Response) updates) =>
      super.copyWith((message) => updates(message as AuthYandex_Response)) as AuthYandex_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthYandex_Response create() => AuthYandex_Response._();
  @$core.override
  AuthYandex_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthYandex_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthYandex_Response>(create);
  static AuthYandex_Response? _defaultInstance;

  /// Скармливается AUTH_CONFIRMATION (тот же путь, что call-password/passkey).
  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);

  /// Включена ли двухшаговая проверка: если true — клиент уходит на шаг ввода
  /// облачного пароля (/auth/cloud_password), передав confirmationSession.
  @$pb.TagNumber(2)
  $core.bool get hasTwoStepVerification => $_getBF(1);
  @$pb.TagNumber(2)
  set hasTwoStepVerification($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasTwoStepVerification() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasTwoStepVerification() => $_clearField(2);
}

/// Вход через Яндекс ID. Клиент (пакет `yandex_login_sdk`) получает OAuth
/// access_token нативным SDK и отдаёт его серверу. Сервер сам проверяет токен
/// через login.yandex.ru/info (включая client_id — токен другого приложения не
/// подойдёт) и берёт оттуда подтверждённый телефон аккаунта (scope
/// login:default_phone). Идентификаторы Яндекса НЕ сохраняются: Яндекс здесь —
/// лишь способ подтвердить номер (как звонок-пароль), пользователь по-прежнему
/// ищется/создаётся по телефону, а в users.phoneVerificationSource пишется
/// «yandex». В отличие от звонка-пароля, регион номера не ограничен РФ.
///
/// Pre-auth unary (как PASSKEY_LOGIN_FINISH): выдаёт confirmationSession, сессию
/// чеканит AUTH_CONFIRMATION; облачный пароль (двухшаговая проверка) сохраняется.
class AuthYandex extends $pb.GeneratedMessage {
  factory AuthYandex() => create();

  AuthYandex._();

  factory AuthYandex.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthYandex.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthYandex',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthYandex clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthYandex copyWith(void Function(AuthYandex) updates) => super.copyWith((message) => updates(message as AuthYandex)) as AuthYandex;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthYandex create() => AuthYandex._();
  @$core.override
  AuthYandex createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthYandex getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthYandex>(create);
  static AuthYandex? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
