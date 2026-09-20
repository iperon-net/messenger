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
    {'1': 'birthday', '3': 4, '4': 1, '5': 14, '6': '.iperon.v1.PrivacySettings.Audience', '10': 'birthday'},
    {'1': 'birthday_allow', '3': 5, '4': 3, '5': 12, '10': 'birthdayAllow'},
    {'1': 'birthday_deny', '3': 6, '4': 3, '5': 12, '10': 'birthdayDeny'},
    {'1': 'hide_birth_year', '3': 7, '4': 1, '5': 8, '10': 'hideBirthYear'},
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
    $convert.base64Decode('Cg9Qcml2YWN5U2V0dGluZ3MaCQoHUmVxdWVzdBq6AgoIUmVzcG9uc2USOQoFY2FsbHMYASABKA'
        '4yIy5pcGVyb24udjEuUHJpdmFjeVNldHRpbmdzLkF1ZGllbmNlUgVjYWxscxIfCgtjYWxsc19h'
        'bGxvdxgCIAMoDFIKY2FsbHNBbGxvdxIdCgpjYWxsc19kZW55GAMgAygMUgljYWxsc0RlbnkSPw'
        'oIYmlydGhkYXkYBCABKA4yIy5pcGVyb24udjEuUHJpdmFjeVNldHRpbmdzLkF1ZGllbmNlUghi'
        'aXJ0aGRheRIlCg5iaXJ0aGRheV9hbGxvdxgFIAMoDFINYmlydGhkYXlBbGxvdxIjCg1iaXJ0aG'
        'RheV9kZW55GAYgAygMUgxiaXJ0aGRheURlbnkSJgoPaGlkZV9iaXJ0aF95ZWFyGAcgASgIUg1o'
        'aWRlQmlydGhZZWFyIjMKCEF1ZGllbmNlEg0KCUVWRVJZQk9EWRAAEgwKCENPTlRBQ1RTEAESCg'
        'oGTk9CT0RZEAI=');

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

@$core.Deprecated('Use privacyBirthdayUpdateDescriptor instead')
const PrivacyBirthdayUpdate$json = {
  '1': 'PrivacyBirthdayUpdate',
  '3': [PrivacyBirthdayUpdate_Request$json, PrivacyBirthdayUpdate_Response$json],
};

@$core.Deprecated('Use privacyBirthdayUpdateDescriptor instead')
const PrivacyBirthdayUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'birthday', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.PrivacySettings.Audience', '10': 'birthday'},
  ],
};

@$core.Deprecated('Use privacyBirthdayUpdateDescriptor instead')
const PrivacyBirthdayUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyBirthdayUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyBirthdayUpdateDescriptor =
    $convert.base64Decode('ChVQcml2YWN5QmlydGhkYXlVcGRhdGUaSgoHUmVxdWVzdBI/CghiaXJ0aGRheRgBIAEoDjIjLm'
        'lwZXJvbi52MS5Qcml2YWN5U2V0dGluZ3MuQXVkaWVuY2VSCGJpcnRoZGF5GgoKCFJlc3BvbnNl');

@$core.Deprecated('Use privacyBirthdayAllowUpdateDescriptor instead')
const PrivacyBirthdayAllowUpdate$json = {
  '1': 'PrivacyBirthdayAllowUpdate',
  '3': [PrivacyBirthdayAllowUpdate_Request$json, PrivacyBirthdayAllowUpdate_Response$json],
};

@$core.Deprecated('Use privacyBirthdayAllowUpdateDescriptor instead')
const PrivacyBirthdayAllowUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'user_ids', '3': 1, '4': 3, '5': 12, '10': 'userIds'},
  ],
};

@$core.Deprecated('Use privacyBirthdayAllowUpdateDescriptor instead')
const PrivacyBirthdayAllowUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyBirthdayAllowUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyBirthdayAllowUpdateDescriptor =
    $convert.base64Decode('ChpQcml2YWN5QmlydGhkYXlBbGxvd1VwZGF0ZRokCgdSZXF1ZXN0EhkKCHVzZXJfaWRzGAEgAy'
        'gMUgd1c2VySWRzGgoKCFJlc3BvbnNl');

@$core.Deprecated('Use privacyBirthdayDenyUpdateDescriptor instead')
const PrivacyBirthdayDenyUpdate$json = {
  '1': 'PrivacyBirthdayDenyUpdate',
  '3': [PrivacyBirthdayDenyUpdate_Request$json, PrivacyBirthdayDenyUpdate_Response$json],
};

@$core.Deprecated('Use privacyBirthdayDenyUpdateDescriptor instead')
const PrivacyBirthdayDenyUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'user_ids', '3': 1, '4': 3, '5': 12, '10': 'userIds'},
  ],
};

@$core.Deprecated('Use privacyBirthdayDenyUpdateDescriptor instead')
const PrivacyBirthdayDenyUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyBirthdayDenyUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyBirthdayDenyUpdateDescriptor =
    $convert.base64Decode('ChlQcml2YWN5QmlydGhkYXlEZW55VXBkYXRlGiQKB1JlcXVlc3QSGQoIdXNlcl9pZHMYASADKA'
        'xSB3VzZXJJZHMaCgoIUmVzcG9uc2U=');

@$core.Deprecated('Use privacyHideBirthYearUpdateDescriptor instead')
const PrivacyHideBirthYearUpdate$json = {
  '1': 'PrivacyHideBirthYearUpdate',
  '3': [PrivacyHideBirthYearUpdate_Request$json, PrivacyHideBirthYearUpdate_Response$json],
};

@$core.Deprecated('Use privacyHideBirthYearUpdateDescriptor instead')
const PrivacyHideBirthYearUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'hide', '3': 1, '4': 1, '5': 8, '10': 'hide'},
  ],
};

@$core.Deprecated('Use privacyHideBirthYearUpdateDescriptor instead')
const PrivacyHideBirthYearUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyHideBirthYearUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyHideBirthYearUpdateDescriptor =
    $convert.base64Decode('ChpQcml2YWN5SGlkZUJpcnRoWWVhclVwZGF0ZRodCgdSZXF1ZXN0EhIKBGhpZGUYASABKAhSBG'
        'hpZGUaCgoIUmVzcG9uc2U=');
