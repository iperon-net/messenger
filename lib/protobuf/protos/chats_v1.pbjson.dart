// This is a generated file - do not edit.
//
// Generated from protos/chats_v1.proto.

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

@$core.Deprecated('Use chatTypeDescriptor instead')
const ChatType$json = {
  '1': 'ChatType',
  '2': [
    {'1': 'CHAT_TYPE_PRIVATE', '2': 0},
    {'1': 'CHAT_TYPE_GROUP', '2': 1},
    {'1': 'CHAT_TYPE_CHANNEL', '2': 2},
    {'1': 'CHAT_TYPE_COMMUNITY', '2': 3},
  ],
};

/// Descriptor for `ChatType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List chatTypeDescriptor =
    $convert.base64Decode('CghDaGF0VHlwZRIVChFDSEFUX1RZUEVfUFJJVkFURRAAEhMKD0NIQVRfVFlQRV9HUk9VUBABEh'
        'UKEUNIQVRfVFlQRV9DSEFOTkVMEAISFwoTQ0hBVF9UWVBFX0NPTU1VTklUWRAD');

@$core.Deprecated('Use messageKindDescriptor instead')
const MessageKind$json = {
  '1': 'MessageKind',
  '2': [
    {'1': 'MESSAGE_KIND_TEXT', '2': 0},
    {'1': 'MESSAGE_KIND_PHOTO', '2': 1},
    {'1': 'MESSAGE_KIND_VIDEO', '2': 2},
    {'1': 'MESSAGE_KIND_FILE', '2': 3},
    {'1': 'MESSAGE_KIND_VOICE', '2': 4},
    {'1': 'MESSAGE_KIND_POLL', '2': 5},
  ],
};

/// Descriptor for `MessageKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageKindDescriptor =
    $convert.base64Decode('CgtNZXNzYWdlS2luZBIVChFNRVNTQUdFX0tJTkRfVEVYVBAAEhYKEk1FU1NBR0VfS0lORF9QSE'
        '9UTxABEhYKEk1FU1NBR0VfS0lORF9WSURFTxACEhUKEU1FU1NBR0VfS0lORF9GSUxFEAMSFgoS'
        'TUVTU0FHRV9LSU5EX1ZPSUNFEAQSFQoRTUVTU0FHRV9LSU5EX1BPTEwQBQ==');

@$core.Deprecated('Use messageEntityDescriptor instead')
const MessageEntity$json = {
  '1': 'MessageEntity',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.MessageEntity.Type', '10': 'type'},
    {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
    {'1': 'length', '3': 3, '4': 1, '5': 5, '10': 'length'},
    {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
    {'1': 'userID', '3': 5, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'expandable', '3': 6, '4': 1, '5': 8, '10': 'expandable'},
  ],
  '4': [MessageEntity_Type$json],
};

@$core.Deprecated('Use messageEntityDescriptor instead')
const MessageEntity_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'BOLD', '2': 0},
    {'1': 'ITALIC', '2': 1},
    {'1': 'UNDERLINE', '2': 2},
    {'1': 'STRIKE', '2': 3},
    {'1': 'SPOILER', '2': 4},
    {'1': 'CODE', '2': 5},
    {'1': 'PRE', '2': 6},
    {'1': 'TEXT_URL', '2': 7},
    {'1': 'URL', '2': 8},
    {'1': 'MENTION', '2': 9},
    {'1': 'MENTION_NAME', '2': 10},
    {'1': 'HASHTAG', '2': 11},
    {'1': 'EMAIL', '2': 12},
    {'1': 'PHONE', '2': 13},
    {'1': 'BLOCKQUOTE', '2': 14},
  ],
};

/// Descriptor for `MessageEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageEntityDescriptor =
    $convert.base64Decode('Cg1NZXNzYWdlRW50aXR5EjEKBHR5cGUYASABKA4yHS5pcGVyb24udjEuTWVzc2FnZUVudGl0eS'
        '5UeXBlUgR0eXBlEhYKBm9mZnNldBgCIAEoBVIGb2Zmc2V0EhYKBmxlbmd0aBgDIAEoBVIGbGVu'
        'Z3RoEhAKA3VybBgEIAEoCVIDdXJsEhYKBnVzZXJJRBgFIAEoDFIGdXNlcklEEh4KCmV4cGFuZG'
        'FibGUYBiABKAhSCmV4cGFuZGFibGUiwAEKBFR5cGUSCAoEQk9MRBAAEgoKBklUQUxJQxABEg0K'
        'CVVOREVSTElORRACEgoKBlNUUklLRRADEgsKB1NQT0lMRVIQBBIICgRDT0RFEAUSBwoDUFJFEA'
        'YSDAoIVEVYVF9VUkwQBxIHCgNVUkwQCBILCgdNRU5USU9OEAkSEAoMTUVOVElPTl9OQU1FEAoS'
        'CwoHSEFTSFRBRxALEgkKBUVNQUlMEAwSCQoFUEhPTkUQDRIOCgpCTE9DS1FVT1RFEA4=');

@$core.Deprecated('Use messageMediaDescriptor instead')
const MessageMedia$json = {
  '1': 'MessageMedia',
  '2': [
    {'1': 'kind', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.MessageKind', '10': 'kind'},
    {'1': 'cdnID', '3': 2, '4': 1, '5': 12, '10': 'cdnID'},
    {'1': 'width', '3': 3, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 4, '4': 1, '5': 5, '10': 'height'},
    {'1': 'size', '3': 5, '4': 1, '5': 3, '10': 'size'},
    {'1': 'thumbhash', '3': 6, '4': 1, '5': 9, '10': 'thumbhash'},
    {'1': 'spoiler', '3': 7, '4': 1, '5': 8, '10': 'spoiler'},
    {'1': 'duration', '3': 8, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'fileName', '3': 9, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'mimeType', '3': 10, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'waveform', '3': 11, '4': 1, '5': 12, '10': 'waveform'},
    {'1': 'file', '3': 12, '4': 1, '5': 11, '6': '.iperon.v1.CDN', '10': 'file'},
    {'1': 'thumbCdnID', '3': 13, '4': 1, '5': 12, '10': 'thumbCdnID'},
    {'1': 'thumbFile', '3': 14, '4': 1, '5': 11, '6': '.iperon.v1.CDN', '10': 'thumbFile'},
  ],
};

/// Descriptor for `MessageMedia`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageMediaDescriptor =
    $convert.base64Decode('CgxNZXNzYWdlTWVkaWESKgoEa2luZBgBIAEoDjIWLmlwZXJvbi52MS5NZXNzYWdlS2luZFIEa2'
        'luZBIUCgVjZG5JRBgCIAEoDFIFY2RuSUQSFAoFd2lkdGgYAyABKAVSBXdpZHRoEhYKBmhlaWdo'
        'dBgEIAEoBVIGaGVpZ2h0EhIKBHNpemUYBSABKANSBHNpemUSHAoJdGh1bWJoYXNoGAYgASgJUg'
        'l0aHVtYmhhc2gSGAoHc3BvaWxlchgHIAEoCFIHc3BvaWxlchIaCghkdXJhdGlvbhgIIAEoBVII'
        'ZHVyYXRpb24SGgoIZmlsZU5hbWUYCSABKAlSCGZpbGVOYW1lEhoKCG1pbWVUeXBlGAogASgJUg'
        'htaW1lVHlwZRIaCgh3YXZlZm9ybRgLIAEoDFIId2F2ZWZvcm0SIgoEZmlsZRgMIAEoCzIOLmlw'
        'ZXJvbi52MS5DRE5SBGZpbGUSHgoKdGh1bWJDZG5JRBgNIAEoDFIKdGh1bWJDZG5JRBIsCgl0aH'
        'VtYkZpbGUYDiABKAsyDi5pcGVyb24udjEuQ0ROUgl0aHVtYkZpbGU=');

@$core.Deprecated('Use messageReplyToDescriptor instead')
const MessageReplyTo$json = {
  '1': 'MessageReplyTo',
  '2': [
    {'1': 'messageID', '3': 1, '4': 1, '5': 3, '10': 'messageID'},
    {'1': 'quoteText', '3': 2, '4': 1, '5': 9, '10': 'quoteText'},
    {'1': 'quoteEntities', '3': 3, '4': 3, '5': 11, '6': '.iperon.v1.MessageEntity', '10': 'quoteEntities'},
    {'1': 'quoteOffset', '3': 4, '4': 1, '5': 5, '10': 'quoteOffset'},
  ],
};

/// Descriptor for `MessageReplyTo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageReplyToDescriptor =
    $convert.base64Decode('Cg5NZXNzYWdlUmVwbHlUbxIcCgltZXNzYWdlSUQYASABKANSCW1lc3NhZ2VJRBIcCglxdW90ZV'
        'RleHQYAiABKAlSCXF1b3RlVGV4dBI+Cg1xdW90ZUVudGl0aWVzGAMgAygLMhguaXBlcm9uLnYx'
        'Lk1lc3NhZ2VFbnRpdHlSDXF1b3RlRW50aXRpZXMSIAoLcXVvdGVPZmZzZXQYBCABKAVSC3F1b3'
        'RlT2Zmc2V0');

@$core.Deprecated('Use messageForwardDescriptor instead')
const MessageForward$json = {
  '1': 'MessageForward',
  '2': [
    {'1': 'fromUserID', '3': 1, '4': 1, '5': 12, '10': 'fromUserID'},
    {'1': 'fromName', '3': 2, '4': 1, '5': 9, '10': 'fromName'},
    {'1': 'date', '3': 3, '4': 1, '5': 3, '10': 'date'},
  ],
};

/// Descriptor for `MessageForward`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageForwardDescriptor =
    $convert.base64Decode('Cg5NZXNzYWdlRm9yd2FyZBIeCgpmcm9tVXNlcklEGAEgASgMUgpmcm9tVXNlcklEEhoKCGZyb2'
        '1OYW1lGAIgASgJUghmcm9tTmFtZRISCgRkYXRlGAMgASgDUgRkYXRl');

@$core.Deprecated('Use messageCallDescriptor instead')
const MessageCall$json = {
  '1': 'MessageCall',
  '2': [
    {'1': 'callID', '3': 1, '4': 1, '5': 9, '10': 'callID'},
    {'1': 'video', '3': 2, '4': 1, '5': 8, '10': 'video'},
    {'1': 'outcome', '3': 3, '4': 1, '5': 14, '6': '.iperon.v1.MessageCall.Outcome', '10': 'outcome'},
    {'1': 'duration', '3': 4, '4': 1, '5': 5, '10': 'duration'},
  ],
  '4': [MessageCall_Outcome$json],
};

@$core.Deprecated('Use messageCallDescriptor instead')
const MessageCall_Outcome$json = {
  '1': 'Outcome',
  '2': [
    {'1': 'ENDED', '2': 0},
    {'1': 'MISSED', '2': 1},
    {'1': 'DECLINED', '2': 2},
    {'1': 'BUSY', '2': 3},
  ],
};

/// Descriptor for `MessageCall`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageCallDescriptor =
    $convert.base64Decode('CgtNZXNzYWdlQ2FsbBIWCgZjYWxsSUQYASABKAlSBmNhbGxJRBIUCgV2aWRlbxgCIAEoCFIFdm'
        'lkZW8SOAoHb3V0Y29tZRgDIAEoDjIeLmlwZXJvbi52MS5NZXNzYWdlQ2FsbC5PdXRjb21lUgdv'
        'dXRjb21lEhoKCGR1cmF0aW9uGAQgASgFUghkdXJhdGlvbiI4CgdPdXRjb21lEgkKBUVOREVEEA'
        'ASCgoGTUlTU0VEEAESDAoIREVDTElORUQQAhIICgRCVVNZEAM=');

@$core.Deprecated('Use messagePinDescriptor instead')
const MessagePin$json = {
  '1': 'MessagePin',
  '2': [
    {'1': 'messageID', '3': 1, '4': 1, '5': 3, '10': 'messageID'},
  ],
};

/// Descriptor for `MessagePin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messagePinDescriptor = $convert.base64Decode('CgpNZXNzYWdlUGluEhwKCW1lc3NhZ2VJRBgBIAEoA1IJbWVzc2FnZUlE');

@$core.Deprecated('Use messageContentDescriptor instead')
const MessageContent$json = {
  '1': 'MessageContent',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'entities', '3': 2, '4': 3, '5': 11, '6': '.iperon.v1.MessageEntity', '10': 'entities'},
    {'1': 'media', '3': 3, '4': 3, '5': 11, '6': '.iperon.v1.MessageMedia', '10': 'media'},
    {'1': 'replyTo', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.MessageReplyTo', '10': 'replyTo'},
    {'1': 'forward', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.MessageForward', '10': 'forward'},
    {'1': 'noLinkPreview', '3': 6, '4': 1, '5': 8, '10': 'noLinkPreview'},
    {'1': 'call', '3': 7, '4': 1, '5': 11, '6': '.iperon.v1.MessageCall', '10': 'call'},
    {'1': 'pin', '3': 8, '4': 1, '5': 11, '6': '.iperon.v1.MessagePin', '10': 'pin'},
  ],
};

/// Descriptor for `MessageContent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageContentDescriptor =
    $convert.base64Decode('Cg5NZXNzYWdlQ29udGVudBISCgR0ZXh0GAEgASgJUgR0ZXh0EjQKCGVudGl0aWVzGAIgAygLMh'
        'guaXBlcm9uLnYxLk1lc3NhZ2VFbnRpdHlSCGVudGl0aWVzEi0KBW1lZGlhGAMgAygLMhcuaXBl'
        'cm9uLnYxLk1lc3NhZ2VNZWRpYVIFbWVkaWESMwoHcmVwbHlUbxgEIAEoCzIZLmlwZXJvbi52MS'
        '5NZXNzYWdlUmVwbHlUb1IHcmVwbHlUbxIzCgdmb3J3YXJkGAUgASgLMhkuaXBlcm9uLnYxLk1l'
        'c3NhZ2VGb3J3YXJkUgdmb3J3YXJkEiQKDW5vTGlua1ByZXZpZXcYBiABKAhSDW5vTGlua1ByZX'
        'ZpZXcSKgoEY2FsbBgHIAEoCzIWLmlwZXJvbi52MS5NZXNzYWdlQ2FsbFIEY2FsbBInCgNwaW4Y'
        'CCABKAsyFS5pcGVyb24udjEuTWVzc2FnZVBpblIDcGlu');

@$core.Deprecated('Use messageReactionDescriptor instead')
const MessageReaction$json = {
  '1': 'MessageReaction',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'emoji', '3': 2, '4': 1, '5': 9, '10': 'emoji'},
    {'1': 'date', '3': 3, '4': 1, '5': 3, '10': 'date'},
  ],
};

/// Descriptor for `MessageReaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageReactionDescriptor =
    $convert.base64Decode('Cg9NZXNzYWdlUmVhY3Rpb24SFgoGdXNlcklEGAEgASgMUgZ1c2VySUQSFAoFZW1vamkYAiABKA'
        'lSBWVtb2ppEhIKBGRhdGUYAyABKANSBGRhdGU=');

@$core.Deprecated('Use messageReactionsDescriptor instead')
const MessageReactions$json = {
  '1': 'MessageReactions',
  '2': [
    {'1': 'reactions', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.MessageReaction', '10': 'reactions'},
  ],
};

/// Descriptor for `MessageReactions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageReactionsDescriptor =
    $convert.base64Decode('ChBNZXNzYWdlUmVhY3Rpb25zEjgKCXJlYWN0aW9ucxgBIAMoCzIaLmlwZXJvbi52MS5NZXNzYW'
        'dlUmVhY3Rpb25SCXJlYWN0aW9ucw==');

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = {
  '1': 'ChatMessage',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
    {'1': 'fromUserID', '3': 3, '4': 1, '5': 12, '10': 'fromUserID'},
    {'1': 'date', '3': 4, '4': 1, '5': 3, '10': 'date'},
    {'1': 'editDate', '3': 5, '4': 1, '5': 3, '10': 'editDate'},
    {'1': 'content', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.MessageContent', '10': 'content'},
    {'1': 'mediaUnread', '3': 7, '4': 1, '5': 8, '10': 'mediaUnread'},
    {'1': 'silent', '3': 8, '4': 1, '5': 8, '10': 'silent'},
    {'1': 'randomID', '3': 9, '4': 1, '5': 3, '10': 'randomID'},
    {'1': 'reactions', '3': 10, '4': 1, '5': 11, '6': '.iperon.v1.MessageReactions', '10': 'reactions'},
    {'1': 'reactionsUnread', '3': 11, '4': 1, '5': 8, '10': 'reactionsUnread'},
  ],
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor =
    $convert.base64Decode('CgtDaGF0TWVzc2FnZRIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIcCgltZXNzYWdlSUQYAiABKA'
        'NSCW1lc3NhZ2VJRBIeCgpmcm9tVXNlcklEGAMgASgMUgpmcm9tVXNlcklEEhIKBGRhdGUYBCAB'
        'KANSBGRhdGUSGgoIZWRpdERhdGUYBSABKANSCGVkaXREYXRlEjMKB2NvbnRlbnQYBiABKAsyGS'
        '5pcGVyb24udjEuTWVzc2FnZUNvbnRlbnRSB2NvbnRlbnQSIAoLbWVkaWFVbnJlYWQYByABKAhS'
        'C21lZGlhVW5yZWFkEhYKBnNpbGVudBgIIAEoCFIGc2lsZW50EhoKCHJhbmRvbUlEGAkgASgDUg'
        'hyYW5kb21JRBI5CglyZWFjdGlvbnMYCiABKAsyGy5pcGVyb24udjEuTWVzc2FnZVJlYWN0aW9u'
        'c1IJcmVhY3Rpb25zEigKD3JlYWN0aW9uc1VucmVhZBgLIAEoCFIPcmVhY3Rpb25zVW5yZWFk');

@$core.Deprecated('Use dialogDescriptor instead')
const Dialog$json = {
  '1': 'Dialog',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.iperon.v1.ChatType', '10': 'type'},
    {'1': 'peerUserID', '3': 3, '4': 1, '5': 12, '10': 'peerUserID'},
    {'1': 'topMessage', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.ChatMessage', '10': 'topMessage'},
    {'1': 'readInboxMaxID', '3': 5, '4': 1, '5': 3, '10': 'readInboxMaxID'},
    {'1': 'readOutboxMaxID', '3': 6, '4': 1, '5': 3, '10': 'readOutboxMaxID'},
    {'1': 'unreadCount', '3': 7, '4': 1, '5': 5, '10': 'unreadCount'},
    {'1': 'pinned', '3': 8, '4': 1, '5': 8, '10': 'pinned'},
    {'1': 'archived', '3': 9, '4': 1, '5': 8, '10': 'archived'},
    {'1': 'markedUnread', '3': 10, '4': 1, '5': 8, '10': 'markedUnread'},
    {'1': 'mutedUntil', '3': 11, '4': 1, '5': 3, '10': 'mutedUntil'},
    {'1': 'createdAt', '3': 12, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'unreadReactionsCount', '3': 13, '4': 1, '5': 5, '10': 'unreadReactionsCount'},
    {'1': 'draft', '3': 14, '4': 1, '5': 9, '10': 'draft'},
    {'1': 'draftDate', '3': 15, '4': 1, '5': 3, '10': 'draftDate'},
  ],
};

/// Descriptor for `Dialog`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dialogDescriptor =
    $convert.base64Decode('CgZEaWFsb2cSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSJwoEdHlwZRgCIAEoDjITLmlwZXJvbi'
        '52MS5DaGF0VHlwZVIEdHlwZRIeCgpwZWVyVXNlcklEGAMgASgMUgpwZWVyVXNlcklEEjYKCnRv'
        'cE1lc3NhZ2UYBCABKAsyFi5pcGVyb24udjEuQ2hhdE1lc3NhZ2VSCnRvcE1lc3NhZ2USJgoOcm'
        'VhZEluYm94TWF4SUQYBSABKANSDnJlYWRJbmJveE1heElEEigKD3JlYWRPdXRib3hNYXhJRBgG'
        'IAEoA1IPcmVhZE91dGJveE1heElEEiAKC3VucmVhZENvdW50GAcgASgFUgt1bnJlYWRDb3VudB'
        'IWCgZwaW5uZWQYCCABKAhSBnBpbm5lZBIaCghhcmNoaXZlZBgJIAEoCFIIYXJjaGl2ZWQSIgoM'
        'bWFya2VkVW5yZWFkGAogASgIUgxtYXJrZWRVbnJlYWQSHgoKbXV0ZWRVbnRpbBgLIAEoA1IKbX'
        'V0ZWRVbnRpbBIcCgljcmVhdGVkQXQYDCABKANSCWNyZWF0ZWRBdBIyChR1bnJlYWRSZWFjdGlv'
        'bnNDb3VudBgNIAEoBVIUdW5yZWFkUmVhY3Rpb25zQ291bnQSFAoFZHJhZnQYDiABKAlSBWRyYW'
        'Z0EhwKCWRyYWZ0RGF0ZRgPIAEoA1IJZHJhZnREYXRl');

@$core.Deprecated('Use scheduledMessageDescriptor instead')
const ScheduledMessage$json = {
  '1': 'ScheduledMessage',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'scheduledID', '3': 2, '4': 1, '5': 3, '10': 'scheduledID'},
    {'1': 'date', '3': 3, '4': 1, '5': 3, '10': 'date'},
    {'1': 'content', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.MessageContent', '10': 'content'},
    {'1': 'silent', '3': 5, '4': 1, '5': 8, '10': 'silent'},
    {'1': 'randomID', '3': 6, '4': 1, '5': 3, '10': 'randomID'},
  ],
};

/// Descriptor for `ScheduledMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduledMessageDescriptor =
    $convert.base64Decode('ChBTY2hlZHVsZWRNZXNzYWdlEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEiAKC3NjaGVkdWxlZE'
        'lEGAIgASgDUgtzY2hlZHVsZWRJRBISCgRkYXRlGAMgASgDUgRkYXRlEjMKB2NvbnRlbnQYBCAB'
        'KAsyGS5pcGVyb24udjEuTWVzc2FnZUNvbnRlbnRSB2NvbnRlbnQSFgoGc2lsZW50GAUgASgIUg'
        'ZzaWxlbnQSGgoIcmFuZG9tSUQYBiABKANSCHJhbmRvbUlE');

@$core.Deprecated('Use chatFolderDescriptor instead')
const ChatFolder$json = {
  '1': 'ChatFolder',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'includeContacts', '3': 3, '4': 1, '5': 8, '10': 'includeContacts'},
    {'1': 'includeNonContacts', '3': 4, '4': 1, '5': 8, '10': 'includeNonContacts'},
    {'1': 'includeGroups', '3': 5, '4': 1, '5': 8, '10': 'includeGroups'},
    {'1': 'includeChannels', '3': 6, '4': 1, '5': 8, '10': 'includeChannels'},
    {'1': 'includeCommunities', '3': 7, '4': 1, '5': 8, '10': 'includeCommunities'},
    {'1': 'includeChatIDs', '3': 8, '4': 3, '5': 12, '10': 'includeChatIDs'},
    {'1': 'excludeChatIDs', '3': 9, '4': 3, '5': 12, '10': 'excludeChatIDs'},
    {'1': 'excludeMuted', '3': 10, '4': 1, '5': 8, '10': 'excludeMuted'},
    {'1': 'excludeRead', '3': 11, '4': 1, '5': 8, '10': 'excludeRead'},
  ],
};

/// Descriptor for `ChatFolder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatFolderDescriptor =
    $convert.base64Decode('CgpDaGF0Rm9sZGVyEg4KAmlkGAEgASgFUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSKAoPaW'
        '5jbHVkZUNvbnRhY3RzGAMgASgIUg9pbmNsdWRlQ29udGFjdHMSLgoSaW5jbHVkZU5vbkNvbnRh'
        'Y3RzGAQgASgIUhJpbmNsdWRlTm9uQ29udGFjdHMSJAoNaW5jbHVkZUdyb3VwcxgFIAEoCFINaW'
        '5jbHVkZUdyb3VwcxIoCg9pbmNsdWRlQ2hhbm5lbHMYBiABKAhSD2luY2x1ZGVDaGFubmVscxIu'
        'ChJpbmNsdWRlQ29tbXVuaXRpZXMYByABKAhSEmluY2x1ZGVDb21tdW5pdGllcxImCg5pbmNsdW'
        'RlQ2hhdElEcxgIIAMoDFIOaW5jbHVkZUNoYXRJRHMSJgoOZXhjbHVkZUNoYXRJRHMYCSADKAxS'
        'DmV4Y2x1ZGVDaGF0SURzEiIKDGV4Y2x1ZGVNdXRlZBgKIAEoCFIMZXhjbHVkZU11dGVkEiAKC2'
        'V4Y2x1ZGVSZWFkGAsgASgIUgtleGNsdWRlUmVhZA==');

@$core.Deprecated('Use chatFoldersDescriptor instead')
const ChatFolders$json = {
  '1': 'ChatFolders',
  '2': [
    {'1': 'folders', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ChatFolder', '10': 'folders'},
    {'1': 'version', '3': 2, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `ChatFolders`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatFoldersDescriptor =
    $convert.base64Decode('CgtDaGF0Rm9sZGVycxIvCgdmb2xkZXJzGAEgAygLMhUuaXBlcm9uLnYxLkNoYXRGb2xkZXJSB2'
        'ZvbGRlcnMSGAoHdmVyc2lvbhgCIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use updatesStateDescriptor instead')
const UpdatesState$json = {
  '1': 'UpdatesState',
  '2': [
    {'1': 'pts', '3': 1, '4': 1, '5': 3, '10': 'pts'},
    {'1': 'date', '3': 2, '4': 1, '5': 3, '10': 'date'},
  ],
};

/// Descriptor for `UpdatesState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatesStateDescriptor =
    $convert.base64Decode('CgxVcGRhdGVzU3RhdGUSEAoDcHRzGAEgASgDUgNwdHMSEgoEZGF0ZRgCIAEoA1IEZGF0ZQ==');

@$core.Deprecated('Use updateDescriptor instead')
const Update$json = {
  '1': 'Update',
  '2': [
    {'1': 'pts', '3': 1, '4': 1, '5': 3, '10': 'pts'},
    {'1': 'date', '3': 2, '4': 1, '5': 3, '10': 'date'},
    {'1': 'newMessage', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.Update.NewMessage', '9': 0, '10': 'newMessage'},
    {'1': 'editMessage', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.Update.EditMessage', '9': 0, '10': 'editMessage'},
    {'1': 'deleteMessages', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.Update.DeleteMessages', '9': 0, '10': 'deleteMessages'},
    {'1': 'readInbox', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.Update.ReadInbox', '9': 0, '10': 'readInbox'},
    {'1': 'readOutbox', '3': 7, '4': 1, '5': 11, '6': '.iperon.v1.Update.ReadOutbox', '9': 0, '10': 'readOutbox'},
    {'1': 'readContents', '3': 8, '4': 1, '5': 11, '6': '.iperon.v1.Update.ReadContents', '9': 0, '10': 'readContents'},
    {'1': 'dialogSettings', '3': 9, '4': 1, '5': 11, '6': '.iperon.v1.Update.DialogSettings', '9': 0, '10': 'dialogSettings'},
    {'1': 'dialogDeleted', '3': 10, '4': 1, '5': 11, '6': '.iperon.v1.Update.DialogDeleted', '9': 0, '10': 'dialogDeleted'},
    {'1': 'pinnedMessages', '3': 11, '4': 1, '5': 11, '6': '.iperon.v1.Update.PinnedMessages', '9': 0, '10': 'pinnedMessages'},
    {'1': 'messageReactions', '3': 12, '4': 1, '5': 11, '6': '.iperon.v1.Update.MessageReactionsChanged', '9': 0, '10': 'messageReactions'},
    {'1': 'readReactions', '3': 13, '4': 1, '5': 11, '6': '.iperon.v1.Update.ReadReactions', '9': 0, '10': 'readReactions'},
    {'1': 'folders', '3': 14, '4': 1, '5': 11, '6': '.iperon.v1.ChatFolders', '9': 0, '10': 'folders'},
    {'1': 'scheduledMessage', '3': 15, '4': 1, '5': 11, '6': '.iperon.v1.Update.ScheduledMessageChanged', '9': 0, '10': 'scheduledMessage'},
    {'1': 'scheduledDeleted', '3': 16, '4': 1, '5': 11, '6': '.iperon.v1.Update.ScheduledDeleted', '9': 0, '10': 'scheduledDeleted'},
  ],
  '3': [
    Update_NewMessage$json,
    Update_EditMessage$json,
    Update_DeleteMessages$json,
    Update_ReadInbox$json,
    Update_ReadOutbox$json,
    Update_ReadContents$json,
    Update_DialogSettings$json,
    Update_DialogDeleted$json,
    Update_PinnedMessages$json,
    Update_MessageReactionsChanged$json,
    Update_ReadReactions$json,
    Update_ScheduledMessageChanged$json,
    Update_ScheduledDeleted$json
  ],
  '8': [
    {'1': 'update'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_NewMessage$json = {
  '1': 'NewMessage',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ChatMessage', '10': 'message'},
    {'1': 'dialog', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.Dialog', '10': 'dialog'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_EditMessage$json = {
  '1': 'EditMessage',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ChatMessage', '10': 'message'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_DeleteMessages$json = {
  '1': 'DeleteMessages',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageIDs', '3': 2, '4': 3, '5': 3, '10': 'messageIDs'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_ReadInbox$json = {
  '1': 'ReadInbox',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'maxID', '3': 2, '4': 1, '5': 3, '10': 'maxID'},
    {'1': 'unreadCount', '3': 3, '4': 1, '5': 5, '10': 'unreadCount'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_ReadOutbox$json = {
  '1': 'ReadOutbox',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'maxID', '3': 2, '4': 1, '5': 3, '10': 'maxID'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_ReadContents$json = {
  '1': 'ReadContents',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageIDs', '3': 2, '4': 3, '5': 3, '10': 'messageIDs'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_DialogSettings$json = {
  '1': 'DialogSettings',
  '2': [
    {'1': 'dialog', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Dialog', '10': 'dialog'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_DialogDeleted$json = {
  '1': 'DialogDeleted',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_PinnedMessages$json = {
  '1': 'PinnedMessages',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageIDs', '3': 2, '4': 3, '5': 3, '10': 'messageIDs'},
    {'1': 'pinned', '3': 3, '4': 1, '5': 8, '10': 'pinned'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_MessageReactionsChanged$json = {
  '1': 'MessageReactionsChanged',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
    {'1': 'reactions', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.MessageReactions', '10': 'reactions'},
    {'1': 'unreadReactionsCount', '3': 4, '4': 1, '5': 5, '10': 'unreadReactionsCount'},
    {'1': 'reactionsUnread', '3': 5, '4': 1, '5': 8, '10': 'reactionsUnread'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_ReadReactions$json = {
  '1': 'ReadReactions',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageIDs', '3': 2, '4': 3, '5': 3, '10': 'messageIDs'},
    {'1': 'unreadReactionsCount', '3': 3, '4': 1, '5': 5, '10': 'unreadReactionsCount'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_ScheduledMessageChanged$json = {
  '1': 'ScheduledMessageChanged',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ScheduledMessage', '10': 'message'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_ScheduledDeleted$json = {
  '1': 'ScheduledDeleted',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'scheduledIDs', '3': 2, '4': 3, '5': 3, '10': 'scheduledIDs'},
    {'1': 'reason', '3': 3, '4': 1, '5': 14, '6': '.iperon.v1.Update.ScheduledDeleted.Reason', '10': 'reason'},
  ],
  '4': [Update_ScheduledDeleted_Reason$json],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_ScheduledDeleted_Reason$json = {
  '1': 'Reason',
  '2': [
    {'1': 'DELETED', '2': 0},
    {'1': 'SENT', '2': 1},
    {'1': 'FAILED', '2': 2},
  ],
};

/// Descriptor for `Update`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDescriptor =
    $convert.base64Decode('CgZVcGRhdGUSEAoDcHRzGAEgASgDUgNwdHMSEgoEZGF0ZRgCIAEoA1IEZGF0ZRI+CgpuZXdNZX'
        'NzYWdlGAMgASgLMhwuaXBlcm9uLnYxLlVwZGF0ZS5OZXdNZXNzYWdlSABSCm5ld01lc3NhZ2US'
        'QQoLZWRpdE1lc3NhZ2UYBCABKAsyHS5pcGVyb24udjEuVXBkYXRlLkVkaXRNZXNzYWdlSABSC2'
        'VkaXRNZXNzYWdlEkoKDmRlbGV0ZU1lc3NhZ2VzGAUgASgLMiAuaXBlcm9uLnYxLlVwZGF0ZS5E'
        'ZWxldGVNZXNzYWdlc0gAUg5kZWxldGVNZXNzYWdlcxI7CglyZWFkSW5ib3gYBiABKAsyGy5pcG'
        'Vyb24udjEuVXBkYXRlLlJlYWRJbmJveEgAUglyZWFkSW5ib3gSPgoKcmVhZE91dGJveBgHIAEo'
        'CzIcLmlwZXJvbi52MS5VcGRhdGUuUmVhZE91dGJveEgAUgpyZWFkT3V0Ym94EkQKDHJlYWRDb2'
        '50ZW50cxgIIAEoCzIeLmlwZXJvbi52MS5VcGRhdGUuUmVhZENvbnRlbnRzSABSDHJlYWRDb250'
        'ZW50cxJKCg5kaWFsb2dTZXR0aW5ncxgJIAEoCzIgLmlwZXJvbi52MS5VcGRhdGUuRGlhbG9nU2'
        'V0dGluZ3NIAFIOZGlhbG9nU2V0dGluZ3MSRwoNZGlhbG9nRGVsZXRlZBgKIAEoCzIfLmlwZXJv'
        'bi52MS5VcGRhdGUuRGlhbG9nRGVsZXRlZEgAUg1kaWFsb2dEZWxldGVkEkoKDnBpbm5lZE1lc3'
        'NhZ2VzGAsgASgLMiAuaXBlcm9uLnYxLlVwZGF0ZS5QaW5uZWRNZXNzYWdlc0gAUg5waW5uZWRN'
        'ZXNzYWdlcxJXChBtZXNzYWdlUmVhY3Rpb25zGAwgASgLMikuaXBlcm9uLnYxLlVwZGF0ZS5NZX'
        'NzYWdlUmVhY3Rpb25zQ2hhbmdlZEgAUhBtZXNzYWdlUmVhY3Rpb25zEkcKDXJlYWRSZWFjdGlv'
        'bnMYDSABKAsyHy5pcGVyb24udjEuVXBkYXRlLlJlYWRSZWFjdGlvbnNIAFINcmVhZFJlYWN0aW'
        '9ucxIyCgdmb2xkZXJzGA4gASgLMhYuaXBlcm9uLnYxLkNoYXRGb2xkZXJzSABSB2ZvbGRlcnMS'
        'VwoQc2NoZWR1bGVkTWVzc2FnZRgPIAEoCzIpLmlwZXJvbi52MS5VcGRhdGUuU2NoZWR1bGVkTW'
        'Vzc2FnZUNoYW5nZWRIAFIQc2NoZWR1bGVkTWVzc2FnZRJQChBzY2hlZHVsZWREZWxldGVkGBAg'
        'ASgLMiIuaXBlcm9uLnYxLlVwZGF0ZS5TY2hlZHVsZWREZWxldGVkSABSEHNjaGVkdWxlZERlbG'
        'V0ZWQaaQoKTmV3TWVzc2FnZRIwCgdtZXNzYWdlGAEgASgLMhYuaXBlcm9uLnYxLkNoYXRNZXNz'
        'YWdlUgdtZXNzYWdlEikKBmRpYWxvZxgCIAEoCzIRLmlwZXJvbi52MS5EaWFsb2dSBmRpYWxvZx'
        'o/CgtFZGl0TWVzc2FnZRIwCgdtZXNzYWdlGAEgASgLMhYuaXBlcm9uLnYxLkNoYXRNZXNzYWdl'
        'UgdtZXNzYWdlGkgKDkRlbGV0ZU1lc3NhZ2VzEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEh4KCm'
        '1lc3NhZ2VJRHMYAiADKANSCm1lc3NhZ2VJRHMaWwoJUmVhZEluYm94EhYKBmNoYXRJRBgBIAEo'
        'DFIGY2hhdElEEhQKBW1heElEGAIgASgDUgVtYXhJRBIgCgt1bnJlYWRDb3VudBgDIAEoBVILdW'
        '5yZWFkQ291bnQaOgoKUmVhZE91dGJveBIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIUCgVtYXhJ'
        'RBgCIAEoA1IFbWF4SUQaRgoMUmVhZENvbnRlbnRzEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEh'
        '4KCm1lc3NhZ2VJRHMYAiADKANSCm1lc3NhZ2VJRHMaOwoORGlhbG9nU2V0dGluZ3MSKQoGZGlh'
        'bG9nGAEgASgLMhEuaXBlcm9uLnYxLkRpYWxvZ1IGZGlhbG9nGicKDURpYWxvZ0RlbGV0ZWQSFg'
        'oGY2hhdElEGAEgASgMUgZjaGF0SUQaYAoOUGlubmVkTWVzc2FnZXMSFgoGY2hhdElEGAEgASgM'
        'UgZjaGF0SUQSHgoKbWVzc2FnZUlEcxgCIAMoA1IKbWVzc2FnZUlEcxIWCgZwaW5uZWQYAyABKA'
        'hSBnBpbm5lZBroAQoXTWVzc2FnZVJlYWN0aW9uc0NoYW5nZWQSFgoGY2hhdElEGAEgASgMUgZj'
        'aGF0SUQSHAoJbWVzc2FnZUlEGAIgASgDUgltZXNzYWdlSUQSOQoJcmVhY3Rpb25zGAMgASgLMh'
        'suaXBlcm9uLnYxLk1lc3NhZ2VSZWFjdGlvbnNSCXJlYWN0aW9ucxIyChR1bnJlYWRSZWFjdGlv'
        'bnNDb3VudBgEIAEoBVIUdW5yZWFkUmVhY3Rpb25zQ291bnQSKAoPcmVhY3Rpb25zVW5yZWFkGA'
        'UgASgIUg9yZWFjdGlvbnNVbnJlYWQaewoNUmVhZFJlYWN0aW9ucxIWCgZjaGF0SUQYASABKAxS'
        'BmNoYXRJRBIeCgptZXNzYWdlSURzGAIgAygDUgptZXNzYWdlSURzEjIKFHVucmVhZFJlYWN0aW'
        '9uc0NvdW50GAMgASgFUhR1bnJlYWRSZWFjdGlvbnNDb3VudBpQChdTY2hlZHVsZWRNZXNzYWdl'
        'Q2hhbmdlZBI1CgdtZXNzYWdlGAEgASgLMhsuaXBlcm9uLnYxLlNjaGVkdWxlZE1lc3NhZ2VSB2'
        '1lc3NhZ2UavgEKEFNjaGVkdWxlZERlbGV0ZWQSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSIgoM'
        'c2NoZWR1bGVkSURzGAIgAygDUgxzY2hlZHVsZWRJRHMSQQoGcmVhc29uGAMgASgOMikuaXBlcm'
        '9uLnYxLlVwZGF0ZS5TY2hlZHVsZWREZWxldGVkLlJlYXNvblIGcmVhc29uIisKBlJlYXNvbhIL'
        'CgdERUxFVEVEEAASCAoEU0VOVBABEgoKBkZBSUxFRBACQggKBnVwZGF0ZQ==');

@$core.Deprecated('Use updatesDescriptor instead')
const Updates$json = {
  '1': 'Updates',
  '2': [
    {'1': 'updates', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Update', '10': 'updates'},
    {'1': 'state', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.UpdatesState', '10': 'state'},
  ],
};

/// Descriptor for `Updates`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatesDescriptor =
    $convert.base64Decode('CgdVcGRhdGVzEisKB3VwZGF0ZXMYASADKAsyES5pcGVyb24udjEuVXBkYXRlUgd1cGRhdGVzEi'
        '0KBXN0YXRlGAIgASgLMhcuaXBlcm9uLnYxLlVwZGF0ZXNTdGF0ZVIFc3RhdGU=');

@$core.Deprecated('Use chatsDescriptor instead')
const Chats$json = {
  '1': 'Chats',
  '3': [
    Chats_List$json,
    Chats_ListResult$json,
    Chats_OpenPrivate$json,
    Chats_OpenPrivateResult$json,
    Chats_ReadHistory$json,
    Chats_ReadHistoryResult$json,
    Chats_SetDialog$json,
    Chats_SetDialogResult$json,
    Chats_DeleteDialog$json,
    Chats_DeleteDialogResult$json,
    Chats_ReadDate$json,
    Chats_ReadDateResult$json,
    Chats_CanWrite$json,
    Chats_CanWriteResult$json,
    Chats_SaveDraft$json,
    Chats_SaveDraftResult$json,
    Chats_GetFolders$json,
    Chats_GetFoldersResult$json,
    Chats_SaveFolder$json,
    Chats_SaveFolderResult$json,
    Chats_DeleteFolder$json,
    Chats_DeleteFolderResult$json,
    Chats_ReorderFolders$json,
    Chats_ReorderFoldersResult$json,
    Chats_ResolveUsername$json,
    Chats_ResolveUsernameResult$json,
    Chats_Request$json,
    Chats_Response$json
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_List$json = {
  '1': 'List',
  '2': [
    {'1': 'offsetDate', '3': 1, '4': 1, '5': 3, '10': 'offsetDate'},
    {'1': 'offsetChatID', '3': 2, '4': 1, '5': 12, '10': 'offsetChatID'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ListResult$json = {
  '1': 'ListResult',
  '2': [
    {'1': 'dialogs', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Dialog', '10': 'dialogs'},
    {'1': 'hasMore', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
    {'1': 'state', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.UpdatesState', '10': 'state'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_OpenPrivate$json = {
  '1': 'OpenPrivate',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 12, '10': 'userID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_OpenPrivateResult$json = {
  '1': 'OpenPrivateResult',
  '2': [
    {'1': 'dialog', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Dialog', '10': 'dialog'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ReadHistory$json = {
  '1': 'ReadHistory',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'maxID', '3': 2, '4': 1, '5': 3, '10': 'maxID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ReadHistoryResult$json = {
  '1': 'ReadHistoryResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SetDialog$json = {
  '1': 'SetDialog',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'pinned', '3': 2, '4': 1, '5': 8, '9': 0, '10': 'pinned', '17': true},
    {'1': 'archived', '3': 3, '4': 1, '5': 8, '9': 1, '10': 'archived', '17': true},
    {'1': 'markedUnread', '3': 4, '4': 1, '5': 8, '9': 2, '10': 'markedUnread', '17': true},
    {'1': 'mutedUntil', '3': 5, '4': 1, '5': 3, '9': 3, '10': 'mutedUntil', '17': true},
  ],
  '8': [
    {'1': '_pinned'},
    {'1': '_archived'},
    {'1': '_markedUnread'},
    {'1': '_mutedUntil'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SetDialogResult$json = {
  '1': 'SetDialogResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_DeleteDialog$json = {
  '1': 'DeleteDialog',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'forEveryone', '3': 2, '4': 1, '5': 8, '10': 'forEveryone'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_DeleteDialogResult$json = {
  '1': 'DeleteDialogResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ReadDate$json = {
  '1': 'ReadDate',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ReadDateResult$json = {
  '1': 'ReadDateResult',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.Chats.ReadDateResult.Status', '10': 'status'},
    {'1': 'date', '3': 2, '4': 1, '5': 3, '10': 'date'},
  ],
  '4': [Chats_ReadDateResult_Status$json],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ReadDateResult_Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'READ', '2': 0},
    {'1': 'NOT_READ', '2': 1},
    {'1': 'HIDDEN', '2': 2},
    {'1': 'UNAVAILABLE', '2': 3},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_CanWrite$json = {
  '1': 'CanWrite',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_CanWriteResult$json = {
  '1': 'CanWriteResult',
  '2': [
    {'1': 'allowed', '3': 1, '4': 1, '5': 8, '10': 'allowed'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SaveDraft$json = {
  '1': 'SaveDraft',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SaveDraftResult$json = {
  '1': 'SaveDraftResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_GetFolders$json = {
  '1': 'GetFolders',
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_GetFoldersResult$json = {
  '1': 'GetFoldersResult',
  '2': [
    {'1': 'folders', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ChatFolders', '10': 'folders'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SaveFolder$json = {
  '1': 'SaveFolder',
  '2': [
    {'1': 'folder', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ChatFolder', '10': 'folder'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SaveFolderResult$json = {
  '1': 'SaveFolderResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
    {'1': 'id', '3': 2, '4': 1, '5': 5, '10': 'id'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_DeleteFolder$json = {
  '1': 'DeleteFolder',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_DeleteFolderResult$json = {
  '1': 'DeleteFolderResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ReorderFolders$json = {
  '1': 'ReorderFolders',
  '2': [
    {'1': 'ids', '3': 1, '4': 3, '5': 5, '10': 'ids'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ReorderFoldersResult$json = {
  '1': 'ReorderFoldersResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ResolveUsername$json = {
  '1': 'ResolveUsername',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ResolveUsernameResult$json = {
  '1': 'ResolveUsernameResult',
  '2': [
    {'1': 'dialog', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Dialog', '10': 'dialog'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'list', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Chats.List', '9': 0, '10': 'list'},
    {'1': 'openPrivate', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.Chats.OpenPrivate', '9': 0, '10': 'openPrivate'},
    {'1': 'readHistory', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ReadHistory', '9': 0, '10': 'readHistory'},
    {'1': 'setDialog', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SetDialog', '9': 0, '10': 'setDialog'},
    {'1': 'deleteDialog', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.Chats.DeleteDialog', '9': 0, '10': 'deleteDialog'},
    {'1': 'readDate', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ReadDate', '9': 0, '10': 'readDate'},
    {'1': 'canWrite', '3': 7, '4': 1, '5': 11, '6': '.iperon.v1.Chats.CanWrite', '9': 0, '10': 'canWrite'},
    {'1': 'saveDraft', '3': 8, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SaveDraft', '9': 0, '10': 'saveDraft'},
    {'1': 'getFolders', '3': 9, '4': 1, '5': 11, '6': '.iperon.v1.Chats.GetFolders', '9': 0, '10': 'getFolders'},
    {'1': 'saveFolder', '3': 10, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SaveFolder', '9': 0, '10': 'saveFolder'},
    {'1': 'deleteFolder', '3': 11, '4': 1, '5': 11, '6': '.iperon.v1.Chats.DeleteFolder', '9': 0, '10': 'deleteFolder'},
    {'1': 'reorderFolders', '3': 12, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ReorderFolders', '9': 0, '10': 'reorderFolders'},
    {'1': 'resolveUsername', '3': 13, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ResolveUsername', '9': 0, '10': 'resolveUsername'},
  ],
  '8': [
    {'1': 'request'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'list', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ListResult', '9': 0, '10': 'list'},
    {'1': 'openPrivate', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.Chats.OpenPrivateResult', '9': 0, '10': 'openPrivate'},
    {'1': 'readHistory', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ReadHistoryResult', '9': 0, '10': 'readHistory'},
    {'1': 'setDialog', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SetDialogResult', '9': 0, '10': 'setDialog'},
    {'1': 'deleteDialog', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.Chats.DeleteDialogResult', '9': 0, '10': 'deleteDialog'},
    {'1': 'readDate', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ReadDateResult', '9': 0, '10': 'readDate'},
    {'1': 'canWrite', '3': 7, '4': 1, '5': 11, '6': '.iperon.v1.Chats.CanWriteResult', '9': 0, '10': 'canWrite'},
    {'1': 'saveDraft', '3': 8, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SaveDraftResult', '9': 0, '10': 'saveDraft'},
    {'1': 'getFolders', '3': 9, '4': 1, '5': 11, '6': '.iperon.v1.Chats.GetFoldersResult', '9': 0, '10': 'getFolders'},
    {'1': 'saveFolder', '3': 10, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SaveFolderResult', '9': 0, '10': 'saveFolder'},
    {'1': 'deleteFolder', '3': 11, '4': 1, '5': 11, '6': '.iperon.v1.Chats.DeleteFolderResult', '9': 0, '10': 'deleteFolder'},
    {'1': 'reorderFolders', '3': 12, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ReorderFoldersResult', '9': 0, '10': 'reorderFolders'},
    {'1': 'resolveUsername', '3': 13, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ResolveUsernameResult', '9': 0, '10': 'resolveUsername'},
  ],
  '8': [
    {'1': 'response'},
  ],
};

/// Descriptor for `Chats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatsDescriptor =
    $convert.base64Decode('CgVDaGF0cxpgCgRMaXN0Eh4KCm9mZnNldERhdGUYASABKANSCm9mZnNldERhdGUSIgoMb2Zmc2'
        'V0Q2hhdElEGAIgASgMUgxvZmZzZXRDaGF0SUQSFAoFbGltaXQYAyABKAVSBWxpbWl0GoIBCgpM'
        'aXN0UmVzdWx0EisKB2RpYWxvZ3MYASADKAsyES5pcGVyb24udjEuRGlhbG9nUgdkaWFsb2dzEh'
        'gKB2hhc01vcmUYAiABKAhSB2hhc01vcmUSLQoFc3RhdGUYAyABKAsyFy5pcGVyb24udjEuVXBk'
        'YXRlc1N0YXRlUgVzdGF0ZRolCgtPcGVuUHJpdmF0ZRIWCgZ1c2VySUQYASABKAxSBnVzZXJJRB'
        'o+ChFPcGVuUHJpdmF0ZVJlc3VsdBIpCgZkaWFsb2cYASABKAsyES5pcGVyb24udjEuRGlhbG9n'
        'UgZkaWFsb2caOwoLUmVhZEhpc3RvcnkSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSFAoFbWF4SU'
        'QYAiABKANSBW1heElEGkEKEVJlYWRIaXN0b3J5UmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5p'
        'cGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxrnAQoJU2V0RGlhbG9nEhYKBmNoYXRJRBgBIAEoDF'
        'IGY2hhdElEEhsKBnBpbm5lZBgCIAEoCEgAUgZwaW5uZWSIAQESHwoIYXJjaGl2ZWQYAyABKAhI'
        'AVIIYXJjaGl2ZWSIAQESJwoMbWFya2VkVW5yZWFkGAQgASgISAJSDG1hcmtlZFVucmVhZIgBAR'
        'IjCgptdXRlZFVudGlsGAUgASgDSANSCm11dGVkVW50aWyIAQFCCQoHX3Bpbm5lZEILCglfYXJj'
        'aGl2ZWRCDwoNX21hcmtlZFVucmVhZEINCgtfbXV0ZWRVbnRpbBo/Cg9TZXREaWFsb2dSZXN1bH'
        'QSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzGkgKDERlbGV0'
        'ZURpYWxvZxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIgCgtmb3JFdmVyeW9uZRgCIAEoCFILZm'
        '9yRXZlcnlvbmUaQgoSRGVsZXRlRGlhbG9nUmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVy'
        'b24udjEuVXBkYXRlc1IHdXBkYXRlcxpACghSZWFkRGF0ZRIWCgZjaGF0SUQYASABKAxSBmNoYX'
        'RJRBIcCgltZXNzYWdlSUQYAiABKANSCW1lc3NhZ2VJRBqjAQoOUmVhZERhdGVSZXN1bHQSPgoG'
        'c3RhdHVzGAEgASgOMiYuaXBlcm9uLnYxLkNoYXRzLlJlYWREYXRlUmVzdWx0LlN0YXR1c1IGc3'
        'RhdHVzEhIKBGRhdGUYAiABKANSBGRhdGUiPQoGU3RhdHVzEggKBFJFQUQQABIMCghOT1RfUkVB'
        'RBABEgoKBkhJRERFThACEg8KC1VOQVZBSUxBQkxFEAMaIgoIQ2FuV3JpdGUSFgoGY2hhdElEGA'
        'EgASgMUgZjaGF0SUQaKgoOQ2FuV3JpdGVSZXN1bHQSGAoHYWxsb3dlZBgBIAEoCFIHYWxsb3dl'
        'ZBo3CglTYXZlRHJhZnQSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSEgoEdGV4dBgCIAEoCVIEdG'
        'V4dBo/Cg9TYXZlRHJhZnRSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRh'
        'dGVzUgd1cGRhdGVzGgwKCkdldEZvbGRlcnMaRAoQR2V0Rm9sZGVyc1Jlc3VsdBIwCgdmb2xkZX'
        'JzGAEgASgLMhYuaXBlcm9uLnYxLkNoYXRGb2xkZXJzUgdmb2xkZXJzGjsKClNhdmVGb2xkZXIS'
        'LQoGZm9sZGVyGAEgASgLMhUuaXBlcm9uLnYxLkNoYXRGb2xkZXJSBmZvbGRlchpQChBTYXZlRm'
        '9sZGVyUmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRl'
        'cxIOCgJpZBgCIAEoBVICaWQaHgoMRGVsZXRlRm9sZGVyEg4KAmlkGAEgASgFUgJpZBpCChJEZW'
        'xldGVGb2xkZXJSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1'
        'cGRhdGVzGiIKDlJlb3JkZXJGb2xkZXJzEhAKA2lkcxgBIAMoBVIDaWRzGkQKFFJlb3JkZXJGb2'
        'xkZXJzUmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRl'
        'cxotCg9SZXNvbHZlVXNlcm5hbWUSGgoIdXNlcm5hbWUYASABKAlSCHVzZXJuYW1lGkIKFVJlc2'
        '9sdmVVc2VybmFtZVJlc3VsdBIpCgZkaWFsb2cYASABKAsyES5pcGVyb24udjEuRGlhbG9nUgZk'
        'aWFsb2ca0AYKB1JlcXVlc3QSKwoEbGlzdBgBIAEoCzIVLmlwZXJvbi52MS5DaGF0cy5MaXN0SA'
        'BSBGxpc3QSQAoLb3BlblByaXZhdGUYAiABKAsyHC5pcGVyb24udjEuQ2hhdHMuT3BlblByaXZh'
        'dGVIAFILb3BlblByaXZhdGUSQAoLcmVhZEhpc3RvcnkYAyABKAsyHC5pcGVyb24udjEuQ2hhdH'
        'MuUmVhZEhpc3RvcnlIAFILcmVhZEhpc3RvcnkSOgoJc2V0RGlhbG9nGAQgASgLMhouaXBlcm9u'
        'LnYxLkNoYXRzLlNldERpYWxvZ0gAUglzZXREaWFsb2cSQwoMZGVsZXRlRGlhbG9nGAUgASgLMh'
        '0uaXBlcm9uLnYxLkNoYXRzLkRlbGV0ZURpYWxvZ0gAUgxkZWxldGVEaWFsb2cSNwoIcmVhZERh'
        'dGUYBiABKAsyGS5pcGVyb24udjEuQ2hhdHMuUmVhZERhdGVIAFIIcmVhZERhdGUSNwoIY2FuV3'
        'JpdGUYByABKAsyGS5pcGVyb24udjEuQ2hhdHMuQ2FuV3JpdGVIAFIIY2FuV3JpdGUSOgoJc2F2'
        'ZURyYWZ0GAggASgLMhouaXBlcm9uLnYxLkNoYXRzLlNhdmVEcmFmdEgAUglzYXZlRHJhZnQSPQ'
        'oKZ2V0Rm9sZGVycxgJIAEoCzIbLmlwZXJvbi52MS5DaGF0cy5HZXRGb2xkZXJzSABSCmdldEZv'
        'bGRlcnMSPQoKc2F2ZUZvbGRlchgKIAEoCzIbLmlwZXJvbi52MS5DaGF0cy5TYXZlRm9sZGVySA'
        'BSCnNhdmVGb2xkZXISQwoMZGVsZXRlRm9sZGVyGAsgASgLMh0uaXBlcm9uLnYxLkNoYXRzLkRl'
        'bGV0ZUZvbGRlckgAUgxkZWxldGVGb2xkZXISSQoOcmVvcmRlckZvbGRlcnMYDCABKAsyHy5pcG'
        'Vyb24udjEuQ2hhdHMuUmVvcmRlckZvbGRlcnNIAFIOcmVvcmRlckZvbGRlcnMSTAoPcmVzb2x2'
        'ZVVzZXJuYW1lGA0gASgLMiAuaXBlcm9uLnYxLkNoYXRzLlJlc29sdmVVc2VybmFtZUgAUg9yZX'
        'NvbHZlVXNlcm5hbWVCCQoHcmVxdWVzdBqgBwoIUmVzcG9uc2USMQoEbGlzdBgBIAEoCzIbLmlw'
        'ZXJvbi52MS5DaGF0cy5MaXN0UmVzdWx0SABSBGxpc3QSRgoLb3BlblByaXZhdGUYAiABKAsyIi'
        '5pcGVyb24udjEuQ2hhdHMuT3BlblByaXZhdGVSZXN1bHRIAFILb3BlblByaXZhdGUSRgoLcmVh'
        'ZEhpc3RvcnkYAyABKAsyIi5pcGVyb24udjEuQ2hhdHMuUmVhZEhpc3RvcnlSZXN1bHRIAFILcm'
        'VhZEhpc3RvcnkSQAoJc2V0RGlhbG9nGAQgASgLMiAuaXBlcm9uLnYxLkNoYXRzLlNldERpYWxv'
        'Z1Jlc3VsdEgAUglzZXREaWFsb2cSSQoMZGVsZXRlRGlhbG9nGAUgASgLMiMuaXBlcm9uLnYxLk'
        'NoYXRzLkRlbGV0ZURpYWxvZ1Jlc3VsdEgAUgxkZWxldGVEaWFsb2cSPQoIcmVhZERhdGUYBiAB'
        'KAsyHy5pcGVyb24udjEuQ2hhdHMuUmVhZERhdGVSZXN1bHRIAFIIcmVhZERhdGUSPQoIY2FuV3'
        'JpdGUYByABKAsyHy5pcGVyb24udjEuQ2hhdHMuQ2FuV3JpdGVSZXN1bHRIAFIIY2FuV3JpdGUS'
        'QAoJc2F2ZURyYWZ0GAggASgLMiAuaXBlcm9uLnYxLkNoYXRzLlNhdmVEcmFmdFJlc3VsdEgAUg'
        'lzYXZlRHJhZnQSQwoKZ2V0Rm9sZGVycxgJIAEoCzIhLmlwZXJvbi52MS5DaGF0cy5HZXRGb2xk'
        'ZXJzUmVzdWx0SABSCmdldEZvbGRlcnMSQwoKc2F2ZUZvbGRlchgKIAEoCzIhLmlwZXJvbi52MS'
        '5DaGF0cy5TYXZlRm9sZGVyUmVzdWx0SABSCnNhdmVGb2xkZXISSQoMZGVsZXRlRm9sZGVyGAsg'
        'ASgLMiMuaXBlcm9uLnYxLkNoYXRzLkRlbGV0ZUZvbGRlclJlc3VsdEgAUgxkZWxldGVGb2xkZX'
        'ISTwoOcmVvcmRlckZvbGRlcnMYDCABKAsyJS5pcGVyb24udjEuQ2hhdHMuUmVvcmRlckZvbGRl'
        'cnNSZXN1bHRIAFIOcmVvcmRlckZvbGRlcnMSUgoPcmVzb2x2ZVVzZXJuYW1lGA0gASgLMiYuaX'
        'Blcm9uLnYxLkNoYXRzLlJlc29sdmVVc2VybmFtZVJlc3VsdEgAUg9yZXNvbHZlVXNlcm5hbWVC'
        'CgoIcmVzcG9uc2U=');

@$core.Deprecated('Use messagesDescriptor instead')
const Messages$json = {
  '1': 'Messages',
  '3': [
    Messages_History$json,
    Messages_HistoryResult$json,
    Messages_Send$json,
    Messages_ForwardFrom$json,
    Messages_SendResult$json,
    Messages_Scheduled$json,
    Messages_ScheduledResult$json,
    Messages_SendScheduledNow$json,
    Messages_SendScheduledNowResult$json,
    Messages_Reschedule$json,
    Messages_RescheduleResult$json,
    Messages_DeleteScheduled$json,
    Messages_DeleteScheduledResult$json,
    Messages_Edit$json,
    Messages_EditResult$json,
    Messages_Delete$json,
    Messages_DeleteResult$json,
    Messages_ReadContents$json,
    Messages_ReadContentsResult$json,
    Messages_Pin$json,
    Messages_PinResult$json,
    Messages_UnpinAll$json,
    Messages_UnpinAllResult$json,
    Messages_Pinned$json,
    Messages_PinnedResult$json,
    Messages_SetReactions$json,
    Messages_SetReactionsResult$json,
    Messages_ReadReactions$json,
    Messages_ReadReactionsResult$json,
    Messages_UnreadReactions$json,
    Messages_UnreadReactionsResult$json,
    Messages_Get$json,
    Messages_GetResult$json,
    Messages_Request$json,
    Messages_Response$json
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_History$json = {
  '1': 'History',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'offsetID', '3': 2, '4': 1, '5': 3, '10': 'offsetID'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_HistoryResult$json = {
  '1': 'HistoryResult',
  '2': [
    {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ChatMessage', '10': 'messages'},
    {'1': 'hasMore', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_Send$json = {
  '1': 'Send',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'peerUserID', '3': 2, '4': 1, '5': 12, '10': 'peerUserID'},
    {'1': 'randomID', '3': 3, '4': 1, '5': 3, '10': 'randomID'},
    {'1': 'content', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.MessageContent', '10': 'content'},
    {'1': 'silent', '3': 5, '4': 1, '5': 8, '10': 'silent'},
    {'1': 'forwardFrom', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ForwardFrom', '10': 'forwardFrom'},
    {'1': 'scheduleDate', '3': 7, '4': 1, '5': 3, '10': 'scheduleDate'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ForwardFrom$json = {
  '1': 'ForwardFrom',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_SendResult$json = {
  '1': 'SendResult',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ChatMessage', '10': 'message'},
    {'1': 'updates', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
    {'1': 'scheduled', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.ScheduledMessage', '10': 'scheduled'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_Scheduled$json = {
  '1': 'Scheduled',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ScheduledResult$json = {
  '1': 'ScheduledResult',
  '2': [
    {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ScheduledMessage', '10': 'messages'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_SendScheduledNow$json = {
  '1': 'SendScheduledNow',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'scheduledIDs', '3': 2, '4': 3, '5': 3, '10': 'scheduledIDs'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_SendScheduledNowResult$json = {
  '1': 'SendScheduledNowResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_Reschedule$json = {
  '1': 'Reschedule',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'scheduledID', '3': 2, '4': 1, '5': 3, '10': 'scheduledID'},
    {'1': 'date', '3': 3, '4': 1, '5': 3, '10': 'date'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_RescheduleResult$json = {
  '1': 'RescheduleResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_DeleteScheduled$json = {
  '1': 'DeleteScheduled',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'scheduledIDs', '3': 2, '4': 3, '5': 3, '10': 'scheduledIDs'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_DeleteScheduledResult$json = {
  '1': 'DeleteScheduledResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_Edit$json = {
  '1': 'Edit',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'entities', '3': 4, '4': 3, '5': 11, '6': '.iperon.v1.MessageEntity', '10': 'entities'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_EditResult$json = {
  '1': 'EditResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_Delete$json = {
  '1': 'Delete',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageIDs', '3': 2, '4': 3, '5': 3, '10': 'messageIDs'},
    {'1': 'forEveryone', '3': 3, '4': 1, '5': 8, '10': 'forEveryone'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_DeleteResult$json = {
  '1': 'DeleteResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ReadContents$json = {
  '1': 'ReadContents',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageIDs', '3': 2, '4': 3, '5': 3, '10': 'messageIDs'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ReadContentsResult$json = {
  '1': 'ReadContentsResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_Pin$json = {
  '1': 'Pin',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
    {'1': 'pinned', '3': 3, '4': 1, '5': 8, '10': 'pinned'},
    {'1': 'forEveryone', '3': 4, '4': 1, '5': 8, '10': 'forEveryone'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_PinResult$json = {
  '1': 'PinResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_UnpinAll$json = {
  '1': 'UnpinAll',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'forEveryone', '3': 2, '4': 1, '5': 8, '10': 'forEveryone'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_UnpinAllResult$json = {
  '1': 'UnpinAllResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_Pinned$json = {
  '1': 'Pinned',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_PinnedResult$json = {
  '1': 'PinnedResult',
  '2': [
    {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ChatMessage', '10': 'messages'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_SetReactions$json = {
  '1': 'SetReactions',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
    {'1': 'emojis', '3': 3, '4': 3, '5': 9, '10': 'emojis'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_SetReactionsResult$json = {
  '1': 'SetReactionsResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ReadReactions$json = {
  '1': 'ReadReactions',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageIDs', '3': 2, '4': 3, '5': 3, '10': 'messageIDs'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ReadReactionsResult$json = {
  '1': 'ReadReactionsResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_UnreadReactions$json = {
  '1': 'UnreadReactions',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_UnreadReactionsResult$json = {
  '1': 'UnreadReactionsResult',
  '2': [
    {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ChatMessage', '10': 'messages'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_Get$json = {
  '1': 'Get',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageIDs', '3': 2, '4': 3, '5': 3, '10': 'messageIDs'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_GetResult$json = {
  '1': 'GetResult',
  '2': [
    {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ChatMessage', '10': 'messages'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'history', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Messages.History', '9': 0, '10': 'history'},
    {'1': 'send', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.Messages.Send', '9': 0, '10': 'send'},
    {'1': 'edit', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.Messages.Edit', '9': 0, '10': 'edit'},
    {'1': 'delete', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.Messages.Delete', '9': 0, '10': 'delete'},
    {'1': 'readContents', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ReadContents', '9': 0, '10': 'readContents'},
    {'1': 'pin', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.Messages.Pin', '9': 0, '10': 'pin'},
    {'1': 'unpinAll', '3': 7, '4': 1, '5': 11, '6': '.iperon.v1.Messages.UnpinAll', '9': 0, '10': 'unpinAll'},
    {'1': 'pinned', '3': 8, '4': 1, '5': 11, '6': '.iperon.v1.Messages.Pinned', '9': 0, '10': 'pinned'},
    {'1': 'setReactions', '3': 9, '4': 1, '5': 11, '6': '.iperon.v1.Messages.SetReactions', '9': 0, '10': 'setReactions'},
    {'1': 'readReactions', '3': 10, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ReadReactions', '9': 0, '10': 'readReactions'},
    {'1': 'unreadReactions', '3': 11, '4': 1, '5': 11, '6': '.iperon.v1.Messages.UnreadReactions', '9': 0, '10': 'unreadReactions'},
    {'1': 'scheduled', '3': 12, '4': 1, '5': 11, '6': '.iperon.v1.Messages.Scheduled', '9': 0, '10': 'scheduled'},
    {'1': 'sendScheduledNow', '3': 13, '4': 1, '5': 11, '6': '.iperon.v1.Messages.SendScheduledNow', '9': 0, '10': 'sendScheduledNow'},
    {'1': 'reschedule', '3': 14, '4': 1, '5': 11, '6': '.iperon.v1.Messages.Reschedule', '9': 0, '10': 'reschedule'},
    {'1': 'deleteScheduled', '3': 15, '4': 1, '5': 11, '6': '.iperon.v1.Messages.DeleteScheduled', '9': 0, '10': 'deleteScheduled'},
    {'1': 'get', '3': 16, '4': 1, '5': 11, '6': '.iperon.v1.Messages.Get', '9': 0, '10': 'get'},
  ],
  '8': [
    {'1': 'request'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'history', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Messages.HistoryResult', '9': 0, '10': 'history'},
    {'1': 'send', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.Messages.SendResult', '9': 0, '10': 'send'},
    {'1': 'edit', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.Messages.EditResult', '9': 0, '10': 'edit'},
    {'1': 'delete', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.Messages.DeleteResult', '9': 0, '10': 'delete'},
    {'1': 'readContents', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ReadContentsResult', '9': 0, '10': 'readContents'},
    {'1': 'pin', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.Messages.PinResult', '9': 0, '10': 'pin'},
    {'1': 'unpinAll', '3': 7, '4': 1, '5': 11, '6': '.iperon.v1.Messages.UnpinAllResult', '9': 0, '10': 'unpinAll'},
    {'1': 'pinned', '3': 8, '4': 1, '5': 11, '6': '.iperon.v1.Messages.PinnedResult', '9': 0, '10': 'pinned'},
    {'1': 'setReactions', '3': 9, '4': 1, '5': 11, '6': '.iperon.v1.Messages.SetReactionsResult', '9': 0, '10': 'setReactions'},
    {'1': 'readReactions', '3': 10, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ReadReactionsResult', '9': 0, '10': 'readReactions'},
    {'1': 'unreadReactions', '3': 11, '4': 1, '5': 11, '6': '.iperon.v1.Messages.UnreadReactionsResult', '9': 0, '10': 'unreadReactions'},
    {'1': 'scheduled', '3': 12, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ScheduledResult', '9': 0, '10': 'scheduled'},
    {
      '1': 'sendScheduledNow',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.Messages.SendScheduledNowResult',
      '9': 0,
      '10': 'sendScheduledNow'
    },
    {'1': 'reschedule', '3': 14, '4': 1, '5': 11, '6': '.iperon.v1.Messages.RescheduleResult', '9': 0, '10': 'reschedule'},
    {'1': 'deleteScheduled', '3': 15, '4': 1, '5': 11, '6': '.iperon.v1.Messages.DeleteScheduledResult', '9': 0, '10': 'deleteScheduled'},
    {'1': 'get', '3': 16, '4': 1, '5': 11, '6': '.iperon.v1.Messages.GetResult', '9': 0, '10': 'get'},
  ],
  '8': [
    {'1': 'response'},
  ],
};

/// Descriptor for `Messages`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messagesDescriptor =
    $convert.base64Decode('CghNZXNzYWdlcxpTCgdIaXN0b3J5EhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhoKCG9mZnNldE'
        'lEGAIgASgDUghvZmZzZXRJRBIUCgVsaW1pdBgDIAEoBVIFbGltaXQaXQoNSGlzdG9yeVJlc3Vs'
        'dBIyCghtZXNzYWdlcxgBIAMoCzIWLmlwZXJvbi52MS5DaGF0TWVzc2FnZVIIbWVzc2FnZXMSGA'
        'oHaGFzTW9yZRgCIAEoCFIHaGFzTW9yZRqOAgoEU2VuZBIWCgZjaGF0SUQYASABKAxSBmNoYXRJ'
        'RBIeCgpwZWVyVXNlcklEGAIgASgMUgpwZWVyVXNlcklEEhoKCHJhbmRvbUlEGAMgASgDUghyYW'
        '5kb21JRBIzCgdjb250ZW50GAQgASgLMhkuaXBlcm9uLnYxLk1lc3NhZ2VDb250ZW50Ugdjb250'
        'ZW50EhYKBnNpbGVudBgFIAEoCFIGc2lsZW50EkEKC2ZvcndhcmRGcm9tGAYgASgLMh8uaXBlcm'
        '9uLnYxLk1lc3NhZ2VzLkZvcndhcmRGcm9tUgtmb3J3YXJkRnJvbRIiCgxzY2hlZHVsZURhdGUY'
        'ByABKANSDHNjaGVkdWxlRGF0ZRpDCgtGb3J3YXJkRnJvbRIWCgZjaGF0SUQYASABKAxSBmNoYX'
        'RJRBIcCgltZXNzYWdlSUQYAiABKANSCW1lc3NhZ2VJRBqnAQoKU2VuZFJlc3VsdBIwCgdtZXNz'
        'YWdlGAEgASgLMhYuaXBlcm9uLnYxLkNoYXRNZXNzYWdlUgdtZXNzYWdlEiwKB3VwZGF0ZXMYAi'
        'ABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxI5CglzY2hlZHVsZWQYAyABKAsyGy5p'
        'cGVyb24udjEuU2NoZWR1bGVkTWVzc2FnZVIJc2NoZWR1bGVkGiMKCVNjaGVkdWxlZBIWCgZjaG'
        'F0SUQYASABKAxSBmNoYXRJRBpKCg9TY2hlZHVsZWRSZXN1bHQSNwoIbWVzc2FnZXMYASADKAsy'
        'Gy5pcGVyb24udjEuU2NoZWR1bGVkTWVzc2FnZVIIbWVzc2FnZXMaTgoQU2VuZFNjaGVkdWxlZE'
        '5vdxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIiCgxzY2hlZHVsZWRJRHMYAiADKANSDHNjaGVk'
        'dWxlZElEcxpGChZTZW5kU2NoZWR1bGVkTm93UmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcG'
        'Vyb24udjEuVXBkYXRlc1IHdXBkYXRlcxpaCgpSZXNjaGVkdWxlEhYKBmNoYXRJRBgBIAEoDFIG'
        'Y2hhdElEEiAKC3NjaGVkdWxlZElEGAIgASgDUgtzY2hlZHVsZWRJRBISCgRkYXRlGAMgASgDUg'
        'RkYXRlGkAKEFJlc2NoZWR1bGVSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5V'
        'cGRhdGVzUgd1cGRhdGVzGk0KD0RlbGV0ZVNjaGVkdWxlZBIWCgZjaGF0SUQYASABKAxSBmNoYX'
        'RJRBIiCgxzY2hlZHVsZWRJRHMYAiADKANSDHNjaGVkdWxlZElEcxpFChVEZWxldGVTY2hlZHVs'
        'ZWRSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzGo'
        'YBCgRFZGl0EhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhwKCW1lc3NhZ2VJRBgCIAEoA1IJbWVz'
        'c2FnZUlEEhIKBHRleHQYAyABKAlSBHRleHQSNAoIZW50aXRpZXMYBCADKAsyGC5pcGVyb24udj'
        'EuTWVzc2FnZUVudGl0eVIIZW50aXRpZXMaOgoKRWRpdFJlc3VsdBIsCgd1cGRhdGVzGAEgASgL'
        'MhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMaYgoGRGVsZXRlEhYKBmNoYXRJRBgBIAEoDF'
        'IGY2hhdElEEh4KCm1lc3NhZ2VJRHMYAiADKANSCm1lc3NhZ2VJRHMSIAoLZm9yRXZlcnlvbmUY'
        'AyABKAhSC2ZvckV2ZXJ5b25lGjwKDERlbGV0ZVJlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaX'
        'Blcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMaRgoMUmVhZENvbnRlbnRzEhYKBmNoYXRJRBgBIAEo'
        'DFIGY2hhdElEEh4KCm1lc3NhZ2VJRHMYAiADKANSCm1lc3NhZ2VJRHMaQgoSUmVhZENvbnRlbn'
        'RzUmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxp1'
        'CgNQaW4SFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSHAoJbWVzc2FnZUlEGAIgASgDUgltZXNzYW'
        'dlSUQSFgoGcGlubmVkGAMgASgIUgZwaW5uZWQSIAoLZm9yRXZlcnlvbmUYBCABKAhSC2ZvckV2'
        'ZXJ5b25lGjkKCVBpblJlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9uLnYxLlVwZGF0ZX'
        'NSB3VwZGF0ZXMaRAoIVW5waW5BbGwSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSIAoLZm9yRXZl'
        'cnlvbmUYAiABKAhSC2ZvckV2ZXJ5b25lGj4KDlVucGluQWxsUmVzdWx0EiwKB3VwZGF0ZXMYAS'
        'ABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxogCgZQaW5uZWQSFgoGY2hhdElEGAEg'
        'ASgMUgZjaGF0SUQaQgoMUGlubmVkUmVzdWx0EjIKCG1lc3NhZ2VzGAEgAygLMhYuaXBlcm9uLn'
        'YxLkNoYXRNZXNzYWdlUghtZXNzYWdlcxpcCgxTZXRSZWFjdGlvbnMSFgoGY2hhdElEGAEgASgM'
        'UgZjaGF0SUQSHAoJbWVzc2FnZUlEGAIgASgDUgltZXNzYWdlSUQSFgoGZW1vamlzGAMgAygJUg'
        'ZlbW9qaXMaQgoSU2V0UmVhY3Rpb25zUmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVyb24u'
        'djEuVXBkYXRlc1IHdXBkYXRlcxpHCg1SZWFkUmVhY3Rpb25zEhYKBmNoYXRJRBgBIAEoDFIGY2'
        'hhdElEEh4KCm1lc3NhZ2VJRHMYAiADKANSCm1lc3NhZ2VJRHMaQwoTUmVhZFJlYWN0aW9uc1Jl'
        'c3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMaPwoPVW'
        '5yZWFkUmVhY3Rpb25zEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhQKBWxpbWl0GAIgASgFUgVs'
        'aW1pdBpLChVVbnJlYWRSZWFjdGlvbnNSZXN1bHQSMgoIbWVzc2FnZXMYASADKAsyFi5pcGVyb2'
        '4udjEuQ2hhdE1lc3NhZ2VSCG1lc3NhZ2VzGj0KA0dldBIWCgZjaGF0SUQYASABKAxSBmNoYXRJ'
        'RBIeCgptZXNzYWdlSURzGAIgAygDUgptZXNzYWdlSURzGj8KCUdldFJlc3VsdBIyCghtZXNzYW'
        'dlcxgBIAMoCzIWLmlwZXJvbi52MS5DaGF0TWVzc2FnZVIIbWVzc2FnZXMagQgKB1JlcXVlc3QS'
        'NwoHaGlzdG9yeRgBIAEoCzIbLmlwZXJvbi52MS5NZXNzYWdlcy5IaXN0b3J5SABSB2hpc3Rvcn'
        'kSLgoEc2VuZBgCIAEoCzIYLmlwZXJvbi52MS5NZXNzYWdlcy5TZW5kSABSBHNlbmQSLgoEZWRp'
        'dBgDIAEoCzIYLmlwZXJvbi52MS5NZXNzYWdlcy5FZGl0SABSBGVkaXQSNAoGZGVsZXRlGAQgAS'
        'gLMhouaXBlcm9uLnYxLk1lc3NhZ2VzLkRlbGV0ZUgAUgZkZWxldGUSRgoMcmVhZENvbnRlbnRz'
        'GAUgASgLMiAuaXBlcm9uLnYxLk1lc3NhZ2VzLlJlYWRDb250ZW50c0gAUgxyZWFkQ29udGVudH'
        'MSKwoDcGluGAYgASgLMhcuaXBlcm9uLnYxLk1lc3NhZ2VzLlBpbkgAUgNwaW4SOgoIdW5waW5B'
        'bGwYByABKAsyHC5pcGVyb24udjEuTWVzc2FnZXMuVW5waW5BbGxIAFIIdW5waW5BbGwSNAoGcG'
        'lubmVkGAggASgLMhouaXBlcm9uLnYxLk1lc3NhZ2VzLlBpbm5lZEgAUgZwaW5uZWQSRgoMc2V0'
        'UmVhY3Rpb25zGAkgASgLMiAuaXBlcm9uLnYxLk1lc3NhZ2VzLlNldFJlYWN0aW9uc0gAUgxzZX'
        'RSZWFjdGlvbnMSSQoNcmVhZFJlYWN0aW9ucxgKIAEoCzIhLmlwZXJvbi52MS5NZXNzYWdlcy5S'
        'ZWFkUmVhY3Rpb25zSABSDXJlYWRSZWFjdGlvbnMSTwoPdW5yZWFkUmVhY3Rpb25zGAsgASgLMi'
        'MuaXBlcm9uLnYxLk1lc3NhZ2VzLlVucmVhZFJlYWN0aW9uc0gAUg91bnJlYWRSZWFjdGlvbnMS'
        'PQoJc2NoZWR1bGVkGAwgASgLMh0uaXBlcm9uLnYxLk1lc3NhZ2VzLlNjaGVkdWxlZEgAUglzY2'
        'hlZHVsZWQSUgoQc2VuZFNjaGVkdWxlZE5vdxgNIAEoCzIkLmlwZXJvbi52MS5NZXNzYWdlcy5T'
        'ZW5kU2NoZWR1bGVkTm93SABSEHNlbmRTY2hlZHVsZWROb3cSQAoKcmVzY2hlZHVsZRgOIAEoCz'
        'IeLmlwZXJvbi52MS5NZXNzYWdlcy5SZXNjaGVkdWxlSABSCnJlc2NoZWR1bGUSTwoPZGVsZXRl'
        'U2NoZWR1bGVkGA8gASgLMiMuaXBlcm9uLnYxLk1lc3NhZ2VzLkRlbGV0ZVNjaGVkdWxlZEgAUg'
        '9kZWxldGVTY2hlZHVsZWQSKwoDZ2V0GBAgASgLMhcuaXBlcm9uLnYxLk1lc3NhZ2VzLkdldEgA'
        'UgNnZXRCCQoHcmVxdWVzdBrjCAoIUmVzcG9uc2USPQoHaGlzdG9yeRgBIAEoCzIhLmlwZXJvbi'
        '52MS5NZXNzYWdlcy5IaXN0b3J5UmVzdWx0SABSB2hpc3RvcnkSNAoEc2VuZBgCIAEoCzIeLmlw'
        'ZXJvbi52MS5NZXNzYWdlcy5TZW5kUmVzdWx0SABSBHNlbmQSNAoEZWRpdBgDIAEoCzIeLmlwZX'
        'Jvbi52MS5NZXNzYWdlcy5FZGl0UmVzdWx0SABSBGVkaXQSOgoGZGVsZXRlGAQgASgLMiAuaXBl'
        'cm9uLnYxLk1lc3NhZ2VzLkRlbGV0ZVJlc3VsdEgAUgZkZWxldGUSTAoMcmVhZENvbnRlbnRzGA'
        'UgASgLMiYuaXBlcm9uLnYxLk1lc3NhZ2VzLlJlYWRDb250ZW50c1Jlc3VsdEgAUgxyZWFkQ29u'
        'dGVudHMSMQoDcGluGAYgASgLMh0uaXBlcm9uLnYxLk1lc3NhZ2VzLlBpblJlc3VsdEgAUgNwaW'
        '4SQAoIdW5waW5BbGwYByABKAsyIi5pcGVyb24udjEuTWVzc2FnZXMuVW5waW5BbGxSZXN1bHRI'
        'AFIIdW5waW5BbGwSOgoGcGlubmVkGAggASgLMiAuaXBlcm9uLnYxLk1lc3NhZ2VzLlBpbm5lZF'
        'Jlc3VsdEgAUgZwaW5uZWQSTAoMc2V0UmVhY3Rpb25zGAkgASgLMiYuaXBlcm9uLnYxLk1lc3Nh'
        'Z2VzLlNldFJlYWN0aW9uc1Jlc3VsdEgAUgxzZXRSZWFjdGlvbnMSTwoNcmVhZFJlYWN0aW9ucx'
        'gKIAEoCzInLmlwZXJvbi52MS5NZXNzYWdlcy5SZWFkUmVhY3Rpb25zUmVzdWx0SABSDXJlYWRS'
        'ZWFjdGlvbnMSVQoPdW5yZWFkUmVhY3Rpb25zGAsgASgLMikuaXBlcm9uLnYxLk1lc3NhZ2VzLl'
        'VucmVhZFJlYWN0aW9uc1Jlc3VsdEgAUg91bnJlYWRSZWFjdGlvbnMSQwoJc2NoZWR1bGVkGAwg'
        'ASgLMiMuaXBlcm9uLnYxLk1lc3NhZ2VzLlNjaGVkdWxlZFJlc3VsdEgAUglzY2hlZHVsZWQSWA'
        'oQc2VuZFNjaGVkdWxlZE5vdxgNIAEoCzIqLmlwZXJvbi52MS5NZXNzYWdlcy5TZW5kU2NoZWR1'
        'bGVkTm93UmVzdWx0SABSEHNlbmRTY2hlZHVsZWROb3cSRgoKcmVzY2hlZHVsZRgOIAEoCzIkLm'
        'lwZXJvbi52MS5NZXNzYWdlcy5SZXNjaGVkdWxlUmVzdWx0SABSCnJlc2NoZWR1bGUSVQoPZGVs'
        'ZXRlU2NoZWR1bGVkGA8gASgLMikuaXBlcm9uLnYxLk1lc3NhZ2VzLkRlbGV0ZVNjaGVkdWxlZF'
        'Jlc3VsdEgAUg9kZWxldGVTY2hlZHVsZWQSMQoDZ2V0GBAgASgLMh0uaXBlcm9uLnYxLk1lc3Nh'
        'Z2VzLkdldFJlc3VsdEgAUgNnZXRCCgoIcmVzcG9uc2U=');

@$core.Deprecated('Use getDifferenceDescriptor instead')
const GetDifference$json = {
  '1': 'GetDifference',
  '3': [GetDifference_Request$json, GetDifference_Response$json],
};

@$core.Deprecated('Use getDifferenceDescriptor instead')
const GetDifference_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'pts', '3': 1, '4': 1, '5': 3, '10': 'pts'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use getDifferenceDescriptor instead')
const GetDifference_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'updates', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Update', '10': 'updates'},
    {'1': 'state', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.UpdatesState', '10': 'state'},
    {'1': 'hasMore', '3': 3, '4': 1, '5': 8, '10': 'hasMore'},
    {'1': 'tooLong', '3': 4, '4': 1, '5': 8, '10': 'tooLong'},
  ],
};

/// Descriptor for `GetDifference`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDifferenceDescriptor =
    $convert.base64Decode('Cg1HZXREaWZmZXJlbmNlGjEKB1JlcXVlc3QSEAoDcHRzGAEgASgDUgNwdHMSFAoFbGltaXQYAi'
        'ABKAVSBWxpbWl0GpoBCghSZXNwb25zZRIrCgd1cGRhdGVzGAEgAygLMhEuaXBlcm9uLnYxLlVw'
        'ZGF0ZVIHdXBkYXRlcxItCgVzdGF0ZRgCIAEoCzIXLmlwZXJvbi52MS5VcGRhdGVzU3RhdGVSBX'
        'N0YXRlEhgKB2hhc01vcmUYAyABKAhSB2hhc01vcmUSGAoHdG9vTG9uZxgEIAEoCFIHdG9vTG9u'
        'Zw==');
