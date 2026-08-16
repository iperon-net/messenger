// This is a generated file - do not edit.
//
// Generated from protos/logout_v1.proto.

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

@$core.Deprecated('Use logoutDescriptor instead')
const Logout$json = {
  '1': 'Logout',
  '3': [Logout_Request$json, Logout_Response$json],
};

@$core.Deprecated('Use logoutDescriptor instead')
const Logout_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 3, '5': 12, '10': 'sessionID'},
  ],
};

@$core.Deprecated('Use logoutDescriptor instead')
const Logout_Response$json = {
  '1': 'Response',
};

/// Descriptor for `Logout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutDescriptor =
    $convert.base64Decode('CgZMb2dvdXQaJwoHUmVxdWVzdBIcCglzZXNzaW9uSUQYASADKAxSCXNlc3Npb25JRBoKCghSZX'
        'Nwb25zZQ==');
