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

@$core.Deprecated('Use authCloudPasswordDescriptor instead')
const AuthCloudPassword$json = {
  '1': 'AuthCloudPassword',
  '3': [AuthCloudPassword_Request$json, AuthCloudPassword_Response$json],
};

@$core.Deprecated('Use authCloudPasswordDescriptor instead')
const AuthCloudPassword_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'pwHash', '3': 2, '4': 1, '5': 12, '10': 'pwHash'},
  ],
};

@$core.Deprecated('Use authCloudPasswordDescriptor instead')
const AuthCloudPassword_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
    {'1': 'attemptsLeft', '3': 3, '4': 1, '5': 5, '9': 1, '10': 'attemptsLeft', '17': true},
  ],
  '8': [
    {'1': '_error'},
    {'1': '_attemptsLeft'},
  ],
};

/// Descriptor for `AuthCloudPassword`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authCloudPasswordDescriptor =
    $convert.base64Decode('ChFBdXRoQ2xvdWRQYXNzd29yZBpTCgdSZXF1ZXN0EjAKE2NvbmZpcm1hdGlvblNlc3Npb24YAS'
        'ABKAxSE2NvbmZpcm1hdGlvblNlc3Npb24SFgoGcHdIYXNoGAIgASgMUgZwd0hhc2gagwEKCFJl'
        'c3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGQoFZXJyb3IYAiABKAlIAFIFZXJyb3'
        'KIAQESJwoMYXR0ZW1wdHNMZWZ0GAMgASgFSAFSDGF0dGVtcHRzTGVmdIgBAUIICgZfZXJyb3JC'
        'DwoNX2F0dGVtcHRzTGVmdA==');

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
    {'1': 'newPwHash', '3': 3, '4': 1, '5': 12, '10': 'newPwHash'},
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
    $convert.base64Decode('CiBBdXRoQ2xvdWRQYXNzd29yZFJlY292ZXJ5Q29uZmlybRptCgdSZXF1ZXN0EjAKE2NvbmZpcm'
        '1hdGlvblNlc3Npb24YASABKAxSE2NvbmZpcm1hdGlvblNlc3Npb24SEgoEY29kZRgCIAEoCVIE'
        'Y29kZRIcCgluZXdQd0hhc2gYAyABKAxSCW5ld1B3SGFzaBpJCghSZXNwb25zZRIYCgdzdWNjZX'
        'NzGAEgASgIUgdzdWNjZXNzEhkKBWVycm9yGAIgASgJSABSBWVycm9yiAEBQggKBl9lcnJvcg==');

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

@$core.Deprecated('Use cloudPasswordSetDescriptor instead')
const CloudPasswordSet$json = {
  '1': 'CloudPasswordSet',
  '3': [CloudPasswordSet_Request$json, CloudPasswordSet_Response$json],
};

@$core.Deprecated('Use cloudPasswordSetDescriptor instead')
const CloudPasswordSet_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'currentPwHash', '3': 1, '4': 1, '5': 12, '10': 'currentPwHash'},
    {'1': 'newPwHash', '3': 2, '4': 1, '5': 12, '10': 'newPwHash'},
  ],
};

@$core.Deprecated('Use cloudPasswordSetDescriptor instead')
const CloudPasswordSet_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `CloudPasswordSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordSetDescriptor =
    $convert.base64Decode('ChBDbG91ZFBhc3N3b3JkU2V0Gk0KB1JlcXVlc3QSJAoNY3VycmVudFB3SGFzaBgBIAEoDFINY3'
        'VycmVudFB3SGFzaBIcCgluZXdQd0hhc2gYAiABKAxSCW5ld1B3SGFzaBpJCghSZXNwb25zZRIY'
        'CgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhkKBWVycm9yGAIgASgJSABSBWVycm9yiAEBQggKBl'
        '9lcnJvcg==');

@$core.Deprecated('Use cloudPasswordDisableDescriptor instead')
const CloudPasswordDisable$json = {
  '1': 'CloudPasswordDisable',
  '3': [CloudPasswordDisable_Request$json, CloudPasswordDisable_Response$json],
};

@$core.Deprecated('Use cloudPasswordDisableDescriptor instead')
const CloudPasswordDisable_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'currentPwHash', '3': 1, '4': 1, '5': 12, '10': 'currentPwHash'},
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
    $convert.base64Decode('ChRDbG91ZFBhc3N3b3JkRGlzYWJsZRovCgdSZXF1ZXN0EiQKDWN1cnJlbnRQd0hhc2gYASABKA'
        'xSDWN1cnJlbnRQd0hhc2gaSQoIUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIZ'
        'CgVlcnJvchgCIAEoCUgAUgVlcnJvcogBAUIICgZfZXJyb3I=');

@$core.Deprecated('Use cloudPasswordEmailSetDescriptor instead')
const CloudPasswordEmailSet$json = {
  '1': 'CloudPasswordEmailSet',
  '3': [CloudPasswordEmailSet_Request$json, CloudPasswordEmailSet_Response$json],
};

@$core.Deprecated('Use cloudPasswordEmailSetDescriptor instead')
const CloudPasswordEmailSet_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'currentPwHash', '3': 1, '4': 1, '5': 12, '10': 'currentPwHash'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
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
    $convert.base64Decode('ChVDbG91ZFBhc3N3b3JkRW1haWxTZXQaRQoHUmVxdWVzdBIkCg1jdXJyZW50UHdIYXNoGAEgAS'
        'gMUg1jdXJyZW50UHdIYXNoEhQKBWVtYWlsGAIgASgJUgVlbWFpbBpJCghSZXNwb25zZRIYCgdz'
        'dWNjZXNzGAEgASgIUgdzdWNjZXNzEhkKBWVycm9yGAIgASgJSABSBWVycm9yiAEBQggKBl9lcn'
        'Jvcg==');

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

@$core.Deprecated('Use cloudPasswordVerifyDescriptor instead')
const CloudPasswordVerify$json = {
  '1': 'CloudPasswordVerify',
  '3': [CloudPasswordVerify_Request$json, CloudPasswordVerify_Response$json],
};

@$core.Deprecated('Use cloudPasswordVerifyDescriptor instead')
const CloudPasswordVerify_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'pwHash', '3': 1, '4': 1, '5': 12, '10': 'pwHash'},
  ],
};

@$core.Deprecated('Use cloudPasswordVerifyDescriptor instead')
const CloudPasswordVerify_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `CloudPasswordVerify`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordVerifyDescriptor =
    $convert.base64Decode('ChNDbG91ZFBhc3N3b3JkVmVyaWZ5GiEKB1JlcXVlc3QSFgoGcHdIYXNoGAEgASgMUgZwd0hhc2'
        'gaSQoIUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIZCgVlcnJvchgCIAEoCUgA'
        'UgVlcnJvcogBAUIICgZfZXJyb3I=');

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
    {'1': 'newPwHash', '3': 2, '4': 1, '5': 12, '10': 'newPwHash'},
  ],
};

@$core.Deprecated('Use cloudPasswordResetDescriptor instead')
const CloudPasswordReset_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `CloudPasswordReset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudPasswordResetDescriptor =
    $convert.base64Decode('ChJDbG91ZFBhc3N3b3JkUmVzZXQaOwoHUmVxdWVzdBISCgRjb2RlGAEgASgJUgRjb2RlEhwKCW'
        '5ld1B3SGFzaBgCIAEoDFIJbmV3UHdIYXNoGkkKCFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhS'
        'B3N1Y2Nlc3MSGQoFZXJyb3IYAiABKAlIAFIFZXJyb3KIAQFCCAoGX2Vycm9y');
