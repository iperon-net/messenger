// This is a generated file - do not edit.
//
// Generated from protos/presence_v1.proto.

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

@$core.Deprecated('Use presenceDescriptor instead')
const Presence$json = {
  '1': 'Presence',
  '3': [Presence_Request$json, Presence_Item$json, Presence_Response$json],
};

@$core.Deprecated('Use presenceDescriptor instead')
const Presence_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 12, '10': 'userIDs'},
  ],
};

@$core.Deprecated('Use presenceDescriptor instead')
const Presence_Item$json = {
  '1': 'Item',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'online', '3': 2, '4': 1, '5': 8, '10': 'online'},
    {'1': 'lastSeen', '3': 3, '4': 1, '5': 3, '10': 'lastSeen'},
  ],
};

@$core.Deprecated('Use presenceDescriptor instead')
const Presence_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Presence.Item', '10': 'items'},
  ],
};

/// Descriptor for `Presence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceDescriptor =
    $convert.base64Decode('CghQcmVzZW5jZRojCgdSZXF1ZXN0EhgKB3VzZXJJRHMYASADKAxSB3VzZXJJRHMaUgoESXRlbR'
        'IWCgZ1c2VySUQYASABKAxSBnVzZXJJRBIWCgZvbmxpbmUYAiABKAhSBm9ubGluZRIaCghsYXN0'
        'U2VlbhgDIAEoA1IIbGFzdFNlZW4aOgoIUmVzcG9uc2USLgoFaXRlbXMYASADKAsyGC5pcGVyb2'
        '4udjEuUHJlc2VuY2UuSXRlbVIFaXRlbXM=');
