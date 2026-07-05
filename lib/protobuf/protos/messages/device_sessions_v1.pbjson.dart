// This is a generated file - do not edit.
//
// Generated from protos/messages/device_sessions_v1.proto.

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

@$core.Deprecated('Use deviceSessionDescriptor instead')
const DeviceSession$json = {
  '1': 'DeviceSession',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 12, '10': 'sessionID'},
    {'1': 'deviceModel', '3': 2, '4': 1, '5': 9, '10': 'deviceModel'},
    {'1': 'os', '3': 3, '4': 1, '5': 5, '10': 'os'},
    {'1': 'osVersion', '3': 4, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'appVersion', '3': 5, '4': 1, '5': 9, '10': 'appVersion'},
    {'1': 'appBuildNumber', '3': 6, '4': 1, '5': 9, '10': 'appBuildNumber'},
    {
      '1': 'updateAt',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updateAt'
    },
    {'1': 'locationRussian', '3': 8, '4': 1, '5': 9, '10': 'locationRussian'},
    {'1': 'locationEnglish', '3': 9, '4': 1, '5': 9, '10': 'locationEnglish'},
  ],
};

/// Descriptor for `DeviceSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceSessionDescriptor = $convert.base64Decode(
    'Cg1EZXZpY2VTZXNzaW9uEhwKCXNlc3Npb25JRBgBIAEoDFIJc2Vzc2lvbklEEiAKC2RldmljZU'
    '1vZGVsGAIgASgJUgtkZXZpY2VNb2RlbBIOCgJvcxgDIAEoBVICb3MSHAoJb3NWZXJzaW9uGAQg'
    'ASgJUglvc1ZlcnNpb24SHgoKYXBwVmVyc2lvbhgFIAEoCVIKYXBwVmVyc2lvbhImCg5hcHBCdW'
    'lsZE51bWJlchgGIAEoCVIOYXBwQnVpbGROdW1iZXISNgoIdXBkYXRlQXQYByABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuVGltZXN0YW1wUgh1cGRhdGVBdBIoCg9sb2NhdGlvblJ1c3NpYW4YCCABKA'
    'lSD2xvY2F0aW9uUnVzc2lhbhIoCg9sb2NhdGlvbkVuZ2xpc2gYCSABKAlSD2xvY2F0aW9uRW5n'
    'bGlzaA==');

@$core.Deprecated('Use deviceSessionsDescriptor instead')
const DeviceSessions$json = {
  '1': 'DeviceSessions',
};

/// Descriptor for `DeviceSessions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceSessionsDescriptor =
    $convert.base64Decode('Cg5EZXZpY2VTZXNzaW9ucw==');

@$core.Deprecated('Use deviceSessionsResultDescriptor instead')
const DeviceSessionsResult$json = {
  '1': 'DeviceSessionsResult',
  '2': [
    {
      '1': 'deviceSessions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.iperon.v1.messages.DeviceSession',
      '10': 'deviceSessions'
    },
  ],
};

/// Descriptor for `DeviceSessionsResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceSessionsResultDescriptor = $convert.base64Decode(
    'ChREZXZpY2VTZXNzaW9uc1Jlc3VsdBJJCg5kZXZpY2VTZXNzaW9ucxgBIAMoCzIhLmlwZXJvbi'
    '52MS5tZXNzYWdlcy5EZXZpY2VTZXNzaW9uUg5kZXZpY2VTZXNzaW9ucw==');

@$core.Deprecated('Use deviceSessionsLogoutDescriptor instead')
const DeviceSessionsLogout$json = {
  '1': 'DeviceSessionsLogout',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 3, '5': 12, '10': 'sessionID'},
  ],
};

/// Descriptor for `DeviceSessionsLogout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceSessionsLogoutDescriptor = $convert.base64Decode(
    'ChREZXZpY2VTZXNzaW9uc0xvZ291dBIcCglzZXNzaW9uSUQYASADKAxSCXNlc3Npb25JRA==');

@$core.Deprecated('Use deviceSessionsLogoutResultDescriptor instead')
const DeviceSessionsLogoutResult$json = {
  '1': 'DeviceSessionsLogoutResult',
};

/// Descriptor for `DeviceSessionsLogoutResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceSessionsLogoutResultDescriptor =
    $convert.base64Decode('ChpEZXZpY2VTZXNzaW9uc0xvZ291dFJlc3VsdA==');
