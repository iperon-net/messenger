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
};

@$core.Deprecated('Use profileDescriptor instead')
const Profile_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'firstName', '3': 1, '4': 1, '5': 9, '10': 'firstName'},
    {'1': 'lastName', '3': 2, '4': 1, '5': 9, '10': 'lastName'},
    {'1': 'aboutMe', '3': 4, '4': 1, '5': 9, '10': 'aboutMe'},
    {'1': 'dateBirth', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.Date', '10': 'dateBirth'},
  ],
};

/// Descriptor for `Profile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileDescriptor =
    $convert.base64Decode('CgdQcm9maWxlGgkKB1JlcXVlc3QajQEKCFJlc3BvbnNlEhwKCWZpcnN0TmFtZRgBIAEoCVIJZm'
        'lyc3ROYW1lEhoKCGxhc3ROYW1lGAIgASgJUghsYXN0TmFtZRIYCgdhYm91dE1lGAQgASgJUgdh'
        'Ym91dE1lEi0KCWRhdGVCaXJ0aBgDIAEoCzIPLmlwZXJvbi52MS5EYXRlUglkYXRlQmlydGg=');

@$core.Deprecated('Use profileEditDescriptor instead')
const ProfileEdit$json = {
  '1': 'ProfileEdit',
  '3': [ProfileEdit_Request$json, ProfileEdit_Response$json],
};

@$core.Deprecated('Use profileEditDescriptor instead')
const ProfileEdit_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'firstName', '3': 1, '4': 1, '5': 9, '10': 'firstName'},
    {'1': 'lastName', '3': 2, '4': 1, '5': 9, '10': 'lastName'},
    {'1': 'aboutMe', '3': 4, '4': 1, '5': 9, '10': 'aboutMe'},
    {'1': 'dateBirth', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.Date', '10': 'dateBirth'},
  ],
};

@$core.Deprecated('Use profileEditDescriptor instead')
const ProfileEdit_Response$json = {
  '1': 'Response',
};

/// Descriptor for `ProfileEdit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileEditDescriptor =
    $convert.base64Decode('CgtQcm9maWxlRWRpdBqMAQoHUmVxdWVzdBIcCglmaXJzdE5hbWUYASABKAlSCWZpcnN0TmFtZR'
        'IaCghsYXN0TmFtZRgCIAEoCVIIbGFzdE5hbWUSGAoHYWJvdXRNZRgEIAEoCVIHYWJvdXRNZRIt'
        'CglkYXRlQmlydGgYAyABKAsyDy5pcGVyb24udjEuRGF0ZVIJZGF0ZUJpcnRoGgoKCFJlc3Bvbn'
        'Nl');
