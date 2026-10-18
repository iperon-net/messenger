// This is a generated file - do not edit.
//
// Generated from protos/secret_chats_v1.proto.

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

@$core.Deprecated('Use secretChatDescriptor instead')
const SecretChat$json = {
  '1': 'SecretChat',
  '2': [
    {'1': 'secretChatID', '3': 1, '4': 1, '5': 12, '10': 'secretChatID'},
    {'1': 'initiatorUserID', '3': 2, '4': 1, '5': 12, '10': 'initiatorUserID'},
    {'1': 'peerUserID', '3': 3, '4': 1, '5': 12, '10': 'peerUserID'},
    {'1': 'state', '3': 4, '4': 1, '5': 14, '6': '.iperon.v1.SecretChat.State', '10': 'state'},
    {'1': 'date', '3': 5, '4': 1, '5': 3, '10': 'date'},
  ],
  '4': [SecretChat_State$json],
};

@$core.Deprecated('Use secretChatDescriptor instead')
const SecretChat_State$json = {
  '1': 'State',
  '2': [
    {'1': 'REQUESTED', '2': 0},
    {'1': 'ACCEPTED', '2': 1},
    {'1': 'READY', '2': 2},
    {'1': 'DISCARDED', '2': 3},
  ],
};

/// Descriptor for `SecretChat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List secretChatDescriptor =
    $convert.base64Decode('CgpTZWNyZXRDaGF0EiIKDHNlY3JldENoYXRJRBgBIAEoDFIMc2VjcmV0Q2hhdElEEigKD2luaX'
        'RpYXRvclVzZXJJRBgCIAEoDFIPaW5pdGlhdG9yVXNlcklEEh4KCnBlZXJVc2VySUQYAyABKAxS'
        'CnBlZXJVc2VySUQSMQoFc3RhdGUYBCABKA4yGy5pcGVyb24udjEuU2VjcmV0Q2hhdC5TdGF0ZV'
        'IFc3RhdGUSEgoEZGF0ZRgFIAEoA1IEZGF0ZSI+CgVTdGF0ZRINCglSRVFVRVNURUQQABIMCghB'
        'Q0NFUFRFRBABEgkKBVJFQURZEAISDQoJRElTQ0FSREVEEAM=');

@$core.Deprecated('Use secretUpdateDescriptor instead')
const SecretUpdate$json = {
  '1': 'SecretUpdate',
  '2': [
    {'1': 'qts', '3': 1, '4': 1, '5': 3, '10': 'qts'},
    {'1': 'date', '3': 2, '4': 1, '5': 3, '10': 'date'},
    {'1': 'secretChatID', '3': 3, '4': 1, '5': 12, '10': 'secretChatID'},
    {'1': 'requested', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.SecretUpdate.Requested', '9': 0, '10': 'requested'},
    {'1': 'accepted', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.SecretUpdate.Accepted', '9': 0, '10': 'accepted'},
    {'1': 'committed', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.SecretUpdate.Committed', '9': 0, '10': 'committed'},
    {'1': 'newMessage', '3': 7, '4': 1, '5': 11, '6': '.iperon.v1.SecretUpdate.NewMessage', '9': 0, '10': 'newMessage'},
    {'1': 'discarded', '3': 8, '4': 1, '5': 11, '6': '.iperon.v1.SecretUpdate.Discarded', '9': 0, '10': 'discarded'},
  ],
  '3': [
    SecretUpdate_Requested$json,
    SecretUpdate_Accepted$json,
    SecretUpdate_Committed$json,
    SecretUpdate_NewMessage$json,
    SecretUpdate_Discarded$json
  ],
  '8': [
    {'1': 'update'},
  ],
};

@$core.Deprecated('Use secretUpdateDescriptor instead')
const SecretUpdate_Requested$json = {
  '1': 'Requested',
  '2': [
    {'1': 'fromUserID', '3': 1, '4': 1, '5': 12, '10': 'fromUserID'},
    {'1': 'commitment', '3': 2, '4': 1, '5': 12, '10': 'commitment'},
  ],
};

@$core.Deprecated('Use secretUpdateDescriptor instead')
const SecretUpdate_Accepted$json = {
  '1': 'Accepted',
  '2': [
    {'1': 'ephemeralKey', '3': 1, '4': 1, '5': 12, '10': 'ephemeralKey'},
    {'1': 'kemPublicKey', '3': 2, '4': 1, '5': 12, '10': 'kemPublicKey'},
  ],
};

@$core.Deprecated('Use secretUpdateDescriptor instead')
const SecretUpdate_Committed$json = {
  '1': 'Committed',
  '2': [
    {'1': 'ephemeralKey', '3': 1, '4': 1, '5': 12, '10': 'ephemeralKey'},
    {'1': 'nonce', '3': 2, '4': 1, '5': 12, '10': 'nonce'},
    {'1': 'kemCiphertext', '3': 3, '4': 1, '5': 12, '10': 'kemCiphertext'},
    {'1': 'ratchetKey', '3': 4, '4': 1, '5': 12, '10': 'ratchetKey'},
  ],
};

@$core.Deprecated('Use secretUpdateDescriptor instead')
const SecretUpdate_NewMessage$json = {
  '1': 'NewMessage',
  '2': [
    {'1': 'randomID', '3': 1, '4': 1, '5': 3, '10': 'randomID'},
    {'1': 'envelope', '3': 2, '4': 1, '5': 12, '10': 'envelope'},
  ],
};

@$core.Deprecated('Use secretUpdateDescriptor instead')
const SecretUpdate_Discarded$json = {
  '1': 'Discarded',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.SecretUpdate.Discarded.Reason', '10': 'reason'},
    {'1': 'deleteHistory', '3': 2, '4': 1, '5': 8, '10': 'deleteHistory'},
  ],
  '4': [SecretUpdate_Discarded_Reason$json],
};

@$core.Deprecated('Use secretUpdateDescriptor instead')
const SecretUpdate_Discarded_Reason$json = {
  '1': 'Reason',
  '2': [
    {'1': 'BY_PEER', '2': 0},
    {'1': 'ACCEPTED_ELSEWHERE', '2': 1},
    {'1': 'SESSION_ENDED', '2': 2},
    {'1': 'EXPIRED', '2': 3},
  ],
};

/// Descriptor for `SecretUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List secretUpdateDescriptor =
    $convert.base64Decode('CgxTZWNyZXRVcGRhdGUSEAoDcXRzGAEgASgDUgNxdHMSEgoEZGF0ZRgCIAEoA1IEZGF0ZRIiCg'
        'xzZWNyZXRDaGF0SUQYAyABKAxSDHNlY3JldENoYXRJRBJBCglyZXF1ZXN0ZWQYBCABKAsyIS5p'
        'cGVyb24udjEuU2VjcmV0VXBkYXRlLlJlcXVlc3RlZEgAUglyZXF1ZXN0ZWQSPgoIYWNjZXB0ZW'
        'QYBSABKAsyIC5pcGVyb24udjEuU2VjcmV0VXBkYXRlLkFjY2VwdGVkSABSCGFjY2VwdGVkEkEK'
        'CWNvbW1pdHRlZBgGIAEoCzIhLmlwZXJvbi52MS5TZWNyZXRVcGRhdGUuQ29tbWl0dGVkSABSCW'
        'NvbW1pdHRlZBJECgpuZXdNZXNzYWdlGAcgASgLMiIuaXBlcm9uLnYxLlNlY3JldFVwZGF0ZS5O'
        'ZXdNZXNzYWdlSABSCm5ld01lc3NhZ2USQQoJZGlzY2FyZGVkGAggASgLMiEuaXBlcm9uLnYxLl'
        'NlY3JldFVwZGF0ZS5EaXNjYXJkZWRIAFIJZGlzY2FyZGVkGksKCVJlcXVlc3RlZBIeCgpmcm9t'
        'VXNlcklEGAEgASgMUgpmcm9tVXNlcklEEh4KCmNvbW1pdG1lbnQYAiABKAxSCmNvbW1pdG1lbn'
        'QaUgoIQWNjZXB0ZWQSIgoMZXBoZW1lcmFsS2V5GAEgASgMUgxlcGhlbWVyYWxLZXkSIgoMa2Vt'
        'UHVibGljS2V5GAIgASgMUgxrZW1QdWJsaWNLZXkaiwEKCUNvbW1pdHRlZBIiCgxlcGhlbWVyYW'
        'xLZXkYASABKAxSDGVwaGVtZXJhbEtleRIUCgVub25jZRgCIAEoDFIFbm9uY2USJAoNa2VtQ2lw'
        'aGVydGV4dBgDIAEoDFINa2VtQ2lwaGVydGV4dBIeCgpyYXRjaGV0S2V5GAQgASgMUgpyYXRjaG'
        'V0S2V5GkQKCk5ld01lc3NhZ2USGgoIcmFuZG9tSUQYASABKANSCHJhbmRvbUlEEhoKCGVudmVs'
        'b3BlGAIgASgMUghlbnZlbG9wZRrCAQoJRGlzY2FyZGVkEkAKBnJlYXNvbhgBIAEoDjIoLmlwZX'
        'Jvbi52MS5TZWNyZXRVcGRhdGUuRGlzY2FyZGVkLlJlYXNvblIGcmVhc29uEiQKDWRlbGV0ZUhp'
        'c3RvcnkYAiABKAhSDWRlbGV0ZUhpc3RvcnkiTQoGUmVhc29uEgsKB0JZX1BFRVIQABIWChJBQ0'
        'NFUFRFRF9FTFNFV0hFUkUQARIRCg1TRVNTSU9OX0VOREVEEAISCwoHRVhQSVJFRBADQggKBnVw'
        'ZGF0ZQ==');

@$core.Deprecated('Use secretUpdatesDescriptor instead')
const SecretUpdates$json = {
  '1': 'SecretUpdates',
  '2': [
    {'1': 'updates', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.SecretUpdate', '10': 'updates'},
  ],
};

/// Descriptor for `SecretUpdates`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List secretUpdatesDescriptor =
    $convert.base64Decode('Cg1TZWNyZXRVcGRhdGVzEjEKB3VwZGF0ZXMYASADKAsyFy5pcGVyb24udjEuU2VjcmV0VXBkYX'
        'RlUgd1cGRhdGVz');

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats$json = {
  '1': 'SecretChats',
  '3': [
    SecretChats_Create$json,
    SecretChats_CreateResult$json,
    SecretChats_Accept$json,
    SecretChats_AcceptResult$json,
    SecretChats_Commit$json,
    SecretChats_CommitResult$json,
    SecretChats_Discard$json,
    SecretChats_DiscardResult$json,
    SecretChats_Send$json,
    SecretChats_SendResult$json,
    SecretChats_GetUpdates$json,
    SecretChats_GetUpdatesResult$json,
    SecretChats_Ack$json,
    SecretChats_AckResult$json,
    SecretChats_Request$json,
    SecretChats_Response$json
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_Create$json = {
  '1': 'Create',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'commitment', '3': 2, '4': 1, '5': 12, '10': 'commitment'},
    {'1': 'randomID', '3': 3, '4': 1, '5': 3, '10': 'randomID'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_CreateResult$json = {
  '1': 'CreateResult',
  '2': [
    {'1': 'chat', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.SecretChat', '10': 'chat'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_Accept$json = {
  '1': 'Accept',
  '2': [
    {'1': 'secretChatID', '3': 1, '4': 1, '5': 12, '10': 'secretChatID'},
    {'1': 'ephemeralKey', '3': 2, '4': 1, '5': 12, '10': 'ephemeralKey'},
    {'1': 'kemPublicKey', '3': 3, '4': 1, '5': 12, '10': 'kemPublicKey'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_AcceptResult$json = {
  '1': 'AcceptResult',
  '2': [
    {'1': 'chat', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.SecretChat', '10': 'chat'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_Commit$json = {
  '1': 'Commit',
  '2': [
    {'1': 'secretChatID', '3': 1, '4': 1, '5': 12, '10': 'secretChatID'},
    {'1': 'ephemeralKey', '3': 2, '4': 1, '5': 12, '10': 'ephemeralKey'},
    {'1': 'nonce', '3': 3, '4': 1, '5': 12, '10': 'nonce'},
    {'1': 'kemCiphertext', '3': 4, '4': 1, '5': 12, '10': 'kemCiphertext'},
    {'1': 'ratchetKey', '3': 5, '4': 1, '5': 12, '10': 'ratchetKey'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_CommitResult$json = {
  '1': 'CommitResult',
  '2': [
    {'1': 'chat', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.SecretChat', '10': 'chat'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_Discard$json = {
  '1': 'Discard',
  '2': [
    {'1': 'secretChatID', '3': 1, '4': 1, '5': 12, '10': 'secretChatID'},
    {'1': 'deleteHistory', '3': 2, '4': 1, '5': 8, '10': 'deleteHistory'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_DiscardResult$json = {
  '1': 'DiscardResult',
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_Send$json = {
  '1': 'Send',
  '2': [
    {'1': 'secretChatID', '3': 1, '4': 1, '5': 12, '10': 'secretChatID'},
    {'1': 'randomID', '3': 2, '4': 1, '5': 3, '10': 'randomID'},
    {'1': 'envelope', '3': 3, '4': 1, '5': 12, '10': 'envelope'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_SendResult$json = {
  '1': 'SendResult',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 3, '10': 'date'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_GetUpdates$json = {
  '1': 'GetUpdates',
  '2': [
    {'1': 'afterQts', '3': 1, '4': 1, '5': 3, '10': 'afterQts'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_GetUpdatesResult$json = {
  '1': 'GetUpdatesResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.SecretUpdate', '10': 'updates'},
    {'1': 'hasMore', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_Ack$json = {
  '1': 'Ack',
  '2': [
    {'1': 'maxQts', '3': 1, '4': 1, '5': 3, '10': 'maxQts'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_AckResult$json = {
  '1': 'AckResult',
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'createChat', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.Create', '9': 0, '10': 'createChat'},
    {'1': 'accept', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.Accept', '9': 0, '10': 'accept'},
    {'1': 'commit', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.Commit', '9': 0, '10': 'commit'},
    {'1': 'discard', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.Discard', '9': 0, '10': 'discard'},
    {'1': 'send', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.Send', '9': 0, '10': 'send'},
    {'1': 'getUpdates', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.GetUpdates', '9': 0, '10': 'getUpdates'},
    {'1': 'ack', '3': 7, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.Ack', '9': 0, '10': 'ack'},
  ],
  '8': [
    {'1': 'request'},
  ],
};

@$core.Deprecated('Use secretChatsDescriptor instead')
const SecretChats_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'createChat', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.CreateResult', '9': 0, '10': 'createChat'},
    {'1': 'accept', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.AcceptResult', '9': 0, '10': 'accept'},
    {'1': 'commit', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.CommitResult', '9': 0, '10': 'commit'},
    {'1': 'discard', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.DiscardResult', '9': 0, '10': 'discard'},
    {'1': 'send', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.SendResult', '9': 0, '10': 'send'},
    {'1': 'getUpdates', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.GetUpdatesResult', '9': 0, '10': 'getUpdates'},
    {'1': 'ack', '3': 7, '4': 1, '5': 11, '6': '.iperon.v1.SecretChats.AckResult', '9': 0, '10': 'ack'},
  ],
  '8': [
    {'1': 'response'},
  ],
};

/// Descriptor for `SecretChats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List secretChatsDescriptor =
    $convert.base64Decode('CgtTZWNyZXRDaGF0cxpcCgZDcmVhdGUSFgoGdXNlcklEGAEgASgMUgZ1c2VySUQSHgoKY29tbW'
        'l0bWVudBgCIAEoDFIKY29tbWl0bWVudBIaCghyYW5kb21JRBgDIAEoA1IIcmFuZG9tSUQaOQoM'
        'Q3JlYXRlUmVzdWx0EikKBGNoYXQYASABKAsyFS5pcGVyb24udjEuU2VjcmV0Q2hhdFIEY2hhdB'
        'p0CgZBY2NlcHQSIgoMc2VjcmV0Q2hhdElEGAEgASgMUgxzZWNyZXRDaGF0SUQSIgoMZXBoZW1l'
        'cmFsS2V5GAIgASgMUgxlcGhlbWVyYWxLZXkSIgoMa2VtUHVibGljS2V5GAMgASgMUgxrZW1QdW'
        'JsaWNLZXkaOQoMQWNjZXB0UmVzdWx0EikKBGNoYXQYASABKAsyFS5pcGVyb24udjEuU2VjcmV0'
        'Q2hhdFIEY2hhdBqsAQoGQ29tbWl0EiIKDHNlY3JldENoYXRJRBgBIAEoDFIMc2VjcmV0Q2hhdE'
        'lEEiIKDGVwaGVtZXJhbEtleRgCIAEoDFIMZXBoZW1lcmFsS2V5EhQKBW5vbmNlGAMgASgMUgVu'
        'b25jZRIkCg1rZW1DaXBoZXJ0ZXh0GAQgASgMUg1rZW1DaXBoZXJ0ZXh0Eh4KCnJhdGNoZXRLZX'
        'kYBSABKAxSCnJhdGNoZXRLZXkaOQoMQ29tbWl0UmVzdWx0EikKBGNoYXQYASABKAsyFS5pcGVy'
        'b24udjEuU2VjcmV0Q2hhdFIEY2hhdBpTCgdEaXNjYXJkEiIKDHNlY3JldENoYXRJRBgBIAEoDF'
        'IMc2VjcmV0Q2hhdElEEiQKDWRlbGV0ZUhpc3RvcnkYAiABKAhSDWRlbGV0ZUhpc3RvcnkaDwoN'
        'RGlzY2FyZFJlc3VsdBpiCgRTZW5kEiIKDHNlY3JldENoYXRJRBgBIAEoDFIMc2VjcmV0Q2hhdE'
        'lEEhoKCHJhbmRvbUlEGAIgASgDUghyYW5kb21JRBIaCghlbnZlbG9wZRgDIAEoDFIIZW52ZWxv'
        'cGUaIAoKU2VuZFJlc3VsdBISCgRkYXRlGAEgASgDUgRkYXRlGj4KCkdldFVwZGF0ZXMSGgoIYW'
        'Z0ZXJRdHMYASABKANSCGFmdGVyUXRzEhQKBWxpbWl0GAIgASgFUgVsaW1pdBpfChBHZXRVcGRh'
        'dGVzUmVzdWx0EjEKB3VwZGF0ZXMYASADKAsyFy5pcGVyb24udjEuU2VjcmV0VXBkYXRlUgd1cG'
        'RhdGVzEhgKB2hhc01vcmUYAiABKAhSB2hhc01vcmUaHQoDQWNrEhYKBm1heFF0cxgBIAEoA1IG'
        'bWF4UXRzGgsKCUFja1Jlc3VsdBqrAwoHUmVxdWVzdBI/CgpjcmVhdGVDaGF0GAEgASgLMh0uaX'
        'Blcm9uLnYxLlNlY3JldENoYXRzLkNyZWF0ZUgAUgpjcmVhdGVDaGF0EjcKBmFjY2VwdBgCIAEo'
        'CzIdLmlwZXJvbi52MS5TZWNyZXRDaGF0cy5BY2NlcHRIAFIGYWNjZXB0EjcKBmNvbW1pdBgDIA'
        'EoCzIdLmlwZXJvbi52MS5TZWNyZXRDaGF0cy5Db21taXRIAFIGY29tbWl0EjoKB2Rpc2NhcmQY'
        'BCABKAsyHi5pcGVyb24udjEuU2VjcmV0Q2hhdHMuRGlzY2FyZEgAUgdkaXNjYXJkEjEKBHNlbm'
        'QYBSABKAsyGy5pcGVyb24udjEuU2VjcmV0Q2hhdHMuU2VuZEgAUgRzZW5kEkMKCmdldFVwZGF0'
        'ZXMYBiABKAsyIS5pcGVyb24udjEuU2VjcmV0Q2hhdHMuR2V0VXBkYXRlc0gAUgpnZXRVcGRhdG'
        'VzEi4KA2FjaxgHIAEoCzIaLmlwZXJvbi52MS5TZWNyZXRDaGF0cy5BY2tIAFIDYWNrQgkKB3Jl'
        'cXVlc3Qa1wMKCFJlc3BvbnNlEkUKCmNyZWF0ZUNoYXQYASABKAsyIy5pcGVyb24udjEuU2Vjcm'
        'V0Q2hhdHMuQ3JlYXRlUmVzdWx0SABSCmNyZWF0ZUNoYXQSPQoGYWNjZXB0GAIgASgLMiMuaXBl'
        'cm9uLnYxLlNlY3JldENoYXRzLkFjY2VwdFJlc3VsdEgAUgZhY2NlcHQSPQoGY29tbWl0GAMgAS'
        'gLMiMuaXBlcm9uLnYxLlNlY3JldENoYXRzLkNvbW1pdFJlc3VsdEgAUgZjb21taXQSQAoHZGlz'
        'Y2FyZBgEIAEoCzIkLmlwZXJvbi52MS5TZWNyZXRDaGF0cy5EaXNjYXJkUmVzdWx0SABSB2Rpc2'
        'NhcmQSNwoEc2VuZBgFIAEoCzIhLmlwZXJvbi52MS5TZWNyZXRDaGF0cy5TZW5kUmVzdWx0SABS'
        'BHNlbmQSSQoKZ2V0VXBkYXRlcxgGIAEoCzInLmlwZXJvbi52MS5TZWNyZXRDaGF0cy5HZXRVcG'
        'RhdGVzUmVzdWx0SABSCmdldFVwZGF0ZXMSNAoDYWNrGAcgASgLMiAuaXBlcm9uLnYxLlNlY3Jl'
        'dENoYXRzLkFja1Jlc3VsdEgAUgNhY2tCCgoIcmVzcG9uc2U=');
