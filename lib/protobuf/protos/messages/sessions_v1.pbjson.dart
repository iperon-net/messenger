// This is a generated file - do not edit.
//
// Generated from protos/messages/sessions_v1.proto.

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

@$core.Deprecated('Use sessionDescriptor instead')
const Session$json = {
  '1': 'Session',
  '2': [
    {'1': 'deviceModel', '3': 1, '4': 1, '5': 9, '10': 'deviceModel'},
    {'1': 'osVersion', '3': 2, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'appVersion', '3': 3, '4': 1, '5': 9, '10': 'appVersion'},
    {'1': 'appBuildNumber', '3': 4, '4': 1, '5': 9, '10': 'appBuildNumber'},
    {'1': 'locationRussian', '3': 5, '4': 1, '5': 9, '10': 'locationRussian'},
    {'1': 'locationEnglish', '3': 6, '4': 1, '5': 9, '10': 'locationEnglish'},
    {
      '1': 'updateAt',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updateAt'
    },
  ],
};

/// Descriptor for `Session`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionDescriptor = $convert.base64Decode(
    'CgdTZXNzaW9uEiAKC2RldmljZU1vZGVsGAEgASgJUgtkZXZpY2VNb2RlbBIcCglvc1ZlcnNpb2'
    '4YAiABKAlSCW9zVmVyc2lvbhIeCgphcHBWZXJzaW9uGAMgASgJUgphcHBWZXJzaW9uEiYKDmFw'
    'cEJ1aWxkTnVtYmVyGAQgASgJUg5hcHBCdWlsZE51bWJlchIoCg9sb2NhdGlvblJ1c3NpYW4YBS'
    'ABKAlSD2xvY2F0aW9uUnVzc2lhbhIoCg9sb2NhdGlvbkVuZ2xpc2gYBiABKAlSD2xvY2F0aW9u'
    'RW5nbGlzaBI2Cgh1cGRhdGVBdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCH'
    'VwZGF0ZUF0');

@$core.Deprecated('Use sessionsRequestDescriptor instead')
const SessionsRequest$json = {
  '1': 'SessionsRequest',
};

/// Descriptor for `SessionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionsRequestDescriptor =
    $convert.base64Decode('Cg9TZXNzaW9uc1JlcXVlc3Q=');

@$core.Deprecated('Use sessionsResponseDescriptor instead')
const SessionsResponse$json = {
  '1': 'SessionsResponse',
  '2': [
    {
      '1': 'sessions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.iperon.v1.Session',
      '10': 'sessions'
    },
  ],
};

/// Descriptor for `SessionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionsResponseDescriptor = $convert.base64Decode(
    'ChBTZXNzaW9uc1Jlc3BvbnNlEi4KCHNlc3Npb25zGAEgAygLMhIuaXBlcm9uLnYxLlNlc3Npb2'
    '5SCHNlc3Npb25z');
