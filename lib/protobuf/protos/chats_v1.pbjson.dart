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

@$core.Deprecated('Use chatReactionsModeDescriptor instead')
const ChatReactionsMode$json = {
  '1': 'ChatReactionsMode',
  '2': [
    {'1': 'CHAT_REACTIONS_ALL', '2': 0},
    {'1': 'CHAT_REACTIONS_SOME', '2': 1},
    {'1': 'CHAT_REACTIONS_NONE', '2': 2},
  ],
};

/// Descriptor for `ChatReactionsMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List chatReactionsModeDescriptor =
    $convert.base64Decode('ChFDaGF0UmVhY3Rpb25zTW9kZRIWChJDSEFUX1JFQUNUSU9OU19BTEwQABIXChNDSEFUX1JFQU'
        'NUSU9OU19TT01FEAESFwoTQ0hBVF9SRUFDVElPTlNfTk9ORRAC');

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
    {'1': 'slowMode', '3': 15, '4': 1, '5': 5, '10': 'slowMode'},
    {'1': 'newcomerMediaDelay', '3': 16, '4': 1, '5': 5, '10': 'newcomerMediaDelay'},
    {'1': 'membersHidden', '3': 17, '4': 1, '5': 8, '10': 'membersHidden'},
    {'1': 'reactionsMode', '3': 18, '4': 1, '5': 14, '6': '.iperon.v1.ChatReactionsMode', '10': 'reactionsMode'},
    {'1': 'reactions', '3': 19, '4': 3, '5': 9, '10': 'reactions'},
    {'1': 'noForwards', '3': 20, '4': 1, '5': 8, '10': 'noForwards'},
    {'1': 'signMessages', '3': 21, '4': 1, '5': 8, '10': 'signMessages'},
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
        'b2RlEiQKDWhpc3RvcnlIaWRkZW4YDiABKAhSDWhpc3RvcnlIaWRkZW4SGgoIc2xvd01vZGUYDy'
        'ABKAVSCHNsb3dNb2RlEi4KEm5ld2NvbWVyTWVkaWFEZWxheRgQIAEoBVISbmV3Y29tZXJNZWRp'
        'YURlbGF5EiQKDW1lbWJlcnNIaWRkZW4YESABKAhSDW1lbWJlcnNIaWRkZW4SQgoNcmVhY3Rpb2'
        '5zTW9kZRgSIAEoDjIcLmlwZXJvbi52MS5DaGF0UmVhY3Rpb25zTW9kZVINcmVhY3Rpb25zTW9k'
        'ZRIcCglyZWFjdGlvbnMYEyADKAlSCXJlYWN0aW9ucxIeCgpub0ZvcndhcmRzGBQgASgIUgpub0'
        'ZvcndhcmRzEiIKDHNpZ25NZXNzYWdlcxgVIAEoCFIMc2lnbk1lc3NhZ2Vz');

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

@$core.Deprecated('Use messageSystemNoticeDescriptor instead')
const MessageSystemNotice$json = {
  '1': 'MessageSystemNotice',
  '2': [
    {'1': 'kind', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.MessageSystemNotice.Kind', '10': 'kind'},
    {'1': 'sessionID', '3': 2, '4': 1, '5': 12, '10': 'sessionID'},
    {'1': 'deviceModel', '3': 3, '4': 1, '5': 9, '10': 'deviceModel'},
    {'1': 'os', '3': 4, '4': 1, '5': 5, '10': 'os'},
    {'1': 'osVersion', '3': 5, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'appVersion', '3': 6, '4': 1, '5': 9, '10': 'appVersion'},
    {'1': 'ip', '3': 7, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'locationEnglish', '3': 8, '4': 1, '5': 9, '10': 'locationEnglish'},
    {'1': 'locationRussian', '3': 9, '4': 1, '5': 9, '10': 'locationRussian'},
    {'1': 'loginMethod', '3': 10, '4': 1, '5': 14, '6': '.iperon.v1.MessageSystemNotice.LoginMethod', '10': 'loginMethod'},
    {'1': 'email', '3': 11, '4': 1, '5': 9, '10': 'email'},
    {'1': 'passkeyLabel', '3': 12, '4': 1, '5': 9, '10': 'passkeyLabel'},
  ],
  '4': [MessageSystemNotice_Kind$json, MessageSystemNotice_LoginMethod$json],
};

@$core.Deprecated('Use messageSystemNoticeDescriptor instead')
const MessageSystemNotice_Kind$json = {
  '1': 'Kind',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'NEW_LOGIN', '2': 1},
    {'1': 'CLOUD_PASSWORD_SET', '2': 2},
    {'1': 'CLOUD_PASSWORD_CHANGED', '2': 3},
    {'1': 'CLOUD_PASSWORD_DISABLED', '2': 4},
    {'1': 'CLOUD_PASSWORD_RESET', '2': 5},
    {'1': 'CLOUD_PASSWORD_WRONG', '2': 6},
    {'1': 'RECOVERY_EMAIL_SET', '2': 7},
    {'1': 'PASSKEY_ADDED', '2': 8},
    {'1': 'PASSKEY_REMOVED', '2': 9},
  ],
};

@$core.Deprecated('Use messageSystemNoticeDescriptor instead')
const MessageSystemNotice_LoginMethod$json = {
  '1': 'LoginMethod',
  '2': [
    {'1': 'LOGIN_METHOD_UNKNOWN', '2': 0},
    {'1': 'CALL_PASSWORD', '2': 1},
    {'1': 'SMS', '2': 2},
    {'1': 'PASSKEY', '2': 3},
    {'1': 'YANDEX', '2': 4},
  ],
};

/// Descriptor for `MessageSystemNotice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageSystemNoticeDescriptor =
    $convert.base64Decode('ChNNZXNzYWdlU3lzdGVtTm90aWNlEjcKBGtpbmQYASABKA4yIy5pcGVyb24udjEuTWVzc2FnZV'
        'N5c3RlbU5vdGljZS5LaW5kUgRraW5kEhwKCXNlc3Npb25JRBgCIAEoDFIJc2Vzc2lvbklEEiAK'
        'C2RldmljZU1vZGVsGAMgASgJUgtkZXZpY2VNb2RlbBIOCgJvcxgEIAEoBVICb3MSHAoJb3NWZX'
        'JzaW9uGAUgASgJUglvc1ZlcnNpb24SHgoKYXBwVmVyc2lvbhgGIAEoCVIKYXBwVmVyc2lvbhIO'
        'CgJpcBgHIAEoCVICaXASKAoPbG9jYXRpb25FbmdsaXNoGAggASgJUg9sb2NhdGlvbkVuZ2xpc2'
        'gSKAoPbG9jYXRpb25SdXNzaWFuGAkgASgJUg9sb2NhdGlvblJ1c3NpYW4STAoLbG9naW5NZXRo'
        'b2QYCiABKA4yKi5pcGVyb24udjEuTWVzc2FnZVN5c3RlbU5vdGljZS5Mb2dpbk1ldGhvZFILbG'
        '9naW5NZXRob2QSFAoFZW1haWwYCyABKAlSBWVtYWlsEiIKDHBhc3NrZXlMYWJlbBgMIAEoCVIM'
        'cGFzc2tleUxhYmVsIucBCgRLaW5kEgsKB1VOS05PV04QABINCglORVdfTE9HSU4QARIWChJDTE'
        '9VRF9QQVNTV09SRF9TRVQQAhIaChZDTE9VRF9QQVNTV09SRF9DSEFOR0VEEAMSGwoXQ0xPVURf'
        'UEFTU1dPUkRfRElTQUJMRUQQBBIYChRDTE9VRF9QQVNTV09SRF9SRVNFVBAFEhgKFENMT1VEX1'
        'BBU1NXT1JEX1dST05HEAYSFgoSUkVDT1ZFUllfRU1BSUxfU0VUEAcSEQoNUEFTU0tFWV9BRERF'
        'RBAIEhMKD1BBU1NLRVlfUkVNT1ZFRBAJIlwKC0xvZ2luTWV0aG9kEhgKFExPR0lOX01FVEhPRF'
        '9VTktOT1dOEAASEQoNQ0FMTF9QQVNTV09SRBABEgcKA1NNUxACEgsKB1BBU1NLRVkQAxIKCgZZ'
        'QU5ERVgQBA==');

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

@$core.Deprecated('Use messagePollDescriptor instead')
const MessagePoll$json = {
  '1': 'MessagePoll',
  '2': [
    {'1': 'question', '3': 1, '4': 1, '5': 9, '10': 'question'},
    {'1': 'options', '3': 2, '4': 3, '5': 9, '10': 'options'},
    {'1': 'anonymous', '3': 3, '4': 1, '5': 8, '10': 'anonymous'},
    {'1': 'multiple', '3': 4, '4': 1, '5': 8, '10': 'multiple'},
    {'1': 'quiz', '3': 5, '4': 1, '5': 8, '10': 'quiz'},
    {'1': 'correctOption', '3': 6, '4': 1, '5': 5, '10': 'correctOption'},
    {'1': 'explanation', '3': 7, '4': 1, '5': 9, '10': 'explanation'},
  ],
};

/// Descriptor for `MessagePoll`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messagePollDescriptor =
    $convert.base64Decode('CgtNZXNzYWdlUG9sbBIaCghxdWVzdGlvbhgBIAEoCVIIcXVlc3Rpb24SGAoHb3B0aW9ucxgCIA'
        'MoCVIHb3B0aW9ucxIcCglhbm9ueW1vdXMYAyABKAhSCWFub255bW91cxIaCghtdWx0aXBsZRgE'
        'IAEoCFIIbXVsdGlwbGUSEgoEcXVpehgFIAEoCFIEcXVpehIkCg1jb3JyZWN0T3B0aW9uGAYgAS'
        'gFUg1jb3JyZWN0T3B0aW9uEiAKC2V4cGxhbmF0aW9uGAcgASgJUgtleHBsYW5hdGlvbg==');

@$core.Deprecated('Use pollResultsDescriptor instead')
const PollResults$json = {
  '1': 'PollResults',
  '2': [
    {'1': 'votes', '3': 1, '4': 3, '5': 5, '10': 'votes'},
    {'1': 'chosen', '3': 2, '4': 3, '5': 5, '10': 'chosen'},
    {'1': 'totalVoters', '3': 3, '4': 1, '5': 5, '10': 'totalVoters'},
    {'1': 'closed', '3': 4, '4': 1, '5': 8, '10': 'closed'},
    {'1': 'correctOption', '3': 5, '4': 1, '5': 5, '10': 'correctOption'},
    {'1': 'explanation', '3': 6, '4': 1, '5': 9, '10': 'explanation'},
  ],
};

/// Descriptor for `PollResults`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pollResultsDescriptor =
    $convert.base64Decode('CgtQb2xsUmVzdWx0cxIUCgV2b3RlcxgBIAMoBVIFdm90ZXMSFgoGY2hvc2VuGAIgAygFUgZjaG'
        '9zZW4SIAoLdG90YWxWb3RlcnMYAyABKAVSC3RvdGFsVm90ZXJzEhYKBmNsb3NlZBgEIAEoCFIG'
        'Y2xvc2VkEiQKDWNvcnJlY3RPcHRpb24YBSABKAVSDWNvcnJlY3RPcHRpb24SIAoLZXhwbGFuYX'
        'Rpb24YBiABKAlSC2V4cGxhbmF0aW9u');

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
    {'1': 'poll', '3': 13, '4': 1, '5': 11, '6': '.iperon.v1.MessagePoll', '10': 'poll'},
    {'1': 'systemNotice', '3': 14, '4': 1, '5': 11, '6': '.iperon.v1.MessageSystemNotice', '10': 'systemNotice'},
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
        'FnZUNoYXRBY3Rpb25SCmNoYXRBY3Rpb24SKgoEcG9sbBgNIAEoCzIWLmlwZXJvbi52MS5NZXNz'
        'YWdlUG9sbFIEcG9sbBJCCgxzeXN0ZW1Ob3RpY2UYDiABKAsyHi5pcGVyb24udjEuTWVzc2FnZV'
        'N5c3RlbU5vdGljZVIMc3lzdGVtTm90aWNl');

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

@$core.Deprecated('Use reactionCountDescriptor instead')
const ReactionCount$json = {
  '1': 'ReactionCount',
  '2': [
    {'1': 'emoji', '3': 1, '4': 1, '5': 9, '10': 'emoji'},
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
    {'1': 'chosenOrder', '3': 3, '4': 1, '5': 5, '10': 'chosenOrder'},
  ],
};

/// Descriptor for `ReactionCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reactionCountDescriptor =
    $convert.base64Decode('Cg1SZWFjdGlvbkNvdW50EhQKBWVtb2ppGAEgASgJUgVlbW9qaRIUCgVjb3VudBgCIAEoBVIFY2'
        '91bnQSIAoLY2hvc2VuT3JkZXIYAyABKAVSC2Nob3Nlbk9yZGVy');

@$core.Deprecated('Use messageReactionsDescriptor instead')
const MessageReactions$json = {
  '1': 'MessageReactions',
  '2': [
    {'1': 'reactions', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.MessageReaction', '10': 'reactions'},
    {'1': 'counts', '3': 2, '4': 3, '5': 11, '6': '.iperon.v1.ReactionCount', '10': 'counts'},
  ],
};

/// Descriptor for `MessageReactions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageReactionsDescriptor =
    $convert.base64Decode('ChBNZXNzYWdlUmVhY3Rpb25zEjgKCXJlYWN0aW9ucxgBIAMoCzIaLmlwZXJvbi52MS5NZXNzYW'
        'dlUmVhY3Rpb25SCXJlYWN0aW9ucxIwCgZjb3VudHMYAiADKAsyGC5pcGVyb24udjEuUmVhY3Rp'
        'b25Db3VudFIGY291bnRz');

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
    {'1': 'mentionUnread', '3': 13, '4': 1, '5': 8, '10': 'mentionUnread'},
    {'1': 'poll', '3': 14, '4': 1, '5': 11, '6': '.iperon.v1.PollResults', '10': 'poll'},
    {'1': 'authorSignature', '3': 15, '4': 1, '5': 9, '10': 'authorSignature'},
    {'1': 'postOut', '3': 16, '4': 1, '5': 8, '10': 'postOut'},
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
        'wKCXR0bFBlcmlvZBgMIAEoBVIJdHRsUGVyaW9kEiQKDW1lbnRpb25VbnJlYWQYDSABKAhSDW1l'
        'bnRpb25VbnJlYWQSKgoEcG9sbBgOIAEoCzIWLmlwZXJvbi52MS5Qb2xsUmVzdWx0c1IEcG9sbB'
        'IoCg9hdXRob3JTaWduYXR1cmUYDyABKAlSD2F1dGhvclNpZ25hdHVyZRIYCgdwb3N0T3V0GBAg'
        'ASgIUgdwb3N0T3V0');

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
    {'1': 'unreadMentionsCount', '3': 25, '4': 1, '5': 5, '10': 'unreadMentionsCount'},
    {'1': 'slowModeUntil', '3': 26, '4': 1, '5': 3, '10': 'slowModeUntil'},
    {'1': 'joinedAt', '3': 27, '4': 1, '5': 3, '10': 'joinedAt'},
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
        'F1ZXN0cxgYIAEoBVIPcGVuZGluZ1JlcXVlc3RzEjAKE3VucmVhZE1lbnRpb25zQ291bnQYGSAB'
        'KAVSE3VucmVhZE1lbnRpb25zQ291bnQSJAoNc2xvd01vZGVVbnRpbBgaIAEoA1INc2xvd01vZG'
        'VVbnRpbBIaCghqb2luZWRBdBgbIAEoA1IIam9pbmVkQXQ=');

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
    {'1': 'mentions', '3': 21, '4': 1, '5': 11, '6': '.iperon.v1.Update.MentionsChanged', '9': 0, '10': 'mentions'},
    {'1': 'messagePoll', '3': 22, '4': 1, '5': 11, '6': '.iperon.v1.Update.MessagePollChanged', '9': 0, '10': 'messagePoll'},
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
    Update_MentionsChanged$json,
    Update_MessagePollChanged$json,
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
    {'1': 'actorUserID', '3': 6, '4': 1, '5': 12, '10': 'actorUserID'},
    {'1': 'actorEmojis', '3': 7, '4': 3, '5': 9, '10': 'actorEmojis'},
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
const Update_MentionsChanged$json = {
  '1': 'MentionsChanged',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageIDs', '3': 2, '4': 3, '5': 3, '10': 'messageIDs'},
    {'1': 'unread', '3': 3, '4': 1, '5': 8, '10': 'unread'},
    {'1': 'unreadMentionsCount', '3': 4, '4': 1, '5': 5, '10': 'unreadMentionsCount'},
  ],
};

@$core.Deprecated('Use updateDescriptor instead')
const Update_MessagePollChanged$json = {
  '1': 'MessagePollChanged',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
    {'1': 'results', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.PollResults', '10': 'results'},
    {'1': 'actorUserID', '3': 4, '4': 1, '5': 12, '10': 'actorUserID'},
    {'1': 'actorOptions', '3': 5, '4': 3, '5': 5, '10': 'actorOptions'},
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
        'LmlwZXJvbi52MS5VcGRhdGUuSm9pblJlcXVlc3RzQ2hhbmdlZEgAUgxqb2luUmVxdWVzdHMSPw'
        'oIbWVudGlvbnMYFSABKAsyIS5pcGVyb24udjEuVXBkYXRlLk1lbnRpb25zQ2hhbmdlZEgAUght'
        'ZW50aW9ucxJICgttZXNzYWdlUG9sbBgWIAEoCzIkLmlwZXJvbi52MS5VcGRhdGUuTWVzc2FnZV'
        'BvbGxDaGFuZ2VkSABSC21lc3NhZ2VQb2xsGmkKCk5ld01lc3NhZ2USMAoHbWVzc2FnZRgBIAEo'
        'CzIWLmlwZXJvbi52MS5DaGF0TWVzc2FnZVIHbWVzc2FnZRIpCgZkaWFsb2cYAiABKAsyES5pcG'
        'Vyb24udjEuRGlhbG9nUgZkaWFsb2caPwoLRWRpdE1lc3NhZ2USMAoHbWVzc2FnZRgBIAEoCzIW'
        'LmlwZXJvbi52MS5DaGF0TWVzc2FnZVIHbWVzc2FnZRpICg5EZWxldGVNZXNzYWdlcxIWCgZjaG'
        'F0SUQYASABKAxSBmNoYXRJRBIeCgptZXNzYWdlSURzGAIgAygDUgptZXNzYWdlSURzGlsKCVJl'
        'YWRJbmJveBIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIUCgVtYXhJRBgCIAEoA1IFbWF4SUQSIA'
        'oLdW5yZWFkQ291bnQYAyABKAVSC3VucmVhZENvdW50GjoKClJlYWRPdXRib3gSFgoGY2hhdElE'
        'GAEgASgMUgZjaGF0SUQSFAoFbWF4SUQYAiABKANSBW1heElEGkYKDFJlYWRDb250ZW50cxIWCg'
        'ZjaGF0SUQYASABKAxSBmNoYXRJRBIeCgptZXNzYWdlSURzGAIgAygDUgptZXNzYWdlSURzGjsK'
        'DkRpYWxvZ1NldHRpbmdzEikKBmRpYWxvZxgBIAEoCzIRLmlwZXJvbi52MS5EaWFsb2dSBmRpYW'
        'xvZxonCg1EaWFsb2dEZWxldGVkEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEGngKDlBpbm5lZE1l'
        'c3NhZ2VzEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEh4KCm1lc3NhZ2VJRHMYAiADKANSCm1lc3'
        'NhZ2VJRHMSFgoGcGlubmVkGAMgASgIUgZwaW5uZWQSFgoGc2hhcmVkGAQgASgIUgZzaGFyZWQa'
        'rAIKF01lc3NhZ2VSZWFjdGlvbnNDaGFuZ2VkEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhwKCW'
        '1lc3NhZ2VJRBgCIAEoA1IJbWVzc2FnZUlEEjkKCXJlYWN0aW9ucxgDIAEoCzIbLmlwZXJvbi52'
        'MS5NZXNzYWdlUmVhY3Rpb25zUglyZWFjdGlvbnMSMgoUdW5yZWFkUmVhY3Rpb25zQ291bnQYBC'
        'ABKAVSFHVucmVhZFJlYWN0aW9uc0NvdW50EigKD3JlYWN0aW9uc1VucmVhZBgFIAEoCFIPcmVh'
        'Y3Rpb25zVW5yZWFkEiAKC2FjdG9yVXNlcklEGAYgASgMUgthY3RvclVzZXJJRBIgCgthY3Rvck'
        'Vtb2ppcxgHIAMoCVILYWN0b3JFbW9qaXMaewoNUmVhZFJlYWN0aW9ucxIWCgZjaGF0SUQYASAB'
        'KAxSBmNoYXRJRBIeCgptZXNzYWdlSURzGAIgAygDUgptZXNzYWdlSURzEjIKFHVucmVhZFJlYW'
        'N0aW9uc0NvdW50GAMgASgFUhR1bnJlYWRSZWFjdGlvbnNDb3VudBpQChdTY2hlZHVsZWRNZXNz'
        'YWdlQ2hhbmdlZBI1CgdtZXNzYWdlGAEgASgLMhsuaXBlcm9uLnYxLlNjaGVkdWxlZE1lc3NhZ2'
        'VSB21lc3NhZ2UavgEKEFNjaGVkdWxlZERlbGV0ZWQSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQS'
        'IgoMc2NoZWR1bGVkSURzGAIgAygDUgxzY2hlZHVsZWRJRHMSQQoGcmVhc29uGAMgASgOMikuaX'
        'Blcm9uLnYxLlVwZGF0ZS5TY2hlZHVsZWREZWxldGVkLlJlYXNvblIGcmVhc29uIisKBlJlYXNv'
        'bhILCgdERUxFVEVEEAASCAoEU0VOVBABEgoKBkZBSUxFRBACGjoKD0NoYXRJbmZvQ2hhbmdlZB'
        'InCgRjaGF0GAEgASgLMhMuaXBlcm9uLnYxLkNoYXRJbmZvUgRjaGF0GtYBChJDaGF0TWVtYmVy'
        'c0NoYW5nZWQSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSKwoFYWRkZWQYAiADKAsyFS5pcGVyb2'
        '4udjEuQ2hhdE1lbWJlclIFYWRkZWQSJgoOcmVtb3ZlZFVzZXJJRHMYAyADKAxSDnJlbW92ZWRV'
        'c2VySURzEiIKDG1lbWJlcnNDb3VudBgEIAEoBVIMbWVtYmVyc0NvdW50Ei8KB3VwZGF0ZWQYBS'
        'ADKAsyFS5pcGVyb24udjEuQ2hhdE1lbWJlclIHdXBkYXRlZBp3ChNKb2luUmVxdWVzdHNDaGFu'
        'Z2VkEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEiIKDHBlbmRpbmdDb3VudBgCIAEoBVIMcGVuZG'
        'luZ0NvdW50EiQKDXJlY2VudFVzZXJJRHMYAyADKAxSDXJlY2VudFVzZXJJRHMakwEKD01lbnRp'
        'b25zQ2hhbmdlZBIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIeCgptZXNzYWdlSURzGAIgAygDUg'
        'ptZXNzYWdlSURzEhYKBnVucmVhZBgDIAEoCFIGdW5yZWFkEjAKE3VucmVhZE1lbnRpb25zQ291'
        'bnQYBCABKAVSE3VucmVhZE1lbnRpb25zQ291bnQawgEKEk1lc3NhZ2VQb2xsQ2hhbmdlZBIWCg'
        'ZjaGF0SUQYASABKAxSBmNoYXRJRBIcCgltZXNzYWdlSUQYAiABKANSCW1lc3NhZ2VJRBIwCgdy'
        'ZXN1bHRzGAMgASgLMhYuaXBlcm9uLnYxLlBvbGxSZXN1bHRzUgdyZXN1bHRzEiAKC2FjdG9yVX'
        'NlcklEGAQgASgMUgthY3RvclVzZXJJRBIiCgxhY3Rvck9wdGlvbnMYBSADKAVSDGFjdG9yT3B0'
        'aW9ucxo2CglEaWFsb2dOZXcSKQoGZGlhbG9nGAEgASgLMhEuaXBlcm9uLnYxLkRpYWxvZ1IGZG'
        'lhbG9nQggKBnVwZGF0ZQ==');

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
    Chats_SearchChats$json,
    Chats_FoundChat$json,
    Chats_SearchChatsResult$json,
    Chats_CreateGroup$json,
    Chats_CreateGroupResult$json,
    Chats_EditChat$json,
    Chats_ChatReactionsSettings$json,
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
const Chats_SearchChats$json = {
  '1': 'SearchChats',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_FoundChat$json = {
  '1': 'FoundChat',
  '2': [
    {'1': 'chat', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.ChatInfo', '10': 'chat'},
    {'1': 'member', '3': 2, '4': 1, '5': 8, '10': 'member'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_SearchChatsResult$json = {
  '1': 'SearchChatsResult',
  '2': [
    {'1': 'chats', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Chats.FoundChat', '10': 'chats'},
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
    {'1': 'historyHidden', '3': 8, '4': 1, '5': 8, '10': 'historyHidden'},
    {'1': 'channel', '3': 9, '4': 1, '5': 8, '10': 'channel'},
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
    {'1': 'slowMode', '3': 9, '4': 1, '5': 5, '9': 7, '10': 'slowMode', '17': true},
    {'1': 'newcomerMediaDelay', '3': 10, '4': 1, '5': 5, '9': 8, '10': 'newcomerMediaDelay', '17': true},
    {'1': 'membersHidden', '3': 11, '4': 1, '5': 8, '9': 9, '10': 'membersHidden', '17': true},
    {'1': 'reactions', '3': 12, '4': 1, '5': 11, '6': '.iperon.v1.Chats.ChatReactionsSettings', '9': 10, '10': 'reactions', '17': true},
    {'1': 'noForwards', '3': 13, '4': 1, '5': 8, '9': 11, '10': 'noForwards', '17': true},
    {'1': 'signMessages', '3': 14, '4': 1, '5': 8, '9': 12, '10': 'signMessages', '17': true},
  ],
  '8': [
    {'1': '_title'},
    {'1': '_about'},
    {'1': '_avatarCdnID'},
    {'1': '_defaultRole'},
    {'1': '_username'},
    {'1': '_joinMode'},
    {'1': '_historyHidden'},
    {'1': '_slowMode'},
    {'1': '_newcomerMediaDelay'},
    {'1': '_membersHidden'},
    {'1': '_reactions'},
    {'1': '_noForwards'},
    {'1': '_signMessages'},
  ],
};

@$core.Deprecated('Use chatsDescriptor instead')
const Chats_ChatReactionsSettings$json = {
  '1': 'ChatReactionsSettings',
  '2': [
    {'1': 'mode', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.ChatReactionsMode', '10': 'mode'},
    {'1': 'emojis', '3': 2, '4': 3, '5': 9, '10': 'emojis'},
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
    {'1': 'query', '3': 4, '4': 1, '5': 9, '10': 'query'},
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
    {'1': 'searchChats', '3': 42, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SearchChats', '9': 0, '10': 'searchChats'},
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
    {'1': 'searchChats', '3': 42, '4': 1, '5': 11, '6': '.iperon.v1.Chats.SearchChatsResult', '9': 0, '10': 'searchChats'},
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
        'syGy5pcGVyb24udjEuUHJvZmlsZS5SZXNwb25zZVIIcHJvZmlsZXMaOQoLU2VhcmNoQ2hhdHMS'
        'FAoFcXVlcnkYASABKAlSBXF1ZXJ5EhQKBWxpbWl0GAIgASgFUgVsaW1pdBpMCglGb3VuZENoYX'
        'QSJwoEY2hhdBgBIAEoCzITLmlwZXJvbi52MS5DaGF0SW5mb1IEY2hhdBIWCgZtZW1iZXIYAiAB'
        'KAhSBm1lbWJlchpFChFTZWFyY2hDaGF0c1Jlc3VsdBIwCgVjaGF0cxgBIAMoCzIaLmlwZXJvbi'
        '52MS5DaGF0cy5Gb3VuZENoYXRSBWNoYXRzGq4CCgtDcmVhdGVHcm91cBIUCgV0aXRsZRgBIAEo'
        'CVIFdGl0bGUSFAoFYWJvdXQYAiABKAlSBWFib3V0EiQKDW1lbWJlclVzZXJJRHMYAyADKAxSDW'
        '1lbWJlclVzZXJJRHMSIAoLYXZhdGFyQ2RuSUQYBCABKAxSC2F2YXRhckNkbklEEhoKCHJhbmRv'
        'bUlEGAUgASgDUghyYW5kb21JRBIaCgh1c2VybmFtZRgGIAEoCVIIdXNlcm5hbWUSMwoIam9pbk'
        '1vZGUYByABKA4yFy5pcGVyb24udjEuQ2hhdEpvaW5Nb2RlUghqb2luTW9kZRIkCg1oaXN0b3J5'
        'SGlkZGVuGAggASgIUg1oaXN0b3J5SGlkZGVuEhgKB2NoYW5uZWwYCSABKAhSB2NoYW5uZWwamg'
        'EKEUNyZWF0ZUdyb3VwUmVzdWx0EikKBmRpYWxvZxgBIAEoCzIRLmlwZXJvbi52MS5EaWFsb2dS'
        'BmRpYWxvZxIsChFyZXN0cmljdGVkVXNlcklEcxgCIAMoDFIRcmVzdHJpY3RlZFVzZXJJRHMSLA'
        'oHdXBkYXRlcxgDIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzGp8GCghFZGl0Q2hh'
        'dBIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIZCgV0aXRsZRgCIAEoCUgAUgV0aXRsZYgBARIZCg'
        'VhYm91dBgDIAEoCUgBUgVhYm91dIgBARIlCgthdmF0YXJDZG5JRBgEIAEoDEgCUgthdmF0YXJD'
        'ZG5JRIgBARI6CgtkZWZhdWx0Um9sZRgFIAEoDjITLmlwZXJvbi52MS5DaGF0Um9sZUgDUgtkZW'
        'ZhdWx0Um9sZYgBARIfCgh1c2VybmFtZRgGIAEoCUgEUgh1c2VybmFtZYgBARI4Cghqb2luTW9k'
        'ZRgHIAEoDjIXLmlwZXJvbi52MS5DaGF0Sm9pbk1vZGVIBVIIam9pbk1vZGWIAQESKQoNaGlzdG'
        '9yeUhpZGRlbhgIIAEoCEgGUg1oaXN0b3J5SGlkZGVuiAEBEh8KCHNsb3dNb2RlGAkgASgFSAdS'
        'CHNsb3dNb2RliAEBEjMKEm5ld2NvbWVyTWVkaWFEZWxheRgKIAEoBUgIUhJuZXdjb21lck1lZG'
        'lhRGVsYXmIAQESKQoNbWVtYmVyc0hpZGRlbhgLIAEoCEgJUg1tZW1iZXJzSGlkZGVuiAEBEkkK'
        'CXJlYWN0aW9ucxgMIAEoCzImLmlwZXJvbi52MS5DaGF0cy5DaGF0UmVhY3Rpb25zU2V0dGluZ3'
        'NIClIJcmVhY3Rpb25ziAEBEiMKCm5vRm9yd2FyZHMYDSABKAhIC1IKbm9Gb3J3YXJkc4gBARIn'
        'CgxzaWduTWVzc2FnZXMYDiABKAhIDFIMc2lnbk1lc3NhZ2VziAEBQggKBl90aXRsZUIICgZfYW'
        'JvdXRCDgoMX2F2YXRhckNkbklEQg4KDF9kZWZhdWx0Um9sZUILCglfdXNlcm5hbWVCCwoJX2pv'
        'aW5Nb2RlQhAKDl9oaXN0b3J5SGlkZGVuQgsKCV9zbG93TW9kZUIVChNfbmV3Y29tZXJNZWRpYU'
        'RlbGF5QhAKDl9tZW1iZXJzSGlkZGVuQgwKCl9yZWFjdGlvbnNCDQoLX25vRm9yd2FyZHNCDwoN'
        'X3NpZ25NZXNzYWdlcxphChVDaGF0UmVhY3Rpb25zU2V0dGluZ3MSMAoEbW9kZRgBIAEoDjIcLm'
        'lwZXJvbi52MS5DaGF0UmVhY3Rpb25zTW9kZVIEbW9kZRIWCgZlbW9qaXMYAiADKAlSBmVtb2pp'
        'cxo+Cg5FZGl0Q2hhdFJlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9uLnYxLlVwZGF0ZX'
        'NSB3VwZGF0ZXMaPgoKQWRkTWVtYmVycxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIYCgd1c2Vy'
        'SURzGAIgAygMUgd1c2VySURzGm4KEEFkZE1lbWJlcnNSZXN1bHQSLAoRcmVzdHJpY3RlZFVzZX'
        'JJRHMYASADKAxSEXJlc3RyaWN0ZWRVc2VySURzEiwKB3VwZGF0ZXMYAiABKAsyEi5pcGVyb24u'
        'djEuVXBkYXRlc1IHdXBkYXRlcxojCglMZWF2ZUNoYXQSFgoGY2hhdElEGAEgASgMUgZjaGF0SU'
        'QaPwoPTGVhdmVDaGF0UmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVyb24udjEuVXBkYXRl'
        'c1IHdXBkYXRlcxokCgpEZWxldGVDaGF0EhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEGkAKEERlbG'
        'V0ZUNoYXRSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRh'
        'dGVzGmUKB01lbWJlcnMSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSFgoGb2Zmc2V0GAIgASgMUg'
        'ZvZmZzZXQSFAoFbGltaXQYAyABKAVSBWxpbWl0EhQKBXF1ZXJ5GAQgASgJUgVxdWVyeRqvAQoN'
        'TWVtYmVyc1Jlc3VsdBIvCgdtZW1iZXJzGAEgAygLMhUuaXBlcm9uLnYxLkNoYXRNZW1iZXJSB2'
        '1lbWJlcnMSNwoIcHJvZmlsZXMYAiADKAsyGy5pcGVyb24udjEuUHJvZmlsZS5SZXNwb25zZVII'
        'cHJvZmlsZXMSHgoKbmV4dE9mZnNldBgDIAEoDFIKbmV4dE9mZnNldBIUCgV0b3RhbBgEIAEoBV'
        'IFdG90YWwaPwoNR2V0Q2hhdHNTdGF0ZRIuCgVjaGF0cxgBIAMoCzIYLmlwZXJvbi52MS5DaGF0'
        'cy5DaGF0UHRzUgVjaGF0cxozCgdDaGF0UHRzEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhAKA3'
        'B0cxgCIAEoA1IDcHRzGl0KE0dldENoYXRzU3RhdGVSZXN1bHQSMgoHY2hhbmdlZBgBIAMoCzIY'
        'LmlwZXJvbi52MS5DaGF0cy5DaGF0UHRzUgdjaGFuZ2VkEhIKBGdvbmUYAiADKAxSBGdvbmUaUw'
        'oRR2V0Q2hhdERpZmZlcmVuY2USFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSEAoDcHRzGAIgASgD'
        'UgNwdHMSFAoFbGltaXQYAyABKAVSBWxpbWl0GrcBChdHZXRDaGF0RGlmZmVyZW5jZVJlc3VsdB'
        'IrCgd1cGRhdGVzGAEgAygLMhEuaXBlcm9uLnYxLlVwZGF0ZVIHdXBkYXRlcxIQCgNwdHMYAiAB'
        'KANSA3B0cxIYCgdoYXNNb3JlGAMgASgIUgdoYXNNb3JlEhgKB3Rvb0xvbmcYBCABKAhSB3Rvb0'
        'xvbmcSKQoGZGlhbG9nGAUgASgLMhEuaXBlcm9uLnYxLkRpYWxvZ1IGZGlhbG9nGmgKDVNldE1l'
        'bWJlclJvbGUSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSFgoGdXNlcklEGAIgASgMUgZ1c2VySU'
        'QSJwoEcm9sZRgDIAEoDjITLmlwZXJvbi52MS5DaGF0Um9sZVIEcm9sZRpDChNTZXRNZW1iZXJS'
        'b2xlUmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcx'
        'pQCgxSZW1vdmVNZW1iZXISFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSFgoGdXNlcklEGAIgASgM'
        'UgZ1c2VySUQSEAoDYmFuGAMgASgIUgNiYW4aQgoSUmVtb3ZlTWVtYmVyUmVzdWx0EiwKB3VwZG'
        'F0ZXMYASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxpOCgZCYW5uZWQSFgoGY2hh'
        'dElEGAEgASgMUgZjaGF0SUQSFgoGb2Zmc2V0GAIgASgMUgZvZmZzZXQSFAoFbGltaXQYAyABKA'
        'VSBWxpbWl0GrIBCgxCYW5uZWRSZXN1bHQSMwoGYmFubmVkGAEgAygLMhsuaXBlcm9uLnYxLkNo'
        'YXRCYW5uZWRNZW1iZXJSBmJhbm5lZBI3Cghwcm9maWxlcxgCIAMoCzIbLmlwZXJvbi52MS5Qcm'
        '9maWxlLlJlc3BvbnNlUghwcm9maWxlcxIeCgpuZXh0T2Zmc2V0GAMgASgMUgpuZXh0T2Zmc2V0'
        'EhQKBXRvdGFsGAQgASgFUgV0b3RhbBo3CgVVbmJhbhIWCgZjaGF0SUQYASABKAxSBmNoYXRJRB'
        'IWCgZ1c2VySUQYAiABKAxSBnVzZXJJRBoNCgtVbmJhblJlc3VsdBqCAQoIU2V0QWRtaW4SFgoG'
        'Y2hhdElEGAEgASgMUgZjaGF0SUQSFgoGdXNlcklEGAIgASgMUgZ1c2VySUQSMgoGcmlnaHRzGA'
        'MgASgLMhouaXBlcm9uLnYxLkNoYXRBZG1pblJpZ2h0c1IGcmlnaHRzEhIKBHJhbmsYBCABKAlS'
        'BHJhbmsaPgoOU2V0QWRtaW5SZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcG'
        'RhdGVzUgd1cGRhdGVzGj0KC1JlbW92ZUFkbWluEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhYK'
        'BnVzZXJJRBgCIAEoDFIGdXNlcklEGkEKEVJlbW92ZUFkbWluUmVzdWx0EiwKB3VwZGF0ZXMYAS'
        'ABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxpbChFUcmFuc2Zlck93bmVyc2hpcBIW'
        'CgZjaGF0SUQYASABKAxSBmNoYXRJRBIWCgZ1c2VySUQYAiABKAxSBnVzZXJJRBIWCgZwd0hhc2'
        'gYAyABKAxSBnB3SGFzaBpHChdUcmFuc2Zlck93bmVyc2hpcFJlc3VsdBIsCgd1cGRhdGVzGAEg'
        'ASgLMhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMaTwoNQ2hlY2tVc2VybmFtZRIaCgh1c2'
        'VybmFtZRgBIAEoCVIIdXNlcm5hbWUSIgoMZXhjZXB0Q2hhdElEGAIgASgMUgxleGNlcHRDaGF0'
        'SUQaTQoTQ2hlY2tVc2VybmFtZVJlc3VsdBIcCglhdmFpbGFibGUYASABKAhSCWF2YWlsYWJsZR'
        'IYCgdpbnZhbGlkGAIgASgIUgdpbnZhbGlkGiEKC1Jlc29sdmVMaW5rEhIKBHBhdGgYASABKAlS'
        'BHBhdGgacAoRUmVzb2x2ZUxpbmtSZXN1bHQSKQoGZGlhbG9nGAEgASgLMhEuaXBlcm9uLnYxLk'
        'RpYWxvZ1IGZGlhbG9nEjAKB3ByZXZpZXcYAiABKAsyFi5pcGVyb24udjEuQ2hhdFByZXZpZXdS'
        'B3ByZXZpZXcaHgoISm9pbkNoYXQSEgoEcGF0aBgBIAEoCVIEcGF0aBqHAQoOSm9pbkNoYXRSZX'
        'N1bHQSKQoGZGlhbG9nGAEgASgLMhEuaXBlcm9uLnYxLkRpYWxvZ1IGZGlhbG9nEhwKCXJlcXVl'
        'c3RlZBgCIAEoCFIJcmVxdWVzdGVkEiwKB3VwZGF0ZXMYAyABKAsyEi5pcGVyb24udjEuVXBkYX'
        'Rlc1IHdXBkYXRlcxolCgtJbnZpdGVMaW5rcxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBpEChFJ'
        'bnZpdGVMaW5rc1Jlc3VsdBIvCgVsaW5rcxgBIAMoCzIZLmlwZXJvbi52MS5DaGF0SW52aXRlTG'
        'lua1IFbGlua3MaqgEKEENyZWF0ZUludml0ZUxpbmsSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQS'
        'FAoFdGl0bGUYAiABKAlSBXRpdGxlEh4KCmV4cGlyZURhdGUYAyABKANSCmV4cGlyZURhdGUSHg'
        'oKdXNhZ2VMaW1pdBgEIAEoBVIKdXNhZ2VMaW1pdBIoCg9yZXF1ZXN0QXBwcm92YWwYBSABKAhS'
        'D3JlcXVlc3RBcHByb3ZhbBpHChZDcmVhdGVJbnZpdGVMaW5rUmVzdWx0Ei0KBGxpbmsYASABKA'
        'syGS5pcGVyb24udjEuQ2hhdEludml0ZUxpbmtSBGxpbmsavAEKDkVkaXRJbnZpdGVMaW5rEhYK'
        'BmNoYXRJRBgBIAEoDFIGY2hhdElEEhIKBGNvZGUYAiABKAlSBGNvZGUSFAoFdGl0bGUYAyABKA'
        'lSBXRpdGxlEh4KCmV4cGlyZURhdGUYBCABKANSCmV4cGlyZURhdGUSHgoKdXNhZ2VMaW1pdBgF'
        'IAEoBVIKdXNhZ2VMaW1pdBIoCg9yZXF1ZXN0QXBwcm92YWwYBiABKAhSD3JlcXVlc3RBcHByb3'
        'ZhbBpFChRFZGl0SW52aXRlTGlua1Jlc3VsdBItCgRsaW5rGAEgASgLMhkuaXBlcm9uLnYxLkNo'
        'YXRJbnZpdGVMaW5rUgRsaW5rGj4KEFJldm9rZUludml0ZUxpbmsSFgoGY2hhdElEGAEgASgMUg'
        'ZjaGF0SUQSEgoEY29kZRgCIAEoCVIEY29kZRqwAQoWUmV2b2tlSW52aXRlTGlua1Jlc3VsdBIz'
        'CgdyZXZva2VkGAEgASgLMhkuaXBlcm9uLnYxLkNoYXRJbnZpdGVMaW5rUgdyZXZva2VkEjMKB3'
        'ByaW1hcnkYAiABKAsyGS5pcGVyb24udjEuQ2hhdEludml0ZUxpbmtSB3ByaW1hcnkSLAoHdXBk'
        'YXRlcxgDIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzGjIKGERlbGV0ZVJldm9rZW'
        'RJbnZpdGVMaW5rcxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBogCh5EZWxldGVSZXZva2VkSW52'
        'aXRlTGlua3NSZXN1bHQaVAoMSm9pblJlcXVlc3RzEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEh'
        'YKBm9mZnNldBgCIAEoDFIGb2Zmc2V0EhQKBWxpbWl0GAMgASgFUgVsaW1pdBq7AQoSSm9pblJl'
        'cXVlc3RzUmVzdWx0EjYKCHJlcXVlc3RzGAEgAygLMhouaXBlcm9uLnYxLkNoYXRKb2luUmVxdW'
        'VzdFIIcmVxdWVzdHMSNwoIcHJvZmlsZXMYAiADKAsyGy5pcGVyb24udjEuUHJvZmlsZS5SZXNw'
        'b25zZVIIcHJvZmlsZXMSHgoKbmV4dE9mZnNldBgDIAEoDFIKbmV4dE9mZnNldBIUCgV0b3RhbB'
        'gEIAEoBVIFdG90YWwaXQoRQW5zd2VySm9pblJlcXVlc3QSFgoGY2hhdElEGAEgASgMUgZjaGF0'
        'SUQSFgoGdXNlcklEGAIgASgMUgZ1c2VySUQSGAoHYXBwcm92ZRgDIAEoCFIHYXBwcm92ZRpHCh'
        'dBbnN3ZXJKb2luUmVxdWVzdFJlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9uLnYxLlVw'
        'ZGF0ZXNSB3VwZGF0ZXMaiRYKB1JlcXVlc3QSKwoEbGlzdBgBIAEoCzIVLmlwZXJvbi52MS5DaG'
        'F0cy5MaXN0SABSBGxpc3QSQAoLb3BlblByaXZhdGUYAiABKAsyHC5pcGVyb24udjEuQ2hhdHMu'
        'T3BlblByaXZhdGVIAFILb3BlblByaXZhdGUSQAoLcmVhZEhpc3RvcnkYAyABKAsyHC5pcGVyb2'
        '4udjEuQ2hhdHMuUmVhZEhpc3RvcnlIAFILcmVhZEhpc3RvcnkSOgoJc2V0RGlhbG9nGAQgASgL'
        'MhouaXBlcm9uLnYxLkNoYXRzLlNldERpYWxvZ0gAUglzZXREaWFsb2cSQwoMZGVsZXRlRGlhbG'
        '9nGAUgASgLMh0uaXBlcm9uLnYxLkNoYXRzLkRlbGV0ZURpYWxvZ0gAUgxkZWxldGVEaWFsb2cS'
        'NwoIcmVhZERhdGUYBiABKAsyGS5pcGVyb24udjEuQ2hhdHMuUmVhZERhdGVIAFIIcmVhZERhdG'
        'USNwoIY2FuV3JpdGUYByABKAsyGS5pcGVyb24udjEuQ2hhdHMuQ2FuV3JpdGVIAFIIY2FuV3Jp'
        'dGUSOgoJc2F2ZURyYWZ0GAggASgLMhouaXBlcm9uLnYxLkNoYXRzLlNhdmVEcmFmdEgAUglzYX'
        'ZlRHJhZnQSPQoKZ2V0Rm9sZGVycxgJIAEoCzIbLmlwZXJvbi52MS5DaGF0cy5HZXRGb2xkZXJz'
        'SABSCmdldEZvbGRlcnMSPQoKc2F2ZUZvbGRlchgKIAEoCzIbLmlwZXJvbi52MS5DaGF0cy5TYX'
        'ZlRm9sZGVySABSCnNhdmVGb2xkZXISQwoMZGVsZXRlRm9sZGVyGAsgASgLMh0uaXBlcm9uLnYx'
        'LkNoYXRzLkRlbGV0ZUZvbGRlckgAUgxkZWxldGVGb2xkZXISSQoOcmVvcmRlckZvbGRlcnMYDC'
        'ABKAsyHy5pcGVyb24udjEuQ2hhdHMuUmVvcmRlckZvbGRlcnNIAFIOcmVvcmRlckZvbGRlcnMS'
        'TAoPcmVzb2x2ZVVzZXJuYW1lGA0gASgLMiAuaXBlcm9uLnYxLkNoYXRzLlJlc29sdmVVc2Vybm'
        'FtZUgAUg9yZXNvbHZlVXNlcm5hbWUSMQoGc2V0VFRMGA4gASgLMhcuaXBlcm9uLnYxLkNoYXRz'
        'LlNldFRUTEgAUgZzZXRUVEwSRgoNc2V0Tm9Gb3J3YXJkcxgPIAEoCzIeLmlwZXJvbi52MS5DaG'
        'F0cy5TZXROb0ZvcndhcmRzSABSDXNldE5vRm9yd2FyZHMSQAoLc2VhcmNoVXNlcnMYECABKAsy'
        'HC5pcGVyb24udjEuQ2hhdHMuU2VhcmNoVXNlcnNIAFILc2VhcmNoVXNlcnMSQAoLY3JlYXRlR3'
        'JvdXAYESABKAsyHC5pcGVyb24udjEuQ2hhdHMuQ3JlYXRlR3JvdXBIAFILY3JlYXRlR3JvdXAS'
        'NwoIZWRpdENoYXQYEiABKAsyGS5pcGVyb24udjEuQ2hhdHMuRWRpdENoYXRIAFIIZWRpdENoYX'
        'QSPQoKYWRkTWVtYmVycxgTIAEoCzIbLmlwZXJvbi52MS5DaGF0cy5BZGRNZW1iZXJzSABSCmFk'
        'ZE1lbWJlcnMSOgoJbGVhdmVDaGF0GBQgASgLMhouaXBlcm9uLnYxLkNoYXRzLkxlYXZlQ2hhdE'
        'gAUglsZWF2ZUNoYXQSPQoKZGVsZXRlQ2hhdBgVIAEoCzIbLmlwZXJvbi52MS5DaGF0cy5EZWxl'
        'dGVDaGF0SABSCmRlbGV0ZUNoYXQSNAoHbWVtYmVycxgWIAEoCzIYLmlwZXJvbi52MS5DaGF0cy'
        '5NZW1iZXJzSABSB21lbWJlcnMSRgoNZ2V0Q2hhdHNTdGF0ZRgXIAEoCzIeLmlwZXJvbi52MS5D'
        'aGF0cy5HZXRDaGF0c1N0YXRlSABSDWdldENoYXRzU3RhdGUSUgoRZ2V0Q2hhdERpZmZlcmVuY2'
        'UYGCABKAsyIi5pcGVyb24udjEuQ2hhdHMuR2V0Q2hhdERpZmZlcmVuY2VIAFIRZ2V0Q2hhdERp'
        'ZmZlcmVuY2USRgoNc2V0TWVtYmVyUm9sZRgZIAEoCzIeLmlwZXJvbi52MS5DaGF0cy5TZXRNZW'
        '1iZXJSb2xlSABSDXNldE1lbWJlclJvbGUSQwoMcmVtb3ZlTWVtYmVyGBogASgLMh0uaXBlcm9u'
        'LnYxLkNoYXRzLlJlbW92ZU1lbWJlckgAUgxyZW1vdmVNZW1iZXISMQoGYmFubmVkGBsgASgLMh'
        'cuaXBlcm9uLnYxLkNoYXRzLkJhbm5lZEgAUgZiYW5uZWQSLgoFdW5iYW4YHCABKAsyFi5pcGVy'
        'b24udjEuQ2hhdHMuVW5iYW5IAFIFdW5iYW4SNwoIc2V0QWRtaW4YHSABKAsyGS5pcGVyb24udj'
        'EuQ2hhdHMuU2V0QWRtaW5IAFIIc2V0QWRtaW4SQAoLcmVtb3ZlQWRtaW4YHiABKAsyHC5pcGVy'
        'b24udjEuQ2hhdHMuUmVtb3ZlQWRtaW5IAFILcmVtb3ZlQWRtaW4SUgoRdHJhbnNmZXJPd25lcn'
        'NoaXAYHyABKAsyIi5pcGVyb24udjEuQ2hhdHMuVHJhbnNmZXJPd25lcnNoaXBIAFIRdHJhbnNm'
        'ZXJPd25lcnNoaXASRgoNY2hlY2tVc2VybmFtZRggIAEoCzIeLmlwZXJvbi52MS5DaGF0cy5DaG'
        'Vja1VzZXJuYW1lSABSDWNoZWNrVXNlcm5hbWUSQAoLcmVzb2x2ZUxpbmsYISABKAsyHC5pcGVy'
        'b24udjEuQ2hhdHMuUmVzb2x2ZUxpbmtIAFILcmVzb2x2ZUxpbmsSNwoIam9pbkNoYXQYIiABKA'
        'syGS5pcGVyb24udjEuQ2hhdHMuSm9pbkNoYXRIAFIIam9pbkNoYXQSQAoLaW52aXRlTGlua3MY'
        'IyABKAsyHC5pcGVyb24udjEuQ2hhdHMuSW52aXRlTGlua3NIAFILaW52aXRlTGlua3MSTwoQY3'
        'JlYXRlSW52aXRlTGluaxgkIAEoCzIhLmlwZXJvbi52MS5DaGF0cy5DcmVhdGVJbnZpdGVMaW5r'
        'SABSEGNyZWF0ZUludml0ZUxpbmsSSQoOZWRpdEludml0ZUxpbmsYJSABKAsyHy5pcGVyb24udj'
        'EuQ2hhdHMuRWRpdEludml0ZUxpbmtIAFIOZWRpdEludml0ZUxpbmsSTwoQcmV2b2tlSW52aXRl'
        'TGluaxgmIAEoCzIhLmlwZXJvbi52MS5DaGF0cy5SZXZva2VJbnZpdGVMaW5rSABSEHJldm9rZU'
        'ludml0ZUxpbmsSZwoYZGVsZXRlUmV2b2tlZEludml0ZUxpbmtzGCcgASgLMikuaXBlcm9uLnYx'
        'LkNoYXRzLkRlbGV0ZVJldm9rZWRJbnZpdGVMaW5rc0gAUhhkZWxldGVSZXZva2VkSW52aXRlTG'
        'lua3MSQwoMam9pblJlcXVlc3RzGCggASgLMh0uaXBlcm9uLnYxLkNoYXRzLkpvaW5SZXF1ZXN0'
        'c0gAUgxqb2luUmVxdWVzdHMSUgoRYW5zd2VySm9pblJlcXVlc3QYKSABKAsyIi5pcGVyb24udj'
        'EuQ2hhdHMuQW5zd2VySm9pblJlcXVlc3RIAFIRYW5zd2VySm9pblJlcXVlc3QSQAoLc2VhcmNo'
        'Q2hhdHMYKiABKAsyHC5pcGVyb24udjEuQ2hhdHMuU2VhcmNoQ2hhdHNIAFILc2VhcmNoQ2hhdH'
        'NCCQoHcmVxdWVzdBqHGAoIUmVzcG9uc2USMQoEbGlzdBgBIAEoCzIbLmlwZXJvbi52MS5DaGF0'
        'cy5MaXN0UmVzdWx0SABSBGxpc3QSRgoLb3BlblByaXZhdGUYAiABKAsyIi5pcGVyb24udjEuQ2'
        'hhdHMuT3BlblByaXZhdGVSZXN1bHRIAFILb3BlblByaXZhdGUSRgoLcmVhZEhpc3RvcnkYAyAB'
        'KAsyIi5pcGVyb24udjEuQ2hhdHMuUmVhZEhpc3RvcnlSZXN1bHRIAFILcmVhZEhpc3RvcnkSQA'
        'oJc2V0RGlhbG9nGAQgASgLMiAuaXBlcm9uLnYxLkNoYXRzLlNldERpYWxvZ1Jlc3VsdEgAUglz'
        'ZXREaWFsb2cSSQoMZGVsZXRlRGlhbG9nGAUgASgLMiMuaXBlcm9uLnYxLkNoYXRzLkRlbGV0ZU'
        'RpYWxvZ1Jlc3VsdEgAUgxkZWxldGVEaWFsb2cSPQoIcmVhZERhdGUYBiABKAsyHy5pcGVyb24u'
        'djEuQ2hhdHMuUmVhZERhdGVSZXN1bHRIAFIIcmVhZERhdGUSPQoIY2FuV3JpdGUYByABKAsyHy'
        '5pcGVyb24udjEuQ2hhdHMuQ2FuV3JpdGVSZXN1bHRIAFIIY2FuV3JpdGUSQAoJc2F2ZURyYWZ0'
        'GAggASgLMiAuaXBlcm9uLnYxLkNoYXRzLlNhdmVEcmFmdFJlc3VsdEgAUglzYXZlRHJhZnQSQw'
        'oKZ2V0Rm9sZGVycxgJIAEoCzIhLmlwZXJvbi52MS5DaGF0cy5HZXRGb2xkZXJzUmVzdWx0SABS'
        'CmdldEZvbGRlcnMSQwoKc2F2ZUZvbGRlchgKIAEoCzIhLmlwZXJvbi52MS5DaGF0cy5TYXZlRm'
        '9sZGVyUmVzdWx0SABSCnNhdmVGb2xkZXISSQoMZGVsZXRlRm9sZGVyGAsgASgLMiMuaXBlcm9u'
        'LnYxLkNoYXRzLkRlbGV0ZUZvbGRlclJlc3VsdEgAUgxkZWxldGVGb2xkZXISTwoOcmVvcmRlck'
        'ZvbGRlcnMYDCABKAsyJS5pcGVyb24udjEuQ2hhdHMuUmVvcmRlckZvbGRlcnNSZXN1bHRIAFIO'
        'cmVvcmRlckZvbGRlcnMSUgoPcmVzb2x2ZVVzZXJuYW1lGA0gASgLMiYuaXBlcm9uLnYxLkNoYX'
        'RzLlJlc29sdmVVc2VybmFtZVJlc3VsdEgAUg9yZXNvbHZlVXNlcm5hbWUSNwoGc2V0VFRMGA4g'
        'ASgLMh0uaXBlcm9uLnYxLkNoYXRzLlNldFRUTFJlc3VsdEgAUgZzZXRUVEwSTAoNc2V0Tm9Gb3'
        'J3YXJkcxgPIAEoCzIkLmlwZXJvbi52MS5DaGF0cy5TZXROb0ZvcndhcmRzUmVzdWx0SABSDXNl'
        'dE5vRm9yd2FyZHMSRgoLc2VhcmNoVXNlcnMYECABKAsyIi5pcGVyb24udjEuQ2hhdHMuU2Vhcm'
        'NoVXNlcnNSZXN1bHRIAFILc2VhcmNoVXNlcnMSRgoLY3JlYXRlR3JvdXAYESABKAsyIi5pcGVy'
        'b24udjEuQ2hhdHMuQ3JlYXRlR3JvdXBSZXN1bHRIAFILY3JlYXRlR3JvdXASPQoIZWRpdENoYX'
        'QYEiABKAsyHy5pcGVyb24udjEuQ2hhdHMuRWRpdENoYXRSZXN1bHRIAFIIZWRpdENoYXQSQwoK'
        'YWRkTWVtYmVycxgTIAEoCzIhLmlwZXJvbi52MS5DaGF0cy5BZGRNZW1iZXJzUmVzdWx0SABSCm'
        'FkZE1lbWJlcnMSQAoJbGVhdmVDaGF0GBQgASgLMiAuaXBlcm9uLnYxLkNoYXRzLkxlYXZlQ2hh'
        'dFJlc3VsdEgAUglsZWF2ZUNoYXQSQwoKZGVsZXRlQ2hhdBgVIAEoCzIhLmlwZXJvbi52MS5DaG'
        'F0cy5EZWxldGVDaGF0UmVzdWx0SABSCmRlbGV0ZUNoYXQSOgoHbWVtYmVycxgWIAEoCzIeLmlw'
        'ZXJvbi52MS5DaGF0cy5NZW1iZXJzUmVzdWx0SABSB21lbWJlcnMSTAoNZ2V0Q2hhdHNTdGF0ZR'
        'gXIAEoCzIkLmlwZXJvbi52MS5DaGF0cy5HZXRDaGF0c1N0YXRlUmVzdWx0SABSDWdldENoYXRz'
        'U3RhdGUSWAoRZ2V0Q2hhdERpZmZlcmVuY2UYGCABKAsyKC5pcGVyb24udjEuQ2hhdHMuR2V0Q2'
        'hhdERpZmZlcmVuY2VSZXN1bHRIAFIRZ2V0Q2hhdERpZmZlcmVuY2USTAoNc2V0TWVtYmVyUm9s'
        'ZRgZIAEoCzIkLmlwZXJvbi52MS5DaGF0cy5TZXRNZW1iZXJSb2xlUmVzdWx0SABSDXNldE1lbW'
        'JlclJvbGUSSQoMcmVtb3ZlTWVtYmVyGBogASgLMiMuaXBlcm9uLnYxLkNoYXRzLlJlbW92ZU1l'
        'bWJlclJlc3VsdEgAUgxyZW1vdmVNZW1iZXISNwoGYmFubmVkGBsgASgLMh0uaXBlcm9uLnYxLk'
        'NoYXRzLkJhbm5lZFJlc3VsdEgAUgZiYW5uZWQSNAoFdW5iYW4YHCABKAsyHC5pcGVyb24udjEu'
        'Q2hhdHMuVW5iYW5SZXN1bHRIAFIFdW5iYW4SPQoIc2V0QWRtaW4YHSABKAsyHy5pcGVyb24udj'
        'EuQ2hhdHMuU2V0QWRtaW5SZXN1bHRIAFIIc2V0QWRtaW4SRgoLcmVtb3ZlQWRtaW4YHiABKAsy'
        'Ii5pcGVyb24udjEuQ2hhdHMuUmVtb3ZlQWRtaW5SZXN1bHRIAFILcmVtb3ZlQWRtaW4SWAoRdH'
        'JhbnNmZXJPd25lcnNoaXAYHyABKAsyKC5pcGVyb24udjEuQ2hhdHMuVHJhbnNmZXJPd25lcnNo'
        'aXBSZXN1bHRIAFIRdHJhbnNmZXJPd25lcnNoaXASTAoNY2hlY2tVc2VybmFtZRggIAEoCzIkLm'
        'lwZXJvbi52MS5DaGF0cy5DaGVja1VzZXJuYW1lUmVzdWx0SABSDWNoZWNrVXNlcm5hbWUSRgoL'
        'cmVzb2x2ZUxpbmsYISABKAsyIi5pcGVyb24udjEuQ2hhdHMuUmVzb2x2ZUxpbmtSZXN1bHRIAF'
        'ILcmVzb2x2ZUxpbmsSPQoIam9pbkNoYXQYIiABKAsyHy5pcGVyb24udjEuQ2hhdHMuSm9pbkNo'
        'YXRSZXN1bHRIAFIIam9pbkNoYXQSRgoLaW52aXRlTGlua3MYIyABKAsyIi5pcGVyb24udjEuQ2'
        'hhdHMuSW52aXRlTGlua3NSZXN1bHRIAFILaW52aXRlTGlua3MSVQoQY3JlYXRlSW52aXRlTGlu'
        'axgkIAEoCzInLmlwZXJvbi52MS5DaGF0cy5DcmVhdGVJbnZpdGVMaW5rUmVzdWx0SABSEGNyZW'
        'F0ZUludml0ZUxpbmsSTwoOZWRpdEludml0ZUxpbmsYJSABKAsyJS5pcGVyb24udjEuQ2hhdHMu'
        'RWRpdEludml0ZUxpbmtSZXN1bHRIAFIOZWRpdEludml0ZUxpbmsSVQoQcmV2b2tlSW52aXRlTG'
        'luaxgmIAEoCzInLmlwZXJvbi52MS5DaGF0cy5SZXZva2VJbnZpdGVMaW5rUmVzdWx0SABSEHJl'
        'dm9rZUludml0ZUxpbmsSbQoYZGVsZXRlUmV2b2tlZEludml0ZUxpbmtzGCcgASgLMi8uaXBlcm'
        '9uLnYxLkNoYXRzLkRlbGV0ZVJldm9rZWRJbnZpdGVMaW5rc1Jlc3VsdEgAUhhkZWxldGVSZXZv'
        'a2VkSW52aXRlTGlua3MSSQoMam9pblJlcXVlc3RzGCggASgLMiMuaXBlcm9uLnYxLkNoYXRzLk'
        'pvaW5SZXF1ZXN0c1Jlc3VsdEgAUgxqb2luUmVxdWVzdHMSWAoRYW5zd2VySm9pblJlcXVlc3QY'
        'KSABKAsyKC5pcGVyb24udjEuQ2hhdHMuQW5zd2VySm9pblJlcXVlc3RSZXN1bHRIAFIRYW5zd2'
        'VySm9pblJlcXVlc3QSRgoLc2VhcmNoQ2hhdHMYKiABKAsyIi5pcGVyb24udjEuQ2hhdHMuU2Vh'
        'cmNoQ2hhdHNSZXN1bHRIAFILc2VhcmNoQ2hhdHNCCgoIcmVzcG9uc2U=');

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
    Messages_ReadParticipants$json,
    Messages_ReadParticipant$json,
    Messages_ReadParticipantsResult$json,
    Messages_UnreadMentions$json,
    Messages_UnreadMentionsResult$json,
    Messages_ReadMentions$json,
    Messages_ReadMentionsResult$json,
    Messages_VotePoll$json,
    Messages_VotePollResult$json,
    Messages_ClosePoll$json,
    Messages_ClosePollResult$json,
    Messages_PollVoters$json,
    Messages_PollVoter$json,
    Messages_PollVotersResult$json,
    Messages_ReactionsList$json,
    Messages_ReactionsListResult$json,
    Messages_Search$json,
    Messages_SearchResult$json,
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
    {'1': 'aroundID', '3': 4, '4': 1, '5': 3, '10': 'aroundID'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_HistoryResult$json = {
  '1': 'HistoryResult',
  '2': [
    {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ChatMessage', '10': 'messages'},
    {'1': 'hasMore', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
    {'1': 'hasNewer', '3': 3, '4': 1, '5': 8, '10': 'hasNewer'},
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
    {'1': 'slowModeUntil', '3': 4, '4': 1, '5': 3, '10': 'slowModeUntil'},
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
const Messages_ReadParticipants$json = {
  '1': 'ReadParticipants',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ReadParticipant$json = {
  '1': 'ReadParticipant',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'date', '3': 2, '4': 1, '5': 3, '10': 'date'},
    {'1': 'reaction', '3': 3, '4': 1, '5': 9, '10': 'reaction'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ReadParticipantsResult$json = {
  '1': 'ReadParticipantsResult',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.Messages.ReadParticipantsResult.Status', '10': 'status'},
    {'1': 'readers', '3': 2, '4': 3, '5': 11, '6': '.iperon.v1.Messages.ReadParticipant', '10': 'readers'},
  ],
  '4': [Messages_ReadParticipantsResult_Status$json],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ReadParticipantsResult_Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'READ', '2': 0},
    {'1': 'NOT_READ', '2': 1},
    {'1': 'UNAVAILABLE', '2': 2},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_UnreadMentions$json = {
  '1': 'UnreadMentions',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_UnreadMentionsResult$json = {
  '1': 'UnreadMentionsResult',
  '2': [
    {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.ChatMessage', '10': 'messages'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ReadMentions$json = {
  '1': 'ReadMentions',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageIDs', '3': 2, '4': 3, '5': 3, '10': 'messageIDs'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ReadMentionsResult$json = {
  '1': 'ReadMentionsResult',
  '2': [
    {'1': 'updates', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_VotePoll$json = {
  '1': 'VotePoll',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
    {'1': 'options', '3': 3, '4': 3, '5': 5, '10': 'options'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_VotePollResult$json = {
  '1': 'VotePollResult',
  '2': [
    {'1': 'results', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.PollResults', '10': 'results'},
    {'1': 'updates', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ClosePoll$json = {
  '1': 'ClosePoll',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ClosePollResult$json = {
  '1': 'ClosePollResult',
  '2': [
    {'1': 'results', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.PollResults', '10': 'results'},
    {'1': 'updates', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.Updates', '10': 'updates'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_PollVoters$json = {
  '1': 'PollVoters',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
    {'1': 'option', '3': 3, '4': 1, '5': 5, '10': 'option'},
    {'1': 'offset', '3': 4, '4': 1, '5': 12, '10': 'offset'},
    {'1': 'limit', '3': 5, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_PollVoter$json = {
  '1': 'PollVoter',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 12, '10': 'userID'},
    {'1': 'options', '3': 2, '4': 3, '5': 5, '10': 'options'},
    {'1': 'date', '3': 3, '4': 1, '5': 3, '10': 'date'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_PollVotersResult$json = {
  '1': 'PollVotersResult',
  '2': [
    {'1': 'voters', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.Messages.PollVoter', '10': 'voters'},
    {'1': 'nextOffset', '3': 2, '4': 1, '5': 12, '10': 'nextOffset'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ReactionsList$json = {
  '1': 'ReactionsList',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'messageID', '3': 2, '4': 1, '5': 3, '10': 'messageID'},
    {'1': 'emoji', '3': 3, '4': 1, '5': 9, '10': 'emoji'},
    {'1': 'offset', '3': 4, '4': 1, '5': 12, '10': 'offset'},
    {'1': 'limit', '3': 5, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_ReactionsListResult$json = {
  '1': 'ReactionsListResult',
  '2': [
    {'1': 'reactions', '3': 1, '4': 3, '5': 11, '6': '.iperon.v1.MessageReaction', '10': 'reactions'},
    {'1': 'nextOffset', '3': 2, '4': 1, '5': 12, '10': 'nextOffset'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_Search$json = {
  '1': 'Search',
  '2': [
    {'1': 'chatID', '3': 1, '4': 1, '5': 12, '10': 'chatID'},
    {'1': 'query', '3': 2, '4': 1, '5': 9, '10': 'query'},
    {'1': 'offsetID', '3': 3, '4': 1, '5': 3, '10': 'offsetID'},
    {'1': 'limit', '3': 4, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_SearchResult$json = {
  '1': 'SearchResult',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.Messages.SearchResult.Status', '10': 'status'},
    {'1': 'messages', '3': 2, '4': 3, '5': 11, '6': '.iperon.v1.ChatMessage', '10': 'messages'},
    {'1': 'nextOffsetID', '3': 3, '4': 1, '5': 3, '10': 'nextOffsetID'},
  ],
  '4': [Messages_SearchResult_Status$json],
};

@$core.Deprecated('Use messagesDescriptor instead')
const Messages_SearchResult_Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'OK', '2': 0},
    {'1': 'QUERY_TOO_SHORT', '2': 1},
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
    {'1': 'readParticipants', '3': 17, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ReadParticipants', '9': 0, '10': 'readParticipants'},
    {'1': 'unreadMentions', '3': 18, '4': 1, '5': 11, '6': '.iperon.v1.Messages.UnreadMentions', '9': 0, '10': 'unreadMentions'},
    {'1': 'readMentions', '3': 19, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ReadMentions', '9': 0, '10': 'readMentions'},
    {'1': 'votePoll', '3': 20, '4': 1, '5': 11, '6': '.iperon.v1.Messages.VotePoll', '9': 0, '10': 'votePoll'},
    {'1': 'closePoll', '3': 21, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ClosePoll', '9': 0, '10': 'closePoll'},
    {'1': 'pollVoters', '3': 22, '4': 1, '5': 11, '6': '.iperon.v1.Messages.PollVoters', '9': 0, '10': 'pollVoters'},
    {'1': 'reactionsList', '3': 23, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ReactionsList', '9': 0, '10': 'reactionsList'},
    {'1': 'search', '3': 24, '4': 1, '5': 11, '6': '.iperon.v1.Messages.Search', '9': 0, '10': 'search'},
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
    {
      '1': 'readParticipants',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.Messages.ReadParticipantsResult',
      '9': 0,
      '10': 'readParticipants'
    },
    {'1': 'unreadMentions', '3': 18, '4': 1, '5': 11, '6': '.iperon.v1.Messages.UnreadMentionsResult', '9': 0, '10': 'unreadMentions'},
    {'1': 'readMentions', '3': 19, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ReadMentionsResult', '9': 0, '10': 'readMentions'},
    {'1': 'votePoll', '3': 20, '4': 1, '5': 11, '6': '.iperon.v1.Messages.VotePollResult', '9': 0, '10': 'votePoll'},
    {'1': 'closePoll', '3': 21, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ClosePollResult', '9': 0, '10': 'closePoll'},
    {'1': 'pollVoters', '3': 22, '4': 1, '5': 11, '6': '.iperon.v1.Messages.PollVotersResult', '9': 0, '10': 'pollVoters'},
    {'1': 'reactionsList', '3': 23, '4': 1, '5': 11, '6': '.iperon.v1.Messages.ReactionsListResult', '9': 0, '10': 'reactionsList'},
    {'1': 'search', '3': 24, '4': 1, '5': 11, '6': '.iperon.v1.Messages.SearchResult', '9': 0, '10': 'search'},
  ],
  '8': [
    {'1': 'response'},
  ],
};

/// Descriptor for `Messages`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messagesDescriptor =
    $convert.base64Decode('CghNZXNzYWdlcxpvCgdIaXN0b3J5EhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhoKCG9mZnNldE'
        'lEGAIgASgDUghvZmZzZXRJRBIUCgVsaW1pdBgDIAEoBVIFbGltaXQSGgoIYXJvdW5kSUQYBCAB'
        'KANSCGFyb3VuZElEGnkKDUhpc3RvcnlSZXN1bHQSMgoIbWVzc2FnZXMYASADKAsyFi5pcGVyb2'
        '4udjEuQ2hhdE1lc3NhZ2VSCG1lc3NhZ2VzEhgKB2hhc01vcmUYAiABKAhSB2hhc01vcmUSGgoI'
        'aGFzTmV3ZXIYAyABKAhSCGhhc05ld2VyGo4CCgRTZW5kEhYKBmNoYXRJRBgBIAEoDFIGY2hhdE'
        'lEEh4KCnBlZXJVc2VySUQYAiABKAxSCnBlZXJVc2VySUQSGgoIcmFuZG9tSUQYAyABKANSCHJh'
        'bmRvbUlEEjMKB2NvbnRlbnQYBCABKAsyGS5pcGVyb24udjEuTWVzc2FnZUNvbnRlbnRSB2Nvbn'
        'RlbnQSFgoGc2lsZW50GAUgASgIUgZzaWxlbnQSQQoLZm9yd2FyZEZyb20YBiABKAsyHy5pcGVy'
        'b24udjEuTWVzc2FnZXMuRm9yd2FyZEZyb21SC2ZvcndhcmRGcm9tEiIKDHNjaGVkdWxlRGF0ZR'
        'gHIAEoA1IMc2NoZWR1bGVEYXRlGkMKC0ZvcndhcmRGcm9tEhYKBmNoYXRJRBgBIAEoDFIGY2hh'
        'dElEEhwKCW1lc3NhZ2VJRBgCIAEoA1IJbWVzc2FnZUlEGs0BCgpTZW5kUmVzdWx0EjAKB21lc3'
        'NhZ2UYASABKAsyFi5pcGVyb24udjEuQ2hhdE1lc3NhZ2VSB21lc3NhZ2USLAoHdXBkYXRlcxgC'
        'IAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzEjkKCXNjaGVkdWxlZBgDIAEoCzIbLm'
        'lwZXJvbi52MS5TY2hlZHVsZWRNZXNzYWdlUglzY2hlZHVsZWQSJAoNc2xvd01vZGVVbnRpbBgE'
        'IAEoA1INc2xvd01vZGVVbnRpbBojCglTY2hlZHVsZWQSFgoGY2hhdElEGAEgASgMUgZjaGF0SU'
        'QaSgoPU2NoZWR1bGVkUmVzdWx0EjcKCG1lc3NhZ2VzGAEgAygLMhsuaXBlcm9uLnYxLlNjaGVk'
        'dWxlZE1lc3NhZ2VSCG1lc3NhZ2VzGk4KEFNlbmRTY2hlZHVsZWROb3cSFgoGY2hhdElEGAEgAS'
        'gMUgZjaGF0SUQSIgoMc2NoZWR1bGVkSURzGAIgAygDUgxzY2hlZHVsZWRJRHMaRgoWU2VuZFNj'
        'aGVkdWxlZE5vd1Jlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3'
        'VwZGF0ZXMaWgoKUmVzY2hlZHVsZRIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIgCgtzY2hlZHVs'
        'ZWRJRBgCIAEoA1ILc2NoZWR1bGVkSUQSEgoEZGF0ZRgDIAEoA1IEZGF0ZRpAChBSZXNjaGVkdW'
        'xlUmVzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxpN'
        'Cg9EZWxldGVTY2hlZHVsZWQSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSIgoMc2NoZWR1bGVkSU'
        'RzGAIgAygDUgxzY2hlZHVsZWRJRHMaRQoVRGVsZXRlU2NoZWR1bGVkUmVzdWx0EiwKB3VwZGF0'
        'ZXMYASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxqGAQoERWRpdBIWCgZjaGF0SU'
        'QYASABKAxSBmNoYXRJRBIcCgltZXNzYWdlSUQYAiABKANSCW1lc3NhZ2VJRBISCgR0ZXh0GAMg'
        'ASgJUgR0ZXh0EjQKCGVudGl0aWVzGAQgAygLMhguaXBlcm9uLnYxLk1lc3NhZ2VFbnRpdHlSCG'
        'VudGl0aWVzGjoKCkVkaXRSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRh'
        'dGVzUgd1cGRhdGVzGmIKBkRlbGV0ZRIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIeCgptZXNzYW'
        'dlSURzGAIgAygDUgptZXNzYWdlSURzEiAKC2ZvckV2ZXJ5b25lGAMgASgIUgtmb3JFdmVyeW9u'
        'ZRo8CgxEZWxldGVSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUg'
        'd1cGRhdGVzGkYKDFJlYWRDb250ZW50cxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIeCgptZXNz'
        'YWdlSURzGAIgAygDUgptZXNzYWdlSURzGkIKElJlYWRDb250ZW50c1Jlc3VsdBIsCgd1cGRhdG'
        'VzGAEgASgLMhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMadQoDUGluEhYKBmNoYXRJRBgB'
        'IAEoDFIGY2hhdElEEhwKCW1lc3NhZ2VJRBgCIAEoA1IJbWVzc2FnZUlEEhYKBnBpbm5lZBgDIA'
        'EoCFIGcGlubmVkEiAKC2ZvckV2ZXJ5b25lGAQgASgIUgtmb3JFdmVyeW9uZRo5CglQaW5SZXN1'
        'bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzGkQKCFVucG'
        'luQWxsEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEiAKC2ZvckV2ZXJ5b25lGAIgASgIUgtmb3JF'
        'dmVyeW9uZRo+Cg5VbnBpbkFsbFJlc3VsdBIsCgd1cGRhdGVzGAEgASgLMhIuaXBlcm9uLnYxLl'
        'VwZGF0ZXNSB3VwZGF0ZXMaIAoGUGlubmVkEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEGmAKDFBp'
        'bm5lZFJlc3VsdBIyCghtZXNzYWdlcxgBIAMoCzIWLmlwZXJvbi52MS5DaGF0TWVzc2FnZVIIbW'
        'Vzc2FnZXMSHAoJc2hhcmVkSURzGAIgAygDUglzaGFyZWRJRHMaXAoMU2V0UmVhY3Rpb25zEhYK'
        'BmNoYXRJRBgBIAEoDFIGY2hhdElEEhwKCW1lc3NhZ2VJRBgCIAEoA1IJbWVzc2FnZUlEEhYKBm'
        'Vtb2ppcxgDIAMoCVIGZW1vamlzGkIKElNldFJlYWN0aW9uc1Jlc3VsdBIsCgd1cGRhdGVzGAEg'
        'ASgLMhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMaRwoNUmVhZFJlYWN0aW9ucxIWCgZjaG'
        'F0SUQYASABKAxSBmNoYXRJRBIeCgptZXNzYWdlSURzGAIgAygDUgptZXNzYWdlSURzGkMKE1Jl'
        'YWRSZWFjdGlvbnNSZXN1bHQSLAoHdXBkYXRlcxgBIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUg'
        'd1cGRhdGVzGj8KD1VucmVhZFJlYWN0aW9ucxIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIUCgVs'
        'aW1pdBgCIAEoBVIFbGltaXQaSwoVVW5yZWFkUmVhY3Rpb25zUmVzdWx0EjIKCG1lc3NhZ2VzGA'
        'EgAygLMhYuaXBlcm9uLnYxLkNoYXRNZXNzYWdlUghtZXNzYWdlcxo9CgNHZXQSFgoGY2hhdElE'
        'GAEgASgMUgZjaGF0SUQSHgoKbWVzc2FnZUlEcxgCIAMoA1IKbWVzc2FnZUlEcxo/CglHZXRSZX'
        'N1bHQSMgoIbWVzc2FnZXMYASADKAsyFi5pcGVyb24udjEuQ2hhdE1lc3NhZ2VSCG1lc3NhZ2Vz'
        'GkgKEFJlYWRQYXJ0aWNpcGFudHMSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSHAoJbWVzc2FnZU'
        'lEGAIgASgDUgltZXNzYWdlSUQaWQoPUmVhZFBhcnRpY2lwYW50EhYKBnVzZXJJRBgBIAEoDFIG'
        'dXNlcklEEhIKBGRhdGUYAiABKANSBGRhdGUSGgoIcmVhY3Rpb24YAyABKAlSCHJlYWN0aW9uGt'
        'UBChZSZWFkUGFydGljaXBhbnRzUmVzdWx0EkkKBnN0YXR1cxgBIAEoDjIxLmlwZXJvbi52MS5N'
        'ZXNzYWdlcy5SZWFkUGFydGljaXBhbnRzUmVzdWx0LlN0YXR1c1IGc3RhdHVzEj0KB3JlYWRlcn'
        'MYAiADKAsyIy5pcGVyb24udjEuTWVzc2FnZXMuUmVhZFBhcnRpY2lwYW50UgdyZWFkZXJzIjEK'
        'BlN0YXR1cxIICgRSRUFEEAASDAoITk9UX1JFQUQQARIPCgtVTkFWQUlMQUJMRRACGj4KDlVucm'
        'VhZE1lbnRpb25zEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElEEhQKBWxpbWl0GAIgASgFUgVsaW1p'
        'dBpKChRVbnJlYWRNZW50aW9uc1Jlc3VsdBIyCghtZXNzYWdlcxgBIAMoCzIWLmlwZXJvbi52MS'
        '5DaGF0TWVzc2FnZVIIbWVzc2FnZXMaRgoMUmVhZE1lbnRpb25zEhYKBmNoYXRJRBgBIAEoDFIG'
        'Y2hhdElEEh4KCm1lc3NhZ2VJRHMYAiADKANSCm1lc3NhZ2VJRHMaQgoSUmVhZE1lbnRpb25zUm'
        'VzdWx0EiwKB3VwZGF0ZXMYASABKAsyEi5pcGVyb24udjEuVXBkYXRlc1IHdXBkYXRlcxpaCghW'
        'b3RlUG9sbBIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIcCgltZXNzYWdlSUQYAiABKANSCW1lc3'
        'NhZ2VJRBIYCgdvcHRpb25zGAMgAygFUgdvcHRpb25zGnAKDlZvdGVQb2xsUmVzdWx0EjAKB3Jl'
        'c3VsdHMYASABKAsyFi5pcGVyb24udjEuUG9sbFJlc3VsdHNSB3Jlc3VsdHMSLAoHdXBkYXRlcx'
        'gCIAEoCzISLmlwZXJvbi52MS5VcGRhdGVzUgd1cGRhdGVzGkEKCUNsb3NlUG9sbBIWCgZjaGF0'
        'SUQYASABKAxSBmNoYXRJRBIcCgltZXNzYWdlSUQYAiABKANSCW1lc3NhZ2VJRBpxCg9DbG9zZV'
        'BvbGxSZXN1bHQSMAoHcmVzdWx0cxgBIAEoCzIWLmlwZXJvbi52MS5Qb2xsUmVzdWx0c1IHcmVz'
        'dWx0cxIsCgd1cGRhdGVzGAIgASgLMhIuaXBlcm9uLnYxLlVwZGF0ZXNSB3VwZGF0ZXMaiAEKCl'
        'BvbGxWb3RlcnMSFgoGY2hhdElEGAEgASgMUgZjaGF0SUQSHAoJbWVzc2FnZUlEGAIgASgDUglt'
        'ZXNzYWdlSUQSFgoGb3B0aW9uGAMgASgFUgZvcHRpb24SFgoGb2Zmc2V0GAQgASgMUgZvZmZzZX'
        'QSFAoFbGltaXQYBSABKAVSBWxpbWl0GlEKCVBvbGxWb3RlchIWCgZ1c2VySUQYASABKAxSBnVz'
        'ZXJJRBIYCgdvcHRpb25zGAIgAygFUgdvcHRpb25zEhIKBGRhdGUYAyABKANSBGRhdGUaaQoQUG'
        '9sbFZvdGVyc1Jlc3VsdBI1CgZ2b3RlcnMYASADKAsyHS5pcGVyb24udjEuTWVzc2FnZXMuUG9s'
        'bFZvdGVyUgZ2b3RlcnMSHgoKbmV4dE9mZnNldBgCIAEoDFIKbmV4dE9mZnNldBqJAQoNUmVhY3'
        'Rpb25zTGlzdBIWCgZjaGF0SUQYASABKAxSBmNoYXRJRBIcCgltZXNzYWdlSUQYAiABKANSCW1l'
        'c3NhZ2VJRBIUCgVlbW9qaRgDIAEoCVIFZW1vamkSFgoGb2Zmc2V0GAQgASgMUgZvZmZzZXQSFA'
        'oFbGltaXQYBSABKAVSBWxpbWl0Gm8KE1JlYWN0aW9uc0xpc3RSZXN1bHQSOAoJcmVhY3Rpb25z'
        'GAEgAygLMhouaXBlcm9uLnYxLk1lc3NhZ2VSZWFjdGlvblIJcmVhY3Rpb25zEh4KCm5leHRPZm'
        'ZzZXQYAiABKAxSCm5leHRPZmZzZXQaaAoGU2VhcmNoEhYKBmNoYXRJRBgBIAEoDFIGY2hhdElE'
        'EhQKBXF1ZXJ5GAIgASgJUgVxdWVyeRIaCghvZmZzZXRJRBgDIAEoA1IIb2Zmc2V0SUQSFAoFbG'
        'ltaXQYBCABKAVSBWxpbWl0Gs4BCgxTZWFyY2hSZXN1bHQSPwoGc3RhdHVzGAEgASgOMicuaXBl'
        'cm9uLnYxLk1lc3NhZ2VzLlNlYXJjaFJlc3VsdC5TdGF0dXNSBnN0YXR1cxIyCghtZXNzYWdlcx'
        'gCIAMoCzIWLmlwZXJvbi52MS5DaGF0TWVzc2FnZVIIbWVzc2FnZXMSIgoMbmV4dE9mZnNldElE'
        'GAMgASgDUgxuZXh0T2Zmc2V0SUQiJQoGU3RhdHVzEgYKAk9LEAASEwoPUVVFUllfVE9PX1NIT1'
        'JUEAEaqQwKB1JlcXVlc3QSNwoHaGlzdG9yeRgBIAEoCzIbLmlwZXJvbi52MS5NZXNzYWdlcy5I'
        'aXN0b3J5SABSB2hpc3RvcnkSLgoEc2VuZBgCIAEoCzIYLmlwZXJvbi52MS5NZXNzYWdlcy5TZW'
        '5kSABSBHNlbmQSLgoEZWRpdBgDIAEoCzIYLmlwZXJvbi52MS5NZXNzYWdlcy5FZGl0SABSBGVk'
        'aXQSNAoGZGVsZXRlGAQgASgLMhouaXBlcm9uLnYxLk1lc3NhZ2VzLkRlbGV0ZUgAUgZkZWxldG'
        'USRgoMcmVhZENvbnRlbnRzGAUgASgLMiAuaXBlcm9uLnYxLk1lc3NhZ2VzLlJlYWRDb250ZW50'
        'c0gAUgxyZWFkQ29udGVudHMSKwoDcGluGAYgASgLMhcuaXBlcm9uLnYxLk1lc3NhZ2VzLlBpbk'
        'gAUgNwaW4SOgoIdW5waW5BbGwYByABKAsyHC5pcGVyb24udjEuTWVzc2FnZXMuVW5waW5BbGxI'
        'AFIIdW5waW5BbGwSNAoGcGlubmVkGAggASgLMhouaXBlcm9uLnYxLk1lc3NhZ2VzLlBpbm5lZE'
        'gAUgZwaW5uZWQSRgoMc2V0UmVhY3Rpb25zGAkgASgLMiAuaXBlcm9uLnYxLk1lc3NhZ2VzLlNl'
        'dFJlYWN0aW9uc0gAUgxzZXRSZWFjdGlvbnMSSQoNcmVhZFJlYWN0aW9ucxgKIAEoCzIhLmlwZX'
        'Jvbi52MS5NZXNzYWdlcy5SZWFkUmVhY3Rpb25zSABSDXJlYWRSZWFjdGlvbnMSTwoPdW5yZWFk'
        'UmVhY3Rpb25zGAsgASgLMiMuaXBlcm9uLnYxLk1lc3NhZ2VzLlVucmVhZFJlYWN0aW9uc0gAUg'
        '91bnJlYWRSZWFjdGlvbnMSPQoJc2NoZWR1bGVkGAwgASgLMh0uaXBlcm9uLnYxLk1lc3NhZ2Vz'
        'LlNjaGVkdWxlZEgAUglzY2hlZHVsZWQSUgoQc2VuZFNjaGVkdWxlZE5vdxgNIAEoCzIkLmlwZX'
        'Jvbi52MS5NZXNzYWdlcy5TZW5kU2NoZWR1bGVkTm93SABSEHNlbmRTY2hlZHVsZWROb3cSQAoK'
        'cmVzY2hlZHVsZRgOIAEoCzIeLmlwZXJvbi52MS5NZXNzYWdlcy5SZXNjaGVkdWxlSABSCnJlc2'
        'NoZWR1bGUSTwoPZGVsZXRlU2NoZWR1bGVkGA8gASgLMiMuaXBlcm9uLnYxLk1lc3NhZ2VzLkRl'
        'bGV0ZVNjaGVkdWxlZEgAUg9kZWxldGVTY2hlZHVsZWQSKwoDZ2V0GBAgASgLMhcuaXBlcm9uLn'
        'YxLk1lc3NhZ2VzLkdldEgAUgNnZXQSUgoQcmVhZFBhcnRpY2lwYW50cxgRIAEoCzIkLmlwZXJv'
        'bi52MS5NZXNzYWdlcy5SZWFkUGFydGljaXBhbnRzSABSEHJlYWRQYXJ0aWNpcGFudHMSTAoOdW'
        '5yZWFkTWVudGlvbnMYEiABKAsyIi5pcGVyb24udjEuTWVzc2FnZXMuVW5yZWFkTWVudGlvbnNI'
        'AFIOdW5yZWFkTWVudGlvbnMSRgoMcmVhZE1lbnRpb25zGBMgASgLMiAuaXBlcm9uLnYxLk1lc3'
        'NhZ2VzLlJlYWRNZW50aW9uc0gAUgxyZWFkTWVudGlvbnMSOgoIdm90ZVBvbGwYFCABKAsyHC5p'
        'cGVyb24udjEuTWVzc2FnZXMuVm90ZVBvbGxIAFIIdm90ZVBvbGwSPQoJY2xvc2VQb2xsGBUgAS'
        'gLMh0uaXBlcm9uLnYxLk1lc3NhZ2VzLkNsb3NlUG9sbEgAUgljbG9zZVBvbGwSQAoKcG9sbFZv'
        'dGVycxgWIAEoCzIeLmlwZXJvbi52MS5NZXNzYWdlcy5Qb2xsVm90ZXJzSABSCnBvbGxWb3Rlcn'
        'MSSQoNcmVhY3Rpb25zTGlzdBgXIAEoCzIhLmlwZXJvbi52MS5NZXNzYWdlcy5SZWFjdGlvbnNM'
        'aXN0SABSDXJlYWN0aW9uc0xpc3QSNAoGc2VhcmNoGBggASgLMhouaXBlcm9uLnYxLk1lc3NhZ2'
        'VzLlNlYXJjaEgAUgZzZWFyY2hCCQoHcmVxdWVzdBq7DQoIUmVzcG9uc2USPQoHaGlzdG9yeRgB'
        'IAEoCzIhLmlwZXJvbi52MS5NZXNzYWdlcy5IaXN0b3J5UmVzdWx0SABSB2hpc3RvcnkSNAoEc2'
        'VuZBgCIAEoCzIeLmlwZXJvbi52MS5NZXNzYWdlcy5TZW5kUmVzdWx0SABSBHNlbmQSNAoEZWRp'
        'dBgDIAEoCzIeLmlwZXJvbi52MS5NZXNzYWdlcy5FZGl0UmVzdWx0SABSBGVkaXQSOgoGZGVsZX'
        'RlGAQgASgLMiAuaXBlcm9uLnYxLk1lc3NhZ2VzLkRlbGV0ZVJlc3VsdEgAUgZkZWxldGUSTAoM'
        'cmVhZENvbnRlbnRzGAUgASgLMiYuaXBlcm9uLnYxLk1lc3NhZ2VzLlJlYWRDb250ZW50c1Jlc3'
        'VsdEgAUgxyZWFkQ29udGVudHMSMQoDcGluGAYgASgLMh0uaXBlcm9uLnYxLk1lc3NhZ2VzLlBp'
        'blJlc3VsdEgAUgNwaW4SQAoIdW5waW5BbGwYByABKAsyIi5pcGVyb24udjEuTWVzc2FnZXMuVW'
        '5waW5BbGxSZXN1bHRIAFIIdW5waW5BbGwSOgoGcGlubmVkGAggASgLMiAuaXBlcm9uLnYxLk1l'
        'c3NhZ2VzLlBpbm5lZFJlc3VsdEgAUgZwaW5uZWQSTAoMc2V0UmVhY3Rpb25zGAkgASgLMiYuaX'
        'Blcm9uLnYxLk1lc3NhZ2VzLlNldFJlYWN0aW9uc1Jlc3VsdEgAUgxzZXRSZWFjdGlvbnMSTwoN'
        'cmVhZFJlYWN0aW9ucxgKIAEoCzInLmlwZXJvbi52MS5NZXNzYWdlcy5SZWFkUmVhY3Rpb25zUm'
        'VzdWx0SABSDXJlYWRSZWFjdGlvbnMSVQoPdW5yZWFkUmVhY3Rpb25zGAsgASgLMikuaXBlcm9u'
        'LnYxLk1lc3NhZ2VzLlVucmVhZFJlYWN0aW9uc1Jlc3VsdEgAUg91bnJlYWRSZWFjdGlvbnMSQw'
        'oJc2NoZWR1bGVkGAwgASgLMiMuaXBlcm9uLnYxLk1lc3NhZ2VzLlNjaGVkdWxlZFJlc3VsdEgA'
        'UglzY2hlZHVsZWQSWAoQc2VuZFNjaGVkdWxlZE5vdxgNIAEoCzIqLmlwZXJvbi52MS5NZXNzYW'
        'dlcy5TZW5kU2NoZWR1bGVkTm93UmVzdWx0SABSEHNlbmRTY2hlZHVsZWROb3cSRgoKcmVzY2hl'
        'ZHVsZRgOIAEoCzIkLmlwZXJvbi52MS5NZXNzYWdlcy5SZXNjaGVkdWxlUmVzdWx0SABSCnJlc2'
        'NoZWR1bGUSVQoPZGVsZXRlU2NoZWR1bGVkGA8gASgLMikuaXBlcm9uLnYxLk1lc3NhZ2VzLkRl'
        'bGV0ZVNjaGVkdWxlZFJlc3VsdEgAUg9kZWxldGVTY2hlZHVsZWQSMQoDZ2V0GBAgASgLMh0uaX'
        'Blcm9uLnYxLk1lc3NhZ2VzLkdldFJlc3VsdEgAUgNnZXQSWAoQcmVhZFBhcnRpY2lwYW50cxgR'
        'IAEoCzIqLmlwZXJvbi52MS5NZXNzYWdlcy5SZWFkUGFydGljaXBhbnRzUmVzdWx0SABSEHJlYW'
        'RQYXJ0aWNpcGFudHMSUgoOdW5yZWFkTWVudGlvbnMYEiABKAsyKC5pcGVyb24udjEuTWVzc2Fn'
        'ZXMuVW5yZWFkTWVudGlvbnNSZXN1bHRIAFIOdW5yZWFkTWVudGlvbnMSTAoMcmVhZE1lbnRpb2'
        '5zGBMgASgLMiYuaXBlcm9uLnYxLk1lc3NhZ2VzLlJlYWRNZW50aW9uc1Jlc3VsdEgAUgxyZWFk'
        'TWVudGlvbnMSQAoIdm90ZVBvbGwYFCABKAsyIi5pcGVyb24udjEuTWVzc2FnZXMuVm90ZVBvbG'
        'xSZXN1bHRIAFIIdm90ZVBvbGwSQwoJY2xvc2VQb2xsGBUgASgLMiMuaXBlcm9uLnYxLk1lc3Nh'
        'Z2VzLkNsb3NlUG9sbFJlc3VsdEgAUgljbG9zZVBvbGwSRgoKcG9sbFZvdGVycxgWIAEoCzIkLm'
        'lwZXJvbi52MS5NZXNzYWdlcy5Qb2xsVm90ZXJzUmVzdWx0SABSCnBvbGxWb3RlcnMSTwoNcmVh'
        'Y3Rpb25zTGlzdBgXIAEoCzInLmlwZXJvbi52MS5NZXNzYWdlcy5SZWFjdGlvbnNMaXN0UmVzdW'
        'x0SABSDXJlYWN0aW9uc0xpc3QSOgoGc2VhcmNoGBggASgLMiAuaXBlcm9uLnYxLk1lc3NhZ2Vz'
        'LlNlYXJjaFJlc3VsdEgAUgZzZWFyY2hCCgoIcmVzcG9uc2U=');

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
