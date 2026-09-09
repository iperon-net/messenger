// This is a generated file - do not edit.
//
// Generated from protos/profile_v1.proto.

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

@$core.Deprecated('Use profileDescriptor instead')
const Profile$json = {
  '1': 'Profile',
  '3': [Profile_Request$json, Profile_Response$json],
};

@$core.Deprecated('Use profileDescriptor instead')
const Profile_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 12, '9': 0, '10': 'userID'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'username'},
  ],
  '8': [
    {'1': 'identifier'},
  ],
};

@$core.Deprecated('Use profileDescriptor instead')
const Profile_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'firstName', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'firstName', '17': true},
    {'1': 'lastName', '3': 2, '4': 1, '5': 9, '9': 1, '10': 'lastName', '17': true},
    {'1': 'aboutMe', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'aboutMe', '17': true},
    {'1': 'birthDate', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 3, '10': 'birthDate', '17': true},
    {'1': 'avatar', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.CDN', '9': 4, '10': 'avatar', '17': true},
    {'1': 'username', '3': 6, '4': 1, '5': 9, '9': 5, '10': 'username', '17': true},
    {'1': 'phoneNumber', '3': 7, '4': 1, '5': 9, '9': 6, '10': 'phoneNumber', '17': true},
    {'1': 'userID', '3': 8, '4': 1, '5': 12, '9': 7, '10': 'userID', '17': true},
  ],
  '8': [
    {'1': '_firstName'},
    {'1': '_lastName'},
    {'1': '_aboutMe'},
    {'1': '_birthDate'},
    {'1': '_avatar'},
    {'1': '_username'},
    {'1': '_phoneNumber'},
    {'1': '_userID'},
  ],
};

/// Descriptor for `Profile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileDescriptor =
    $convert.base64Decode('CgdQcm9maWxlGk8KB1JlcXVlc3QSGAoGdXNlcklEGAEgASgMSABSBnVzZXJJRBIcCgh1c2Vybm'
        'FtZRgCIAEoCUgAUgh1c2VybmFtZUIMCgppZGVudGlmaWVyGqYDCghSZXNwb25zZRIhCglmaXJz'
        'dE5hbWUYASABKAlIAFIJZmlyc3ROYW1liAEBEh8KCGxhc3ROYW1lGAIgASgJSAFSCGxhc3ROYW'
        '1liAEBEh0KB2Fib3V0TWUYBCABKAlIAlIHYWJvdXRNZYgBARI9CgliaXJ0aERhdGUYAyABKAsy'
        'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wSANSCWJpcnRoRGF0ZYgBARIrCgZhdmF0YXIYBS'
        'ABKAsyDi5pcGVyb24udjEuQ0ROSARSBmF2YXRhcogBARIfCgh1c2VybmFtZRgGIAEoCUgFUgh1'
        'c2VybmFtZYgBARIlCgtwaG9uZU51bWJlchgHIAEoCUgGUgtwaG9uZU51bWJlcogBARIbCgZ1c2'
        'VySUQYCCABKAxIB1IGdXNlcklEiAEBQgwKCl9maXJzdE5hbWVCCwoJX2xhc3ROYW1lQgoKCF9h'
        'Ym91dE1lQgwKCl9iaXJ0aERhdGVCCQoHX2F2YXRhckILCglfdXNlcm5hbWVCDgoMX3Bob25lTn'
        'VtYmVyQgkKB191c2VySUQ=');
