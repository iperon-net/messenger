// This is a generated file - do not edit.
//
// Generated from protos/messages/auth_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use authDescriptor instead')
const Auth$json = {
  '1': 'Auth',
  '2': [
    {'1': 'session', '3': 1, '4': 1, '5': 12, '10': 'session'},
    {'1': 'osVersion', '3': 2, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'appVersion', '3': 3, '4': 1, '5': 9, '10': 'appVersion'},
    {'1': 'appBuildNumber', '3': 4, '4': 1, '5': 9, '10': 'appBuildNumber'},
  ],
};

/// Descriptor for `Auth`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authDescriptor = $convert.base64Decode(
    'CgRBdXRoEhgKB3Nlc3Npb24YASABKAxSB3Nlc3Npb24SHAoJb3NWZXJzaW9uGAIgASgJUglvc1'
    'ZlcnNpb24SHgoKYXBwVmVyc2lvbhgDIAEoCVIKYXBwVmVyc2lvbhImCg5hcHBCdWlsZE51bWJl'
    'chgEIAEoCVIOYXBwQnVpbGROdW1iZXI=');

@$core.Deprecated('Use authResultDescriptor instead')
const AuthResult$json = {
  '1': 'AuthResult',
  '2': [
    {'1': 'salt', '3': 1, '4': 1, '5': 12, '10': 'salt'},
    {
      '1': 'serverAt',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'serverAt'
    },
  ],
};

/// Descriptor for `AuthResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authResultDescriptor = $convert.base64Decode(
    'CgpBdXRoUmVzdWx0EhIKBHNhbHQYASABKAxSBHNhbHQSNgoIc2VydmVyQXQYAiABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUghzZXJ2ZXJBdA==');
