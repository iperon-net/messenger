// This is a generated file - do not edit.
//
// Generated from protos/push_token_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'push_token_v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'push_token_v1.pbenum.dart';

class RegisterPushToken_Request extends $pb.GeneratedMessage {
  factory RegisterPushToken_Request({
    $core.String? token,
    RegisterPushToken_TokenType? type,
    RegisterPushToken_Platform? platform,
  }) {
    final result = create();
    if (token != null) result.token = token;
    if (type != null) result.type = type;
    if (platform != null) result.platform = platform;
    return result;
  }

  RegisterPushToken_Request._();

  factory RegisterPushToken_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterPushToken_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterPushToken.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aE<RegisterPushToken_TokenType>(2, _omitFieldNames ? '' : 'type', enumValues: RegisterPushToken_TokenType.values)
    ..aE<RegisterPushToken_Platform>(3, _omitFieldNames ? '' : 'platform', enumValues: RegisterPushToken_Platform.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPushToken_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPushToken_Request copyWith(void Function(RegisterPushToken_Request) updates) =>
      super.copyWith((message) => updates(message as RegisterPushToken_Request)) as RegisterPushToken_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPushToken_Request create() => RegisterPushToken_Request._();
  @$core.override
  RegisterPushToken_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterPushToken_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPushToken_Request>(create);
  static RegisterPushToken_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  @$pb.TagNumber(2)
  RegisterPushToken_TokenType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(RegisterPushToken_TokenType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  RegisterPushToken_Platform get platform => $_getN(2);
  @$pb.TagNumber(3)
  set platform(RegisterPushToken_Platform value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);
}

class RegisterPushToken_Response extends $pb.GeneratedMessage {
  factory RegisterPushToken_Response() => create();

  RegisterPushToken_Response._();

  factory RegisterPushToken_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterPushToken_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterPushToken.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPushToken_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPushToken_Response copyWith(void Function(RegisterPushToken_Response) updates) =>
      super.copyWith((message) => updates(message as RegisterPushToken_Response)) as RegisterPushToken_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPushToken_Response create() => RegisterPushToken_Response._();
  @$core.override
  RegisterPushToken_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterPushToken_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPushToken_Response>(create);
  static RegisterPushToken_Response? _defaultInstance;
}

/// RegisterPushToken — регистрация push-токена устройства, чтобы будить входящий
/// звонок, когда персистентный стрим закрыт (приложение в фоне/выгружено). Токен
/// привязывается сервером к текущей сессии (устройству) из крипто-конверта.
///
/// На iOS VoIP-токен (PushKit) отличается от FCM-токена, поэтому тип канала
/// задаётся TokenType: одно устройство может зарегистрировать и FCM (для data-
/// побудки на Android), и APNS_VOIP (для CallKit на iOS). Пустой token стирает
/// ранее сохранённый токен этого типа (разлогин/отзыв).
class RegisterPushToken extends $pb.GeneratedMessage {
  factory RegisterPushToken() => create();

  RegisterPushToken._();

  factory RegisterPushToken.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterPushToken.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterPushToken',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPushToken clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPushToken copyWith(void Function(RegisterPushToken) updates) =>
      super.copyWith((message) => updates(message as RegisterPushToken)) as RegisterPushToken;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPushToken create() => RegisterPushToken._();
  @$core.override
  RegisterPushToken createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterPushToken getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterPushToken>(create);
  static RegisterPushToken? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
