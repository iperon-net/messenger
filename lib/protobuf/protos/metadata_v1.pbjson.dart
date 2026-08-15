// This is a generated file - do not edit.
//
// Generated from protos/metadata_v1.proto.

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

@$core.Deprecated('Use metadataInfoDescriptor instead')
const MetadataInfo$json = {
  '1': 'MetadataInfo',
  '3': [
    MetadataInfo_GitCommit$json,
    MetadataInfo_EdDSA$json,
    MetadataInfo_VOPRF$json,
    MetadataInfo_Request$json,
    MetadataInfo_Response$json
  ],
};

@$core.Deprecated('Use metadataInfoDescriptor instead')
const MetadataInfo_GitCommit$json = {
  '1': 'GitCommit',
  '2': [
    {'1': 'full', '3': 1, '4': 1, '5': 9, '10': 'full'},
    {'1': 'short', '3': 2, '4': 1, '5': 9, '10': 'short'},
  ],
};

@$core.Deprecated('Use metadataInfoDescriptor instead')
const MetadataInfo_EdDSA$json = {
  '1': 'EdDSA',
  '2': [
    {'1': 'publicKey', '3': 1, '4': 1, '5': 12, '10': 'publicKey'},
    {'1': 'fingerprint', '3': 2, '4': 1, '5': 9, '10': 'fingerprint'},
  ],
};

@$core.Deprecated('Use metadataInfoDescriptor instead')
const MetadataInfo_VOPRF$json = {
  '1': 'VOPRF',
  '2': [
    {'1': 'publicKey', '3': 1, '4': 1, '5': 12, '10': 'publicKey'},
    {'1': 'fingerprint', '3': 2, '4': 1, '5': 9, '10': 'fingerprint'},
  ],
};

@$core.Deprecated('Use metadataInfoDescriptor instead')
const MetadataInfo_Request$json = {
  '1': 'Request',
};

@$core.Deprecated('Use metadataInfoDescriptor instead')
const MetadataInfo_Response$json = {
  '1': 'Response',
  '2': [
    {
      '1': 'eddsa',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.MetadataInfo.EdDSA',
      '10': 'eddsa'
    },
    {
      '1': 'voprf',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.MetadataInfo.VOPRF',
      '10': 'voprf'
    },
    {
      '1': 'gitCommit',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.MetadataInfo.GitCommit',
      '10': 'gitCommit'
    },
    {'1': 'buildDate', '3': 5, '4': 1, '5': 9, '10': 'buildDate'},
    {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `MetadataInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataInfoDescriptor = $convert.base64Decode(
    'CgxNZXRhZGF0YUluZm8aNQoJR2l0Q29tbWl0EhIKBGZ1bGwYASABKAlSBGZ1bGwSFAoFc2hvcn'
    'QYAiABKAlSBXNob3J0GkcKBUVkRFNBEhwKCXB1YmxpY0tleRgBIAEoDFIJcHVibGljS2V5EiAK'
    'C2ZpbmdlcnByaW50GAIgASgJUgtmaW5nZXJwcmludBpHCgVWT1BSRhIcCglwdWJsaWNLZXkYAS'
    'ABKAxSCXB1YmxpY0tleRIgCgtmaW5nZXJwcmludBgCIAEoCVILZmluZ2VycHJpbnQaCQoHUmVx'
    'dWVzdBrtAQoIUmVzcG9uc2USMwoFZWRkc2EYAiABKAsyHS5pcGVyb24udjEuTWV0YWRhdGFJbm'
    'ZvLkVkRFNBUgVlZGRzYRIzCgV2b3ByZhgDIAEoCzIdLmlwZXJvbi52MS5NZXRhZGF0YUluZm8u'
    'Vk9QUkZSBXZvcHJmEj8KCWdpdENvbW1pdBgEIAEoCzIhLmlwZXJvbi52MS5NZXRhZGF0YUluZm'
    '8uR2l0Q29tbWl0UglnaXRDb21taXQSHAoJYnVpbGREYXRlGAUgASgJUglidWlsZERhdGUSGAoH'
    'dmVyc2lvbhgGIAEoCVIHdmVyc2lvbg==');

@$core.Deprecated('Use metadataGeoIPDescriptor instead')
const MetadataGeoIP$json = {
  '1': 'MetadataGeoIP',
  '3': [
    MetadataGeoIP_Location$json,
    MetadataGeoIP_Country$json,
    MetadataGeoIP_City$json,
    MetadataGeoIP_Request$json,
    MetadataGeoIP_Response$json
  ],
};

@$core.Deprecated('Use metadataGeoIPDescriptor instead')
const MetadataGeoIP_Location$json = {
  '1': 'Location',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 2, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 2, '10': 'longitude'},
  ],
};

@$core.Deprecated('Use metadataGeoIPDescriptor instead')
const MetadataGeoIP_Country$json = {
  '1': 'Country',
  '2': [
    {'1': 'russianName', '3': 1, '4': 1, '5': 9, '10': 'russianName'},
    {'1': 'englishName', '3': 2, '4': 1, '5': 9, '10': 'englishName'},
  ],
};

@$core.Deprecated('Use metadataGeoIPDescriptor instead')
const MetadataGeoIP_City$json = {
  '1': 'City',
  '2': [
    {'1': 'russianName', '3': 1, '4': 1, '5': 9, '10': 'russianName'},
    {'1': 'englishName', '3': 2, '4': 1, '5': 9, '10': 'englishName'},
  ],
};

@$core.Deprecated('Use metadataGeoIPDescriptor instead')
const MetadataGeoIP_Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'ip', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'ip', '17': true},
  ],
  '8': [
    {'1': '_ip'},
  ],
};

@$core.Deprecated('Use metadataGeoIPDescriptor instead')
const MetadataGeoIP_Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'timeZone', '3': 1, '4': 1, '5': 9, '10': 'timeZone'},
    {'1': 'isoCode', '3': 2, '4': 1, '5': 9, '10': 'isoCode'},
    {
      '1': 'location',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.MetadataGeoIP.Location',
      '10': 'location'
    },
    {
      '1': 'country',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.MetadataGeoIP.Country',
      '10': 'country'
    },
    {
      '1': 'city',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.MetadataGeoIP.City',
      '10': 'city'
    },
    {'1': 'ip', '3': 6, '4': 1, '5': 9, '10': 'ip'},
  ],
};

/// Descriptor for `MetadataGeoIP`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataGeoIPDescriptor = $convert.base64Decode(
    'Cg1NZXRhZGF0YUdlb0lQGkQKCExvY2F0aW9uEhoKCGxhdGl0dWRlGAEgASgCUghsYXRpdHVkZR'
    'IcCglsb25naXR1ZGUYAiABKAJSCWxvbmdpdHVkZRpNCgdDb3VudHJ5EiAKC3J1c3NpYW5OYW1l'
    'GAEgASgJUgtydXNzaWFuTmFtZRIgCgtlbmdsaXNoTmFtZRgCIAEoCVILZW5nbGlzaE5hbWUaSg'
    'oEQ2l0eRIgCgtydXNzaWFuTmFtZRgBIAEoCVILcnVzc2lhbk5hbWUSIAoLZW5nbGlzaE5hbWUY'
    'AiABKAlSC2VuZ2xpc2hOYW1lGiUKB1JlcXVlc3QSEwoCaXAYASABKAlIAFICaXCIAQFCBQoDX2'
    'lwGv4BCghSZXNwb25zZRIaCgh0aW1lWm9uZRgBIAEoCVIIdGltZVpvbmUSGAoHaXNvQ29kZRgC'
    'IAEoCVIHaXNvQ29kZRI9Cghsb2NhdGlvbhgDIAEoCzIhLmlwZXJvbi52MS5NZXRhZGF0YUdlb0'
    'lQLkxvY2F0aW9uUghsb2NhdGlvbhI6Cgdjb3VudHJ5GAQgASgLMiAuaXBlcm9uLnYxLk1ldGFk'
    'YXRhR2VvSVAuQ291bnRyeVIHY291bnRyeRIxCgRjaXR5GAUgASgLMh0uaXBlcm9uLnYxLk1ldG'
    'FkYXRhR2VvSVAuQ2l0eVIEY2l0eRIOCgJpcBgGIAEoCVICaXA=');
