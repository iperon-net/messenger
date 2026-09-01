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
    {'1': 'firstName', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'firstName', '17': true},
    {'1': 'lastName', '3': 2, '4': 1, '5': 9, '9': 1, '10': 'lastName', '17': true},
    {'1': 'aboutMe', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'aboutMe', '17': true},
    {'1': 'birthDate', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 3, '10': 'birthDate', '17': true},
  ],
  '8': [
    {'1': '_firstName'},
    {'1': '_lastName'},
    {'1': '_aboutMe'},
    {'1': '_birthDate'},
  ],
};

/// Descriptor for `MyProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List myProfileDescriptor =
    $convert.base64Decode('CglNeVByb2ZpbGUaCQoHUmVxdWVzdBrhAQoIUmVzcG9uc2USIQoJZmlyc3ROYW1lGAEgASgJSA'
        'BSCWZpcnN0TmFtZYgBARIfCghsYXN0TmFtZRgCIAEoCUgBUghsYXN0TmFtZYgBARIdCgdhYm91'
        'dE1lGAQgASgJSAJSB2Fib3V0TWWIAQESPQoJYmlydGhEYXRlGAMgASgLMhouZ29vZ2xlLnByb3'
        'RvYnVmLlRpbWVzdGFtcEgDUgliaXJ0aERhdGWIAQFCDAoKX2ZpcnN0TmFtZUILCglfbGFzdE5h'
        'bWVCCgoIX2Fib3V0TWVCDAoKX2JpcnRoRGF0ZQ==');

@$core.Deprecated('Use myProfileUpdateDescriptor instead')
const MyProfileUpdate$json = {
  '1': 'MyProfileUpdate',
  '3': [MyProfileUpdate_Request$json, MyProfileUpdate_Response$json],
};

@$core.Deprecated('Use myProfileUpdateDescriptor instead')
const MyProfileUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'firstName', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'firstName', '17': true},
    {'1': 'lastName', '3': 2, '4': 1, '5': 9, '9': 1, '10': 'lastName', '17': true},
    {'1': 'aboutMe', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'aboutMe', '17': true},
    {'1': 'birthDate', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 3, '10': 'birthDate', '17': true},
  ],
  '8': [
    {'1': '_firstName'},
    {'1': '_lastName'},
    {'1': '_aboutMe'},
    {'1': '_birthDate'},
  ],
};

@$core.Deprecated('Use myProfileUpdateDescriptor instead')
const MyProfileUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `MyProfileUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List myProfileUpdateDescriptor =
    $convert.base64Decode('Cg9NeVByb2ZpbGVVcGRhdGUa4AEKB1JlcXVlc3QSIQoJZmlyc3ROYW1lGAEgASgJSABSCWZpcn'
        'N0TmFtZYgBARIfCghsYXN0TmFtZRgCIAEoCUgBUghsYXN0TmFtZYgBARIdCgdhYm91dE1lGAQg'
        'ASgJSAJSB2Fib3V0TWWIAQESPQoJYmlydGhEYXRlGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
        'RpbWVzdGFtcEgDUgliaXJ0aERhdGWIAQFCDAoKX2ZpcnN0TmFtZUILCglfbGFzdE5hbWVCCgoI'
        'X2Fib3V0TWVCDAoKX2JpcnRoRGF0ZRoKCghSZXNwb25zZQ==');
