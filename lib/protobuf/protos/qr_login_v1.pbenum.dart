// This is a generated file - do not edit.
//
// Generated from protos/qr_login_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AuthQr_Status extends $pb.ProtobufEnum {
  static const AuthQr_Status PENDING = AuthQr_Status._(0, _omitEnumNames ? '' : 'PENDING');

  /// Подтверждён на телефоне — в ответе confirmationSession (один раз).
  static const AuthQr_Status ACCEPTED = AuthQr_Status._(1, _omitEnumNames ? '' : 'ACCEPTED');

  /// Истёк или уже использован — показать новый QR.
  static const AuthQr_Status EXPIRED = AuthQr_Status._(2, _omitEnumNames ? '' : 'EXPIRED');

  static const $core.List<AuthQr_Status> values = <AuthQr_Status>[
    PENDING,
    ACCEPTED,
    EXPIRED,
  ];

  static final $core.List<AuthQr_Status?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AuthQr_Status? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AuthQr_Status._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
