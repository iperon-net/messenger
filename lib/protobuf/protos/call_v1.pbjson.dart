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

@$core.Deprecated('Use callDescriptor instead')
const Call$json = {
  '1': 'Call',
  '3': [Call_Signal$json, Call_IceCandidate$json],
};

@$core.Deprecated('Use callDescriptor instead')
const Call_Signal$json = {
  '1': 'Signal',
  '2': [
    {'1': 'callId', '3': 1, '4': 1, '5': 9, '10': 'callId'},
    {'1': 'toUserID', '3': 2, '4': 1, '5': 12, '10': 'toUserID'},
    {'1': 'fromUserID', '3': 3, '4': 1, '5': 12, '10': 'fromUserID'},
    {'1': 'callType', '3': 4, '4': 1, '5': 14, '6': '.iperon.v1.Call.Signal.CallType', '10': 'callType'},
    {'1': 'sdp', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'sdp'},
    {'1': 'candidate', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.Call.IceCandidate', '9': 0, '10': 'candidate'},
  ],
  '4': [Call_Signal_CallType$json],
  '8': [
    {'1': 'body'},
  ],
};

@$core.Deprecated('Use callDescriptor instead')
const Call_Signal_CallType$json = {
  '1': 'CallType',
  '2': [
    {'1': 'AUDIO', '2': 0},
    {'1': 'VIDEO', '2': 1},
  ],
};

@$core.Deprecated('Use callDescriptor instead')
const Call_IceCandidate$json = {
  '1': 'IceCandidate',
  '2': [
    {'1': 'candidate', '3': 1, '4': 1, '5': 9, '10': 'candidate'},
    {'1': 'sdpMid', '3': 2, '4': 1, '5': 9, '10': 'sdpMid'},
    {'1': 'sdpMLineIndex', '3': 3, '4': 1, '5': 5, '10': 'sdpMLineIndex'},
  ],
};

/// Descriptor for `Call`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDescriptor =
    $convert.base64Decode('CgRDYWxsGpUCCgZTaWduYWwSFgoGY2FsbElkGAEgASgJUgZjYWxsSWQSGgoIdG9Vc2VySUQYAi'
        'ABKAxSCHRvVXNlcklEEh4KCmZyb21Vc2VySUQYAyABKAxSCmZyb21Vc2VySUQSOwoIY2FsbFR5'
        'cGUYBCABKA4yHy5pcGVyb24udjEuQ2FsbC5TaWduYWwuQ2FsbFR5cGVSCGNhbGxUeXBlEhIKA3'
        'NkcBgFIAEoCUgAUgNzZHASPAoJY2FuZGlkYXRlGAYgASgLMhwuaXBlcm9uLnYxLkNhbGwuSWNl'
        'Q2FuZGlkYXRlSABSCWNhbmRpZGF0ZSIgCghDYWxsVHlwZRIJCgVBVURJTxAAEgkKBVZJREVPEA'
        'FCBgoEYm9keRpqCgxJY2VDYW5kaWRhdGUSHAoJY2FuZGlkYXRlGAEgASgJUgljYW5kaWRhdGUS'
        'FgoGc2RwTWlkGAIgASgJUgZzZHBNaWQSJAoNc2RwTUxpbmVJbmRleBgDIAEoBVINc2RwTUxpbm'
        'VJbmRleA==');
