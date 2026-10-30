// This is a generated file - do not edit.
//
// Generated from protos/cloud_password_v1.proto.

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

@$core.Deprecated('Use authCloudPasswordStartDescriptor instead')
const AuthCloudPasswordStart$json = {
  '1': 'AuthCloudPasswordStart',
  '3': [AuthCloudPasswordStart_Request$json, AuthCloudPasswordStart_Response$json],
};

@$core.Deprecated('Use authCloudPasswordStartDescriptor instead')
const AuthCloudPasswordStart_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'ke1', '3': 2, '4': 1, '5': 12, '10': 'ke1'},
  ],
};

@$core.Deprecated('Use authCloudPasswordStartDescriptor instead')
const AuthCloudPasswordStart_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'ke2', '3': 1, '4': 1, '5': 12, '10': 'ke2'},
    {'1': 'attemptsLeft', '3': 2, '4': 1, '5': 5, '10': 'attemptsLeft'},
  ],
};

/// Descriptor for `AuthCloudPasswordStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCloudPasswordStartDescriptor =
    $convert.base64Decode('ChZBdXRoQ2xvdWRQYXNzd29yZFN0YXJ0Gk0KB1JlcXVlc3QSMAoTY29uZmlybWF0aW9uU2Vzc2'
        'lvbhgBIAEoDFITY29uZmlybWF0aW9uU2Vzc2lvbhIQCgNrZTEYAiABKAxSA2tlMRpACghSZXNw'
        'b25zZRIQCgNrZTIYASABKAxSA2tlMhIiCgxhdHRlbXB0c0xlZnQYAiABKAVSDGF0dGVtcHRzTG'
        'VmdA==');

@$core.Deprecated('Use authCloudPasswordFinishDescriptor instead')
const AuthCloudPasswordFinish$json = {
  '1': 'AuthCloudPasswordFinish',
  '3': [AuthCloudPasswordFinish_Request$json, AuthCloudPasswordFinish_Response$json],
};

@$core.Deprecated('Use authCloudPasswordFinishDescriptor instead')
const AuthCloudPasswordFinish_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'ke3', '3': 2, '4': 1, '5': 12, '10': 'ke3'},
  ],
};

@$core.Deprecated('Use authCloudPasswordFinishDescriptor instead')
const AuthCloudPasswordFinish_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `AuthCloudPasswordFinish`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCloudPasswordFinishDescriptor =
    $convert.base64Decode('ChdBdXRoQ2xvdWRQYXNzd29yZEZpbmlzaBpNCgdSZXF1ZXN0EjAKE2NvbmZpcm1hdGlvblNlc3'
        'Npb24YASABKAxSE2NvbmZpcm1hdGlvblNlc3Npb24SEAoDa2UzGAIgASgMUgNrZTMaSQoIUmVz'
        'cG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIZCgVlcnJvchgCIAEoCUgAUgVlcnJvco'
        'gBAUIICgZfZXJyb3I=');

@$core.Deprecated('Use authCloudPasswordRecoveryDescriptor instead')
const AuthCloudPasswordRecovery$json = {
  '1': 'AuthCloudPasswordRecovery',
  '3': [AuthCloudPasswordRecovery_Request$json, AuthCloudPasswordRecovery_Response$json],
};

@$core.Deprecated('Use authCloudPasswordRecoveryDescriptor instead')
const AuthCloudPasswordRecovery_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
  ],
};

@$core.Deprecated('Use authCloudPasswordRecoveryDescriptor instead')
const AuthCloudPasswordRecovery_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'maskedEmail', '3': 1, '4': 1, '5': 9, '10': 'maskedEmail'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `AuthCloudPasswordRecovery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCloudPasswordRecoveryDescriptor =
    $convert.base64Decode('ChlBdXRoQ2xvdWRQYXNzd29yZFJlY292ZXJ5GlEKB1JlcXVlc3QSMAoTY29uZmlybWF0aW9uU2'
        'Vzc2lvbhgBIAEoDFITY29uZmlybWF0aW9uU2Vzc2lvbhIUCgVlbWFpbBgCIAEoCVIFZW1haWwa'
        'UQoIUmVzcG9uc2USIAoLbWFza2VkRW1haWwYASABKAlSC21hc2tlZEVtYWlsEhkKBWVycm9yGA'
        'IgASgJSABSBWVycm9yiAEBQggKBl9lcnJvcg==');

@$core.Deprecated('Use authCloudPasswordRecoveryConfirmDescriptor instead')
const AuthCloudPasswordRecoveryConfirm$json = {
  '1': 'AuthCloudPasswordRecoveryConfirm',
  '3': [AuthCloudPasswordRecoveryConfirm_Request$json, AuthCloudPasswordRecoveryConfirm_Response$json],
};

@$core.Deprecated('Use authCloudPasswordRecoveryConfirmDescriptor instead')
const AuthCloudPasswordRecoveryConfirm_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
  ],
  '9': [
    {'1': 3, '2': 4},
  ],
};

@$core.Deprecated('Use authCloudPasswordRecoveryConfirmDescriptor instead')
const AuthCloudPasswordRecoveryConfirm_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `AuthCloudPasswordRecoveryConfirm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCloudPasswordRecoveryConfirmDescriptor =
    $convert.base64Decode('CiBBdXRoQ2xvdWRQYXNzd29yZFJlY292ZXJ5Q29uZmlybRpVCgdSZXF1ZXN0EjAKE2NvbmZpcm'
        '1hdGlvblNlc3Npb24YASABKAxSE2NvbmZpcm1hdGlvblNlc3Npb24SEgoEY29kZRgCIAEoCVIE'
        'Y29kZUoECAMQBBpJCghSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhkKBWVycm'
        '9yGAIgASgJSABSBWVycm9yiAEBQggKBl9lcnJvcg==');

@$core.Deprecated('Use authCloudPasswordRegisterStartDescriptor instead')
const AuthCloudPasswordRegisterStart$json = {
  '1': 'AuthCloudPasswordRegisterStart',
  '3': [AuthCloudPasswordRegisterStart_Request$json, AuthCloudPasswordRegisterStart_Response$json],
};

@$core.Deprecated('Use authCloudPasswordRegisterStartDescriptor instead')
const AuthCloudPasswordRegisterStart_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'registrationRequest', '3': 2, '4': 1, '5': 12, '10': 'registrationRequest'},
  ],
};

@$core.Deprecated('Use authCloudPasswordRegisterStartDescriptor instead')
const AuthCloudPasswordRegisterStart_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'registrationResponse', '3': 1, '4': 1, '5': 12, '10': 'registrationResponse'},
  ],
};

/// Descriptor for `AuthCloudPasswordRegisterStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCloudPasswordRegisterStartDescriptor =
    $convert.base64Decode('Ch5BdXRoQ2xvdWRQYXNzd29yZFJlZ2lzdGVyU3RhcnQabQoHUmVxdWVzdBIwChNjb25maXJtYX'
        'Rpb25TZXNzaW9uGAEgASgMUhNjb25maXJtYXRpb25TZXNzaW9uEjAKE3JlZ2lzdHJhdGlvblJl'
        'cXVlc3QYAiABKAxSE3JlZ2lzdHJhdGlvblJlcXVlc3QaPgoIUmVzcG9uc2USMgoUcmVnaXN0cm'
        'F0aW9uUmVzcG9uc2UYASABKAxSFHJlZ2lzdHJhdGlvblJlc3BvbnNl');

@$core.Deprecated('Use authCloudPasswordRegisterFinishDescriptor instead')
const AuthCloudPasswordRegisterFinish$json = {
  '1': 'AuthCloudPasswordRegisterFinish',
  '3': [AuthCloudPasswordRegisterFinish_Request$json, AuthCloudPasswordRegisterFinish_Response$json],
};

@$core.Deprecated('Use authCloudPasswordRegisterFinishDescriptor instead')
const AuthCloudPasswordRegisterFinish_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'record', '3': 2, '4': 1, '5': 12, '10': 'record'},
  ],
};

@$core.Deprecated('Use authCloudPasswordRegisterFinishDescriptor instead')
const AuthCloudPasswordRegisterFinish_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `AuthCloudPasswordRegisterFinish`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCloudPasswordRegisterFinishDescriptor =
    $convert.base64Decode('Ch9BdXRoQ2xvdWRQYXNzd29yZFJlZ2lzdGVyRmluaXNoGlMKB1JlcXVlc3QSMAoTY29uZmlybW'
        'F0aW9uU2Vzc2lvbhgBIAEoDFITY29uZmlybWF0aW9uU2Vzc2lvbhIWCgZyZWNvcmQYAiABKAxS'
        'BnJlY29yZBpJCghSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhkKBWVycm9yGA'
        'IgASgJSABSBWVycm9yiAEBQggKBl9lcnJvcg==');

@$core.Deprecated('Use cloudPasswordInfoDescriptor instead')
const CloudPasswordInfo$json = {
  '1': 'CloudPasswordInfo',
  '3': [CloudPasswordInfo_Request$json, CloudPasswordInfo_Response$json],
};

@$core.Deprecated('Use cloudPasswordInfoDescriptor instead')
const CloudPasswordInfo_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use cloudPasswordInfoDescriptor instead')
const CloudPasswordInfo_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'isEnabled', '3': 1, '4': 1, '5': 8, '10': 'isEnabled'},
    {'1': 'maskedEmail', '3': 2, '4': 1, '5': 9, '10': 'maskedEmail'},
    {'1': 'isEmailVerified', '3': 3, '4': 1, '5': 8, '10': 'isEmailVerified'},
  ],
};

/// Descriptor for `CloudPasswordInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordInfoDescriptor =
    $convert.base64Decode('ChFDbG91ZFBhc3N3b3JkSW5mbxoJCgdSZXF1ZXN0GnQKCFJlc3BvbnNlEhwKCWlzRW5hYmxlZB'
        'gBIAEoCFIJaXNFbmFibGVkEiAKC21hc2tlZEVtYWlsGAIgASgJUgttYXNrZWRFbWFpbBIoCg9p'
        'c0VtYWlsVmVyaWZpZWQYAyABKAhSD2lzRW1haWxWZXJpZmllZA==');

@$core.Deprecated('Use cloudPasswordAuthStartDescriptor instead')
const CloudPasswordAuthStart$json = {
  '1': 'CloudPasswordAuthStart',
  '3': [CloudPasswordAuthStart_Request$json, CloudPasswordAuthStart_Response$json],
};

@$core.Deprecated('Use cloudPasswordAuthStartDescriptor instead')
const CloudPasswordAuthStart_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'ke1', '3': 1, '4': 1, '5': 12, '10': 'ke1'},
  ],
};

@$core.Deprecated('Use cloudPasswordAuthStartDescriptor instead')
const CloudPasswordAuthStart_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'ke2', '3': 1, '4': 1, '5': 12, '10': 'ke2'},
  ],
};

/// Descriptor for `CloudPasswordAuthStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordAuthStartDescriptor =
    $convert.base64Decode('ChZDbG91ZFBhc3N3b3JkQXV0aFN0YXJ0GhsKB1JlcXVlc3QSEAoDa2UxGAEgASgMUgNrZTEaHA'
        'oIUmVzcG9uc2USEAoDa2UyGAEgASgMUgNrZTI=');

@$core.Deprecated('Use cloudPasswordAuthFinishDescriptor instead')
const CloudPasswordAuthFinish$json = {
  '1': 'CloudPasswordAuthFinish',
  '3': [CloudPasswordAuthFinish_Request$json, CloudPasswordAuthFinish_Response$json],
};

@$core.Deprecated('Use cloudPasswordAuthFinishDescriptor instead')
const CloudPasswordAuthFinish_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'ke3', '3': 1, '4': 1, '5': 12, '10': 'ke3'},
  ],
};

@$core.Deprecated('Use cloudPasswordAuthFinishDescriptor instead')
const CloudPasswordAuthFinish_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 12, '10': 'token'},
  ],
};

/// Descriptor for `CloudPasswordAuthFinish`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordAuthFinishDescriptor =
    $convert.base64Decode('ChdDbG91ZFBhc3N3b3JkQXV0aEZpbmlzaBobCgdSZXF1ZXN0EhAKA2tlMxgBIAEoDFIDa2UzGi'
        'AKCFJlc3BvbnNlEhQKBXRva2VuGAEgASgMUgV0b2tlbg==');

@$core.Deprecated('Use cloudPasswordRegisterStartDescriptor instead')
const CloudPasswordRegisterStart$json = {
  '1': 'CloudPasswordRegisterStart',
  '3': [CloudPasswordRegisterStart_Request$json, CloudPasswordRegisterStart_Response$json],
};

@$core.Deprecated('Use cloudPasswordRegisterStartDescriptor instead')
const CloudPasswordRegisterStart_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 12, '10': 'token'},
    {'1': 'registrationRequest', '3': 2, '4': 1, '5': 12, '10': 'registrationRequest'},
  ],
};

@$core.Deprecated('Use cloudPasswordRegisterStartDescriptor instead')
const CloudPasswordRegisterStart_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'registrationResponse', '3': 1, '4': 1, '5': 12, '10': 'registrationResponse'},
  ],
};

/// Descriptor for `CloudPasswordRegisterStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordRegisterStartDescriptor =
    $convert.base64Decode('ChpDbG91ZFBhc3N3b3JkUmVnaXN0ZXJTdGFydBpRCgdSZXF1ZXN0EhQKBXRva2VuGAEgASgMUg'
        'V0b2tlbhIwChNyZWdpc3RyYXRpb25SZXF1ZXN0GAIgASgMUhNyZWdpc3RyYXRpb25SZXF1ZXN0'
        'Gj4KCFJlc3BvbnNlEjIKFHJlZ2lzdHJhdGlvblJlc3BvbnNlGAEgASgMUhRyZWdpc3RyYXRpb2'
        '5SZXNwb25zZQ==');

@$core.Deprecated('Use cloudPasswordRegisterFinishDescriptor instead')
const CloudPasswordRegisterFinish$json = {
  '1': 'CloudPasswordRegisterFinish',
  '3': [CloudPasswordRegisterFinish_Request$json, CloudPasswordRegisterFinish_Response$json],
};

@$core.Deprecated('Use cloudPasswordRegisterFinishDescriptor instead')
const CloudPasswordRegisterFinish_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 12, '10': 'token'},
    {'1': 'record', '3': 2, '4': 1, '5': 12, '10': 'record'},
  ],
};

@$core.Deprecated('Use cloudPasswordRegisterFinishDescriptor instead')
const CloudPasswordRegisterFinish_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `CloudPasswordRegisterFinish`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordRegisterFinishDescriptor =
    $convert.base64Decode('ChtDbG91ZFBhc3N3b3JkUmVnaXN0ZXJGaW5pc2gaNwoHUmVxdWVzdBIUCgV0b2tlbhgBIAEoDF'
        'IFdG9rZW4SFgoGcmVjb3JkGAIgASgMUgZyZWNvcmQaSQoIUmVzcG9uc2USGAoHc3VjY2VzcxgB'
        'IAEoCFIHc3VjY2VzcxIZCgVlcnJvchgCIAEoCUgAUgVlcnJvcogBAUIICgZfZXJyb3I=');

@$core.Deprecated('Use cloudPasswordDisableDescriptor instead')
const CloudPasswordDisable$json = {
  '1': 'CloudPasswordDisable',
  '3': [CloudPasswordDisable_Request$json, CloudPasswordDisable_Response$json],
};

@$core.Deprecated('Use cloudPasswordDisableDescriptor instead')
const CloudPasswordDisable_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'token', '3': 2, '4': 1, '5': 12, '10': 'token'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

@$core.Deprecated('Use cloudPasswordDisableDescriptor instead')
const CloudPasswordDisable_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `CloudPasswordDisable`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordDisableDescriptor =
    $convert.base64Decode('ChRDbG91ZFBhc3N3b3JkRGlzYWJsZRolCgdSZXF1ZXN0EhQKBXRva2VuGAIgASgMUgV0b2tlbk'
        'oECAEQAhpJCghSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhkKBWVycm9yGAIg'
        'ASgJSABSBWVycm9yiAEBQggKBl9lcnJvcg==');

@$core.Deprecated('Use cloudPasswordEmailSetDescriptor instead')
const CloudPasswordEmailSet$json = {
  '1': 'CloudPasswordEmailSet',
  '3': [CloudPasswordEmailSet_Request$json, CloudPasswordEmailSet_Response$json],
};

@$core.Deprecated('Use cloudPasswordEmailSetDescriptor instead')
const CloudPasswordEmailSet_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'token', '3': 3, '4': 1, '5': 12, '10': 'token'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

@$core.Deprecated('Use cloudPasswordEmailSetDescriptor instead')
const CloudPasswordEmailSet_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `CloudPasswordEmailSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordEmailSetDescriptor =
    $convert.base64Decode('ChVDbG91ZFBhc3N3b3JkRW1haWxTZXQaOwoHUmVxdWVzdBIUCgVlbWFpbBgCIAEoCVIFZW1haW'
        'wSFAoFdG9rZW4YAyABKAxSBXRva2VuSgQIARACGkkKCFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASAB'
        'KAhSB3N1Y2Nlc3MSGQoFZXJyb3IYAiABKAlIAFIFZXJyb3KIAQFCCAoGX2Vycm9y');

@$core.Deprecated('Use cloudPasswordEmailVerifyDescriptor instead')
const CloudPasswordEmailVerify$json = {
  '1': 'CloudPasswordEmailVerify',
  '3': [CloudPasswordEmailVerify_Request$json, CloudPasswordEmailVerify_Response$json],
};

@$core.Deprecated('Use cloudPasswordEmailVerifyDescriptor instead')
const CloudPasswordEmailVerify_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

@$core.Deprecated('Use cloudPasswordEmailVerifyDescriptor instead')
const CloudPasswordEmailVerify_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `CloudPasswordEmailVerify`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordEmailVerifyDescriptor =
    $convert.base64Decode('ChhDbG91ZFBhc3N3b3JkRW1haWxWZXJpZnkaHQoHUmVxdWVzdBISCgRjb2RlGAEgASgJUgRjb2'
        'RlGkkKCFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGQoFZXJyb3IYAiABKAlI'
        'AFIFZXJyb3KIAQFCCAoGX2Vycm9y');

@$core.Deprecated('Use cloudPasswordRecoverySendDescriptor instead')
const CloudPasswordRecoverySend$json = {
  '1': 'CloudPasswordRecoverySend',
  '3': [CloudPasswordRecoverySend_Request$json, CloudPasswordRecoverySend_Response$json],
};

@$core.Deprecated('Use cloudPasswordRecoverySendDescriptor instead')
const CloudPasswordRecoverySend_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use cloudPasswordRecoverySendDescriptor instead')
const CloudPasswordRecoverySend_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'maskedEmail', '3': 1, '4': 1, '5': 9, '10': 'maskedEmail'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `CloudPasswordRecoverySend`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordRecoverySendDescriptor =
    $convert.base64Decode('ChlDbG91ZFBhc3N3b3JkUmVjb3ZlcnlTZW5kGgkKB1JlcXVlc3QaUQoIUmVzcG9uc2USIAoLbW'
        'Fza2VkRW1haWwYASABKAlSC21hc2tlZEVtYWlsEhkKBWVycm9yGAIgASgJSABSBWVycm9yiAEB'
        'QggKBl9lcnJvcg==');

@$core.Deprecated('Use cloudPasswordResetDescriptor instead')
const CloudPasswordReset$json = {
  '1': 'CloudPasswordReset',
  '3': [CloudPasswordReset_Request$json, CloudPasswordReset_Response$json],
};

@$core.Deprecated('Use cloudPasswordResetDescriptor instead')
const CloudPasswordReset_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
  '9': [
    {'1': 2, '2': 3},
  ],
};

@$core.Deprecated('Use cloudPasswordResetDescriptor instead')
const CloudPasswordReset_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
    {'1': 'token', '3': 3, '4': 1, '5': 12, '10': 'token'},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `CloudPasswordReset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordResetDescriptor =
    $convert.base64Decode('ChJDbG91ZFBhc3N3b3JkUmVzZXQaIwoHUmVxdWVzdBISCgRjb2RlGAEgASgJUgRjb2RlSgQIAh'
        'ADGl8KCFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGQoFZXJyb3IYAiABKAlI'
        'AFIFZXJyb3KIAQESFAoFdG9rZW4YAyABKAxSBXRva2VuQggKBl9lcnJvcg==');
