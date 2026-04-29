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

@$core.Deprecated('Use statusDescriptor instead')
const Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'healthcheck', '2': 0},
    {'1': 'error', '2': 1},
    {'1': 'success', '2': 2},
  ],
};

/// Descriptor for `Status`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List statusDescriptor = $convert.base64Decode(
    'CgZTdGF0dXMSDwoLaGVhbHRoY2hlY2sQABIJCgVlcnJvchABEgsKB3N1Y2Nlc3MQAg==');

@$core.Deprecated('Use locationDescriptor instead')
const Location$json = {
  '1': 'Location',
  '2': [
    {'1': 'russianName', '3': 1, '4': 1, '5': 9, '10': 'russianName'},
    {'1': 'englishName', '3': 2, '4': 1, '5': 9, '10': 'englishName'},
  ],
};

/// Descriptor for `Location`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationDescriptor = $convert.base64Decode(
    'CghMb2NhdGlvbhIgCgtydXNzaWFuTmFtZRgBIAEoCVILcnVzc2lhbk5hbWUSIAoLZW5nbGlzaE'
    '5hbWUYAiABKAlSC2VuZ2xpc2hOYW1l');
