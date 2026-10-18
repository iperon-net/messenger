// This is a generated file - do not edit.
//
// Generated from protos/secret_payload_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SecretMedia_Kind extends $pb.ProtobufEnum {
  static const SecretMedia_Kind PHOTO = SecretMedia_Kind._(0, _omitEnumNames ? '' : 'PHOTO');
  static const SecretMedia_Kind VIDEO = SecretMedia_Kind._(1, _omitEnumNames ? '' : 'VIDEO');
  static const SecretMedia_Kind FILE = SecretMedia_Kind._(2, _omitEnumNames ? '' : 'FILE');
  static const SecretMedia_Kind VOICE = SecretMedia_Kind._(3, _omitEnumNames ? '' : 'VOICE');

  static const $core.List<SecretMedia_Kind> values = <SecretMedia_Kind>[
    PHOTO,
    VIDEO,
    FILE,
    VOICE,
  ];

  static final $core.List<SecretMedia_Kind?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SecretMedia_Kind? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SecretMedia_Kind._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
