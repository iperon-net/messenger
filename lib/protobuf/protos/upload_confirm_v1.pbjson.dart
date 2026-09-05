// This is a generated file - do not edit.
//
// Generated from protos/upload_confirm_v1.proto.

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

@$core.Deprecated('Use uploadConfirmDescriptor instead')
const UploadConfirm$json = {
  '1': 'UploadConfirm',
  '3': [UploadConfirm_Request$json, UploadConfirm_Response$json],
};

@$core.Deprecated('Use uploadConfirmDescriptor instead')
const UploadConfirm_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'uploadId', '3': 1, '4': 1, '5': 9, '10': 'uploadId'},
    {'1': 'encryptionKey', '3': 2, '4': 1, '5': 12, '10': 'encryptionKey'},
    {'1': 'hkdfSalt', '3': 3, '4': 1, '5': 12, '10': 'hkdfSalt'},
    {'1': 'fileName', '3': 4, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'contentType', '3': 5, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'folder', '3': 6, '4': 1, '5': 9, '10': 'folder'},
  ],
};

@$core.Deprecated('Use uploadConfirmDescriptor instead')
const UploadConfirm_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'cdn', '3': 1, '4': 1, '5': 11, '6': '.iperon.v1.CDN', '10': 'cdn'},
  ],
};

/// Descriptor for `UploadConfirm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadConfirmDescriptor =
    $convert.base64Decode('Cg1VcGxvYWRDb25maXJtGr0BCgdSZXF1ZXN0EhoKCHVwbG9hZElkGAEgASgJUgh1cGxvYWRJZB'
        'IkCg1lbmNyeXB0aW9uS2V5GAIgASgMUg1lbmNyeXB0aW9uS2V5EhoKCGhrZGZTYWx0GAMgASgM'
        'Ughoa2RmU2FsdBIaCghmaWxlTmFtZRgEIAEoCVIIZmlsZU5hbWUSIAoLY29udGVudFR5cGUYBS'
        'ABKAlSC2NvbnRlbnRUeXBlEhYKBmZvbGRlchgGIAEoCVIGZm9sZGVyGiwKCFJlc3BvbnNlEiAK'
        'A2NkbhgBIAEoCzIOLmlwZXJvbi52MS5DRE5SA2Nkbg==');
