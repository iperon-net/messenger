// This is a generated file - do not edit.
//
// Generated from protos/models.proto.

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

@$core.Deprecated('Use authCallPasswordStatusDescriptor instead')
const AuthCallPasswordStatus$json = {
  '1': 'AuthCallPasswordStatus',
  '2': [
    {'1': 'healthcheck', '2': 0},
    {'1': 'error', '2': 1},
    {'1': 'success', '2': 2},
  ],
};

/// Descriptor for `AuthCallPasswordStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List authCallPasswordStatusDescriptor =
    $convert.base64Decode('ChZBdXRoQ2FsbFBhc3N3b3JkU3RhdHVzEg8KC2hlYWx0aGNoZWNrEAASCQoFZXJyb3IQARILCg'
        'dzdWNjZXNzEAI=');

@$core.Deprecated('Use dateDescriptor instead')
const Date$json = {
  '1': 'Date',
  '2': [
    {'1': 'year', '3': 1, '4': 1, '5': 5, '10': 'year'},
    {'1': 'month', '3': 2, '4': 1, '5': 5, '10': 'month'},
    {'1': 'day', '3': 3, '4': 1, '5': 5, '10': 'day'},
  ],
};

/// Descriptor for `Date`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dateDescriptor =
    $convert.base64Decode('CgREYXRlEhIKBHllYXIYASABKAVSBHllYXISFAoFbW9udGgYAiABKAVSBW1vbnRoEhAKA2RheR'
        'gDIAEoBVIDZGF5');
