// This is a generated file - do not edit.
//
// Generated from protos/account_deletion_v1.proto.

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

@$core.Deprecated('Use accountDeletionRequestDescriptor instead')
const AccountDeletionRequest$json = {
  '1': 'AccountDeletionRequest',
  '3': [AccountDeletionRequest_Request$json, AccountDeletionRequest_Response$json],
};

@$core.Deprecated('Use accountDeletionRequestDescriptor instead')
const AccountDeletionRequest_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'cloudPasswordToken', '3': 2, '4': 1, '5': 12, '10': 'cloudPasswordToken'},
  ],
};

@$core.Deprecated('Use accountDeletionRequestDescriptor instead')
const AccountDeletionRequest_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'manualDeleteAfter', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'manualDeleteAfter'},
    {'1': 'alreadyScheduled', '3': 2, '4': 1, '5': 8, '10': 'alreadyScheduled'},
  ],
};

/// Descriptor for `AccountDeletionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDeletionRequestDescriptor =
    $convert.base64Decode('ChZBY2NvdW50RGVsZXRpb25SZXF1ZXN0GjkKB1JlcXVlc3QSLgoSY2xvdWRQYXNzd29yZFRva2'
        'VuGAIgASgMUhJjbG91ZFBhc3N3b3JkVG9rZW4agAEKCFJlc3BvbnNlEkgKEW1hbnVhbERlbGV0'
        'ZUFmdGVyGAEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIRbWFudWFsRGVsZXRlQW'
        'Z0ZXISKgoQYWxyZWFkeVNjaGVkdWxlZBgCIAEoCFIQYWxyZWFkeVNjaGVkdWxlZA==');

@$core.Deprecated('Use accountDeletionCancelDescriptor instead')
const AccountDeletionCancel$json = {
  '1': 'AccountDeletionCancel',
  '3': [AccountDeletionCancel_Request$json, AccountDeletionCancel_Response$json],
};

@$core.Deprecated('Use accountDeletionCancelDescriptor instead')
const AccountDeletionCancel_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use accountDeletionCancelDescriptor instead')
const AccountDeletionCancel_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'cancelled', '3': 1, '4': 1, '5': 8, '10': 'cancelled'},
  ],
};

/// Descriptor for `AccountDeletionCancel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDeletionCancelDescriptor =
    $convert.base64Decode('ChVBY2NvdW50RGVsZXRpb25DYW5jZWwaCQoHUmVxdWVzdBooCghSZXNwb25zZRIcCgljYW5jZW'
        'xsZWQYASABKAhSCWNhbmNlbGxlZA==');

@$core.Deprecated('Use accountDeletionStatusDescriptor instead')
const AccountDeletionStatus$json = {
  '1': 'AccountDeletionStatus',
  '3': [AccountDeletionStatus_Request$json, AccountDeletionStatus_Response$json],
};

@$core.Deprecated('Use accountDeletionStatusDescriptor instead')
const AccountDeletionStatus_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use accountDeletionStatusDescriptor instead')
const AccountDeletionStatus_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'manualDeleteAfter', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'manualDeleteAfter'},
    {'1': 'autoDeleteAfter', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'autoDeleteAfter'},
    {'1': 'deletionState', '3': 3, '4': 1, '5': 9, '10': 'deletionState'},
  ],
};

/// Descriptor for `AccountDeletionStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDeletionStatusDescriptor =
    $convert.base64Decode('ChVBY2NvdW50RGVsZXRpb25TdGF0dXMaCQoHUmVxdWVzdBrAAQoIUmVzcG9uc2USSAoRbWFudW'
        'FsRGVsZXRlQWZ0ZXIYASABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhFtYW51YWxE'
        'ZWxldGVBZnRlchJECg9hdXRvRGVsZXRlQWZ0ZXIYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
        'ltZXN0YW1wUg9hdXRvRGVsZXRlQWZ0ZXISJAoNZGVsZXRpb25TdGF0ZRgDIAEoCVINZGVsZXRp'
        'b25TdGF0ZQ==');

@$core.Deprecated('Use accountActivityDescriptor instead')
const AccountActivity$json = {
  '1': 'AccountActivity',
  '3': [AccountActivity_Request$json, AccountActivity_Response$json],
};

@$core.Deprecated('Use accountActivityDescriptor instead')
const AccountActivity_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use accountActivityDescriptor instead')
const AccountActivity_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'autoDeleteAfter', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'autoDeleteAfter'},
  ],
};

/// Descriptor for `AccountActivity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountActivityDescriptor =
    $convert.base64Decode('Cg9BY2NvdW50QWN0aXZpdHkaCQoHUmVxdWVzdBpQCghSZXNwb25zZRJECg9hdXRvRGVsZXRlQW'
        'Z0ZXIYASABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg9hdXRvRGVsZXRlQWZ0ZXI=');
