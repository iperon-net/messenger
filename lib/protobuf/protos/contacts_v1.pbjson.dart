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

@$core.Deprecated('Use contactsUpsertDescriptor instead')
const ContactsUpsert$json = {
  '1': 'ContactsUpsert',
  '3': [ContactsUpsert_Item$json, ContactsUpsert_Request$json, ContactsUpsert_Response$json],
  '4': [ContactsUpsert_Source$json],
};

@$core.Deprecated('Use contactsUpsertDescriptor instead')
const ContactsUpsert_Item$json = {
  '1': 'Item',
  '2': [
    {'1': 'oprf', '3': 1, '4': 1, '5': 12, '10': 'oprf'},
    {'1': 'source', '3': 2, '4': 1, '5': 14, '6': '.iperon.v1.ContactsUpsert.Source', '10': 'source'},
    {'1': 'firstName', '3': 3, '4': 1, '5': 9, '10': 'firstName'},
    {'1': 'lastName', '3': 4, '4': 1, '5': 9, '10': 'lastName'},
    {'1': 'phoneNumber', '3': 5, '4': 1, '5': 9, '10': 'phoneNumber'},
  ],
};

@$core.Deprecated('Use contactsUpsertDescriptor instead')
const ContactsUpsert_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ContactsUpsert.Item', '10': 'items'},
    {'1': 'full', '3': 2, '4': 1, '5': 8, '10': 'full'},
  ],
};

@$core.Deprecated('Use contactsUpsertDescriptor instead')
const ContactsUpsert_Response$json = {
  '1': 'Response',
};

@$core.Deprecated('Use contactsUpsertDescriptor instead')
const ContactsUpsert_Source$json = {
  '1': 'Source',
  '2': [
    {'1': 'OPRF', '2': 0},
    {'1': 'MANUAL', '2': 1},
  ],
};

/// Descriptor for `ContactsUpsert`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactsUpsertDescriptor =
    $convert.base64Decode('Cg5Db250YWN0c1Vwc2VydBqwAQoESXRlbRISCgRvcHJmGAEgASgMUgRvcHJmEjgKBnNvdXJjZR'
        'gCIAEoDjIgLmlwZXJvbi52MS5Db250YWN0c1Vwc2VydC5Tb3VyY2VSBnNvdXJjZRIcCglmaXJz'
        'dE5hbWUYAyABKAlSCWZpcnN0TmFtZRIaCghsYXN0TmFtZRgEIAEoCVIIbGFzdE5hbWUSIAoLcG'
        'hvbmVOdW1iZXIYBSABKAlSC3Bob25lTnVtYmVyGlMKB1JlcXVlc3QSNAoFaXRlbXMYASADKAsy'
        'Hi5pcGVyb24udjEuQ29udGFjdHNVcHNlcnQuSXRlbVIFaXRlbXMSEgoEZnVsbBgCIAEoCFIEZn'
        'VsbBoKCghSZXNwb25zZSIeCgZTb3VyY2USCAoET1BSRhAAEgoKBk1BTlVBTBAB');

@$core.Deprecated('Use contactsRemoveDescriptor instead')
const ContactsRemove$json = {
  '1': 'ContactsRemove',
  '3': [ContactsRemove_Request$json, ContactsRemove_Response$json],
};

@$core.Deprecated('Use contactsRemoveDescriptor instead')
const ContactsRemove_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'oprf', '3': 1, '4': 3, '5': 12, '10': 'oprf'},
  ],
};

@$core.Deprecated('Use contactsRemoveDescriptor instead')
const ContactsRemove_Response$json = {
  '1': 'Response',
};

/// Descriptor for `ContactsRemove`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactsRemoveDescriptor =
    $convert.base64Decode('Cg5Db250YWN0c1JlbW92ZRodCgdSZXF1ZXN0EhIKBG9wcmYYASADKAxSBG9wcmYaCgoIUmVzcG'
        '9uc2U=');

@$core.Deprecated('Use contactDescriptor instead')
const Contact$json = {
  '1': 'Contact',
  '2': [
    {'1': 'oprf', '3': 1, '4': 1, '5': 12, '10': 'oprf'},
    {'1': 'contactUserID', '3': 2, '4': 1, '5': 12, '10': 'contactUserID'},
    {'1': 'source', '3': 3, '4': 1, '5': 14, '6': '.iperon.v1.ContactsUpsert.Source', '10': 'source'},
    {'1': 'firstName', '3': 4, '4': 1, '5': 9, '10': 'firstName'},
    {'1': 'lastName', '3': 5, '4': 1, '5': 9, '10': 'lastName'},
    {'1': 'phoneNumber', '3': 6, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'updatedAt', '3': 7, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Contact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactDescriptor =
    $convert.base64Decode('CgdDb250YWN0EhIKBG9wcmYYASABKAxSBG9wcmYSJAoNY29udGFjdFVzZXJJRBgCIAEoDFINY2'
        '9udGFjdFVzZXJJRBI4CgZzb3VyY2UYAyABKA4yIC5pcGVyb24udjEuQ29udGFjdHNVcHNlcnQu'
        'U291cmNlUgZzb3VyY2USHAoJZmlyc3ROYW1lGAQgASgJUglmaXJzdE5hbWUSGgoIbGFzdE5hbW'
        'UYBSABKAlSCGxhc3ROYW1lEiAKC3Bob25lTnVtYmVyGAYgASgJUgtwaG9uZU51bWJlchIcCgl1'
        'cGRhdGVkQXQYByABKANSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use contactsListDescriptor instead')
const ContactsList$json = {
  '1': 'ContactsList',
  '3': [ContactsList_Request$json, ContactsList_Response$json],
};

@$core.Deprecated('Use contactsListDescriptor instead')
const ContactsList_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use contactsListDescriptor instead')
const ContactsList_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'contacts', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Contact', '10': 'contacts'},
  ],
};

/// Descriptor for `ContactsList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactsListDescriptor =
    $convert.base64Decode('CgxDb250YWN0c0xpc3QaCQoHUmVxdWVzdBo6CghSZXNwb25zZRIuCghjb250YWN0cxgBIAMoCz'
        'ISLmlwZXJvbi52MS5Db250YWN0Ughjb250YWN0cw==');

@$core.Deprecated('Use contactsUpdatedDescriptor instead')
const ContactsUpdated$json = {
  '1': 'ContactsUpdated',
  '2': [
    {'1': 'upserted', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Contact', '10': 'upserted'},
    {'1': 'removedOprf', '3': 2, '4': 3, '5': 12, '10': 'removedOprf'},
  ],
};

/// Descriptor for `ContactsUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactsUpdatedDescriptor =
    $convert.base64Decode('Cg9Db250YWN0c1VwZGF0ZWQSLgoIdXBzZXJ0ZWQYASADKAsyEi5pcGVyb24udjEuQ29udGFjdF'
        'IIdXBzZXJ0ZWQSIAoLcmVtb3ZlZE9wcmYYAiADKAxSC3JlbW92ZWRPcHJm');
