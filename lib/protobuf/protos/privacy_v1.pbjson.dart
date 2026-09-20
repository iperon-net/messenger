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
    {'1': 'about_me', '3': 8, '4': 1, '5': 14, '6': '.iperon.v1.PrivacySettings.Audience', '10': 'aboutMe'},
    {'1': 'about_me_allow', '3': 9, '4': 3, '5': 12, '10': 'aboutMeAllow'},
    {'1': 'about_me_deny', '3': 10, '4': 3, '5': 12, '10': 'aboutMeDeny'},
    {'1': 'last_seen', '3': 11, '4': 1, '5': 14, '6': '.iperon.v1.PrivacySettings.Audience', '10': 'lastSeen'},
    {'1': 'last_seen_allow', '3': 12, '4': 3, '5': 12, '10': 'lastSeenAllow'},
    {'1': 'last_seen_deny', '3': 13, '4': 3, '5': 12, '10': 'lastSeenDeny'},
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
    $convert.base64Decode('Cg9Qcml2YWN5U2V0dGluZ3MaCQoHUmVxdWVzdBrUBAoIUmVzcG9uc2USOQoFY2FsbHMYASABKA'
        '4yIy5pcGVyb24udjEuUHJpdmFjeVNldHRpbmdzLkF1ZGllbmNlUgVjYWxscxIfCgtjYWxsc19h'
        'bGxvdxgCIAMoDFIKY2FsbHNBbGxvdxIdCgpjYWxsc19kZW55GAMgAygMUgljYWxsc0RlbnkSPw'
        'oIYmlydGhkYXkYBCABKA4yIy5pcGVyb24udjEuUHJpdmFjeVNldHRpbmdzLkF1ZGllbmNlUghi'
        'aXJ0aGRheRIlCg5iaXJ0aGRheV9hbGxvdxgFIAMoDFINYmlydGhkYXlBbGxvdxIjCg1iaXJ0aG'
        'RheV9kZW55GAYgAygMUgxiaXJ0aGRheURlbnkSJgoPaGlkZV9iaXJ0aF95ZWFyGAcgASgIUg1o'
        'aWRlQmlydGhZZWFyEj4KCGFib3V0X21lGAggASgOMiMuaXBlcm9uLnYxLlByaXZhY3lTZXR0aW'
        '5ncy5BdWRpZW5jZVIHYWJvdXRNZRIkCg5hYm91dF9tZV9hbGxvdxgJIAMoDFIMYWJvdXRNZUFs'
        'bG93EiIKDWFib3V0X21lX2RlbnkYCiADKAxSC2Fib3V0TWVEZW55EkAKCWxhc3Rfc2VlbhgLIA'
        'EoDjIjLmlwZXJvbi52MS5Qcml2YWN5U2V0dGluZ3MuQXVkaWVuY2VSCGxhc3RTZWVuEiYKD2xh'
        'c3Rfc2Vlbl9hbGxvdxgMIAMoDFINbGFzdFNlZW5BbGxvdxIkCg5sYXN0X3NlZW5fZGVueRgNIA'
        'MoDFIMbGFzdFNlZW5EZW55IjMKCEF1ZGllbmNlEg0KCUVWRVJZQk9EWRAAEgwKCENPTlRBQ1RT'
        'EAESCgoGTk9CT0RZEAI=');

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

@$core.Deprecated('Use privacyAboutMeUpdateDescriptor instead')
const PrivacyAboutMeUpdate$json = {
  '1': 'PrivacyAboutMeUpdate',
  '3': [PrivacyAboutMeUpdate_Request$json, PrivacyAboutMeUpdate_Response$json],
};

@$core.Deprecated('Use privacyAboutMeUpdateDescriptor instead')
const PrivacyAboutMeUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'about_me', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.PrivacySettings.Audience', '10': 'aboutMe'},
  ],
};

@$core.Deprecated('Use privacyAboutMeUpdateDescriptor instead')
const PrivacyAboutMeUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyAboutMeUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyAboutMeUpdateDescriptor =
    $convert.base64Decode('ChRQcml2YWN5QWJvdXRNZVVwZGF0ZRpJCgdSZXF1ZXN0Ej4KCGFib3V0X21lGAEgASgOMiMuaX'
        'Blcm9uLnYxLlByaXZhY3lTZXR0aW5ncy5BdWRpZW5jZVIHYWJvdXRNZRoKCghSZXNwb25zZQ==');

@$core.Deprecated('Use privacyAboutMeAllowUpdateDescriptor instead')
const PrivacyAboutMeAllowUpdate$json = {
  '1': 'PrivacyAboutMeAllowUpdate',
  '3': [PrivacyAboutMeAllowUpdate_Request$json, PrivacyAboutMeAllowUpdate_Response$json],
};

@$core.Deprecated('Use privacyAboutMeAllowUpdateDescriptor instead')
const PrivacyAboutMeAllowUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'user_ids', '3': 1, '4': 3, '5': 12, '10': 'userIds'},
  ],
};

@$core.Deprecated('Use privacyAboutMeAllowUpdateDescriptor instead')
const PrivacyAboutMeAllowUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyAboutMeAllowUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyAboutMeAllowUpdateDescriptor =
    $convert.base64Decode('ChlQcml2YWN5QWJvdXRNZUFsbG93VXBkYXRlGiQKB1JlcXVlc3QSGQoIdXNlcl9pZHMYASADKA'
        'xSB3VzZXJJZHMaCgoIUmVzcG9uc2U=');

@$core.Deprecated('Use privacyAboutMeDenyUpdateDescriptor instead')
const PrivacyAboutMeDenyUpdate$json = {
  '1': 'PrivacyAboutMeDenyUpdate',
  '3': [PrivacyAboutMeDenyUpdate_Request$json, PrivacyAboutMeDenyUpdate_Response$json],
};

@$core.Deprecated('Use privacyAboutMeDenyUpdateDescriptor instead')
const PrivacyAboutMeDenyUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'user_ids', '3': 1, '4': 3, '5': 12, '10': 'userIds'},
  ],
};

@$core.Deprecated('Use privacyAboutMeDenyUpdateDescriptor instead')
const PrivacyAboutMeDenyUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyAboutMeDenyUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyAboutMeDenyUpdateDescriptor =
    $convert.base64Decode('ChhQcml2YWN5QWJvdXRNZURlbnlVcGRhdGUaJAoHUmVxdWVzdBIZCgh1c2VyX2lkcxgBIAMoDF'
        'IHdXNlcklkcxoKCghSZXNwb25zZQ==');

@$core.Deprecated('Use privacyLastSeenUpdateDescriptor instead')
const PrivacyLastSeenUpdate$json = {
  '1': 'PrivacyLastSeenUpdate',
  '3': [PrivacyLastSeenUpdate_Request$json, PrivacyLastSeenUpdate_Response$json],
};

@$core.Deprecated('Use privacyLastSeenUpdateDescriptor instead')
const PrivacyLastSeenUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'last_seen', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.PrivacySettings.Audience', '10': 'lastSeen'},
  ],
};

@$core.Deprecated('Use privacyLastSeenUpdateDescriptor instead')
const PrivacyLastSeenUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyLastSeenUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyLastSeenUpdateDescriptor =
    $convert.base64Decode('ChVQcml2YWN5TGFzdFNlZW5VcGRhdGUaSwoHUmVxdWVzdBJACglsYXN0X3NlZW4YASABKA4yIy'
        '5pcGVyb24udjEuUHJpdmFjeVNldHRpbmdzLkF1ZGllbmNlUghsYXN0U2VlbhoKCghSZXNwb25z'
        'ZQ==');

@$core.Deprecated('Use privacyLastSeenAllowUpdateDescriptor instead')
const PrivacyLastSeenAllowUpdate$json = {
  '1': 'PrivacyLastSeenAllowUpdate',
  '3': [PrivacyLastSeenAllowUpdate_Request$json, PrivacyLastSeenAllowUpdate_Response$json],
};

@$core.Deprecated('Use privacyLastSeenAllowUpdateDescriptor instead')
const PrivacyLastSeenAllowUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'user_ids', '3': 1, '4': 3, '5': 12, '10': 'userIds'},
  ],
};

@$core.Deprecated('Use privacyLastSeenAllowUpdateDescriptor instead')
const PrivacyLastSeenAllowUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyLastSeenAllowUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyLastSeenAllowUpdateDescriptor =
    $convert.base64Decode('ChpQcml2YWN5TGFzdFNlZW5BbGxvd1VwZGF0ZRokCgdSZXF1ZXN0EhkKCHVzZXJfaWRzGAEgAy'
        'gMUgd1c2VySWRzGgoKCFJlc3BvbnNl');

@$core.Deprecated('Use privacyLastSeenDenyUpdateDescriptor instead')
const PrivacyLastSeenDenyUpdate$json = {
  '1': 'PrivacyLastSeenDenyUpdate',
  '3': [PrivacyLastSeenDenyUpdate_Request$json, PrivacyLastSeenDenyUpdate_Response$json],
};

@$core.Deprecated('Use privacyLastSeenDenyUpdateDescriptor instead')
const PrivacyLastSeenDenyUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'user_ids', '3': 1, '4': 3, '5': 12, '10': 'userIds'},
  ],
};

@$core.Deprecated('Use privacyLastSeenDenyUpdateDescriptor instead')
const PrivacyLastSeenDenyUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `PrivacyLastSeenDenyUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacyLastSeenDenyUpdateDescriptor =
    $convert.base64Decode('ChlQcml2YWN5TGFzdFNlZW5EZW55VXBkYXRlGiQKB1JlcXVlc3QSGQoIdXNlcl9pZHMYASADKA'
        'xSB3VzZXJJZHMaCgoIUmVzcG9uc2U=');
