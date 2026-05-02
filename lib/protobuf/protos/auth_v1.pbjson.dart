// This is a generated file - do not edit.
//
// Generated from protos/auth_v1.proto.

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

@$core.Deprecated('Use authCallPasswordRequestDescriptor instead')
const AuthCallPasswordRequest$json = {
  '1': 'AuthCallPasswordRequest',
  '2': [
    {'1': 'phoneNumber', '3': 1, '4': 1, '5': 9, '10': 'phoneNumber'},
  ],
};

/// Descriptor for `AuthCallPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCallPasswordRequestDescriptor =
    $convert.base64Decode(
        'ChdBdXRoQ2FsbFBhc3N3b3JkUmVxdWVzdBIgCgtwaG9uZU51bWJlchgBIAEoCVILcGhvbmVOdW'
        '1iZXI=');

@$core.Deprecated('Use authCallPasswordResponseDescriptor instead')
const AuthCallPasswordResponse$json = {
  '1': 'AuthCallPasswordResponse',
  '2': [
    {
      '1': 'callPasswordSession',
      '3': 1,
      '4': 1,
      '5': 12,
      '10': 'callPasswordSession'
    },
    {'1': 'timeout', '3': 2, '4': 1, '5': 2, '10': 'timeout'},
    {
      '1': 'confirmationPhoneNumber',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'confirmationPhoneNumber'
    },
  ],
};

/// Descriptor for `AuthCallPasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCallPasswordResponseDescriptor = $convert.base64Decode(
    'ChhBdXRoQ2FsbFBhc3N3b3JkUmVzcG9uc2USMAoTY2FsbFBhc3N3b3JkU2Vzc2lvbhgBIAEoDF'
    'ITY2FsbFBhc3N3b3JkU2Vzc2lvbhIYCgd0aW1lb3V0GAIgASgCUgd0aW1lb3V0EjgKF2NvbmZp'
    'cm1hdGlvblBob25lTnVtYmVyGAMgASgJUhdjb25maXJtYXRpb25QaG9uZU51bWJlcg==');

@$core.Deprecated('Use authCallPasswordCheckRequestDescriptor instead')
const AuthCallPasswordCheckRequest$json = {
  '1': 'AuthCallPasswordCheckRequest',
  '2': [
    {
      '1': 'callPasswordSession',
      '3': 1,
      '4': 1,
      '5': 12,
      '10': 'callPasswordSession'
    },
  ],
};

/// Descriptor for `AuthCallPasswordCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCallPasswordCheckRequestDescriptor =
    $convert.base64Decode(
        'ChxBdXRoQ2FsbFBhc3N3b3JkQ2hlY2tSZXF1ZXN0EjAKE2NhbGxQYXNzd29yZFNlc3Npb24YAS'
        'ABKAxSE2NhbGxQYXNzd29yZFNlc3Npb24=');

@$core.Deprecated('Use authCallPasswordCheckResponseDescriptor instead')
const AuthCallPasswordCheckResponse$json = {
  '1': 'AuthCallPasswordCheckResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.iperon.v1.Status',
      '10': 'status'
    },
    {'1': 'timer', '3': 2, '4': 1, '5': 3, '9': 0, '10': 'timer', '17': true},
    {
      '1': 'errorMessage',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'errorMessage',
      '17': true
    },
    {
      '1': 'confirmationSession',
      '3': 4,
      '4': 1,
      '5': 12,
      '9': 2,
      '10': 'confirmationSession',
      '17': true
    },
    {
      '1': 'hasCloudPassword',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 3,
      '10': 'hasCloudPassword',
      '17': true
    },
    {
      '1': 'isBlocked',
      '3': 6,
      '4': 1,
      '5': 8,
      '9': 4,
      '10': 'isBlocked',
      '17': true
    },
  ],
  '8': [
    {'1': '_timer'},
    {'1': '_errorMessage'},
    {'1': '_confirmationSession'},
    {'1': '_hasCloudPassword'},
    {'1': '_isBlocked'},
  ],
};

/// Descriptor for `AuthCallPasswordCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCallPasswordCheckResponseDescriptor = $convert.base64Decode(
    'Ch1BdXRoQ2FsbFBhc3N3b3JkQ2hlY2tSZXNwb25zZRIpCgZzdGF0dXMYASABKA4yES5pcGVyb2'
    '4udjEuU3RhdHVzUgZzdGF0dXMSGQoFdGltZXIYAiABKANIAFIFdGltZXKIAQESJwoMZXJyb3JN'
    'ZXNzYWdlGAMgASgJSAFSDGVycm9yTWVzc2FnZYgBARI1ChNjb25maXJtYXRpb25TZXNzaW9uGA'
    'QgASgMSAJSE2NvbmZpcm1hdGlvblNlc3Npb26IAQESLwoQaGFzQ2xvdWRQYXNzd29yZBgFIAEo'
    'CEgDUhBoYXNDbG91ZFBhc3N3b3JkiAEBEiEKCWlzQmxvY2tlZBgGIAEoCEgEUglpc0Jsb2NrZW'
    'SIAQFCCAoGX3RpbWVyQg8KDV9lcnJvck1lc3NhZ2VCFgoUX2NvbmZpcm1hdGlvblNlc3Npb25C'
    'EwoRX2hhc0Nsb3VkUGFzc3dvcmRCDAoKX2lzQmxvY2tlZA==');

@$core.Deprecated('Use authConfirmationRequestDescriptor instead')
const AuthConfirmationRequest$json = {
  '1': 'AuthConfirmationRequest',
  '2': [
    {
      '1': 'confirmationSession',
      '3': 1,
      '4': 1,
      '5': 12,
      '10': 'confirmationSession'
    },
    {
      '1': 'clientPublicKeyECDH',
      '3': 2,
      '4': 1,
      '5': 12,
      '10': 'clientPublicKeyECDH'
    },
    {'1': 'deviceModel', '3': 3, '4': 1, '5': 9, '10': 'deviceModel'},
    {'1': 'os', '3': 4, '4': 1, '5': 5, '10': 'os'},
    {'1': 'osVersion', '3': 5, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'appVersion', '3': 6, '4': 1, '5': 9, '10': 'appVersion'},
    {'1': 'appBuildNumber', '3': 7, '4': 1, '5': 9, '10': 'appBuildNumber'},
  ],
};

/// Descriptor for `AuthConfirmationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authConfirmationRequestDescriptor = $convert.base64Decode(
    'ChdBdXRoQ29uZmlybWF0aW9uUmVxdWVzdBIwChNjb25maXJtYXRpb25TZXNzaW9uGAEgASgMUh'
    'Njb25maXJtYXRpb25TZXNzaW9uEjAKE2NsaWVudFB1YmxpY0tleUVDREgYAiABKAxSE2NsaWVu'
    'dFB1YmxpY0tleUVDREgSIAoLZGV2aWNlTW9kZWwYAyABKAlSC2RldmljZU1vZGVsEg4KAm9zGA'
    'QgASgFUgJvcxIcCglvc1ZlcnNpb24YBSABKAlSCW9zVmVyc2lvbhIeCgphcHBWZXJzaW9uGAYg'
    'ASgJUgphcHBWZXJzaW9uEiYKDmFwcEJ1aWxkTnVtYmVyGAcgASgJUg5hcHBCdWlsZE51bWJlcg'
    '==');

@$core.Deprecated('Use authConfirmationResponseDescriptor instead')
const AuthConfirmationResponse$json = {
  '1': 'AuthConfirmationResponse',
  '2': [
    {'1': 'session', '3': 1, '4': 1, '5': 12, '10': 'session'},
    {'1': 'userID', '3': 2, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'phoneNumber', '3': 3, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'sharedKeyID', '3': 4, '4': 1, '5': 12, '10': 'sharedKeyID'},
  ],
};

/// Descriptor for `AuthConfirmationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authConfirmationResponseDescriptor = $convert.base64Decode(
    'ChhBdXRoQ29uZmlybWF0aW9uUmVzcG9uc2USGAoHc2Vzc2lvbhgBIAEoDFIHc2Vzc2lvbhIWCg'
    'Z1c2VySUQYAiABKAxSBnVzZXJJRBIgCgtwaG9uZU51bWJlchgDIAEoCVILcGhvbmVOdW1iZXIS'
    'IAoLc2hhcmVkS2V5SUQYBCABKAxSC3NoYXJlZEtleUlE');
