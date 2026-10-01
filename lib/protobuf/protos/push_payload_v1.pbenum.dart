// This is a generated file - do not edit.
//
// Generated from protos/push_payload_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class PushPayload_Kind extends $pb.ProtobufEnum {
  static const PushPayload_Kind UNKNOWN = PushPayload_Kind._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const PushPayload_Kind TEST = PushPayload_Kind._(1, _omitEnumNames ? '' : 'TEST');
  static const PushPayload_Kind CONTACT_JOINED = PushPayload_Kind._(2, _omitEnumNames ? '' : 'CONTACT_JOINED');
  static const PushPayload_Kind CALL_MISSED = PushPayload_Kind._(3, _omitEnumNames ? '' : 'CALL_MISSED');
  static const PushPayload_Kind MESSAGE = PushPayload_Kind._(10, _omitEnumNames ? '' : 'MESSAGE');
  static const PushPayload_Kind READ_HISTORY = PushPayload_Kind._(11, _omitEnumNames ? '' : 'READ_HISTORY');
  static const PushPayload_Kind MESSAGE_DELETED = PushPayload_Kind._(12, _omitEnumNames ? '' : 'MESSAGE_DELETED');

  static const $core.List<PushPayload_Kind> values = <PushPayload_Kind>[
    UNKNOWN,
    TEST,
    CONTACT_JOINED,
    CALL_MISSED,
    MESSAGE,
    READ_HISTORY,
    MESSAGE_DELETED,
  ];

  static final $core.Map<$core.int, PushPayload_Kind> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PushPayload_Kind? valueOf($core.int value) => _byValue[value];

  const PushPayload_Kind._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
