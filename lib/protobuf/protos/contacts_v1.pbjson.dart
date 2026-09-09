// This is a generated file - do not edit.
//
// Generated from protos/contacts_v1.proto.

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

@$core.Deprecated('Use contactsDiscoveryEvaluateDescriptor instead')
const ContactsDiscoveryEvaluate$json = {
  '1': 'ContactsDiscoveryEvaluate',
  '3': [ContactsDiscoveryEvaluate_Request$json, ContactsDiscoveryEvaluate_Response$json],
};

@$core.Deprecated('Use contactsDiscoveryEvaluateDescriptor instead')
const ContactsDiscoveryEvaluate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'blindedElements', '3': 1, '4': 3, '5': 12, '10': 'blindedElements'},
  ],
};

@$core.Deprecated('Use contactsDiscoveryEvaluateDescriptor instead')
const ContactsDiscoveryEvaluate_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'evaluatedElements', '3': 1, '4': 3, '5': 12, '10': 'evaluatedElements'},
  ],
};

/// Descriptor for `ContactsDiscoveryEvaluate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactsDiscoveryEvaluateDescriptor =
    $convert.base64Decode('ChlDb250YWN0c0Rpc2NvdmVyeUV2YWx1YXRlGjMKB1JlcXVlc3QSKAoPYmxpbmRlZEVsZW1lbn'
        'RzGAEgAygMUg9ibGluZGVkRWxlbWVudHMaOAoIUmVzcG9uc2USLAoRZXZhbHVhdGVkRWxlbWVu'
        'dHMYASADKAxSEWV2YWx1YXRlZEVsZW1lbnRz');

@$core.Deprecated('Use contactsDiscoveryMatchDescriptor instead')
const ContactsDiscoveryMatch$json = {
  '1': 'ContactsDiscoveryMatch',
  '3': [ContactsDiscoveryMatch_Request$json, ContactsDiscoveryMatch_Match$json, ContactsDiscoveryMatch_Response$json],
};

@$core.Deprecated('Use contactsDiscoveryMatchDescriptor instead')
const ContactsDiscoveryMatch_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'oprfOutputs', '3': 1, '4': 3, '5': 12, '10': 'oprfOutputs'},
  ],
};

@$core.Deprecated('Use contactsDiscoveryMatchDescriptor instead')
const ContactsDiscoveryMatch_Match$json = {
  '1': 'Match',
  '2': [
    {'1': 'oprf', '3': 1, '4': 1, '5': 12, '10': 'oprf'},
    {'1': 'userID', '3': 2, '4': 1, '5': 12, '10': 'userID'},
  ],
};

@$core.Deprecated('Use contactsDiscoveryMatchDescriptor instead')
const ContactsDiscoveryMatch_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'matches', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ContactsDiscoveryMatch.Match', '10': 'matches'},
  ],
};

/// Descriptor for `ContactsDiscoveryMatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactsDiscoveryMatchDescriptor =
    $convert.base64Decode('ChZDb250YWN0c0Rpc2NvdmVyeU1hdGNoGisKB1JlcXVlc3QSIAoLb3ByZk91dHB1dHMYASADKA'
        'xSC29wcmZPdXRwdXRzGjMKBU1hdGNoEhIKBG9wcmYYASABKAxSBG9wcmYSFgoGdXNlcklEGAIg'
        'ASgMUgZ1c2VySUQaTQoIUmVzcG9uc2USQQoHbWF0Y2hlcxgBIAMoCzInLmlwZXJvbi52MS5Db2'
        '50YWN0c0Rpc2NvdmVyeU1hdGNoLk1hdGNoUgdtYXRjaGVz');
