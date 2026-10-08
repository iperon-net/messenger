// This is a generated file - do not edit.
//
// Generated from protos/notify_settings_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Тип чатов, к которому относится настройка.
class NotifySettings_Scope extends $pb.ProtobufEnum {
  static const NotifySettings_Scope PRIVATE = NotifySettings_Scope._(0, _omitEnumNames ? '' : 'PRIVATE');
  static const NotifySettings_Scope GROUPS = NotifySettings_Scope._(1, _omitEnumNames ? '' : 'GROUPS');
  static const NotifySettings_Scope CHANNELS = NotifySettings_Scope._(2, _omitEnumNames ? '' : 'CHANNELS');

  static const $core.List<NotifySettings_Scope> values = <NotifySettings_Scope>[
    PRIVATE,
    GROUPS,
    CHANNELS,
  ];

  static final $core.List<NotifySettings_Scope?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static NotifySettings_Scope? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NotifySettings_Scope._(super.value, super.name);
}

/// От кого уведомлять о реакциях на мои сообщения.
class NotifySettings_ReactionsFrom extends $pb.ProtobufEnum {
  static const NotifySettings_ReactionsFrom REACTIONS_FROM_ALL =
      NotifySettings_ReactionsFrom._(0, _omitEnumNames ? '' : 'REACTIONS_FROM_ALL');
  static const NotifySettings_ReactionsFrom REACTIONS_FROM_CONTACTS =
      NotifySettings_ReactionsFrom._(1, _omitEnumNames ? '' : 'REACTIONS_FROM_CONTACTS');

  static const $core.List<NotifySettings_ReactionsFrom> values = <NotifySettings_ReactionsFrom>[
    REACTIONS_FROM_ALL,
    REACTIONS_FROM_CONTACTS,
  ];

  static final $core.List<NotifySettings_ReactionsFrom?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static NotifySettings_ReactionsFrom? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NotifySettings_ReactionsFrom._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
