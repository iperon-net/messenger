// This is a generated file - do not edit.
//
// Generated from protos/call_v1.proto.

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

@$core.Deprecated('Use callRingDescriptor instead')
const CallRing$json = {
  '1': 'CallRing',
  '2': [
    {'1': 'callId', '3': 1, '4': 1, '5': 9, '10': 'callId'},
    {'1': 'toUserID', '3': 2, '4': 1, '5': 12, '10': 'toUserID'},
    {'1': 'fromUserID', '3': 3, '4': 1, '5': 12, '10': 'fromUserID'},
    {'1': 'video', '3': 4, '4': 1, '5': 8, '10': 'video'},
  ],
};

/// Descriptor for `CallRing`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callRingDescriptor =
    $convert.base64Decode('CghDYWxsUmluZxIWCgZjYWxsSWQYASABKAlSBmNhbGxJZBIaCgh0b1VzZXJJRBgCIAEoDFIIdG'
        '9Vc2VySUQSHgoKZnJvbVVzZXJJRBgDIAEoDFIKZnJvbVVzZXJJRBIUCgV2aWRlbxgEIAEoCFIF'
        'dmlkZW8=');

@$core.Deprecated('Use callTokenDescriptor instead')
const CallToken$json = {
  '1': 'CallToken',
  '3': [CallToken_Request$json, CallToken_Response$json],
};

@$core.Deprecated('Use callTokenDescriptor instead')
const CallToken_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'callId', '3': 1, '4': 1, '5': 9, '10': 'callId'},
    {'1': 'toUserID', '3': 2, '4': 1, '5': 12, '10': 'toUserID'},
  ],
};

@$core.Deprecated('Use callTokenDescriptor instead')
const CallToken_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `CallToken`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callTokenDescriptor =
    $convert.base64Decode('CglDYWxsVG9rZW4aPQoHUmVxdWVzdBIWCgZjYWxsSWQYASABKAlSBmNhbGxJZBIaCgh0b1VzZX'
        'JJRBgCIAEoDFIIdG9Vc2VySUQaMgoIUmVzcG9uc2USEAoDdXJsGAEgASgJUgN1cmwSFAoFdG9r'
        'ZW4YAiABKAlSBXRva2Vu');
