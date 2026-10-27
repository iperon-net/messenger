// This is a generated file - do not edit.
//
// Generated from protos/upload_confirm_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Назначение файла — пишется в запись cdn (отчёты по месту, сборщик). Клиент
/// указывает его для папки «chats» (вложение или превью); аватары и файлы
/// секретных чатов сервер определяет сам по папке / opaque.
class CdnKind extends $pb.ProtobufEnum {
  static const CdnKind CDN_KIND_UNSPECIFIED = CdnKind._(0, _omitEnumNames ? '' : 'CDN_KIND_UNSPECIFIED');
  static const CdnKind CDN_KIND_MEDIA = CdnKind._(1, _omitEnumNames ? '' : 'CDN_KIND_MEDIA');
  static const CdnKind CDN_KIND_THUMB = CdnKind._(2, _omitEnumNames ? '' : 'CDN_KIND_THUMB');
  static const CdnKind CDN_KIND_AVATAR = CdnKind._(3, _omitEnumNames ? '' : 'CDN_KIND_AVATAR');

  static const $core.List<CdnKind> values = <CdnKind>[
    CDN_KIND_UNSPECIFIED,
    CDN_KIND_MEDIA,
    CDN_KIND_THUMB,
    CDN_KIND_AVATAR,
  ];

  static final $core.List<CdnKind?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CdnKind? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CdnKind._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
