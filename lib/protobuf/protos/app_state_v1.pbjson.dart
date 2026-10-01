// This is a generated file - do not edit.
//
// Generated from protos/app_state_v1.proto.

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

@$core.Deprecated('Use appStateDescriptor instead')
const AppState$json = {
  '1': 'AppState',
  '3': [AppState_Request$json, AppState_Response$json],
};

@$core.Deprecated('Use appStateDescriptor instead')
const AppState_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'foreground', '3': 1, '4': 1, '5': 8, '10': 'foreground'},
  ],
};

@$core.Deprecated('Use appStateDescriptor instead')
const AppState_Response$json = {
  '1': 'Response',
};

/// Descriptor for `AppState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appStateDescriptor =
    $convert.base64Decode('CghBcHBTdGF0ZRopCgdSZXF1ZXN0Eh4KCmZvcmVncm91bmQYASABKAhSCmZvcmVncm91bmQaCg'
        'oIUmVzcG9uc2U=');
