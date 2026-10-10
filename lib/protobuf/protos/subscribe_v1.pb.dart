// This is a generated file - do not edit.
//
// Generated from protos/subscribe_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Subscribe_Request extends $pb.GeneratedMessage {
  factory Subscribe_Request({
    $core.bool? background,
  }) {
    final result = create();
    if (background != null) result.background = background;
    return result;
  }

  Subscribe_Request._();

  factory Subscribe_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Subscribe_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Subscribe.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'background')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subscribe_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subscribe_Request copyWith(void Function(Subscribe_Request) updates) =>
      super.copyWith((message) => updates(message as Subscribe_Request)) as Subscribe_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Subscribe_Request create() => Subscribe_Request._();
  @$core.override
  Subscribe_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Subscribe_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Subscribe_Request>(create);
  static Subscribe_Request? _defaultInstance;

  /// background — приложение запущено системой в фоне (VoIP / тихий пуш), а не
  /// открыто пользователем: сервер не ставит сессии presence online, иначе
  /// push-уведомления ей не уходят, пока стрим не отвалится по keepalive.
  /// Онлайн поставит APP_STATE{foreground:true}, когда приложение откроют.
  /// Старые клиенты поле не шлют (false) — как раньше, открытие стрима = online.
  @$pb.TagNumber(1)
  $core.bool get background => $_getBF(0);
  @$pb.TagNumber(1)
  set background($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBackground() => $_has(0);
  @$pb.TagNumber(1)
  void clearBackground() => $_clearField(1);
}

class Subscribe_Response extends $pb.GeneratedMessage {
  factory Subscribe_Response() => create();

  Subscribe_Response._();

  factory Subscribe_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Subscribe_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Subscribe.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subscribe_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subscribe_Response copyWith(void Function(Subscribe_Response) updates) =>
      super.copyWith((message) => updates(message as Subscribe_Response)) as Subscribe_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Subscribe_Response create() => Subscribe_Response._();
  @$core.override
  Subscribe_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Subscribe_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Subscribe_Response>(create);
  static Subscribe_Response? _defaultInstance;
}

class Subscribe extends $pb.GeneratedMessage {
  factory Subscribe() => create();

  Subscribe._();

  factory Subscribe.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Subscribe.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Subscribe',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subscribe clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subscribe copyWith(void Function(Subscribe) updates) => super.copyWith((message) => updates(message as Subscribe)) as Subscribe;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Subscribe create() => Subscribe._();
  @$core.override
  Subscribe createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Subscribe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Subscribe>(create);
  static Subscribe? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
