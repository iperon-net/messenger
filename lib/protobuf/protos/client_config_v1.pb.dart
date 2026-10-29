// This is a generated file - do not edit.
//
// Generated from protos/client_config_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ClientConfig_Request extends $pb.GeneratedMessage {
  factory ClientConfig_Request() => create();

  ClientConfig_Request._();

  factory ClientConfig_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientConfig_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClientConfig.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientConfig_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientConfig_Request copyWith(void Function(ClientConfig_Request) updates) =>
      super.copyWith((message) => updates(message as ClientConfig_Request)) as ClientConfig_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientConfig_Request create() => ClientConfig_Request._();
  @$core.override
  ClientConfig_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClientConfig_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientConfig_Request>(create);
  static ClientConfig_Request? _defaultInstance;
}

class ClientConfig_Response extends $pb.GeneratedMessage {
  factory ClientConfig_Response({
    $core.bool? secretChatsEnabled,
    $core.bool? secretChatsPremiumOnly,
    $core.bool? groupCallsEnabled,
    $core.int? callConnectMaxAttempts,
    $core.int? callPeerConnectionTimeoutSeconds,
    $core.int? callRingTimeoutSeconds,
    $core.String? animatedEmojiUrl,
    $core.String? yandexClientId,
    $core.String? minimalVersion,
  }) {
    final result = create();
    if (secretChatsEnabled != null) result.secretChatsEnabled = secretChatsEnabled;
    if (secretChatsPremiumOnly != null) result.secretChatsPremiumOnly = secretChatsPremiumOnly;
    if (groupCallsEnabled != null) result.groupCallsEnabled = groupCallsEnabled;
    if (callConnectMaxAttempts != null) result.callConnectMaxAttempts = callConnectMaxAttempts;
    if (callPeerConnectionTimeoutSeconds != null) result.callPeerConnectionTimeoutSeconds = callPeerConnectionTimeoutSeconds;
    if (callRingTimeoutSeconds != null) result.callRingTimeoutSeconds = callRingTimeoutSeconds;
    if (animatedEmojiUrl != null) result.animatedEmojiUrl = animatedEmojiUrl;
    if (yandexClientId != null) result.yandexClientId = yandexClientId;
    if (minimalVersion != null) result.minimalVersion = minimalVersion;
    return result;
  }

  ClientConfig_Response._();

  factory ClientConfig_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientConfig_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClientConfig.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'secretChatsEnabled', protoName: 'secretChatsEnabled')
    ..aOB(2, _omitFieldNames ? '' : 'secretChatsPremiumOnly', protoName: 'secretChatsPremiumOnly')
    ..aOB(3, _omitFieldNames ? '' : 'groupCallsEnabled', protoName: 'groupCallsEnabled')
    ..aI(4, _omitFieldNames ? '' : 'callConnectMaxAttempts', protoName: 'callConnectMaxAttempts')
    ..aI(5, _omitFieldNames ? '' : 'callPeerConnectionTimeoutSeconds', protoName: 'callPeerConnectionTimeoutSeconds')
    ..aI(6, _omitFieldNames ? '' : 'callRingTimeoutSeconds', protoName: 'callRingTimeoutSeconds')
    ..aOS(7, _omitFieldNames ? '' : 'animatedEmojiUrl', protoName: 'animatedEmojiUrl')
    ..aOS(8, _omitFieldNames ? '' : 'yandexClientId', protoName: 'yandexClientId')
    ..aOS(9, _omitFieldNames ? '' : 'minimalVersion', protoName: 'minimalVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientConfig_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientConfig_Response copyWith(void Function(ClientConfig_Response) updates) =>
      super.copyWith((message) => updates(message as ClientConfig_Response)) as ClientConfig_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientConfig_Response create() => ClientConfig_Response._();
  @$core.override
  ClientConfig_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClientConfig_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientConfig_Response>(create);
  static ClientConfig_Response? _defaultInstance;

  /// secretChats.enabled / premiumOnly — те же выключатели, что на сервере.
  @$pb.TagNumber(1)
  $core.bool get secretChatsEnabled => $_getBF(0);
  @$pb.TagNumber(1)
  set secretChatsEnabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSecretChatsEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecretChatsEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get secretChatsPremiumOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set secretChatsPremiumOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSecretChatsPremiumOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearSecretChatsPremiumOnly() => $_clearField(2);

  /// calls.groupEnabled — «Добавить участника» / «Позвонить нескольким».
  @$pb.TagNumber(3)
  $core.bool get groupCallsEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set groupCallsEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGroupCallsEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroupCallsEnabled() => $_clearField(3);

  /// calls.* — подключение к комнате LiveKit и время дозвона, секунды.
  @$pb.TagNumber(4)
  $core.int get callConnectMaxAttempts => $_getIZ(3);
  @$pb.TagNumber(4)
  set callConnectMaxAttempts($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCallConnectMaxAttempts() => $_has(3);
  @$pb.TagNumber(4)
  void clearCallConnectMaxAttempts() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get callPeerConnectionTimeoutSeconds => $_getIZ(4);
  @$pb.TagNumber(5)
  set callPeerConnectionTimeoutSeconds($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCallPeerConnectionTimeoutSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearCallPeerConnectionTimeoutSeconds() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get callRingTimeoutSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set callRingTimeoutSeconds($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCallRingTimeoutSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearCallRingTimeoutSeconds() => $_clearField(6);

  /// client.animatedEmojiUrl — откуда докачивать анимированные эмодзи
  /// (`<url><имя>.json`, со «/» в конце).
  @$pb.TagNumber(7)
  $core.String get animatedEmojiUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set animatedEmojiUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAnimatedEmojiUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearAnimatedEmojiUrl() => $_clearField(7);

  /// oauth.yandex.clientId сервера (пусто — вход через Яндекс выключен).
  @$pb.TagNumber(8)
  $core.String get yandexClientId => $_getSZ(7);
  @$pb.TagNumber(8)
  set yandexClientId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasYandexClientId() => $_has(7);
  @$pb.TagNumber(8)
  void clearYandexClientId() => $_clearField(8);

  /// client.minimalVersion — сборка старше («0.0.570») должна обновиться.
  @$pb.TagNumber(9)
  $core.String get minimalVersion => $_getSZ(8);
  @$pb.TagNumber(9)
  set minimalVersion($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMinimalVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearMinimalVersion() => $_clearField(9);
}

/// Настройки приложения с сервера (админка → «Настройки», этап 5б плана
/// docs/plans/admin-panel.md клиента) вместо Firebase Remote Config. Ничего
/// секретного и ничего о конкретном пользователе: конфиг видит любой, в т.ч. до
/// входа.
///
/// Как доходит: до входа — pre-auth unary CLIENT_CONFIG (как META_DATA_INFO,
/// без шифрования); после входа — в Subscribe.Response и пушем CLIENT_CONFIG по
/// стриму, когда настройку поменяли в админке. Клиент хранит последний ответ и
/// сравнивает байты: другие — значит, что-то поменялось.
///
/// Ноль / пустая строка — «не задано»: приложение берёт своё значение по
/// умолчанию (так и старые серверы без поля не ломают клиента).
class ClientConfig extends $pb.GeneratedMessage {
  factory ClientConfig() => create();

  ClientConfig._();

  factory ClientConfig.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientConfig.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClientConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientConfig copyWith(void Function(ClientConfig) updates) =>
      super.copyWith((message) => updates(message as ClientConfig)) as ClientConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientConfig create() => ClientConfig._();
  @$core.override
  ClientConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClientConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientConfig>(create);
  static ClientConfig? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
