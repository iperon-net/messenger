// This is a generated file - do not edit.
//
// Generated from protos/secret_payload_v1.proto.

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

@$core.Deprecated('Use secretPayloadDescriptor instead')
const SecretPayload$json = {
  '1': 'SecretPayload',
  '2': [
    {'1': 'layer', '3': 1, '4': 1, '5': 5, '10': 'layer'},
    {'1': 'text', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.SecretText', '9': 0, '10': 'text'},
    {'1': 'read', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.SecretRead', '9': 0, '10': 'read'},
    {'1': 'delete', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.SecretDelete', '9': 0, '10': 'delete'},
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `SecretPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List secretPayloadDescriptor =
    $convert.base64Decode('Cg1TZWNyZXRQYXlsb2FkEhQKBWxheWVyGAEgASgFUgVsYXllchIrCgR0ZXh0GAIgASgLMhUuaX'
        'Blcm9uLnYxLlNlY3JldFRleHRIAFIEdGV4dBIrCgRyZWFkGAMgASgLMhUuaXBlcm9uLnYxLlNl'
        'Y3JldFJlYWRIAFIEcmVhZBIxCgZkZWxldGUYBCABKAsyFy5pcGVyb24udjEuU2VjcmV0RGVsZX'
        'RlSABSBmRlbGV0ZUIJCgdwYXlsb2Fk');

@$core.Deprecated('Use secretTextDescriptor instead')
const SecretText$json = {
  '1': 'SecretText',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'replyToRandomID', '3': 2, '4': 1, '5': 3, '10': 'replyToRandomID'},
  ],
};

/// Descriptor for `SecretText`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List secretTextDescriptor =
    $convert.base64Decode('CgpTZWNyZXRUZXh0EhIKBHRleHQYASABKAlSBHRleHQSKAoPcmVwbHlUb1JhbmRvbUlEGAIgAS'
        'gDUg9yZXBseVRvUmFuZG9tSUQ=');

@$core.Deprecated('Use secretReadDescriptor instead')
const SecretRead$json = {
  '1': 'SecretRead',
  '2': [
    {'1': 'randomIDs', '3': 1, '4': 3, '5': 3, '10': 'randomIDs'},
  ],
};

/// Descriptor for `SecretRead`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List secretReadDescriptor = $convert.base64Decode('CgpTZWNyZXRSZWFkEhwKCXJhbmRvbUlEcxgBIAMoA1IJcmFuZG9tSURz');

@$core.Deprecated('Use secretDeleteDescriptor instead')
const SecretDelete$json = {
  '1': 'SecretDelete',
  '2': [
    {'1': 'randomIDs', '3': 1, '4': 3, '5': 3, '10': 'randomIDs'},
  ],
};

/// Descriptor for `SecretDelete`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List secretDeleteDescriptor = $convert.base64Decode('CgxTZWNyZXREZWxldGUSHAoJcmFuZG9tSURzGAEgAygDUglyYW5kb21JRHM=');
