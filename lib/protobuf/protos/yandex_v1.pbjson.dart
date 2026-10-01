// This is a generated file - do not edit.
//
// Generated from protos/yandex_v1.proto.

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

@$core.Deprecated('Use authYandexDescriptor instead')
const AuthYandex$json = {
  '1': 'AuthYandex',
  '3': [AuthYandex_Request$json, AuthYandex_Response$json],
};

@$core.Deprecated('Use authYandexDescriptor instead')
const AuthYandex_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

@$core.Deprecated('Use authYandexDescriptor instead')
const AuthYandex_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'hasTwoStepVerification', '3': 2, '4': 1, '5': 8, '10': 'hasTwoStepVerification'},
  ],
};

/// Descriptor for `AuthYandex`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authYandexDescriptor =
    $convert.base64Decode('CgpBdXRoWWFuZGV4Gh8KB1JlcXVlc3QSFAoFdG9rZW4YASABKAlSBXRva2VuGnQKCFJlc3Bvbn'
        'NlEjAKE2NvbmZpcm1hdGlvblNlc3Npb24YASABKAxSE2NvbmZpcm1hdGlvblNlc3Npb24SNgoW'
        'aGFzVHdvU3RlcFZlcmlmaWNhdGlvbhgCIAEoCFIWaGFzVHdvU3RlcFZlcmlmaWNhdGlvbg==');
