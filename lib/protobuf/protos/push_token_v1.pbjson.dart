// This is a generated file - do not edit.
//
// Generated from protos/push_token_v1.proto.

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

@$core.Deprecated('Use registerPushTokenDescriptor instead')
const RegisterPushToken$json = {
  '1': 'RegisterPushToken',
  '3': [RegisterPushToken_Request$json, RegisterPushToken_Response$json],
  '4': [RegisterPushToken_TokenType$json, RegisterPushToken_Platform$json],
};

@$core.Deprecated('Use registerPushTokenDescriptor instead')
const RegisterPushToken_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.iperon.v1.RegisterPushToken.TokenType', '10': 'type'},
    {'1': 'platform', '3': 3, '4': 1, '5': 14, '6': '.iperon.v1.RegisterPushToken.Platform', '10': 'platform'},
  ],
};

@$core.Deprecated('Use registerPushTokenDescriptor instead')
const RegisterPushToken_Response$json = {
  '1': 'Response',
};

@$core.Deprecated('Use registerPushTokenDescriptor instead')
const RegisterPushToken_TokenType$json = {
  '1': 'TokenType',
  '2': [
    {'1': 'FCM', '2': 0},
    {'1': 'APNS_VOIP', '2': 1},
  ],
};

@$core.Deprecated('Use registerPushTokenDescriptor instead')
const RegisterPushToken_Platform$json = {
  '1': 'Platform',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'ANDROID', '2': 1},
    {'1': 'IOS', '2': 2},
  ],
};

/// Descriptor for `RegisterPushToken`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPushTokenDescriptor =
    $convert.base64Decode('ChFSZWdpc3RlclB1c2hUb2tlbhqeAQoHUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4SOg'
        'oEdHlwZRgCIAEoDjImLmlwZXJvbi52MS5SZWdpc3RlclB1c2hUb2tlbi5Ub2tlblR5cGVSBHR5'
        'cGUSQQoIcGxhdGZvcm0YAyABKA4yJS5pcGVyb24udjEuUmVnaXN0ZXJQdXNoVG9rZW4uUGxhdG'
        'Zvcm1SCHBsYXRmb3JtGgoKCFJlc3BvbnNlIiMKCVRva2VuVHlwZRIHCgNGQ00QABINCglBUE5T'
        'X1ZPSVAQASItCghQbGF0Zm9ybRILCgdVTktOT1dOEAASCwoHQU5EUk9JRBABEgcKA0lPUxAC');
