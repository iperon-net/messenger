// This is a generated file - do not edit.
//
// Generated from protos/device_sessions_v1.proto.

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

@$core.Deprecated('Use deviceSessionsDescriptor instead')
const DeviceSessions$json = {
  '1': 'DeviceSessions',
  '3': [DeviceSessions_DeviceSession$json, DeviceSessions_Request$json, DeviceSessions_Response$json],
};

@$core.Deprecated('Use deviceSessionsDescriptor instead')
const DeviceSessions_DeviceSession$json = {
  '1': 'DeviceSession',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 12, '10': 'sessionID'},
    {'1': 'updateAt', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updateAt'},
    {'1': 'deviceModel', '3': 3, '4': 1, '5': 9, '10': 'deviceModel'},
    {'1': 'os', '3': 4, '4': 1, '5': 5, '10': 'os'},
    {'1': 'osVersion', '3': 5, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'appVersion', '3': 6, '4': 1, '5': 9, '10': 'appVersion'},
    {'1': 'appBuildNumber', '3': 7, '4': 1, '5': 9, '10': 'appBuildNumber'},
    {'1': 'LocationEnglish', '3': 8, '4': 1, '5': 9, '10': 'LocationEnglish'},
    {'1': 'LocationRussian', '3': 9, '4': 1, '5': 9, '10': 'LocationRussian'},
  ],
};

@$core.Deprecated('Use deviceSessionsDescriptor instead')
const DeviceSessions_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use deviceSessionsDescriptor instead')
const DeviceSessions_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.DeviceSessions.DeviceSession', '10': 'results'},
  ],
};

/// Descriptor for `DeviceSessions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceSessionsDescriptor =
    $convert.base64Decode('Cg5EZXZpY2VTZXNzaW9ucxrRAgoNRGV2aWNlU2Vzc2lvbhIcCglzZXNzaW9uSUQYASABKAxSCX'
        'Nlc3Npb25JRBI2Cgh1cGRhdGVBdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
        'CHVwZGF0ZUF0EiAKC2RldmljZU1vZGVsGAMgASgJUgtkZXZpY2VNb2RlbBIOCgJvcxgEIAEoBV'
        'ICb3MSHAoJb3NWZXJzaW9uGAUgASgJUglvc1ZlcnNpb24SHgoKYXBwVmVyc2lvbhgGIAEoCVIK'
        'YXBwVmVyc2lvbhImCg5hcHBCdWlsZE51bWJlchgHIAEoCVIOYXBwQnVpbGROdW1iZXISKAoPTG'
        '9jYXRpb25FbmdsaXNoGAggASgJUg9Mb2NhdGlvbkVuZ2xpc2gSKAoPTG9jYXRpb25SdXNzaWFu'
        'GAkgASgJUg9Mb2NhdGlvblJ1c3NpYW4aCQoHUmVxdWVzdBpNCghSZXNwb25zZRJBCgdyZXN1bH'
        'RzGAEgAygLMicuaXBlcm9uLnYxLkRldmljZVNlc3Npb25zLkRldmljZVNlc3Npb25SB3Jlc3Vs'
        'dHM=');

@$core.Deprecated('Use deviceSessionsTerminateDescriptor instead')
const DeviceSessionsTerminate$json = {
  '1': 'DeviceSessionsTerminate',
  '3': [DeviceSessionsTerminate_Request$json, DeviceSessionsTerminate_Response$json],
};

@$core.Deprecated('Use deviceSessionsTerminateDescriptor instead')
const DeviceSessionsTerminate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 3, '5': 12, '10': 'sessionID'},
  ],
};

@$core.Deprecated('Use deviceSessionsTerminateDescriptor instead')
const DeviceSessionsTerminate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `DeviceSessionsTerminate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceSessionsTerminateDescriptor =
    $convert.base64Decode('ChdEZXZpY2VTZXNzaW9uc1Rlcm1pbmF0ZRonCgdSZXF1ZXN0EhwKCXNlc3Npb25JRBgBIAMoDF'
        'IJc2Vzc2lvbklEGgoKCFJlc3BvbnNl');
