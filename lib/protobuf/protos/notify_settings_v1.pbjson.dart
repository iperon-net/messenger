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
  '3': [NotifySettings_ScopeSettings$json, NotifySettings_Request$json, NotifySettings_Response$json],
  '4': [NotifySettings_Scope$json],
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

/// Descriptor for `NotifySettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notifySettingsDescriptor =
    $convert.base64Decode('Cg5Ob3RpZnlTZXR0aW5ncxpkCg1TY29wZVNldHRpbmdzEhgKB2VuYWJsZWQYASABKAhSB2VuYW'
        'JsZWQSIwoNc2hvd19wcmV2aWV3cxgCIAEoCFIMc2hvd1ByZXZpZXdzEhQKBXNvdW5kGAMgASgI'
        'UgVzb3VuZBoJCgdSZXF1ZXN0GqgCCghSZXNwb25zZRJMCg1wcml2YXRlX2NoYXRzGAEgASgLMi'
        'cuaXBlcm9uLnYxLk5vdGlmeVNldHRpbmdzLlNjb3BlU2V0dGluZ3NSDHByaXZhdGVDaGF0cxI/'
        'CgZncm91cHMYAiABKAsyJy5pcGVyb24udjEuTm90aWZ5U2V0dGluZ3MuU2NvcGVTZXR0aW5nc1'
        'IGZ3JvdXBzEkMKCGNoYW5uZWxzGAMgASgLMicuaXBlcm9uLnYxLk5vdGlmeVNldHRpbmdzLlNj'
        'b3BlU2V0dGluZ3NSCGNoYW5uZWxzEiUKDmNvbnRhY3Rfam9pbmVkGAQgASgIUg1jb250YWN0Sm'
        '9pbmVkEiEKDG1pc3NlZF9jYWxscxgFIAEoCFILbWlzc2VkQ2FsbHMiLgoFU2NvcGUSCwoHUFJJ'
        'VkFURRAAEgoKBkdST1VQUxABEgwKCENIQU5ORUxTEAI=');

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
        'MicuaXBlcm9uLnYxLk5vdGlmeVNldHRpbmdzLlNjb3BlU2V0dGluZ3NSCHNldHRpbmdzGqYBCg'
        'dSZXF1ZXN0EkMKBXNjb3BlGAEgASgLMisuaXBlcm9uLnYxLk5vdGlmeVNldHRpbmdzVXBkYXRl'
        'LlNjb3BlQ2hhbmdlSABSBXNjb3BlEicKDmNvbnRhY3Rfam9pbmVkGAIgASgISABSDWNvbnRhY3'
        'RKb2luZWQSIwoMbWlzc2VkX2NhbGxzGAMgASgISABSC21pc3NlZENhbGxzQggKBmNoYW5nZRoK'
        'CghSZXNwb25zZQ==');
