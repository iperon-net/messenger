// This is a generated file - do not edit.
//
// Generated from protos/subscribe_v1.proto.

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

@$core.Deprecated('Use subscribeDescriptor instead')
const Subscribe$json = {
  '1': 'Subscribe',
  '3': [Subscribe_Request$json, Subscribe_Response$json],
};

@$core.Deprecated('Use subscribeDescriptor instead')
const Subscribe_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'background', '3': 1, '4': 1, '5': 8, '10': 'background'},
    {'1': 'capabilities', '3': 2, '4': 3, '5': 9, '10': 'capabilities'},
  ],
};

@$core.Deprecated('Use subscribeDescriptor instead')
const Subscribe_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'clientConfig', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ClientConfig.Response', '10': 'clientConfig'},
  ],
};

/// Descriptor for `Subscribe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeDescriptor =
    $convert.base64Decode('CglTdWJzY3JpYmUaTQoHUmVxdWVzdBIeCgpiYWNrZ3JvdW5kGAEgASgIUgpiYWNrZ3JvdW5kEi'
        'IKDGNhcGFiaWxpdGllcxgCIAMoCVIMY2FwYWJpbGl0aWVzGlAKCFJlc3BvbnNlEkQKDGNsaWVu'
        'dENvbmZpZxgBIAEoCzIgLmlwZXJvbi52MS5DbGllbnRDb25maWcuUmVzcG9uc2VSDGNsaWVudE'
        'NvbmZpZw==');
