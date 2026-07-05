// This is a generated file - do not edit.
//
// Generated from protos/messages/two_step_verification_v1.proto.

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

@$core.Deprecated('Use twoStepVerificationDescriptor instead')
const TwoStepVerification$json = {
  '1': 'TwoStepVerification',
  '2': [
    {'1': 'password', '3': 1, '4': 1, '5': 12, '10': 'password'},
  ],
};

/// Descriptor for `TwoStepVerification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twoStepVerificationDescriptor =
    $convert.base64Decode(
        'ChNUd29TdGVwVmVyaWZpY2F0aW9uEhoKCHBhc3N3b3JkGAEgASgMUghwYXNzd29yZA==');

@$core.Deprecated('Use twoStepVerificationResultDescriptor instead')
const TwoStepVerificationResult$json = {
  '1': 'TwoStepVerificationResult',
};

/// Descriptor for `TwoStepVerificationResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twoStepVerificationResultDescriptor =
    $convert.base64Decode('ChlUd29TdGVwVmVyaWZpY2F0aW9uUmVzdWx0');
