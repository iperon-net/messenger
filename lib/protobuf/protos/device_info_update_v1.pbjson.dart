// This is a generated file - do not edit.
//
// Generated from protos/device_info_update_v1.proto.

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

@$core.Deprecated('Use deviceInfoUpdateDescriptor instead')
const DeviceInfoUpdate$json = {
  '1': 'DeviceInfoUpdate',
  '3': [DeviceInfoUpdate_Request$json, DeviceInfoUpdate_Response$json],
};

@$core.Deprecated('Use deviceInfoUpdateDescriptor instead')
const DeviceInfoUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'deviceModel', '3': 1, '4': 1, '5': 9, '10': 'deviceModel'},
    {'1': 'os', '3': 2, '4': 1, '5': 5, '10': 'os'},
    {'1': 'osVersion', '3': 3, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'appVersion', '3': 4, '4': 1, '5': 9, '10': 'appVersion'},
    {'1': 'appBuildNumber', '3': 5, '4': 1, '5': 9, '10': 'appBuildNumber'},
  ],
};

@$core.Deprecated('Use deviceInfoUpdateDescriptor instead')
const DeviceInfoUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `DeviceInfoUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceInfoUpdateDescriptor =
    $convert.base64Decode('ChBEZXZpY2VJbmZvVXBkYXRlGqEBCgdSZXF1ZXN0EiAKC2RldmljZU1vZGVsGAEgASgJUgtkZX'
        'ZpY2VNb2RlbBIOCgJvcxgCIAEoBVICb3MSHAoJb3NWZXJzaW9uGAMgASgJUglvc1ZlcnNpb24S'
        'HgoKYXBwVmVyc2lvbhgEIAEoCVIKYXBwVmVyc2lvbhImCg5hcHBCdWlsZE51bWJlchgFIAEoCV'
        'IOYXBwQnVpbGROdW1iZXIaCgoIUmVzcG9uc2U=');
