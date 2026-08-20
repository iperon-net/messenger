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
    {'1': 'PROFILE', '2': 11},
    {'1': 'PROFILE_EDIT', '2': 12},
    {'1': 'DEVICE_INFO_UPDATE', '2': 13},
  ],
};

/// Descriptor for `MessageType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageTypeDescriptor =
    $convert.base64Decode('CgtNZXNzYWdlVHlwZRIPCgtIRUFMVEhDSEVDSxAAEhIKDk1FVEFfREFUQV9JTkZPEAESFgoSQV'
        'VUSF9DQUxMX1BBU1NXT1JEEAISIwofQVVUSF9DQUxMX1BBU1NXT1JEX0NPTkZJUk1BVElPThAD'
        'EiUKIUFVVEhfTU9ERVJBVElPTl9BUFBMSUNBVElPTl9TVE9SRRAEEjIKLkFVVEhfTU9ERVJBVE'
        'lPTl9BUFBMSUNBVElPTl9TVE9SRV9DT05GSVJNQVRJT04QBRITCg9ERVZJQ0VfU0VTU0lPTlMQ'
        'BhIKCgZMT0dPVVQQBxINCglTVUJTQ1JJQkUQCBIdChlERVZJQ0VfU0VTU0lPTlNfVEVSTUlOQV'
        'RFEAkSFQoRQVVUSF9DT05GSVJNQVRJT04QChILCgdQUk9GSUxFEAsSEAoMUFJPRklMRV9FRElU'
        'EAwSFgoSREVWSUNFX0lORk9fVVBEQVRFEA0=');

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
