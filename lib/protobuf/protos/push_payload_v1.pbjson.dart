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
    {'1': 'badge', '3': 9, '4': 1, '5': 5, '9': 0, '10': 'badge', '17': true},
    {'1': 'date', '3': 10, '4': 1, '5': 3, '10': 'date'},
    {'1': 'messageIDs', '3': 11, '4': 3, '5': 3, '10': 'messageIDs'},
    {'1': 'senderPhone', '3': 12, '4': 1, '5': 9, '10': 'senderPhone'},
    {'1': 'titleFromContact', '3': 13, '4': 1, '5': 8, '10': 'titleFromContact'},
    {'1': 'chatTitle', '3': 14, '4': 1, '5': 9, '10': 'chatTitle'},
  ],
  '4': [PushPayload_Kind$json],
  '8': [
    {'1': '_badge'},
  ],
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
    {'1': 'MESSAGE_REACTION', '2': 13},
    {'1': 'SECRET_MESSAGE', '2': 14},
    {'1': 'SYSTEM_NOTICE', '2': 15},
  ],
};

/// Descriptor for `PushPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushPayloadDescriptor =
    $convert.base64Decode('CgtQdXNoUGF5bG9hZBIvCgRraW5kGAEgASgOMhsuaXBlcm9uLnYxLlB1c2hQYXlsb2FkLktpbm'
        'RSBGtpbmQSDgoCaWQYAiABKAlSAmlkEh4KCmZyb21Vc2VySUQYAyABKAxSCmZyb21Vc2VySUQS'
        'FgoGY2hhdElEGAQgASgMUgZjaGF0SUQSHAoJbWVzc2FnZUlEGAUgASgDUgltZXNzYWdlSUQSFA'
        'oFdGl0bGUYBiABKAlSBXRpdGxlEhIKBGJvZHkYByABKAlSBGJvZHkSEgoEYXJncxgIIAMoCVIE'
        'YXJncxIZCgViYWRnZRgJIAEoBUgAUgViYWRnZYgBARISCgRkYXRlGAogASgDUgRkYXRlEh4KCm'
        '1lc3NhZ2VJRHMYCyADKANSCm1lc3NhZ2VJRHMSIAoLc2VuZGVyUGhvbmUYDCABKAlSC3NlbmRl'
        'clBob25lEioKEHRpdGxlRnJvbUNvbnRhY3QYDSABKAhSEHRpdGxlRnJvbUNvbnRhY3QSHAoJY2'
        'hhdFRpdGxlGA4gASgJUgljaGF0VGl0bGUiswEKBEtpbmQSCwoHVU5LTk9XThAAEggKBFRFU1QQ'
        'ARISCg5DT05UQUNUX0pPSU5FRBACEg8KC0NBTExfTUlTU0VEEAMSCwoHTUVTU0FHRRAKEhAKDF'
        'JFQURfSElTVE9SWRALEhMKD01FU1NBR0VfREVMRVRFRBAMEhQKEE1FU1NBR0VfUkVBQ1RJT04Q'
        'DRISCg5TRUNSRVRfTUVTU0FHRRAOEhEKDVNZU1RFTV9OT1RJQ0UQD0IICgZfYmFkZ2U=');
