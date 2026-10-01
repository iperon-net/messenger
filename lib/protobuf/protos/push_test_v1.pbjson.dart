// This is a generated file - do not edit.
//
// Generated from protos/push_test_v1.proto.

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

@$core.Deprecated('Use pushTestDescriptor instead')
const PushTest$json = {
  '1': 'PushTest',
  '3': [PushTest_Request$json, PushTest_Response$json],
};

@$core.Deprecated('Use pushTestDescriptor instead')
const PushTest_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use pushTestDescriptor instead')
const PushTest_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'apnsSent', '3': 1, '4': 1, '5': 5, '10': 'apnsSent'},
    {'1': 'fcmSent', '3': 2, '4': 1, '5': 5, '10': 'fcmSent'},
    {'1': 'failed', '3': 3, '4': 1, '5': 5, '10': 'failed'},
  ],
};

/// Descriptor for `PushTest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushTestDescriptor =
    $convert.base64Decode('CghQdXNoVGVzdBoJCgdSZXF1ZXN0GlgKCFJlc3BvbnNlEhoKCGFwbnNTZW50GAEgASgFUghhcG'
        '5zU2VudBIYCgdmY21TZW50GAIgASgFUgdmY21TZW50EhYKBmZhaWxlZBgDIAEoBVIGZmFpbGVk');
