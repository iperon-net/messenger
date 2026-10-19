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

@$core.Deprecated('Use chatJoinModeDescriptor instead')
const ChatJoinMode$json = {
  '1': 'ChatJoinMode',
  '2': [
    {'1': 'CHAT_JOIN_LINK', '2': 0},
    {'1': 'CHAT_JOIN_OPEN', '2': 1},
    {'1': 'CHAT_JOIN_REQUEST', '2': 2},
    {'1': 'CHAT_JOIN_ADMINS', '2': 3},
  ],
};

/// Descriptor for `ChatJoinMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List chatJoinModeDescriptor =
    $convert.base64Decode('CgxDaGF0Sm9pbk1vZGUSEgoOQ0hBVF9KT0lOX0xJTksQABISCg5DSEFUX0pPSU5fT1BFThABEh'
        'UKEUNIQVRfSk9JTl9SRVFVRVNUEAISFAoQQ0hBVF9KT0lOX0FETUlOUxAD');

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
    {'1': 'username', '3': 12, '4': 1, '5': 9, '10': 'username'},
    {'1': 'joinMode', '3': 13, '4': 1, '5': 14, '6': '.iperon.v1.ChatJoinMode', '10': 'joinMode'},
    {'1': 'historyHidden', '3': 14, '4': 1, '5': 8, '10': 'historyHidden'},
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
        'Ey5pcGVyb24udjEuQ2hhdFJvbGVSC2RlZmF1bHRSb2xlEhoKCHVzZXJuYW1lGAwgASgJUgh1c2'
        'VybmFtZRIzCghqb2luTW9kZRgNIAEoDjIXLmlwZXJvbi52MS5DaGF0Sm9pbk1vZGVSCGpvaW5N'
        'b2RlEiQKDWhpc3RvcnlIaWRkZW4YDiABKAhSDWhpc3RvcnlIaWRkZW4=');

@$core.Deprecated('Use chatInviteLinkDescriptor instead')
const ChatInviteLink$json = {
  '1': 'ChatInviteLink',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'primary', '3': 3, '4': 1, '5': 8, '10': 'primary'},
    {'1': 'revoked', '3': 4, '4': 1, '5': 8, '10': 'revoked'},
    {'1': 'expireDate', '3': 5, '4': 1, '5': 3, '10': 'expireDate'},
    {'1': 'usageLimit', '3': 6, '4': 1, '5': 5, '10': 'usageLimit'},
    {'1': 'usage', '3': 7, '4': 1, '5': 5, '10': 'usage'},
    {'1': 'requestApproval', '3': 8, '4': 1, '5': 8, '10': 'requestApproval'},
    {'1': 'createdAt', '3': 9, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'creatorUserID', '3': 10, '4': 1, '5': 12, '10': 'creatorUserID'},
    {'1': 'pendingCount', '3': 11, '4': 1, '5': 5, '10': 'pendingCount'},
  ],
};

/// Descriptor for `ChatInviteLink`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatInviteLinkDescriptor =
    $convert.base64Decode('Cg5DaGF0SW52aXRlTGluaxISCgRjb2RlGAEgASgJUgRjb2RlEhQKBXRpdGxlGAIgASgJUgV0aX'
        'RsZRIYCgdwcmltYXJ5GAMgASgIUgdwcmltYXJ5EhgKB3Jldm9rZWQYBCABKAhSB3Jldm9rZWQS'
        'HgoKZXhwaXJlRGF0ZRgFIAEoA1IKZXhwaXJlRGF0ZRIeCgp1c2FnZUxpbWl0GAYgASgFUgp1c2'
        'FnZUxpbWl0EhQKBXVzYWdlGAcgASgFUgV1c2FnZRIoCg9yZXF1ZXN0QXBwcm92YWwYCCABKAhS'
        'D3JlcXVlc3RBcHByb3ZhbBIcCgljcmVhdGVkQXQYCSABKANSCWNyZWF0ZWRBdBIkCg1jcmVhdG'
        '9yVXNlcklEGAogASgMUg1jcmVhdG9yVXNlcklEEiIKDHBlbmRpbmdDb3VudBgLIAEoBVIMcGVu'
        'ZGluZ0NvdW50');

@$core.Deprecated('Use chatJoinRequestDescriptor instead')
const ChatJoinRequest$json = {
  '1': 'ChatJoinRequest',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'date', '3': 2, '4': 1, '5': 3, '10': 'date'},
    {'1': 'inviteCode', '3': 3, '4': 1, '5': 9, '10': 'inviteCode'},
    {'1': 'inviteTitle', '3': 4, '4': 1, '5': 9, '10': 'inviteTitle'},
  ],
};

/// Descriptor for `ChatJoinRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatJoinRequestDescriptor =
    $convert.base64Decode('Cg9DaGF0Sm9pblJlcXVlc3QSFgoGdXNlcklEGAEgASgMUgZ1c2VySUQSEgoEZGF0ZRgCIAEoA1'
        'IEZGF0ZRIeCgppbnZpdGVDb2RlGAMgASgJUgppbnZpdGVDb2RlEiAKC2ludml0ZVRpdGxlGAQg'
        'ASgJUgtpbnZpdGVUaXRsZQ==');

@$core.Deprecated('Use chatPreviewDescriptor instead')
const ChatPreview$json = {
  '1': 'ChatPreview',
  '2': [
    {'1': 'chat', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ChatInfo', '10': 'chat'},
    {'1': 'requestNeeded', '3': 2, '4': 1, '5': 8, '10': 'requestNeeded'},
    {'1': 'requested', '3': 3, '4': 1, '5': 8, '10': 'requested'},
    {'1': 'canViewHistory', '3': 4, '4': 1, '5': 8, '10': 'canViewHistory'},
    {'1': 'members', '3': 5, '4': 3, '5': 11, '6': '.iperon.v1.Profile.Response', '10': 'members'},
  ],
};

/// Descriptor for `ChatPreview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatPreviewDescriptor =
    $convert.base64Decode('CgtDaGF0UHJldmlldxInCgRjaGF0GAEgASgLMhMuaXBlcm9uLnYxLkNoYXRJbmZvUgRjaGF0Ei'
        'QKDXJlcXVlc3ROZWVkZWQYAiABKAhSDXJlcXVlc3ROZWVkZWQSHAoJcmVxdWVzdGVkGAMgASgI'
        'UglyZXF1ZXN0ZWQSJgoOY2FuVmlld0hpc3RvcnkYBCABKAhSDmNhblZpZXdIaXN0b3J5EjUKB2'
        '1lbWJlcnMYBSADKAsyGy5pcGVyb24udjEuUHJvZmlsZS5SZXNwb25zZVIHbWVtYmVycw==');

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
    {'1': 'inviteCode', '3': 23, '4': 1, '5': 9, '10': 'inviteCode'},
    {'1': 'pendingRequests', '3': 24, '4': 1, '5': 5, '10': 'pendingRequests'},
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
        'IAEoCVIEcmFuaxIeCgppbnZpdGVDb2RlGBcgASgJUgppbnZpdGVDb2RlEigKD3BlbmRpbmdSZX'
        'F1ZXN0cxgYIAEoBVIPcGVuZGluZ1JlcXVlc3Rz');

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
    {'1': 'joinRequests', '3': 20, '4': 1, '5': 11, '6': '.iperon.v1.Update.JoinRequestsChanged', '9': 0, '10': 'joinRequests'},
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
    Update_JoinRequestsChanged$json,
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
const Update_JoinRequestsChanged$json = {
  '1': 'JoinRequestsChanged',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'pendingCount', '3': 2, '4': 1, '5': 5, '10': 'pendingCount'},
    {'1': 'recentUserIDs', '3': 3, '4': 3, '5': 12, '10': 'recentUserIDs'},
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
        'YxLlVwZGF0ZS5EaWFsb2dOZXdIAFIJZGlhbG9nTmV3EksKDGpvaW5SZXF1ZXN0cxgUIAEoCzIl'
        'LmlwZXJvbi52MS5VcGRhdGUuSm9pblJlcXVlc3RzQ2hhbmdlZEgAUgxqb2luUmVxdWVzdHMaaQ'
        'oKTmV3TWVzc2FnZRIwCgdtZXNzYWdlGAEgASgLMhYuaXBlcm9uLnYxLkNoYXRNZXNzYWdlUgdt'
        'ZXNzYWdlEikKBmRpYWxvZxgCIAEoCzIRLmlwZXJvbi52MS5EaWFsb2dSBmRpYWxvZxo/CgtFZG'
        'l0TWVzc2FnZRIwCgdtZXNzYWdlGAEgASgLMhYuaXBlcm9uLnYxLkNoYXRNZXNzYWdlUgdtZXNz'
        'YWdlGkgKDkRlbGV0ZU1lc3NhZ2VzEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEh4KCm1lc3NhZ2'
        'VJRHMYAiADKANSCm1lc3NhZ2VJRHMaWwoJUmVhZEluYm94EhYKBmNoYXRJRBgBIAEoDFIGY2hh'
        'dElEEhQKBW1heElEGAIgASgDUgVtYXhJRBIgCgt1bnJlYWRDb3VudBgDIAEoBVILdW5yZWFkQ2'
        '91bnQaOgoKUmVhZE91dGJveBIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIUCgVtYXhJRBgCIAEo'
        'A1IFbWF4SUQaRgoMUmVhZENvbnRlbnRzEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEh4KCm1lc3'
        'NhZ2VJRHMYAiADKANSCm1lc3NhZ2VJRHMaOwoORGlhbG9nU2V0dGluZ3MSKQoGZGlhbG9nGAEg'
        'ASgLMhEuaXBlcm9uLnYxLkRpYWxvZ1IGZGlhbG9nGicKDURpYWxvZ0RlbGV0ZWQSFgoGY2hhdE'
        'lEGAEgASgMUgZjaGF0SUQaeAoOUGlubmVkTWVzc2FnZXMSFgoGY2hhdElEGAEgASgMUgZjaGF0'
        'SUQSHgoKbWVzc2FnZUlEcxgCIAMoA1IKbWVzc2FnZUlEcxIWCgZwaW5uZWQYAyABKAhSBnBpbm'
        '5lZBIWCgZzaGFyZWQYBCABKAhSBnNoYXJlZBroAQoXTWVzc2FnZVJlYWN0aW9uc0NoYW5nZWQS'
        'FgoGY2hhdElEGAEgASgMUgZjaGF0SUQSHAoJbWVzc2FnZUlEGAIgASgDUgltZXNzYWdlSUQSOQ'
        'oJcmVhY3Rpb25zGAMgASgLMhsuaXBlcm9uLnYxLk1lc3NhZ2VSZWFjdGlvbnNSCXJlYWN0aW9u'
        'cxIyChR1bnJlYWRSZWFjdGlvbnNDb3VudBgEIAEoBVIUdW5yZWFkUmVhY3Rpb25zQ291bnQSKA'
        'oPcmVhY3Rpb25zVW5yZWFkGAUgASgIUg9yZWFjdGlvbnNVbnJlYWQaewoNUmVhZFJlYWN0aW9u'
        'cxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIeCgptZXNzYWdlSURzGAIgAygDUgptZXNzYWdlSU'
        'RzEjIKFHVucmVhZFJlYWN0aW9uc0NvdW50GAMgASgFUhR1bnJlYWRSZWFjdGlvbnNDb3VudBpQ'
        'ChdTY2hlZHVsZWRNZXNzYWdlQ2hhbmdlZBI1CgdtZXNzYWdlGAEgASgLMhsuaXBlcm9uLnYxLl'
        'NjaGVkdWxlZE1lc3NhZ2VSB21lc3NhZ2UavgEKEFNjaGVkdWxlZERlbGV0ZWQSFgoGY2hhdElE'
        'GAEgASgMUgZjaGF0SUQSIgoMc2NoZWR1bGVkSURzGAIgAygDUgxzY2hlZHVsZWRJRHMSQQoGcm'
        'Vhc29uGAMgASgOMikuaXBlcm9uLnYxLlVwZGF0ZS5TY2hlZHVsZWREZWxldGVkLlJlYXNvblIG'
        'cmVhc29uIisKBlJlYXNvbhILCgdERUxFVEVEEAASCAoEU0VOVBABEgoKBkZBSUxFRBACGjoKD0'
        'NoYXRJbmZvQ2hhbmdlZBInCgRjaGF0GAEgASgLMhMuaXBlcm9uLnYxLkNoYXRJbmZvUgRjaGF0'
        'GtYBChJDaGF0TWVtYmVyc0NoYW5nZWQSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSKwoFYWRkZW'
        'QYAiADKAsyFS5pcGVyb24udjEuQ2hhdE1lbWJlclIFYWRkZWQSJgoOcmVtb3ZlZFVzZXJJRHMY'
        'AyADKAxSDnJlbW92ZWRVc2VySURzEiIKDG1lbWJlcnNDb3VudBgEIAEoBVIMbWVtYmVyc0NvdW'
        '50Ei8KB3VwZGF0ZWQYBSADKAsyFS5pcGVyb24udjEuQ2hhdE1lbWJlclIHdXBkYXRlZBp3ChNK'
        'b2luUmVxdWVzdHNDaGFuZ2VkEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEiIKDHBlbmRpbmdDb3'
        'VudBgCIAEoBVIMcGVuZGluZ0NvdW50EiQKDXJlY2VudFVzZXJJRHMYAyADKAxSDXJlY2VudFVz'
        'ZXJJRHMaNgoJRGlhbG9nTmV3EikKBmRpYWxvZxgBIAEoCzIRLmlwZXJvbi52MS5EaWFsb2dSBm'
        'RpYWxvZ0IICgZ1cGRhdGU=');

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
    Chats_CheckUsername$json,
    Chats_CheckUsernameResult$json,
    Chats_ResolveLink$json,
    Chats_ResolveLinkResult$json,
    Chats_JoinChat$json,
    Chats_JoinChatResult$json,
    Chats_InviteLinks$json,
    Chats_InviteLinksResult$json,
    Chats_CreateInviteLink$json,
    Chats_CreateInviteLinkResult$json,
    Chats_EditInviteLink$json,
    Chats_EditInviteLinkResult$json,
    Chats_RevokeInviteLink$json,
    Chats_RevokeInviteLinkResult$json,
    Chats_DeleteRevokedInviteLinks$json,
    Chats_DeleteRevokedInviteLinksResult$json,
    Chats_JoinRequests$json,
    Chats_JoinRequestsResult$json,
    Chats_AnswerJoinRequest$json,
    Chats_AnswerJoinRequestResult$json,
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
    {'1': 'username', '3': 6, '4': 1, '5': 9, '10': 'username'},
    {'1': 'joinMode', '3': 7, '4': 1, '5': 14, '6': '.iperon.v1.ChatJoinMode', '10': 'joinMode'},
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
    {'1': 'username', '3': 6, '4': 1, '5': 9, '9': 4, '10': 'username', '17': true},
    {'1': 'joinMode', '3': 7, '4': 1, '5': 14, '6': '.iperon.v1.ChatJoinMode', '9': 5, '10': 'joinMode', '17': true},
    {'1': 'historyHidden', '3': 8, '4': 1, '5': 8, '9': 6, '10': 'historyHidden', '17': true},
  ],
  '8': [
    {'1': '_title'},
    {'1': '_about'},
    {'1': '_avatarCdnID'},
    {'1': '_defaultRole'},
    {'1': '_username'},
    {'1': '_joinMode'},
    {'1': '_historyHidden'},
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
const Chats_CheckUsername$json = {
  '1': 'CheckUsername',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'exceptChatID', '3': 2, '4': 1, '5': 12, '10': 'exceptChatID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_CheckUsernameResult$json = {
  '1': 'CheckUsernameResult',
  '2': [
    {'1': 'available', '3': 1, '4': 1, '5': 8, '10': 'available'},
    {'1': 'invalid', '3': 2, '4': 1, '5': 8, '10': 'invalid'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ResolveLink$json = {
  '1': 'ResolveLink',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ResolveLinkResult$json = {
  '1': 'ResolveLinkResult',
  '2': [
    {'1': 'dialog', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Dialog', '10': 'dialog'},
    {'1': 'preview', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.ChatPreview', '10': 'preview'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_JoinChat$json = {
  '1': 'JoinChat',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_JoinChatResult$json = {
  '1': 'JoinChatResult',
  '2': [
    {'1': 'dialog', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Dialog', '10': 'dialog'},
    {'1': 'requested', '3': 2, '4': 1, '5': 8, '10': 'requested'},
    {'1': 'updates', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_InviteLinks$json = {
  '1': 'InviteLinks',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_InviteLinksResult$json = {
  '1': 'InviteLinksResult',
  '2': [
    {'1': 'links', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ChatInviteLink', '10': 'links'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_CreateInviteLink$json = {
  '1': 'CreateInviteLink',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'expireDate', '3': 3, '4': 1, '5': 3, '10': 'expireDate'},
    {'1': 'usageLimit', '3': 4, '4': 1, '5': 5, '10': 'usageLimit'},
    {'1': 'requestApproval', '3': 5, '4': 1, '5': 8, '10': 'requestApproval'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_CreateInviteLinkResult$json = {
  '1': 'CreateInviteLinkResult',
  '2': [
    {'1': 'link', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ChatInviteLink', '10': 'link'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_EditInviteLink$json = {
  '1': 'EditInviteLink',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'expireDate', '3': 4, '4': 1, '5': 3, '10': 'expireDate'},
    {'1': 'usageLimit', '3': 5, '4': 1, '5': 5, '10': 'usageLimit'},
    {'1': 'requestApproval', '3': 6, '4': 1, '5': 8, '10': 'requestApproval'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_EditInviteLinkResult$json = {
  '1': 'EditInviteLinkResult',
  '2': [
    {'1': 'link', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ChatInviteLink', '10': 'link'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_RevokeInviteLink$json = {
  '1': 'RevokeInviteLink',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_RevokeInviteLinkResult$json = {
  '1': 'RevokeInviteLinkResult',
  '2': [
    {'1': 'revoked', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ChatInviteLink', '10': 'revoked'},
    {'1': 'primary', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.ChatInviteLink', '10': 'primary'},
    {'1': 'updates', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_DeleteRevokedInviteLinks$json = {
  '1': 'DeleteRevokedInviteLinks',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_DeleteRevokedInviteLinksResult$json = {
  '1': 'DeleteRevokedInviteLinksResult',
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_JoinRequests$json = {
  '1': 'JoinRequests',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'offset', '3': 2, '4': 1, '5': 12, '10': 'offset'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_JoinRequestsResult$json = {
  '1': 'JoinRequestsResult',
  '2': [
    {'1': 'requests', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ChatJoinRequest', '10': 'requests'},
    {'1': 'profiles', '3': 2, '4': 3, '5': 11, '6': '.iperon.v1.Profile.Response', '10': 'profiles'},
    {'1': 'nextOffset', '3': 3, '4': 1, '5': 12, '10': 'nextOffset'},
    {'1': 'total', '3': 4, '4': 1, '5': 5, '10': 'total'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_AnswerJoinRequest$json = {
  '1': 'AnswerJoinRequest',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'userID', '3': 2, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'approve', '3': 3, '4': 1, '5': 8, '10': 'approve'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_AnswerJoinRequestResult$json = {
  '1': 'AnswerJoinRequestResult',
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
    {'1': 'checkUsername', '3': 32, '4': 1, '5': 11, '6': '.iperon.v1.Chats.CheckUsername', '9': 0, '10': 'checkUsername'},
    {'1': 'resolveLink', '3': 33, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ResolveLink', '9': 0, '10': 'resolveLink'},
    {'1': 'joinChat', '3': 34, '4': 1, '5': 11, '6': '.iperon.v1.Chats.JoinChat', '9': 0, '10': 'joinChat'},
    {'1': 'inviteLinks', '3': 35, '4': 1, '5': 11, '6': '.iperon.v1.Chats.InviteLinks', '9': 0, '10': 'inviteLinks'},
    {'1': 'createInviteLink', '3': 36, '4': 1, '5': 11, '6': '.iperon.v1.Chats.CreateInviteLink', '9': 0, '10': 'createInviteLink'},
    {'1': 'editInviteLink', '3': 37, '4': 1, '5': 11, '6': '.iperon.v1.Chats.EditInviteLink', '9': 0, '10': 'editInviteLink'},
    {'1': 'revokeInviteLink', '3': 38, '4': 1, '5': 11, '6': '.iperon.v1.Chats.RevokeInviteLink', '9': 0, '10': 'revokeInviteLink'},
    {
      '1': 'deleteRevokedInviteLinks',
      '3': 39,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.Chats.DeleteRevokedInviteLinks',
      '9': 0,
      '10': 'deleteRevokedInviteLinks'
    },
    {'1': 'joinRequests', '3': 40, '4': 1, '5': 11, '6': '.iperon.v1.Chats.JoinRequests', '9': 0, '10': 'joinRequests'},
    {'1': 'answerJoinRequest', '3': 41, '4': 1, '5': 11, '6': '.iperon.v1.Chats.AnswerJoinRequest', '9': 0, '10': 'answerJoinRequest'},
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
    {'1': 'checkUsername', '3': 32, '4': 1, '5': 11, '6': '.iperon.v1.Chats.CheckUsernameResult', '9': 0, '10': 'checkUsername'},
    {'1': 'resolveLink', '3': 33, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ResolveLinkResult', '9': 0, '10': 'resolveLink'},
    {'1': 'joinChat', '3': 34, '4': 1, '5': 11, '6': '.iperon.v1.Chats.JoinChatResult', '9': 0, '10': 'joinChat'},
    {'1': 'inviteLinks', '3': 35, '4': 1, '5': 11, '6': '.iperon.v1.Chats.InviteLinksResult', '9': 0, '10': 'inviteLinks'},
    {'1': 'createInviteLink', '3': 36, '4': 1, '5': 11, '6': '.iperon.v1.Chats.CreateInviteLinkResult', '9': 0, '10': 'createInviteLink'},
    {'1': 'editInviteLink', '3': 37, '4': 1, '5': 11, '6': '.iperon.v1.Chats.EditInviteLinkResult', '9': 0, '10': 'editInviteLink'},
    {'1': 'revokeInviteLink', '3': 38, '4': 1, '5': 11, '6': '.iperon.v1.Chats.RevokeInviteLinkResult', '9': 0, '10': 'revokeInviteLink'},
    {
      '1': 'deleteRevokedInviteLinks',
      '3': 39,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.Chats.DeleteRevokedInviteLinksResult',
      '9': 0,
      '10': 'deleteRevokedInviteLinks'
    },
    {'1': 'joinRequests', '3': 40, '4': 1, '5': 11, '6': '.iperon.v1.Chats.JoinRequestsResult', '9': 0, '10': 'joinRequests'},
    {
      '1': 'answerJoinRequest',
      '3': 41,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.Chats.AnswerJoinRequestResult',
      '9': 0,
      '10': 'answerJoinRequest'
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
        'syGy5pcGVyb24udjEuUHJvZmlsZS5SZXNwb25zZVIIcHJvZmlsZXMa7gEKC0NyZWF0ZUdyb3Vw'
        'EhQKBXRpdGxlGAEgASgJUgV0aXRsZRIUCgVhYm91dBgCIAEoCVIFYWJvdXQSJAoNbWVtYmVyVX'
        'NlcklEcxgDIAMoDFINbWVtYmVyVXNlcklEcxIgCgthdmF0YXJDZG5JRBgEIAEoDFILYXZhdGFy'
        'Q2RuSUQSGgoIcmFuZG9tSUQYBSABKANSCHJhbmRvbUlEEhoKCHVzZXJuYW1lGAYgASgJUgh1c2'
        'VybmFtZRIzCghqb2luTW9kZRgHIAEoDjIXLmlwZXJvbi52MS5DaGF0Sm9pbk1vZGVSCGpvaW5N'
        'b2RlGpoBChFDcmVhdGVHcm91cFJlc3VsdBIpCgZkaWFsb2cYASABKAsyES5pcGVyb24udjEuRG'
        'lhbG9nUgZkaWFsb2cSLAoRcmVzdHJpY3RlZFVzZXJJRHMYAiADKAxSEXJlc3RyaWN0ZWRVc2Vy'
        'SURzEiwKB3VwZGF0ZXMYAyABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxqhAwoIRW'
        'RpdENoYXQSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSGQoFdGl0bGUYAiABKAlIAFIFdGl0bGWI'
        'AQESGQoFYWJvdXQYAyABKAlIAVIFYWJvdXSIAQESJQoLYXZhdGFyQ2RuSUQYBCABKAxIAlILYX'
        'ZhdGFyQ2RuSUSIAQESOgoLZGVmYXVsdFJvbGUYBSABKA4yEy5pcGVyb24udjEuQ2hhdFJvbGVI'
        'A1ILZGVmYXVsdFJvbGWIAQESHwoIdXNlcm5hbWUYBiABKAlIBFIIdXNlcm5hbWWIAQESOAoIam'
        '9pbk1vZGUYByABKA4yFy5pcGVyb24udjEuQ2hhdEpvaW5Nb2RlSAVSCGpvaW5Nb2RliAEBEikK'
        'DWhpc3RvcnlIaWRkZW4YCCABKAhIBlINaGlzdG9yeUhpZGRlbogBAUIICgZfdGl0bGVCCAoGX2'
        'Fib3V0Qg4KDF9hdmF0YXJDZG5JREIOCgxfZGVmYXVsdFJvbGVCCwoJX3VzZXJuYW1lQgsKCV9q'
        'b2luTW9kZUIQCg5faGlzdG9yeUhpZGRlbho+Cg5FZGl0Q2hhdFJlc3VsdBIsCgd1cGRhdGVzGA'
        'EgASgLMhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMaPgoKQWRkTWVtYmVycxIWCgZjaGF0'
        'SUQYASABKAxSBmNoYXRJRBIYCgd1c2VySURzGAIgAygMUgd1c2VySURzGm4KEEFkZE1lbWJlcn'
        'NSZXN1bHQSLAoRcmVzdHJpY3RlZFVzZXJJRHMYASADKAxSEXJlc3RyaWN0ZWRVc2VySURzEiwK'
        'B3VwZGF0ZXMYAiABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxojCglMZWF2ZUNoYX'
        'QSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQaPwoPTGVhdmVDaGF0UmVzdWx0EiwKB3VwZGF0ZXMY'
        'ASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxokCgpEZWxldGVDaGF0EhYKBmNoYX'
        'RJRBgBIAEoDFIGY2hhdElEGkAKEERlbGV0ZUNoYXRSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzIS'
        'LmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzGk8KB01lbWJlcnMSFgoGY2hhdElEGAEgASgMUg'
        'ZjaGF0SUQSFgoGb2Zmc2V0GAIgASgMUgZvZmZzZXQSFAoFbGltaXQYAyABKAVSBWxpbWl0Gq8B'
        'Cg1NZW1iZXJzUmVzdWx0Ei8KB21lbWJlcnMYASADKAsyFS5pcGVyb24udjEuQ2hhdE1lbWJlcl'
        'IHbWVtYmVycxI3Cghwcm9maWxlcxgCIAMoCzIbLmlwZXJvbi52MS5Qcm9maWxlLlJlc3BvbnNl'
        'Ughwcm9maWxlcxIeCgpuZXh0T2Zmc2V0GAMgASgMUgpuZXh0T2Zmc2V0EhQKBXRvdGFsGAQgAS'
        'gFUgV0b3RhbBo/Cg1HZXRDaGF0c1N0YXRlEi4KBWNoYXRzGAEgAygLMhguaXBlcm9uLnYxLkNo'
        'YXRzLkNoYXRQdHNSBWNoYXRzGjMKB0NoYXRQdHMSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSEA'
        'oDcHRzGAIgASgDUgNwdHMaXQoTR2V0Q2hhdHNTdGF0ZVJlc3VsdBIyCgdjaGFuZ2VkGAEgAygL'
        'MhguaXBlcm9uLnYxLkNoYXRzLkNoYXRQdHNSB2NoYW5nZWQSEgoEZ29uZRgCIAMoDFIEZ29uZR'
        'pTChFHZXRDaGF0RGlmZmVyZW5jZRIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIQCgNwdHMYAiAB'
        'KANSA3B0cxIUCgVsaW1pdBgDIAEoBVIFbGltaXQatwEKF0dldENoYXREaWZmZXJlbmNlUmVzdW'
        'x0EisKB3VwZGF0ZXMYASADKAsyES5pcGVyb24udjEuVXBkYXRlUgd1cGRhdGVzEhAKA3B0cxgC'
        'IAEoA1IDcHRzEhgKB2hhc01vcmUYAyABKAhSB2hhc01vcmUSGAoHdG9vTG9uZxgEIAEoCFIHdG'
        '9vTG9uZxIpCgZkaWFsb2cYBSABKAsyES5pcGVyb24udjEuRGlhbG9nUgZkaWFsb2caaAoNU2V0'
        'TWVtYmVyUm9sZRIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIWCgZ1c2VySUQYAiABKAxSBnVzZX'
        'JJRBInCgRyb2xlGAMgASgOMhMuaXBlcm9uLnYxLkNoYXRSb2xlUgRyb2xlGkMKE1NldE1lbWJl'
        'clJvbGVSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdG'
        'VzGlAKDFJlbW92ZU1lbWJlchIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIWCgZ1c2VySUQYAiAB'
        'KAxSBnVzZXJJRBIQCgNiYW4YAyABKAhSA2JhbhpCChJSZW1vdmVNZW1iZXJSZXN1bHQSLAoHdX'
        'BkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzGk4KBkJhbm5lZBIWCgZj'
        'aGF0SUQYASABKAxSBmNoYXRJRBIWCgZvZmZzZXQYAiABKAxSBm9mZnNldBIUCgVsaW1pdBgDIA'
        'EoBVIFbGltaXQasgEKDEJhbm5lZFJlc3VsdBIzCgZiYW5uZWQYASADKAsyGy5pcGVyb24udjEu'
        'Q2hhdEJhbm5lZE1lbWJlclIGYmFubmVkEjcKCHByb2ZpbGVzGAIgAygLMhsuaXBlcm9uLnYxLl'
        'Byb2ZpbGUuUmVzcG9uc2VSCHByb2ZpbGVzEh4KCm5leHRPZmZzZXQYAyABKAxSCm5leHRPZmZz'
        'ZXQSFAoFdG90YWwYBCABKAVSBXRvdGFsGjcKBVVuYmFuEhYKBmNoYXRJRBgBIAEoDFIGY2hhdE'
        'lEEhYKBnVzZXJJRBgCIAEoDFIGdXNlcklEGg0KC1VuYmFuUmVzdWx0GoIBCghTZXRBZG1pbhIW'
        'CgZjaGF0SUQYASABKAxSBmNoYXRJRBIWCgZ1c2VySUQYAiABKAxSBnVzZXJJRBIyCgZyaWdodH'
        'MYAyABKAsyGi5pcGVyb24udjEuQ2hhdEFkbWluUmlnaHRzUgZyaWdodHMSEgoEcmFuaxgEIAEo'
        'CVIEcmFuaxo+Cg5TZXRBZG1pblJlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9uLnYxLl'
        'VwZGF0ZXNSB3VwZGF0ZXMaPQoLUmVtb3ZlQWRtaW4SFgoGY2hhdElEGAEgASgMUgZjaGF0SUQS'
        'FgoGdXNlcklEGAIgASgMUgZ1c2VySUQaQQoRUmVtb3ZlQWRtaW5SZXN1bHQSLAoHdXBkYXRlcx'
        'gBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzGlsKEVRyYW5zZmVyT3duZXJzaGlw'
        'EhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhYKBnVzZXJJRBgCIAEoDFIGdXNlcklEEhYKBnB3SG'
        'FzaBgDIAEoDFIGcHdIYXNoGkcKF1RyYW5zZmVyT3duZXJzaGlwUmVzdWx0EiwKB3VwZGF0ZXMY'
        'ASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxpPCg1DaGVja1VzZXJuYW1lEhoKCH'
        'VzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIiCgxleGNlcHRDaGF0SUQYAiABKAxSDGV4Y2VwdENo'
        'YXRJRBpNChNDaGVja1VzZXJuYW1lUmVzdWx0EhwKCWF2YWlsYWJsZRgBIAEoCFIJYXZhaWxhYm'
        'xlEhgKB2ludmFsaWQYAiABKAhSB2ludmFsaWQaIQoLUmVzb2x2ZUxpbmsSEgoEcGF0aBgBIAEo'
        'CVIEcGF0aBpwChFSZXNvbHZlTGlua1Jlc3VsdBIpCgZkaWFsb2cYASABKAsyES5pcGVyb24udj'
        'EuRGlhbG9nUgZkaWFsb2cSMAoHcHJldmlldxgCIAEoCzIWLmlwZXJvbi52MS5DaGF0UHJldmll'
        'd1IHcHJldmlldxoeCghKb2luQ2hhdBISCgRwYXRoGAEgASgJUgRwYXRoGocBCg5Kb2luQ2hhdF'
        'Jlc3VsdBIpCgZkaWFsb2cYASABKAsyES5pcGVyb24udjEuRGlhbG9nUgZkaWFsb2cSHAoJcmVx'
        'dWVzdGVkGAIgASgIUglyZXF1ZXN0ZWQSLAoHdXBkYXRlcxgDIAEoCzISLmlwZXJvbi52MS5VcG'
        'RhdGVzUgd1cGRhdGVzGiUKC0ludml0ZUxpbmtzEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEGkQK'
        'EUludml0ZUxpbmtzUmVzdWx0Ei8KBWxpbmtzGAEgAygLMhkuaXBlcm9uLnYxLkNoYXRJbnZpdG'
        'VMaW5rUgVsaW5rcxqqAQoQQ3JlYXRlSW52aXRlTGluaxIWCgZjaGF0SUQYASABKAxSBmNoYXRJ'
        'RBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSHgoKZXhwaXJlRGF0ZRgDIAEoA1IKZXhwaXJlRGF0ZR'
        'IeCgp1c2FnZUxpbWl0GAQgASgFUgp1c2FnZUxpbWl0EigKD3JlcXVlc3RBcHByb3ZhbBgFIAEo'
        'CFIPcmVxdWVzdEFwcHJvdmFsGkcKFkNyZWF0ZUludml0ZUxpbmtSZXN1bHQSLQoEbGluaxgBIA'
        'EoCzIZLmlwZXJvbi52MS5DaGF0SW52aXRlTGlua1IEbGluaxq8AQoORWRpdEludml0ZUxpbmsS'
        'FgoGY2hhdElEGAEgASgMUgZjaGF0SUQSEgoEY29kZRgCIAEoCVIEY29kZRIUCgV0aXRsZRgDIA'
        'EoCVIFdGl0bGUSHgoKZXhwaXJlRGF0ZRgEIAEoA1IKZXhwaXJlRGF0ZRIeCgp1c2FnZUxpbWl0'
        'GAUgASgFUgp1c2FnZUxpbWl0EigKD3JlcXVlc3RBcHByb3ZhbBgGIAEoCFIPcmVxdWVzdEFwcH'
        'JvdmFsGkUKFEVkaXRJbnZpdGVMaW5rUmVzdWx0Ei0KBGxpbmsYASABKAsyGS5pcGVyb24udjEu'
        'Q2hhdEludml0ZUxpbmtSBGxpbmsaPgoQUmV2b2tlSW52aXRlTGluaxIWCgZjaGF0SUQYASABKA'
        'xSBmNoYXRJRBISCgRjb2RlGAIgASgJUgRjb2RlGrABChZSZXZva2VJbnZpdGVMaW5rUmVzdWx0'
        'EjMKB3Jldm9rZWQYASABKAsyGS5pcGVyb24udjEuQ2hhdEludml0ZUxpbmtSB3Jldm9rZWQSMw'
        'oHcHJpbWFyeRgCIAEoCzIZLmlwZXJvbi52MS5DaGF0SW52aXRlTGlua1IHcHJpbWFyeRIsCgd1'
        'cGRhdGVzGAMgASgLMhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMaMgoYRGVsZXRlUmV2b2'
        'tlZEludml0ZUxpbmtzEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEGiAKHkRlbGV0ZVJldm9rZWRJ'
        'bnZpdGVMaW5rc1Jlc3VsdBpUCgxKb2luUmVxdWVzdHMSFgoGY2hhdElEGAEgASgMUgZjaGF0SU'
        'QSFgoGb2Zmc2V0GAIgASgMUgZvZmZzZXQSFAoFbGltaXQYAyABKAVSBWxpbWl0GrsBChJKb2lu'
        'UmVxdWVzdHNSZXN1bHQSNgoIcmVxdWVzdHMYASADKAsyGi5pcGVyb24udjEuQ2hhdEpvaW5SZX'
        'F1ZXN0UghyZXF1ZXN0cxI3Cghwcm9maWxlcxgCIAMoCzIbLmlwZXJvbi52MS5Qcm9maWxlLlJl'
        'c3BvbnNlUghwcm9maWxlcxIeCgpuZXh0T2Zmc2V0GAMgASgMUgpuZXh0T2Zmc2V0EhQKBXRvdG'
        'FsGAQgASgFUgV0b3RhbBpdChFBbnN3ZXJKb2luUmVxdWVzdBIWCgZjaGF0SUQYASABKAxSBmNo'
        'YXRJRBIWCgZ1c2VySUQYAiABKAxSBnVzZXJJRBIYCgdhcHByb3ZlGAMgASgIUgdhcHByb3ZlGk'
        'cKF0Fuc3dlckpvaW5SZXF1ZXN0UmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVyb24udjEu'
        'VXBkYXRlc1IHdXBkYXRlcxrHFQoHUmVxdWVzdBIrCgRsaXN0GAEgASgLMhUuaXBlcm9uLnYxLk'
        'NoYXRzLkxpc3RIAFIEbGlzdBJACgtvcGVuUHJpdmF0ZRgCIAEoCzIcLmlwZXJvbi52MS5DaGF0'
        'cy5PcGVuUHJpdmF0ZUgAUgtvcGVuUHJpdmF0ZRJACgtyZWFkSGlzdG9yeRgDIAEoCzIcLmlwZX'
        'Jvbi52MS5DaGF0cy5SZWFkSGlzdG9yeUgAUgtyZWFkSGlzdG9yeRI6CglzZXREaWFsb2cYBCAB'
        'KAsyGi5pcGVyb24udjEuQ2hhdHMuU2V0RGlhbG9nSABSCXNldERpYWxvZxJDCgxkZWxldGVEaW'
        'Fsb2cYBSABKAsyHS5pcGVyb24udjEuQ2hhdHMuRGVsZXRlRGlhbG9nSABSDGRlbGV0ZURpYWxv'
        'ZxI3CghyZWFkRGF0ZRgGIAEoCzIZLmlwZXJvbi52MS5DaGF0cy5SZWFkRGF0ZUgAUghyZWFkRG'
        'F0ZRI3CghjYW5Xcml0ZRgHIAEoCzIZLmlwZXJvbi52MS5DaGF0cy5DYW5Xcml0ZUgAUghjYW5X'
        'cml0ZRI6CglzYXZlRHJhZnQYCCABKAsyGi5pcGVyb24udjEuQ2hhdHMuU2F2ZURyYWZ0SABSCX'
        'NhdmVEcmFmdBI9CgpnZXRGb2xkZXJzGAkgASgLMhsuaXBlcm9uLnYxLkNoYXRzLkdldEZvbGRl'
        'cnNIAFIKZ2V0Rm9sZGVycxI9CgpzYXZlRm9sZGVyGAogASgLMhsuaXBlcm9uLnYxLkNoYXRzLl'
        'NhdmVGb2xkZXJIAFIKc2F2ZUZvbGRlchJDCgxkZWxldGVGb2xkZXIYCyABKAsyHS5pcGVyb24u'
        'djEuQ2hhdHMuRGVsZXRlRm9sZGVySABSDGRlbGV0ZUZvbGRlchJJCg5yZW9yZGVyRm9sZGVycx'
        'gMIAEoCzIfLmlwZXJvbi52MS5DaGF0cy5SZW9yZGVyRm9sZGVyc0gAUg5yZW9yZGVyRm9sZGVy'
        'cxJMCg9yZXNvbHZlVXNlcm5hbWUYDSABKAsyIC5pcGVyb24udjEuQ2hhdHMuUmVzb2x2ZVVzZX'
        'JuYW1lSABSD3Jlc29sdmVVc2VybmFtZRIxCgZzZXRUVEwYDiABKAsyFy5pcGVyb24udjEuQ2hh'
        'dHMuU2V0VFRMSABSBnNldFRUTBJGCg1zZXROb0ZvcndhcmRzGA8gASgLMh4uaXBlcm9uLnYxLk'
        'NoYXRzLlNldE5vRm9yd2FyZHNIAFINc2V0Tm9Gb3J3YXJkcxJACgtzZWFyY2hVc2VycxgQIAEo'
        'CzIcLmlwZXJvbi52MS5DaGF0cy5TZWFyY2hVc2Vyc0gAUgtzZWFyY2hVc2VycxJACgtjcmVhdG'
        'VHcm91cBgRIAEoCzIcLmlwZXJvbi52MS5DaGF0cy5DcmVhdGVHcm91cEgAUgtjcmVhdGVHcm91'
        'cBI3CghlZGl0Q2hhdBgSIAEoCzIZLmlwZXJvbi52MS5DaGF0cy5FZGl0Q2hhdEgAUghlZGl0Q2'
        'hhdBI9CgphZGRNZW1iZXJzGBMgASgLMhsuaXBlcm9uLnYxLkNoYXRzLkFkZE1lbWJlcnNIAFIK'
        'YWRkTWVtYmVycxI6CglsZWF2ZUNoYXQYFCABKAsyGi5pcGVyb24udjEuQ2hhdHMuTGVhdmVDaG'
        'F0SABSCWxlYXZlQ2hhdBI9CgpkZWxldGVDaGF0GBUgASgLMhsuaXBlcm9uLnYxLkNoYXRzLkRl'
        'bGV0ZUNoYXRIAFIKZGVsZXRlQ2hhdBI0CgdtZW1iZXJzGBYgASgLMhguaXBlcm9uLnYxLkNoYX'
        'RzLk1lbWJlcnNIAFIHbWVtYmVycxJGCg1nZXRDaGF0c1N0YXRlGBcgASgLMh4uaXBlcm9uLnYx'
        'LkNoYXRzLkdldENoYXRzU3RhdGVIAFINZ2V0Q2hhdHNTdGF0ZRJSChFnZXRDaGF0RGlmZmVyZW'
        '5jZRgYIAEoCzIiLmlwZXJvbi52MS5DaGF0cy5HZXRDaGF0RGlmZmVyZW5jZUgAUhFnZXRDaGF0'
        'RGlmZmVyZW5jZRJGCg1zZXRNZW1iZXJSb2xlGBkgASgLMh4uaXBlcm9uLnYxLkNoYXRzLlNldE'
        '1lbWJlclJvbGVIAFINc2V0TWVtYmVyUm9sZRJDCgxyZW1vdmVNZW1iZXIYGiABKAsyHS5pcGVy'
        'b24udjEuQ2hhdHMuUmVtb3ZlTWVtYmVySABSDHJlbW92ZU1lbWJlchIxCgZiYW5uZWQYGyABKA'
        'syFy5pcGVyb24udjEuQ2hhdHMuQmFubmVkSABSBmJhbm5lZBIuCgV1bmJhbhgcIAEoCzIWLmlw'
        'ZXJvbi52MS5DaGF0cy5VbmJhbkgAUgV1bmJhbhI3CghzZXRBZG1pbhgdIAEoCzIZLmlwZXJvbi'
        '52MS5DaGF0cy5TZXRBZG1pbkgAUghzZXRBZG1pbhJACgtyZW1vdmVBZG1pbhgeIAEoCzIcLmlw'
        'ZXJvbi52MS5DaGF0cy5SZW1vdmVBZG1pbkgAUgtyZW1vdmVBZG1pbhJSChF0cmFuc2Zlck93bm'
        'Vyc2hpcBgfIAEoCzIiLmlwZXJvbi52MS5DaGF0cy5UcmFuc2Zlck93bmVyc2hpcEgAUhF0cmFu'
        'c2Zlck93bmVyc2hpcBJGCg1jaGVja1VzZXJuYW1lGCAgASgLMh4uaXBlcm9uLnYxLkNoYXRzLk'
        'NoZWNrVXNlcm5hbWVIAFINY2hlY2tVc2VybmFtZRJACgtyZXNvbHZlTGluaxghIAEoCzIcLmlw'
        'ZXJvbi52MS5DaGF0cy5SZXNvbHZlTGlua0gAUgtyZXNvbHZlTGluaxI3Cghqb2luQ2hhdBgiIA'
        'EoCzIZLmlwZXJvbi52MS5DaGF0cy5Kb2luQ2hhdEgAUghqb2luQ2hhdBJACgtpbnZpdGVMaW5r'
        'cxgjIAEoCzIcLmlwZXJvbi52MS5DaGF0cy5JbnZpdGVMaW5rc0gAUgtpbnZpdGVMaW5rcxJPCh'
        'BjcmVhdGVJbnZpdGVMaW5rGCQgASgLMiEuaXBlcm9uLnYxLkNoYXRzLkNyZWF0ZUludml0ZUxp'
        'bmtIAFIQY3JlYXRlSW52aXRlTGluaxJJCg5lZGl0SW52aXRlTGluaxglIAEoCzIfLmlwZXJvbi'
        '52MS5DaGF0cy5FZGl0SW52aXRlTGlua0gAUg5lZGl0SW52aXRlTGluaxJPChByZXZva2VJbnZp'
        'dGVMaW5rGCYgASgLMiEuaXBlcm9uLnYxLkNoYXRzLlJldm9rZUludml0ZUxpbmtIAFIQcmV2b2'
        'tlSW52aXRlTGluaxJnChhkZWxldGVSZXZva2VkSW52aXRlTGlua3MYJyABKAsyKS5pcGVyb24u'
        'djEuQ2hhdHMuRGVsZXRlUmV2b2tlZEludml0ZUxpbmtzSABSGGRlbGV0ZVJldm9rZWRJbnZpdG'
        'VMaW5rcxJDCgxqb2luUmVxdWVzdHMYKCABKAsyHS5pcGVyb24udjEuQ2hhdHMuSm9pblJlcXVl'
        'c3RzSABSDGpvaW5SZXF1ZXN0cxJSChFhbnN3ZXJKb2luUmVxdWVzdBgpIAEoCzIiLmlwZXJvbi'
        '52MS5DaGF0cy5BbnN3ZXJKb2luUmVxdWVzdEgAUhFhbnN3ZXJKb2luUmVxdWVzdEIJCgdyZXF1'
        'ZXN0Gr8XCghSZXNwb25zZRIxCgRsaXN0GAEgASgLMhsuaXBlcm9uLnYxLkNoYXRzLkxpc3RSZX'
        'N1bHRIAFIEbGlzdBJGCgtvcGVuUHJpdmF0ZRgCIAEoCzIiLmlwZXJvbi52MS5DaGF0cy5PcGVu'
        'UHJpdmF0ZVJlc3VsdEgAUgtvcGVuUHJpdmF0ZRJGCgtyZWFkSGlzdG9yeRgDIAEoCzIiLmlwZX'
        'Jvbi52MS5DaGF0cy5SZWFkSGlzdG9yeVJlc3VsdEgAUgtyZWFkSGlzdG9yeRJACglzZXREaWFs'
        'b2cYBCABKAsyIC5pcGVyb24udjEuQ2hhdHMuU2V0RGlhbG9nUmVzdWx0SABSCXNldERpYWxvZx'
        'JJCgxkZWxldGVEaWFsb2cYBSABKAsyIy5pcGVyb24udjEuQ2hhdHMuRGVsZXRlRGlhbG9nUmVz'
        'dWx0SABSDGRlbGV0ZURpYWxvZxI9CghyZWFkRGF0ZRgGIAEoCzIfLmlwZXJvbi52MS5DaGF0cy'
        '5SZWFkRGF0ZVJlc3VsdEgAUghyZWFkRGF0ZRI9CghjYW5Xcml0ZRgHIAEoCzIfLmlwZXJvbi52'
        'MS5DaGF0cy5DYW5Xcml0ZVJlc3VsdEgAUghjYW5Xcml0ZRJACglzYXZlRHJhZnQYCCABKAsyIC'
        '5pcGVyb24udjEuQ2hhdHMuU2F2ZURyYWZ0UmVzdWx0SABSCXNhdmVEcmFmdBJDCgpnZXRGb2xk'
        'ZXJzGAkgASgLMiEuaXBlcm9uLnYxLkNoYXRzLkdldEZvbGRlcnNSZXN1bHRIAFIKZ2V0Rm9sZG'
        'VycxJDCgpzYXZlRm9sZGVyGAogASgLMiEuaXBlcm9uLnYxLkNoYXRzLlNhdmVGb2xkZXJSZXN1'
        'bHRIAFIKc2F2ZUZvbGRlchJJCgxkZWxldGVGb2xkZXIYCyABKAsyIy5pcGVyb24udjEuQ2hhdH'
        'MuRGVsZXRlRm9sZGVyUmVzdWx0SABSDGRlbGV0ZUZvbGRlchJPCg5yZW9yZGVyRm9sZGVycxgM'
        'IAEoCzIlLmlwZXJvbi52MS5DaGF0cy5SZW9yZGVyRm9sZGVyc1Jlc3VsdEgAUg5yZW9yZGVyRm'
        '9sZGVycxJSCg9yZXNvbHZlVXNlcm5hbWUYDSABKAsyJi5pcGVyb24udjEuQ2hhdHMuUmVzb2x2'
        'ZVVzZXJuYW1lUmVzdWx0SABSD3Jlc29sdmVVc2VybmFtZRI3CgZzZXRUVEwYDiABKAsyHS5pcG'
        'Vyb24udjEuQ2hhdHMuU2V0VFRMUmVzdWx0SABSBnNldFRUTBJMCg1zZXROb0ZvcndhcmRzGA8g'
        'ASgLMiQuaXBlcm9uLnYxLkNoYXRzLlNldE5vRm9yd2FyZHNSZXN1bHRIAFINc2V0Tm9Gb3J3YX'
        'JkcxJGCgtzZWFyY2hVc2VycxgQIAEoCzIiLmlwZXJvbi52MS5DaGF0cy5TZWFyY2hVc2Vyc1Jl'
        'c3VsdEgAUgtzZWFyY2hVc2VycxJGCgtjcmVhdGVHcm91cBgRIAEoCzIiLmlwZXJvbi52MS5DaG'
        'F0cy5DcmVhdGVHcm91cFJlc3VsdEgAUgtjcmVhdGVHcm91cBI9CghlZGl0Q2hhdBgSIAEoCzIf'
        'LmlwZXJvbi52MS5DaGF0cy5FZGl0Q2hhdFJlc3VsdEgAUghlZGl0Q2hhdBJDCgphZGRNZW1iZX'
        'JzGBMgASgLMiEuaXBlcm9uLnYxLkNoYXRzLkFkZE1lbWJlcnNSZXN1bHRIAFIKYWRkTWVtYmVy'
        'cxJACglsZWF2ZUNoYXQYFCABKAsyIC5pcGVyb24udjEuQ2hhdHMuTGVhdmVDaGF0UmVzdWx0SA'
        'BSCWxlYXZlQ2hhdBJDCgpkZWxldGVDaGF0GBUgASgLMiEuaXBlcm9uLnYxLkNoYXRzLkRlbGV0'
        'ZUNoYXRSZXN1bHRIAFIKZGVsZXRlQ2hhdBI6CgdtZW1iZXJzGBYgASgLMh4uaXBlcm9uLnYxLk'
        'NoYXRzLk1lbWJlcnNSZXN1bHRIAFIHbWVtYmVycxJMCg1nZXRDaGF0c1N0YXRlGBcgASgLMiQu'
        'aXBlcm9uLnYxLkNoYXRzLkdldENoYXRzU3RhdGVSZXN1bHRIAFINZ2V0Q2hhdHNTdGF0ZRJYCh'
        'FnZXRDaGF0RGlmZmVyZW5jZRgYIAEoCzIoLmlwZXJvbi52MS5DaGF0cy5HZXRDaGF0RGlmZmVy'
        'ZW5jZVJlc3VsdEgAUhFnZXRDaGF0RGlmZmVyZW5jZRJMCg1zZXRNZW1iZXJSb2xlGBkgASgLMi'
        'QuaXBlcm9uLnYxLkNoYXRzLlNldE1lbWJlclJvbGVSZXN1bHRIAFINc2V0TWVtYmVyUm9sZRJJ'
        'CgxyZW1vdmVNZW1iZXIYGiABKAsyIy5pcGVyb24udjEuQ2hhdHMuUmVtb3ZlTWVtYmVyUmVzdW'
        'x0SABSDHJlbW92ZU1lbWJlchI3CgZiYW5uZWQYGyABKAsyHS5pcGVyb24udjEuQ2hhdHMuQmFu'
        'bmVkUmVzdWx0SABSBmJhbm5lZBI0CgV1bmJhbhgcIAEoCzIcLmlwZXJvbi52MS5DaGF0cy5Vbm'
        'JhblJlc3VsdEgAUgV1bmJhbhI9CghzZXRBZG1pbhgdIAEoCzIfLmlwZXJvbi52MS5DaGF0cy5T'
        'ZXRBZG1pblJlc3VsdEgAUghzZXRBZG1pbhJGCgtyZW1vdmVBZG1pbhgeIAEoCzIiLmlwZXJvbi'
        '52MS5DaGF0cy5SZW1vdmVBZG1pblJlc3VsdEgAUgtyZW1vdmVBZG1pbhJYChF0cmFuc2Zlck93'
        'bmVyc2hpcBgfIAEoCzIoLmlwZXJvbi52MS5DaGF0cy5UcmFuc2Zlck93bmVyc2hpcFJlc3VsdE'
        'gAUhF0cmFuc2Zlck93bmVyc2hpcBJMCg1jaGVja1VzZXJuYW1lGCAgASgLMiQuaXBlcm9uLnYx'
        'LkNoYXRzLkNoZWNrVXNlcm5hbWVSZXN1bHRIAFINY2hlY2tVc2VybmFtZRJGCgtyZXNvbHZlTG'
        'luaxghIAEoCzIiLmlwZXJvbi52MS5DaGF0cy5SZXNvbHZlTGlua1Jlc3VsdEgAUgtyZXNvbHZl'
        'TGluaxI9Cghqb2luQ2hhdBgiIAEoCzIfLmlwZXJvbi52MS5DaGF0cy5Kb2luQ2hhdFJlc3VsdE'
        'gAUghqb2luQ2hhdBJGCgtpbnZpdGVMaW5rcxgjIAEoCzIiLmlwZXJvbi52MS5DaGF0cy5JbnZp'
        'dGVMaW5rc1Jlc3VsdEgAUgtpbnZpdGVMaW5rcxJVChBjcmVhdGVJbnZpdGVMaW5rGCQgASgLMi'
        'cuaXBlcm9uLnYxLkNoYXRzLkNyZWF0ZUludml0ZUxpbmtSZXN1bHRIAFIQY3JlYXRlSW52aXRl'
        'TGluaxJPCg5lZGl0SW52aXRlTGluaxglIAEoCzIlLmlwZXJvbi52MS5DaGF0cy5FZGl0SW52aX'
        'RlTGlua1Jlc3VsdEgAUg5lZGl0SW52aXRlTGluaxJVChByZXZva2VJbnZpdGVMaW5rGCYgASgL'
        'MicuaXBlcm9uLnYxLkNoYXRzLlJldm9rZUludml0ZUxpbmtSZXN1bHRIAFIQcmV2b2tlSW52aX'
        'RlTGluaxJtChhkZWxldGVSZXZva2VkSW52aXRlTGlua3MYJyABKAsyLy5pcGVyb24udjEuQ2hh'
        'dHMuRGVsZXRlUmV2b2tlZEludml0ZUxpbmtzUmVzdWx0SABSGGRlbGV0ZVJldm9rZWRJbnZpdG'
        'VMaW5rcxJJCgxqb2luUmVxdWVzdHMYKCABKAsyIy5pcGVyb24udjEuQ2hhdHMuSm9pblJlcXVl'
        'c3RzUmVzdWx0SABSDGpvaW5SZXF1ZXN0cxJYChFhbnN3ZXJKb2luUmVxdWVzdBgpIAEoCzIoLm'
        'lwZXJvbi52MS5DaGF0cy5BbnN3ZXJKb2luUmVxdWVzdFJlc3VsdEgAUhFhbnN3ZXJKb2luUmVx'
        'dWVzdEIKCghyZXNwb25zZQ==');

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
