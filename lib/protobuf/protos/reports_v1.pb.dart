// This is a generated file - do not edit.
//
// Generated from protos/reports_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'reports_v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'reports_v1.pbenum.dart';

class Report_Request extends $pb.GeneratedMessage {
  factory Report_Request({
    $core.List<$core.int>? userID,
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
    Report_Reason? reason,
    $core.String? comment,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    if (reason != null) result.reason = reason;
    if (comment != null) result.comment = comment;
    return result;
  }

  Report_Request._();

  factory Report_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Report_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Report.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(3, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..aE<Report_Reason>(4, _omitFieldNames ? '' : 'reason', enumValues: Report_Reason.values)
    ..aOS(5, _omitFieldNames ? '' : 'comment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Report_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Report_Request copyWith(void Function(Report_Request) updates) =>
      super.copyWith((message) => updates(message as Report_Request)) as Report_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Report_Request create() => Report_Request._();
  @$core.override
  Report_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Report_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Report_Request>(create);
  static Report_Request? _defaultInstance;

  /// На кого — одно из двух: userID (профиль, секретный чат — без
  /// содержимого) или chatID (личный чат — на собеседника, группа, канал).
  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get chatID => $_getN(1);
  @$pb.TagNumber(2)
  set chatID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChatID() => $_has(1);
  @$pb.TagNumber(2)
  void clearChatID() => $_clearField(2);

  /// Сообщения чата chatID — доказательства (до 20; в личном чате только
  /// они попадают модератору). Пусто для группы / канала — последние
  /// сообщения чата.
  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(2);

  @$pb.TagNumber(4)
  Report_Reason get reason => $_getN(3);
  @$pb.TagNumber(4)
  set reason(Report_Reason value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  /// Необязательный комментарий (до 1000 символов).
  @$pb.TagNumber(5)
  $core.String get comment => $_getSZ(4);
  @$pb.TagNumber(5)
  set comment($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasComment() => $_has(4);
  @$pb.TagNumber(5)
  void clearComment() => $_clearField(5);
}

class Report_Response extends $pb.GeneratedMessage {
  factory Report_Response() => create();

  Report_Response._();

  factory Report_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Report_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Report.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Report_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Report_Response copyWith(void Function(Report_Response) updates) =>
      super.copyWith((message) => updates(message as Report_Response)) as Report_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Report_Response create() => Report_Response._();
  @$core.override
  Report_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Report_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Report_Response>(create);
  static Report_Response? _defaultInstance;
}

/// Жалоба модерации (MessageType_REPORT, зашифрованный unary; этап 3 плана
/// docs/plans/admin-panel.md клиента). Ответа по существу нет: о решении
/// пожаловавшийся не узнаёт, как в Telegram.
class Report extends $pb.GeneratedMessage {
  factory Report() => create();

  Report._();

  factory Report.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Report.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Report',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Report clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Report copyWith(void Function(Report) updates) => super.copyWith((message) => updates(message as Report)) as Report;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Report create() => Report._();
  @$core.override
  Report createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Report getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Report>(create);
  static Report? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
