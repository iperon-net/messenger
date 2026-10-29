// This is a generated file - do not edit.
//
// Generated from protos/reports_v1.proto.

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

@$core.Deprecated('Use reportDescriptor instead')
const Report$json = {
  '1': 'Report',
  '3': [Report_Request$json, Report_Response$json],
  '4': [Report_Reason$json],
};

@$core.Deprecated('Use reportDescriptor instead')
const Report_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'chatID', '3': 2, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageIDs', '3': 3, '4': 3, '5': 3, '10': 'messageIDs'},
    {'1': 'reason', '3': 4, '4': 1, '5': 14, '6': '.iperon.v1.Report.Reason', '10': 'reason'},
    {'1': 'comment', '3': 5, '4': 1, '5': 9, '10': 'comment'},
  ],
};

@$core.Deprecated('Use reportDescriptor instead')
const Report_Response$json = {
  '1': 'Response',
};

@$core.Deprecated('Use reportDescriptor instead')
const Report_Reason$json = {
  '1': 'Reason',
  '2': [
    {'1': 'REASON_UNKNOWN', '2': 0},
    {'1': 'SPAM', '2': 1},
    {'1': 'VIOLENCE', '2': 2},
    {'1': 'PORNOGRAPHY', '2': 3},
    {'1': 'CHILD_ABUSE', '2': 4},
    {'1': 'ILLEGAL_DRUGS', '2': 5},
    {'1': 'PERSONAL_DATA', '2': 6},
    {'1': 'FAKE', '2': 7},
    {'1': 'COPYRIGHT', '2': 8},
    {'1': 'OTHER', '2': 9},
  ],
};

/// Descriptor for `Report`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportDescriptor =
    $convert.base64Decode('CgZSZXBvcnQapQEKB1JlcXVlc3QSFgoGdXNlcklEGAEgASgMUgZ1c2VySUQSFgoGY2hhdElEGA'
        'IgASgMUgZjaGF0SUQSHgoKbWVzc2FnZUlEcxgDIAMoA1IKbWVzc2FnZUlEcxIwCgZyZWFzb24Y'
        'BCABKA4yGC5pcGVyb24udjEuUmVwb3J0LlJlYXNvblIGcmVhc29uEhgKB2NvbW1lbnQYBSABKA'
        'lSB2NvbW1lbnQaCgoIUmVzcG9uc2UioAEKBlJlYXNvbhISCg5SRUFTT05fVU5LTk9XThAAEggK'
        'BFNQQU0QARIMCghWSU9MRU5DRRACEg8KC1BPUk5PR1JBUEhZEAMSDwoLQ0hJTERfQUJVU0UQBB'
        'IRCg1JTExFR0FMX0RSVUdTEAUSEQoNUEVSU09OQUxfREFUQRAGEggKBEZBS0UQBxINCglDT1BZ'
        'UklHSFQQCBIJCgVPVEhFUhAJ');
