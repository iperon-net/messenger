// This is a generated file - do not edit.
//
// Generated from protos/qr_login_v1.proto.

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

@$core.Deprecated('Use authQrDescriptor instead')
const AuthQr$json = {
  '1': 'AuthQr',
  '3': [AuthQr_Device$json, AuthQr_Create$json, AuthQr_Check$json, AuthQr_Request$json, AuthQr_Response$json],
  '4': [AuthQr_Status$json],
};

@$core.Deprecated('Use authQrDescriptor instead')
const AuthQr_Device$json = {
  '1': 'Device',
  '2': [
    {'1': 'deviceModel', '3': 1, '4': 1, '5': 9, '10': 'deviceModel'},
    {'1': 'os', '3': 2, '4': 1, '5': 5, '10': 'os'},
    {'1': 'osVersion', '3': 3, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'appVersion', '3': 4, '4': 1, '5': 9, '10': 'appVersion'},
  ],
};

@$core.Deprecated('Use authQrDescriptor instead')
const AuthQr_Create$json = {
  '1': 'Create',
  '2': [
    {'1': 'device', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.AuthQr.Device', '10': 'device'},
  ],
};

@$core.Deprecated('Use authQrDescriptor instead')
const AuthQr_Check$json = {
  '1': 'Check',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 12, '10': 'token'},
  ],
};

@$core.Deprecated('Use authQrDescriptor instead')
const AuthQr_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'newToken', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.AuthQr.Create', '9': 0, '10': 'newToken'},
    {'1': 'poll', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.AuthQr.Check', '9': 0, '10': 'poll'},
  ],
  '8': [
    {'1': 'action'},
  ],
};

@$core.Deprecated('Use authQrDescriptor instead')
const AuthQr_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 12, '10': 'token'},
    {'1': 'expiresAt', '3': 2, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'status', '3': 3, '4': 1, '5': 14, '6': '.iperon.v1.AuthQr.Status', '10': 'status'},
    {'1': 'confirmationSession', '3': 4, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'hasTwoStepVerification', '3': 5, '4': 1, '5': 8, '10': 'hasTwoStepVerification'},
  ],
};

@$core.Deprecated('Use authQrDescriptor instead')
const AuthQr_Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'PENDING', '2': 0},
    {'1': 'ACCEPTED', '2': 1},
    {'1': 'EXPIRED', '2': 2},
  ],
};

/// Descriptor for `AuthQr`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authQrDescriptor =
    $convert.base64Decode('CgZBdXRoUXIaeAoGRGV2aWNlEiAKC2RldmljZU1vZGVsGAEgASgJUgtkZXZpY2VNb2RlbBIOCg'
        'JvcxgCIAEoBVICb3MSHAoJb3NWZXJzaW9uGAMgASgJUglvc1ZlcnNpb24SHgoKYXBwVmVyc2lv'
        'bhgEIAEoCVIKYXBwVmVyc2lvbho6CgZDcmVhdGUSMAoGZGV2aWNlGAEgASgLMhguaXBlcm9uLn'
        'YxLkF1dGhRci5EZXZpY2VSBmRldmljZRodCgVDaGVjaxIUCgV0b2tlbhgBIAEoDFIFdG9rZW4a'
        'egoHUmVxdWVzdBI2CghuZXdUb2tlbhgBIAEoCzIYLmlwZXJvbi52MS5BdXRoUXIuQ3JlYXRlSA'
        'BSCG5ld1Rva2VuEi0KBHBvbGwYAiABKAsyFy5pcGVyb24udjEuQXV0aFFyLkNoZWNrSABSBHBv'
        'bGxCCAoGYWN0aW9uGtoBCghSZXNwb25zZRIUCgV0b2tlbhgBIAEoDFIFdG9rZW4SHAoJZXhwaX'
        'Jlc0F0GAIgASgDUglleHBpcmVzQXQSMAoGc3RhdHVzGAMgASgOMhguaXBlcm9uLnYxLkF1dGhR'
        'ci5TdGF0dXNSBnN0YXR1cxIwChNjb25maXJtYXRpb25TZXNzaW9uGAQgASgMUhNjb25maXJtYX'
        'Rpb25TZXNzaW9uEjYKFmhhc1R3b1N0ZXBWZXJpZmljYXRpb24YBSABKAhSFmhhc1R3b1N0ZXBW'
        'ZXJpZmljYXRpb24iMAoGU3RhdHVzEgsKB1BFTkRJTkcQABIMCghBQ0NFUFRFRBABEgsKB0VYUE'
        'lSRUQQAg==');

@$core.Deprecated('Use authQrConfirmDescriptor instead')
const AuthQrConfirm$json = {
  '1': 'AuthQrConfirm',
  '3': [AuthQrConfirm_Request$json, AuthQrConfirm_Response$json],
};

@$core.Deprecated('Use authQrConfirmDescriptor instead')
const AuthQrConfirm_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 12, '10': 'token'},
    {'1': 'accept', '3': 2, '4': 1, '5': 8, '10': 'accept'},
  ],
};

@$core.Deprecated('Use authQrConfirmDescriptor instead')
const AuthQrConfirm_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'device', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.AuthQr.Device', '10': 'device'},
    {'1': 'locationEnglish', '3': 2, '4': 1, '5': 9, '10': 'locationEnglish'},
    {'1': 'locationRussian', '3': 3, '4': 1, '5': 9, '10': 'locationRussian'},
  ],
};

/// Descriptor for `AuthQrConfirm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authQrConfirmDescriptor =
    $convert.base64Decode('Cg1BdXRoUXJDb25maXJtGjcKB1JlcXVlc3QSFAoFdG9rZW4YASABKAxSBXRva2VuEhYKBmFjY2'
        'VwdBgCIAEoCFIGYWNjZXB0GpABCghSZXNwb25zZRIwCgZkZXZpY2UYASABKAsyGC5pcGVyb24u'
        'djEuQXV0aFFyLkRldmljZVIGZGV2aWNlEigKD2xvY2F0aW9uRW5nbGlzaBgCIAEoCVIPbG9jYX'
        'Rpb25FbmdsaXNoEigKD2xvY2F0aW9uUnVzc2lhbhgDIAEoCVIPbG9jYXRpb25SdXNzaWFu');
