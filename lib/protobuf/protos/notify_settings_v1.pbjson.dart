// This is a generated file - do not edit.
//
// Generated from protos/notify_settings_v1.proto.

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

@$core.Deprecated('Use notifySettingsDescriptor instead')
const NotifySettings$json = {
  '1': 'NotifySettings',
  '3': [
    NotifySettings_ScopeSettings$json,
    NotifySettings_ReactionsSettings$json,
    NotifySettings_Request$json,
    NotifySettings_Response$json
  ],
  '4': [NotifySettings_Scope$json, NotifySettings_ReactionsFrom$json],
};

@$core.Deprecated('Use notifySettingsDescriptor instead')
const NotifySettings_ScopeSettings$json = {
  '1': 'ScopeSettings',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'show_previews', '3': 2, '4': 1, '5': 8, '10': 'showPreviews'},
    {'1': 'sound', '3': 3, '4': 1, '5': 8, '10': 'sound'},
  ],
};

@$core.Deprecated('Use notifySettingsDescriptor instead')
const NotifySettings_ReactionsSettings$json = {
  '1': 'ReactionsSettings',
  '2': [
    {'1': 'private_chats', '3': 1, '4': 1, '5': 8, '10': 'privateChats'},
    {'1': 'groups', '3': 2, '4': 1, '5': 8, '10': 'groups'},
    {'1': 'from', '3': 3, '4': 1, '5': 14, '6': '.iperon.v1.NotifySettings.ReactionsFrom', '10': 'from'},
  ],
};

@$core.Deprecated('Use notifySettingsDescriptor instead')
const NotifySettings_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use notifySettingsDescriptor instead')
const NotifySettings_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'private_chats', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.NotifySettings.ScopeSettings', '10': 'privateChats'},
    {'1': 'groups', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.NotifySettings.ScopeSettings', '10': 'groups'},
    {'1': 'channels', '3': 3, '4': 1, '5': 11, '6': '.iperon.v1.NotifySettings.ScopeSettings', '10': 'channels'},
    {'1': 'contact_joined', '3': 4, '4': 1, '5': 8, '10': 'contactJoined'},
    {'1': 'missed_calls', '3': 5, '4': 1, '5': 8, '10': 'missedCalls'},
    {'1': 'reactions', '3': 6, '4': 1, '5': 11, '6': '.iperon.v1.NotifySettings.ReactionsSettings', '10': 'reactions'},
  ],
};

@$core.Deprecated('Use notifySettingsDescriptor instead')
const NotifySettings_Scope$json = {
  '1': 'Scope',
  '2': [
    {'1': 'PRIVATE', '2': 0},
    {'1': 'GROUPS', '2': 1},
    {'1': 'CHANNELS', '2': 2},
  ],
};

@$core.Deprecated('Use notifySettingsDescriptor instead')
const NotifySettings_ReactionsFrom$json = {
  '1': 'ReactionsFrom',
  '2': [
    {'1': 'REACTIONS_FROM_ALL', '2': 0},
    {'1': 'REACTIONS_FROM_CONTACTS', '2': 1},
  ],
};

/// Descriptor for `NotifySettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notifySettingsDescriptor =
    $convert.base64Decode('Cg5Ob3RpZnlTZXR0aW5ncxpkCg1TY29wZVNldHRpbmdzEhgKB2VuYWJsZWQYASABKAhSB2VuYW'
        'JsZWQSIwoNc2hvd19wcmV2aWV3cxgCIAEoCFIMc2hvd1ByZXZpZXdzEhQKBXNvdW5kGAMgASgI'
        'UgVzb3VuZBqNAQoRUmVhY3Rpb25zU2V0dGluZ3MSIwoNcHJpdmF0ZV9jaGF0cxgBIAEoCFIMcH'
        'JpdmF0ZUNoYXRzEhYKBmdyb3VwcxgCIAEoCFIGZ3JvdXBzEjsKBGZyb20YAyABKA4yJy5pcGVy'
        'b24udjEuTm90aWZ5U2V0dGluZ3MuUmVhY3Rpb25zRnJvbVIEZnJvbRoJCgdSZXF1ZXN0GvMCCg'
        'hSZXNwb25zZRJMCg1wcml2YXRlX2NoYXRzGAEgASgLMicuaXBlcm9uLnYxLk5vdGlmeVNldHRp'
        'bmdzLlNjb3BlU2V0dGluZ3NSDHByaXZhdGVDaGF0cxI/CgZncm91cHMYAiABKAsyJy5pcGVyb2'
        '4udjEuTm90aWZ5U2V0dGluZ3MuU2NvcGVTZXR0aW5nc1IGZ3JvdXBzEkMKCGNoYW5uZWxzGAMg'
        'ASgLMicuaXBlcm9uLnYxLk5vdGlmeVNldHRpbmdzLlNjb3BlU2V0dGluZ3NSCGNoYW5uZWxzEi'
        'UKDmNvbnRhY3Rfam9pbmVkGAQgASgIUg1jb250YWN0Sm9pbmVkEiEKDG1pc3NlZF9jYWxscxgF'
        'IAEoCFILbWlzc2VkQ2FsbHMSSQoJcmVhY3Rpb25zGAYgASgLMisuaXBlcm9uLnYxLk5vdGlmeV'
        'NldHRpbmdzLlJlYWN0aW9uc1NldHRpbmdzUglyZWFjdGlvbnMiLgoFU2NvcGUSCwoHUFJJVkFU'
        'RRAAEgoKBkdST1VQUxABEgwKCENIQU5ORUxTEAIiRAoNUmVhY3Rpb25zRnJvbRIWChJSRUFDVE'
        'lPTlNfRlJPTV9BTEwQABIbChdSRUFDVElPTlNfRlJPTV9DT05UQUNUUxAB');

@$core.Deprecated('Use notifySettingsUpdateDescriptor instead')
const NotifySettingsUpdate$json = {
  '1': 'NotifySettingsUpdate',
  '3': [NotifySettingsUpdate_ScopeChange$json, NotifySettingsUpdate_Request$json, NotifySettingsUpdate_Response$json],
};

@$core.Deprecated('Use notifySettingsUpdateDescriptor instead')
const NotifySettingsUpdate_ScopeChange$json = {
  '1': 'ScopeChange',
  '2': [
    {'1': 'scope', '3': 1, '4': 1, '5': 14, '6': '.iperon.v1.NotifySettings.Scope', '10': 'scope'},
    {'1': 'settings', '3': 2, '4': 1, '5': 11, '6': '.iperon.v1.NotifySettings.ScopeSettings', '10': 'settings'},
  ],
};

@$core.Deprecated('Use notifySettingsUpdateDescriptor instead')
const NotifySettingsUpdate_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'scope', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.NotifySettingsUpdate.ScopeChange', '9': 0, '10': 'scope'},
    {'1': 'contact_joined', '3': 2, '4': 1, '5': 8, '9': 0, '10': 'contactJoined'},
    {'1': 'missed_calls', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'missedCalls'},
    {'1': 'reactions', '3': 4, '4': 1, '5': 11, '6': '.iperon.v1.NotifySettings.ReactionsSettings', '9': 0, '10': 'reactions'},
  ],
  '8': [
    {'1': 'change'},
  ],
};

@$core.Deprecated('Use notifySettingsUpdateDescriptor instead')
const NotifySettingsUpdate_Response$json = {
  '1': 'Response',
};

/// Descriptor for `NotifySettingsUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notifySettingsUpdateDescriptor =
    $convert.base64Decode('ChROb3RpZnlTZXR0aW5nc1VwZGF0ZRqJAQoLU2NvcGVDaGFuZ2USNQoFc2NvcGUYASABKA4yHy'
        '5pcGVyb24udjEuTm90aWZ5U2V0dGluZ3MuU2NvcGVSBXNjb3BlEkMKCHNldHRpbmdzGAIgASgL'
        'MicuaXBlcm9uLnYxLk5vdGlmeVNldHRpbmdzLlNjb3BlU2V0dGluZ3NSCHNldHRpbmdzGvMBCg'
        'dSZXF1ZXN0EkMKBXNjb3BlGAEgASgLMisuaXBlcm9uLnYxLk5vdGlmeVNldHRpbmdzVXBkYXRl'
        'LlNjb3BlQ2hhbmdlSABSBXNjb3BlEicKDmNvbnRhY3Rfam9pbmVkGAIgASgISABSDWNvbnRhY3'
        'RKb2luZWQSIwoMbWlzc2VkX2NhbGxzGAMgASgISABSC21pc3NlZENhbGxzEksKCXJlYWN0aW9u'
        'cxgEIAEoCzIrLmlwZXJvbi52MS5Ob3RpZnlTZXR0aW5ncy5SZWFjdGlvbnNTZXR0aW5nc0gAUg'
        'lyZWFjdGlvbnNCCAoGY2hhbmdlGgoKCFJlc3BvbnNl');
