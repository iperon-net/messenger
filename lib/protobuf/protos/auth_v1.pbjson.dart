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
      '1': 'hasTwoStepVerification',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 3,
      '10': 'hasTwoStepVerification',
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
    {'1': '_hasTwoStepVerification'},
    {'1': '_isBlocked'},
  ],
};

/// Descriptor for `AuthCallPasswordCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCallPasswordCheckResponseDescriptor = $convert.base64Decode(
    'Ch1BdXRoQ2FsbFBhc3N3b3JkQ2hlY2tSZXNwb25zZRIpCgZzdGF0dXMYASABKA4yES5pcGVyb2'
    '4udjEuU3RhdHVzUgZzdGF0dXMSGQoFdGltZXIYAiABKANIAFIFdGltZXKIAQESJwoMZXJyb3JN'
    'ZXNzYWdlGAMgASgJSAFSDGVycm9yTWVzc2FnZYgBARI1ChNjb25maXJtYXRpb25TZXNzaW9uGA'
    'QgASgMSAJSE2NvbmZpcm1hdGlvblNlc3Npb26IAQESOwoWaGFzVHdvU3RlcFZlcmlmaWNhdGlv'
    'bhgFIAEoCEgDUhZoYXNUd29TdGVwVmVyaWZpY2F0aW9uiAEBEiEKCWlzQmxvY2tlZBgGIAEoCE'
    'gEUglpc0Jsb2NrZWSIAQFCCAoGX3RpbWVyQg8KDV9lcnJvck1lc3NhZ2VCFgoUX2NvbmZpcm1h'
    'dGlvblNlc3Npb25CGQoXX2hhc1R3b1N0ZXBWZXJpZmljYXRpb25CDAoKX2lzQmxvY2tlZA==');

@$core.Deprecated('Use authSMSRequestDescriptor instead')
const AuthSMSRequest$json = {
  '1': 'AuthSMSRequest',
  '2': [
    {'1': 'phoneNumber', '3': 1, '4': 1, '5': 9, '10': 'phoneNumber'},
  ],
};

/// Descriptor for `AuthSMSRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authSMSRequestDescriptor = $convert.base64Decode(
    'Cg5BdXRoU01TUmVxdWVzdBIgCgtwaG9uZU51bWJlchgBIAEoCVILcGhvbmVOdW1iZXI=');

@$core.Deprecated('Use authSMSResponseDescriptor instead')
const AuthSMSResponse$json = {
  '1': 'AuthSMSResponse',
  '2': [
    {'1': 'smsSession', '3': 1, '4': 1, '5': 12, '10': 'smsSession'},
  ],
};

/// Descriptor for `AuthSMSResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authSMSResponseDescriptor = $convert.base64Decode(
    'Cg9BdXRoU01TUmVzcG9uc2USHgoKc21zU2Vzc2lvbhgBIAEoDFIKc21zU2Vzc2lvbg==');

@$core.Deprecated('Use authSMSCheckRequestDescriptor instead')
const AuthSMSCheckRequest$json = {
  '1': 'AuthSMSCheckRequest',
  '2': [
    {'1': 'smsSession', '3': 1, '4': 1, '5': 12, '10': 'smsSession'},
    {'1': 'verificationCode', '3': 2, '4': 1, '5': 9, '10': 'verificationCode'},
  ],
};

/// Descriptor for `AuthSMSCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authSMSCheckRequestDescriptor = $convert.base64Decode(
    'ChNBdXRoU01TQ2hlY2tSZXF1ZXN0Eh4KCnNtc1Nlc3Npb24YASABKAxSCnNtc1Nlc3Npb24SKg'
    'oQdmVyaWZpY2F0aW9uQ29kZRgCIAEoCVIQdmVyaWZpY2F0aW9uQ29kZQ==');

@$core.Deprecated('Use authSMSCheckResponseDescriptor instead')
const AuthSMSCheckResponse$json = {
  '1': 'AuthSMSCheckResponse',
  '2': [
    {
      '1': 'confirmationSession',
      '3': 1,
      '4': 1,
      '5': 12,
      '9': 0,
      '10': 'confirmationSession',
      '17': true
    },
    {
      '1': 'hasTwoStepVerification',
      '3': 2,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'hasTwoStepVerification',
      '17': true
    },
    {
      '1': 'isBlocked',
      '3': 3,
      '4': 1,
      '5': 8,
      '9': 2,
      '10': 'isBlocked',
      '17': true
    },
  ],
  '8': [
    {'1': '_confirmationSession'},
    {'1': '_hasTwoStepVerification'},
    {'1': '_isBlocked'},
  ],
};

/// Descriptor for `AuthSMSCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authSMSCheckResponseDescriptor = $convert.base64Decode(
    'ChRBdXRoU01TQ2hlY2tSZXNwb25zZRI1ChNjb25maXJtYXRpb25TZXNzaW9uGAEgASgMSABSE2'
    'NvbmZpcm1hdGlvblNlc3Npb26IAQESOwoWaGFzVHdvU3RlcFZlcmlmaWNhdGlvbhgCIAEoCEgB'
    'UhZoYXNUd29TdGVwVmVyaWZpY2F0aW9uiAEBEiEKCWlzQmxvY2tlZBgDIAEoCEgCUglpc0Jsb2'
    'NrZWSIAQFCFgoUX2NvbmZpcm1hdGlvblNlc3Npb25CGQoXX2hhc1R3b1N0ZXBWZXJpZmljYXRp'
    'b25CDAoKX2lzQmxvY2tlZA==');

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
      '1': 'cipherTextSharedKey',
      '3': 2,
      '4': 1,
      '5': 12,
      '10': 'cipherTextSharedKey'
    },
    {'1': 'cipherTextSalt', '3': 3, '4': 1, '5': 12, '10': 'cipherTextSalt'},
    {'1': 'deviceModel', '3': 4, '4': 1, '5': 9, '10': 'deviceModel'},
    {'1': 'os', '3': 5, '4': 1, '5': 5, '10': 'os'},
    {'1': 'osVersion', '3': 6, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'appVersion', '3': 7, '4': 1, '5': 9, '10': 'appVersion'},
    {'1': 'appBuildNumber', '3': 8, '4': 1, '5': 9, '10': 'appBuildNumber'},
  ],
};

/// Descriptor for `AuthConfirmationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authConfirmationRequestDescriptor = $convert.base64Decode(
    'ChdBdXRoQ29uZmlybWF0aW9uUmVxdWVzdBIwChNjb25maXJtYXRpb25TZXNzaW9uGAEgASgMUh'
    'Njb25maXJtYXRpb25TZXNzaW9uEjAKE2NpcGhlclRleHRTaGFyZWRLZXkYAiABKAxSE2NpcGhl'
    'clRleHRTaGFyZWRLZXkSJgoOY2lwaGVyVGV4dFNhbHQYAyABKAxSDmNpcGhlclRleHRTYWx0Ei'
    'AKC2RldmljZU1vZGVsGAQgASgJUgtkZXZpY2VNb2RlbBIOCgJvcxgFIAEoBVICb3MSHAoJb3NW'
    'ZXJzaW9uGAYgASgJUglvc1ZlcnNpb24SHgoKYXBwVmVyc2lvbhgHIAEoCVIKYXBwVmVyc2lvbh'
    'ImCg5hcHBCdWlsZE51bWJlchgIIAEoCVIOYXBwQnVpbGROdW1iZXI=');

@$core.Deprecated('Use authConfirmationResponseDescriptor instead')
const AuthConfirmationResponse$json = {
  '1': 'AuthConfirmationResponse',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 12, '10': 'sessionID'},
    {'1': 'session', '3': 2, '4': 1, '5': 12, '10': 'session'},
    {
      '1': 'cipherTextSharedKey',
      '3': 3,
      '4': 1,
      '5': 12,
      '10': 'cipherTextSharedKey'
    },
    {'1': 'cipherTextSalt', '3': 4, '4': 1, '5': 12, '10': 'cipherTextSalt'},
    {
      '1': 'signatureSharedKey',
      '3': 5,
      '4': 1,
      '5': 12,
      '10': 'signatureSharedKey'
    },
    {'1': 'signatureSalt', '3': 6, '4': 1, '5': 12, '10': 'signatureSalt'},
    {'1': 'userID', '3': 7, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'phoneNumber', '3': 8, '4': 1, '5': 9, '10': 'phoneNumber'},
    {
      '1': 'createdAt',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `AuthConfirmationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authConfirmationResponseDescriptor = $convert.base64Decode(
    'ChhBdXRoQ29uZmlybWF0aW9uUmVzcG9uc2USHAoJc2Vzc2lvbklEGAEgASgMUglzZXNzaW9uSU'
    'QSGAoHc2Vzc2lvbhgCIAEoDFIHc2Vzc2lvbhIwChNjaXBoZXJUZXh0U2hhcmVkS2V5GAMgASgM'
    'UhNjaXBoZXJUZXh0U2hhcmVkS2V5EiYKDmNpcGhlclRleHRTYWx0GAQgASgMUg5jaXBoZXJUZX'
    'h0U2FsdBIuChJzaWduYXR1cmVTaGFyZWRLZXkYBSABKAxSEnNpZ25hdHVyZVNoYXJlZEtleRIk'
    'Cg1zaWduYXR1cmVTYWx0GAYgASgMUg1zaWduYXR1cmVTYWx0EhYKBnVzZXJJRBgHIAEoDFIGdX'
    'NlcklEEiAKC3Bob25lTnVtYmVyGAggASgJUgtwaG9uZU51bWJlchI4CgljcmVhdGVkQXQYCSAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQ=');
