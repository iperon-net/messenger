// This is a generated file - do not edit.
//
// Generated from protos/secret_chats_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SecretChat_State extends $pb.ProtobufEnum {
  /// A отправил запрос, ждём, какое устройство B примет.
  static const SecretChat_State REQUESTED = SecretChat_State._(0, _omitEnumNames ? '' : 'REQUESTED');

  /// B принял, ждём раскрытия коммитмента от A.
  static const SecretChat_State ACCEPTED = SecretChat_State._(1, _omitEnumNames ? '' : 'ACCEPTED');

  /// Рукопожатие завершено — можно переписываться.
  static const SecretChat_State READY = SecretChat_State._(2, _omitEnumNames ? '' : 'READY');

  /// Закрыт (одной из сторон, сервером — сессия завершена/истёк запрос).
  static const SecretChat_State DISCARDED = SecretChat_State._(3, _omitEnumNames ? '' : 'DISCARDED');

  static const $core.List<SecretChat_State> values = <SecretChat_State>[
    REQUESTED,
    ACCEPTED,
    READY,
    DISCARDED,
  ];

  static final $core.List<SecretChat_State?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SecretChat_State? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SecretChat_State._(super.value, super.name);
}

class SecretUpdate_Discarded_Reason extends $pb.ProtobufEnum {
  /// Собеседник закрыл (или отклонил запрос, или отозвал свой).
  static const SecretUpdate_Discarded_Reason BY_PEER = SecretUpdate_Discarded_Reason._(0, _omitEnumNames ? '' : 'BY_PEER');

  /// Запрос принят другим устройством этого же пользователя.
  static const SecretUpdate_Discarded_Reason ACCEPTED_ELSEWHERE =
      SecretUpdate_Discarded_Reason._(1, _omitEnumNames ? '' : 'ACCEPTED_ELSEWHERE');

  /// Сессия собеседника завершена (выход, удаление устройства).
  static const SecretUpdate_Discarded_Reason SESSION_ENDED = SecretUpdate_Discarded_Reason._(2, _omitEnumNames ? '' : 'SESSION_ENDED');

  /// Запрос не приняли за отведённое время.
  static const SecretUpdate_Discarded_Reason EXPIRED = SecretUpdate_Discarded_Reason._(3, _omitEnumNames ? '' : 'EXPIRED');

  static const $core.List<SecretUpdate_Discarded_Reason> values = <SecretUpdate_Discarded_Reason>[
    BY_PEER,
    ACCEPTED_ELSEWHERE,
    SESSION_ENDED,
    EXPIRED,
  ];

  static final $core.List<SecretUpdate_Discarded_Reason?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SecretUpdate_Discarded_Reason? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SecretUpdate_Discarded_Reason._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
