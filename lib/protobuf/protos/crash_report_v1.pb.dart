// This is a generated file - do not edit.
//
// Generated from protos/crash_report_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CrashReport_Item extends $pb.GeneratedMessage {
  factory CrashReport_Item({
    $core.String? error,
    $core.String? stack,
    $core.String? reason,
    $core.bool? fatal,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (error != null) result.error = error;
    if (stack != null) result.stack = stack;
    if (reason != null) result.reason = reason;
    if (fatal != null) result.fatal = fatal;
    if (date != null) result.date = date;
    return result;
  }

  CrashReport_Item._();

  factory CrashReport_Item.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CrashReport_Item.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CrashReport.Item',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'error')
    ..aOS(2, _omitFieldNames ? '' : 'stack')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOB(4, _omitFieldNames ? '' : 'fatal')
    ..aInt64(5, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CrashReport_Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CrashReport_Item copyWith(void Function(CrashReport_Item) updates) =>
      super.copyWith((message) => updates(message as CrashReport_Item)) as CrashReport_Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CrashReport_Item create() => CrashReport_Item._();
  @$core.override
  CrashReport_Item createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CrashReport_Item getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CrashReport_Item>(create);
  static CrashReport_Item? _defaultInstance;

  /// Текст исключения (`error.toString()`).
  @$pb.TagNumber(1)
  $core.String get error => $_getSZ(0);
  @$pb.TagNumber(1)
  set error($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get stack => $_getSZ(1);
  @$pb.TagNumber(2)
  set stack($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStack() => $_has(1);
  @$pb.TagNumber(2)
  void clearStack() => $_clearField(2);

  /// Контекст FlutterError (`errorDetails.context`), если есть.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get fatal => $_getBF(3);
  @$pb.TagNumber(4)
  set fatal($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFatal() => $_has(3);
  @$pb.TagNumber(4)
  void clearFatal() => $_clearField(4);

  /// Когда случился, мс от эпохи (UTC).
  @$pb.TagNumber(5)
  $fixnum.Int64 get date => $_getI64(4);
  @$pb.TagNumber(5)
  set date($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearDate() => $_clearField(5);
}

class CrashReport_Request extends $pb.GeneratedMessage {
  factory CrashReport_Request({
    $core.Iterable<CrashReport_Item>? items,
    $core.String? appVersion,
    $core.String? appBuildNumber,
    $core.int? os,
    $core.String? osVersion,
    $core.String? deviceModel,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (appVersion != null) result.appVersion = appVersion;
    if (appBuildNumber != null) result.appBuildNumber = appBuildNumber;
    if (os != null) result.os = os;
    if (osVersion != null) result.osVersion = osVersion;
    if (deviceModel != null) result.deviceModel = deviceModel;
    return result;
  }

  CrashReport_Request._();

  factory CrashReport_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CrashReport_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CrashReport.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<CrashReport_Item>(1, _omitFieldNames ? '' : 'items', subBuilder: CrashReport_Item.create)
    ..aOS(2, _omitFieldNames ? '' : 'appVersion', protoName: 'appVersion')
    ..aOS(3, _omitFieldNames ? '' : 'appBuildNumber', protoName: 'appBuildNumber')
    ..aI(4, _omitFieldNames ? '' : 'os')
    ..aOS(5, _omitFieldNames ? '' : 'osVersion', protoName: 'osVersion')
    ..aOS(6, _omitFieldNames ? '' : 'deviceModel', protoName: 'deviceModel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CrashReport_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CrashReport_Request copyWith(void Function(CrashReport_Request) updates) =>
      super.copyWith((message) => updates(message as CrashReport_Request)) as CrashReport_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CrashReport_Request create() => CrashReport_Request._();
  @$core.override
  CrashReport_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CrashReport_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CrashReport_Request>(create);
  static CrashReport_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CrashReport_Item> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get appVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set appVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAppVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearAppVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get appBuildNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set appBuildNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAppBuildNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppBuildNumber() => $_clearField(3);

  /// Код ОС как в сессии: 1 iOS, 2 Android, 3 macOS, 4 Windows.
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
  $core.String get deviceModel => $_getSZ(5);
  @$pb.TagNumber(6)
  set deviceModel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeviceModel() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeviceModel() => $_clearField(6);
}

class CrashReport_Response extends $pb.GeneratedMessage {
  factory CrashReport_Response() => create();

  CrashReport_Response._();

  factory CrashReport_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CrashReport_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CrashReport.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CrashReport_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CrashReport_Response copyWith(void Function(CrashReport_Response) updates) =>
      super.copyWith((message) => updates(message as CrashReport_Response)) as CrashReport_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CrashReport_Response create() => CrashReport_Response._();
  @$core.override
  CrashReport_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CrashReport_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CrashReport_Response>(create);
  static CrashReport_Response? _defaultInstance;
}

/// CrashReport — сбои клиента там, где нет Crashlytics (десктоп, см.
/// docs/plans/desktop-client.md §3.1). Клиент копит отчёты в device.db и шлёт
/// пачкой, когда есть сессия и сеть; сервер пишет их в свой лог (→ Loki) с
/// версией и ОС. Содержимого переписки и логов приложения в отчёте нет — только
/// текст исключения и стек.
class CrashReport extends $pb.GeneratedMessage {
  factory CrashReport() => create();

  CrashReport._();

  factory CrashReport.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CrashReport.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CrashReport',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CrashReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CrashReport copyWith(void Function(CrashReport) updates) => super.copyWith((message) => updates(message as CrashReport)) as CrashReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CrashReport create() => CrashReport._();
  @$core.override
  CrashReport createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CrashReport getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CrashReport>(create);
  static CrashReport? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
