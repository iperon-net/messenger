// This is a generated file - do not edit.
//
// Generated from protos/push_token_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RegisterPushToken_TokenType extends $pb.ProtobufEnum {
  static const RegisterPushToken_TokenType FCM = RegisterPushToken_TokenType._(0, _omitEnumNames ? '' : 'FCM');
  static const RegisterPushToken_TokenType APNS_VOIP = RegisterPushToken_TokenType._(1, _omitEnumNames ? '' : 'APNS_VOIP');

  static const $core.List<RegisterPushToken_TokenType> values = <RegisterPushToken_TokenType>[
    FCM,
    APNS_VOIP,
  ];

  static final $core.List<RegisterPushToken_TokenType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static RegisterPushToken_TokenType? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RegisterPushToken_TokenType._(super.value, super.name);
}

class RegisterPushToken_Platform extends $pb.ProtobufEnum {
  static const RegisterPushToken_Platform UNKNOWN = RegisterPushToken_Platform._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const RegisterPushToken_Platform ANDROID = RegisterPushToken_Platform._(1, _omitEnumNames ? '' : 'ANDROID');
  static const RegisterPushToken_Platform IOS = RegisterPushToken_Platform._(2, _omitEnumNames ? '' : 'IOS');

  static const $core.List<RegisterPushToken_Platform> values = <RegisterPushToken_Platform>[
    UNKNOWN,
    ANDROID,
    IOS,
  ];

  static final $core.List<RegisterPushToken_Platform?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static RegisterPushToken_Platform? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RegisterPushToken_Platform._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
