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

import 'package:protobuf/protobuf.dart' as $pb;

class Report_Reason extends $pb.ProtobufEnum {
  static const Report_Reason REASON_UNKNOWN = Report_Reason._(0, _omitEnumNames ? '' : 'REASON_UNKNOWN');
  static const Report_Reason SPAM = Report_Reason._(1, _omitEnumNames ? '' : 'SPAM');
  static const Report_Reason VIOLENCE = Report_Reason._(2, _omitEnumNames ? '' : 'VIOLENCE');
  static const Report_Reason PORNOGRAPHY = Report_Reason._(3, _omitEnumNames ? '' : 'PORNOGRAPHY');
  static const Report_Reason CHILD_ABUSE = Report_Reason._(4, _omitEnumNames ? '' : 'CHILD_ABUSE');
  static const Report_Reason ILLEGAL_DRUGS = Report_Reason._(5, _omitEnumNames ? '' : 'ILLEGAL_DRUGS');
  static const Report_Reason PERSONAL_DATA = Report_Reason._(6, _omitEnumNames ? '' : 'PERSONAL_DATA');
  static const Report_Reason FAKE = Report_Reason._(7, _omitEnumNames ? '' : 'FAKE');
  static const Report_Reason COPYRIGHT = Report_Reason._(8, _omitEnumNames ? '' : 'COPYRIGHT');
  static const Report_Reason OTHER = Report_Reason._(9, _omitEnumNames ? '' : 'OTHER');

  static const $core.List<Report_Reason> values = <Report_Reason>[
    REASON_UNKNOWN,
    SPAM,
    VIOLENCE,
    PORNOGRAPHY,
    CHILD_ABUSE,
    ILLEGAL_DRUGS,
    PERSONAL_DATA,
    FAKE,
    COPYRIGHT,
    OTHER,
  ];

  static final $core.List<Report_Reason?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 9);
  static Report_Reason? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Report_Reason._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
