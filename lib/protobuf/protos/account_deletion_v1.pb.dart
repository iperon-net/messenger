// This is a generated file - do not edit.
//
// Generated from protos/account_deletion_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AccountDeletionRequest_Request extends $pb.GeneratedMessage {
  factory AccountDeletionRequest_Request({
    $core.String? phoneNumber,
    $core.List<$core.int>? cloudPasswordToken,
  }) {
    final result = create();
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (cloudPasswordToken != null) result.cloudPasswordToken = cloudPasswordToken;
    return result;
  }

  AccountDeletionRequest_Request._();

  factory AccountDeletionRequest_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDeletionRequest_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDeletionRequest.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'cloudPasswordToken', $pb.PbFieldType.OY, protoName: 'cloudPasswordToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionRequest_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionRequest_Request copyWith(void Function(AccountDeletionRequest_Request) updates) =>
      super.copyWith((message) => updates(message as AccountDeletionRequest_Request)) as AccountDeletionRequest_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDeletionRequest_Request create() => AccountDeletionRequest_Request._();
  @$core.override
  AccountDeletionRequest_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDeletionRequest_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDeletionRequest_Request>(create);
  static AccountDeletionRequest_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phoneNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set phoneNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhoneNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoneNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get cloudPasswordToken => $_getN(1);
  @$pb.TagNumber(2)
  set cloudPasswordToken($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCloudPasswordToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearCloudPasswordToken() => $_clearField(2);
}

class AccountDeletionRequest_Response extends $pb.GeneratedMessage {
  factory AccountDeletionRequest_Response({
    $0.Timestamp? manualDeleteAfter,
    $core.bool? alreadyScheduled,
  }) {
    final result = create();
    if (manualDeleteAfter != null) result.manualDeleteAfter = manualDeleteAfter;
    if (alreadyScheduled != null) result.alreadyScheduled = alreadyScheduled;
    return result;
  }

  AccountDeletionRequest_Response._();

  factory AccountDeletionRequest_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDeletionRequest_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDeletionRequest.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'manualDeleteAfter', protoName: 'manualDeleteAfter', subBuilder: $0.Timestamp.create)
    ..aOB(2, _omitFieldNames ? '' : 'alreadyScheduled', protoName: 'alreadyScheduled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionRequest_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionRequest_Response copyWith(void Function(AccountDeletionRequest_Response) updates) =>
      super.copyWith((message) => updates(message as AccountDeletionRequest_Response)) as AccountDeletionRequest_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDeletionRequest_Response create() => AccountDeletionRequest_Response._();
  @$core.override
  AccountDeletionRequest_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDeletionRequest_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDeletionRequest_Response>(create);
  static AccountDeletionRequest_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get manualDeleteAfter => $_getN(0);
  @$pb.TagNumber(1)
  set manualDeleteAfter($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasManualDeleteAfter() => $_has(0);
  @$pb.TagNumber(1)
  void clearManualDeleteAfter() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureManualDeleteAfter() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get alreadyScheduled => $_getBF(1);
  @$pb.TagNumber(2)
  set alreadyScheduled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlreadyScheduled() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlreadyScheduled() => $_clearField(2);
}

class AccountDeletionRequest extends $pb.GeneratedMessage {
  factory AccountDeletionRequest() => create();

  AccountDeletionRequest._();

  factory AccountDeletionRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDeletionRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDeletionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionRequest copyWith(void Function(AccountDeletionRequest) updates) =>
      super.copyWith((message) => updates(message as AccountDeletionRequest)) as AccountDeletionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDeletionRequest create() => AccountDeletionRequest._();
  @$core.override
  AccountDeletionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDeletionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDeletionRequest>(create);
  static AccountDeletionRequest? _defaultInstance;
}

class AccountDeletionCancel_Request extends $pb.GeneratedMessage {
  factory AccountDeletionCancel_Request() => create();

  AccountDeletionCancel_Request._();

  factory AccountDeletionCancel_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDeletionCancel_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDeletionCancel.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionCancel_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionCancel_Request copyWith(void Function(AccountDeletionCancel_Request) updates) =>
      super.copyWith((message) => updates(message as AccountDeletionCancel_Request)) as AccountDeletionCancel_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDeletionCancel_Request create() => AccountDeletionCancel_Request._();
  @$core.override
  AccountDeletionCancel_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDeletionCancel_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDeletionCancel_Request>(create);
  static AccountDeletionCancel_Request? _defaultInstance;
}

class AccountDeletionCancel_Response extends $pb.GeneratedMessage {
  factory AccountDeletionCancel_Response({
    $core.bool? cancelled,
  }) {
    final result = create();
    if (cancelled != null) result.cancelled = cancelled;
    return result;
  }

  AccountDeletionCancel_Response._();

  factory AccountDeletionCancel_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDeletionCancel_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDeletionCancel.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'cancelled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionCancel_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionCancel_Response copyWith(void Function(AccountDeletionCancel_Response) updates) =>
      super.copyWith((message) => updates(message as AccountDeletionCancel_Response)) as AccountDeletionCancel_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDeletionCancel_Response create() => AccountDeletionCancel_Response._();
  @$core.override
  AccountDeletionCancel_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDeletionCancel_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDeletionCancel_Response>(create);
  static AccountDeletionCancel_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get cancelled => $_getBF(0);
  @$pb.TagNumber(1)
  set cancelled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCancelled() => $_has(0);
  @$pb.TagNumber(1)
  void clearCancelled() => $_clearField(1);
}

class AccountDeletionCancel extends $pb.GeneratedMessage {
  factory AccountDeletionCancel() => create();

  AccountDeletionCancel._();

  factory AccountDeletionCancel.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDeletionCancel.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDeletionCancel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionCancel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionCancel copyWith(void Function(AccountDeletionCancel) updates) =>
      super.copyWith((message) => updates(message as AccountDeletionCancel)) as AccountDeletionCancel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDeletionCancel create() => AccountDeletionCancel._();
  @$core.override
  AccountDeletionCancel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDeletionCancel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDeletionCancel>(create);
  static AccountDeletionCancel? _defaultInstance;
}

class AccountDeletionStatus_Request extends $pb.GeneratedMessage {
  factory AccountDeletionStatus_Request() => create();

  AccountDeletionStatus_Request._();

  factory AccountDeletionStatus_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDeletionStatus_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDeletionStatus.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionStatus_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionStatus_Request copyWith(void Function(AccountDeletionStatus_Request) updates) =>
      super.copyWith((message) => updates(message as AccountDeletionStatus_Request)) as AccountDeletionStatus_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDeletionStatus_Request create() => AccountDeletionStatus_Request._();
  @$core.override
  AccountDeletionStatus_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDeletionStatus_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDeletionStatus_Request>(create);
  static AccountDeletionStatus_Request? _defaultInstance;
}

class AccountDeletionStatus_Response extends $pb.GeneratedMessage {
  factory AccountDeletionStatus_Response({
    $0.Timestamp? manualDeleteAfter,
    $0.Timestamp? autoDeleteAfter,
    $core.String? deletionState,
  }) {
    final result = create();
    if (manualDeleteAfter != null) result.manualDeleteAfter = manualDeleteAfter;
    if (autoDeleteAfter != null) result.autoDeleteAfter = autoDeleteAfter;
    if (deletionState != null) result.deletionState = deletionState;
    return result;
  }

  AccountDeletionStatus_Response._();

  factory AccountDeletionStatus_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDeletionStatus_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDeletionStatus.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'manualDeleteAfter', protoName: 'manualDeleteAfter', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'autoDeleteAfter', protoName: 'autoDeleteAfter', subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'deletionState', protoName: 'deletionState')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionStatus_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionStatus_Response copyWith(void Function(AccountDeletionStatus_Response) updates) =>
      super.copyWith((message) => updates(message as AccountDeletionStatus_Response)) as AccountDeletionStatus_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDeletionStatus_Response create() => AccountDeletionStatus_Response._();
  @$core.override
  AccountDeletionStatus_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDeletionStatus_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDeletionStatus_Response>(create);
  static AccountDeletionStatus_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get manualDeleteAfter => $_getN(0);
  @$pb.TagNumber(1)
  set manualDeleteAfter($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasManualDeleteAfter() => $_has(0);
  @$pb.TagNumber(1)
  void clearManualDeleteAfter() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureManualDeleteAfter() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Timestamp get autoDeleteAfter => $_getN(1);
  @$pb.TagNumber(2)
  set autoDeleteAfter($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAutoDeleteAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAutoDeleteAfter() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureAutoDeleteAfter() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get deletionState => $_getSZ(2);
  @$pb.TagNumber(3)
  set deletionState($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeletionState() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeletionState() => $_clearField(3);
}

class AccountDeletionStatus extends $pb.GeneratedMessage {
  factory AccountDeletionStatus() => create();

  AccountDeletionStatus._();

  factory AccountDeletionStatus.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDeletionStatus.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDeletionStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDeletionStatus copyWith(void Function(AccountDeletionStatus) updates) =>
      super.copyWith((message) => updates(message as AccountDeletionStatus)) as AccountDeletionStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDeletionStatus create() => AccountDeletionStatus._();
  @$core.override
  AccountDeletionStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDeletionStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDeletionStatus>(create);
  static AccountDeletionStatus? _defaultInstance;
}

class AccountActivity_Request extends $pb.GeneratedMessage {
  factory AccountActivity_Request() => create();

  AccountActivity_Request._();

  factory AccountActivity_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountActivity_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountActivity.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountActivity_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountActivity_Request copyWith(void Function(AccountActivity_Request) updates) =>
      super.copyWith((message) => updates(message as AccountActivity_Request)) as AccountActivity_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountActivity_Request create() => AccountActivity_Request._();
  @$core.override
  AccountActivity_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountActivity_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountActivity_Request>(create);
  static AccountActivity_Request? _defaultInstance;
}

class AccountActivity_Response extends $pb.GeneratedMessage {
  factory AccountActivity_Response({
    $0.Timestamp? autoDeleteAfter,
  }) {
    final result = create();
    if (autoDeleteAfter != null) result.autoDeleteAfter = autoDeleteAfter;
    return result;
  }

  AccountActivity_Response._();

  factory AccountActivity_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountActivity_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountActivity.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'autoDeleteAfter', protoName: 'autoDeleteAfter', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountActivity_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountActivity_Response copyWith(void Function(AccountActivity_Response) updates) =>
      super.copyWith((message) => updates(message as AccountActivity_Response)) as AccountActivity_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountActivity_Response create() => AccountActivity_Response._();
  @$core.override
  AccountActivity_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountActivity_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountActivity_Response>(create);
  static AccountActivity_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get autoDeleteAfter => $_getN(0);
  @$pb.TagNumber(1)
  set autoDeleteAfter($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAutoDeleteAfter() => $_has(0);
  @$pb.TagNumber(1)
  void clearAutoDeleteAfter() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureAutoDeleteAfter() => $_ensure(0);
}

class AccountActivity extends $pb.GeneratedMessage {
  factory AccountActivity() => create();

  AccountActivity._();

  factory AccountActivity.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountActivity.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountActivity',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountActivity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountActivity copyWith(void Function(AccountActivity) updates) =>
      super.copyWith((message) => updates(message as AccountActivity)) as AccountActivity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountActivity create() => AccountActivity._();
  @$core.override
  AccountActivity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountActivity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountActivity>(create);
  static AccountActivity? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
