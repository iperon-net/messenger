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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'contacts_v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'contacts_v1.pbenum.dart';

class ContactsDiscoveryEvaluate_Request extends $pb.GeneratedMessage {
  factory ContactsDiscoveryEvaluate_Request({
    $core.Iterable<$core.List<$core.int>>? blindedElements,
  }) {
    final result = create();
    if (blindedElements != null) result.blindedElements.addAll(blindedElements);
    return result;
  }

  ContactsDiscoveryEvaluate_Request._();

  factory ContactsDiscoveryEvaluate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsDiscoveryEvaluate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsDiscoveryEvaluate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'blindedElements', $pb.PbFieldType.PY, protoName: 'blindedElements')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryEvaluate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryEvaluate_Request copyWith(void Function(ContactsDiscoveryEvaluate_Request) updates) =>
      super.copyWith((message) => updates(message as ContactsDiscoveryEvaluate_Request)) as ContactsDiscoveryEvaluate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryEvaluate_Request create() => ContactsDiscoveryEvaluate_Request._();
  @$core.override
  ContactsDiscoveryEvaluate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryEvaluate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsDiscoveryEvaluate_Request>(create);
  static ContactsDiscoveryEvaluate_Request? _defaultInstance;

  /// Ослеплённые элементы ristretto255 (по одному на номер), 32 байта каждый.
  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get blindedElements => $_getList(0);
}

class ContactsDiscoveryEvaluate_Response extends $pb.GeneratedMessage {
  factory ContactsDiscoveryEvaluate_Response({
    $core.Iterable<$core.List<$core.int>>? evaluatedElements,
  }) {
    final result = create();
    if (evaluatedElements != null) result.evaluatedElements.addAll(evaluatedElements);
    return result;
  }

  ContactsDiscoveryEvaluate_Response._();

  factory ContactsDiscoveryEvaluate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsDiscoveryEvaluate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsDiscoveryEvaluate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'evaluatedElements', $pb.PbFieldType.PY, protoName: 'evaluatedElements')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryEvaluate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryEvaluate_Response copyWith(void Function(ContactsDiscoveryEvaluate_Response) updates) =>
      super.copyWith((message) => updates(message as ContactsDiscoveryEvaluate_Response)) as ContactsDiscoveryEvaluate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryEvaluate_Response create() => ContactsDiscoveryEvaluate_Response._();
  @$core.override
  ContactsDiscoveryEvaluate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryEvaluate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsDiscoveryEvaluate_Response>(create);
  static ContactsDiscoveryEvaluate_Response? _defaultInstance;

  /// Сериализованные Evaluation (элемент + DLEQ-пруф) в порядке запроса.
  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get evaluatedElements => $_getList(0);
}

/// Раунд 1: клиент шлёт ослеплённые элементы, сервер возвращает результат оценки.
class ContactsDiscoveryEvaluate extends $pb.GeneratedMessage {
  factory ContactsDiscoveryEvaluate() => create();

  ContactsDiscoveryEvaluate._();

  factory ContactsDiscoveryEvaluate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsDiscoveryEvaluate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsDiscoveryEvaluate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryEvaluate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryEvaluate copyWith(void Function(ContactsDiscoveryEvaluate) updates) =>
      super.copyWith((message) => updates(message as ContactsDiscoveryEvaluate)) as ContactsDiscoveryEvaluate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryEvaluate create() => ContactsDiscoveryEvaluate._();
  @$core.override
  ContactsDiscoveryEvaluate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryEvaluate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsDiscoveryEvaluate>(create);
  static ContactsDiscoveryEvaluate? _defaultInstance;
}

class ContactsDiscoveryMatch_Request extends $pb.GeneratedMessage {
  factory ContactsDiscoveryMatch_Request({
    $core.Iterable<$core.List<$core.int>>? oprfOutputs,
  }) {
    final result = create();
    if (oprfOutputs != null) result.oprfOutputs.addAll(oprfOutputs);
    return result;
  }

  ContactsDiscoveryMatch_Request._();

  factory ContactsDiscoveryMatch_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsDiscoveryMatch_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsDiscoveryMatch.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'oprfOutputs', $pb.PbFieldType.PY, protoName: 'oprfOutputs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryMatch_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryMatch_Request copyWith(void Function(ContactsDiscoveryMatch_Request) updates) =>
      super.copyWith((message) => updates(message as ContactsDiscoveryMatch_Request)) as ContactsDiscoveryMatch_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryMatch_Request create() => ContactsDiscoveryMatch_Request._();
  @$core.override
  ContactsDiscoveryMatch_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryMatch_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsDiscoveryMatch_Request>(create);
  static ContactsDiscoveryMatch_Request? _defaultInstance;

  /// Финализированные OPRF-выходы (SHA-512, 64 байта), по одному на номер.
  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get oprfOutputs => $_getList(0);
}

class ContactsDiscoveryMatch_Match extends $pb.GeneratedMessage {
  factory ContactsDiscoveryMatch_Match({
    $core.List<$core.int>? oprf,
    $core.List<$core.int>? userID,
  }) {
    final result = create();
    if (oprf != null) result.oprf = oprf;
    if (userID != null) result.userID = userID;
    return result;
  }

  ContactsDiscoveryMatch_Match._();

  factory ContactsDiscoveryMatch_Match.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsDiscoveryMatch_Match.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsDiscoveryMatch.Match',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'oprf', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryMatch_Match clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryMatch_Match copyWith(void Function(ContactsDiscoveryMatch_Match) updates) =>
      super.copyWith((message) => updates(message as ContactsDiscoveryMatch_Match)) as ContactsDiscoveryMatch_Match;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryMatch_Match create() => ContactsDiscoveryMatch_Match._();
  @$core.override
  ContactsDiscoveryMatch_Match createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryMatch_Match getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsDiscoveryMatch_Match>(create);
  static ContactsDiscoveryMatch_Match? _defaultInstance;

  /// OPRF-отпечаток совпавшего пользователя — клиент по нему находит локальный
  /// номер, соответствующий контакту.
  @$pb.TagNumber(1)
  $core.List<$core.int> get oprf => $_getN(0);
  @$pb.TagNumber(1)
  set oprf($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOprf() => $_has(0);
  @$pb.TagNumber(1)
  void clearOprf() => $_clearField(1);

  /// userID найденного пользователя (сырые байты ObjectID).
  @$pb.TagNumber(2)
  $core.List<$core.int> get userID => $_getN(1);
  @$pb.TagNumber(2)
  set userID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);
}

class ContactsDiscoveryMatch_Response extends $pb.GeneratedMessage {
  factory ContactsDiscoveryMatch_Response({
    $core.Iterable<ContactsDiscoveryMatch_Match>? matches,
  }) {
    final result = create();
    if (matches != null) result.matches.addAll(matches);
    return result;
  }

  ContactsDiscoveryMatch_Response._();

  factory ContactsDiscoveryMatch_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsDiscoveryMatch_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsDiscoveryMatch.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ContactsDiscoveryMatch_Match>(1, _omitFieldNames ? '' : 'matches', subBuilder: ContactsDiscoveryMatch_Match.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryMatch_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryMatch_Response copyWith(void Function(ContactsDiscoveryMatch_Response) updates) =>
      super.copyWith((message) => updates(message as ContactsDiscoveryMatch_Response)) as ContactsDiscoveryMatch_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryMatch_Response create() => ContactsDiscoveryMatch_Response._();
  @$core.override
  ContactsDiscoveryMatch_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryMatch_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsDiscoveryMatch_Response>(create);
  static ContactsDiscoveryMatch_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ContactsDiscoveryMatch_Match> get matches => $_getList(0);
}

/// Раунд 2: клиент шлёт финализированные OPRF-выходы, сервер отвечает, какие из
/// них соответствуют зарегистрированным пользователям (совпадение по user.oprf).
class ContactsDiscoveryMatch extends $pb.GeneratedMessage {
  factory ContactsDiscoveryMatch() => create();

  ContactsDiscoveryMatch._();

  factory ContactsDiscoveryMatch.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsDiscoveryMatch.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsDiscoveryMatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryMatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsDiscoveryMatch copyWith(void Function(ContactsDiscoveryMatch) updates) =>
      super.copyWith((message) => updates(message as ContactsDiscoveryMatch)) as ContactsDiscoveryMatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryMatch create() => ContactsDiscoveryMatch._();
  @$core.override
  ContactsDiscoveryMatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsDiscoveryMatch getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsDiscoveryMatch>(create);
  static ContactsDiscoveryMatch? _defaultInstance;
}

class ContactsUpsert_Item extends $pb.GeneratedMessage {
  factory ContactsUpsert_Item({
    $core.List<$core.int>? oprf,
    ContactsUpsert_Source? source,
    $core.String? firstName,
    $core.String? lastName,
    $core.String? phoneNumber,
  }) {
    final result = create();
    if (oprf != null) result.oprf = oprf;
    if (source != null) result.source = source;
    if (firstName != null) result.firstName = firstName;
    if (lastName != null) result.lastName = lastName;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    return result;
  }

  ContactsUpsert_Item._();

  factory ContactsUpsert_Item.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsUpsert_Item.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsUpsert.Item',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'oprf', $pb.PbFieldType.OY)
    ..aE<ContactsUpsert_Source>(2, _omitFieldNames ? '' : 'source', enumValues: ContactsUpsert_Source.values)
    ..aOS(3, _omitFieldNames ? '' : 'firstName', protoName: 'firstName')
    ..aOS(4, _omitFieldNames ? '' : 'lastName', protoName: 'lastName')
    ..aOS(5, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsUpsert_Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsUpsert_Item copyWith(void Function(ContactsUpsert_Item) updates) =>
      super.copyWith((message) => updates(message as ContactsUpsert_Item)) as ContactsUpsert_Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsUpsert_Item create() => ContactsUpsert_Item._();
  @$core.override
  ContactsUpsert_Item createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsUpsert_Item getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsUpsert_Item>(create);
  static ContactsUpsert_Item? _defaultInstance;

  /// Финализированный OPRF-выход номера контакта (SHA-512, 64 байта).
  @$pb.TagNumber(1)
  $core.List<$core.int> get oprf => $_getN(0);
  @$pb.TagNumber(1)
  set oprf($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOprf() => $_has(0);
  @$pb.TagNumber(1)
  void clearOprf() => $_clearField(1);

  @$pb.TagNumber(2)
  ContactsUpsert_Source get source => $_getN(1);
  @$pb.TagNumber(2)
  set source(ContactsUpsert_Source value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);

  /// Ниже — только для облачных контактов (синхронизируемых между устройствами).
  /// Непустой phoneNumber ⇒ ребро облачное: сервер шифрует эти поля at-rest
  /// (Encryptor, ключ на сервере — это НЕ E2E) и рассылает их на устройства
  /// владельца. Пусто ⇒ приватное OPRF-ребро, PII не покидает устройство.
  /// Открытый текст здесь защищён шифрованием сессии, не хранением на сервере.
  @$pb.TagNumber(3)
  $core.String get firstName => $_getSZ(2);
  @$pb.TagNumber(3)
  set firstName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFirstName() => $_has(2);
  @$pb.TagNumber(3)
  void clearFirstName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get lastName => $_getSZ(3);
  @$pb.TagNumber(4)
  set lastName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLastName() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get phoneNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set phoneNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPhoneNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearPhoneNumber() => $_clearField(5);
}

class ContactsUpsert_Request extends $pb.GeneratedMessage {
  factory ContactsUpsert_Request({
    $core.Iterable<ContactsUpsert_Item>? items,
    $core.bool? full,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (full != null) result.full = full;
    return result;
  }

  ContactsUpsert_Request._();

  factory ContactsUpsert_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsUpsert_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsUpsert.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ContactsUpsert_Item>(1, _omitFieldNames ? '' : 'items', subBuilder: ContactsUpsert_Item.create)
    ..aOB(2, _omitFieldNames ? '' : 'full')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsUpsert_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsUpsert_Request copyWith(void Function(ContactsUpsert_Request) updates) =>
      super.copyWith((message) => updates(message as ContactsUpsert_Request)) as ContactsUpsert_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsUpsert_Request create() => ContactsUpsert_Request._();
  @$core.override
  ContactsUpsert_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsUpsert_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsUpsert_Request>(create);
  static ContactsUpsert_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ContactsUpsert_Item> get items => $_getList(0);

  /// true → полный доступ к книге: заменить весь OPRF-набор владельца (удалить
  /// рёбра source=OPRF, чьих oprf нет в items). false → только добавить/обновить
  /// (iOS limited-доступ, ручное добавление) — ничего не удаляем.
  @$pb.TagNumber(2)
  $core.bool get full => $_getBF(1);
  @$pb.TagNumber(2)
  set full($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFull() => $_has(1);
  @$pb.TagNumber(2)
  void clearFull() => $_clearField(2);
}

class ContactsUpsert_Response extends $pb.GeneratedMessage {
  factory ContactsUpsert_Response() => create();

  ContactsUpsert_Response._();

  factory ContactsUpsert_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsUpsert_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsUpsert.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsUpsert_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsUpsert_Response copyWith(void Function(ContactsUpsert_Response) updates) =>
      super.copyWith((message) => updates(message as ContactsUpsert_Response)) as ContactsUpsert_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsUpsert_Response create() => ContactsUpsert_Response._();
  @$core.override
  ContactsUpsert_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsUpsert_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsUpsert_Response>(create);
  static ContactsUpsert_Response? _defaultInstance;
}

/// Серверный граф контактов (облачная адресная книга) — запись рёбер владельца.
/// MATCH выше остаётся чистым discovery; здесь клиент фиксирует, кого держать в
/// книге. Контакт адресуется OPRF-отпечатком номера; сам номер сервер не видит.
/// contactUserID сервер резолвит сам через user.oprf — в запросе его нет.
class ContactsUpsert extends $pb.GeneratedMessage {
  factory ContactsUpsert() => create();

  ContactsUpsert._();

  factory ContactsUpsert.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsUpsert.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsUpsert',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsUpsert clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsUpsert copyWith(void Function(ContactsUpsert) updates) =>
      super.copyWith((message) => updates(message as ContactsUpsert)) as ContactsUpsert;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsUpsert create() => ContactsUpsert._();
  @$core.override
  ContactsUpsert createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsUpsert getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsUpsert>(create);
  static ContactsUpsert? _defaultInstance;
}

class ContactsRemove_Request extends $pb.GeneratedMessage {
  factory ContactsRemove_Request({
    $core.Iterable<$core.List<$core.int>>? oprf,
  }) {
    final result = create();
    if (oprf != null) result.oprf.addAll(oprf);
    return result;
  }

  ContactsRemove_Request._();

  factory ContactsRemove_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsRemove_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsRemove.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'oprf', $pb.PbFieldType.PY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsRemove_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsRemove_Request copyWith(void Function(ContactsRemove_Request) updates) =>
      super.copyWith((message) => updates(message as ContactsRemove_Request)) as ContactsRemove_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsRemove_Request create() => ContactsRemove_Request._();
  @$core.override
  ContactsRemove_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsRemove_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsRemove_Request>(create);
  static ContactsRemove_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get oprf => $_getList(0);
}

class ContactsRemove_Response extends $pb.GeneratedMessage {
  factory ContactsRemove_Response() => create();

  ContactsRemove_Response._();

  factory ContactsRemove_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsRemove_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsRemove.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsRemove_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsRemove_Response copyWith(void Function(ContactsRemove_Response) updates) =>
      super.copyWith((message) => updates(message as ContactsRemove_Response)) as ContactsRemove_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsRemove_Response create() => ContactsRemove_Response._();
  @$core.override
  ContactsRemove_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsRemove_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsRemove_Response>(create);
  static ContactsRemove_Response? _defaultInstance;
}

/// Удаление рёбер владельца по OPRF-отпечаткам (отзыв контакта / права звонка).
/// Работает одинаково для pending, резолвленных и ручных записей.
class ContactsRemove extends $pb.GeneratedMessage {
  factory ContactsRemove() => create();

  ContactsRemove._();

  factory ContactsRemove.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsRemove.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsRemove',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsRemove clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsRemove copyWith(void Function(ContactsRemove) updates) =>
      super.copyWith((message) => updates(message as ContactsRemove)) as ContactsRemove;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsRemove create() => ContactsRemove._();
  @$core.override
  ContactsRemove createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsRemove getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsRemove>(create);
  static ContactsRemove? _defaultInstance;
}

/// Облачный контакт — PII, синхронизируемое между устройствами владельца. Сервер
/// хранит firstName/lastName/phoneNumber зашифрованными at-rest (Encryptor,
/// hkdfSalt = ownerUserID), но ДЕРЖИТ КЛЮЧ — это не E2E: сервис технически может
/// их прочитать. В List/Updated поля приходят уже расшифрованными (канал защищён
/// сессией). Пустые PII-поля ⇒ приватное OPRF-ребро (в облачные списки не входит).
class Contact extends $pb.GeneratedMessage {
  factory Contact({
    $core.List<$core.int>? oprf,
    $core.List<$core.int>? contactUserID,
    ContactsUpsert_Source? source,
    $core.String? firstName,
    $core.String? lastName,
    $core.String? phoneNumber,
    $fixnum.Int64? updatedAt,
  }) {
    final result = create();
    if (oprf != null) result.oprf = oprf;
    if (contactUserID != null) result.contactUserID = contactUserID;
    if (source != null) result.source = source;
    if (firstName != null) result.firstName = firstName;
    if (lastName != null) result.lastName = lastName;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Contact._();

  factory Contact.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Contact.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Contact',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'oprf', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'contactUserID', $pb.PbFieldType.OY, protoName: 'contactUserID')
    ..aE<ContactsUpsert_Source>(3, _omitFieldNames ? '' : 'source', enumValues: ContactsUpsert_Source.values)
    ..aOS(4, _omitFieldNames ? '' : 'firstName', protoName: 'firstName')
    ..aOS(5, _omitFieldNames ? '' : 'lastName', protoName: 'lastName')
    ..aOS(6, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aInt64(7, _omitFieldNames ? '' : 'updatedAt', protoName: 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Contact clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Contact copyWith(void Function(Contact) updates) => super.copyWith((message) => updates(message as Contact)) as Contact;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Contact create() => Contact._();
  @$core.override
  Contact createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Contact getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Contact>(create);
  static Contact? _defaultInstance;

  /// OPRF-отпечаток номера контакта — адрес ребра.
  @$pb.TagNumber(1)
  $core.List<$core.int> get oprf => $_getN(0);
  @$pb.TagNumber(1)
  set oprf($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOprf() => $_has(0);
  @$pb.TagNumber(1)
  void clearOprf() => $_clearField(1);

  /// userID резолвленного контакта (сырые байты ObjectID); пусто пока pending.
  @$pb.TagNumber(2)
  $core.List<$core.int> get contactUserID => $_getN(1);
  @$pb.TagNumber(2)
  set contactUserID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContactUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearContactUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  ContactsUpsert_Source get source => $_getN(2);
  @$pb.TagNumber(3)
  set source(ContactsUpsert_Source value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get firstName => $_getSZ(3);
  @$pb.TagNumber(4)
  set firstName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFirstName() => $_has(3);
  @$pb.TagNumber(4)
  void clearFirstName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get lastName => $_getSZ(4);
  @$pb.TagNumber(5)
  set lastName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLastName() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get phoneNumber => $_getSZ(5);
  @$pb.TagNumber(6)
  set phoneNumber($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPhoneNumber() => $_has(5);
  @$pb.TagNumber(6)
  void clearPhoneNumber() => $_clearField(6);

  /// Момент последнего изменения ребра (epoch ms) — для дельт/сортировки.
  @$pb.TagNumber(7)
  $fixnum.Int64 get updatedAt => $_getI64(6);
  @$pb.TagNumber(7)
  set updatedAt($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => $_clearField(7);
}

class ContactsList_Request extends $pb.GeneratedMessage {
  factory ContactsList_Request() => create();

  ContactsList_Request._();

  factory ContactsList_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsList_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsList.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsList_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsList_Request copyWith(void Function(ContactsList_Request) updates) =>
      super.copyWith((message) => updates(message as ContactsList_Request)) as ContactsList_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsList_Request create() => ContactsList_Request._();
  @$core.override
  ContactsList_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsList_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsList_Request>(create);
  static ContactsList_Request? _defaultInstance;
}

class ContactsList_Response extends $pb.GeneratedMessage {
  factory ContactsList_Response({
    $core.Iterable<Contact>? contacts,
  }) {
    final result = create();
    if (contacts != null) result.contacts.addAll(contacts);
    return result;
  }

  ContactsList_Response._();

  factory ContactsList_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsList_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsList.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Contact>(1, _omitFieldNames ? '' : 'contacts', subBuilder: Contact.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsList_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsList_Response copyWith(void Function(ContactsList_Response) updates) =>
      super.copyWith((message) => updates(message as ContactsList_Response)) as ContactsList_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsList_Response create() => ContactsList_Response._();
  @$core.override
  ContactsList_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsList_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsList_Response>(create);
  static ContactsList_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Contact> get contacts => $_getList(0);
}

/// Полный список облачных контактов владельца — тянется новым устройством на
/// bootstrap (владелец берётся из сессии). Сервер отдаёт PII расшифрованными.
class ContactsList extends $pb.GeneratedMessage {
  factory ContactsList() => create();

  ContactsList._();

  factory ContactsList.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsList.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsList copyWith(void Function(ContactsList) updates) =>
      super.copyWith((message) => updates(message as ContactsList)) as ContactsList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsList create() => ContactsList._();
  @$core.override
  ContactsList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsList>(create);
  static ContactsList? _defaultInstance;
}

/// Push-дельта облачных контактов, рассылаемая на все устройства владельца при
/// add/update/remove/resolve (тип сообщения CONTACTS_UPDATED, без Request/Response).
class ContactsUpdated extends $pb.GeneratedMessage {
  factory ContactsUpdated({
    $core.Iterable<Contact>? upserted,
    $core.Iterable<$core.List<$core.int>>? removedOprf,
  }) {
    final result = create();
    if (upserted != null) result.upserted.addAll(upserted);
    if (removedOprf != null) result.removedOprf.addAll(removedOprf);
    return result;
  }

  ContactsUpdated._();

  factory ContactsUpdated.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactsUpdated.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactsUpdated',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Contact>(1, _omitFieldNames ? '' : 'upserted', subBuilder: Contact.create)
    ..p<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'removedOprf', $pb.PbFieldType.PY, protoName: 'removedOprf')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsUpdated clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsUpdated copyWith(void Function(ContactsUpdated) updates) =>
      super.copyWith((message) => updates(message as ContactsUpdated)) as ContactsUpdated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactsUpdated create() => ContactsUpdated._();
  @$core.override
  ContactsUpdated createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactsUpdated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsUpdated>(create);
  static ContactsUpdated? _defaultInstance;

  /// Добавленные/обновлённые облачные контакты (PII расшифрованы).
  @$pb.TagNumber(1)
  $pb.PbList<Contact> get upserted => $_getList(0);

  /// OPRF-отпечатки удалённых рёбер.
  @$pb.TagNumber(2)
  $pb.PbList<$core.List<$core.int>> get removedOprf => $_getList(1);
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
