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
    {'1': 'session', '3': 1, '4': 1, '5': 12, '10': 'session'},
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
    'Cg1EZXZpY2VTZXNzaW9uEhgKB3Nlc3Npb24YASABKAxSB3Nlc3Npb24SIAoLZGV2aWNlTW9kZW'
    'wYAiABKAlSC2RldmljZU1vZGVsEg4KAm9zGAMgASgFUgJvcxIcCglvc1ZlcnNpb24YBCABKAlS'
    'CW9zVmVyc2lvbhIeCgphcHBWZXJzaW9uGAUgASgJUgphcHBWZXJzaW9uEiYKDmFwcEJ1aWxkTn'
    'VtYmVyGAYgASgJUg5hcHBCdWlsZE51bWJlchI2Cgh1cGRhdGVBdBgHIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSCHVwZGF0ZUF0EigKD2xvY2F0aW9uUnVzc2lhbhgIIAEoCVIPbG'
    '9jYXRpb25SdXNzaWFuEigKD2xvY2F0aW9uRW5nbGlzaBgJIAEoCVIPbG9jYXRpb25FbmdsaXNo');

@$core.Deprecated('Use deviceSessionsRequestDescriptor instead')
const DeviceSessionsRequest$json = {
  '1': 'DeviceSessionsRequest',
};

/// Descriptor for `DeviceSessionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceSessionsRequestDescriptor =
    $convert.base64Decode('ChVEZXZpY2VTZXNzaW9uc1JlcXVlc3Q=');

@$core.Deprecated('Use deviceSessionsResponseDescriptor instead')
const DeviceSessionsResponse$json = {
  '1': 'DeviceSessionsResponse',
  '2': [
    {
      '1': 'deviceSessions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.iperon.v1.DeviceSession',
      '10': 'deviceSessions'
    },
  ],
};

/// Descriptor for `DeviceSessionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceSessionsResponseDescriptor =
    $convert.base64Decode(
        'ChZEZXZpY2VTZXNzaW9uc1Jlc3BvbnNlEkAKDmRldmljZVNlc3Npb25zGAEgAygLMhguaXBlcm'
        '9uLnYxLkRldmljZVNlc3Npb25SDmRldmljZVNlc3Npb25z');
