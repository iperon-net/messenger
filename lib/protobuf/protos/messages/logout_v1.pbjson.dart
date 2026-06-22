// This is a generated file - do not edit.
//
// Generated from protos/messages/logout_v1.proto.

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

@$core.Deprecated('Use logoutActionDescriptor instead')
const LogoutAction$json = {
  '1': 'LogoutAction',
  '2': [
    {'1': 'current', '2': 0},
    {'1': 'others', '2': 1},
    {'1': 'all', '2': 2},
  ],
};

/// Descriptor for `LogoutAction`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List logoutActionDescriptor = $convert.base64Decode(
    'CgxMb2dvdXRBY3Rpb24SCwoHY3VycmVudBAAEgoKBm90aGVycxABEgcKA2FsbBAC');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.iperon.v1.LogoutAction',
      '10': 'action'
    },
  ],
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor = $convert.base64Decode(
    'Cg1Mb2dvdXRSZXF1ZXN0Ei8KBmFjdGlvbhgBIAEoDjIXLmlwZXJvbi52MS5Mb2dvdXRBY3Rpb2'
    '5SBmFjdGlvbg==');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor =
    $convert.base64Decode('Cg5Mb2dvdXRSZXNwb25zZQ==');
