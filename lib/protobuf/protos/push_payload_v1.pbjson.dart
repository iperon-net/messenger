// This is a generated file - do not edit.
//
// Generated from protos/push_payload_v1.proto.

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

@$core.Deprecated('Use pushPayloadDescriptor instead')
const PushPayload$json = {
  '1': 'PushPayload',
  '2': [
    {'1': 'kind', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.PushPayload.Kind', '10': 'kind'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {'1': 'fromUserID', '3': 3, '4': 1, '5': 12, '10': 'fromUserID'},
    {'1': 'chatID', '3': 4, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 5, '4': 1, '5': 3, '10': 'messageID'},
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'body', '3': 7, '4': 1, '5': 9, '10': 'body'},
    {'1': 'args', '3': 8, '4': 3, '5': 9, '10': 'args'},
    {'1': 'badge', '3': 9, '4': 1, '5': 5, '10': 'badge'},
    {'1': 'date', '3': 10, '4': 1, '5': 3, '10': 'date'},
    {'1': 'messageIDs', '3': 11, '4': 3, '5': 3, '10': 'messageIDs'},
  ],
  '4': [PushPayload_Kind$json],
};

@$core.Deprecated('Use pushPayloadDescriptor instead')
const PushPayload_Kind$json = {
  '1': 'Kind',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'TEST', '2': 1},
    {'1': 'CONTACT_JOINED', '2': 2},
    {'1': 'CALL_MISSED', '2': 3},
    {'1': 'MESSAGE', '2': 10},
    {'1': 'READ_HISTORY', '2': 11},
    {'1': 'MESSAGE_DELETED', '2': 12},
  ],
};

/// Descriptor for `PushPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushPayloadDescriptor =
    $convert.base64Decode('CgtQdXNoUGF5bG9hZBIvCgRraW5kGAEgASgOMhsuaXBlcm9uLnYxLlB1c2hQYXlsb2FkLktpbm'
        'RSBGtpbmQSDgoCaWQYAiABKAlSAmlkEh4KCmZyb21Vc2VySUQYAyABKAxSCmZyb21Vc2VySUQS'
        'FgoGY2hhdElEGAQgASgMUgZjaGF0SUQSHAoJbWVzc2FnZUlEGAUgASgDUgltZXNzYWdlSUQSFA'
        'oFdGl0bGUYBiABKAlSBXRpdGxlEhIKBGJvZHkYByABKAlSBGJvZHkSEgoEYXJncxgIIAMoCVIE'
        'YXJncxIUCgViYWRnZRgJIAEoBVIFYmFkZ2USEgoEZGF0ZRgKIAEoA1IEZGF0ZRIeCgptZXNzYW'
        'dlSURzGAsgAygDUgptZXNzYWdlSURzInYKBEtpbmQSCwoHVU5LTk9XThAAEggKBFRFU1QQARIS'
        'Cg5DT05UQUNUX0pPSU5FRBACEg8KC0NBTExfTUlTU0VEEAMSCwoHTUVTU0FHRRAKEhAKDFJFQU'
        'RfSElTVE9SWRALEhMKD01FU1NBR0VfREVMRVRFRBAM');
