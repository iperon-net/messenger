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

@$core.Deprecated('Use authCallPasswordDescriptor instead')
const AuthCallPassword$json = {
  '1': 'AuthCallPassword',
  '3': [AuthCallPassword_Request$json, AuthCallPassword_Response$json],
};

@$core.Deprecated('Use authCallPasswordDescriptor instead')
const AuthCallPassword_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'phoneNumber', '3': 1, '4': 1, '5': 9, '10': 'phoneNumber'},
  ],
};

@$core.Deprecated('Use authCallPasswordDescriptor instead')
const AuthCallPassword_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'callPasswordSession', '3': 1, '4': 1, '5': 12, '10': 'callPasswordSession'},
    {'1': 'timeout', '3': 2, '4': 1, '5': 2, '10': 'timeout'},
    {'1': 'confirmationPhoneNumber', '3': 3, '4': 1, '5': 9, '10': 'confirmationPhoneNumber'},
  ],
};

/// Descriptor for `AuthCallPassword`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCallPasswordDescriptor =
    $convert.base64Decode('ChBBdXRoQ2FsbFBhc3N3b3JkGisKB1JlcXVlc3QSIAoLcGhvbmVOdW1iZXIYASABKAlSC3Bob2'
        '5lTnVtYmVyGpABCghSZXNwb25zZRIwChNjYWxsUGFzc3dvcmRTZXNzaW9uGAEgASgMUhNjYWxs'
        'UGFzc3dvcmRTZXNzaW9uEhgKB3RpbWVvdXQYAiABKAJSB3RpbWVvdXQSOAoXY29uZmlybWF0aW'
        '9uUGhvbmVOdW1iZXIYAyABKAlSF2NvbmZpcm1hdGlvblBob25lTnVtYmVy');

@$core.Deprecated('Use authCallPasswordConfirmationDescriptor instead')
const AuthCallPasswordConfirmation$json = {
  '1': 'AuthCallPasswordConfirmation',
  '3': [AuthCallPasswordConfirmation_Request$json, AuthCallPasswordConfirmation_Response$json],
};

@$core.Deprecated('Use authCallPasswordConfirmationDescriptor instead')
const AuthCallPasswordConfirmation_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'callPasswordSession', '3': 1, '4': 1, '5': 12, '10': 'callPasswordSession'},
  ],
};

@$core.Deprecated('Use authCallPasswordConfirmationDescriptor instead')
const AuthCallPasswordConfirmation_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'authCallPasswordStatus', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.AuthCallPasswordStatus', '10': 'authCallPasswordStatus'},
    {'1': 'timer', '3': 2, '4': 1, '5': 3, '9': 0, '10': 'timer', '17': true},
    {'1': 'errorMessage', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'errorMessage', '17': true},
    {'1': 'confirmationSession', '3': 4, '4': 1, '5': 12, '9': 2, '10': 'confirmationSession', '17': true},
    {'1': 'hasTwoStepVerification', '3': 5, '4': 1, '5': 8, '9': 3, '10': 'hasTwoStepVerification', '17': true},
    {'1': 'isBlocked', '3': 6, '4': 1, '5': 8, '9': 4, '10': 'isBlocked', '17': true},
  ],
  '8': [
    {'1': '_timer'},
    {'1': '_errorMessage'},
    {'1': '_confirmationSession'},
    {'1': '_hasTwoStepVerification'},
    {'1': '_isBlocked'},
  ],
};

/// Descriptor for `AuthCallPasswordConfirmation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCallPasswordConfirmationDescriptor =
    $convert.base64Decode('ChxBdXRoQ2FsbFBhc3N3b3JkQ29uZmlybWF0aW9uGjsKB1JlcXVlc3QSMAoTY2FsbFBhc3N3b3'
        'JkU2Vzc2lvbhgBIAEoDFITY2FsbFBhc3N3b3JkU2Vzc2lvbhqcAwoIUmVzcG9uc2USWQoWYXV0'
        'aENhbGxQYXNzd29yZFN0YXR1cxgBIAEoDjIhLmlwZXJvbi52MS5BdXRoQ2FsbFBhc3N3b3JkU3'
        'RhdHVzUhZhdXRoQ2FsbFBhc3N3b3JkU3RhdHVzEhkKBXRpbWVyGAIgASgDSABSBXRpbWVyiAEB'
        'EicKDGVycm9yTWVzc2FnZRgDIAEoCUgBUgxlcnJvck1lc3NhZ2WIAQESNQoTY29uZmlybWF0aW'
        '9uU2Vzc2lvbhgEIAEoDEgCUhNjb25maXJtYXRpb25TZXNzaW9uiAEBEjsKFmhhc1R3b1N0ZXBW'
        'ZXJpZmljYXRpb24YBSABKAhIA1IWaGFzVHdvU3RlcFZlcmlmaWNhdGlvbogBARIhCglpc0Jsb2'
        'NrZWQYBiABKAhIBFIJaXNCbG9ja2VkiAEBQggKBl90aW1lckIPCg1fZXJyb3JNZXNzYWdlQhYK'
        'FF9jb25maXJtYXRpb25TZXNzaW9uQhkKF19oYXNUd29TdGVwVmVyaWZpY2F0aW9uQgwKCl9pc0'
        'Jsb2NrZWQ=');

@$core.Deprecated('Use authModerationApplicationStoreDescriptor instead')
const AuthModerationApplicationStore$json = {
  '1': 'AuthModerationApplicationStore',
  '3': [AuthModerationApplicationStore_Request$json, AuthModerationApplicationStore_Response$json],
};

@$core.Deprecated('Use authModerationApplicationStoreDescriptor instead')
const AuthModerationApplicationStore_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'phoneNumber', '3': 1, '4': 1, '5': 9, '10': 'phoneNumber'},
  ],
};

@$core.Deprecated('Use authModerationApplicationStoreDescriptor instead')
const AuthModerationApplicationStore_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'moderationApplicationStoreSession', '3': 1, '4': 1, '5': 12, '10': 'moderationApplicationStoreSession'},
    {'1': 'phoneNumber', '3': 2, '4': 1, '5': 9, '10': 'phoneNumber'},
  ],
};

/// Descriptor for `AuthModerationApplicationStore`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authModerationApplicationStoreDescriptor =
    $convert.base64Decode('Ch5BdXRoTW9kZXJhdGlvbkFwcGxpY2F0aW9uU3RvcmUaKwoHUmVxdWVzdBIgCgtwaG9uZU51bW'
        'JlchgBIAEoCVILcGhvbmVOdW1iZXIaegoIUmVzcG9uc2USTAohbW9kZXJhdGlvbkFwcGxpY2F0'
        'aW9uU3RvcmVTZXNzaW9uGAEgASgMUiFtb2RlcmF0aW9uQXBwbGljYXRpb25TdG9yZVNlc3Npb2'
        '4SIAoLcGhvbmVOdW1iZXIYAiABKAlSC3Bob25lTnVtYmVy');

@$core.Deprecated('Use authModerationApplicationStoreConfirmationDescriptor instead')
const AuthModerationApplicationStoreConfirmation$json = {
  '1': 'AuthModerationApplicationStoreConfirmation',
  '3': [AuthModerationApplicationStoreConfirmation_Request$json, AuthModerationApplicationStoreConfirmation_Response$json],
};

@$core.Deprecated('Use authModerationApplicationStoreConfirmationDescriptor instead')
const AuthModerationApplicationStoreConfirmation_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'moderationApplicationStoreSession', '3': 1, '4': 1, '5': 12, '10': 'moderationApplicationStoreSession'},
    {'1': 'verificationCode', '3': 2, '4': 1, '5': 9, '10': 'verificationCode'},
  ],
};

@$core.Deprecated('Use authModerationApplicationStoreConfirmationDescriptor instead')
const AuthModerationApplicationStoreConfirmation_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
  ],
};

/// Descriptor for `AuthModerationApplicationStoreConfirmation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authModerationApplicationStoreConfirmationDescriptor =
    $convert.base64Decode('CipBdXRoTW9kZXJhdGlvbkFwcGxpY2F0aW9uU3RvcmVDb25maXJtYXRpb24agwEKB1JlcXVlc3'
        'QSTAohbW9kZXJhdGlvbkFwcGxpY2F0aW9uU3RvcmVTZXNzaW9uGAEgASgMUiFtb2RlcmF0aW9u'
        'QXBwbGljYXRpb25TdG9yZVNlc3Npb24SKgoQdmVyaWZpY2F0aW9uQ29kZRgCIAEoCVIQdmVyaW'
        'ZpY2F0aW9uQ29kZRo8CghSZXNwb25zZRIwChNjb25maXJtYXRpb25TZXNzaW9uGAEgASgMUhNj'
        'b25maXJtYXRpb25TZXNzaW9u');

@$core.Deprecated('Use authConfirmationDescriptor instead')
const AuthConfirmation$json = {
  '1': 'AuthConfirmation',
  '3': [AuthConfirmation_Request$json, AuthConfirmation_Response$json],
};

@$core.Deprecated('Use authConfirmationDescriptor instead')
const AuthConfirmation_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'publicKeySharedKey', '3': 2, '4': 1, '5': 12, '10': 'publicKeySharedKey'},
    {'1': 'publicKeySalt', '3': 3, '4': 1, '5': 12, '10': 'publicKeySalt'},
    {'1': 'deviceModel', '3': 4, '4': 1, '5': 9, '10': 'deviceModel'},
    {'1': 'os', '3': 5, '4': 1, '5': 5, '10': 'os'},
    {'1': 'osVersion', '3': 6, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'appVersion', '3': 7, '4': 1, '5': 9, '10': 'appVersion'},
    {'1': 'appBuildNumber', '3': 8, '4': 1, '5': 9, '10': 'appBuildNumber'},
  ],
};

@$core.Deprecated('Use authConfirmationDescriptor instead')
const AuthConfirmation_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 12, '10': 'sessionID'},
    {'1': 'session', '3': 2, '4': 1, '5': 12, '10': 'session'},
    {'1': 'ciphertextSharedKey', '3': 3, '4': 1, '5': 12, '10': 'ciphertextSharedKey'},
    {'1': 'ciphertextSalt', '3': 4, '4': 1, '5': 12, '10': 'ciphertextSalt'},
    {'1': 'signatureSharedKey', '3': 5, '4': 1, '5': 12, '10': 'signatureSharedKey'},
    {'1': 'signatureSalt', '3': 6, '4': 1, '5': 12, '10': 'signatureSalt'},
    {'1': 'userID', '3': 7, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'phoneNumber', '3': 8, '4': 1, '5': 9, '10': 'phoneNumber'},
  ],
};

/// Descriptor for `AuthConfirmation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authConfirmationDescriptor =
    $convert.base64Decode('ChBBdXRoQ29uZmlybWF0aW9uGqkCCgdSZXF1ZXN0EjAKE2NvbmZpcm1hdGlvblNlc3Npb24YAS'
        'ABKAxSE2NvbmZpcm1hdGlvblNlc3Npb24SLgoScHVibGljS2V5U2hhcmVkS2V5GAIgASgMUhJw'
        'dWJsaWNLZXlTaGFyZWRLZXkSJAoNcHVibGljS2V5U2FsdBgDIAEoDFINcHVibGljS2V5U2FsdB'
        'IgCgtkZXZpY2VNb2RlbBgEIAEoCVILZGV2aWNlTW9kZWwSDgoCb3MYBSABKAVSAm9zEhwKCW9z'
        'VmVyc2lvbhgGIAEoCVIJb3NWZXJzaW9uEh4KCmFwcFZlcnNpb24YByABKAlSCmFwcFZlcnNpb2'
        '4SJgoOYXBwQnVpbGROdW1iZXIYCCABKAlSDmFwcEJ1aWxkTnVtYmVyGqwCCghSZXNwb25zZRIc'
        'CglzZXNzaW9uSUQYASABKAxSCXNlc3Npb25JRBIYCgdzZXNzaW9uGAIgASgMUgdzZXNzaW9uEj'
        'AKE2NpcGhlcnRleHRTaGFyZWRLZXkYAyABKAxSE2NpcGhlcnRleHRTaGFyZWRLZXkSJgoOY2lw'
        'aGVydGV4dFNhbHQYBCABKAxSDmNpcGhlcnRleHRTYWx0Ei4KEnNpZ25hdHVyZVNoYXJlZEtleR'
        'gFIAEoDFISc2lnbmF0dXJlU2hhcmVkS2V5EiQKDXNpZ25hdHVyZVNhbHQYBiABKAxSDXNpZ25h'
        'dHVyZVNhbHQSFgoGdXNlcklEGAcgASgMUgZ1c2VySUQSIAoLcGhvbmVOdW1iZXIYCCABKAlSC3'
        'Bob25lTnVtYmVy');
