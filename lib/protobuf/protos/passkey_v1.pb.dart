// This is a generated file - do not edit.
//
// Generated from protos/passkey_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class PasskeyRegisterBegin_Request extends $pb.GeneratedMessage {
  factory PasskeyRegisterBegin_Request() => create();

  PasskeyRegisterBegin_Request._();

  factory PasskeyRegisterBegin_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRegisterBegin_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyRegisterBegin.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterBegin_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterBegin_Request copyWith(void Function(PasskeyRegisterBegin_Request) updates) =>
      super.copyWith((message) => updates(message as PasskeyRegisterBegin_Request)) as PasskeyRegisterBegin_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterBegin_Request create() => PasskeyRegisterBegin_Request._();
  @$core.override
  PasskeyRegisterBegin_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterBegin_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyRegisterBegin_Request>(create);
  static PasskeyRegisterBegin_Request? _defaultInstance;
}

class PasskeyRegisterBegin_Response extends $pb.GeneratedMessage {
  factory PasskeyRegisterBegin_Response({
    $core.List<$core.int>? publicKey,
  }) {
    final result = create();
    if (publicKey != null) result.publicKey = publicKey;
    return result;
  }

  PasskeyRegisterBegin_Response._();

  factory PasskeyRegisterBegin_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRegisterBegin_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyRegisterBegin.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY, protoName: 'publicKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterBegin_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterBegin_Response copyWith(void Function(PasskeyRegisterBegin_Response) updates) =>
      super.copyWith((message) => updates(message as PasskeyRegisterBegin_Response)) as PasskeyRegisterBegin_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterBegin_Response create() => PasskeyRegisterBegin_Response._();
  @$core.override
  PasskeyRegisterBegin_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterBegin_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyRegisterBegin_Response>(create);
  static PasskeyRegisterBegin_Response? _defaultInstance;

  /// JSON PublicKeyCredentialCreationOptions (challenge, rp, user,
  /// authenticatorSelection с residentKey=required и т.д.). Клиент передаёт его
  /// нативному API создания ключа.
  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => $_clearField(1);
}

/// Начало регистрации нового ключа: сервер отдаёт WebAuthn CreationOptions.
class PasskeyRegisterBegin extends $pb.GeneratedMessage {
  factory PasskeyRegisterBegin() => create();

  PasskeyRegisterBegin._();

  factory PasskeyRegisterBegin.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRegisterBegin.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyRegisterBegin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterBegin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterBegin copyWith(void Function(PasskeyRegisterBegin) updates) =>
      super.copyWith((message) => updates(message as PasskeyRegisterBegin)) as PasskeyRegisterBegin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterBegin create() => PasskeyRegisterBegin._();
  @$core.override
  PasskeyRegisterBegin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterBegin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyRegisterBegin>(create);
  static PasskeyRegisterBegin? _defaultInstance;
}

class PasskeyRegisterFinish_Request extends $pb.GeneratedMessage {
  factory PasskeyRegisterFinish_Request({
    $core.List<$core.int>? credential,
    $core.String? label,
  }) {
    final result = create();
    if (credential != null) result.credential = credential;
    if (label != null) result.label = label;
    return result;
  }

  PasskeyRegisterFinish_Request._();

  factory PasskeyRegisterFinish_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRegisterFinish_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyRegisterFinish.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'credential', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterFinish_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterFinish_Request copyWith(void Function(PasskeyRegisterFinish_Request) updates) =>
      super.copyWith((message) => updates(message as PasskeyRegisterFinish_Request)) as PasskeyRegisterFinish_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterFinish_Request create() => PasskeyRegisterFinish_Request._();
  @$core.override
  PasskeyRegisterFinish_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterFinish_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyRegisterFinish_Request>(create);
  static PasskeyRegisterFinish_Request? _defaultInstance;

  /// JSON credential (attestationObject + clientDataJSON), как вернул
  /// authenticator. Сервер верифицирует и сохраняет.
  @$pb.TagNumber(1)
  $core.List<$core.int> get credential => $_getN(0);
  @$pb.TagNumber(1)
  set credential($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCredential() => $_has(0);
  @$pb.TagNumber(1)
  void clearCredential() => $_clearField(1);

  /// Пользовательская метка ключа (необязательна). Если пусто — клиент покажет
  /// имя провайдера, выведенное из aaguid.
  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);
}

class PasskeyRegisterFinish_Response extends $pb.GeneratedMessage {
  factory PasskeyRegisterFinish_Response({
    PasskeyCredential? credential,
  }) {
    final result = create();
    if (credential != null) result.credential = credential;
    return result;
  }

  PasskeyRegisterFinish_Response._();

  factory PasskeyRegisterFinish_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRegisterFinish_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyRegisterFinish.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<PasskeyCredential>(1, _omitFieldNames ? '' : 'credential', subBuilder: PasskeyCredential.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterFinish_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterFinish_Response copyWith(void Function(PasskeyRegisterFinish_Response) updates) =>
      super.copyWith((message) => updates(message as PasskeyRegisterFinish_Response)) as PasskeyRegisterFinish_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterFinish_Response create() => PasskeyRegisterFinish_Response._();
  @$core.override
  PasskeyRegisterFinish_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterFinish_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyRegisterFinish_Response>(create);
  static PasskeyRegisterFinish_Response? _defaultInstance;

  @$pb.TagNumber(1)
  PasskeyCredential get credential => $_getN(0);
  @$pb.TagNumber(1)
  set credential(PasskeyCredential value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCredential() => $_has(0);
  @$pb.TagNumber(1)
  void clearCredential() => $_clearField(1);
  @$pb.TagNumber(1)
  PasskeyCredential ensureCredential() => $_ensure(0);
}

/// Завершение регистрации: attestation от аутентификатора + метка для UI.
class PasskeyRegisterFinish extends $pb.GeneratedMessage {
  factory PasskeyRegisterFinish() => create();

  PasskeyRegisterFinish._();

  factory PasskeyRegisterFinish.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRegisterFinish.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyRegisterFinish',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterFinish clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegisterFinish copyWith(void Function(PasskeyRegisterFinish) updates) =>
      super.copyWith((message) => updates(message as PasskeyRegisterFinish)) as PasskeyRegisterFinish;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterFinish create() => PasskeyRegisterFinish._();
  @$core.override
  PasskeyRegisterFinish createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRegisterFinish getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyRegisterFinish>(create);
  static PasskeyRegisterFinish? _defaultInstance;
}

class PasskeyList_Request extends $pb.GeneratedMessage {
  factory PasskeyList_Request() => create();

  PasskeyList_Request._();

  factory PasskeyList_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyList_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyList.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyList_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyList_Request copyWith(void Function(PasskeyList_Request) updates) =>
      super.copyWith((message) => updates(message as PasskeyList_Request)) as PasskeyList_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyList_Request create() => PasskeyList_Request._();
  @$core.override
  PasskeyList_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyList_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyList_Request>(create);
  static PasskeyList_Request? _defaultInstance;
}

class PasskeyList_Response extends $pb.GeneratedMessage {
  factory PasskeyList_Response({
    $core.Iterable<PasskeyCredential>? credentials,
  }) {
    final result = create();
    if (credentials != null) result.credentials.addAll(credentials);
    return result;
  }

  PasskeyList_Response._();

  factory PasskeyList_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyList_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyList.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<PasskeyCredential>(1, _omitFieldNames ? '' : 'credentials', subBuilder: PasskeyCredential.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyList_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyList_Response copyWith(void Function(PasskeyList_Response) updates) =>
      super.copyWith((message) => updates(message as PasskeyList_Response)) as PasskeyList_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyList_Response create() => PasskeyList_Response._();
  @$core.override
  PasskeyList_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyList_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyList_Response>(create);
  static PasskeyList_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PasskeyCredential> get credentials => $_getList(0);
}

/// Список ключей пользователя (экран настроек).
class PasskeyList extends $pb.GeneratedMessage {
  factory PasskeyList() => create();

  PasskeyList._();

  factory PasskeyList.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyList.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyList copyWith(void Function(PasskeyList) updates) => super.copyWith((message) => updates(message as PasskeyList)) as PasskeyList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyList create() => PasskeyList._();
  @$core.override
  PasskeyList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyList>(create);
  static PasskeyList? _defaultInstance;
}

class PasskeyDelete_Request extends $pb.GeneratedMessage {
  factory PasskeyDelete_Request({
    $core.List<$core.int>? credentialId,
  }) {
    final result = create();
    if (credentialId != null) result.credentialId = credentialId;
    return result;
  }

  PasskeyDelete_Request._();

  factory PasskeyDelete_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyDelete_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyDelete.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'credentialId', $pb.PbFieldType.OY, protoName: 'credentialId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyDelete_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyDelete_Request copyWith(void Function(PasskeyDelete_Request) updates) =>
      super.copyWith((message) => updates(message as PasskeyDelete_Request)) as PasskeyDelete_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyDelete_Request create() => PasskeyDelete_Request._();
  @$core.override
  PasskeyDelete_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyDelete_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyDelete_Request>(create);
  static PasskeyDelete_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get credentialId => $_getN(0);
  @$pb.TagNumber(1)
  set credentialId($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCredentialId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCredentialId() => $_clearField(1);
}

class PasskeyDelete_Response extends $pb.GeneratedMessage {
  factory PasskeyDelete_Response({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  PasskeyDelete_Response._();

  factory PasskeyDelete_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyDelete_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyDelete.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyDelete_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyDelete_Response copyWith(void Function(PasskeyDelete_Response) updates) =>
      super.copyWith((message) => updates(message as PasskeyDelete_Response)) as PasskeyDelete_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyDelete_Response create() => PasskeyDelete_Response._();
  @$core.override
  PasskeyDelete_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyDelete_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyDelete_Response>(create);
  static PasskeyDelete_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// Удаление ключа (по credentialId; сервер проверяет принадлежность userID).
class PasskeyDelete extends $pb.GeneratedMessage {
  factory PasskeyDelete() => create();

  PasskeyDelete._();

  factory PasskeyDelete.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyDelete.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyDelete',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyDelete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyDelete copyWith(void Function(PasskeyDelete) updates) =>
      super.copyWith((message) => updates(message as PasskeyDelete)) as PasskeyDelete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyDelete create() => PasskeyDelete._();
  @$core.override
  PasskeyDelete createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyDelete getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyDelete>(create);
  static PasskeyDelete? _defaultInstance;
}

/// Сводка одного ключа для UI. aaguid → имя/иконка провайдера («iCloud Keychain»,
/// «Google Password Manager», …) резолвится на клиенте по публичной FIDO-таблице.
class PasskeyCredential extends $pb.GeneratedMessage {
  factory PasskeyCredential({
    $core.List<$core.int>? credentialId,
    $core.String? label,
    $core.List<$core.int>? aaguid,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? lastUsedAt,
  }) {
    final result = create();
    if (credentialId != null) result.credentialId = credentialId;
    if (label != null) result.label = label;
    if (aaguid != null) result.aaguid = aaguid;
    if (createdAt != null) result.createdAt = createdAt;
    if (lastUsedAt != null) result.lastUsedAt = lastUsedAt;
    return result;
  }

  PasskeyCredential._();

  factory PasskeyCredential.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyCredential.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyCredential',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'credentialId', $pb.PbFieldType.OY, protoName: 'credentialId')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'aaguid', $pb.PbFieldType.OY)
    ..aInt64(4, _omitFieldNames ? '' : 'createdAt', protoName: 'createdAt')
    ..aInt64(5, _omitFieldNames ? '' : 'lastUsedAt', protoName: 'lastUsedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCredential clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCredential copyWith(void Function(PasskeyCredential) updates) =>
      super.copyWith((message) => updates(message as PasskeyCredential)) as PasskeyCredential;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyCredential create() => PasskeyCredential._();
  @$core.override
  PasskeyCredential createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyCredential getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyCredential>(create);
  static PasskeyCredential? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get credentialId => $_getN(0);
  @$pb.TagNumber(1)
  set credentialId($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCredentialId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCredentialId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get aaguid => $_getN(2);
  @$pb.TagNumber(3)
  set aaguid($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAaguid() => $_has(2);
  @$pb.TagNumber(3)
  void clearAaguid() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get createdAt => $_getI64(3);
  @$pb.TagNumber(4)
  set createdAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get lastUsedAt => $_getI64(4);
  @$pb.TagNumber(5)
  set lastUsedAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLastUsedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastUsedAt() => $_clearField(5);
}

class PasskeyLoginBegin_Request extends $pb.GeneratedMessage {
  factory PasskeyLoginBegin_Request() => create();

  PasskeyLoginBegin_Request._();

  factory PasskeyLoginBegin_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyLoginBegin_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyLoginBegin.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginBegin_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginBegin_Request copyWith(void Function(PasskeyLoginBegin_Request) updates) =>
      super.copyWith((message) => updates(message as PasskeyLoginBegin_Request)) as PasskeyLoginBegin_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyLoginBegin_Request create() => PasskeyLoginBegin_Request._();
  @$core.override
  PasskeyLoginBegin_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyLoginBegin_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyLoginBegin_Request>(create);
  static PasskeyLoginBegin_Request? _defaultInstance;
}

class PasskeyLoginBegin_Response extends $pb.GeneratedMessage {
  factory PasskeyLoginBegin_Response({
    $core.List<$core.int>? loginSession,
    $core.List<$core.int>? publicKey,
  }) {
    final result = create();
    if (loginSession != null) result.loginSession = loginSession;
    if (publicKey != null) result.publicKey = publicKey;
    return result;
  }

  PasskeyLoginBegin_Response._();

  factory PasskeyLoginBegin_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyLoginBegin_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyLoginBegin.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'loginSession', $pb.PbFieldType.OY, protoName: 'loginSession')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY, protoName: 'publicKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginBegin_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginBegin_Response copyWith(void Function(PasskeyLoginBegin_Response) updates) =>
      super.copyWith((message) => updates(message as PasskeyLoginBegin_Response)) as PasskeyLoginBegin_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyLoginBegin_Response create() => PasskeyLoginBegin_Response._();
  @$core.override
  PasskeyLoginBegin_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyLoginBegin_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyLoginBegin_Response>(create);
  static PasskeyLoginBegin_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get loginSession => $_getN(0);
  @$pb.TagNumber(1)
  set loginSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLoginSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoginSession() => $_clearField(1);

  /// JSON PublicKeyCredentialRequestOptions.
  @$pb.TagNumber(2)
  $core.List<$core.int> get publicKey => $_getN(1);
  @$pb.TagNumber(2)
  set publicKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => $_clearField(2);
}

/// Начало входа: discoverable-assertion (без allowCredentials — конкретный ключ
/// выбирается на устройстве). Сервер отдаёт RequestOptions + loginSession —
/// непрозрачный хэндл, связывающий begin/finish (challenge живёт в Redis).
class PasskeyLoginBegin extends $pb.GeneratedMessage {
  factory PasskeyLoginBegin() => create();

  PasskeyLoginBegin._();

  factory PasskeyLoginBegin.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyLoginBegin.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyLoginBegin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginBegin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginBegin copyWith(void Function(PasskeyLoginBegin) updates) =>
      super.copyWith((message) => updates(message as PasskeyLoginBegin)) as PasskeyLoginBegin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyLoginBegin create() => PasskeyLoginBegin._();
  @$core.override
  PasskeyLoginBegin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyLoginBegin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyLoginBegin>(create);
  static PasskeyLoginBegin? _defaultInstance;
}

class PasskeyLoginFinish_Request extends $pb.GeneratedMessage {
  factory PasskeyLoginFinish_Request({
    $core.List<$core.int>? loginSession,
    $core.List<$core.int>? credential,
  }) {
    final result = create();
    if (loginSession != null) result.loginSession = loginSession;
    if (credential != null) result.credential = credential;
    return result;
  }

  PasskeyLoginFinish_Request._();

  factory PasskeyLoginFinish_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyLoginFinish_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyLoginFinish.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'loginSession', $pb.PbFieldType.OY, protoName: 'loginSession')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'credential', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginFinish_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginFinish_Request copyWith(void Function(PasskeyLoginFinish_Request) updates) =>
      super.copyWith((message) => updates(message as PasskeyLoginFinish_Request)) as PasskeyLoginFinish_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyLoginFinish_Request create() => PasskeyLoginFinish_Request._();
  @$core.override
  PasskeyLoginFinish_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyLoginFinish_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyLoginFinish_Request>(create);
  static PasskeyLoginFinish_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get loginSession => $_getN(0);
  @$pb.TagNumber(1)
  set loginSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLoginSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoginSession() => $_clearField(1);

  /// JSON assertion (authenticatorData + clientDataJSON + signature + userHandle).
  @$pb.TagNumber(2)
  $core.List<$core.int> get credential => $_getN(1);
  @$pb.TagNumber(2)
  set credential($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCredential() => $_has(1);
  @$pb.TagNumber(2)
  void clearCredential() => $_clearField(2);
}

class PasskeyLoginFinish_Response extends $pb.GeneratedMessage {
  factory PasskeyLoginFinish_Response({
    $core.List<$core.int>? confirmationSession,
    $core.bool? hasTwoStepVerification,
  }) {
    final result = create();
    if (confirmationSession != null) result.confirmationSession = confirmationSession;
    if (hasTwoStepVerification != null) result.hasTwoStepVerification = hasTwoStepVerification;
    return result;
  }

  PasskeyLoginFinish_Response._();

  factory PasskeyLoginFinish_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyLoginFinish_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyLoginFinish.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'confirmationSession', $pb.PbFieldType.OY, protoName: 'confirmationSession')
    ..aOB(2, _omitFieldNames ? '' : 'hasTwoStepVerification', protoName: 'hasTwoStepVerification')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginFinish_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginFinish_Response copyWith(void Function(PasskeyLoginFinish_Response) updates) =>
      super.copyWith((message) => updates(message as PasskeyLoginFinish_Response)) as PasskeyLoginFinish_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyLoginFinish_Response create() => PasskeyLoginFinish_Response._();
  @$core.override
  PasskeyLoginFinish_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyLoginFinish_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyLoginFinish_Response>(create);
  static PasskeyLoginFinish_Response? _defaultInstance;

  /// Скармливается AUTH_CONFIRMATION (тот же путь, что call-password/moderation).
  @$pb.TagNumber(1)
  $core.List<$core.int> get confirmationSession => $_getN(0);
  @$pb.TagNumber(1)
  set confirmationSession($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConfirmationSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfirmationSession() => $_clearField(1);

  /// Включена ли двухшаговая проверка: если true — клиент уходит на шаг ввода
  /// облачного пароля (/auth/cloud_password), передав confirmationSession.
  @$pb.TagNumber(2)
  $core.bool get hasTwoStepVerification => $_getBF(1);
  @$pb.TagNumber(2)
  set hasTwoStepVerification($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasTwoStepVerification() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasTwoStepVerification() => $_clearField(2);
}

/// Завершение входа: assertion от аутентификатора. Сервер проверяет подпись и
/// signCount, резолвит пользователя по userHandle и выдаёт confirmationSession.
class PasskeyLoginFinish extends $pb.GeneratedMessage {
  factory PasskeyLoginFinish() => create();

  PasskeyLoginFinish._();

  factory PasskeyLoginFinish.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyLoginFinish.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PasskeyLoginFinish',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginFinish clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyLoginFinish copyWith(void Function(PasskeyLoginFinish) updates) =>
      super.copyWith((message) => updates(message as PasskeyLoginFinish)) as PasskeyLoginFinish;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyLoginFinish create() => PasskeyLoginFinish._();
  @$core.override
  PasskeyLoginFinish createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyLoginFinish getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PasskeyLoginFinish>(create);
  static PasskeyLoginFinish? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
