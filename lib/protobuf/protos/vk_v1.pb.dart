// This is a generated file - do not edit.
//
// Generated from protos/vk_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AuthVK_Request extends $pb.GeneratedMessage {
  factory AuthVK_Request({
    $core.String? token,
    $core.String? clientId,
  }) {
    final result = create();
    if (token != null) result.token = token;
    if (clientId != null) result.clientId = clientId;
    return result;
  }

  AuthVK_Request._();

  factory AuthVK_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthVK_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthVK.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOS(2, _omitFieldNames ? '' : 'clientId', protoName: 'clientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthVK_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthVK_Request copyWith(void Function(AuthVK_Request) updates) =>
      super.copyWith((message) => updates(message as AuthVK_Request)) as AuthVK_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthVK_Request create() => AuthVK_Request._();
  @$core.override
  AuthVK_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthVK_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthVK_Request>(create);
  static AuthVK_Request? _defaultInstance;

  /// OAuth access_token, который вернул VK ID SDK.
  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  /// Client_id приложения VK ID, которому SDK выдал токен (iOS или Android).
  @$pb.TagNumber(2)
  $core.String get clientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientId() => $_clearField(2);
}

class AuthVK_Response extends $pb.GeneratedMessage {
  factory AuthVK_Response({
    $core.List<$core.int>? confirmationSession,
    $core.bool? hasTwoStepVerification,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (hasTwoStepVerification != null) result.hasTwoStepVerification = hasTwoStepVerification;
    return result;
  }

  AuthVK_Response._();

  factory AuthVK_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthVK_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthVK.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..aOB(2, _omitFieldNames ? '' : 'hasTwoStepVerification', protoName: 'hasTwoStepVerification')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthVK_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthVK_Response copyWith(void Function(AuthVK_Response) updates) =>
      super.copyWith((message) => updates(message as AuthVK_Response)) as AuthVK_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthVK_Response create() => AuthVK_Response._();
  @$core.override
  AuthVK_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthVK_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthVK_Response>(create);
  static AuthVK_Response? _defaultInstance;

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

/// Вход через VK ID. Клиент (пакет `vkid_flutter_sdk`) получает OAuth
/// access_token нативным SDK и отдаёт его серверу вместе с client_id своего
/// приложения VK ID: у iOS и Android свои client_id, и токен действителен
/// только для того приложения, которому выдан. Сервер проверяет, что client_id
/// входит в разрешённые (настройка сервера `OAuth.Vk.ClientIDs`), затем сам
/// запрашивает id.vk.ru/oauth2/user_info (пара clientId + access_token) и
/// берёт оттуда подтверждённый телефон аккаунта (scope phone). Идентификаторы
/// VK НЕ сохраняются: VK здесь — лишь способ подтвердить номер (как
/// звонок-пароль), пользователь по-прежнему ищется/создаётся по телефону.
///
/// VK-токен разовый: сервер использует его только для этого подтверждения и
/// нигде не сохраняет; клиент его не хранит.
///
/// Pre-auth unary (как AUTH_YANDEX): выдаёт confirmationSession, сессию
/// чеканит AUTH_CONFIRMATION; облачный пароль (двухшаговая проверка) сохраняется.
class AuthVK extends $pb.GeneratedMessage {
  factory AuthVK() => create();

  AuthVK._();

  factory AuthVK.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthVK.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthVK',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthVK clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthVK copyWith(void Function(AuthVK) updates) => super.copyWith((message) => updates(message as AuthVK)) as AuthVK;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthVK create() => AuthVK._();
  @$core.override
  AuthVK createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthVK getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthVK>(create);
  static AuthVK? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
