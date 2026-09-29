// This is a generated file - do not edit.
//
// Generated from protos/passkey_v1.proto.

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

@$core.Deprecated('Use passkeyRegisterBeginDescriptor instead')
const PasskeyRegisterBegin$json = {
  '1': 'PasskeyRegisterBegin',
  '3': [PasskeyRegisterBegin_Request$json, PasskeyRegisterBegin_Response$json],
};

@$core.Deprecated('Use passkeyRegisterBeginDescriptor instead')
const PasskeyRegisterBegin_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use passkeyRegisterBeginDescriptor instead')
const PasskeyRegisterBegin_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'publicKey', '3': 1, '4': 1, '5': 12, '10': 'publicKey'},
  ],
};

/// Descriptor for `PasskeyRegisterBegin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyRegisterBeginDescriptor =
    $convert.base64Decode('ChRQYXNza2V5UmVnaXN0ZXJCZWdpbhoJCgdSZXF1ZXN0GigKCFJlc3BvbnNlEhwKCXB1YmxpY0'
        'tleRgBIAEoDFIJcHVibGljS2V5');

@$core.Deprecated('Use passkeyRegisterFinishDescriptor instead')
const PasskeyRegisterFinish$json = {
  '1': 'PasskeyRegisterFinish',
  '3': [PasskeyRegisterFinish_Request$json, PasskeyRegisterFinish_Response$json],
};

@$core.Deprecated('Use passkeyRegisterFinishDescriptor instead')
const PasskeyRegisterFinish_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'credential', '3': 1, '4': 1, '5': 12, '10': 'credential'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
  ],
};

@$core.Deprecated('Use passkeyRegisterFinishDescriptor instead')
const PasskeyRegisterFinish_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'credential', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.PasskeyCredential', '10': 'credential'},
  ],
};

/// Descriptor for `PasskeyRegisterFinish`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyRegisterFinishDescriptor =
    $convert.base64Decode('ChVQYXNza2V5UmVnaXN0ZXJGaW5pc2gaPwoHUmVxdWVzdBIeCgpjcmVkZW50aWFsGAEgASgMUg'
        'pjcmVkZW50aWFsEhQKBWxhYmVsGAIgASgJUgVsYWJlbBpICghSZXNwb25zZRI8CgpjcmVkZW50'
        'aWFsGAEgASgLMhwuaXBlcm9uLnYxLlBhc3NrZXlDcmVkZW50aWFsUgpjcmVkZW50aWFs');

@$core.Deprecated('Use passkeyListDescriptor instead')
const PasskeyList$json = {
  '1': 'PasskeyList',
  '3': [PasskeyList_Request$json, PasskeyList_Response$json],
};

@$core.Deprecated('Use passkeyListDescriptor instead')
const PasskeyList_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use passkeyListDescriptor instead')
const PasskeyList_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'credentials', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.PasskeyCredential', '10': 'credentials'},
  ],
};

/// Descriptor for `PasskeyList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyListDescriptor =
    $convert.base64Decode('CgtQYXNza2V5TGlzdBoJCgdSZXF1ZXN0GkoKCFJlc3BvbnNlEj4KC2NyZWRlbnRpYWxzGAEgAy'
        'gLMhwuaXBlcm9uLnYxLlBhc3NrZXlDcmVkZW50aWFsUgtjcmVkZW50aWFscw==');

@$core.Deprecated('Use passkeyDeleteDescriptor instead')
const PasskeyDelete$json = {
  '1': 'PasskeyDelete',
  '3': [PasskeyDelete_Request$json, PasskeyDelete_Response$json],
};

@$core.Deprecated('Use passkeyDeleteDescriptor instead')
const PasskeyDelete_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'credentialId', '3': 1, '4': 1, '5': 12, '10': 'credentialId'},
  ],
};

@$core.Deprecated('Use passkeyDeleteDescriptor instead')
const PasskeyDelete_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `PasskeyDelete`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyDeleteDescriptor =
    $convert.base64Decode('Cg1QYXNza2V5RGVsZXRlGi0KB1JlcXVlc3QSIgoMY3JlZGVudGlhbElkGAEgASgMUgxjcmVkZW'
        '50aWFsSWQaJAoIUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use passkeyCredentialDescriptor instead')
const PasskeyCredential$json = {
  '1': 'PasskeyCredential',
  '2': [
    {'1': 'credentialId', '3': 1, '4': 1, '5': 12, '10': 'credentialId'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'aaguid', '3': 3, '4': 1, '5': 12, '10': 'aaguid'},
    {'1': 'createdAt', '3': 4, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'lastUsedAt', '3': 5, '4': 1, '5': 3, '10': 'lastUsedAt'},
  ],
};

/// Descriptor for `PasskeyCredential`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyCredentialDescriptor =
    $convert.base64Decode('ChFQYXNza2V5Q3JlZGVudGlhbBIiCgxjcmVkZW50aWFsSWQYASABKAxSDGNyZWRlbnRpYWxJZB'
        'IUCgVsYWJlbBgCIAEoCVIFbGFiZWwSFgoGYWFndWlkGAMgASgMUgZhYWd1aWQSHAoJY3JlYXRl'
        'ZEF0GAQgASgDUgljcmVhdGVkQXQSHgoKbGFzdFVzZWRBdBgFIAEoA1IKbGFzdFVzZWRBdA==');

@$core.Deprecated('Use passkeyLoginBeginDescriptor instead')
const PasskeyLoginBegin$json = {
  '1': 'PasskeyLoginBegin',
  '3': [PasskeyLoginBegin_Request$json, PasskeyLoginBegin_Response$json],
};

@$core.Deprecated('Use passkeyLoginBeginDescriptor instead')
const PasskeyLoginBegin_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use passkeyLoginBeginDescriptor instead')
const PasskeyLoginBegin_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'loginSession', '3': 1, '4': 1, '5': 12, '10': 'loginSession'},
    {'1': 'publicKey', '3': 2, '4': 1, '5': 12, '10': 'publicKey'},
  ],
};

/// Descriptor for `PasskeyLoginBegin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyLoginBeginDescriptor =
    $convert.base64Decode('ChFQYXNza2V5TG9naW5CZWdpbhoJCgdSZXF1ZXN0GkwKCFJlc3BvbnNlEiIKDGxvZ2luU2Vzc2'
        'lvbhgBIAEoDFIMbG9naW5TZXNzaW9uEhwKCXB1YmxpY0tleRgCIAEoDFIJcHVibGljS2V5');

@$core.Deprecated('Use passkeyLoginFinishDescriptor instead')
const PasskeyLoginFinish$json = {
  '1': 'PasskeyLoginFinish',
  '3': [PasskeyLoginFinish_Request$json, PasskeyLoginFinish_Response$json],
};

@$core.Deprecated('Use passkeyLoginFinishDescriptor instead')
const PasskeyLoginFinish_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'loginSession', '3': 1, '4': 1, '5': 12, '10': 'loginSession'},
    {'1': 'credential', '3': 2, '4': 1, '5': 12, '10': 'credential'},
  ],
};

@$core.Deprecated('Use passkeyLoginFinishDescriptor instead')
const PasskeyLoginFinish_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'confirmationSession', '3': 1, '4': 1, '5': 12, '10': 'confirmationSession'},
    {'1': 'hasTwoStepVerification', '3': 2, '4': 1, '5': 8, '10': 'hasTwoStepVerification'},
  ],
};

/// Descriptor for `PasskeyLoginFinish`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyLoginFinishDescriptor =
    $convert.base64Decode('ChJQYXNza2V5TG9naW5GaW5pc2gaTQoHUmVxdWVzdBIiCgxsb2dpblNlc3Npb24YASABKAxSDG'
        'xvZ2luU2Vzc2lvbhIeCgpjcmVkZW50aWFsGAIgASgMUgpjcmVkZW50aWFsGnQKCFJlc3BvbnNl'
        'EjAKE2NvbmZpcm1hdGlvblNlc3Npb24YASABKAxSE2NvbmZpcm1hdGlvblNlc3Npb24SNgoWaG'
        'FzVHdvU3RlcFZlcmlmaWNhdGlvbhgCIAEoCFIWaGFzVHdvU3RlcFZlcmlmaWNhdGlvbg==');
