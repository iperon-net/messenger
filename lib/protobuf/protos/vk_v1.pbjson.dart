// This is a generated file - do not edit.
//
// Generated from protos/vk_v1.proto.

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

@$core.Deprecated('Use authVKDescriptor instead')
const AuthVK$json = {
  '1': 'AuthVK',
  '3': [AuthVK_Request$json, AuthVK_Response$json],
};

@$core.Deprecated('Use authVKDescriptor instead')
const AuthVK_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'clientId', '3': 2, '4': 1, '5': 9, '10': 'clientId'},
  ],
};

@$core.Deprecated('Use authVKDescriptor instead')
const AuthVK_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'hasTwoStepVerification', '3': 2, '4': 1, '5': 8, '10': 'hasTwoStepVerification'},
  ],
};

/// Descriptor for `AuthVK`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authVKDescriptor =
    $convert.base64Decode('CgZBdXRoVksaOwoHUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4SGgoIY2xpZW50SWQYAi'
        'ABKAlSCGNsaWVudElkGnQKCFJlc3BvbnNlEjAKE2NvbmZpcm1hdGlvblNlc3Npb24YASABKAxS'
        'E2NvbmZpcm1hdGlvblNlc3Npb24SNgoWaGFzVHdvU3RlcFZlcmlmaWNhdGlvbhgCIAEoCFIWaG'
        'FzVHdvU3RlcFZlcmlmaWNhdGlvbg==');
