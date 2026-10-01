// This is a generated file - do not edit.
//
// Generated from protos/app_state_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AppState_Request extends $pb.GeneratedMessage {
  factory AppState_Request({
    $core.bool? foreground,
  }) {
    final result = create();
    if (foreground != null) result.foreground = foreground;
    return result;
  }

  AppState_Request._();

  factory AppState_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppState_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppState.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'foreground')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppState_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppState_Request copyWith(void Function(AppState_Request) updates) =>
      super.copyWith((message) => updates(message as AppState_Request)) as AppState_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppState_Request create() => AppState_Request._();
  @$core.override
  AppState_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppState_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppState_Request>(create);
  static AppState_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get foreground => $_getBF(0);
  @$pb.TagNumber(1)
  set foreground($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasForeground() => $_has(0);
  @$pb.TagNumber(1)
  void clearForeground() => $_clearField(1);
}

class AppState_Response extends $pb.GeneratedMessage {
  factory AppState_Response() => create();

  AppState_Response._();

  factory AppState_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppState_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppState.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppState_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppState_Response copyWith(void Function(AppState_Response) updates) =>
      super.copyWith((message) => updates(message as AppState_Response)) as AppState_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppState_Response create() => AppState_Response._();
  @$core.override
  AppState_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppState_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppState_Response>(create);
  static AppState_Response? _defaultInstance;
}

/// AppState — клиент сообщает по стриму, что приложение ушло в фон (foreground =
/// false, сразу на paused, пока стрим ещё жив) или вернулось (true). Сервер по
/// нему сразу снимает/ставит presence сессии: push-уведомления гейтятся по
/// presence, а без явного сигнала свёрнутая сессия числится онлайн до обрыва
/// стрима по keepalive (~25 с) — уведомления за это окно терялись бы.
class AppState extends $pb.GeneratedMessage {
  factory AppState() => create();

  AppState._();

  factory AppState.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppState.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppState copyWith(void Function(AppState) updates) => super.copyWith((message) => updates(message as AppState)) as AppState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppState create() => AppState._();
  @$core.override
  AppState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppState>(create);
  static AppState? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
