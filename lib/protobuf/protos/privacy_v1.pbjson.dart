// This is a generated file - do not edit.
//
// Generated from protos/privacy_v1.proto.

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

@$core.Deprecated('Use privacySettingsDescriptor instead')
const PrivacySettings$json = {
  '1': 'PrivacySettings',
  '3': [PrivacySettings_Request$json, PrivacySettings_Response$json],
  '4': [PrivacySettings_Audience$json],
};

@$core.Deprecated('Use privacySettingsDescriptor instead')
const PrivacySettings_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use privacySettingsDescriptor instead')
const PrivacySettings_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'calls', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.PrivacySettings.Audience', '10': 'calls'},
    {'1': 'calls_allow', '3': 2, '4': 3, '5': 12, '10': 'callsAllow'},
    {'1': 'calls_deny', '3': 3, '4': 3, '5': 12, '10': 'callsDeny'},
  ],
};

@$core.Deprecated('Use privacySettingsDescriptor instead')
const PrivacySettings_Audience$json = {
  '1': 'Audience',
  '2': [
    {'1': 'EVERYBODY', '2': 0},
    {'1': 'CONTACTS', '2': 1},
    {'1': 'NOBODY', '2': 2},
  ],
};

/// Descriptor for `PrivacySettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacySettingsDescriptor =
    $convert.base64Decode('Cg9Qcml2YWN5U2V0dGluZ3MaCQoHUmVxdWVzdBqFAQoIUmVzcG9uc2USOQoFY2FsbHMYASABKA'
        '4yIy5pcGVyb24udjEuUHJpdmFjeVNldHRpbmdzLkF1ZGllbmNlUgVjYWxscxIfCgtjYWxsc19h'
        'bGxvdxgCIAMoDFIKY2FsbHNBbGxvdxIdCgpjYWxsc19kZW55GAMgAygMUgljYWxsc0RlbnkiMw'
        'oIQXVkaWVuY2USDQoJRVZFUllCT0RZEAASDAoIQ09OVEFDVFMQARIKCgZOT0JPRFkQAg==');

@$core.Deprecated('Use privacySettingsUpdateDescriptor instead')
const PrivacySettingsUpdate$json = {
  '1': 'PrivacySettingsUpdate',
  '3': [PrivacySettingsUpdate_Request$json, PrivacySettingsUpdate_Response$json],
};

@$core.Deprecated('Use privacySettingsUpdateDescriptor instead')
const PrivacySettingsUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'calls', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.PrivacySettings.Audience', '10': 'calls'},
  ],
};

@$core.Deprecated('Use privacySettingsUpdateDescriptor instead')
const PrivacySettingsUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacySettingsUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacySettingsUpdateDescriptor =
    $convert.base64Decode('ChVQcml2YWN5U2V0dGluZ3NVcGRhdGUaRAoHUmVxdWVzdBI5CgVjYWxscxgBIAEoDjIjLmlwZX'
        'Jvbi52MS5Qcml2YWN5U2V0dGluZ3MuQXVkaWVuY2VSBWNhbGxzGgoKCFJlc3BvbnNl');

@$core.Deprecated('Use privacyCallsAllowUpdateDescriptor instead')
const PrivacyCallsAllowUpdate$json = {
  '1': 'PrivacyCallsAllowUpdate',
  '3': [PrivacyCallsAllowUpdate_Request$json, PrivacyCallsAllowUpdate_Response$json],
};

@$core.Deprecated('Use privacyCallsAllowUpdateDescriptor instead')
const PrivacyCallsAllowUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'user_ids', '3': 1, '4': 3, '5': 12, '10': 'userIds'},
  ],
};

@$core.Deprecated('Use privacyCallsAllowUpdateDescriptor instead')
const PrivacyCallsAllowUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyCallsAllowUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyCallsAllowUpdateDescriptor =
    $convert.base64Decode('ChdQcml2YWN5Q2FsbHNBbGxvd1VwZGF0ZRokCgdSZXF1ZXN0EhkKCHVzZXJfaWRzGAEgAygMUg'
        'd1c2VySWRzGgoKCFJlc3BvbnNl');

@$core.Deprecated('Use privacyCallsDenyUpdateDescriptor instead')
const PrivacyCallsDenyUpdate$json = {
  '1': 'PrivacyCallsDenyUpdate',
  '3': [PrivacyCallsDenyUpdate_Request$json, PrivacyCallsDenyUpdate_Response$json],
};

@$core.Deprecated('Use privacyCallsDenyUpdateDescriptor instead')
const PrivacyCallsDenyUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'user_ids', '3': 1, '4': 3, '5': 12, '10': 'userIds'},
  ],
};

@$core.Deprecated('Use privacyCallsDenyUpdateDescriptor instead')
const PrivacyCallsDenyUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyCallsDenyUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyCallsDenyUpdateDescriptor =
    $convert.base64Decode('ChZQcml2YWN5Q2FsbHNEZW55VXBkYXRlGiQKB1JlcXVlc3QSGQoIdXNlcl9pZHMYASADKAxSB3'
        'VzZXJJZHMaCgoIUmVzcG9uc2U=');
