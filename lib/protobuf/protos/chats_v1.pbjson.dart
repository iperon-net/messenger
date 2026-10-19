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

@$core.Deprecated('Use chatRoleDescriptor instead')
const ChatRole$json = {
  '1': 'ChatRole',
  '2': [
    {'1': 'CHAT_ROLE_NONE', '2': 0},
    {'1': 'CHAT_ROLE_READER', '2': 1},
    {'1': 'CHAT_ROLE_WRITER', '2': 2},
    {'1': 'CHAT_ROLE_ADMIN', '2': 3},
    {'1': 'CHAT_ROLE_OWNER', '2': 4},
  ],
};

/// Descriptor for `ChatRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List chatRoleDescriptor =
    $convert.base64Decode('CghDaGF0Um9sZRISCg5DSEFUX1JPTEVfTk9ORRAAEhQKEENIQVRfUk9MRV9SRUFERVIQARIUCh'
        'BDSEFUX1JPTEVfV1JJVEVSEAISEwoPQ0hBVF9ST0xFX0FETUlOEAMSEwoPQ0hBVF9ST0xFX09X'
        'TkVSEAQ=');

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

@$core.Deprecated('Use chatInfoDescriptor instead')
const ChatInfo$json = {
  '1': 'ChatInfo',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.iperon.v1.ChatType', '10': 'type'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'about', '3': 4, '4': 1, '5': 9, '10': 'about'},
    {'1': 'avatarCdnID', '3': 5, '4': 1, '5': 12, '10': 'avatarCdnID'},
    {'1': 'avatar', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.CDN', '10': 'avatar'},
    {'1': 'membersCount', '3': 7, '4': 1, '5': 5, '10': 'membersCount'},
    {'1': 'ownerUserID', '3': 8, '4': 1, '5': 12, '10': 'ownerUserID'},
    {'1': 'pts', '3': 9, '4': 1, '5': 3, '10': 'pts'},
    {'1': 'createdAt', '3': 10, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'defaultRole', '3': 11, '4': 1, '5': 14, '6': '.iperon.v1.ChatRole', '10': 'defaultRole'},
  ],
};

/// Descriptor for `ChatInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatInfoDescriptor =
    $convert.base64Decode('CghDaGF0SW5mbxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBInCgR0eXBlGAIgASgOMhMuaXBlcm'
        '9uLnYxLkNoYXRUeXBlUgR0eXBlEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIUCgVhYm91dBgEIAEo'
        'CVIFYWJvdXQSIAoLYXZhdGFyQ2RuSUQYBSABKAxSC2F2YXRhckNkbklEEiYKBmF2YXRhchgGIA'
        'EoCzIOLmlwZXJvbi52MS5DRE5SBmF2YXRhchIiCgxtZW1iZXJzQ291bnQYByABKAVSDG1lbWJl'
        'cnNDb3VudBIgCgtvd25lclVzZXJJRBgIIAEoDFILb3duZXJVc2VySUQSEAoDcHRzGAkgASgDUg'
        'NwdHMSHAoJY3JlYXRlZEF0GAogASgDUgljcmVhdGVkQXQSNQoLZGVmYXVsdFJvbGUYCyABKA4y'
        'Ey5pcGVyb24udjEuQ2hhdFJvbGVSC2RlZmF1bHRSb2xl');

@$core.Deprecated('Use chatAdminRightsDescriptor instead')
const ChatAdminRights$json = {
  '1': 'ChatAdminRights',
  '2': [
    {'1': 'changeInfo', '3': 1, '4': 1, '5': 8, '10': 'changeInfo'},
    {'1': 'postMessages', '3': 2, '4': 1, '5': 8, '10': 'postMessages'},
    {'1': 'editMessages', '3': 3, '4': 1, '5': 8, '10': 'editMessages'},
    {'1': 'deleteMessages', '3': 4, '4': 1, '5': 8, '10': 'deleteMessages'},
    {'1': 'banUsers', '3': 5, '4': 1, '5': 8, '10': 'banUsers'},
    {'1': 'inviteUsers', '3': 6, '4': 1, '5': 8, '10': 'inviteUsers'},
    {'1': 'pinMessages', '3': 7, '4': 1, '5': 8, '10': 'pinMessages'},
    {'1': 'manageCalls', '3': 8, '4': 1, '5': 8, '10': 'manageCalls'},
    {'1': 'anonymous', '3': 9, '4': 1, '5': 8, '10': 'anonymous'},
    {'1': 'addAdmins', '3': 10, '4': 1, '5': 8, '10': 'addAdmins'},
  ],
};

/// Descriptor for `ChatAdminRights`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatAdminRightsDescriptor =
    $convert.base64Decode('Cg9DaGF0QWRtaW5SaWdodHMSHgoKY2hhbmdlSW5mbxgBIAEoCFIKY2hhbmdlSW5mbxIiCgxwb3'
        'N0TWVzc2FnZXMYAiABKAhSDHBvc3RNZXNzYWdlcxIiCgxlZGl0TWVzc2FnZXMYAyABKAhSDGVk'
        'aXRNZXNzYWdlcxImCg5kZWxldGVNZXNzYWdlcxgEIAEoCFIOZGVsZXRlTWVzc2FnZXMSGgoIYm'
        'FuVXNlcnMYBSABKAhSCGJhblVzZXJzEiAKC2ludml0ZVVzZXJzGAYgASgIUgtpbnZpdGVVc2Vy'
        'cxIgCgtwaW5NZXNzYWdlcxgHIAEoCFILcGluTWVzc2FnZXMSIAoLbWFuYWdlQ2FsbHMYCCABKA'
        'hSC21hbmFnZUNhbGxzEhwKCWFub255bW91cxgJIAEoCFIJYW5vbnltb3VzEhwKCWFkZEFkbWlu'
        'cxgKIAEoCFIJYWRkQWRtaW5z');

@$core.Deprecated('Use chatMemberDescriptor instead')
const ChatMember$json = {
  '1': 'ChatMember',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'role', '3': 2, '4': 1, '5': 14, '6': '.iperon.v1.ChatRole', '10': 'role'},
    {'1': 'joinedAt', '3': 3, '4': 1, '5': 3, '10': 'joinedAt'},
    {'1': 'inviterUserID', '3': 4, '4': 1, '5': 12, '10': 'inviterUserID'},
    {'1': 'rights', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.ChatAdminRights', '10': 'rights'},
    {'1': 'rank', '3': 6, '4': 1, '5': 9, '10': 'rank'},
    {'1': 'promotedByUserID', '3': 7, '4': 1, '5': 12, '10': 'promotedByUserID'},
  ],
};

/// Descriptor for `ChatMember`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMemberDescriptor =
    $convert.base64Decode('CgpDaGF0TWVtYmVyEhYKBnVzZXJJRBgBIAEoDFIGdXNlcklEEicKBHJvbGUYAiABKA4yEy5pcG'
        'Vyb24udjEuQ2hhdFJvbGVSBHJvbGUSGgoIam9pbmVkQXQYAyABKANSCGpvaW5lZEF0EiQKDWlu'
        'dml0ZXJVc2VySUQYBCABKAxSDWludml0ZXJVc2VySUQSMgoGcmlnaHRzGAUgASgLMhouaXBlcm'
        '9uLnYxLkNoYXRBZG1pblJpZ2h0c1IGcmlnaHRzEhIKBHJhbmsYBiABKAlSBHJhbmsSKgoQcHJv'
        'bW90ZWRCeVVzZXJJRBgHIAEoDFIQcHJvbW90ZWRCeVVzZXJJRA==');

@$core.Deprecated('Use chatBannedMemberDescriptor instead')
const ChatBannedMember$json = {
  '1': 'ChatBannedMember',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'bannedByUserID', '3': 2, '4': 1, '5': 12, '10': 'bannedByUserID'},
    {'1': 'date', '3': 3, '4': 1, '5': 3, '10': 'date'},
  ],
};

/// Descriptor for `ChatBannedMember`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatBannedMemberDescriptor =
    $convert.base64Decode('ChBDaGF0QmFubmVkTWVtYmVyEhYKBnVzZXJJRBgBIAEoDFIGdXNlcklEEiYKDmJhbm5lZEJ5VX'
        'NlcklEGAIgASgMUg5iYW5uZWRCeVVzZXJJRBISCgRkYXRlGAMgASgDUgRkYXRl');

@$core.Deprecated('Use messageChatActionDescriptor instead')
const MessageChatAction$json = {
  '1': 'MessageChatAction',
  '2': [
    {'1': 'kind', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.MessageChatAction.Kind', '10': 'kind'},
    {'1': 'userIDs', '3': 2, '4': 3, '5': 12, '10': 'userIDs'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
  ],
  '4': [MessageChatAction_Kind$json],
};

@$core.Deprecated('Use messageChatActionDescriptor instead')
const MessageChatAction_Kind$json = {
  '1': 'Kind',
  '2': [
    {'1': 'CREATED', '2': 0},
    {'1': 'ADDED', '2': 1},
    {'1': 'JOINED', '2': 2},
    {'1': 'LEFT', '2': 3},
    {'1': 'REMOVED', '2': 4},
    {'1': 'TITLE_CHANGED', '2': 5},
    {'1': 'PHOTO_CHANGED', '2': 6},
    {'1': 'PHOTO_REMOVED', '2': 7},
    {'1': 'OWNER_CHANGED', '2': 8},
  ],
};

/// Descriptor for `MessageChatAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageChatActionDescriptor =
    $convert.base64Decode('ChFNZXNzYWdlQ2hhdEFjdGlvbhI1CgRraW5kGAEgASgOMiEuaXBlcm9uLnYxLk1lc3NhZ2VDaG'
        'F0QWN0aW9uLktpbmRSBGtpbmQSGAoHdXNlcklEcxgCIAMoDFIHdXNlcklEcxIUCgV0aXRsZRgD'
        'IAEoCVIFdGl0bGUijQEKBEtpbmQSCwoHQ1JFQVRFRBAAEgkKBUFEREVEEAESCgoGSk9JTkVEEA'
        'ISCAoETEVGVBADEgsKB1JFTU9WRUQQBBIRCg1USVRMRV9DSEFOR0VEEAUSEQoNUEhPVE9fQ0hB'
        'TkdFRBAGEhEKDVBIT1RPX1JFTU9WRUQQBxIRCg1PV05FUl9DSEFOR0VEEAg=');

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

@$core.Deprecated('Use messageTTLChangedDescriptor instead')
const MessageTTLChanged$json = {
  '1': 'MessageTTLChanged',
  '2': [
    {'1': 'period', '3': 1, '4': 1, '5': 5, '10': 'period'},
    {'1': 'auto', '3': 2, '4': 1, '5': 8, '10': 'auto'},
  ],
};

/// Descriptor for `MessageTTLChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageTTLChangedDescriptor =
    $convert.base64Decode('ChFNZXNzYWdlVFRMQ2hhbmdlZBIWCgZwZXJpb2QYASABKAVSBnBlcmlvZBISCgRhdXRvGAIgAS'
        'gIUgRhdXRv');

@$core.Deprecated('Use messageNoForwardsDescriptor instead')
const MessageNoForwards$json = {
  '1': 'MessageNoForwards',
  '2': [
    {'1': 'prevValue', '3': 1, '4': 1, '5': 8, '10': 'prevValue'},
    {'1': 'newValue', '3': 2, '4': 1, '5': 8, '10': 'newValue'},
    {'1': 'requestID', '3': 3, '4': 1, '5': 3, '10': 'requestID'},
  ],
};

/// Descriptor for `MessageNoForwards`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageNoForwardsDescriptor =
    $convert.base64Decode('ChFNZXNzYWdlTm9Gb3J3YXJkcxIcCglwcmV2VmFsdWUYASABKAhSCXByZXZWYWx1ZRIaCghuZX'
        'dWYWx1ZRgCIAEoCFIIbmV3VmFsdWUSHAoJcmVxdWVzdElEGAMgASgDUglyZXF1ZXN0SUQ=');

@$core.Deprecated('Use messageNoForwardsRequestDescriptor instead')
const MessageNoForwardsRequest$json = {
  '1': 'MessageNoForwardsRequest',
  '2': [
    {'1': 'prevValue', '3': 1, '4': 1, '5': 8, '10': 'prevValue'},
    {'1': 'newValue', '3': 2, '4': 1, '5': 8, '10': 'newValue'},
  ],
};

/// Descriptor for `MessageNoForwardsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageNoForwardsRequestDescriptor =
    $convert.base64Decode('ChhNZXNzYWdlTm9Gb3J3YXJkc1JlcXVlc3QSHAoJcHJldlZhbHVlGAEgASgIUglwcmV2VmFsdW'
        'USGgoIbmV3VmFsdWUYAiABKAhSCG5ld1ZhbHVl');

@$core.Deprecated('Use chatTypingDescriptor instead')
const ChatTyping$json = {
  '1': 'ChatTyping',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'userID', '3': 2, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'action', '3': 3, '4': 1, '5': 14, '6': '.iperon.v1.ChatTyping.Action', '10': 'action'},
  ],
  '4': [ChatTyping_Action$json],
};

@$core.Deprecated('Use chatTypingDescriptor instead')
const ChatTyping_Action$json = {
  '1': 'Action',
  '2': [
    {'1': 'CANCEL', '2': 0},
    {'1': 'TYPING', '2': 1},
    {'1': 'RECORD_VOICE', '2': 2},
    {'1': 'UPLOAD_PHOTO', '2': 3},
    {'1': 'UPLOAD_VIDEO', '2': 4},
    {'1': 'UPLOAD_FILE', '2': 5},
  ],
};

/// Descriptor for `ChatTyping`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatTypingDescriptor =
    $convert.base64Decode('CgpDaGF0VHlwaW5nEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhYKBnVzZXJJRBgCIAEoDFIGdX'
        'NlcklEEjQKBmFjdGlvbhgDIAEoDjIcLmlwZXJvbi52MS5DaGF0VHlwaW5nLkFjdGlvblIGYWN0'
        'aW9uImcKBkFjdGlvbhIKCgZDQU5DRUwQABIKCgZUWVBJTkcQARIQCgxSRUNPUkRfVk9JQ0UQAh'
        'IQCgxVUExPQURfUEhPVE8QAxIQCgxVUExPQURfVklERU8QBBIPCgtVUExPQURfRklMRRAF');

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
    {'1': 'ttlChanged', '3': 9, '4': 1, '5': 11, '6': '.iperon.v1.MessageTTLChanged', '10': 'ttlChanged'},
    {'1': 'noForwards', '3': 10, '4': 1, '5': 11, '6': '.iperon.v1.MessageNoForwards', '10': 'noForwards'},
    {'1': 'noForwardsRequest', '3': 11, '4': 1, '5': 11, '6': '.iperon.v1.MessageNoForwardsRequest', '10': 'noForwardsRequest'},
    {'1': 'chatAction', '3': 12, '4': 1, '5': 11, '6': '.iperon.v1.MessageChatAction', '10': 'chatAction'},
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
        'CCABKAsyFS5pcGVyb24udjEuTWVzc2FnZVBpblIDcGluEjwKCnR0bENoYW5nZWQYCSABKAsyHC'
        '5pcGVyb24udjEuTWVzc2FnZVRUTENoYW5nZWRSCnR0bENoYW5nZWQSPAoKbm9Gb3J3YXJkcxgK'
        'IAEoCzIcLmlwZXJvbi52MS5NZXNzYWdlTm9Gb3J3YXJkc1IKbm9Gb3J3YXJkcxJRChFub0Zvcn'
        'dhcmRzUmVxdWVzdBgLIAEoCzIjLmlwZXJvbi52MS5NZXNzYWdlTm9Gb3J3YXJkc1JlcXVlc3RS'
        'EW5vRm9yd2FyZHNSZXF1ZXN0EjwKCmNoYXRBY3Rpb24YDCABKAsyHC5pcGVyb24udjEuTWVzc2'
        'FnZUNoYXRBY3Rpb25SCmNoYXRBY3Rpb24=');

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
    {'1': 'ttlPeriod', '3': 12, '4': 1, '5': 5, '10': 'ttlPeriod'},
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
        'c1IJcmVhY3Rpb25zEigKD3JlYWN0aW9uc1VucmVhZBgLIAEoCFIPcmVhY3Rpb25zVW5yZWFkEh'
        'wKCXR0bFBlcmlvZBgMIAEoBVIJdHRsUGVyaW9k');

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
    {'1': 'ttlPeriod', '3': 16, '4': 1, '5': 5, '10': 'ttlPeriod'},
    {'1': 'noForwards', '3': 17, '4': 1, '5': 8, '10': 'noForwards'},
    {'1': 'noForwardsMine', '3': 18, '4': 1, '5': 8, '10': 'noForwardsMine'},
    {'1': 'chat', '3': 19, '4': 1, '5': 11, '6': '.iperon.v1.ChatInfo', '10': 'chat'},
    {'1': 'role', '3': 20, '4': 1, '5': 14, '6': '.iperon.v1.ChatRole', '10': 'role'},
    {'1': 'rights', '3': 21, '4': 1, '5': 11, '6': '.iperon.v1.ChatAdminRights', '10': 'rights'},
    {'1': 'rank', '3': 22, '4': 1, '5': 9, '10': 'rank'},
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
        'Z0EhwKCWRyYWZ0RGF0ZRgPIAEoA1IJZHJhZnREYXRlEhwKCXR0bFBlcmlvZBgQIAEoBVIJdHRs'
        'UGVyaW9kEh4KCm5vRm9yd2FyZHMYESABKAhSCm5vRm9yd2FyZHMSJgoObm9Gb3J3YXJkc01pbm'
        'UYEiABKAhSDm5vRm9yd2FyZHNNaW5lEicKBGNoYXQYEyABKAsyEy5pcGVyb24udjEuQ2hhdElu'
        'Zm9SBGNoYXQSJwoEcm9sZRgUIAEoDjITLmlwZXJvbi52MS5DaGF0Um9sZVIEcm9sZRIyCgZyaW'
        'dodHMYFSABKAsyGi5pcGVyb24udjEuQ2hhdEFkbWluUmlnaHRzUgZyaWdodHMSEgoEcmFuaxgW'
        'IAEoCVIEcmFuaw==');

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
    {'1': 'chatPts', '3': 50, '4': 1, '5': 3, '10': 'chatPts'},
    {'1': 'chatID', '3': 51, '4': 1, '5': 12, '10': 'chatID'},
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
    {'1': 'chatInfo', '3': 17, '4': 1, '5': 11, '6': '.iperon.v1.Update.ChatInfoChanged', '9': 0, '10': 'chatInfo'},
    {'1': 'chatMembers', '3': 18, '4': 1, '5': 11, '6': '.iperon.v1.Update.ChatMembersChanged', '9': 0, '10': 'chatMembers'},
    {'1': 'dialogNew', '3': 19, '4': 1, '5': 11, '6': '.iperon.v1.Update.DialogNew', '9': 0, '10': 'dialogNew'},
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
    Update_ScheduledDeleted$json,
    Update_ChatInfoChanged$json,
    Update_ChatMembersChanged$json,
    Update_DialogNew$json
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
    {'1': 'shared', '3': 4, '4': 1, '5': 8, '10': 'shared'},
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

@$core.Deprecated('Use updateDescriptor instead')
const Update_ChatInfoChanged$json = {
  '1': 'ChatInfoChanged',
  '2': [
    {'1': 'chat', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ChatInfo', '10': 'chat'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_ChatMembersChanged$json = {
  '1': 'ChatMembersChanged',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'added', '3': 2, '4': 3, '5': 11, '6': '.iperon.v1.ChatMember', '10': 'added'},
    {'1': 'removedUserIDs', '3': 3, '4': 3, '5': 12, '10': 'removedUserIDs'},
    {'1': 'membersCount', '3': 4, '4': 1, '5': 5, '10': 'membersCount'},
    {'1': 'updated', '3': 5, '4': 3, '5': 11, '6': '.iperon.v1.ChatMember', '10': 'updated'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_DialogNew$json = {
  '1': 'DialogNew',
  '2': [
    {'1': 'dialog', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Dialog', '10': 'dialog'},
  ],
};

/// Descriptor for `Update`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDescriptor =
    $convert.base64Decode('CgZVcGRhdGUSEAoDcHRzGAEgASgDUgNwdHMSEgoEZGF0ZRgCIAEoA1IEZGF0ZRIYCgdjaGF0UH'
        'RzGDIgASgDUgdjaGF0UHRzEhYKBmNoYXRJRBgzIAEoDFIGY2hhdElEEj4KCm5ld01lc3NhZ2UY'
        'AyABKAsyHC5pcGVyb24udjEuVXBkYXRlLk5ld01lc3NhZ2VIAFIKbmV3TWVzc2FnZRJBCgtlZG'
        'l0TWVzc2FnZRgEIAEoCzIdLmlwZXJvbi52MS5VcGRhdGUuRWRpdE1lc3NhZ2VIAFILZWRpdE1l'
        'c3NhZ2USSgoOZGVsZXRlTWVzc2FnZXMYBSABKAsyIC5pcGVyb24udjEuVXBkYXRlLkRlbGV0ZU'
        '1lc3NhZ2VzSABSDmRlbGV0ZU1lc3NhZ2VzEjsKCXJlYWRJbmJveBgGIAEoCzIbLmlwZXJvbi52'
        'MS5VcGRhdGUuUmVhZEluYm94SABSCXJlYWRJbmJveBI+CgpyZWFkT3V0Ym94GAcgASgLMhwuaX'
        'Blcm9uLnYxLlVwZGF0ZS5SZWFkT3V0Ym94SABSCnJlYWRPdXRib3gSRAoMcmVhZENvbnRlbnRz'
        'GAggASgLMh4uaXBlcm9uLnYxLlVwZGF0ZS5SZWFkQ29udGVudHNIAFIMcmVhZENvbnRlbnRzEk'
        'oKDmRpYWxvZ1NldHRpbmdzGAkgASgLMiAuaXBlcm9uLnYxLlVwZGF0ZS5EaWFsb2dTZXR0aW5n'
        'c0gAUg5kaWFsb2dTZXR0aW5ncxJHCg1kaWFsb2dEZWxldGVkGAogASgLMh8uaXBlcm9uLnYxLl'
        'VwZGF0ZS5EaWFsb2dEZWxldGVkSABSDWRpYWxvZ0RlbGV0ZWQSSgoOcGlubmVkTWVzc2FnZXMY'
        'CyABKAsyIC5pcGVyb24udjEuVXBkYXRlLlBpbm5lZE1lc3NhZ2VzSABSDnBpbm5lZE1lc3NhZ2'
        'VzElcKEG1lc3NhZ2VSZWFjdGlvbnMYDCABKAsyKS5pcGVyb24udjEuVXBkYXRlLk1lc3NhZ2VS'
        'ZWFjdGlvbnNDaGFuZ2VkSABSEG1lc3NhZ2VSZWFjdGlvbnMSRwoNcmVhZFJlYWN0aW9ucxgNIA'
        'EoCzIfLmlwZXJvbi52MS5VcGRhdGUuUmVhZFJlYWN0aW9uc0gAUg1yZWFkUmVhY3Rpb25zEjIK'
        'B2ZvbGRlcnMYDiABKAsyFi5pcGVyb24udjEuQ2hhdEZvbGRlcnNIAFIHZm9sZGVycxJXChBzY2'
        'hlZHVsZWRNZXNzYWdlGA8gASgLMikuaXBlcm9uLnYxLlVwZGF0ZS5TY2hlZHVsZWRNZXNzYWdl'
        'Q2hhbmdlZEgAUhBzY2hlZHVsZWRNZXNzYWdlElAKEHNjaGVkdWxlZERlbGV0ZWQYECABKAsyIi'
        '5pcGVyb24udjEuVXBkYXRlLlNjaGVkdWxlZERlbGV0ZWRIAFIQc2NoZWR1bGVkRGVsZXRlZBI/'
        'CghjaGF0SW5mbxgRIAEoCzIhLmlwZXJvbi52MS5VcGRhdGUuQ2hhdEluZm9DaGFuZ2VkSABSCG'
        'NoYXRJbmZvEkgKC2NoYXRNZW1iZXJzGBIgASgLMiQuaXBlcm9uLnYxLlVwZGF0ZS5DaGF0TWVt'
        'YmVyc0NoYW5nZWRIAFILY2hhdE1lbWJlcnMSOwoJZGlhbG9nTmV3GBMgASgLMhsuaXBlcm9uLn'
        'YxLlVwZGF0ZS5EaWFsb2dOZXdIAFIJZGlhbG9nTmV3GmkKCk5ld01lc3NhZ2USMAoHbWVzc2Fn'
        'ZRgBIAEoCzIWLmlwZXJvbi52MS5DaGF0TWVzc2FnZVIHbWVzc2FnZRIpCgZkaWFsb2cYAiABKA'
        'syES5pcGVyb24udjEuRGlhbG9nUgZkaWFsb2caPwoLRWRpdE1lc3NhZ2USMAoHbWVzc2FnZRgB'
        'IAEoCzIWLmlwZXJvbi52MS5DaGF0TWVzc2FnZVIHbWVzc2FnZRpICg5EZWxldGVNZXNzYWdlcx'
        'IWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIeCgptZXNzYWdlSURzGAIgAygDUgptZXNzYWdlSURz'
        'GlsKCVJlYWRJbmJveBIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIUCgVtYXhJRBgCIAEoA1IFbW'
        'F4SUQSIAoLdW5yZWFkQ291bnQYAyABKAVSC3VucmVhZENvdW50GjoKClJlYWRPdXRib3gSFgoG'
        'Y2hhdElEGAEgASgMUgZjaGF0SUQSFAoFbWF4SUQYAiABKANSBW1heElEGkYKDFJlYWRDb250ZW'
        '50cxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIeCgptZXNzYWdlSURzGAIgAygDUgptZXNzYWdl'
        'SURzGjsKDkRpYWxvZ1NldHRpbmdzEikKBmRpYWxvZxgBIAEoCzIRLmlwZXJvbi52MS5EaWFsb2'
        'dSBmRpYWxvZxonCg1EaWFsb2dEZWxldGVkEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEGngKDlBp'
        'bm5lZE1lc3NhZ2VzEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEh4KCm1lc3NhZ2VJRHMYAiADKA'
        'NSCm1lc3NhZ2VJRHMSFgoGcGlubmVkGAMgASgIUgZwaW5uZWQSFgoGc2hhcmVkGAQgASgIUgZz'
        'aGFyZWQa6AEKF01lc3NhZ2VSZWFjdGlvbnNDaGFuZ2VkEhYKBmNoYXRJRBgBIAEoDFIGY2hhdE'
        'lEEhwKCW1lc3NhZ2VJRBgCIAEoA1IJbWVzc2FnZUlEEjkKCXJlYWN0aW9ucxgDIAEoCzIbLmlw'
        'ZXJvbi52MS5NZXNzYWdlUmVhY3Rpb25zUglyZWFjdGlvbnMSMgoUdW5yZWFkUmVhY3Rpb25zQ2'
        '91bnQYBCABKAVSFHVucmVhZFJlYWN0aW9uc0NvdW50EigKD3JlYWN0aW9uc1VucmVhZBgFIAEo'
        'CFIPcmVhY3Rpb25zVW5yZWFkGnsKDVJlYWRSZWFjdGlvbnMSFgoGY2hhdElEGAEgASgMUgZjaG'
        'F0SUQSHgoKbWVzc2FnZUlEcxgCIAMoA1IKbWVzc2FnZUlEcxIyChR1bnJlYWRSZWFjdGlvbnND'
        'b3VudBgDIAEoBVIUdW5yZWFkUmVhY3Rpb25zQ291bnQaUAoXU2NoZWR1bGVkTWVzc2FnZUNoYW'
        '5nZWQSNQoHbWVzc2FnZRgBIAEoCzIbLmlwZXJvbi52MS5TY2hlZHVsZWRNZXNzYWdlUgdtZXNz'
        'YWdlGr4BChBTY2hlZHVsZWREZWxldGVkEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEiIKDHNjaG'
        'VkdWxlZElEcxgCIAMoA1IMc2NoZWR1bGVkSURzEkEKBnJlYXNvbhgDIAEoDjIpLmlwZXJvbi52'
        'MS5VcGRhdGUuU2NoZWR1bGVkRGVsZXRlZC5SZWFzb25SBnJlYXNvbiIrCgZSZWFzb24SCwoHRE'
        'VMRVRFRBAAEggKBFNFTlQQARIKCgZGQUlMRUQQAho6Cg9DaGF0SW5mb0NoYW5nZWQSJwoEY2hh'
        'dBgBIAEoCzITLmlwZXJvbi52MS5DaGF0SW5mb1IEY2hhdBrWAQoSQ2hhdE1lbWJlcnNDaGFuZ2'
        'VkEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEisKBWFkZGVkGAIgAygLMhUuaXBlcm9uLnYxLkNo'
        'YXRNZW1iZXJSBWFkZGVkEiYKDnJlbW92ZWRVc2VySURzGAMgAygMUg5yZW1vdmVkVXNlcklEcx'
        'IiCgxtZW1iZXJzQ291bnQYBCABKAVSDG1lbWJlcnNDb3VudBIvCgd1cGRhdGVkGAUgAygLMhUu'
        'aXBlcm9uLnYxLkNoYXRNZW1iZXJSB3VwZGF0ZWQaNgoJRGlhbG9nTmV3EikKBmRpYWxvZxgBIA'
        'EoCzIRLmlwZXJvbi52MS5EaWFsb2dSBmRpYWxvZ0IICgZ1cGRhdGU=');

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
    Chats_SetTTL$json,
    Chats_SetTTLResult$json,
    Chats_SetNoForwards$json,
    Chats_SetNoForwardsResult$json,
    Chats_SearchUsers$json,
    Chats_SearchUsersResult$json,
    Chats_CreateGroup$json,
    Chats_CreateGroupResult$json,
    Chats_EditChat$json,
    Chats_EditChatResult$json,
    Chats_AddMembers$json,
    Chats_AddMembersResult$json,
    Chats_LeaveChat$json,
    Chats_LeaveChatResult$json,
    Chats_DeleteChat$json,
    Chats_DeleteChatResult$json,
    Chats_Members$json,
    Chats_MembersResult$json,
    Chats_GetChatsState$json,
    Chats_ChatPts$json,
    Chats_GetChatsStateResult$json,
    Chats_GetChatDifference$json,
    Chats_GetChatDifferenceResult$json,
    Chats_SetMemberRole$json,
    Chats_SetMemberRoleResult$json,
    Chats_RemoveMember$json,
    Chats_RemoveMemberResult$json,
    Chats_Banned$json,
    Chats_BannedResult$json,
    Chats_Unban$json,
    Chats_UnbanResult$json,
    Chats_SetAdmin$json,
    Chats_SetAdminResult$json,
    Chats_RemoveAdmin$json,
    Chats_RemoveAdminResult$json,
    Chats_TransferOwnership$json,
    Chats_TransferOwnershipResult$json,
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
const Chats_SetTTL$json = {
  '1': 'SetTTL',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'period', '3': 2, '4': 1, '5': 5, '10': 'period'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SetTTLResult$json = {
  '1': 'SetTTLResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SetNoForwards$json = {
  '1': 'SetNoForwards',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'enabled', '3': 2, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'requestID', '3': 3, '4': 1, '5': 3, '10': 'requestID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SetNoForwardsResult$json = {
  '1': 'SetNoForwardsResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SearchUsers$json = {
  '1': 'SearchUsers',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SearchUsersResult$json = {
  '1': 'SearchUsersResult',
  '2': [
    {'1': 'profiles', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Profile.Response', '10': 'profiles'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_CreateGroup$json = {
  '1': 'CreateGroup',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'about', '3': 2, '4': 1, '5': 9, '10': 'about'},
    {'1': 'memberUserIDs', '3': 3, '4': 3, '5': 12, '10': 'memberUserIDs'},
    {'1': 'avatarCdnID', '3': 4, '4': 1, '5': 12, '10': 'avatarCdnID'},
    {'1': 'randomID', '3': 5, '4': 1, '5': 3, '10': 'randomID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_CreateGroupResult$json = {
  '1': 'CreateGroupResult',
  '2': [
    {'1': 'dialog', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Dialog', '10': 'dialog'},
    {'1': 'restrictedUserIDs', '3': 2, '4': 3, '5': 12, '10': 'restrictedUserIDs'},
    {'1': 'updates', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_EditChat$json = {
  '1': 'EditChat',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'title', '17': true},
    {'1': 'about', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'about', '17': true},
    {'1': 'avatarCdnID', '3': 4, '4': 1, '5': 12, '9': 2, '10': 'avatarCdnID', '17': true},
    {'1': 'defaultRole', '3': 5, '4': 1, '5': 14, '6': '.iperon.v1.ChatRole', '9': 3, '10': 'defaultRole', '17': true},
  ],
  '8': [
    {'1': '_title'},
    {'1': '_about'},
    {'1': '_avatarCdnID'},
    {'1': '_defaultRole'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_EditChatResult$json = {
  '1': 'EditChatResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_AddMembers$json = {
  '1': 'AddMembers',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'userIDs', '3': 2, '4': 3, '5': 12, '10': 'userIDs'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_AddMembersResult$json = {
  '1': 'AddMembersResult',
  '2': [
    {'1': 'restrictedUserIDs', '3': 1, '4': 3, '5': 12, '10': 'restrictedUserIDs'},
    {'1': 'updates', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_LeaveChat$json = {
  '1': 'LeaveChat',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_LeaveChatResult$json = {
  '1': 'LeaveChatResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_DeleteChat$json = {
  '1': 'DeleteChat',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_DeleteChatResult$json = {
  '1': 'DeleteChatResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_Members$json = {
  '1': 'Members',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'offset', '3': 2, '4': 1, '5': 12, '10': 'offset'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_MembersResult$json = {
  '1': 'MembersResult',
  '2': [
    {'1': 'members', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ChatMember', '10': 'members'},
    {'1': 'profiles', '3': 2, '4': 3, '5': 11, '6': '.iperon.v1.Profile.Response', '10': 'profiles'},
    {'1': 'nextOffset', '3': 3, '4': 1, '5': 12, '10': 'nextOffset'},
    {'1': 'total', '3': 4, '4': 1, '5': 5, '10': 'total'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_GetChatsState$json = {
  '1': 'GetChatsState',
  '2': [
    {'1': 'chats', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Chats.ChatPts', '10': 'chats'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ChatPts$json = {
  '1': 'ChatPts',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'pts', '3': 2, '4': 1, '5': 3, '10': 'pts'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_GetChatsStateResult$json = {
  '1': 'GetChatsStateResult',
  '2': [
    {'1': 'changed', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Chats.ChatPts', '10': 'changed'},
    {'1': 'gone', '3': 2, '4': 3, '5': 12, '10': 'gone'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_GetChatDifference$json = {
  '1': 'GetChatDifference',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'pts', '3': 2, '4': 1, '5': 3, '10': 'pts'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_GetChatDifferenceResult$json = {
  '1': 'GetChatDifferenceResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Update', '10': 'updates'},
    {'1': 'pts', '3': 2, '4': 1, '5': 3, '10': 'pts'},
    {'1': 'hasMore', '3': 3, '4': 1, '5': 8, '10': 'hasMore'},
    {'1': 'tooLong', '3': 4, '4': 1, '5': 8, '10': 'tooLong'},
    {'1': 'dialog', '3': 5, '4': 1, '5': 11, '6': '.iperon.v1.Dialog', '10': 'dialog'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SetMemberRole$json = {
  '1': 'SetMemberRole',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'userID', '3': 2, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'role', '3': 3, '4': 1, '5': 14, '6': '.iperon.v1.ChatRole', '10': 'role'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SetMemberRoleResult$json = {
  '1': 'SetMemberRoleResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_RemoveMember$json = {
  '1': 'RemoveMember',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'userID', '3': 2, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'ban', '3': 3, '4': 1, '5': 8, '10': 'ban'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_RemoveMemberResult$json = {
  '1': 'RemoveMemberResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_Banned$json = {
  '1': 'Banned',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'offset', '3': 2, '4': 1, '5': 12, '10': 'offset'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_BannedResult$json = {
  '1': 'BannedResult',
  '2': [
    {'1': 'banned', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ChatBannedMember', '10': 'banned'},
    {'1': 'profiles', '3': 2, '4': 3, '5': 11, '6': '.iperon.v1.Profile.Response', '10': 'profiles'},
    {'1': 'nextOffset', '3': 3, '4': 1, '5': 12, '10': 'nextOffset'},
    {'1': 'total', '3': 4, '4': 1, '5': 5, '10': 'total'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_Unban$json = {
  '1': 'Unban',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'userID', '3': 2, '4': 1, '5': 12, '10': 'userID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_UnbanResult$json = {
  '1': 'UnbanResult',
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SetAdmin$json = {
  '1': 'SetAdmin',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'userID', '3': 2, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'rights', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.ChatAdminRights', '10': 'rights'},
    {'1': 'rank', '3': 4, '4': 1, '5': 9, '10': 'rank'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SetAdminResult$json = {
  '1': 'SetAdminResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_RemoveAdmin$json = {
  '1': 'RemoveAdmin',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'userID', '3': 2, '4': 1, '5': 12, '10': 'userID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_RemoveAdminResult$json = {
  '1': 'RemoveAdminResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_TransferOwnership$json = {
  '1': 'TransferOwnership',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'userID', '3': 2, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'pwHash', '3': 3, '4': 1, '5': 12, '10': 'pwHash'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_TransferOwnershipResult$json = {
  '1': 'TransferOwnershipResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
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
    {'1': 'setTTL', '3': 14, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SetTTL', '9': 0, '10': 'setTTL'},
    {'1': 'setNoForwards', '3': 15, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SetNoForwards', '9': 0, '10': 'setNoForwards'},
    {'1': 'searchUsers', '3': 16, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SearchUsers', '9': 0, '10': 'searchUsers'},
    {'1': 'createGroup', '3': 17, '4': 1, '5': 11, '6': '.iperon.v1.Chats.CreateGroup', '9': 0, '10': 'createGroup'},
    {'1': 'editChat', '3': 18, '4': 1, '5': 11, '6': '.iperon.v1.Chats.EditChat', '9': 0, '10': 'editChat'},
    {'1': 'addMembers', '3': 19, '4': 1, '5': 11, '6': '.iperon.v1.Chats.AddMembers', '9': 0, '10': 'addMembers'},
    {'1': 'leaveChat', '3': 20, '4': 1, '5': 11, '6': '.iperon.v1.Chats.LeaveChat', '9': 0, '10': 'leaveChat'},
    {'1': 'deleteChat', '3': 21, '4': 1, '5': 11, '6': '.iperon.v1.Chats.DeleteChat', '9': 0, '10': 'deleteChat'},
    {'1': 'members', '3': 22, '4': 1, '5': 11, '6': '.iperon.v1.Chats.Members', '9': 0, '10': 'members'},
    {'1': 'getChatsState', '3': 23, '4': 1, '5': 11, '6': '.iperon.v1.Chats.GetChatsState', '9': 0, '10': 'getChatsState'},
    {'1': 'getChatDifference', '3': 24, '4': 1, '5': 11, '6': '.iperon.v1.Chats.GetChatDifference', '9': 0, '10': 'getChatDifference'},
    {'1': 'setMemberRole', '3': 25, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SetMemberRole', '9': 0, '10': 'setMemberRole'},
    {'1': 'removeMember', '3': 26, '4': 1, '5': 11, '6': '.iperon.v1.Chats.RemoveMember', '9': 0, '10': 'removeMember'},
    {'1': 'banned', '3': 27, '4': 1, '5': 11, '6': '.iperon.v1.Chats.Banned', '9': 0, '10': 'banned'},
    {'1': 'unban', '3': 28, '4': 1, '5': 11, '6': '.iperon.v1.Chats.Unban', '9': 0, '10': 'unban'},
    {'1': 'setAdmin', '3': 29, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SetAdmin', '9': 0, '10': 'setAdmin'},
    {'1': 'removeAdmin', '3': 30, '4': 1, '5': 11, '6': '.iperon.v1.Chats.RemoveAdmin', '9': 0, '10': 'removeAdmin'},
    {'1': 'transferOwnership', '3': 31, '4': 1, '5': 11, '6': '.iperon.v1.Chats.TransferOwnership', '9': 0, '10': 'transferOwnership'},
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
    {'1': 'setTTL', '3': 14, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SetTTLResult', '9': 0, '10': 'setTTL'},
    {'1': 'setNoForwards', '3': 15, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SetNoForwardsResult', '9': 0, '10': 'setNoForwards'},
    {'1': 'searchUsers', '3': 16, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SearchUsersResult', '9': 0, '10': 'searchUsers'},
    {'1': 'createGroup', '3': 17, '4': 1, '5': 11, '6': '.iperon.v1.Chats.CreateGroupResult', '9': 0, '10': 'createGroup'},
    {'1': 'editChat', '3': 18, '4': 1, '5': 11, '6': '.iperon.v1.Chats.EditChatResult', '9': 0, '10': 'editChat'},
    {'1': 'addMembers', '3': 19, '4': 1, '5': 11, '6': '.iperon.v1.Chats.AddMembersResult', '9': 0, '10': 'addMembers'},
    {'1': 'leaveChat', '3': 20, '4': 1, '5': 11, '6': '.iperon.v1.Chats.LeaveChatResult', '9': 0, '10': 'leaveChat'},
    {'1': 'deleteChat', '3': 21, '4': 1, '5': 11, '6': '.iperon.v1.Chats.DeleteChatResult', '9': 0, '10': 'deleteChat'},
    {'1': 'members', '3': 22, '4': 1, '5': 11, '6': '.iperon.v1.Chats.MembersResult', '9': 0, '10': 'members'},
    {'1': 'getChatsState', '3': 23, '4': 1, '5': 11, '6': '.iperon.v1.Chats.GetChatsStateResult', '9': 0, '10': 'getChatsState'},
    {
      '1': 'getChatDifference',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.Chats.GetChatDifferenceResult',
      '9': 0,
      '10': 'getChatDifference'
    },
    {'1': 'setMemberRole', '3': 25, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SetMemberRoleResult', '9': 0, '10': 'setMemberRole'},
    {'1': 'removeMember', '3': 26, '4': 1, '5': 11, '6': '.iperon.v1.Chats.RemoveMemberResult', '9': 0, '10': 'removeMember'},
    {'1': 'banned', '3': 27, '4': 1, '5': 11, '6': '.iperon.v1.Chats.BannedResult', '9': 0, '10': 'banned'},
    {'1': 'unban', '3': 28, '4': 1, '5': 11, '6': '.iperon.v1.Chats.UnbanResult', '9': 0, '10': 'unban'},
    {'1': 'setAdmin', '3': 29, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SetAdminResult', '9': 0, '10': 'setAdmin'},
    {'1': 'removeAdmin', '3': 30, '4': 1, '5': 11, '6': '.iperon.v1.Chats.RemoveAdminResult', '9': 0, '10': 'removeAdmin'},
    {
      '1': 'transferOwnership',
      '3': 31,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.Chats.TransferOwnershipResult',
      '9': 0,
      '10': 'transferOwnership'
    },
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
        'aWFsb2caOAoGU2V0VFRMEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhYKBnBlcmlvZBgCIAEoBV'
        'IGcGVyaW9kGjwKDFNldFRUTFJlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9uLnYxLlVw'
        'ZGF0ZXNSB3VwZGF0ZXMaXwoNU2V0Tm9Gb3J3YXJkcxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRB'
        'IYCgdlbmFibGVkGAIgASgIUgdlbmFibGVkEhwKCXJlcXVlc3RJRBgDIAEoA1IJcmVxdWVzdElE'
        'GkMKE1NldE5vRm9yd2FyZHNSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcG'
        'RhdGVzUgd1cGRhdGVzGjkKC1NlYXJjaFVzZXJzEhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRIUCgVs'
        'aW1pdBgCIAEoBVIFbGltaXQaTAoRU2VhcmNoVXNlcnNSZXN1bHQSNwoIcHJvZmlsZXMYASADKA'
        'syGy5pcGVyb24udjEuUHJvZmlsZS5SZXNwb25zZVIIcHJvZmlsZXManQEKC0NyZWF0ZUdyb3Vw'
        'EhQKBXRpdGxlGAEgASgJUgV0aXRsZRIUCgVhYm91dBgCIAEoCVIFYWJvdXQSJAoNbWVtYmVyVX'
        'NlcklEcxgDIAMoDFINbWVtYmVyVXNlcklEcxIgCgthdmF0YXJDZG5JRBgEIAEoDFILYXZhdGFy'
        'Q2RuSUQSGgoIcmFuZG9tSUQYBSABKANSCHJhbmRvbUlEGpoBChFDcmVhdGVHcm91cFJlc3VsdB'
        'IpCgZkaWFsb2cYASABKAsyES5pcGVyb24udjEuRGlhbG9nUgZkaWFsb2cSLAoRcmVzdHJpY3Rl'
        'ZFVzZXJJRHMYAiADKAxSEXJlc3RyaWN0ZWRVc2VySURzEiwKB3VwZGF0ZXMYAyABKAsyEi5pcG'
        'Vyb24udjEuVXBkYXRlc1IHdXBkYXRlcxrvAQoIRWRpdENoYXQSFgoGY2hhdElEGAEgASgMUgZj'
        'aGF0SUQSGQoFdGl0bGUYAiABKAlIAFIFdGl0bGWIAQESGQoFYWJvdXQYAyABKAlIAVIFYWJvdX'
        'SIAQESJQoLYXZhdGFyQ2RuSUQYBCABKAxIAlILYXZhdGFyQ2RuSUSIAQESOgoLZGVmYXVsdFJv'
        'bGUYBSABKA4yEy5pcGVyb24udjEuQ2hhdFJvbGVIA1ILZGVmYXVsdFJvbGWIAQFCCAoGX3RpdG'
        'xlQggKBl9hYm91dEIOCgxfYXZhdGFyQ2RuSURCDgoMX2RlZmF1bHRSb2xlGj4KDkVkaXRDaGF0'
        'UmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxo+Cg'
        'pBZGRNZW1iZXJzEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhgKB3VzZXJJRHMYAiADKAxSB3Vz'
        'ZXJJRHMabgoQQWRkTWVtYmVyc1Jlc3VsdBIsChFyZXN0cmljdGVkVXNlcklEcxgBIAMoDFIRcm'
        'VzdHJpY3RlZFVzZXJJRHMSLAoHdXBkYXRlcxgCIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1'
        'cGRhdGVzGiMKCUxlYXZlQ2hhdBIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBo/Cg9MZWF2ZUNoYX'
        'RSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzGiQK'
        'CkRlbGV0ZUNoYXQSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQaQAoQRGVsZXRlQ2hhdFJlc3VsdB'
        'IsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMaTwoHTWVtYmVy'
        'cxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIWCgZvZmZzZXQYAiABKAxSBm9mZnNldBIUCgVsaW'
        '1pdBgDIAEoBVIFbGltaXQarwEKDU1lbWJlcnNSZXN1bHQSLwoHbWVtYmVycxgBIAMoCzIVLmlw'
        'ZXJvbi52MS5DaGF0TWVtYmVyUgdtZW1iZXJzEjcKCHByb2ZpbGVzGAIgAygLMhsuaXBlcm9uLn'
        'YxLlByb2ZpbGUuUmVzcG9uc2VSCHByb2ZpbGVzEh4KCm5leHRPZmZzZXQYAyABKAxSCm5leHRP'
        'ZmZzZXQSFAoFdG90YWwYBCABKAVSBXRvdGFsGj8KDUdldENoYXRzU3RhdGUSLgoFY2hhdHMYAS'
        'ADKAsyGC5pcGVyb24udjEuQ2hhdHMuQ2hhdFB0c1IFY2hhdHMaMwoHQ2hhdFB0cxIWCgZjaGF0'
        'SUQYASABKAxSBmNoYXRJRBIQCgNwdHMYAiABKANSA3B0cxpdChNHZXRDaGF0c1N0YXRlUmVzdW'
        'x0EjIKB2NoYW5nZWQYASADKAsyGC5pcGVyb24udjEuQ2hhdHMuQ2hhdFB0c1IHY2hhbmdlZBIS'
        'CgRnb25lGAIgAygMUgRnb25lGlMKEUdldENoYXREaWZmZXJlbmNlEhYKBmNoYXRJRBgBIAEoDF'
        'IGY2hhdElEEhAKA3B0cxgCIAEoA1IDcHRzEhQKBWxpbWl0GAMgASgFUgVsaW1pdBq3AQoXR2V0'
        'Q2hhdERpZmZlcmVuY2VSZXN1bHQSKwoHdXBkYXRlcxgBIAMoCzIRLmlwZXJvbi52MS5VcGRhdG'
        'VSB3VwZGF0ZXMSEAoDcHRzGAIgASgDUgNwdHMSGAoHaGFzTW9yZRgDIAEoCFIHaGFzTW9yZRIY'
        'Cgd0b29Mb25nGAQgASgIUgd0b29Mb25nEikKBmRpYWxvZxgFIAEoCzIRLmlwZXJvbi52MS5EaW'
        'Fsb2dSBmRpYWxvZxpoCg1TZXRNZW1iZXJSb2xlEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhYK'
        'BnVzZXJJRBgCIAEoDFIGdXNlcklEEicKBHJvbGUYAyABKA4yEy5pcGVyb24udjEuQ2hhdFJvbG'
        'VSBHJvbGUaQwoTU2V0TWVtYmVyUm9sZVJlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9u'
        'LnYxLlVwZGF0ZXNSB3VwZGF0ZXMaUAoMUmVtb3ZlTWVtYmVyEhYKBmNoYXRJRBgBIAEoDFIGY2'
        'hhdElEEhYKBnVzZXJJRBgCIAEoDFIGdXNlcklEEhAKA2JhbhgDIAEoCFIDYmFuGkIKElJlbW92'
        'ZU1lbWJlclJlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3VwZG'
        'F0ZXMaTgoGQmFubmVkEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhYKBm9mZnNldBgCIAEoDFIG'
        'b2Zmc2V0EhQKBWxpbWl0GAMgASgFUgVsaW1pdBqyAQoMQmFubmVkUmVzdWx0EjMKBmJhbm5lZB'
        'gBIAMoCzIbLmlwZXJvbi52MS5DaGF0QmFubmVkTWVtYmVyUgZiYW5uZWQSNwoIcHJvZmlsZXMY'
        'AiADKAsyGy5pcGVyb24udjEuUHJvZmlsZS5SZXNwb25zZVIIcHJvZmlsZXMSHgoKbmV4dE9mZn'
        'NldBgDIAEoDFIKbmV4dE9mZnNldBIUCgV0b3RhbBgEIAEoBVIFdG90YWwaNwoFVW5iYW4SFgoG'
        'Y2hhdElEGAEgASgMUgZjaGF0SUQSFgoGdXNlcklEGAIgASgMUgZ1c2VySUQaDQoLVW5iYW5SZX'
        'N1bHQaggEKCFNldEFkbWluEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhYKBnVzZXJJRBgCIAEo'
        'DFIGdXNlcklEEjIKBnJpZ2h0cxgDIAEoCzIaLmlwZXJvbi52MS5DaGF0QWRtaW5SaWdodHNSBn'
        'JpZ2h0cxISCgRyYW5rGAQgASgJUgRyYW5rGj4KDlNldEFkbWluUmVzdWx0EiwKB3VwZGF0ZXMY'
        'ASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxo9CgtSZW1vdmVBZG1pbhIWCgZjaG'
        'F0SUQYASABKAxSBmNoYXRJRBIWCgZ1c2VySUQYAiABKAxSBnVzZXJJRBpBChFSZW1vdmVBZG1p'
        'blJlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMaWw'
        'oRVHJhbnNmZXJPd25lcnNoaXASFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSFgoGdXNlcklEGAIg'
        'ASgMUgZ1c2VySUQSFgoGcHdIYXNoGAMgASgMUgZwd0hhc2gaRwoXVHJhbnNmZXJPd25lcnNoaX'
        'BSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzGtMP'
        'CgdSZXF1ZXN0EisKBGxpc3QYASABKAsyFS5pcGVyb24udjEuQ2hhdHMuTGlzdEgAUgRsaXN0Ek'
        'AKC29wZW5Qcml2YXRlGAIgASgLMhwuaXBlcm9uLnYxLkNoYXRzLk9wZW5Qcml2YXRlSABSC29w'
        'ZW5Qcml2YXRlEkAKC3JlYWRIaXN0b3J5GAMgASgLMhwuaXBlcm9uLnYxLkNoYXRzLlJlYWRIaX'
        'N0b3J5SABSC3JlYWRIaXN0b3J5EjoKCXNldERpYWxvZxgEIAEoCzIaLmlwZXJvbi52MS5DaGF0'
        'cy5TZXREaWFsb2dIAFIJc2V0RGlhbG9nEkMKDGRlbGV0ZURpYWxvZxgFIAEoCzIdLmlwZXJvbi'
        '52MS5DaGF0cy5EZWxldGVEaWFsb2dIAFIMZGVsZXRlRGlhbG9nEjcKCHJlYWREYXRlGAYgASgL'
        'MhkuaXBlcm9uLnYxLkNoYXRzLlJlYWREYXRlSABSCHJlYWREYXRlEjcKCGNhbldyaXRlGAcgAS'
        'gLMhkuaXBlcm9uLnYxLkNoYXRzLkNhbldyaXRlSABSCGNhbldyaXRlEjoKCXNhdmVEcmFmdBgI'
        'IAEoCzIaLmlwZXJvbi52MS5DaGF0cy5TYXZlRHJhZnRIAFIJc2F2ZURyYWZ0Ej0KCmdldEZvbG'
        'RlcnMYCSABKAsyGy5pcGVyb24udjEuQ2hhdHMuR2V0Rm9sZGVyc0gAUgpnZXRGb2xkZXJzEj0K'
        'CnNhdmVGb2xkZXIYCiABKAsyGy5pcGVyb24udjEuQ2hhdHMuU2F2ZUZvbGRlckgAUgpzYXZlRm'
        '9sZGVyEkMKDGRlbGV0ZUZvbGRlchgLIAEoCzIdLmlwZXJvbi52MS5DaGF0cy5EZWxldGVGb2xk'
        'ZXJIAFIMZGVsZXRlRm9sZGVyEkkKDnJlb3JkZXJGb2xkZXJzGAwgASgLMh8uaXBlcm9uLnYxLk'
        'NoYXRzLlJlb3JkZXJGb2xkZXJzSABSDnJlb3JkZXJGb2xkZXJzEkwKD3Jlc29sdmVVc2VybmFt'
        'ZRgNIAEoCzIgLmlwZXJvbi52MS5DaGF0cy5SZXNvbHZlVXNlcm5hbWVIAFIPcmVzb2x2ZVVzZX'
        'JuYW1lEjEKBnNldFRUTBgOIAEoCzIXLmlwZXJvbi52MS5DaGF0cy5TZXRUVExIAFIGc2V0VFRM'
        'EkYKDXNldE5vRm9yd2FyZHMYDyABKAsyHi5pcGVyb24udjEuQ2hhdHMuU2V0Tm9Gb3J3YXJkc0'
        'gAUg1zZXROb0ZvcndhcmRzEkAKC3NlYXJjaFVzZXJzGBAgASgLMhwuaXBlcm9uLnYxLkNoYXRz'
        'LlNlYXJjaFVzZXJzSABSC3NlYXJjaFVzZXJzEkAKC2NyZWF0ZUdyb3VwGBEgASgLMhwuaXBlcm'
        '9uLnYxLkNoYXRzLkNyZWF0ZUdyb3VwSABSC2NyZWF0ZUdyb3VwEjcKCGVkaXRDaGF0GBIgASgL'
        'MhkuaXBlcm9uLnYxLkNoYXRzLkVkaXRDaGF0SABSCGVkaXRDaGF0Ej0KCmFkZE1lbWJlcnMYEy'
        'ABKAsyGy5pcGVyb24udjEuQ2hhdHMuQWRkTWVtYmVyc0gAUgphZGRNZW1iZXJzEjoKCWxlYXZl'
        'Q2hhdBgUIAEoCzIaLmlwZXJvbi52MS5DaGF0cy5MZWF2ZUNoYXRIAFIJbGVhdmVDaGF0Ej0KCm'
        'RlbGV0ZUNoYXQYFSABKAsyGy5pcGVyb24udjEuQ2hhdHMuRGVsZXRlQ2hhdEgAUgpkZWxldGVD'
        'aGF0EjQKB21lbWJlcnMYFiABKAsyGC5pcGVyb24udjEuQ2hhdHMuTWVtYmVyc0gAUgdtZW1iZX'
        'JzEkYKDWdldENoYXRzU3RhdGUYFyABKAsyHi5pcGVyb24udjEuQ2hhdHMuR2V0Q2hhdHNTdGF0'
        'ZUgAUg1nZXRDaGF0c1N0YXRlElIKEWdldENoYXREaWZmZXJlbmNlGBggASgLMiIuaXBlcm9uLn'
        'YxLkNoYXRzLkdldENoYXREaWZmZXJlbmNlSABSEWdldENoYXREaWZmZXJlbmNlEkYKDXNldE1l'
        'bWJlclJvbGUYGSABKAsyHi5pcGVyb24udjEuQ2hhdHMuU2V0TWVtYmVyUm9sZUgAUg1zZXRNZW'
        '1iZXJSb2xlEkMKDHJlbW92ZU1lbWJlchgaIAEoCzIdLmlwZXJvbi52MS5DaGF0cy5SZW1vdmVN'
        'ZW1iZXJIAFIMcmVtb3ZlTWVtYmVyEjEKBmJhbm5lZBgbIAEoCzIXLmlwZXJvbi52MS5DaGF0cy'
        '5CYW5uZWRIAFIGYmFubmVkEi4KBXVuYmFuGBwgASgLMhYuaXBlcm9uLnYxLkNoYXRzLlVuYmFu'
        'SABSBXVuYmFuEjcKCHNldEFkbWluGB0gASgLMhkuaXBlcm9uLnYxLkNoYXRzLlNldEFkbWluSA'
        'BSCHNldEFkbWluEkAKC3JlbW92ZUFkbWluGB4gASgLMhwuaXBlcm9uLnYxLkNoYXRzLlJlbW92'
        'ZUFkbWluSABSC3JlbW92ZUFkbWluElIKEXRyYW5zZmVyT3duZXJzaGlwGB8gASgLMiIuaXBlcm'
        '9uLnYxLkNoYXRzLlRyYW5zZmVyT3duZXJzaGlwSABSEXRyYW5zZmVyT3duZXJzaGlwQgkKB3Jl'
        'cXVlc3QajxEKCFJlc3BvbnNlEjEKBGxpc3QYASABKAsyGy5pcGVyb24udjEuQ2hhdHMuTGlzdF'
        'Jlc3VsdEgAUgRsaXN0EkYKC29wZW5Qcml2YXRlGAIgASgLMiIuaXBlcm9uLnYxLkNoYXRzLk9w'
        'ZW5Qcml2YXRlUmVzdWx0SABSC29wZW5Qcml2YXRlEkYKC3JlYWRIaXN0b3J5GAMgASgLMiIuaX'
        'Blcm9uLnYxLkNoYXRzLlJlYWRIaXN0b3J5UmVzdWx0SABSC3JlYWRIaXN0b3J5EkAKCXNldERp'
        'YWxvZxgEIAEoCzIgLmlwZXJvbi52MS5DaGF0cy5TZXREaWFsb2dSZXN1bHRIAFIJc2V0RGlhbG'
        '9nEkkKDGRlbGV0ZURpYWxvZxgFIAEoCzIjLmlwZXJvbi52MS5DaGF0cy5EZWxldGVEaWFsb2dS'
        'ZXN1bHRIAFIMZGVsZXRlRGlhbG9nEj0KCHJlYWREYXRlGAYgASgLMh8uaXBlcm9uLnYxLkNoYX'
        'RzLlJlYWREYXRlUmVzdWx0SABSCHJlYWREYXRlEj0KCGNhbldyaXRlGAcgASgLMh8uaXBlcm9u'
        'LnYxLkNoYXRzLkNhbldyaXRlUmVzdWx0SABSCGNhbldyaXRlEkAKCXNhdmVEcmFmdBgIIAEoCz'
        'IgLmlwZXJvbi52MS5DaGF0cy5TYXZlRHJhZnRSZXN1bHRIAFIJc2F2ZURyYWZ0EkMKCmdldEZv'
        'bGRlcnMYCSABKAsyIS5pcGVyb24udjEuQ2hhdHMuR2V0Rm9sZGVyc1Jlc3VsdEgAUgpnZXRGb2'
        'xkZXJzEkMKCnNhdmVGb2xkZXIYCiABKAsyIS5pcGVyb24udjEuQ2hhdHMuU2F2ZUZvbGRlclJl'
        'c3VsdEgAUgpzYXZlRm9sZGVyEkkKDGRlbGV0ZUZvbGRlchgLIAEoCzIjLmlwZXJvbi52MS5DaG'
        'F0cy5EZWxldGVGb2xkZXJSZXN1bHRIAFIMZGVsZXRlRm9sZGVyEk8KDnJlb3JkZXJGb2xkZXJz'
        'GAwgASgLMiUuaXBlcm9uLnYxLkNoYXRzLlJlb3JkZXJGb2xkZXJzUmVzdWx0SABSDnJlb3JkZX'
        'JGb2xkZXJzElIKD3Jlc29sdmVVc2VybmFtZRgNIAEoCzImLmlwZXJvbi52MS5DaGF0cy5SZXNv'
        'bHZlVXNlcm5hbWVSZXN1bHRIAFIPcmVzb2x2ZVVzZXJuYW1lEjcKBnNldFRUTBgOIAEoCzIdLm'
        'lwZXJvbi52MS5DaGF0cy5TZXRUVExSZXN1bHRIAFIGc2V0VFRMEkwKDXNldE5vRm9yd2FyZHMY'
        'DyABKAsyJC5pcGVyb24udjEuQ2hhdHMuU2V0Tm9Gb3J3YXJkc1Jlc3VsdEgAUg1zZXROb0Zvcn'
        'dhcmRzEkYKC3NlYXJjaFVzZXJzGBAgASgLMiIuaXBlcm9uLnYxLkNoYXRzLlNlYXJjaFVzZXJz'
        'UmVzdWx0SABSC3NlYXJjaFVzZXJzEkYKC2NyZWF0ZUdyb3VwGBEgASgLMiIuaXBlcm9uLnYxLk'
        'NoYXRzLkNyZWF0ZUdyb3VwUmVzdWx0SABSC2NyZWF0ZUdyb3VwEj0KCGVkaXRDaGF0GBIgASgL'
        'Mh8uaXBlcm9uLnYxLkNoYXRzLkVkaXRDaGF0UmVzdWx0SABSCGVkaXRDaGF0EkMKCmFkZE1lbW'
        'JlcnMYEyABKAsyIS5pcGVyb24udjEuQ2hhdHMuQWRkTWVtYmVyc1Jlc3VsdEgAUgphZGRNZW1i'
        'ZXJzEkAKCWxlYXZlQ2hhdBgUIAEoCzIgLmlwZXJvbi52MS5DaGF0cy5MZWF2ZUNoYXRSZXN1bH'
        'RIAFIJbGVhdmVDaGF0EkMKCmRlbGV0ZUNoYXQYFSABKAsyIS5pcGVyb24udjEuQ2hhdHMuRGVs'
        'ZXRlQ2hhdFJlc3VsdEgAUgpkZWxldGVDaGF0EjoKB21lbWJlcnMYFiABKAsyHi5pcGVyb24udj'
        'EuQ2hhdHMuTWVtYmVyc1Jlc3VsdEgAUgdtZW1iZXJzEkwKDWdldENoYXRzU3RhdGUYFyABKAsy'
        'JC5pcGVyb24udjEuQ2hhdHMuR2V0Q2hhdHNTdGF0ZVJlc3VsdEgAUg1nZXRDaGF0c1N0YXRlEl'
        'gKEWdldENoYXREaWZmZXJlbmNlGBggASgLMiguaXBlcm9uLnYxLkNoYXRzLkdldENoYXREaWZm'
        'ZXJlbmNlUmVzdWx0SABSEWdldENoYXREaWZmZXJlbmNlEkwKDXNldE1lbWJlclJvbGUYGSABKA'
        'syJC5pcGVyb24udjEuQ2hhdHMuU2V0TWVtYmVyUm9sZVJlc3VsdEgAUg1zZXRNZW1iZXJSb2xl'
        'EkkKDHJlbW92ZU1lbWJlchgaIAEoCzIjLmlwZXJvbi52MS5DaGF0cy5SZW1vdmVNZW1iZXJSZX'
        'N1bHRIAFIMcmVtb3ZlTWVtYmVyEjcKBmJhbm5lZBgbIAEoCzIdLmlwZXJvbi52MS5DaGF0cy5C'
        'YW5uZWRSZXN1bHRIAFIGYmFubmVkEjQKBXVuYmFuGBwgASgLMhwuaXBlcm9uLnYxLkNoYXRzLl'
        'VuYmFuUmVzdWx0SABSBXVuYmFuEj0KCHNldEFkbWluGB0gASgLMh8uaXBlcm9uLnYxLkNoYXRz'
        'LlNldEFkbWluUmVzdWx0SABSCHNldEFkbWluEkYKC3JlbW92ZUFkbWluGB4gASgLMiIuaXBlcm'
        '9uLnYxLkNoYXRzLlJlbW92ZUFkbWluUmVzdWx0SABSC3JlbW92ZUFkbWluElgKEXRyYW5zZmVy'
        'T3duZXJzaGlwGB8gASgLMiguaXBlcm9uLnYxLkNoYXRzLlRyYW5zZmVyT3duZXJzaGlwUmVzdW'
        'x0SABSEXRyYW5zZmVyT3duZXJzaGlwQgoKCHJlc3BvbnNl');

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
    {'1': 'sharedIDs', '3': 2, '4': 3, '5': 3, '10': 'sharedIDs'},
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
        'ASgMUgZjaGF0SUQaYAoMUGlubmVkUmVzdWx0EjIKCG1lc3NhZ2VzGAEgAygLMhYuaXBlcm9uLn'
        'YxLkNoYXRNZXNzYWdlUghtZXNzYWdlcxIcCglzaGFyZWRJRHMYAiADKANSCXNoYXJlZElEcxpc'
        'CgxTZXRSZWFjdGlvbnMSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSHAoJbWVzc2FnZUlEGAIgAS'
        'gDUgltZXNzYWdlSUQSFgoGZW1vamlzGAMgAygJUgZlbW9qaXMaQgoSU2V0UmVhY3Rpb25zUmVz'
        'dWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxpHCg1SZW'
        'FkUmVhY3Rpb25zEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEh4KCm1lc3NhZ2VJRHMYAiADKANS'
        'Cm1lc3NhZ2VJRHMaQwoTUmVhZFJlYWN0aW9uc1Jlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaX'
        'Blcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMaPwoPVW5yZWFkUmVhY3Rpb25zEhYKBmNoYXRJRBgB'
        'IAEoDFIGY2hhdElEEhQKBWxpbWl0GAIgASgFUgVsaW1pdBpLChVVbnJlYWRSZWFjdGlvbnNSZX'
        'N1bHQSMgoIbWVzc2FnZXMYASADKAsyFi5pcGVyb24udjEuQ2hhdE1lc3NhZ2VSCG1lc3NhZ2Vz'
        'Gj0KA0dldBIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIeCgptZXNzYWdlSURzGAIgAygDUgptZX'
        'NzYWdlSURzGj8KCUdldFJlc3VsdBIyCghtZXNzYWdlcxgBIAMoCzIWLmlwZXJvbi52MS5DaGF0'
        'TWVzc2FnZVIIbWVzc2FnZXMagQgKB1JlcXVlc3QSNwoHaGlzdG9yeRgBIAEoCzIbLmlwZXJvbi'
        '52MS5NZXNzYWdlcy5IaXN0b3J5SABSB2hpc3RvcnkSLgoEc2VuZBgCIAEoCzIYLmlwZXJvbi52'
        'MS5NZXNzYWdlcy5TZW5kSABSBHNlbmQSLgoEZWRpdBgDIAEoCzIYLmlwZXJvbi52MS5NZXNzYW'
        'dlcy5FZGl0SABSBGVkaXQSNAoGZGVsZXRlGAQgASgLMhouaXBlcm9uLnYxLk1lc3NhZ2VzLkRl'
        'bGV0ZUgAUgZkZWxldGUSRgoMcmVhZENvbnRlbnRzGAUgASgLMiAuaXBlcm9uLnYxLk1lc3NhZ2'
        'VzLlJlYWRDb250ZW50c0gAUgxyZWFkQ29udGVudHMSKwoDcGluGAYgASgLMhcuaXBlcm9uLnYx'
        'Lk1lc3NhZ2VzLlBpbkgAUgNwaW4SOgoIdW5waW5BbGwYByABKAsyHC5pcGVyb24udjEuTWVzc2'
        'FnZXMuVW5waW5BbGxIAFIIdW5waW5BbGwSNAoGcGlubmVkGAggASgLMhouaXBlcm9uLnYxLk1l'
        'c3NhZ2VzLlBpbm5lZEgAUgZwaW5uZWQSRgoMc2V0UmVhY3Rpb25zGAkgASgLMiAuaXBlcm9uLn'
        'YxLk1lc3NhZ2VzLlNldFJlYWN0aW9uc0gAUgxzZXRSZWFjdGlvbnMSSQoNcmVhZFJlYWN0aW9u'
        'cxgKIAEoCzIhLmlwZXJvbi52MS5NZXNzYWdlcy5SZWFkUmVhY3Rpb25zSABSDXJlYWRSZWFjdG'
        'lvbnMSTwoPdW5yZWFkUmVhY3Rpb25zGAsgASgLMiMuaXBlcm9uLnYxLk1lc3NhZ2VzLlVucmVh'
        'ZFJlYWN0aW9uc0gAUg91bnJlYWRSZWFjdGlvbnMSPQoJc2NoZWR1bGVkGAwgASgLMh0uaXBlcm'
        '9uLnYxLk1lc3NhZ2VzLlNjaGVkdWxlZEgAUglzY2hlZHVsZWQSUgoQc2VuZFNjaGVkdWxlZE5v'
        'dxgNIAEoCzIkLmlwZXJvbi52MS5NZXNzYWdlcy5TZW5kU2NoZWR1bGVkTm93SABSEHNlbmRTY2'
        'hlZHVsZWROb3cSQAoKcmVzY2hlZHVsZRgOIAEoCzIeLmlwZXJvbi52MS5NZXNzYWdlcy5SZXNj'
        'aGVkdWxlSABSCnJlc2NoZWR1bGUSTwoPZGVsZXRlU2NoZWR1bGVkGA8gASgLMiMuaXBlcm9uLn'
        'YxLk1lc3NhZ2VzLkRlbGV0ZVNjaGVkdWxlZEgAUg9kZWxldGVTY2hlZHVsZWQSKwoDZ2V0GBAg'
        'ASgLMhcuaXBlcm9uLnYxLk1lc3NhZ2VzLkdldEgAUgNnZXRCCQoHcmVxdWVzdBrjCAoIUmVzcG'
        '9uc2USPQoHaGlzdG9yeRgBIAEoCzIhLmlwZXJvbi52MS5NZXNzYWdlcy5IaXN0b3J5UmVzdWx0'
        'SABSB2hpc3RvcnkSNAoEc2VuZBgCIAEoCzIeLmlwZXJvbi52MS5NZXNzYWdlcy5TZW5kUmVzdW'
        'x0SABSBHNlbmQSNAoEZWRpdBgDIAEoCzIeLmlwZXJvbi52MS5NZXNzYWdlcy5FZGl0UmVzdWx0'
        'SABSBGVkaXQSOgoGZGVsZXRlGAQgASgLMiAuaXBlcm9uLnYxLk1lc3NhZ2VzLkRlbGV0ZVJlc3'
        'VsdEgAUgZkZWxldGUSTAoMcmVhZENvbnRlbnRzGAUgASgLMiYuaXBlcm9uLnYxLk1lc3NhZ2Vz'
        'LlJlYWRDb250ZW50c1Jlc3VsdEgAUgxyZWFkQ29udGVudHMSMQoDcGluGAYgASgLMh0uaXBlcm'
        '9uLnYxLk1lc3NhZ2VzLlBpblJlc3VsdEgAUgNwaW4SQAoIdW5waW5BbGwYByABKAsyIi5pcGVy'
        'b24udjEuTWVzc2FnZXMuVW5waW5BbGxSZXN1bHRIAFIIdW5waW5BbGwSOgoGcGlubmVkGAggAS'
        'gLMiAuaXBlcm9uLnYxLk1lc3NhZ2VzLlBpbm5lZFJlc3VsdEgAUgZwaW5uZWQSTAoMc2V0UmVh'
        'Y3Rpb25zGAkgASgLMiYuaXBlcm9uLnYxLk1lc3NhZ2VzLlNldFJlYWN0aW9uc1Jlc3VsdEgAUg'
        'xzZXRSZWFjdGlvbnMSTwoNcmVhZFJlYWN0aW9ucxgKIAEoCzInLmlwZXJvbi52MS5NZXNzYWdl'
        'cy5SZWFkUmVhY3Rpb25zUmVzdWx0SABSDXJlYWRSZWFjdGlvbnMSVQoPdW5yZWFkUmVhY3Rpb2'
        '5zGAsgASgLMikuaXBlcm9uLnYxLk1lc3NhZ2VzLlVucmVhZFJlYWN0aW9uc1Jlc3VsdEgAUg91'
        'bnJlYWRSZWFjdGlvbnMSQwoJc2NoZWR1bGVkGAwgASgLMiMuaXBlcm9uLnYxLk1lc3NhZ2VzLl'
        'NjaGVkdWxlZFJlc3VsdEgAUglzY2hlZHVsZWQSWAoQc2VuZFNjaGVkdWxlZE5vdxgNIAEoCzIq'
        'LmlwZXJvbi52MS5NZXNzYWdlcy5TZW5kU2NoZWR1bGVkTm93UmVzdWx0SABSEHNlbmRTY2hlZH'
        'VsZWROb3cSRgoKcmVzY2hlZHVsZRgOIAEoCzIkLmlwZXJvbi52MS5NZXNzYWdlcy5SZXNjaGVk'
        'dWxlUmVzdWx0SABSCnJlc2NoZWR1bGUSVQoPZGVsZXRlU2NoZWR1bGVkGA8gASgLMikuaXBlcm'
        '9uLnYxLk1lc3NhZ2VzLkRlbGV0ZVNjaGVkdWxlZFJlc3VsdEgAUg9kZWxldGVTY2hlZHVsZWQS'
        'MQoDZ2V0GBAgASgLMh0uaXBlcm9uLnYxLk1lc3NhZ2VzLkdldFJlc3VsdEgAUgNnZXRCCgoIcm'
        'VzcG9uc2U=');

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
