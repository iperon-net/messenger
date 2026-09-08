// This is a generated file - do not edit.
//
// Generated from protos/v1.proto.

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

import 'package:protobuf/well_known_types/google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use messageTypeDescriptor instead')
const MessageType$json = {
  '1': 'MessageType',
  '2': [
    {'1': 'HEALTHCHECK', '2': 0},
    {'1': 'META_DATA_INFO', '2': 1},
    {'1': 'AUTH_CALL_PASSWORD', '2': 2},
    {'1': 'AUTH_CALL_PASSWORD_CONFIRMATION', '2': 3},
    {'1': 'AUTH_MODERATION_APPLICATION_STORE', '2': 4},
    {'1': 'AUTH_MODERATION_APPLICATION_STORE_CONFIRMATION', '2': 5},
    {'1': 'DEVICE_SESSIONS', '2': 6},
    {'1': 'LOGOUT', '2': 7},
    {'1': 'SUBSCRIBE', '2': 8},
    {'1': 'DEVICE_SESSIONS_TERMINATE', '2': 9},
    {'1': 'AUTH_CONFIRMATION', '2': 10},
    {'1': 'MY_PROFILE', '2': 11},
    {'1': 'MY_PROFILE_UPDATE', '2': 12},
    {'1': 'DEVICE_INFO_UPDATE', '2': 13},
    {'1': 'MY_PROFILE_AVATAR_UPDATE', '2': 14},
    {'1': 'UPLOAD_CONFIRM', '2': 15},
    {'1': 'CALL_OFFER', '2': 16},
    {'1': 'CALL_ANSWER', '2': 17},
    {'1': 'CALL_ICE_CANDIDATE', '2': 18},
    {'1': 'CALL_HANGUP', '2': 19},
    {'1': 'CALL_REJECT', '2': 20},
    {'1': 'CALL_ICE_SERVERS', '2': 21},
    {'1': 'MY_PROFILE_USERNAME_UPDATE', '2': 22},
  ],
};

/// Descriptor for `MessageType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageTypeDescriptor =
    $convert.base64Decode('CgtNZXNzYWdlVHlwZRIPCgtIRUFMVEhDSEVDSxAAEhIKDk1FVEFfREFUQV9JTkZPEAESFgoSQV'
        'VUSF9DQUxMX1BBU1NXT1JEEAISIwofQVVUSF9DQUxMX1BBU1NXT1JEX0NPTkZJUk1BVElPThAD'
        'EiUKIUFVVEhfTU9ERVJBVElPTl9BUFBMSUNBVElPTl9TVE9SRRAEEjIKLkFVVEhfTU9ERVJBVE'
        'lPTl9BUFBMSUNBVElPTl9TVE9SRV9DT05GSVJNQVRJT04QBRITCg9ERVZJQ0VfU0VTU0lPTlMQ'
        'BhIKCgZMT0dPVVQQBxINCglTVUJTQ1JJQkUQCBIdChlERVZJQ0VfU0VTU0lPTlNfVEVSTUlOQV'
        'RFEAkSFQoRQVVUSF9DT05GSVJNQVRJT04QChIOCgpNWV9QUk9GSUxFEAsSFQoRTVlfUFJPRklM'
        'RV9VUERBVEUQDBIWChJERVZJQ0VfSU5GT19VUERBVEUQDRIcChhNWV9QUk9GSUxFX0FWQVRBUl'
        '9VUERBVEUQDhISCg5VUExPQURfQ09ORklSTRAPEg4KCkNBTExfT0ZGRVIQEBIPCgtDQUxMX0FO'
        'U1dFUhAREhYKEkNBTExfSUNFX0NBTkRJREFURRASEg8KC0NBTExfSEFOR1VQEBMSDwoLQ0FMTF'
        '9SRUpFQ1QQFBIUChBDQUxMX0lDRV9TRVJWRVJTEBUSHgoaTVlfUFJPRklMRV9VU0VSTkFNRV9V'
        'UERBVEUQFg==');

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'messageType', '3': 1, '4': 1, '5': 14, '6': '.v1.MessageType', '10': 'messageType'},
    {'1': 'message', '3': 2, '4': 1, '5': 12, '10': 'message'},
    {'1': 'currentAt', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'currentAt'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor =
    $convert.base64Decode('CgdNZXNzYWdlEjEKC21lc3NhZ2VUeXBlGAEgASgOMg8udjEuTWVzc2FnZVR5cGVSC21lc3NhZ2'
        'VUeXBlEhgKB21lc3NhZ2UYAiABKAxSB21lc3NhZ2USOAoJY3VycmVudEF0GAMgASgLMhouZ29v'
        'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3VycmVudEF0');

@$core.Deprecated('Use uploadDescriptor instead')
const Upload$json = {
  '1': 'Upload',
  '3': [
    Upload_Init$json,
    Upload_Chunk$json,
    Upload_Done$json,
    Upload_InitAck$json,
    Upload_ChunkAck$json,
    Upload_CompleteAck$json,
    Upload_Request$json,
    Upload_Response$json
  ],
};

@$core.Deprecated('Use uploadDescriptor instead')
const Upload_Init$json = {
  '1': 'Init',
  '2': [
    {'1': 'sessionId', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'fileSize', '3': 2, '4': 1, '5': 3, '10': 'fileSize'},
    {'1': 'resumeUploadId', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'resumeUploadId', '17': true},
  ],
  '8': [
    {'1': '_resumeUploadId'},
  ],
};

@$core.Deprecated('Use uploadDescriptor instead')
const Upload_Chunk$json = {
  '1': 'Chunk',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

@$core.Deprecated('Use uploadDescriptor instead')
const Upload_Done$json = {
  '1': 'Done',
};

@$core.Deprecated('Use uploadDescriptor instead')
const Upload_InitAck$json = {
  '1': 'InitAck',
  '2': [
    {'1': 'uploadId', '3': 1, '4': 1, '5': 9, '10': 'uploadId'},
    {'1': 'receivedBytes', '3': 2, '4': 1, '5': 3, '10': 'receivedBytes'},
  ],
};

@$core.Deprecated('Use uploadDescriptor instead')
const Upload_ChunkAck$json = {
  '1': 'ChunkAck',
  '2': [
    {'1': 'receivedBytes', '3': 1, '4': 1, '5': 3, '10': 'receivedBytes'},
  ],
};

@$core.Deprecated('Use uploadDescriptor instead')
const Upload_CompleteAck$json = {
  '1': 'CompleteAck',
  '2': [
    {'1': 'uploadId', '3': 1, '4': 1, '5': 9, '10': 'uploadId'},
    {'1': 'receivedBytes', '3': 2, '4': 1, '5': 3, '10': 'receivedBytes'},
  ],
};

@$core.Deprecated('Use uploadDescriptor instead')
const Upload_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'init', '3': 1, '4': 1, '5': 11, '6': '.v1.Upload.Init', '9': 0, '10': 'init'},
    {'1': 'chunk', '3': 2, '4': 1, '5': 11, '6': '.v1.Upload.Chunk', '9': 0, '10': 'chunk'},
    {'1': 'done', '3': 3, '4': 1, '5': 11, '6': '.v1.Upload.Done', '9': 0, '10': 'done'},
  ],
  '8': [
    {'1': 'payload'},
  ],
};

@$core.Deprecated('Use uploadDescriptor instead')
const Upload_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'initAck', '3': 1, '4': 1, '5': 11, '6': '.v1.Upload.InitAck', '9': 0, '10': 'initAck'},
    {'1': 'chunkAck', '3': 2, '4': 1, '5': 11, '6': '.v1.Upload.ChunkAck', '9': 0, '10': 'chunkAck'},
    {'1': 'completeAck', '3': 3, '4': 1, '5': 11, '6': '.v1.Upload.CompleteAck', '9': 0, '10': 'completeAck'},
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `Upload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadDescriptor =
    $convert.base64Decode('CgZVcGxvYWQagAEKBEluaXQSHAoJc2Vzc2lvbklkGAEgASgJUglzZXNzaW9uSWQSGgoIZmlsZV'
        'NpemUYAiABKANSCGZpbGVTaXplEisKDnJlc3VtZVVwbG9hZElkGAMgASgJSABSDnJlc3VtZVVw'
        'bG9hZElkiAEBQhEKD19yZXN1bWVVcGxvYWRJZBobCgVDaHVuaxISCgRkYXRhGAEgASgMUgRkYX'
        'RhGgYKBERvbmUaSwoHSW5pdEFjaxIaCgh1cGxvYWRJZBgBIAEoCVIIdXBsb2FkSWQSJAoNcmVj'
        'ZWl2ZWRCeXRlcxgCIAEoA1INcmVjZWl2ZWRCeXRlcxowCghDaHVua0FjaxIkCg1yZWNlaXZlZE'
        'J5dGVzGAEgASgDUg1yZWNlaXZlZEJ5dGVzGk8KC0NvbXBsZXRlQWNrEhoKCHVwbG9hZElkGAEg'
        'ASgJUgh1cGxvYWRJZBIkCg1yZWNlaXZlZEJ5dGVzGAIgASgDUg1yZWNlaXZlZEJ5dGVzGowBCg'
        'dSZXF1ZXN0EiUKBGluaXQYASABKAsyDy52MS5VcGxvYWQuSW5pdEgAUgRpbml0EigKBWNodW5r'
        'GAIgASgLMhAudjEuVXBsb2FkLkNodW5rSABSBWNodW5rEiUKBGRvbmUYAyABKAsyDy52MS5VcG'
        'xvYWQuRG9uZUgAUgRkb25lQgkKB3BheWxvYWQatAEKCFJlc3BvbnNlEi4KB2luaXRBY2sYASAB'
        'KAsyEi52MS5VcGxvYWQuSW5pdEFja0gAUgdpbml0QWNrEjEKCGNodW5rQWNrGAIgASgLMhMudj'
        'EuVXBsb2FkLkNodW5rQWNrSABSCGNodW5rQWNrEjoKC2NvbXBsZXRlQWNrGAMgASgLMhYudjEu'
        'VXBsb2FkLkNvbXBsZXRlQWNrSABSC2NvbXBsZXRlQWNrQgkKB3BheWxvYWQ=');

const $core.Map<$core.String, $core.dynamic> IperonServiceBase$json = {
  '1': 'Iperon',
  '2': [
    {'1': 'Unary', '2': '.v1.Message', '3': '.v1.Message', '4': {}},
    {'1': 'Stream', '2': '.v1.Message', '3': '.v1.Message', '4': {}, '5': true, '6': true},
    {'1': 'Upload', '2': '.v1.Upload.Request', '3': '.v1.Upload.Response', '4': {}, '5': true, '6': true},
  ],
};

@$core.Deprecated('Use iperonServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> IperonServiceBase$messageJson = {
  '.v1.Message': Message$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.v1.Upload.Request': Upload_Request$json,
  '.v1.Upload.Init': Upload_Init$json,
  '.v1.Upload.Chunk': Upload_Chunk$json,
  '.v1.Upload.Done': Upload_Done$json,
  '.v1.Upload.Response': Upload_Response$json,
  '.v1.Upload.InitAck': Upload_InitAck$json,
  '.v1.Upload.ChunkAck': Upload_ChunkAck$json,
  '.v1.Upload.CompleteAck': Upload_CompleteAck$json,
};

/// Descriptor for `Iperon`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List iperonServiceDescriptor =
    $convert.base64Decode('CgZJcGVyb24SIwoFVW5hcnkSCy52MS5NZXNzYWdlGgsudjEuTWVzc2FnZSIAEigKBlN0cmVhbR'
        'ILLnYxLk1lc3NhZ2UaCy52MS5NZXNzYWdlIgAoATABEjcKBlVwbG9hZBISLnYxLlVwbG9hZC5S'
        'ZXF1ZXN0GhMudjEuVXBsb2FkLlJlc3BvbnNlIgAoATAB');
