// This is a generated file - do not edit.
//
// Generated from protos/myprofile_v1.proto.

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

@$core.Deprecated('Use myProfileDescriptor instead')
const MyProfile$json = {
  '1': 'MyProfile',
  '3': [MyProfile_Request$json, MyProfile_Response$json],
};

@$core.Deprecated('Use myProfileDescriptor instead')
const MyProfile_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use myProfileDescriptor instead')
const MyProfile_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'firstName', '3': 1, '4': 1, '5': 9, '10': 'firstName'},
    {'1': 'lastName', '3': 2, '4': 1, '5': 9, '10': 'lastName'},
    {'1': 'aboutMe', '3': 4, '4': 1, '5': 9, '10': 'aboutMe'},
    {'1': 'birthDate', '3': 3, '4': 1, '5': 9, '10': 'birthDate'},
  ],
};

/// Descriptor for `MyProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List myProfileDescriptor =
    $convert.base64Decode('CglNeVByb2ZpbGUaCQoHUmVxdWVzdBp8CghSZXNwb25zZRIcCglmaXJzdE5hbWUYASABKAlSCW'
        'ZpcnN0TmFtZRIaCghsYXN0TmFtZRgCIAEoCVIIbGFzdE5hbWUSGAoHYWJvdXRNZRgEIAEoCVIH'
        'YWJvdXRNZRIcCgliaXJ0aERhdGUYAyABKAlSCWJpcnRoRGF0ZQ==');

@$core.Deprecated('Use myProfileEditDescriptor instead')
const MyProfileEdit$json = {
  '1': 'MyProfileEdit',
  '3': [MyProfileEdit_Request$json, MyProfileEdit_Response$json],
};

@$core.Deprecated('Use myProfileEditDescriptor instead')
const MyProfileEdit_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'firstName', '3': 1, '4': 1, '5': 9, '10': 'firstName'},
    {'1': 'lastName', '3': 2, '4': 1, '5': 9, '10': 'lastName'},
    {'1': 'aboutMe', '3': 4, '4': 1, '5': 9, '10': 'aboutMe'},
    {'1': 'birthDate', '3': 3, '4': 1, '5': 9, '10': 'birthDate'},
  ],
};

@$core.Deprecated('Use myProfileEditDescriptor instead')
const MyProfileEdit_Response$json = {
  '1': 'Response',
};

/// Descriptor for `MyProfileEdit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List myProfileEditDescriptor =
    $convert.base64Decode('Cg1NeVByb2ZpbGVFZGl0GnsKB1JlcXVlc3QSHAoJZmlyc3ROYW1lGAEgASgJUglmaXJzdE5hbW'
        'USGgoIbGFzdE5hbWUYAiABKAlSCGxhc3ROYW1lEhgKB2Fib3V0TWUYBCABKAlSB2Fib3V0TWUS'
        'HAoJYmlydGhEYXRlGAMgASgJUgliaXJ0aERhdGUaCgoIUmVzcG9uc2U=');
