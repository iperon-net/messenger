// This is a generated file - do not edit.
//
// Generated from protos/client_config_v1.proto.

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

@$core.Deprecated('Use clientConfigDescriptor instead')
const ClientConfig$json = {
  '1': 'ClientConfig',
  '3': [ClientConfig_Request$json, ClientConfig_Response$json],
};

@$core.Deprecated('Use clientConfigDescriptor instead')
const ClientConfig_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use clientConfigDescriptor instead')
const ClientConfig_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'secretChatsEnabled', '3': 1, '4': 1, '5': 8, '10': 'secretChatsEnabled'},
    {'1': 'secretChatsPremiumOnly', '3': 2, '4': 1, '5': 8, '10': 'secretChatsPremiumOnly'},
    {'1': 'groupCallsEnabled', '3': 3, '4': 1, '5': 8, '10': 'groupCallsEnabled'},
    {'1': 'callConnectMaxAttempts', '3': 4, '4': 1, '5': 5, '10': 'callConnectMaxAttempts'},
    {'1': 'callPeerConnectionTimeoutSeconds', '3': 5, '4': 1, '5': 5, '10': 'callPeerConnectionTimeoutSeconds'},
    {'1': 'callRingTimeoutSeconds', '3': 6, '4': 1, '5': 5, '10': 'callRingTimeoutSeconds'},
    {'1': 'animatedEmojiUrl', '3': 7, '4': 1, '5': 9, '10': 'animatedEmojiUrl'},
    {'1': 'yandexClientId', '3': 8, '4': 1, '5': 9, '10': 'yandexClientId'},
    {'1': 'minimalVersion', '3': 9, '4': 1, '5': 9, '10': 'minimalVersion'},
  ],
};

/// Descriptor for `ClientConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientConfigDescriptor =
    $convert.base64Decode('CgxDbGllbnRDb25maWcaCQoHUmVxdWVzdBrYAwoIUmVzcG9uc2USLgoSc2VjcmV0Q2hhdHNFbm'
        'FibGVkGAEgASgIUhJzZWNyZXRDaGF0c0VuYWJsZWQSNgoWc2VjcmV0Q2hhdHNQcmVtaXVtT25s'
        'eRgCIAEoCFIWc2VjcmV0Q2hhdHNQcmVtaXVtT25seRIsChFncm91cENhbGxzRW5hYmxlZBgDIA'
        'EoCFIRZ3JvdXBDYWxsc0VuYWJsZWQSNgoWY2FsbENvbm5lY3RNYXhBdHRlbXB0cxgEIAEoBVIW'
        'Y2FsbENvbm5lY3RNYXhBdHRlbXB0cxJKCiBjYWxsUGVlckNvbm5lY3Rpb25UaW1lb3V0U2Vjb2'
        '5kcxgFIAEoBVIgY2FsbFBlZXJDb25uZWN0aW9uVGltZW91dFNlY29uZHMSNgoWY2FsbFJpbmdU'
        'aW1lb3V0U2Vjb25kcxgGIAEoBVIWY2FsbFJpbmdUaW1lb3V0U2Vjb25kcxIqChBhbmltYXRlZE'
        'Vtb2ppVXJsGAcgASgJUhBhbmltYXRlZEVtb2ppVXJsEiYKDnlhbmRleENsaWVudElkGAggASgJ'
        'Ug55YW5kZXhDbGllbnRJZBImCg5taW5pbWFsVmVyc2lvbhgJIAEoCVIObWluaW1hbFZlcnNpb2'
        '4=');
