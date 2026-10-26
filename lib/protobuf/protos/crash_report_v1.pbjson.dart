// This is a generated file - do not edit.
//
// Generated from protos/crash_report_v1.proto.

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

@$core.Deprecated('Use crashReportDescriptor instead')
const CrashReport$json = {
  '1': 'CrashReport',
  '3': [CrashReport_Item$json, CrashReport_Request$json, CrashReport_Response$json],
};

@$core.Deprecated('Use crashReportDescriptor instead')
const CrashReport_Item$json = {
  '1': 'Item',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 9, '10': 'error'},
    {'1': 'stack', '3': 2, '4': 1, '5': 9, '10': 'stack'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'fatal', '3': 4, '4': 1, '5': 8, '10': 'fatal'},
    {'1': 'date', '3': 5, '4': 1, '5': 3, '10': 'date'},
  ],
};

@$core.Deprecated('Use crashReportDescriptor instead')
const CrashReport_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.CrashReport.Item', '10': 'items'},
    {'1': 'appVersion', '3': 2, '4': 1, '5': 9, '10': 'appVersion'},
    {'1': 'appBuildNumber', '3': 3, '4': 1, '5': 9, '10': 'appBuildNumber'},
    {'1': 'os', '3': 4, '4': 1, '5': 5, '10': 'os'},
    {'1': 'osVersion', '3': 5, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'deviceModel', '3': 6, '4': 1, '5': 9, '10': 'deviceModel'},
  ],
};

@$core.Deprecated('Use crashReportDescriptor instead')
const CrashReport_Response$json = {
  '1': 'Response',
};

/// Descriptor for `CrashReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List crashReportDescriptor =
    $convert.base64Decode('CgtDcmFzaFJlcG9ydBp0CgRJdGVtEhQKBWVycm9yGAEgASgJUgVlcnJvchIUCgVzdGFjaxgCIA'
        'EoCVIFc3RhY2sSFgoGcmVhc29uGAMgASgJUgZyZWFzb24SFAoFZmF0YWwYBCABKAhSBWZhdGFs'
        'EhIKBGRhdGUYBSABKANSBGRhdGUa1AEKB1JlcXVlc3QSMQoFaXRlbXMYASADKAsyGy5pcGVyb2'
        '4udjEuQ3Jhc2hSZXBvcnQuSXRlbVIFaXRlbXMSHgoKYXBwVmVyc2lvbhgCIAEoCVIKYXBwVmVy'
        'c2lvbhImCg5hcHBCdWlsZE51bWJlchgDIAEoCVIOYXBwQnVpbGROdW1iZXISDgoCb3MYBCABKA'
        'VSAm9zEhwKCW9zVmVyc2lvbhgFIAEoCVIJb3NWZXJzaW9uEiAKC2RldmljZU1vZGVsGAYgASgJ'
        'UgtkZXZpY2VNb2RlbBoKCghSZXNwb25zZQ==');
