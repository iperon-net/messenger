// This is a generated file - do not edit.
//
// Generated from protos/privacy_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Аудитория канала: EVERYBODY — кто угодно; CONTACTS — только те, у кого
/// отправитель есть в контактах (ребро owner→sender); NOBODY — никто (действие
/// запрещено всем). favorites/messages/group_invites — следующие этапы.
class PrivacySettings_Audience extends $pb.ProtobufEnum {
  static const PrivacySettings_Audience EVERYBODY = PrivacySettings_Audience._(0, _omitEnumNames ? '' : 'EVERYBODY');
  static const PrivacySettings_Audience CONTACTS = PrivacySettings_Audience._(1, _omitEnumNames ? '' : 'CONTACTS');
  static const PrivacySettings_Audience NOBODY = PrivacySettings_Audience._(2, _omitEnumNames ? '' : 'NOBODY');

  static const $core.List<PrivacySettings_Audience> values = <PrivacySettings_Audience>[
    EVERYBODY,
    CONTACTS,
    NOBODY,
  ];

  static final $core.List<PrivacySettings_Audience?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PrivacySettings_Audience? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PrivacySettings_Audience._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
