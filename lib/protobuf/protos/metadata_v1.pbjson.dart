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

@$core.Deprecated('Use metadataInfoRequestDescriptor instead')
const MetadataInfoRequest$json = {
  '1': 'MetadataInfoRequest',
};

/// Descriptor for `MetadataInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataInfoRequestDescriptor =
    $convert.base64Decode('ChNNZXRhZGF0YUluZm9SZXF1ZXN0');

@$core.Deprecated('Use metadataInfoResponseDescriptor instead')
const MetadataInfoResponse$json = {
  '1': 'MetadataInfoResponse',
  '2': [
    {
      '1': 'ecdh',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.MetadataInfoResponse.ECDH',
      '10': 'ecdh'
    },
    {
      '1': 'gitCommit',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.MetadataInfoResponse.GitCommit',
      '10': 'gitCommit'
    },
    {'1': 'buildDate', '3': 3, '4': 1, '5': 9, '10': 'buildDate'},
    {'1': 'version', '3': 4, '4': 1, '5': 9, '10': 'version'},
  ],
  '3': [MetadataInfoResponse_GitCommit$json, MetadataInfoResponse_ECDH$json],
};

@$core.Deprecated('Use metadataInfoResponseDescriptor instead')
const MetadataInfoResponse_GitCommit$json = {
  '1': 'GitCommit',
  '2': [
    {'1': 'full', '3': 1, '4': 1, '5': 9, '10': 'full'},
    {'1': 'short', '3': 2, '4': 1, '5': 9, '10': 'short'},
  ],
};

@$core.Deprecated('Use metadataInfoResponseDescriptor instead')
const MetadataInfoResponse_ECDH$json = {
  '1': 'ECDH',
  '2': [
    {'1': 'publicKey', '3': 1, '4': 1, '5': 12, '10': 'publicKey'},
    {'1': 'fingerprint', '3': 2, '4': 1, '5': 9, '10': 'fingerprint'},
  ],
};

/// Descriptor for `MetadataInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataInfoResponseDescriptor = $convert.base64Decode(
    'ChRNZXRhZGF0YUluZm9SZXNwb25zZRI4CgRlY2RoGAEgASgLMiQuaXBlcm9uLnYxLk1ldGFkYX'
    'RhSW5mb1Jlc3BvbnNlLkVDREhSBGVjZGgSRwoJZ2l0Q29tbWl0GAIgASgLMikuaXBlcm9uLnYx'
    'Lk1ldGFkYXRhSW5mb1Jlc3BvbnNlLkdpdENvbW1pdFIJZ2l0Q29tbWl0EhwKCWJ1aWxkRGF0ZR'
    'gDIAEoCVIJYnVpbGREYXRlEhgKB3ZlcnNpb24YBCABKAlSB3ZlcnNpb24aNQoJR2l0Q29tbWl0'
    'EhIKBGZ1bGwYASABKAlSBGZ1bGwSFAoFc2hvcnQYAiABKAlSBXNob3J0GkYKBEVDREgSHAoJcH'
    'VibGljS2V5GAEgASgMUglwdWJsaWNLZXkSIAoLZmluZ2VycHJpbnQYAiABKAlSC2ZpbmdlcnBy'
    'aW50');

@$core.Deprecated('Use metadataGeoIPRequestDescriptor instead')
const MetadataGeoIPRequest$json = {
  '1': 'MetadataGeoIPRequest',
  '2': [
    {'1': 'ip', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'ip', '17': true},
  ],
  '8': [
    {'1': '_ip'},
  ],
};

/// Descriptor for `MetadataGeoIPRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataGeoIPRequestDescriptor =
    $convert.base64Decode(
        'ChRNZXRhZGF0YUdlb0lQUmVxdWVzdBITCgJpcBgBIAEoCUgAUgJpcIgBAUIFCgNfaXA=');

@$core.Deprecated('Use metadataGeoIPResponseDescriptor instead')
const MetadataGeoIPResponse$json = {
  '1': 'MetadataGeoIPResponse',
  '2': [
    {'1': 'timeZone', '3': 1, '4': 1, '5': 9, '10': 'timeZone'},
    {'1': 'isoCode', '3': 2, '4': 1, '5': 9, '10': 'isoCode'},
    {
      '1': 'location',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.MetadataGeoIPResponse.MetadataGeoIPLocation',
      '10': 'location'
    },
    {
      '1': 'country',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.MetadataGeoIPResponse.MetadataGeoIPCountry',
      '10': 'country'
    },
    {
      '1': 'city',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.iperon.v1.MetadataGeoIPResponse.MetadataGeoIPCity',
      '10': 'city'
    },
    {'1': 'ip', '3': 6, '4': 1, '5': 9, '10': 'ip'},
  ],
  '3': [
    MetadataGeoIPResponse_MetadataGeoIPLocation$json,
    MetadataGeoIPResponse_MetadataGeoIPCountry$json,
    MetadataGeoIPResponse_MetadataGeoIPCity$json
  ],
};

@$core.Deprecated('Use metadataGeoIPResponseDescriptor instead')
const MetadataGeoIPResponse_MetadataGeoIPLocation$json = {
  '1': 'MetadataGeoIPLocation',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 2, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 2, '10': 'longitude'},
  ],
};

@$core.Deprecated('Use metadataGeoIPResponseDescriptor instead')
const MetadataGeoIPResponse_MetadataGeoIPCountry$json = {
  '1': 'MetadataGeoIPCountry',
  '2': [
    {'1': 'russianName', '3': 1, '4': 1, '5': 9, '10': 'russianName'},
    {'1': 'englishName', '3': 2, '4': 1, '5': 9, '10': 'englishName'},
  ],
};

@$core.Deprecated('Use metadataGeoIPResponseDescriptor instead')
const MetadataGeoIPResponse_MetadataGeoIPCity$json = {
  '1': 'MetadataGeoIPCity',
  '2': [
    {'1': 'russianName', '3': 1, '4': 1, '5': 9, '10': 'russianName'},
    {'1': 'englishName', '3': 2, '4': 1, '5': 9, '10': 'englishName'},
  ],
};

/// Descriptor for `MetadataGeoIPResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataGeoIPResponseDescriptor = $convert.base64Decode(
    'ChVNZXRhZGF0YUdlb0lQUmVzcG9uc2USGgoIdGltZVpvbmUYASABKAlSCHRpbWVab25lEhgKB2'
    'lzb0NvZGUYAiABKAlSB2lzb0NvZGUSUgoIbG9jYXRpb24YAyABKAsyNi5pcGVyb24udjEuTWV0'
    'YWRhdGFHZW9JUFJlc3BvbnNlLk1ldGFkYXRhR2VvSVBMb2NhdGlvblIIbG9jYXRpb24STwoHY2'
    '91bnRyeRgEIAEoCzI1LmlwZXJvbi52MS5NZXRhZGF0YUdlb0lQUmVzcG9uc2UuTWV0YWRhdGFH'
    'ZW9JUENvdW50cnlSB2NvdW50cnkSRgoEY2l0eRgFIAEoCzIyLmlwZXJvbi52MS5NZXRhZGF0YU'
    'dlb0lQUmVzcG9uc2UuTWV0YWRhdGFHZW9JUENpdHlSBGNpdHkSDgoCaXAYBiABKAlSAmlwGlEK'
    'FU1ldGFkYXRhR2VvSVBMb2NhdGlvbhIaCghsYXRpdHVkZRgBIAEoAlIIbGF0aXR1ZGUSHAoJbG'
    '9uZ2l0dWRlGAIgASgCUglsb25naXR1ZGUaWgoUTWV0YWRhdGFHZW9JUENvdW50cnkSIAoLcnVz'
    'c2lhbk5hbWUYASABKAlSC3J1c3NpYW5OYW1lEiAKC2VuZ2xpc2hOYW1lGAIgASgJUgtlbmdsaX'
    'NoTmFtZRpXChFNZXRhZGF0YUdlb0lQQ2l0eRIgCgtydXNzaWFuTmFtZRgBIAEoCVILcnVzc2lh'
    'bk5hbWUSIAoLZW5nbGlzaE5hbWUYAiABKAlSC2VuZ2xpc2hOYW1l');
