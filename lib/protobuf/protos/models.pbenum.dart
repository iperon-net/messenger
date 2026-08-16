// This is a generated file - do not edit.
//
// Generated from protos/models.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AuthCallPasswordStatus extends $pb.ProtobufEnum {
  static const AuthCallPasswordStatus healthcheck = AuthCallPasswordStatus._(0, _omitEnumNames ? '' : 'healthcheck');
  static const AuthCallPasswordStatus error = AuthCallPasswordStatus._(1, _omitEnumNames ? '' : 'error');
  static const AuthCallPasswordStatus success = AuthCallPasswordStatus._(2, _omitEnumNames ? '' : 'success');

  static const $core.List<AuthCallPasswordStatus> values = <AuthCallPasswordStatus>[
    healthcheck,
    error,
    success,
  ];

  static final $core.List<AuthCallPasswordStatus?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AuthCallPasswordStatus? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AuthCallPasswordStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
