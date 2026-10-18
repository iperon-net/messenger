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
    {'1': 'media', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.SecretMedia', '9': 0, '10': 'media'},
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
        'RlSABSBmRlbGV0ZRIuCgVtZWRpYRgFIAEoCzIWLmlwZXJvbi52MS5TZWNyZXRNZWRpYUgAUgVt'
        'ZWRpYUIJCgdwYXlsb2Fk');

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

@$core.Deprecated('Use secretMediaDescriptor instead')
const SecretMedia$json = {
  '1': 'SecretMedia',
  '2': [
    {'1': 'kind', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.SecretMedia.Kind', '10': 'kind'},
    {'1': 'fileID', '3': 2, '4': 1, '5': 12, '10': 'fileID'},
    {'1': 'key', '3': 3, '4': 1, '5': 12, '10': 'key'},
    {'1': 'hkdfSalt', '3': 4, '4': 1, '5': 12, '10': 'hkdfSalt'},
    {'1': 'sha256', '3': 5, '4': 1, '5': 12, '10': 'sha256'},
    {'1': 'size', '3': 6, '4': 1, '5': 3, '10': 'size'},
    {'1': 'mimeType', '3': 7, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'fileName', '3': 8, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'width', '3': 9, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 10, '4': 1, '5': 5, '10': 'height'},
    {'1': 'duration', '3': 11, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'thumbhash', '3': 12, '4': 1, '5': 9, '10': 'thumbhash'},
    {'1': 'thumb', '3': 13, '4': 1, '5': 12, '10': 'thumb'},
    {'1': 'spoiler', '3': 14, '4': 1, '5': 8, '10': 'spoiler'},
    {'1': 'waveform', '3': 15, '4': 1, '5': 12, '10': 'waveform'},
    {'1': 'caption', '3': 16, '4': 1, '5': 9, '10': 'caption'},
    {'1': 'replyToRandomID', '3': 17, '4': 1, '5': 3, '10': 'replyToRandomID'},
  ],
  '4': [SecretMedia_Kind$json],
};

@$core.Deprecated('Use secretMediaDescriptor instead')
const SecretMedia_Kind$json = {
  '1': 'Kind',
  '2': [
    {'1': 'PHOTO', '2': 0},
    {'1': 'VIDEO', '2': 1},
    {'1': 'FILE', '2': 2},
    {'1': 'VOICE', '2': 3},
  ],
};

/// Descriptor for `SecretMedia`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List secretMediaDescriptor =
    $convert.base64Decode('CgtTZWNyZXRNZWRpYRIvCgRraW5kGAEgASgOMhsuaXBlcm9uLnYxLlNlY3JldE1lZGlhLktpbm'
        'RSBGtpbmQSFgoGZmlsZUlEGAIgASgMUgZmaWxlSUQSEAoDa2V5GAMgASgMUgNrZXkSGgoIaGtk'
        'ZlNhbHQYBCABKAxSCGhrZGZTYWx0EhYKBnNoYTI1NhgFIAEoDFIGc2hhMjU2EhIKBHNpemUYBi'
        'ABKANSBHNpemUSGgoIbWltZVR5cGUYByABKAlSCG1pbWVUeXBlEhoKCGZpbGVOYW1lGAggASgJ'
        'UghmaWxlTmFtZRIUCgV3aWR0aBgJIAEoBVIFd2lkdGgSFgoGaGVpZ2h0GAogASgFUgZoZWlnaH'
        'QSGgoIZHVyYXRpb24YCyABKAVSCGR1cmF0aW9uEhwKCXRodW1iaGFzaBgMIAEoCVIJdGh1bWJo'
        'YXNoEhQKBXRodW1iGA0gASgMUgV0aHVtYhIYCgdzcG9pbGVyGA4gASgIUgdzcG9pbGVyEhoKCH'
        'dhdmVmb3JtGA8gASgMUgh3YXZlZm9ybRIYCgdjYXB0aW9uGBAgASgJUgdjYXB0aW9uEigKD3Jl'
        'cGx5VG9SYW5kb21JRBgRIAEoA1IPcmVwbHlUb1JhbmRvbUlEIjEKBEtpbmQSCQoFUEhPVE8QAB'
        'IJCgVWSURFTxABEggKBEZJTEUQAhIJCgVWT0lDRRAD');
