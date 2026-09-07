// This is a generated file - do not edit.
//
// Generated from protos/call_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Call_Signal_CallType extends $pb.ProtobufEnum {
  static const Call_Signal_CallType AUDIO = Call_Signal_CallType._(0, _omitEnumNames ? '' : 'AUDIO');
  static const Call_Signal_CallType VIDEO = Call_Signal_CallType._(1, _omitEnumNames ? '' : 'VIDEO');

  static const $core.List<Call_Signal_CallType> values = <Call_Signal_CallType>[
    AUDIO,
    VIDEO,
  ];

  static final $core.List<Call_Signal_CallType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static Call_Signal_CallType? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Call_Signal_CallType._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
