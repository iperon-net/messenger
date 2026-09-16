// This is a generated file - do not edit.
//
// Generated from protos/contacts_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Источник записи: OPRF — обнаружено в системной книге; MANUAL — добавлено
/// вручную по номеру (клиент прогоняет OPRF по одному номеру).
class ContactsUpsert_Source extends $pb.ProtobufEnum {
  static const ContactsUpsert_Source OPRF = ContactsUpsert_Source._(0, _omitEnumNames ? '' : 'OPRF');
  static const ContactsUpsert_Source MANUAL = ContactsUpsert_Source._(1, _omitEnumNames ? '' : 'MANUAL');

  static const $core.List<ContactsUpsert_Source> values = <ContactsUpsert_Source>[
    OPRF,
    MANUAL,
  ];

  static final $core.List<ContactsUpsert_Source?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static ContactsUpsert_Source? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ContactsUpsert_Source._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
