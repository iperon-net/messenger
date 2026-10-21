// This is a generated file - do not edit.
//
// Generated from protos/chats_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chats_v1.pbenum.dart';
import 'models.pb.dart' as $0;
import 'profile_v1.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'chats_v1.pbenum.dart';

/// Группа (общее для всех участников). Название, описание и аватар хранятся на
/// сервере зашифрованными (crypto.Encryptor). pts — журнал ЧАТА: у группы свой
/// монотонный номер обновлений, не копия в журнал каждого участника (см.
/// Update.chatPts и Chats.GetChatDifference).
class ChatInfo extends $pb.GeneratedMessage {
  factory ChatInfo({
    $core.List<$core.int>? chatID,
    ChatType? type,
    $core.String? title,
    $core.String? about,
    $core.List<$core.int>? avatarCdnID,
    $0.CDN? avatar,
    $core.int? membersCount,
    $core.List<$core.int>? ownerUserID,
    $fixnum.Int64? pts,
    $fixnum.Int64? createdAt,
    ChatRole? defaultRole,
    $core.String? username,
    ChatJoinMode? joinMode,
    $core.bool? historyHidden,
    $core.int? slowMode,
    $core.int? newcomerMediaDelay,
    $core.bool? membersHidden,
    ChatReactionsMode? reactionsMode,
    $core.Iterable<$core.String>? reactions,
    $core.bool? noForwards,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (type != null) result.type = type;
    if (title != null) result.title = title;
    if (about != null) result.about = about;
    if (avatarCdnID != null) result.avatarCdnID = avatarCdnID;
    if (avatar != null) result.avatar = avatar;
    if (membersCount != null) result.membersCount = membersCount;
    if (ownerUserID != null) result.ownerUserID = ownerUserID;
    if (pts != null) result.pts = pts;
    if (createdAt != null) result.createdAt = createdAt;
    if (defaultRole != null) result.defaultRole = defaultRole;
    if (username != null) result.username = username;
    if (joinMode != null) result.joinMode = joinMode;
    if (historyHidden != null) result.historyHidden = historyHidden;
    if (slowMode != null) result.slowMode = slowMode;
    if (newcomerMediaDelay != null) result.newcomerMediaDelay = newcomerMediaDelay;
    if (membersHidden != null) result.membersHidden = membersHidden;
    if (reactionsMode != null) result.reactionsMode = reactionsMode;
    if (reactions != null) result.reactions.addAll(reactions);
    if (noForwards != null) result.noForwards = noForwards;
    return result;
  }

  ChatInfo._();

  factory ChatInfo.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatInfo.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aE<ChatType>(2, _omitFieldNames ? '' : 'type', enumValues: ChatType.values)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'about')
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'avatarCdnID', $pb.PbFieldType.OY, protoName: 'avatarCdnID')
    ..aOM<$0.CDN>(6, _omitFieldNames ? '' : 'avatar', subBuilder: $0.CDN.create)
    ..aI(7, _omitFieldNames ? '' : 'membersCount', protoName: 'membersCount')
    ..a<$core.List<$core.int>>(8, _omitFieldNames ? '' : 'ownerUserID', $pb.PbFieldType.OY, protoName: 'ownerUserID')
    ..aInt64(9, _omitFieldNames ? '' : 'pts')
    ..aInt64(10, _omitFieldNames ? '' : 'createdAt', protoName: 'createdAt')
    ..aE<ChatRole>(11, _omitFieldNames ? '' : 'defaultRole', protoName: 'defaultRole', enumValues: ChatRole.values)
    ..aOS(12, _omitFieldNames ? '' : 'username')
    ..aE<ChatJoinMode>(13, _omitFieldNames ? '' : 'joinMode', protoName: 'joinMode', enumValues: ChatJoinMode.values)
    ..aOB(14, _omitFieldNames ? '' : 'historyHidden', protoName: 'historyHidden')
    ..aI(15, _omitFieldNames ? '' : 'slowMode', protoName: 'slowMode')
    ..aI(16, _omitFieldNames ? '' : 'newcomerMediaDelay', protoName: 'newcomerMediaDelay')
    ..aOB(17, _omitFieldNames ? '' : 'membersHidden', protoName: 'membersHidden')
    ..aE<ChatReactionsMode>(18, _omitFieldNames ? '' : 'reactionsMode', protoName: 'reactionsMode', enumValues: ChatReactionsMode.values)
    ..pPS(19, _omitFieldNames ? '' : 'reactions')
    ..aOB(20, _omitFieldNames ? '' : 'noForwards', protoName: 'noForwards')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatInfo copyWith(void Function(ChatInfo) updates) => super.copyWith((message) => updates(message as ChatInfo)) as ChatInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatInfo create() => ChatInfo._();
  @$core.override
  ChatInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatInfo>(create);
  static ChatInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  ChatType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(ChatType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get about => $_getSZ(3);
  @$pb.TagNumber(4)
  set about($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAbout() => $_has(3);
  @$pb.TagNumber(4)
  void clearAbout() => $_clearField(4);

  /// Аватар (загружен через Upload); пусто — нет.
  @$pb.TagNumber(5)
  $core.List<$core.int> get avatarCdnID => $_getN(4);
  @$pb.TagNumber(5)
  set avatarCdnID($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAvatarCdnID() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvatarCdnID() => $_clearField(5);

  /// Как скачать аватар — заполняет сервер при выдаче (как MessageMedia.file).
  @$pb.TagNumber(6)
  $0.CDN get avatar => $_getN(5);
  @$pb.TagNumber(6)
  set avatar($0.CDN value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAvatar() => $_has(5);
  @$pb.TagNumber(6)
  void clearAvatar() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.CDN ensureAvatar() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get membersCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set membersCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMembersCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearMembersCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get ownerUserID => $_getN(7);
  @$pb.TagNumber(8)
  set ownerUserID($core.List<$core.int> value) => $_setBytes(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOwnerUserID() => $_has(7);
  @$pb.TagNumber(8)
  void clearOwnerUserID() => $_clearField(8);

  /// Текущий pts журнала чата.
  @$pb.TagNumber(9)
  $fixnum.Int64 get pts => $_getI64(8);
  @$pb.TagNumber(9)
  set pts($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPts() => $_has(8);
  @$pb.TagNumber(9)
  void clearPts() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get createdAt => $_getI64(9);
  @$pb.TagNumber(10)
  set createdAt($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);

  /// Роль вступающих / добавленных (READER или WRITER; по умолчанию WRITER).
  @$pb.TagNumber(11)
  ChatRole get defaultRole => $_getN(10);
  @$pb.TagNumber(11)
  set defaultRole(ChatRole value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDefaultRole() => $_has(10);
  @$pb.TagNumber(11)
  void clearDefaultRole() => $_clearField(11);

  /// Публичное имя (ссылка iperon.net/<username>) — только у OPEN, иначе пусто.
  @$pb.TagNumber(12)
  $core.String get username => $_getSZ(11);
  @$pb.TagNumber(12)
  set username($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasUsername() => $_has(11);
  @$pb.TagNumber(12)
  void clearUsername() => $_clearField(12);

  @$pb.TagNumber(13)
  ChatJoinMode get joinMode => $_getN(12);
  @$pb.TagNumber(13)
  set joinMode(ChatJoinMode value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasJoinMode() => $_has(12);
  @$pb.TagNumber(13)
  void clearJoinMode() => $_clearField(13);

  /// «Скрыть историю» (только частные — не OPEN): вступившие после включения
  /// видят сообщения только с момента вступления.
  @$pb.TagNumber(14)
  $core.bool get historyHidden => $_getBF(13);
  @$pb.TagNumber(14)
  set historyHidden($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasHistoryHidden() => $_has(13);
  @$pb.TagNumber(14)
  void clearHistoryHidden() => $_clearField(14);

  /// Медленный режим (подэтап 3.4): участник без прав админа отправляет не
  /// чаще одного сообщения за столько секунд; 0 — выключен. Значения — 0, 10,
  /// 30, 60, 300, 900, 3600.
  @$pb.TagNumber(15)
  $core.int get slowMode => $_getIZ(14);
  @$pb.TagNumber(15)
  set slowMode($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasSlowMode() => $_has(14);
  @$pb.TagNumber(15)
  void clearSlowMode() => $_clearField(15);

  /// «Новичкам — без ссылок и медиа»: вступившие меньше стольких секунд назад
  /// (не админы) пишут только текст без ссылок; 0 — выключено.
  @$pb.TagNumber(16)
  $core.int get newcomerMediaDelay => $_getIZ(15);
  @$pb.TagNumber(16)
  set newcomerMediaDelay($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasNewcomerMediaDelay() => $_has(15);
  @$pb.TagNumber(16)
  void clearNewcomerMediaDelay() => $_clearField(16);

  /// «Скрыть участников»: список участников видят только владелец и админы
  /// (остальным Members отдаёт только админов). Не-админам не уходят и
  /// изменения состава (Update.chatMembers — только о них самих), а служебные
  /// «добавил / вступил / вышел / исключил» в ленту не пишутся вовсе.
  @$pb.TagNumber(17)
  $core.bool get membersHidden => $_getBF(16);
  @$pb.TagNumber(17)
  set membersHidden($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasMembersHidden() => $_has(16);
  @$pb.TagNumber(17)
  void clearMembersHidden() => $_clearField(17);

  /// Реакции группы: режим и набор (для SOME, порядок — порядок в полосе).
  @$pb.TagNumber(18)
  ChatReactionsMode get reactionsMode => $_getN(17);
  @$pb.TagNumber(18)
  set reactionsMode(ChatReactionsMode value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasReactionsMode() => $_has(17);
  @$pb.TagNumber(18)
  void clearReactionsMode() => $_clearField(18);

  @$pb.TagNumber(19)
  $pb.PbList<$core.String> get reactions => $_getList(18);

  /// «Запретить копирование» (как noforwards / «Restrict saving content» у
  /// групп в Telegram, EditChat.noForwards): пересылка из группы (сервер
  /// отказывает), копирование, сохранение медиа и скриншоты запрещены всем
  /// участникам, включая админов и владельца, на всю историю; пуши — без
  /// текста. Служебного в ленту нет — только Update.chatInfo.
  @$pb.TagNumber(20)
  $core.bool get noForwards => $_getBF(19);
  @$pb.TagNumber(20)
  set noForwards($core.bool value) => $_setBool(19, value);
  @$pb.TagNumber(20)
  $core.bool hasNoForwards() => $_has(19);
  @$pb.TagNumber(20)
  void clearNoForwards() => $_clearField(20);
}

/// Ссылка-приглашение (как chatInviteExported в Telegram). Путь ссылки —
/// iperon.net/+<code>; код выдаёт сервер (12 символов base62). primary —
/// основная: создаётся с группой, её можно только заменить (Revoke выдаёт
/// новую основную), не удалить. Видят и правят владелец и админы с inviteUsers.
class ChatInviteLink extends $pb.GeneratedMessage {
  factory ChatInviteLink({
    $core.String? code,
    $core.String? title,
    $core.bool? primary,
    $core.bool? revoked,
    $fixnum.Int64? expireDate,
    $core.int? usageLimit,
    $core.int? usage,
    $core.bool? requestApproval,
    $fixnum.Int64? createdAt,
    $core.List<$core.int>? creatorUserID,
    $core.int? pendingCount,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (title != null) result.title = title;
    if (primary != null) result.primary = primary;
    if (revoked != null) result.revoked = revoked;
    if (expireDate != null) result.expireDate = expireDate;
    if (usageLimit != null) result.usageLimit = usageLimit;
    if (usage != null) result.usage = usage;
    if (requestApproval != null) result.requestApproval = requestApproval;
    if (createdAt != null) result.createdAt = createdAt;
    if (creatorUserID != null) result.creatorUserID = creatorUserID;
    if (pendingCount != null) result.pendingCount = pendingCount;
    return result;
  }

  ChatInviteLink._();

  factory ChatInviteLink.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatInviteLink.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatInviteLink',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOB(3, _omitFieldNames ? '' : 'primary')
    ..aOB(4, _omitFieldNames ? '' : 'revoked')
    ..aInt64(5, _omitFieldNames ? '' : 'expireDate', protoName: 'expireDate')
    ..aI(6, _omitFieldNames ? '' : 'usageLimit', protoName: 'usageLimit')
    ..aI(7, _omitFieldNames ? '' : 'usage')
    ..aOB(8, _omitFieldNames ? '' : 'requestApproval', protoName: 'requestApproval')
    ..aInt64(9, _omitFieldNames ? '' : 'createdAt', protoName: 'createdAt')
    ..a<$core.List<$core.int>>(10, _omitFieldNames ? '' : 'creatorUserID', $pb.PbFieldType.OY, protoName: 'creatorUserID')
    ..aI(11, _omitFieldNames ? '' : 'pendingCount', protoName: 'pendingCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatInviteLink clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatInviteLink copyWith(void Function(ChatInviteLink) updates) =>
      super.copyWith((message) => updates(message as ChatInviteLink)) as ChatInviteLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatInviteLink create() => ChatInviteLink._();
  @$core.override
  ChatInviteLink createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatInviteLink getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatInviteLink>(create);
  static ChatInviteLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  /// Название для админов; пусто — показывается сама ссылка.
  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get primary => $_getBF(2);
  @$pb.TagNumber(3)
  set primary($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrimary() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrimary() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get revoked => $_getBF(3);
  @$pb.TagNumber(4)
  set revoked($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevoked() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevoked() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expireDate => $_getI64(4);
  @$pb.TagNumber(5)
  set expireDate($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpireDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpireDate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get usageLimit => $_getIZ(5);
  @$pb.TagNumber(6)
  set usageLimit($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUsageLimit() => $_has(5);
  @$pb.TagNumber(6)
  void clearUsageLimit() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get usage => $_getIZ(6);
  @$pb.TagNumber(7)
  set usage($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUsage() => $_has(6);
  @$pb.TagNumber(7)
  void clearUsage() => $_clearField(7);

  /// Вступление по ссылке — заявкой (у REQUEST — всегда).
  @$pb.TagNumber(8)
  $core.bool get requestApproval => $_getBF(7);
  @$pb.TagNumber(8)
  set requestApproval($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRequestApproval() => $_has(7);
  @$pb.TagNumber(8)
  void clearRequestApproval() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createdAt => $_getI64(8);
  @$pb.TagNumber(9)
  set createdAt($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.List<$core.int> get creatorUserID => $_getN(9);
  @$pb.TagNumber(10)
  set creatorUserID($core.List<$core.int> value) => $_setBytes(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatorUserID() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatorUserID() => $_clearField(10);

  /// Ждущих заявок по этой ссылке.
  @$pb.TagNumber(11)
  $core.int get pendingCount => $_getIZ(10);
  @$pb.TagNumber(11)
  set pendingCount($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPendingCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearPendingCount() => $_clearField(11);
}

/// Заявка на вступление.
class ChatJoinRequest extends $pb.GeneratedMessage {
  factory ChatJoinRequest({
    $core.List<$core.int>? userID,
    $fixnum.Int64? date,
    $core.String? inviteCode,
    $core.String? inviteTitle,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (date != null) result.date = date;
    if (inviteCode != null) result.inviteCode = inviteCode;
    if (inviteTitle != null) result.inviteTitle = inviteTitle;
    return result;
  }

  ChatJoinRequest._();

  factory ChatJoinRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatJoinRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatJoinRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aInt64(2, _omitFieldNames ? '' : 'date')
    ..aOS(3, _omitFieldNames ? '' : 'inviteCode', protoName: 'inviteCode')
    ..aOS(4, _omitFieldNames ? '' : 'inviteTitle', protoName: 'inviteTitle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatJoinRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatJoinRequest copyWith(void Function(ChatJoinRequest) updates) =>
      super.copyWith((message) => updates(message as ChatJoinRequest)) as ChatJoinRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatJoinRequest create() => ChatJoinRequest._();
  @$core.override
  ChatJoinRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatJoinRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatJoinRequest>(create);
  static ChatJoinRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get date => $_getI64(1);
  @$pb.TagNumber(2)
  set date($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);

  /// Ссылка, по которой пришла (пусто — по username у OPEN не бывает; основная
  /// — её код), и её название.
  @$pb.TagNumber(3)
  $core.String get inviteCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set inviteCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInviteCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearInviteCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get inviteTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set inviteTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInviteTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearInviteTitle() => $_clearField(4);
}

/// Предпросмотр группы до вступления (по ссылке-приглашению или username).
class ChatPreview extends $pb.GeneratedMessage {
  factory ChatPreview({
    ChatInfo? chat,
    $core.bool? requestNeeded,
    $core.bool? requested,
    $core.bool? canViewHistory,
    $core.Iterable<$1.Profile_Response>? members,
  }) {
    final result = create();
    if (chat != null) result.chat = chat;
    if (requestNeeded != null) result.requestNeeded = requestNeeded;
    if (requested != null) result.requested = requested;
    if (canViewHistory != null) result.canViewHistory = canViewHistory;
    if (members != null) result.members.addAll(members);
    return result;
  }

  ChatPreview._();

  factory ChatPreview.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatPreview.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatPreview',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatInfo>(1, _omitFieldNames ? '' : 'chat', subBuilder: ChatInfo.create)
    ..aOB(2, _omitFieldNames ? '' : 'requestNeeded', protoName: 'requestNeeded')
    ..aOB(3, _omitFieldNames ? '' : 'requested')
    ..aOB(4, _omitFieldNames ? '' : 'canViewHistory', protoName: 'canViewHistory')
    ..pPM<$1.Profile_Response>(5, _omitFieldNames ? '' : 'members', subBuilder: $1.Profile_Response.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatPreview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatPreview copyWith(void Function(ChatPreview) updates) => super.copyWith((message) => updates(message as ChatPreview)) as ChatPreview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatPreview create() => ChatPreview._();
  @$core.override
  ChatPreview createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatPreview getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatPreview>(create);
  static ChatPreview? _defaultInstance;

  /// Без pts; avatar — со ссылкой на скачивание.
  @$pb.TagNumber(1)
  ChatInfo get chat => $_getN(0);
  @$pb.TagNumber(1)
  set chat(ChatInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChat() => $_has(0);
  @$pb.TagNumber(1)
  void clearChat() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatInfo ensureChat() => $_ensure(0);

  /// Вступление — заявкой (ссылка с одобрением или режим REQUEST).
  @$pb.TagNumber(2)
  $core.bool get requestNeeded => $_getBF(1);
  @$pb.TagNumber(2)
  set requestNeeded($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestNeeded() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestNeeded() => $_clearField(2);

  /// Моя заявка уже ждёт.
  @$pb.TagNumber(3)
  $core.bool get requested => $_getBF(2);
  @$pb.TagNumber(3)
  set requested($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequested() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequested() => $_clearField(3);

  /// Можно читать историю без вступления (публичная, OPEN) — Messages.History /
  /// Get по chatID без журнала и без отметок о прочтении.
  @$pb.TagNumber(4)
  $core.bool get canViewHistory => $_getBF(3);
  @$pb.TagNumber(4)
  set canViewHistory($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCanViewHistory() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanViewHistory() => $_clearField(4);

  /// Несколько участников для «Анна, Олег и ещё 12» (профили — глазами
  /// смотрящего).
  @$pb.TagNumber(5)
  $pb.PbList<$1.Profile_Response> get members => $_getList(4);
}

/// Права админа (как chatAdminRights в Telegram) — раздельные галочки при
/// назначении. Выдать можно только не шире своих (у владельца — все всегда).
/// postMessages / editMessages — для каналов (срез 4), в группе не значат.
class ChatAdminRights extends $pb.GeneratedMessage {
  factory ChatAdminRights({
    $core.bool? changeInfo,
    $core.bool? postMessages,
    $core.bool? editMessages,
    $core.bool? deleteMessages,
    $core.bool? banUsers,
    $core.bool? inviteUsers,
    $core.bool? pinMessages,
    $core.bool? manageCalls,
    $core.bool? anonymous,
    $core.bool? addAdmins,
  }) {
    final result = create();
    if (changeInfo != null) result.changeInfo = changeInfo;
    if (postMessages != null) result.postMessages = postMessages;
    if (editMessages != null) result.editMessages = editMessages;
    if (deleteMessages != null) result.deleteMessages = deleteMessages;
    if (banUsers != null) result.banUsers = banUsers;
    if (inviteUsers != null) result.inviteUsers = inviteUsers;
    if (pinMessages != null) result.pinMessages = pinMessages;
    if (manageCalls != null) result.manageCalls = manageCalls;
    if (anonymous != null) result.anonymous = anonymous;
    if (addAdmins != null) result.addAdmins = addAdmins;
    return result;
  }

  ChatAdminRights._();

  factory ChatAdminRights.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatAdminRights.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatAdminRights',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'changeInfo', protoName: 'changeInfo')
    ..aOB(2, _omitFieldNames ? '' : 'postMessages', protoName: 'postMessages')
    ..aOB(3, _omitFieldNames ? '' : 'editMessages', protoName: 'editMessages')
    ..aOB(4, _omitFieldNames ? '' : 'deleteMessages', protoName: 'deleteMessages')
    ..aOB(5, _omitFieldNames ? '' : 'banUsers', protoName: 'banUsers')
    ..aOB(6, _omitFieldNames ? '' : 'inviteUsers', protoName: 'inviteUsers')
    ..aOB(7, _omitFieldNames ? '' : 'pinMessages', protoName: 'pinMessages')
    ..aOB(8, _omitFieldNames ? '' : 'manageCalls', protoName: 'manageCalls')
    ..aOB(9, _omitFieldNames ? '' : 'anonymous')
    ..aOB(10, _omitFieldNames ? '' : 'addAdmins', protoName: 'addAdmins')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatAdminRights clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatAdminRights copyWith(void Function(ChatAdminRights) updates) =>
      super.copyWith((message) => updates(message as ChatAdminRights)) as ChatAdminRights;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatAdminRights create() => ChatAdminRights._();
  @$core.override
  ChatAdminRights createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatAdminRights getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatAdminRights>(create);
  static ChatAdminRights? _defaultInstance;

  /// Название, описание, фото и настройки группы (в т.ч. роль по умолчанию).
  @$pb.TagNumber(1)
  $core.bool get changeInfo => $_getBF(0);
  @$pb.TagNumber(1)
  set changeInfo($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChangeInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearChangeInfo() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get postMessages => $_getBF(1);
  @$pb.TagNumber(2)
  set postMessages($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostMessages() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostMessages() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get editMessages => $_getBF(2);
  @$pb.TagNumber(3)
  set editMessages($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEditMessages() => $_has(2);
  @$pb.TagNumber(3)
  void clearEditMessages() => $_clearField(3);

  /// Удалять чужие сообщения у всех.
  @$pb.TagNumber(4)
  $core.bool get deleteMessages => $_getBF(3);
  @$pb.TagNumber(4)
  set deleteMessages($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeleteMessages() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeleteMessages() => $_clearField(4);

  /// Исключать и блокировать участников, менять роль READER / WRITER.
  @$pb.TagNumber(5)
  $core.bool get banUsers => $_getBF(4);
  @$pb.TagNumber(5)
  set banUsers($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBanUsers() => $_has(4);
  @$pb.TagNumber(5)
  void clearBanUsers() => $_clearField(5);

  /// Приглашать участников (ссылки и заявки — подэтап 3.3).
  @$pb.TagNumber(6)
  $core.bool get inviteUsers => $_getBF(5);
  @$pb.TagNumber(6)
  set inviteUsers($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInviteUsers() => $_has(5);
  @$pb.TagNumber(6)
  void clearInviteUsers() => $_clearField(6);

  /// Закреплять сообщения у всех.
  @$pb.TagNumber(7)
  $core.bool get pinMessages => $_getBF(6);
  @$pb.TagNumber(7)
  set pinMessages($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPinMessages() => $_has(6);
  @$pb.TagNumber(7)
  void clearPinMessages() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get manageCalls => $_getBF(7);
  @$pb.TagNumber(8)
  set manageCalls($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasManageCalls() => $_has(7);
  @$pb.TagNumber(8)
  void clearManageCalls() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get anonymous => $_getBF(8);
  @$pb.TagNumber(9)
  set anonymous($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAnonymous() => $_has(8);
  @$pb.TagNumber(9)
  void clearAnonymous() => $_clearField(9);

  /// Назначать админов (с правами не шире своих) и снимать назначенных собой.
  @$pb.TagNumber(10)
  $core.bool get addAdmins => $_getBF(9);
  @$pb.TagNumber(10)
  set addAdmins($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAddAdmins() => $_has(9);
  @$pb.TagNumber(10)
  void clearAddAdmins() => $_clearField(10);
}

/// Участник группы.
class ChatMember extends $pb.GeneratedMessage {
  factory ChatMember({
    $core.List<$core.int>? userID,
    ChatRole? role,
    $fixnum.Int64? joinedAt,
    $core.List<$core.int>? inviterUserID,
    ChatAdminRights? rights,
    $core.String? rank,
    $core.List<$core.int>? promotedByUserID,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (role != null) result.role = role;
    if (joinedAt != null) result.joinedAt = joinedAt;
    if (inviterUserID != null) result.inviterUserID = inviterUserID;
    if (rights != null) result.rights = rights;
    if (rank != null) result.rank = rank;
    if (promotedByUserID != null) result.promotedByUserID = promotedByUserID;
    return result;
  }

  ChatMember._();

  factory ChatMember.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatMember.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatMember',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aE<ChatRole>(2, _omitFieldNames ? '' : 'role', enumValues: ChatRole.values)
    ..aInt64(3, _omitFieldNames ? '' : 'joinedAt', protoName: 'joinedAt')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'inviterUserID', $pb.PbFieldType.OY, protoName: 'inviterUserID')
    ..aOM<ChatAdminRights>(5, _omitFieldNames ? '' : 'rights', subBuilder: ChatAdminRights.create)
    ..aOS(6, _omitFieldNames ? '' : 'rank')
    ..a<$core.List<$core.int>>(7, _omitFieldNames ? '' : 'promotedByUserID', $pb.PbFieldType.OY, protoName: 'promotedByUserID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMember clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMember copyWith(void Function(ChatMember) updates) => super.copyWith((message) => updates(message as ChatMember)) as ChatMember;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMember create() => ChatMember._();
  @$core.override
  ChatMember createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatMember getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatMember>(create);
  static ChatMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  ChatRole get role => $_getN(1);
  @$pb.TagNumber(2)
  set role(ChatRole value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get joinedAt => $_getI64(2);
  @$pb.TagNumber(3)
  set joinedAt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJoinedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearJoinedAt() => $_clearField(3);

  /// Кто добавил (пусто — создатель или вступил сам).
  @$pb.TagNumber(4)
  $core.List<$core.int> get inviterUserID => $_getN(3);
  @$pb.TagNumber(4)
  set inviterUserID($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInviterUserID() => $_has(3);
  @$pb.TagNumber(4)
  void clearInviterUserID() => $_clearField(4);

  /// ADMIN — его права (у OWNER — пусто: все); остальным — пусто.
  @$pb.TagNumber(5)
  ChatAdminRights get rights => $_getN(4);
  @$pb.TagNumber(5)
  set rights(ChatAdminRights value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRights() => $_has(4);
  @$pb.TagNumber(5)
  void clearRights() => $_clearField(5);
  @$pb.TagNumber(5)
  ChatAdminRights ensureRights() => $_ensure(4);

  /// «Звание» админа / владельца (подпись в пузыре справа от имени), ≤ 16
  /// символов. Пусто — клиент пишет «владелец» / «админ» по роли. Владелец
  /// задаёт себе сам (Chats.SetAdmin с userID = свой).
  @$pb.TagNumber(6)
  $core.String get rank => $_getSZ(5);
  @$pb.TagNumber(6)
  set rank($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRank() => $_has(5);
  @$pb.TagNumber(6)
  void clearRank() => $_clearField(6);

  /// Кто назначил админом (ADMIN) — для сведения в «Права админа».
  @$pb.TagNumber(7)
  $core.List<$core.int> get promotedByUserID => $_getN(6);
  @$pb.TagNumber(7)
  set promotedByUserID($core.List<$core.int> value) => $_setBytes(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPromotedByUserID() => $_has(6);
  @$pb.TagNumber(7)
  void clearPromotedByUserID() => $_clearField(7);
}

/// Заблокированный в группе (список «Заблокированные»).
class ChatBannedMember extends $pb.GeneratedMessage {
  factory ChatBannedMember({
    $core.List<$core.int>? userID,
    $core.List<$core.int>? bannedByUserID,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (bannedByUserID != null) result.bannedByUserID = bannedByUserID;
    if (date != null) result.date = date;
    return result;
  }

  ChatBannedMember._();

  factory ChatBannedMember.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatBannedMember.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatBannedMember',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'bannedByUserID', $pb.PbFieldType.OY, protoName: 'bannedByUserID')
    ..aInt64(3, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatBannedMember clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatBannedMember copyWith(void Function(ChatBannedMember) updates) =>
      super.copyWith((message) => updates(message as ChatBannedMember)) as ChatBannedMember;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatBannedMember create() => ChatBannedMember._();
  @$core.override
  ChatBannedMember createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatBannedMember getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatBannedMember>(create);
  static ChatBannedMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  /// Кто заблокировал и когда.
  @$pb.TagNumber(2)
  $core.List<$core.int> get bannedByUserID => $_getN(1);
  @$pb.TagNumber(2)
  set bannedByUserID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBannedByUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearBannedByUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get date => $_getI64(2);
  @$pb.TagNumber(3)
  set date($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDate() => $_clearField(3);
}

/// Служебное действие в группе (только от сервера; при отправке — отказ), как
/// messageAction* в Telegram. От того, кто сделал (fromUserID сообщения).
class MessageChatAction extends $pb.GeneratedMessage {
  factory MessageChatAction({
    MessageChatAction_Kind? kind,
    $core.Iterable<$core.List<$core.int>>? userIDs,
    $core.String? title,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (userIDs != null) result.userIDs.addAll(userIDs);
    if (title != null) result.title = title;
    return result;
  }

  MessageChatAction._();

  factory MessageChatAction.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageChatAction.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageChatAction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<MessageChatAction_Kind>(1, _omitFieldNames ? '' : 'kind', enumValues: MessageChatAction_Kind.values)
    ..p<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'userIDs', $pb.PbFieldType.PY, protoName: 'userIDs')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageChatAction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageChatAction copyWith(void Function(MessageChatAction) updates) =>
      super.copyWith((message) => updates(message as MessageChatAction)) as MessageChatAction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageChatAction create() => MessageChatAction._();
  @$core.override
  MessageChatAction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageChatAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageChatAction>(create);
  static MessageChatAction? _defaultInstance;

  @$pb.TagNumber(1)
  MessageChatAction_Kind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(MessageChatAction_Kind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.List<$core.int>> get userIDs => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);
}

/// Служебное уведомление системного аккаунта «Iperon» (только от сервера и
/// только в чат с SYSTEM_USER_ID = ObjectID 000000000000000000000001; при
/// отправке — отказ), как сервисные сообщения 777000 в Telegram. Текст
/// собирает клиент по kind и полям (локализация), sessionID — для кнопок
/// «Устройства» / «Это не я». План: docs/plans/system-notices.md (клиент).
class MessageSystemNotice extends $pb.GeneratedMessage {
  factory MessageSystemNotice({
    MessageSystemNotice_Kind? kind,
    $core.List<$core.int>? sessionID,
    $core.String? deviceModel,
    $core.int? os,
    $core.String? osVersion,
    $core.String? appVersion,
    $core.String? ip,
    $core.String? locationEnglish,
    $core.String? locationRussian,
    MessageSystemNotice_LoginMethod? loginMethod,
    $core.String? email,
    $core.String? passkeyLabel,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (sessionID != null) result.sessionID = sessionID;
    if (deviceModel != null) result.deviceModel = deviceModel;
    if (os != null) result.os = os;
    if (osVersion != null) result.osVersion = osVersion;
    if (appVersion != null) result.appVersion = appVersion;
    if (ip != null) result.ip = ip;
    if (locationEnglish != null) result.locationEnglish = locationEnglish;
    if (locationRussian != null) result.locationRussian = locationRussian;
    if (loginMethod != null) result.loginMethod = loginMethod;
    if (email != null) result.email = email;
    if (passkeyLabel != null) result.passkeyLabel = passkeyLabel;
    return result;
  }

  MessageSystemNotice._();

  factory MessageSystemNotice.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageSystemNotice.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageSystemNotice',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<MessageSystemNotice_Kind>(1, _omitFieldNames ? '' : 'kind', enumValues: MessageSystemNotice_Kind.values)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'sessionID', $pb.PbFieldType.OY, protoName: 'sessionID')
    ..aOS(3, _omitFieldNames ? '' : 'deviceModel', protoName: 'deviceModel')
    ..aI(4, _omitFieldNames ? '' : 'os')
    ..aOS(5, _omitFieldNames ? '' : 'osVersion', protoName: 'osVersion')
    ..aOS(6, _omitFieldNames ? '' : 'appVersion', protoName: 'appVersion')
    ..aOS(7, _omitFieldNames ? '' : 'ip')
    ..aOS(8, _omitFieldNames ? '' : 'locationEnglish', protoName: 'locationEnglish')
    ..aOS(9, _omitFieldNames ? '' : 'locationRussian', protoName: 'locationRussian')
    ..aE<MessageSystemNotice_LoginMethod>(10, _omitFieldNames ? '' : 'loginMethod',
        protoName: 'loginMethod', enumValues: MessageSystemNotice_LoginMethod.values)
    ..aOS(11, _omitFieldNames ? '' : 'email')
    ..aOS(12, _omitFieldNames ? '' : 'passkeyLabel', protoName: 'passkeyLabel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageSystemNotice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageSystemNotice copyWith(void Function(MessageSystemNotice) updates) =>
      super.copyWith((message) => updates(message as MessageSystemNotice)) as MessageSystemNotice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageSystemNotice create() => MessageSystemNotice._();
  @$core.override
  MessageSystemNotice createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageSystemNotice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageSystemNotice>(create);
  static MessageSystemNotice? _defaultInstance;

  @$pb.TagNumber(1)
  MessageSystemNotice_Kind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(MessageSystemNotice_Kind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  /// Сессия, которая это сделала (у NEW_LOGIN — новая сессия); пусто — не
  /// известна (CLOUD_PASSWORD_WRONG: сессии ещё нет).
  @$pb.TagNumber(2)
  $core.List<$core.int> get sessionID => $_getN(1);
  @$pb.TagNumber(2)
  set sessionID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionID() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionID() => $_clearField(2);

  /// Устройство и место — как в DeviceSessions.DeviceSession (NEW_LOGIN;
  /// у остальных — устройство сессии-инициатора, если она есть).
  @$pb.TagNumber(3)
  $core.String get deviceModel => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceModel($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceModel() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceModel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get os => $_getIZ(3);
  @$pb.TagNumber(4)
  set os($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOs() => $_has(3);
  @$pb.TagNumber(4)
  void clearOs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get osVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set osVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOsVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearOsVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get appVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set appVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAppVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearAppVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get ip => $_getSZ(6);
  @$pb.TagNumber(7)
  set ip($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIp() => $_has(6);
  @$pb.TagNumber(7)
  void clearIp() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get locationEnglish => $_getSZ(7);
  @$pb.TagNumber(8)
  set locationEnglish($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLocationEnglish() => $_has(7);
  @$pb.TagNumber(8)
  void clearLocationEnglish() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get locationRussian => $_getSZ(8);
  @$pb.TagNumber(9)
  set locationRussian($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLocationRussian() => $_has(8);
  @$pb.TagNumber(9)
  void clearLocationRussian() => $_clearField(9);

  /// Способ входа (NEW_LOGIN, CLOUD_PASSWORD_WRONG).
  @$pb.TagNumber(10)
  MessageSystemNotice_LoginMethod get loginMethod => $_getN(9);
  @$pb.TagNumber(10)
  set loginMethod(MessageSystemNotice_LoginMethod value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLoginMethod() => $_has(9);
  @$pb.TagNumber(10)
  void clearLoginMethod() => $_clearField(10);

  /// Маска почты (RECOVERY_EMAIL_SET), например «k***@yandex.ru».
  @$pb.TagNumber(11)
  $core.String get email => $_getSZ(10);
  @$pb.TagNumber(11)
  set email($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEmail() => $_has(10);
  @$pb.TagNumber(11)
  void clearEmail() => $_clearField(11);

  /// Название ключа доступа (PASSKEY_ADDED).
  @$pb.TagNumber(12)
  $core.String get passkeyLabel => $_getSZ(11);
  @$pb.TagNumber(12)
  set passkeyLabel($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPasskeyLabel() => $_has(11);
  @$pb.TagNumber(12)
  void clearPasskeyLabel() => $_clearField(12);
}

/// Разметка текста (как MessageEntity на клиенте, смещения — в UTF-16).
class MessageEntity extends $pb.GeneratedMessage {
  factory MessageEntity({
    MessageEntity_Type? type,
    $core.int? offset,
    $core.int? length,
    $core.String? url,
    $core.List<$core.int>? userID,
    $core.bool? expandable,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (offset != null) result.offset = offset;
    if (length != null) result.length = length;
    if (url != null) result.url = url;
    if (userID != null) result.userID = userID;
    if (expandable != null) result.expandable = expandable;
    return result;
  }

  MessageEntity._();

  factory MessageEntity.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageEntity.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageEntity',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<MessageEntity_Type>(1, _omitFieldNames ? '' : 'type', enumValues: MessageEntity_Type.values)
    ..aI(2, _omitFieldNames ? '' : 'offset')
    ..aI(3, _omitFieldNames ? '' : 'length')
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aOB(6, _omitFieldNames ? '' : 'expandable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageEntity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageEntity copyWith(void Function(MessageEntity) updates) =>
      super.copyWith((message) => updates(message as MessageEntity)) as MessageEntity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageEntity create() => MessageEntity._();
  @$core.override
  MessageEntity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageEntity>(create);
  static MessageEntity? _defaultInstance;

  @$pb.TagNumber(1)
  MessageEntity_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(MessageEntity_Type value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get offset => $_getIZ(1);
  @$pb.TagNumber(2)
  set offset($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get length => $_getIZ(2);
  @$pb.TagNumber(3)
  set length($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLength() => $_has(2);
  @$pb.TagNumber(3)
  void clearLength() => $_clearField(3);

  /// TEXT_URL — адрес; PRE — язык.
  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);

  /// MENTION_NAME — кого упомянули.
  @$pb.TagNumber(5)
  $core.List<$core.int> get userID => $_getN(4);
  @$pb.TagNumber(5)
  set userID($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUserID() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserID() => $_clearField(5);

  /// BLOCKQUOTE — свёрнутая цитата.
  @$pb.TagNumber(6)
  $core.bool get expandable => $_getBF(5);
  @$pb.TagNumber(6)
  set expandable($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpandable() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpandable() => $_clearField(6);
}

/// Файл вложения: загружен заранее через Upload (UPLOAD_CONFIRM → cdnID) —
/// самим отправителем, иначе отправка отклоняется (PERMISSION_DENIED).
class MessageMedia extends $pb.GeneratedMessage {
  factory MessageMedia({
    MessageKind? kind,
    $core.List<$core.int>? cdnID,
    $core.int? width,
    $core.int? height,
    $fixnum.Int64? size,
    $core.String? thumbhash,
    $core.bool? spoiler,
    $core.int? duration,
    $core.String? fileName,
    $core.String? mimeType,
    $core.List<$core.int>? waveform,
    $0.CDN? file,
    $core.List<$core.int>? thumbCdnID,
    $0.CDN? thumbFile,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (cdnID != null) result.cdnID = cdnID;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (size != null) result.size = size;
    if (thumbhash != null) result.thumbhash = thumbhash;
    if (spoiler != null) result.spoiler = spoiler;
    if (duration != null) result.duration = duration;
    if (fileName != null) result.fileName = fileName;
    if (mimeType != null) result.mimeType = mimeType;
    if (waveform != null) result.waveform = waveform;
    if (file != null) result.file = file;
    if (thumbCdnID != null) result.thumbCdnID = thumbCdnID;
    if (thumbFile != null) result.thumbFile = thumbFile;
    return result;
  }

  MessageMedia._();

  factory MessageMedia.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageMedia.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageMedia',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<MessageKind>(1, _omitFieldNames ? '' : 'kind', enumValues: MessageKind.values)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'cdnID', $pb.PbFieldType.OY, protoName: 'cdnID')
    ..aI(3, _omitFieldNames ? '' : 'width')
    ..aI(4, _omitFieldNames ? '' : 'height')
    ..aInt64(5, _omitFieldNames ? '' : 'size')
    ..aOS(6, _omitFieldNames ? '' : 'thumbhash')
    ..aOB(7, _omitFieldNames ? '' : 'spoiler')
    ..aI(8, _omitFieldNames ? '' : 'duration')
    ..aOS(9, _omitFieldNames ? '' : 'fileName', protoName: 'fileName')
    ..aOS(10, _omitFieldNames ? '' : 'mimeType', protoName: 'mimeType')
    ..a<$core.List<$core.int>>(11, _omitFieldNames ? '' : 'waveform', $pb.PbFieldType.OY)
    ..aOM<$0.CDN>(12, _omitFieldNames ? '' : 'file', subBuilder: $0.CDN.create)
    ..a<$core.List<$core.int>>(13, _omitFieldNames ? '' : 'thumbCdnID', $pb.PbFieldType.OY, protoName: 'thumbCdnID')
    ..aOM<$0.CDN>(14, _omitFieldNames ? '' : 'thumbFile', protoName: 'thumbFile', subBuilder: $0.CDN.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageMedia clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageMedia copyWith(void Function(MessageMedia) updates) =>
      super.copyWith((message) => updates(message as MessageMedia)) as MessageMedia;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageMedia create() => MessageMedia._();
  @$core.override
  MessageMedia createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageMedia getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageMedia>(create);
  static MessageMedia? _defaultInstance;

  @$pb.TagNumber(1)
  MessageKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(MessageKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get cdnID => $_getN(1);
  @$pb.TagNumber(2)
  set cdnID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCdnID() => $_has(1);
  @$pb.TagNumber(2)
  void clearCdnID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(2);
  @$pb.TagNumber(3)
  set width($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidth() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get size => $_getI64(4);
  @$pb.TagNumber(5)
  set size($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get thumbhash => $_getSZ(5);
  @$pb.TagNumber(6)
  set thumbhash($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasThumbhash() => $_has(5);
  @$pb.TagNumber(6)
  void clearThumbhash() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get spoiler => $_getBF(6);
  @$pb.TagNumber(7)
  set spoiler($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSpoiler() => $_has(6);
  @$pb.TagNumber(7)
  void clearSpoiler() => $_clearField(7);

  /// Видео / голосовое — секунд.
  @$pb.TagNumber(8)
  $core.int get duration => $_getIZ(7);
  @$pb.TagNumber(8)
  set duration($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDuration() => $_has(7);
  @$pb.TagNumber(8)
  void clearDuration() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get fileName => $_getSZ(8);
  @$pb.TagNumber(9)
  set fileName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFileName() => $_has(8);
  @$pb.TagNumber(9)
  void clearFileName() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get mimeType => $_getSZ(9);
  @$pb.TagNumber(10)
  set mimeType($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMimeType() => $_has(9);
  @$pb.TagNumber(10)
  void clearMimeType() => $_clearField(10);

  /// Голосовое — уровни громкости (0..255), Message.voiceWaveformBars столбцов.
  @$pb.TagNumber(11)
  $core.List<$core.int> get waveform => $_getN(10);
  @$pb.TagNumber(11)
  set waveform($core.List<$core.int> value) => $_setBytes(10, value);
  @$pb.TagNumber(11)
  $core.bool hasWaveform() => $_has(10);
  @$pb.TagNumber(11)
  void clearWaveform() => $_clearField(11);

  /// Как скачать: адрес, ключ, соль, хеш шифротекста. Заполняет сервер при
  /// выдаче сообщения (история, обновления, догон, ответ на отправку) — адрес
  /// собирается в момент выдачи (горячее/холодное хранилище). При отправке
  /// клиент поле не заполняет (сервер его отбрасывает); в БД не хранится.
  @$pb.TagNumber(12)
  $0.CDN get file => $_getN(11);
  @$pb.TagNumber(12)
  set file($0.CDN value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasFile() => $_has(11);
  @$pb.TagNumber(12)
  void clearFile() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.CDN ensureFile() => $_ensure(11);

  /// Видео — кадр-обложка (JPEG ~320 px), загружен так же, как сам файл, чтобы
  /// получатель видел превью до скачивания видео. thumbFile — как file.
  @$pb.TagNumber(13)
  $core.List<$core.int> get thumbCdnID => $_getN(12);
  @$pb.TagNumber(13)
  set thumbCdnID($core.List<$core.int> value) => $_setBytes(12, value);
  @$pb.TagNumber(13)
  $core.bool hasThumbCdnID() => $_has(12);
  @$pb.TagNumber(13)
  void clearThumbCdnID() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.CDN get thumbFile => $_getN(13);
  @$pb.TagNumber(14)
  set thumbFile($0.CDN value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasThumbFile() => $_has(13);
  @$pb.TagNumber(14)
  void clearThumbFile() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.CDN ensureThumbFile() => $_ensure(13);
}

/// Ответ на сообщение (того же чата).
class MessageReplyTo extends $pb.GeneratedMessage {
  factory MessageReplyTo({
    $fixnum.Int64? messageID,
    $core.String? quoteText,
    $core.Iterable<MessageEntity>? quoteEntities,
    $core.int? quoteOffset,
  }) {
    final result = create();
    if (messageID != null) result.messageID = messageID;
    if (quoteText != null) result.quoteText = quoteText;
    if (quoteEntities != null) result.quoteEntities.addAll(quoteEntities);
    if (quoteOffset != null) result.quoteOffset = quoteOffset;
    return result;
  }

  MessageReplyTo._();

  factory MessageReplyTo.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageReplyTo.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageReplyTo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aOS(2, _omitFieldNames ? '' : 'quoteText', protoName: 'quoteText')
    ..pPM<MessageEntity>(3, _omitFieldNames ? '' : 'quoteEntities', protoName: 'quoteEntities', subBuilder: MessageEntity.create)
    ..aI(4, _omitFieldNames ? '' : 'quoteOffset', protoName: 'quoteOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReplyTo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReplyTo copyWith(void Function(MessageReplyTo) updates) =>
      super.copyWith((message) => updates(message as MessageReplyTo)) as MessageReplyTo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageReplyTo create() => MessageReplyTo._();
  @$core.override
  MessageReplyTo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageReplyTo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageReplyTo>(create);
  static MessageReplyTo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get messageID => $_getI64(0);
  @$pb.TagNumber(1)
  set messageID($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessageID() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageID() => $_clearField(1);

  /// Цитата — выделенный фрагмент исходного сообщения.
  @$pb.TagNumber(2)
  $core.String get quoteText => $_getSZ(1);
  @$pb.TagNumber(2)
  set quoteText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuoteText() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuoteText() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<MessageEntity> get quoteEntities => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get quoteOffset => $_getIZ(3);
  @$pb.TagNumber(4)
  set quoteOffset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuoteOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuoteOffset() => $_clearField(4);
}

/// Пересланное: автор оригинала (fromName — его имя в профиле на момент
/// пересылки, на случай если профиль получателю не виден) и дата оригинала.
/// fromUserID пуст — автор запретил ссылку на свой аккаунт при пересылке
/// (PrivacySettings.forwards): только имя, без перехода в профиль.
/// Ставит только сервер (Messages.Send.forwardFrom); в обычной отправке
/// отбрасывается.
class MessageForward extends $pb.GeneratedMessage {
  factory MessageForward({
    $core.List<$core.int>? fromUserID,
    $core.String? fromName,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (fromName != null) result.fromName = fromName;
    if (date != null) result.date = date;
    return result;
  }

  MessageForward._();

  factory MessageForward.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageForward.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageForward',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'fromUserID', $pb.PbFieldType.OY, protoName: 'fromUserID')
    ..aOS(2, _omitFieldNames ? '' : 'fromName', protoName: 'fromName')
    ..aInt64(3, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageForward clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageForward copyWith(void Function(MessageForward) updates) =>
      super.copyWith((message) => updates(message as MessageForward)) as MessageForward;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageForward create() => MessageForward._();
  @$core.override
  MessageForward createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageForward getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageForward>(create);
  static MessageForward? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get fromUserID => $_getN(0);
  @$pb.TagNumber(1)
  set fromUserID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromName => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get date => $_getI64(2);
  @$pb.TagNumber(3)
  set date($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDate() => $_clearField(3);
}

/// Звонок — служебное сообщение в личном чате (как messageActionPhoneCall в
/// Telegram). Пишет сервер по завершении звонка, от звонящего; клиент его не
/// отправляет. Исход — с точки зрения звонка, подпись («Пропущенный» /
/// «Отменённый» …) клиент выбирает по направлению.
class MessageCall extends $pb.GeneratedMessage {
  factory MessageCall({
    $core.String? callID,
    $core.bool? video,
    MessageCall_Outcome? outcome,
    $core.int? duration,
  }) {
    final result = create();
    if (callID != null) result.callID = callID;
    if (video != null) result.video = video;
    if (outcome != null) result.outcome = outcome;
    if (duration != null) result.duration = duration;
    return result;
  }

  MessageCall._();

  factory MessageCall.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageCall.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageCall',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'callID', protoName: 'callID')
    ..aOB(2, _omitFieldNames ? '' : 'video')
    ..aE<MessageCall_Outcome>(3, _omitFieldNames ? '' : 'outcome', enumValues: MessageCall_Outcome.values)
    ..aI(4, _omitFieldNames ? '' : 'duration')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageCall clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageCall copyWith(void Function(MessageCall) updates) => super.copyWith((message) => updates(message as MessageCall)) as MessageCall;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageCall create() => MessageCall._();
  @$core.override
  MessageCall createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageCall getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageCall>(create);
  static MessageCall? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callID => $_getSZ(0);
  @$pb.TagNumber(1)
  set callID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get video => $_getBF(1);
  @$pb.TagNumber(2)
  set video($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVideo() => $_has(1);
  @$pb.TagNumber(2)
  void clearVideo() => $_clearField(2);

  @$pb.TagNumber(3)
  MessageCall_Outcome get outcome => $_getN(2);
  @$pb.TagNumber(3)
  set outcome(MessageCall_Outcome value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOutcome() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutcome() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get duration => $_getIZ(3);
  @$pb.TagNumber(4)
  set duration($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDuration() => $_has(3);
  @$pb.TagNumber(4)
  void clearDuration() => $_clearField(4);
}

/// Закрепление сообщения — служебное (как messageActionPinMessage в Telegram).
/// Пишет сервер, когда сообщение закрепили «у всех», от закрепившего; клиент
/// его не отправляет. messageID — закреплённое сообщение того же чата.
class MessagePin extends $pb.GeneratedMessage {
  factory MessagePin({
    $fixnum.Int64? messageID,
  }) {
    final result = create();
    if (messageID != null) result.messageID = messageID;
    return result;
  }

  MessagePin._();

  factory MessagePin.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessagePin.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessagePin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessagePin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessagePin copyWith(void Function(MessagePin) updates) => super.copyWith((message) => updates(message as MessagePin)) as MessagePin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessagePin create() => MessagePin._();
  @$core.override
  MessagePin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessagePin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessagePin>(create);
  static MessagePin? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get messageID => $_getI64(0);
  @$pb.TagNumber(1)
  set messageID($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessageID() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageID() => $_clearField(1);
}

/// Служебное «изменил автоудаление» (только от сервера; при отправке — отказ):
/// period — новый таймер чата в секундах (0 — выключил). Само не удаляется.
/// auto — таймер по умолчанию для новых чатов (настройка приватности
/// отправителя), а не изменение в этом чате.
class MessageTTLChanged extends $pb.GeneratedMessage {
  factory MessageTTLChanged({
    $core.int? period,
    $core.bool? auto,
  }) {
    final result = create();
    if (period != null) result.period = period;
    if (auto != null) result.auto = auto;
    return result;
  }

  MessageTTLChanged._();

  factory MessageTTLChanged.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageTTLChanged.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageTTLChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'period')
    ..aOB(2, _omitFieldNames ? '' : 'auto')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageTTLChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageTTLChanged copyWith(void Function(MessageTTLChanged) updates) =>
      super.copyWith((message) => updates(message as MessageTTLChanged)) as MessageTTLChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageTTLChanged create() => MessageTTLChanged._();
  @$core.override
  MessageTTLChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageTTLChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageTTLChanged>(create);
  static MessageTTLChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get period => $_getIZ(0);
  @$pb.TagNumber(1)
  set period($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeriod() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeriod() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get auto => $_getBF(1);
  @$pb.TagNumber(2)
  set auto($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAuto() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuto() => $_clearField(2);
}

/// Служебное «запретил / разрешил копирование» (только от сервера; как
/// messageActionNoForwardsToggle в Telegram): prevValue → newValue — защита
/// чата до и после. requestID — ответ на запрос MessageNoForwardsRequest
/// (messageID запроса; тогда prevValue может равняться newValue), 0 — без
/// запроса. Ответ на запрос гасит его (клиент — сам, по этому полю).
class MessageNoForwards extends $pb.GeneratedMessage {
  factory MessageNoForwards({
    $core.bool? prevValue,
    $core.bool? newValue,
    $fixnum.Int64? requestID,
  }) {
    final result = create();
    if (prevValue != null) result.prevValue = prevValue;
    if (newValue != null) result.newValue = newValue;
    if (requestID != null) result.requestID = requestID;
    return result;
  }

  MessageNoForwards._();

  factory MessageNoForwards.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageNoForwards.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageNoForwards',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'prevValue', protoName: 'prevValue')
    ..aOB(2, _omitFieldNames ? '' : 'newValue', protoName: 'newValue')
    ..aInt64(3, _omitFieldNames ? '' : 'requestID', protoName: 'requestID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageNoForwards clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageNoForwards copyWith(void Function(MessageNoForwards) updates) =>
      super.copyWith((message) => updates(message as MessageNoForwards)) as MessageNoForwards;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageNoForwards create() => MessageNoForwards._();
  @$core.override
  MessageNoForwards createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageNoForwards getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageNoForwards>(create);
  static MessageNoForwards? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get prevValue => $_getBF(0);
  @$pb.TagNumber(1)
  set prevValue($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrevValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrevValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get newValue => $_getBF(1);
  @$pb.TagNumber(2)
  set newValue($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get requestID => $_getI64(2);
  @$pb.TagNumber(3)
  set requestID($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestID() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestID() => $_clearField(3);
}

/// Служебное «просит разрешить копирование» (только от сервера; как
/// messageActionNoForwardsRequest): собеседник включившего хочет снять защиту.
/// Включивший отвечает Chats.SetNoForwards с requestID; без ответа запрос
/// гаснет через сутки (date + 24 ч) или когда пришёл MessageNoForwards с его
/// requestID.
class MessageNoForwardsRequest extends $pb.GeneratedMessage {
  factory MessageNoForwardsRequest({
    $core.bool? prevValue,
    $core.bool? newValue,
  }) {
    final result = create();
    if (prevValue != null) result.prevValue = prevValue;
    if (newValue != null) result.newValue = newValue;
    return result;
  }

  MessageNoForwardsRequest._();

  factory MessageNoForwardsRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageNoForwardsRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageNoForwardsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'prevValue', protoName: 'prevValue')
    ..aOB(2, _omitFieldNames ? '' : 'newValue', protoName: 'newValue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageNoForwardsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageNoForwardsRequest copyWith(void Function(MessageNoForwardsRequest) updates) =>
      super.copyWith((message) => updates(message as MessageNoForwardsRequest)) as MessageNoForwardsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageNoForwardsRequest create() => MessageNoForwardsRequest._();
  @$core.override
  MessageNoForwardsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageNoForwardsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageNoForwardsRequest>(create);
  static MessageNoForwardsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get prevValue => $_getBF(0);
  @$pb.TagNumber(1)
  set prevValue($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrevValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrevValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get newValue => $_getBF(1);
  @$pb.TagNumber(2)
  set newValue($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewValue() => $_clearField(2);
}

/// «Печатает…» / «отправляет фото…» — эфемерный сигнал по стриму
/// (MessageType CHAT_TYPING) в обе стороны, без ответа, без журнала pts и
/// без пушей. Клиент повторяет его, пока действие идёт (раз в ~5 с), и шлёт
/// CANCEL, когда закончил; у получателя запись живёт ~6 с, если её не продлили,
/// и снимается сразу новым сообщением от того же человека. Сервер проверяет
/// членство и «кто может писать», ограничивает частоту и рассылает остальным
/// участникам (не каналы, не «Избранное»).
class ChatTyping extends $pb.GeneratedMessage {
  factory ChatTyping({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? userID,
    ChatTyping_Action? action,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (userID != null) result.userID = userID;
    if (action != null) result.action = action;
    return result;
  }

  ChatTyping._();

  factory ChatTyping.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatTyping.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatTyping',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aE<ChatTyping_Action>(3, _omitFieldNames ? '' : 'action', enumValues: ChatTyping_Action.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatTyping clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatTyping copyWith(void Function(ChatTyping) updates) => super.copyWith((message) => updates(message as ChatTyping)) as ChatTyping;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatTyping create() => ChatTyping._();
  @$core.override
  ChatTyping createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatTyping getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatTyping>(create);
  static ChatTyping? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  /// Кто — заполняет сервер при рассылке (от клиента игнорируется).
  @$pb.TagNumber(2)
  $core.List<$core.int> get userID => $_getN(1);
  @$pb.TagNumber(2)
  set userID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  ChatTyping_Action get action => $_getN(2);
  @$pb.TagNumber(3)
  set action(ChatTyping_Action value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAction() => $_has(2);
  @$pb.TagNumber(3)
  void clearAction() => $_clearField(3);
}

/// Опрос / викторина (подэтап 3.4, только группы; в личном чате —
/// INVALID_ARGUMENT). Вопрос ≤ 255 символов, 2–10 вариантов по ≤ 100,
/// пояснение ≤ 200. Викторина — один верный вариант (correctOption), без
/// multiple. Верный вариант и пояснение сервер при выдаче из содержимого
/// УБИРАЕТ (correctOption = -1, explanation пусто) — они приходят в
/// PollResults тому, кто уже проголосовал, или всем после завершения.
/// Править опрос нельзя. Пересылка (только в группу; в личный чат —
/// INVALID_ARGUMENT «pollInvalid») — тот же опрос, как в Telegram: итоги у
/// копии — исходного опроса, голос в копии идёт в исходный (голосует тот, кто
/// видит пересланное), завершить копию нельзя (завершает автор оригинала).
class MessagePoll extends $pb.GeneratedMessage {
  factory MessagePoll({
    $core.String? question,
    $core.Iterable<$core.String>? options,
    $core.bool? anonymous,
    $core.bool? multiple,
    $core.bool? quiz,
    $core.int? correctOption,
    $core.String? explanation,
  }) {
    final result = create();
    if (question != null) result.question = question;
    if (options != null) result.options.addAll(options);
    if (anonymous != null) result.anonymous = anonymous;
    if (multiple != null) result.multiple = multiple;
    if (quiz != null) result.quiz = quiz;
    if (correctOption != null) result.correctOption = correctOption;
    if (explanation != null) result.explanation = explanation;
    return result;
  }

  MessagePoll._();

  factory MessagePoll.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessagePoll.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessagePoll',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'question')
    ..pPS(2, _omitFieldNames ? '' : 'options')
    ..aOB(3, _omitFieldNames ? '' : 'anonymous')
    ..aOB(4, _omitFieldNames ? '' : 'multiple')
    ..aOB(5, _omitFieldNames ? '' : 'quiz')
    ..aI(6, _omitFieldNames ? '' : 'correctOption', protoName: 'correctOption')
    ..aOS(7, _omitFieldNames ? '' : 'explanation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessagePoll clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessagePoll copyWith(void Function(MessagePoll) updates) => super.copyWith((message) => updates(message as MessagePoll)) as MessagePoll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessagePoll create() => MessagePoll._();
  @$core.override
  MessagePoll createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessagePoll getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessagePoll>(create);
  static MessagePoll? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get question => $_getSZ(0);
  @$pb.TagNumber(1)
  set question($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuestion() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuestion() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get options => $_getList(1);

  /// Анонимный: кто как голосовал, не видно (PollVoters — отказ).
  @$pb.TagNumber(3)
  $core.bool get anonymous => $_getBF(2);
  @$pb.TagNumber(3)
  set anonymous($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAnonymous() => $_has(2);
  @$pb.TagNumber(3)
  void clearAnonymous() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get multiple => $_getBF(3);
  @$pb.TagNumber(4)
  set multiple($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMultiple() => $_has(3);
  @$pb.TagNumber(4)
  void clearMultiple() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get quiz => $_getBF(4);
  @$pb.TagNumber(5)
  set quiz($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuiz() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuiz() => $_clearField(5);

  /// Викторина — индекс верного варианта (при отправке обязателен); при
  /// выдаче — всегда -1 (см. PollResults.correctOption).
  @$pb.TagNumber(6)
  $core.int get correctOption => $_getIZ(5);
  @$pb.TagNumber(6)
  set correctOption($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCorrectOption() => $_has(5);
  @$pb.TagNumber(6)
  void clearCorrectOption() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get explanation => $_getSZ(6);
  @$pb.TagNumber(7)
  set explanation($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExplanation() => $_has(6);
  @$pb.TagNumber(7)
  void clearExplanation() => $_clearField(7);
}

/// Итоги опроса глазами смотрящего (ChatMessage.poll, ответ VotePoll,
/// Update.MessagePollChanged). chosen — мой выбор (в общем обновлении журнала
/// чата не заполняется — см. MessagePollChanged.actorUserID).
class PollResults extends $pb.GeneratedMessage {
  factory PollResults({
    $core.Iterable<$core.int>? votes,
    $core.Iterable<$core.int>? chosen,
    $core.int? totalVoters,
    $core.bool? closed,
    $core.int? correctOption,
    $core.String? explanation,
  }) {
    final result = create();
    if (votes != null) result.votes.addAll(votes);
    if (chosen != null) result.chosen.addAll(chosen);
    if (totalVoters != null) result.totalVoters = totalVoters;
    if (closed != null) result.closed = closed;
    if (correctOption != null) result.correctOption = correctOption;
    if (explanation != null) result.explanation = explanation;
    return result;
  }

  PollResults._();

  factory PollResults.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PollResults.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PollResults',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.int>(1, _omitFieldNames ? '' : 'votes', $pb.PbFieldType.K3)
    ..p<$core.int>(2, _omitFieldNames ? '' : 'chosen', $pb.PbFieldType.K3)
    ..aI(3, _omitFieldNames ? '' : 'totalVoters', protoName: 'totalVoters')
    ..aOB(4, _omitFieldNames ? '' : 'closed')
    ..aI(5, _omitFieldNames ? '' : 'correctOption', protoName: 'correctOption')
    ..aOS(6, _omitFieldNames ? '' : 'explanation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollResults clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollResults copyWith(void Function(PollResults) updates) => super.copyWith((message) => updates(message as PollResults)) as PollResults;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PollResults create() => PollResults._();
  @$core.override
  PollResults createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PollResults getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PollResults>(create);
  static PollResults? _defaultInstance;

  /// По вариантам — сколько выбрало; chosen — индексы моих вариантов.
  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get votes => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.int> get chosen => $_getList(1);

  /// Проголосовавших людей (у multiple человек считается один раз).
  @$pb.TagNumber(3)
  $core.int get totalVoters => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalVoters($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalVoters() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalVoters() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get closed => $_getBF(3);
  @$pb.TagNumber(4)
  set closed($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClosed() => $_has(3);
  @$pb.TagNumber(4)
  void clearClosed() => $_clearField(4);

  /// Викторина: верный вариант и пояснение — мне после моего голоса или всем
  /// после завершения; иначе -1 и пусто.
  @$pb.TagNumber(5)
  $core.int get correctOption => $_getIZ(4);
  @$pb.TagNumber(5)
  set correctOption($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCorrectOption() => $_has(4);
  @$pb.TagNumber(5)
  void clearCorrectOption() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get explanation => $_getSZ(5);
  @$pb.TagNumber(6)
  set explanation($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExplanation() => $_has(5);
  @$pb.TagNumber(6)
  void clearExplanation() => $_clearField(6);
}

/// Содержимое сообщения. На сервере хранится ОДНИМ зашифрованным блобом
/// (messages.contentEncrypted, crypto.Encryptor) — открыты только chatID,
/// messageID, отправитель, дата и флаги.
class MessageContent extends $pb.GeneratedMessage {
  factory MessageContent({
    $core.String? text,
    $core.Iterable<MessageEntity>? entities,
    $core.Iterable<MessageMedia>? media,
    MessageReplyTo? replyTo,
    MessageForward? forward,
    $core.bool? noLinkPreview,
    MessageCall? call,
    MessagePin? pin,
    MessageTTLChanged? ttlChanged,
    MessageNoForwards? noForwards,
    MessageNoForwardsRequest? noForwardsRequest,
    MessageChatAction? chatAction,
    MessagePoll? poll,
    MessageSystemNotice? systemNotice,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (entities != null) result.entities.addAll(entities);
    if (media != null) result.media.addAll(media);
    if (replyTo != null) result.replyTo = replyTo;
    if (forward != null) result.forward = forward;
    if (noLinkPreview != null) result.noLinkPreview = noLinkPreview;
    if (call != null) result.call = call;
    if (pin != null) result.pin = pin;
    if (ttlChanged != null) result.ttlChanged = ttlChanged;
    if (noForwards != null) result.noForwards = noForwards;
    if (noForwardsRequest != null) result.noForwardsRequest = noForwardsRequest;
    if (chatAction != null) result.chatAction = chatAction;
    if (poll != null) result.poll = poll;
    if (systemNotice != null) result.systemNotice = systemNotice;
    return result;
  }

  MessageContent._();

  factory MessageContent.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageContent.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageContent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..pPM<MessageEntity>(2, _omitFieldNames ? '' : 'entities', subBuilder: MessageEntity.create)
    ..pPM<MessageMedia>(3, _omitFieldNames ? '' : 'media', subBuilder: MessageMedia.create)
    ..aOM<MessageReplyTo>(4, _omitFieldNames ? '' : 'replyTo', protoName: 'replyTo', subBuilder: MessageReplyTo.create)
    ..aOM<MessageForward>(5, _omitFieldNames ? '' : 'forward', subBuilder: MessageForward.create)
    ..aOB(6, _omitFieldNames ? '' : 'noLinkPreview', protoName: 'noLinkPreview')
    ..aOM<MessageCall>(7, _omitFieldNames ? '' : 'call', subBuilder: MessageCall.create)
    ..aOM<MessagePin>(8, _omitFieldNames ? '' : 'pin', subBuilder: MessagePin.create)
    ..aOM<MessageTTLChanged>(9, _omitFieldNames ? '' : 'ttlChanged', protoName: 'ttlChanged', subBuilder: MessageTTLChanged.create)
    ..aOM<MessageNoForwards>(10, _omitFieldNames ? '' : 'noForwards', protoName: 'noForwards', subBuilder: MessageNoForwards.create)
    ..aOM<MessageNoForwardsRequest>(11, _omitFieldNames ? '' : 'noForwardsRequest',
        protoName: 'noForwardsRequest', subBuilder: MessageNoForwardsRequest.create)
    ..aOM<MessageChatAction>(12, _omitFieldNames ? '' : 'chatAction', protoName: 'chatAction', subBuilder: MessageChatAction.create)
    ..aOM<MessagePoll>(13, _omitFieldNames ? '' : 'poll', subBuilder: MessagePoll.create)
    ..aOM<MessageSystemNotice>(14, _omitFieldNames ? '' : 'systemNotice', protoName: 'systemNotice', subBuilder: MessageSystemNotice.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageContent copyWith(void Function(MessageContent) updates) =>
      super.copyWith((message) => updates(message as MessageContent)) as MessageContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageContent create() => MessageContent._();
  @$core.override
  MessageContent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageContent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageContent>(create);
  static MessageContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<MessageEntity> get entities => $_getList(1);

  /// Альбом — несколько; один файл / голосовое — один элемент.
  @$pb.TagNumber(3)
  $pb.PbList<MessageMedia> get media => $_getList(2);

  @$pb.TagNumber(4)
  MessageReplyTo get replyTo => $_getN(3);
  @$pb.TagNumber(4)
  set replyTo(MessageReplyTo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasReplyTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearReplyTo() => $_clearField(4);
  @$pb.TagNumber(4)
  MessageReplyTo ensureReplyTo() => $_ensure(3);

  @$pb.TagNumber(5)
  MessageForward get forward => $_getN(4);
  @$pb.TagNumber(5)
  set forward(MessageForward value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasForward() => $_has(4);
  @$pb.TagNumber(5)
  void clearForward() => $_clearField(5);
  @$pb.TagNumber(5)
  MessageForward ensureForward() => $_ensure(4);

  /// true — отправитель убрал превью ссылки.
  @$pb.TagNumber(6)
  $core.bool get noLinkPreview => $_getBF(5);
  @$pb.TagNumber(6)
  set noLinkPreview($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNoLinkPreview() => $_has(5);
  @$pb.TagNumber(6)
  void clearNoLinkPreview() => $_clearField(6);

  /// Служебное «звонок» (только от сервера; при отправке клиентом — отказ).
  @$pb.TagNumber(7)
  MessageCall get call => $_getN(6);
  @$pb.TagNumber(7)
  set call(MessageCall value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCall() => $_has(6);
  @$pb.TagNumber(7)
  void clearCall() => $_clearField(7);
  @$pb.TagNumber(7)
  MessageCall ensureCall() => $_ensure(6);

  /// Служебное «закрепил сообщение» (только от сервера; при отправке — отказ).
  @$pb.TagNumber(8)
  MessagePin get pin => $_getN(7);
  @$pb.TagNumber(8)
  set pin(MessagePin value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPin() => $_has(7);
  @$pb.TagNumber(8)
  void clearPin() => $_clearField(8);
  @$pb.TagNumber(8)
  MessagePin ensurePin() => $_ensure(7);

  /// Служебное «изменил автоудаление» (только от сервера; при отправке — отказ).
  @$pb.TagNumber(9)
  MessageTTLChanged get ttlChanged => $_getN(8);
  @$pb.TagNumber(9)
  set ttlChanged(MessageTTLChanged value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasTtlChanged() => $_has(8);
  @$pb.TagNumber(9)
  void clearTtlChanged() => $_clearField(9);
  @$pb.TagNumber(9)
  MessageTTLChanged ensureTtlChanged() => $_ensure(8);

  /// Служебные «запретил / разрешил копирование» и «просит разрешить» (только
  /// от сервера; при отправке — отказ).
  @$pb.TagNumber(10)
  MessageNoForwards get noForwards => $_getN(9);
  @$pb.TagNumber(10)
  set noForwards(MessageNoForwards value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasNoForwards() => $_has(9);
  @$pb.TagNumber(10)
  void clearNoForwards() => $_clearField(10);
  @$pb.TagNumber(10)
  MessageNoForwards ensureNoForwards() => $_ensure(9);

  @$pb.TagNumber(11)
  MessageNoForwardsRequest get noForwardsRequest => $_getN(10);
  @$pb.TagNumber(11)
  set noForwardsRequest(MessageNoForwardsRequest value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasNoForwardsRequest() => $_has(10);
  @$pb.TagNumber(11)
  void clearNoForwardsRequest() => $_clearField(11);
  @$pb.TagNumber(11)
  MessageNoForwardsRequest ensureNoForwardsRequest() => $_ensure(10);

  /// Служебное действие в группе (только от сервера; при отправке — отказ).
  @$pb.TagNumber(12)
  MessageChatAction get chatAction => $_getN(11);
  @$pb.TagNumber(12)
  set chatAction(MessageChatAction value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasChatAction() => $_has(11);
  @$pb.TagNumber(12)
  void clearChatAction() => $_clearField(12);
  @$pb.TagNumber(12)
  MessageChatAction ensureChatAction() => $_ensure(11);

  /// Опрос (группа). Текст при этом пуст.
  @$pb.TagNumber(13)
  MessagePoll get poll => $_getN(12);
  @$pb.TagNumber(13)
  set poll(MessagePoll value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasPoll() => $_has(12);
  @$pb.TagNumber(13)
  void clearPoll() => $_clearField(13);
  @$pb.TagNumber(13)
  MessagePoll ensurePoll() => $_ensure(12);

  /// Уведомление системного аккаунта (только от сервера; при отправке — отказ).
  @$pb.TagNumber(14)
  MessageSystemNotice get systemNotice => $_getN(13);
  @$pb.TagNumber(14)
  set systemNotice(MessageSystemNotice value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSystemNotice() => $_has(13);
  @$pb.TagNumber(14)
  void clearSystemNotice() => $_clearField(14);
  @$pb.TagNumber(14)
  MessageSystemNotice ensureSystemNotice() => $_ensure(13);
}

/// Реакция участника на сообщение: кто, каким эмодзи и когда поставил.
class MessageReaction extends $pb.GeneratedMessage {
  factory MessageReaction({
    $core.List<$core.int>? userID,
    $core.String? emoji,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (emoji != null) result.emoji = emoji;
    if (date != null) result.date = date;
    return result;
  }

  MessageReaction._();

  factory MessageReaction.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageReaction.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageReaction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'emoji')
    ..aInt64(3, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReaction copyWith(void Function(MessageReaction) updates) =>
      super.copyWith((message) => updates(message as MessageReaction)) as MessageReaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageReaction create() => MessageReaction._();
  @$core.override
  MessageReaction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageReaction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageReaction>(create);
  static MessageReaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get emoji => $_getSZ(1);
  @$pb.TagNumber(2)
  set emoji($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmoji() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmoji() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get date => $_getI64(2);
  @$pb.TagNumber(3)
  set date($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDate() => $_clearField(3);
}

/// Счётчик реакции в группе: эмодзи, сколько поставили и (глазами
/// смотрящего) порядок моей постановки — 1, 2, 3; 0 — не моя (в общем
/// обновлении журнала чата всегда 0 — см. MessageReactionsChanged.actorUserID).
class ReactionCount extends $pb.GeneratedMessage {
  factory ReactionCount({
    $core.String? emoji,
    $core.int? count,
    $core.int? chosenOrder,
  }) {
    final result = create();
    if (emoji != null) result.emoji = emoji;
    if (count != null) result.count = count;
    if (chosenOrder != null) result.chosenOrder = chosenOrder;
    return result;
  }

  ReactionCount._();

  factory ReactionCount.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReactionCount.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReactionCount',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'emoji')
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..aI(3, _omitFieldNames ? '' : 'chosenOrder', protoName: 'chosenOrder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReactionCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReactionCount copyWith(void Function(ReactionCount) updates) =>
      super.copyWith((message) => updates(message as ReactionCount)) as ReactionCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReactionCount create() => ReactionCount._();
  @$core.override
  ReactionCount createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReactionCount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReactionCount>(create);
  static ReactionCount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get emoji => $_getSZ(0);
  @$pb.TagNumber(1)
  set emoji($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmoji() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmoji() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get chosenOrder => $_getIZ(2);
  @$pb.TagNumber(3)
  set chosenOrder($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChosenOrder() => $_has(2);
  @$pb.TagNumber(3)
  void clearChosenOrder() => $_clearField(3);
}

/// Реакции на сообщение (как MessageReactions в Telegram). Личный чат —
/// полный список reactions, от ранних к поздним: чипы и «мои» клиент
/// собирает сам. Группа — только counts (по первой постановке эмодзи), кто
/// поставил — Messages.ReactionsList по запросу.
class MessageReactions extends $pb.GeneratedMessage {
  factory MessageReactions({
    $core.Iterable<MessageReaction>? reactions,
    $core.Iterable<ReactionCount>? counts,
  }) {
    final result = create();
    if (reactions != null) result.reactions.addAll(reactions);
    if (counts != null) result.counts.addAll(counts);
    return result;
  }

  MessageReactions._();

  factory MessageReactions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageReactions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageReactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<MessageReaction>(1, _omitFieldNames ? '' : 'reactions', subBuilder: MessageReaction.create)
    ..pPM<ReactionCount>(2, _omitFieldNames ? '' : 'counts', subBuilder: ReactionCount.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReactions copyWith(void Function(MessageReactions) updates) =>
      super.copyWith((message) => updates(message as MessageReactions)) as MessageReactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageReactions create() => MessageReactions._();
  @$core.override
  MessageReactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageReactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageReactions>(create);
  static MessageReactions? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MessageReaction> get reactions => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<ReactionCount> get counts => $_getList(1);
}

/// Сообщение «глазами получателя»: outgoing = fromUserID == я; прочитано ли
/// исходящее — сравнением messageID с Dialog.readOutboxMaxID.
class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.List<$core.int>? fromUserID,
    $fixnum.Int64? date,
    $fixnum.Int64? editDate,
    MessageContent? content,
    $core.bool? mediaUnread,
    $core.bool? silent,
    $fixnum.Int64? randomID,
    MessageReactions? reactions,
    $core.bool? reactionsUnread,
    $core.int? ttlPeriod,
    $core.bool? mentionUnread,
    PollResults? poll,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (date != null) result.date = date;
    if (editDate != null) result.editDate = editDate;
    if (content != null) result.content = content;
    if (mediaUnread != null) result.mediaUnread = mediaUnread;
    if (silent != null) result.silent = silent;
    if (randomID != null) result.randomID = randomID;
    if (reactions != null) result.reactions = reactions;
    if (reactionsUnread != null) result.reactionsUnread = reactionsUnread;
    if (ttlPeriod != null) result.ttlPeriod = ttlPeriod;
    if (mentionUnread != null) result.mentionUnread = mentionUnread;
    if (poll != null) result.poll = poll;
    return result;
  }

  ChatMessage._();

  factory ChatMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'fromUserID', $pb.PbFieldType.OY, protoName: 'fromUserID')
    ..aInt64(4, _omitFieldNames ? '' : 'date')
    ..aInt64(5, _omitFieldNames ? '' : 'editDate', protoName: 'editDate')
    ..aOM<MessageContent>(6, _omitFieldNames ? '' : 'content', subBuilder: MessageContent.create)
    ..aOB(7, _omitFieldNames ? '' : 'mediaUnread', protoName: 'mediaUnread')
    ..aOB(8, _omitFieldNames ? '' : 'silent')
    ..aInt64(9, _omitFieldNames ? '' : 'randomID', protoName: 'randomID')
    ..aOM<MessageReactions>(10, _omitFieldNames ? '' : 'reactions', subBuilder: MessageReactions.create)
    ..aOB(11, _omitFieldNames ? '' : 'reactionsUnread', protoName: 'reactionsUnread')
    ..aI(12, _omitFieldNames ? '' : 'ttlPeriod', protoName: 'ttlPeriod')
    ..aOB(13, _omitFieldNames ? '' : 'mentionUnread', protoName: 'mentionUnread')
    ..aOM<PollResults>(14, _omitFieldNames ? '' : 'poll', subBuilder: PollResults.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage copyWith(void Function(ChatMessage) updates) => super.copyWith((message) => updates(message as ChatMessage)) as ChatMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  @$core.override
  ChatMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get fromUserID => $_getN(2);
  @$pb.TagNumber(3)
  set fromUserID($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromUserID() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromUserID() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get date => $_getI64(3);
  @$pb.TagNumber(4)
  set date($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearDate() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get editDate => $_getI64(4);
  @$pb.TagNumber(5)
  set editDate($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEditDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearEditDate() => $_clearField(5);

  @$pb.TagNumber(6)
  MessageContent get content => $_getN(5);
  @$pb.TagNumber(6)
  set content(MessageContent value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => $_clearField(6);
  @$pb.TagNumber(6)
  MessageContent ensureContent() => $_ensure(5);

  /// Голосовое ещё не прослушано получателем (точка у длительности).
  @$pb.TagNumber(7)
  $core.bool get mediaUnread => $_getBF(6);
  @$pb.TagNumber(7)
  set mediaUnread($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMediaUnread() => $_has(6);
  @$pb.TagNumber(7)
  void clearMediaUnread() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get silent => $_getBF(7);
  @$pb.TagNumber(8)
  set silent($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSilent() => $_has(7);
  @$pb.TagNumber(8)
  void clearSilent() => $_clearField(8);

  /// Отправитель задал при отправке (идемпотентность, сопоставление с outbox).
  @$pb.TagNumber(9)
  $fixnum.Int64 get randomID => $_getI64(8);
  @$pb.TagNumber(9)
  set randomID($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRandomID() => $_has(8);
  @$pb.TagNumber(9)
  void clearRandomID() => $_clearField(9);

  /// Реакции (нет — пусто). Текущие на момент выдачи.
  @$pb.TagNumber(10)
  MessageReactions get reactions => $_getN(9);
  @$pb.TagNumber(10)
  set reactions(MessageReactions value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReactions() => $_has(9);
  @$pb.TagNumber(10)
  void clearReactions() => $_clearField(10);
  @$pb.TagNumber(10)
  MessageReactions ensureReactions() => $_ensure(9);

  /// Автор ещё не видел новые реакции собеседника на это сообщение (значимо
  /// только для автора: у получателя — игнорировать).
  @$pb.TagNumber(11)
  $core.bool get reactionsUnread => $_getBF(10);
  @$pb.TagNumber(11)
  set reactionsUnread($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReactionsUnread() => $_has(10);
  @$pb.TagNumber(11)
  void clearReactionsUnread() => $_clearField(11);

  /// Автоудаление (как ttl_period в Telegram): в date + ttlPeriod (секунды)
  /// сервер удалит сообщение у всех, клиент удаляет его у себя в тот же момент
  /// сам (и без сети). 0 — не удаляется. Таймер чата на момент отправки.
  @$pb.TagNumber(12)
  $core.int get ttlPeriod => $_getIZ(11);
  @$pb.TagNumber(12)
  set ttlPeriod($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTtlPeriod() => $_has(11);
  @$pb.TagNumber(12)
  void clearTtlPeriod() => $_clearField(12);

  /// Группа: сообщение упоминает меня (@username, по имени или ответ на моё) и
  /// я его ещё не видел — снимается Messages.ReadMentions. Заполняется глазами
  /// запросившего (History / Get / UnreadMentions); в общем обновлении журнала
  /// чата — false (новые упоминания приходят Update.mentions).
  @$pb.TagNumber(13)
  $core.bool get mentionUnread => $_getBF(12);
  @$pb.TagNumber(13)
  set mentionUnread($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasMentionUnread() => $_has(12);
  @$pb.TagNumber(13)
  void clearMentionUnread() => $_clearField(13);

  /// Опрос: итоги глазами запросившего (в общем обновлении журнала чата —
  /// без chosen и без верного ответа).
  @$pb.TagNumber(14)
  PollResults get poll => $_getN(13);
  @$pb.TagNumber(14)
  set poll(PollResults value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasPoll() => $_has(13);
  @$pb.TagNumber(14)
  void clearPoll() => $_clearField(14);
  @$pb.TagNumber(14)
  PollResults ensurePoll() => $_ensure(13);
}

/// Диалог пользователя: общий чат + моё состояние в нём.
class Dialog extends $pb.GeneratedMessage {
  factory Dialog({
    $core.List<$core.int>? chatID,
    ChatType? type,
    $core.List<$core.int>? peerUserID,
    ChatMessage? topMessage,
    $fixnum.Int64? readInboxMaxID,
    $fixnum.Int64? readOutboxMaxID,
    $core.int? unreadCount,
    $core.bool? pinned,
    $core.bool? archived,
    $core.bool? markedUnread,
    $fixnum.Int64? mutedUntil,
    $fixnum.Int64? createdAt,
    $core.int? unreadReactionsCount,
    $core.String? draft,
    $fixnum.Int64? draftDate,
    $core.int? ttlPeriod,
    $core.bool? noForwards,
    $core.bool? noForwardsMine,
    ChatInfo? chat,
    ChatRole? role,
    ChatAdminRights? rights,
    $core.String? rank,
    $core.String? inviteCode,
    $core.int? pendingRequests,
    $core.int? unreadMentionsCount,
    $fixnum.Int64? slowModeUntil,
    $fixnum.Int64? joinedAt,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (type != null) result.type = type;
    if (peerUserID != null) result.peerUserID = peerUserID;
    if (topMessage != null) result.topMessage = topMessage;
    if (readInboxMaxID != null) result.readInboxMaxID = readInboxMaxID;
    if (readOutboxMaxID != null) result.readOutboxMaxID = readOutboxMaxID;
    if (unreadCount != null) result.unreadCount = unreadCount;
    if (pinned != null) result.pinned = pinned;
    if (archived != null) result.archived = archived;
    if (markedUnread != null) result.markedUnread = markedUnread;
    if (mutedUntil != null) result.mutedUntil = mutedUntil;
    if (createdAt != null) result.createdAt = createdAt;
    if (unreadReactionsCount != null) result.unreadReactionsCount = unreadReactionsCount;
    if (draft != null) result.draft = draft;
    if (draftDate != null) result.draftDate = draftDate;
    if (ttlPeriod != null) result.ttlPeriod = ttlPeriod;
    if (noForwards != null) result.noForwards = noForwards;
    if (noForwardsMine != null) result.noForwardsMine = noForwardsMine;
    if (chat != null) result.chat = chat;
    if (role != null) result.role = role;
    if (rights != null) result.rights = rights;
    if (rank != null) result.rank = rank;
    if (inviteCode != null) result.inviteCode = inviteCode;
    if (pendingRequests != null) result.pendingRequests = pendingRequests;
    if (unreadMentionsCount != null) result.unreadMentionsCount = unreadMentionsCount;
    if (slowModeUntil != null) result.slowModeUntil = slowModeUntil;
    if (joinedAt != null) result.joinedAt = joinedAt;
    return result;
  }

  Dialog._();

  factory Dialog.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Dialog.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Dialog',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aE<ChatType>(2, _omitFieldNames ? '' : 'type', enumValues: ChatType.values)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'peerUserID', $pb.PbFieldType.OY, protoName: 'peerUserID')
    ..aOM<ChatMessage>(4, _omitFieldNames ? '' : 'topMessage', protoName: 'topMessage', subBuilder: ChatMessage.create)
    ..aInt64(5, _omitFieldNames ? '' : 'readInboxMaxID', protoName: 'readInboxMaxID')
    ..aInt64(6, _omitFieldNames ? '' : 'readOutboxMaxID', protoName: 'readOutboxMaxID')
    ..aI(7, _omitFieldNames ? '' : 'unreadCount', protoName: 'unreadCount')
    ..aOB(8, _omitFieldNames ? '' : 'pinned')
    ..aOB(9, _omitFieldNames ? '' : 'archived')
    ..aOB(10, _omitFieldNames ? '' : 'markedUnread', protoName: 'markedUnread')
    ..aInt64(11, _omitFieldNames ? '' : 'mutedUntil', protoName: 'mutedUntil')
    ..aInt64(12, _omitFieldNames ? '' : 'createdAt', protoName: 'createdAt')
    ..aI(13, _omitFieldNames ? '' : 'unreadReactionsCount', protoName: 'unreadReactionsCount')
    ..aOS(14, _omitFieldNames ? '' : 'draft')
    ..aInt64(15, _omitFieldNames ? '' : 'draftDate', protoName: 'draftDate')
    ..aI(16, _omitFieldNames ? '' : 'ttlPeriod', protoName: 'ttlPeriod')
    ..aOB(17, _omitFieldNames ? '' : 'noForwards', protoName: 'noForwards')
    ..aOB(18, _omitFieldNames ? '' : 'noForwardsMine', protoName: 'noForwardsMine')
    ..aOM<ChatInfo>(19, _omitFieldNames ? '' : 'chat', subBuilder: ChatInfo.create)
    ..aE<ChatRole>(20, _omitFieldNames ? '' : 'role', enumValues: ChatRole.values)
    ..aOM<ChatAdminRights>(21, _omitFieldNames ? '' : 'rights', subBuilder: ChatAdminRights.create)
    ..aOS(22, _omitFieldNames ? '' : 'rank')
    ..aOS(23, _omitFieldNames ? '' : 'inviteCode', protoName: 'inviteCode')
    ..aI(24, _omitFieldNames ? '' : 'pendingRequests', protoName: 'pendingRequests')
    ..aI(25, _omitFieldNames ? '' : 'unreadMentionsCount', protoName: 'unreadMentionsCount')
    ..aInt64(26, _omitFieldNames ? '' : 'slowModeUntil', protoName: 'slowModeUntil')
    ..aInt64(27, _omitFieldNames ? '' : 'joinedAt', protoName: 'joinedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dialog clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dialog copyWith(void Function(Dialog) updates) => super.copyWith((message) => updates(message as Dialog)) as Dialog;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Dialog create() => Dialog._();
  @$core.override
  Dialog createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Dialog getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Dialog>(create);
  static Dialog? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  ChatType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(ChatType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  /// Личный чат — собеседник (у «Избранного» — я сам).
  @$pb.TagNumber(3)
  $core.List<$core.int> get peerUserID => $_getN(2);
  @$pb.TagNumber(3)
  set peerUserID($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPeerUserID() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeerUserID() => $_clearField(3);

  /// Последнее сообщение (нет — пустой чат).
  @$pb.TagNumber(4)
  ChatMessage get topMessage => $_getN(3);
  @$pb.TagNumber(4)
  set topMessage(ChatMessage value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTopMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearTopMessage() => $_clearField(4);
  @$pb.TagNumber(4)
  ChatMessage ensureTopMessage() => $_ensure(3);

  /// До какого messageID я прочитал входящие.
  @$pb.TagNumber(5)
  $fixnum.Int64 get readInboxMaxID => $_getI64(4);
  @$pb.TagNumber(5)
  set readInboxMaxID($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReadInboxMaxID() => $_has(4);
  @$pb.TagNumber(5)
  void clearReadInboxMaxID() => $_clearField(5);

  /// До какого messageID собеседник прочитал мои.
  @$pb.TagNumber(6)
  $fixnum.Int64 get readOutboxMaxID => $_getI64(5);
  @$pb.TagNumber(6)
  set readOutboxMaxID($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReadOutboxMaxID() => $_has(5);
  @$pb.TagNumber(6)
  void clearReadOutboxMaxID() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get unreadCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set unreadCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUnreadCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnreadCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get pinned => $_getBF(7);
  @$pb.TagNumber(8)
  set pinned($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPinned() => $_has(7);
  @$pb.TagNumber(8)
  void clearPinned() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get archived => $_getBF(8);
  @$pb.TagNumber(9)
  set archived($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasArchived() => $_has(8);
  @$pb.TagNumber(9)
  void clearArchived() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get markedUnread => $_getBF(9);
  @$pb.TagNumber(10)
  set markedUnread($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMarkedUnread() => $_has(9);
  @$pb.TagNumber(10)
  void clearMarkedUnread() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get mutedUntil => $_getI64(10);
  @$pb.TagNumber(11)
  set mutedUntil($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMutedUntil() => $_has(10);
  @$pb.TagNumber(11)
  void clearMutedUntil() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get createdAt => $_getI64(11);
  @$pb.TagNumber(12)
  set createdAt($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);

  /// Моих сообщений с непрочитанными реакциями (бейдж ❤️ в списке).
  @$pb.TagNumber(13)
  $core.int get unreadReactionsCount => $_getIZ(12);
  @$pb.TagNumber(13)
  set unreadReactionsCount($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasUnreadReactionsCount() => $_has(12);
  @$pb.TagNumber(13)
  void clearUnreadReactionsCount() => $_clearField(13);

  /// Мой черновик (текст поля ввода, как есть — с markdown-ярлыками); пусто —
  /// нет. Синхронизируется между моими устройствами (Chats.SaveDraft →
  /// Update.dialogSettings).
  @$pb.TagNumber(14)
  $core.String get draft => $_getSZ(13);
  @$pb.TagNumber(14)
  set draft($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDraft() => $_has(13);
  @$pb.TagNumber(14)
  void clearDraft() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get draftDate => $_getI64(14);
  @$pb.TagNumber(15)
  set draftDate($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDraftDate() => $_has(14);
  @$pb.TagNumber(15)
  void clearDraftDate() => $_clearField(15);

  /// Автоудаление в чате (общее для участников, Chats.SetTTL): новые сообщения
  /// удаляются через столько секунд после отправки; 0 — выключено.
  @$pb.TagNumber(16)
  $core.int get ttlPeriod => $_getIZ(15);
  @$pb.TagNumber(16)
  set ttlPeriod($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasTtlPeriod() => $_has(15);
  @$pb.TagNumber(16)
  void clearTtlPeriod() => $_clearField(16);

  /// Защита содержимого (Chats.SetNoForwards, как noforwards в Telegram):
  /// пересылка (сервер отказывает), копирование, сохранение медиа и скриншоты
  /// в чате запрещены обоим участникам, а пуши — без текста. noForwardsMine —
  /// включил я (снять могу сам), иначе — собеседник (могу только попросить).
  /// Группа — копия ChatInfo.noForwards (noForwardsMine всегда false).
  @$pb.TagNumber(17)
  $core.bool get noForwards => $_getBF(16);
  @$pb.TagNumber(17)
  set noForwards($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasNoForwards() => $_has(16);
  @$pb.TagNumber(17)
  void clearNoForwards() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get noForwardsMine => $_getBF(17);
  @$pb.TagNumber(18)
  set noForwardsMine($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasNoForwardsMine() => $_has(17);
  @$pb.TagNumber(18)
  void clearNoForwardsMine() => $_clearField(18);

  /// Группа: общее описание (название, аватар, участники, pts журнала чата) и
  /// моя роль. У личного чата — пусто / CHAT_ROLE_NONE. В группе peerUserID
  /// пуст, readOutboxMaxID — до какого мои сообщения прочитал хоть один
  /// участник (✓✓, как в Telegram).
  @$pb.TagNumber(19)
  ChatInfo get chat => $_getN(18);
  @$pb.TagNumber(19)
  set chat(ChatInfo value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasChat() => $_has(18);
  @$pb.TagNumber(19)
  void clearChat() => $_clearField(19);
  @$pb.TagNumber(19)
  ChatInfo ensureChat() => $_ensure(18);

  @$pb.TagNumber(20)
  ChatRole get role => $_getN(19);
  @$pb.TagNumber(20)
  set role(ChatRole value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasRole() => $_has(19);
  @$pb.TagNumber(20)
  void clearRole() => $_clearField(20);

  /// Мои права в группе (ADMIN; у OWNER — все, у остальных — пусто) и звание.
  @$pb.TagNumber(21)
  ChatAdminRights get rights => $_getN(20);
  @$pb.TagNumber(21)
  set rights(ChatAdminRights value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasRights() => $_has(20);
  @$pb.TagNumber(21)
  void clearRights() => $_clearField(21);
  @$pb.TagNumber(21)
  ChatAdminRights ensureRights() => $_ensure(20);

  @$pb.TagNumber(22)
  $core.String get rank => $_getSZ(21);
  @$pb.TagNumber(22)
  set rank($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasRank() => $_has(21);
  @$pb.TagNumber(22)
  void clearRank() => $_clearField(22);

  /// Владельцу и админам с inviteUsers: основная ссылка-приглашение (код) и
  /// число ждущих заявок; остальным — пусто / 0.
  @$pb.TagNumber(23)
  $core.String get inviteCode => $_getSZ(22);
  @$pb.TagNumber(23)
  set inviteCode($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasInviteCode() => $_has(22);
  @$pb.TagNumber(23)
  void clearInviteCode() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.int get pendingRequests => $_getIZ(23);
  @$pb.TagNumber(24)
  set pendingRequests($core.int value) => $_setSignedInt32(23, value);
  @$pb.TagNumber(24)
  $core.bool hasPendingRequests() => $_has(23);
  @$pb.TagNumber(24)
  void clearPendingRequests() => $_clearField(24);

  /// Группа: непрочитанных упоминаний меня (бейдж «@», кнопка «@» в чате).
  @$pb.TagNumber(25)
  $core.int get unreadMentionsCount => $_getIZ(24);
  @$pb.TagNumber(25)
  set unreadMentionsCount($core.int value) => $_setSignedInt32(24, value);
  @$pb.TagNumber(25)
  $core.bool hasUnreadMentionsCount() => $_has(24);
  @$pb.TagNumber(25)
  void clearUnreadMentionsCount() => $_clearField(25);

  /// Медленный режим: когда мне можно отправить следующее (unix millis; 0 /
  /// в прошлом — можно сейчас; у админов — всегда 0).
  @$pb.TagNumber(26)
  $fixnum.Int64 get slowModeUntil => $_getI64(25);
  @$pb.TagNumber(26)
  set slowModeUntil($fixnum.Int64 value) => $_setInt64(25, value);
  @$pb.TagNumber(26)
  $core.bool hasSlowModeUntil() => $_has(25);
  @$pb.TagNumber(26)
  void clearSlowModeUntil() => $_clearField(26);

  /// Когда я вступил (unix millis) — для «Новичкам — без ссылок и медиа».
  @$pb.TagNumber(27)
  $fixnum.Int64 get joinedAt => $_getI64(26);
  @$pb.TagNumber(27)
  set joinedAt($fixnum.Int64 value) => $_setInt64(26, value);
  @$pb.TagNumber(27)
  $core.bool hasJoinedAt() => $_has(26);
  @$pb.TagNumber(27)
  void clearJoinedAt() => $_clearField(27);
}

/// Отложенное сообщение — моё, ещё не отправленное (как scheduled messages в
/// Telegram). Видно только мне (на всех моих устройствах); в момент date сервер
/// отправляет его обычным сообщением (новый messageID, дата — момент
/// отправки). scheduledID — номер внутри (я, чат), не messageID.
class ScheduledMessage extends $pb.GeneratedMessage {
  factory ScheduledMessage({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? scheduledID,
    $fixnum.Int64? date,
    MessageContent? content,
    $core.bool? silent,
    $fixnum.Int64? randomID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (scheduledID != null) result.scheduledID = scheduledID;
    if (date != null) result.date = date;
    if (content != null) result.content = content;
    if (silent != null) result.silent = silent;
    if (randomID != null) result.randomID = randomID;
    return result;
  }

  ScheduledMessage._();

  factory ScheduledMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduledMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ScheduledMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'scheduledID', protoName: 'scheduledID')
    ..aInt64(3, _omitFieldNames ? '' : 'date')
    ..aOM<MessageContent>(4, _omitFieldNames ? '' : 'content', subBuilder: MessageContent.create)
    ..aOB(5, _omitFieldNames ? '' : 'silent')
    ..aInt64(6, _omitFieldNames ? '' : 'randomID', protoName: 'randomID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduledMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduledMessage copyWith(void Function(ScheduledMessage) updates) =>
      super.copyWith((message) => updates(message as ScheduledMessage)) as ScheduledMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduledMessage create() => ScheduledMessage._();
  @$core.override
  ScheduledMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduledMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScheduledMessage>(create);
  static ScheduledMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get scheduledID => $_getI64(1);
  @$pb.TagNumber(2)
  set scheduledID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScheduledID() => $_has(1);
  @$pb.TagNumber(2)
  void clearScheduledID() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get date => $_getI64(2);
  @$pb.TagNumber(3)
  set date($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDate() => $_clearField(3);

  @$pb.TagNumber(4)
  MessageContent get content => $_getN(3);
  @$pb.TagNumber(4)
  set content(MessageContent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => $_clearField(4);
  @$pb.TagNumber(4)
  MessageContent ensureContent() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get silent => $_getBF(4);
  @$pb.TagNumber(5)
  set silent($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSilent() => $_has(4);
  @$pb.TagNumber(5)
  void clearSilent() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get randomID => $_getI64(5);
  @$pb.TagNumber(6)
  set randomID($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRandomID() => $_has(5);
  @$pb.TagNumber(6)
  void clearRandomID() => $_clearField(6);
}

/// Папка (таб) списка чатов — как dialogFilter в Telegram. «Все чаты» — не
/// папка (у клиента всегда первая). id выдаёт сервер; у SaveFolder 0 — новая.
/// Чат попадает в папку, если он в includeChatIDs или подходит по типу и не
/// исключён (excludeChatIDs, флаги exclude*); архивные — никогда.
class ChatFolder extends $pb.GeneratedMessage {
  factory ChatFolder({
    $core.int? id,
    $core.String? title,
    $core.bool? includeContacts,
    $core.bool? includeNonContacts,
    $core.bool? includeGroups,
    $core.bool? includeChannels,
    $core.bool? includeCommunities,
    $core.Iterable<$core.List<$core.int>>? includeChatIDs,
    $core.Iterable<$core.List<$core.int>>? excludeChatIDs,
    $core.bool? excludeMuted,
    $core.bool? excludeRead,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (includeContacts != null) result.includeContacts = includeContacts;
    if (includeNonContacts != null) result.includeNonContacts = includeNonContacts;
    if (includeGroups != null) result.includeGroups = includeGroups;
    if (includeChannels != null) result.includeChannels = includeChannels;
    if (includeCommunities != null) result.includeCommunities = includeCommunities;
    if (includeChatIDs != null) result.includeChatIDs.addAll(includeChatIDs);
    if (excludeChatIDs != null) result.excludeChatIDs.addAll(excludeChatIDs);
    if (excludeMuted != null) result.excludeMuted = excludeMuted;
    if (excludeRead != null) result.excludeRead = excludeRead;
    return result;
  }

  ChatFolder._();

  factory ChatFolder.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatFolder.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatFolder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOB(3, _omitFieldNames ? '' : 'includeContacts', protoName: 'includeContacts')
    ..aOB(4, _omitFieldNames ? '' : 'includeNonContacts', protoName: 'includeNonContacts')
    ..aOB(5, _omitFieldNames ? '' : 'includeGroups', protoName: 'includeGroups')
    ..aOB(6, _omitFieldNames ? '' : 'includeChannels', protoName: 'includeChannels')
    ..aOB(7, _omitFieldNames ? '' : 'includeCommunities', protoName: 'includeCommunities')
    ..p<$core.List<$core.int>>(8, _omitFieldNames ? '' : 'includeChatIDs', $pb.PbFieldType.PY, protoName: 'includeChatIDs')
    ..p<$core.List<$core.int>>(9, _omitFieldNames ? '' : 'excludeChatIDs', $pb.PbFieldType.PY, protoName: 'excludeChatIDs')
    ..aOB(10, _omitFieldNames ? '' : 'excludeMuted', protoName: 'excludeMuted')
    ..aOB(11, _omitFieldNames ? '' : 'excludeRead', protoName: 'excludeRead')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatFolder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatFolder copyWith(void Function(ChatFolder) updates) => super.copyWith((message) => updates(message as ChatFolder)) as ChatFolder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatFolder create() => ChatFolder._();
  @$core.override
  ChatFolder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatFolder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatFolder>(create);
  static ChatFolder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get includeContacts => $_getBF(2);
  @$pb.TagNumber(3)
  set includeContacts($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIncludeContacts() => $_has(2);
  @$pb.TagNumber(3)
  void clearIncludeContacts() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get includeNonContacts => $_getBF(3);
  @$pb.TagNumber(4)
  set includeNonContacts($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIncludeNonContacts() => $_has(3);
  @$pb.TagNumber(4)
  void clearIncludeNonContacts() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get includeGroups => $_getBF(4);
  @$pb.TagNumber(5)
  set includeGroups($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIncludeGroups() => $_has(4);
  @$pb.TagNumber(5)
  void clearIncludeGroups() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get includeChannels => $_getBF(5);
  @$pb.TagNumber(6)
  set includeChannels($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIncludeChannels() => $_has(5);
  @$pb.TagNumber(6)
  void clearIncludeChannels() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get includeCommunities => $_getBF(6);
  @$pb.TagNumber(7)
  set includeCommunities($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIncludeCommunities() => $_has(6);
  @$pb.TagNumber(7)
  void clearIncludeCommunities() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.List<$core.int>> get includeChatIDs => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.List<$core.int>> get excludeChatIDs => $_getList(8);

  @$pb.TagNumber(10)
  $core.bool get excludeMuted => $_getBF(9);
  @$pb.TagNumber(10)
  set excludeMuted($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasExcludeMuted() => $_has(9);
  @$pb.TagNumber(10)
  void clearExcludeMuted() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get excludeRead => $_getBF(10);
  @$pb.TagNumber(11)
  set excludeRead($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasExcludeRead() => $_has(10);
  @$pb.TagNumber(11)
  void clearExcludeRead() => $_clearField(11);
}

/// Все мои папки по порядку (до 9, без «Все чаты»). version растёт с каждым
/// изменением: клиент не перезаписывает новый снимок старым.
class ChatFolders extends $pb.GeneratedMessage {
  factory ChatFolders({
    $core.Iterable<ChatFolder>? folders,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (folders != null) result.folders.addAll(folders);
    if (version != null) result.version = version;
    return result;
  }

  ChatFolders._();

  factory ChatFolders.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatFolders.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatFolders',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatFolder>(1, _omitFieldNames ? '' : 'folders', subBuilder: ChatFolder.create)
    ..aInt64(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatFolders clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatFolders copyWith(void Function(ChatFolders) updates) => super.copyWith((message) => updates(message as ChatFolders)) as ChatFolders;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatFolders create() => ChatFolders._();
  @$core.override
  ChatFolders createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatFolders getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatFolders>(create);
  static ChatFolders? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatFolder> get folders => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get version => $_getI64(1);
  @$pb.TagNumber(2)
  set version($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

/// Состояние журнала обновлений пользователя.
class UpdatesState extends $pb.GeneratedMessage {
  factory UpdatesState({
    $fixnum.Int64? pts,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (pts != null) result.pts = pts;
    if (date != null) result.date = date;
    return result;
  }

  UpdatesState._();

  factory UpdatesState.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdatesState.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdatesState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pts')
    ..aInt64(2, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatesState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatesState copyWith(void Function(UpdatesState) updates) =>
      super.copyWith((message) => updates(message as UpdatesState)) as UpdatesState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatesState create() => UpdatesState._();
  @$core.override
  UpdatesState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdatesState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdatesState>(create);
  static UpdatesState? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pts => $_getI64(0);
  @$pb.TagNumber(1)
  set pts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPts() => $_has(0);
  @$pb.TagNumber(1)
  void clearPts() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get date => $_getI64(1);
  @$pb.TagNumber(2)
  set date($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);
}

class Update_NewMessage extends $pb.GeneratedMessage {
  factory Update_NewMessage({
    ChatMessage? message,
    Dialog? dialog,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (dialog != null) result.dialog = dialog;
    return result;
  }

  Update_NewMessage._();

  factory Update_NewMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_NewMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.NewMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatMessage>(1, _omitFieldNames ? '' : 'message', subBuilder: ChatMessage.create)
    ..aOM<Dialog>(2, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_NewMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_NewMessage copyWith(void Function(Update_NewMessage) updates) =>
      super.copyWith((message) => updates(message as Update_NewMessage)) as Update_NewMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_NewMessage create() => Update_NewMessage._();
  @$core.override
  Update_NewMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_NewMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_NewMessage>(create);
  static Update_NewMessage? _defaultInstance;

  @$pb.TagNumber(1)
  ChatMessage get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(ChatMessage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatMessage ensureMessage() => $_ensure(0);

  /// Чат появился у пользователя этим сообщением (первое в личном чате).
  @$pb.TagNumber(2)
  Dialog get dialog => $_getN(1);
  @$pb.TagNumber(2)
  set dialog(Dialog value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDialog() => $_has(1);
  @$pb.TagNumber(2)
  void clearDialog() => $_clearField(2);
  @$pb.TagNumber(2)
  Dialog ensureDialog() => $_ensure(1);
}

class Update_EditMessage extends $pb.GeneratedMessage {
  factory Update_EditMessage({
    ChatMessage? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  Update_EditMessage._();

  factory Update_EditMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_EditMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.EditMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatMessage>(1, _omitFieldNames ? '' : 'message', subBuilder: ChatMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_EditMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_EditMessage copyWith(void Function(Update_EditMessage) updates) =>
      super.copyWith((message) => updates(message as Update_EditMessage)) as Update_EditMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_EditMessage create() => Update_EditMessage._();
  @$core.override
  Update_EditMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_EditMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_EditMessage>(create);
  static Update_EditMessage? _defaultInstance;

  @$pb.TagNumber(1)
  ChatMessage get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(ChatMessage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatMessage ensureMessage() => $_ensure(0);
}

class Update_DeleteMessages extends $pb.GeneratedMessage {
  factory Update_DeleteMessages({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    return result;
  }

  Update_DeleteMessages._();

  factory Update_DeleteMessages.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_DeleteMessages.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.DeleteMessages',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DeleteMessages clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DeleteMessages copyWith(void Function(Update_DeleteMessages) updates) =>
      super.copyWith((message) => updates(message as Update_DeleteMessages)) as Update_DeleteMessages;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_DeleteMessages create() => Update_DeleteMessages._();
  @$core.override
  Update_DeleteMessages createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_DeleteMessages getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_DeleteMessages>(create);
  static Update_DeleteMessages? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);
}

/// Я прочитал входящие до maxID (на этом или другом устройстве).
class Update_ReadInbox extends $pb.GeneratedMessage {
  factory Update_ReadInbox({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? maxID,
    $core.int? unreadCount,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (maxID != null) result.maxID = maxID;
    if (unreadCount != null) result.unreadCount = unreadCount;
    return result;
  }

  Update_ReadInbox._();

  factory Update_ReadInbox.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ReadInbox.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ReadInbox',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'maxID', protoName: 'maxID')
    ..aI(3, _omitFieldNames ? '' : 'unreadCount', protoName: 'unreadCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadInbox clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadInbox copyWith(void Function(Update_ReadInbox) updates) =>
      super.copyWith((message) => updates(message as Update_ReadInbox)) as Update_ReadInbox;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ReadInbox create() => Update_ReadInbox._();
  @$core.override
  Update_ReadInbox createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ReadInbox getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ReadInbox>(create);
  static Update_ReadInbox? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxID => $_getI64(1);
  @$pb.TagNumber(2)
  set maxID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unreadCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set unreadCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnreadCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnreadCount() => $_clearField(3);
}

/// Собеседник прочитал мои до maxID (✓✓).
class Update_ReadOutbox extends $pb.GeneratedMessage {
  factory Update_ReadOutbox({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? maxID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (maxID != null) result.maxID = maxID;
    return result;
  }

  Update_ReadOutbox._();

  factory Update_ReadOutbox.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ReadOutbox.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ReadOutbox',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'maxID', protoName: 'maxID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadOutbox clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadOutbox copyWith(void Function(Update_ReadOutbox) updates) =>
      super.copyWith((message) => updates(message as Update_ReadOutbox)) as Update_ReadOutbox;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ReadOutbox create() => Update_ReadOutbox._();
  @$core.override
  Update_ReadOutbox createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ReadOutbox getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ReadOutbox>(create);
  static Update_ReadOutbox? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxID => $_getI64(1);
  @$pb.TagNumber(2)
  set maxID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxID() => $_clearField(2);
}

/// Голосовые прослушаны.
class Update_ReadContents extends $pb.GeneratedMessage {
  factory Update_ReadContents({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    return result;
  }

  Update_ReadContents._();

  factory Update_ReadContents.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ReadContents.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ReadContents',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadContents clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadContents copyWith(void Function(Update_ReadContents) updates) =>
      super.copyWith((message) => updates(message as Update_ReadContents)) as Update_ReadContents;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ReadContents create() => Update_ReadContents._();
  @$core.override
  Update_ReadContents createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ReadContents getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ReadContents>(create);
  static Update_ReadContents? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);
}

/// Изменились мои настройки диалога (закреп/архив/звук/пометка).
class Update_DialogSettings extends $pb.GeneratedMessage {
  factory Update_DialogSettings({
    Dialog? dialog,
  }) {
    final result = create();
    if (dialog != null) result.dialog = dialog;
    return result;
  }

  Update_DialogSettings._();

  factory Update_DialogSettings.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_DialogSettings.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.DialogSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Dialog>(1, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DialogSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DialogSettings copyWith(void Function(Update_DialogSettings) updates) =>
      super.copyWith((message) => updates(message as Update_DialogSettings)) as Update_DialogSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_DialogSettings create() => Update_DialogSettings._();
  @$core.override
  Update_DialogSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_DialogSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_DialogSettings>(create);
  static Update_DialogSettings? _defaultInstance;

  @$pb.TagNumber(1)
  Dialog get dialog => $_getN(0);
  @$pb.TagNumber(1)
  set dialog(Dialog value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDialog() => $_has(0);
  @$pb.TagNumber(1)
  void clearDialog() => $_clearField(1);
  @$pb.TagNumber(1)
  Dialog ensureDialog() => $_ensure(0);
}

/// Диалог удалён у меня (история очищена).
class Update_DialogDeleted extends $pb.GeneratedMessage {
  factory Update_DialogDeleted({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Update_DialogDeleted._();

  factory Update_DialogDeleted.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_DialogDeleted.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.DialogDeleted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DialogDeleted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DialogDeleted copyWith(void Function(Update_DialogDeleted) updates) =>
      super.copyWith((message) => updates(message as Update_DialogDeleted)) as Update_DialogDeleted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_DialogDeleted create() => Update_DialogDeleted._();
  @$core.override
  Update_DialogDeleted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_DialogDeleted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_DialogDeleted>(create);
  static Update_DialogDeleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

/// Сообщения закреплены (pinned) / откреплены у меня — на этом или другом
/// устройстве, мной или собеседником (закреп «у всех»). shared — закреплены
/// у всех участников (личный: у обоих; «Избранное» — всегда), иначе только у
/// меня. Приходит и когда у меня ничего не поменялось, а поменялось shared
/// (собеседник закрепил то же или открепил общее у себя). Содержимое
/// закреплённых, которых нет в кэше, клиент берёт запросом Messages.Pinned.
class Update_PinnedMessages extends $pb.GeneratedMessage {
  factory Update_PinnedMessages({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
    $core.bool? pinned,
    $core.bool? shared,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    if (pinned != null) result.pinned = pinned;
    if (shared != null) result.shared = shared;
    return result;
  }

  Update_PinnedMessages._();

  factory Update_PinnedMessages.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_PinnedMessages.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.PinnedMessages',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..aOB(3, _omitFieldNames ? '' : 'pinned')
    ..aOB(4, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_PinnedMessages clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_PinnedMessages copyWith(void Function(Update_PinnedMessages) updates) =>
      super.copyWith((message) => updates(message as Update_PinnedMessages)) as Update_PinnedMessages;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_PinnedMessages create() => Update_PinnedMessages._();
  @$core.override
  Update_PinnedMessages createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_PinnedMessages getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_PinnedMessages>(create);
  static Update_PinnedMessages? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get pinned => $_getBF(2);
  @$pb.TagNumber(3)
  set pinned($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPinned() => $_has(2);
  @$pb.TagNumber(3)
  void clearPinned() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get shared => $_getBF(3);
  @$pb.TagNumber(4)
  set shared($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShared() => $_has(3);
  @$pb.TagNumber(4)
  void clearShared() => $_clearField(4);
}

/// Изменились реакции на сообщение (мои — на этом или другом устройстве — или
/// собеседника). reactions — текущие целиком (заменяют прежние).
///
/// Группа: журнал чата (всем), reactions.counts без chosenOrder; actorUserID /
/// actorEmojis — кто изменил и его набор целиком (пусто — снял все): если
/// это я — мои реакции теперь такие, иначе свои не менять. Автору сообщения
/// при новой чужой реакции — ещё такое же обновление в журнал пользователя
/// (pts > 0) с unreadReactionsCount / reactionsUnread.
class Update_MessageReactionsChanged extends $pb.GeneratedMessage {
  factory Update_MessageReactionsChanged({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    MessageReactions? reactions,
    $core.int? unreadReactionsCount,
    $core.bool? reactionsUnread,
    $core.List<$core.int>? actorUserID,
    $core.Iterable<$core.String>? actorEmojis,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (reactions != null) result.reactions = reactions;
    if (unreadReactionsCount != null) result.unreadReactionsCount = unreadReactionsCount;
    if (reactionsUnread != null) result.reactionsUnread = reactionsUnread;
    if (actorUserID != null) result.actorUserID = actorUserID;
    if (actorEmojis != null) result.actorEmojis.addAll(actorEmojis);
    return result;
  }

  Update_MessageReactionsChanged._();

  factory Update_MessageReactionsChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_MessageReactionsChanged.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.MessageReactionsChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aOM<MessageReactions>(3, _omitFieldNames ? '' : 'reactions', subBuilder: MessageReactions.create)
    ..aI(4, _omitFieldNames ? '' : 'unreadReactionsCount', protoName: 'unreadReactionsCount')
    ..aOB(5, _omitFieldNames ? '' : 'reactionsUnread', protoName: 'reactionsUnread')
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'actorUserID', $pb.PbFieldType.OY, protoName: 'actorUserID')
    ..pPS(7, _omitFieldNames ? '' : 'actorEmojis', protoName: 'actorEmojis')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_MessageReactionsChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_MessageReactionsChanged copyWith(void Function(Update_MessageReactionsChanged) updates) =>
      super.copyWith((message) => updates(message as Update_MessageReactionsChanged)) as Update_MessageReactionsChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_MessageReactionsChanged create() => Update_MessageReactionsChanged._();
  @$core.override
  Update_MessageReactionsChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_MessageReactionsChanged getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_MessageReactionsChanged>(create);
  static Update_MessageReactionsChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);

  @$pb.TagNumber(3)
  MessageReactions get reactions => $_getN(2);
  @$pb.TagNumber(3)
  set reactions(MessageReactions value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReactions() => $_has(2);
  @$pb.TagNumber(3)
  void clearReactions() => $_clearField(3);
  @$pb.TagNumber(3)
  MessageReactions ensureReactions() => $_ensure(2);

  /// Мой текущий счётчик Dialog.unreadReactionsCount в этом чате.
  @$pb.TagNumber(4)
  $core.int get unreadReactionsCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set unreadReactionsCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnreadReactionsCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnreadReactionsCount() => $_clearField(4);

  /// ChatMessage.reactionsUnread сообщения (значим только для автора).
  @$pb.TagNumber(5)
  $core.bool get reactionsUnread => $_getBF(4);
  @$pb.TagNumber(5)
  set reactionsUnread($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReactionsUnread() => $_has(4);
  @$pb.TagNumber(5)
  void clearReactionsUnread() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get actorUserID => $_getN(5);
  @$pb.TagNumber(6)
  set actorUserID($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActorUserID() => $_has(5);
  @$pb.TagNumber(6)
  void clearActorUserID() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get actorEmojis => $_getList(6);
}

/// Реакции на мои сообщения messageIDs просмотрены (на этом или другом
/// устройстве): снять reactionsUnread; unreadReactionsCount — текущий.
class Update_ReadReactions extends $pb.GeneratedMessage {
  factory Update_ReadReactions({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
    $core.int? unreadReactionsCount,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    if (unreadReactionsCount != null) result.unreadReactionsCount = unreadReactionsCount;
    return result;
  }

  Update_ReadReactions._();

  factory Update_ReadReactions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ReadReactions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ReadReactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..aI(3, _omitFieldNames ? '' : 'unreadReactionsCount', protoName: 'unreadReactionsCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadReactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadReactions copyWith(void Function(Update_ReadReactions) updates) =>
      super.copyWith((message) => updates(message as Update_ReadReactions)) as Update_ReadReactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ReadReactions create() => Update_ReadReactions._();
  @$core.override
  Update_ReadReactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ReadReactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ReadReactions>(create);
  static Update_ReadReactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get unreadReactionsCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set unreadReactionsCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnreadReactionsCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnreadReactionsCount() => $_clearField(3);
}

/// Моё отложенное создано или перенесено (всегда текущее).
class Update_ScheduledMessageChanged extends $pb.GeneratedMessage {
  factory Update_ScheduledMessageChanged({
    ScheduledMessage? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  Update_ScheduledMessageChanged._();

  factory Update_ScheduledMessageChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ScheduledMessageChanged.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ScheduledMessageChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ScheduledMessage>(1, _omitFieldNames ? '' : 'message', subBuilder: ScheduledMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ScheduledMessageChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ScheduledMessageChanged copyWith(void Function(Update_ScheduledMessageChanged) updates) =>
      super.copyWith((message) => updates(message as Update_ScheduledMessageChanged)) as Update_ScheduledMessageChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ScheduledMessageChanged create() => Update_ScheduledMessageChanged._();
  @$core.override
  Update_ScheduledMessageChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ScheduledMessageChanged getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ScheduledMessageChanged>(create);
  static Update_ScheduledMessageChanged? _defaultInstance;

  @$pb.TagNumber(1)
  ScheduledMessage get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(ScheduledMessage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
  @$pb.TagNumber(1)
  ScheduledMessage ensureMessage() => $_ensure(0);
}

/// Мои отложенные scheduledIDs больше не ждут: отправлены (сообщение придёт
/// своим newMessage), удалены или не отправлены — сервер отказал в момент
/// отправки (чат удалён, собеседник ограничил, кто может ему писать).
class Update_ScheduledDeleted extends $pb.GeneratedMessage {
  factory Update_ScheduledDeleted({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? scheduledIDs,
    Update_ScheduledDeleted_Reason? reason,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (scheduledIDs != null) result.scheduledIDs.addAll(scheduledIDs);
    if (reason != null) result.reason = reason;
    return result;
  }

  Update_ScheduledDeleted._();

  factory Update_ScheduledDeleted.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ScheduledDeleted.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ScheduledDeleted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'scheduledIDs', $pb.PbFieldType.K6, protoName: 'scheduledIDs')
    ..aE<Update_ScheduledDeleted_Reason>(3, _omitFieldNames ? '' : 'reason', enumValues: Update_ScheduledDeleted_Reason.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ScheduledDeleted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ScheduledDeleted copyWith(void Function(Update_ScheduledDeleted) updates) =>
      super.copyWith((message) => updates(message as Update_ScheduledDeleted)) as Update_ScheduledDeleted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ScheduledDeleted create() => Update_ScheduledDeleted._();
  @$core.override
  Update_ScheduledDeleted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ScheduledDeleted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ScheduledDeleted>(create);
  static Update_ScheduledDeleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get scheduledIDs => $_getList(1);

  @$pb.TagNumber(3)
  Update_ScheduledDeleted_Reason get reason => $_getN(2);
  @$pb.TagNumber(3)
  set reason(Update_ScheduledDeleted_Reason value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

/// Изменились сведения о группе (название, описание, аватар, число
/// участников) — журнал чата.
class Update_ChatInfoChanged extends $pb.GeneratedMessage {
  factory Update_ChatInfoChanged({
    ChatInfo? chat,
  }) {
    final result = create();
    if (chat != null) result.chat = chat;
    return result;
  }

  Update_ChatInfoChanged._();

  factory Update_ChatInfoChanged.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ChatInfoChanged.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ChatInfoChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatInfo>(1, _omitFieldNames ? '' : 'chat', subBuilder: ChatInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ChatInfoChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ChatInfoChanged copyWith(void Function(Update_ChatInfoChanged) updates) =>
      super.copyWith((message) => updates(message as Update_ChatInfoChanged)) as Update_ChatInfoChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ChatInfoChanged create() => Update_ChatInfoChanged._();
  @$core.override
  Update_ChatInfoChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ChatInfoChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ChatInfoChanged>(create);
  static Update_ChatInfoChanged? _defaultInstance;

  @$pb.TagNumber(1)
  ChatInfo get chat => $_getN(0);
  @$pb.TagNumber(1)
  set chat(ChatInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChat() => $_has(0);
  @$pb.TagNumber(1)
  void clearChat() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatInfo ensureChat() => $_ensure(0);
}

/// Изменился состав группы — журнал чата. added — новые участники (с ролью),
/// removedUserIDs — вышедшие / исключённые; membersCount — текущее число.
class Update_ChatMembersChanged extends $pb.GeneratedMessage {
  factory Update_ChatMembersChanged({
    $core.List<$core.int>? chatID,
    $core.Iterable<ChatMember>? added,
    $core.Iterable<$core.List<$core.int>>? removedUserIDs,
    $core.int? membersCount,
    $core.Iterable<ChatMember>? updated,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (added != null) result.added.addAll(added);
    if (removedUserIDs != null) result.removedUserIDs.addAll(removedUserIDs);
    if (membersCount != null) result.membersCount = membersCount;
    if (updated != null) result.updated.addAll(updated);
    return result;
  }

  Update_ChatMembersChanged._();

  factory Update_ChatMembersChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ChatMembersChanged.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ChatMembersChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..pPM<ChatMember>(2, _omitFieldNames ? '' : 'added', subBuilder: ChatMember.create)
    ..p<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'removedUserIDs', $pb.PbFieldType.PY, protoName: 'removedUserIDs')
    ..aI(4, _omitFieldNames ? '' : 'membersCount', protoName: 'membersCount')
    ..pPM<ChatMember>(5, _omitFieldNames ? '' : 'updated', subBuilder: ChatMember.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ChatMembersChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ChatMembersChanged copyWith(void Function(Update_ChatMembersChanged) updates) =>
      super.copyWith((message) => updates(message as Update_ChatMembersChanged)) as Update_ChatMembersChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ChatMembersChanged create() => Update_ChatMembersChanged._();
  @$core.override
  Update_ChatMembersChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ChatMembersChanged getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ChatMembersChanged>(create);
  static Update_ChatMembersChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ChatMember> get added => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.List<$core.int>> get removedUserIDs => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get membersCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set membersCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMembersCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearMembersCount() => $_clearField(4);

  /// Изменились роль / права / звание (назначили или сняли админа, сменили
  /// READER / WRITER, передали владение) — участник целиком, текущий.
  @$pb.TagNumber(5)
  $pb.PbList<ChatMember> get updated => $_getList(4);
}

/// Изменились заявки на вступление в группу (журнал пользователя — только
/// владельцу и админам с inviteUsers): pendingCount — сколько ждёт,
/// recentUserIDs — последние (до 3) для плашки «Заявки на вступление».
class Update_JoinRequestsChanged extends $pb.GeneratedMessage {
  factory Update_JoinRequestsChanged({
    $core.List<$core.int>? chatID,
    $core.int? pendingCount,
    $core.Iterable<$core.List<$core.int>>? recentUserIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (pendingCount != null) result.pendingCount = pendingCount;
    if (recentUserIDs != null) result.recentUserIDs.addAll(recentUserIDs);
    return result;
  }

  Update_JoinRequestsChanged._();

  factory Update_JoinRequestsChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_JoinRequestsChanged.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.JoinRequestsChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aI(2, _omitFieldNames ? '' : 'pendingCount', protoName: 'pendingCount')
    ..p<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'recentUserIDs', $pb.PbFieldType.PY, protoName: 'recentUserIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_JoinRequestsChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_JoinRequestsChanged copyWith(void Function(Update_JoinRequestsChanged) updates) =>
      super.copyWith((message) => updates(message as Update_JoinRequestsChanged)) as Update_JoinRequestsChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_JoinRequestsChanged create() => Update_JoinRequestsChanged._();
  @$core.override
  Update_JoinRequestsChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_JoinRequestsChanged getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_JoinRequestsChanged>(create);
  static Update_JoinRequestsChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pendingCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set pendingCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPendingCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearPendingCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.List<$core.int>> get recentUserIDs => $_getList(2);
}

/// Упоминания меня в группе (журнал пользователя): unread — новые
/// непрочитанные (сообщения с @мной, с моим именем или ответы на мои),
/// иначе — прочитаны (Messages.ReadMentions на этом или другом устройстве)
/// или сообщения удалены у всех. unreadMentionsCount — текущий
/// Dialog.unreadMentionsCount.
class Update_MentionsChanged extends $pb.GeneratedMessage {
  factory Update_MentionsChanged({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
    $core.bool? unread,
    $core.int? unreadMentionsCount,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    if (unread != null) result.unread = unread;
    if (unreadMentionsCount != null) result.unreadMentionsCount = unreadMentionsCount;
    return result;
  }

  Update_MentionsChanged._();

  factory Update_MentionsChanged.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_MentionsChanged.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.MentionsChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..aOB(3, _omitFieldNames ? '' : 'unread')
    ..aI(4, _omitFieldNames ? '' : 'unreadMentionsCount', protoName: 'unreadMentionsCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_MentionsChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_MentionsChanged copyWith(void Function(Update_MentionsChanged) updates) =>
      super.copyWith((message) => updates(message as Update_MentionsChanged)) as Update_MentionsChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_MentionsChanged create() => Update_MentionsChanged._();
  @$core.override
  Update_MentionsChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_MentionsChanged getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_MentionsChanged>(create);
  static Update_MentionsChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get unread => $_getBF(2);
  @$pb.TagNumber(3)
  set unread($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnread() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnread() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get unreadMentionsCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set unreadMentionsCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnreadMentionsCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnreadMentionsCount() => $_clearField(4);
}

/// Изменились итоги опроса. Журнал чата (всем участникам): results без
/// chosen (и без верного ответа, пока не завершён); actorUserID /
/// actorOptions — кто проголосовал и его выбор целиком (пусто — отменил
/// голос; у завершения — пусто): если это я — мой выбор теперь такой,
/// иначе свой выбор не менять. Голосовавшему в журнал пользователя (на все
/// его устройства) — такое же обновление с results глазами него (chosen,
/// верный ответ и пояснение викторины), actorUserID пуст.
class Update_MessagePollChanged extends $pb.GeneratedMessage {
  factory Update_MessagePollChanged({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    PollResults? results,
    $core.List<$core.int>? actorUserID,
    $core.Iterable<$core.int>? actorOptions,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (results != null) result.results = results;
    if (actorUserID != null) result.actorUserID = actorUserID;
    if (actorOptions != null) result.actorOptions.addAll(actorOptions);
    return result;
  }

  Update_MessagePollChanged._();

  factory Update_MessagePollChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_MessagePollChanged.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.MessagePollChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aOM<PollResults>(3, _omitFieldNames ? '' : 'results', subBuilder: PollResults.create)
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'actorUserID', $pb.PbFieldType.OY, protoName: 'actorUserID')
    ..p<$core.int>(5, _omitFieldNames ? '' : 'actorOptions', $pb.PbFieldType.K3, protoName: 'actorOptions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_MessagePollChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_MessagePollChanged copyWith(void Function(Update_MessagePollChanged) updates) =>
      super.copyWith((message) => updates(message as Update_MessagePollChanged)) as Update_MessagePollChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_MessagePollChanged create() => Update_MessagePollChanged._();
  @$core.override
  Update_MessagePollChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_MessagePollChanged getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_MessagePollChanged>(create);
  static Update_MessagePollChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);

  @$pb.TagNumber(3)
  PollResults get results => $_getN(2);
  @$pb.TagNumber(3)
  set results(PollResults value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasResults() => $_has(2);
  @$pb.TagNumber(3)
  void clearResults() => $_clearField(3);
  @$pb.TagNumber(3)
  PollResults ensureResults() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<$core.int> get actorUserID => $_getN(3);
  @$pb.TagNumber(4)
  set actorUserID($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActorUserID() => $_has(3);
  @$pb.TagNumber(4)
  void clearActorUserID() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.int> get actorOptions => $_getList(4);
}

/// У меня появился диалог группы (создал, добавили, вступил) — журнал
/// пользователя. После него клиент подписан на журнал чата с dialog.chat.pts.
/// Вышел / исключили / группу удалили — Update.dialogDeleted.
class Update_DialogNew extends $pb.GeneratedMessage {
  factory Update_DialogNew({
    Dialog? dialog,
  }) {
    final result = create();
    if (dialog != null) result.dialog = dialog;
    return result;
  }

  Update_DialogNew._();

  factory Update_DialogNew.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_DialogNew.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.DialogNew',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Dialog>(1, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DialogNew clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DialogNew copyWith(void Function(Update_DialogNew) updates) =>
      super.copyWith((message) => updates(message as Update_DialogNew)) as Update_DialogNew;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_DialogNew create() => Update_DialogNew._();
  @$core.override
  Update_DialogNew createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_DialogNew getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_DialogNew>(create);
  static Update_DialogNew? _defaultInstance;

  @$pb.TagNumber(1)
  Dialog get dialog => $_getN(0);
  @$pb.TagNumber(1)
  set dialog(Dialog value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDialog() => $_has(0);
  @$pb.TagNumber(1)
  void clearDialog() => $_clearField(1);
  @$pb.TagNumber(1)
  Dialog ensureDialog() => $_ensure(0);
}

enum Update_Update {
  newMessage,
  editMessage,
  deleteMessages,
  readInbox,
  readOutbox,
  readContents,
  dialogSettings,
  dialogDeleted,
  pinnedMessages,
  messageReactions,
  readReactions,
  folders,
  scheduledMessage,
  scheduledDeleted,
  chatInfo,
  chatMembers,
  dialogNew,
  joinRequests,
  mentions,
  messagePoll,
  notSet
}

/// Одно обновление журнала. pts — номер обновления у пользователя (без дыр:
/// клиент, получив pts > своего + 1, догоняет через GET_DIFFERENCE).
///
/// Журнал ЧАТА (группы): у обновления chatPts > 0 и chatID, а pts = 0 (в
/// журнал пользователя не входит). Порядок — по chatPts внутри чата: дубликат
/// пропустить, дыра (chatPts > своего + 1) — Chats.GetChatDifference. В журнал
/// чата идут общие события группы: сообщения (новое / правка / удаление),
/// прослушивание, сведения о группе и участники. Моё состояние диалога
/// (прочитано, звук, закреп, черновик, вступил / вышел) — в журнале
/// пользователя, как у личных.
class Update extends $pb.GeneratedMessage {
  factory Update({
    $fixnum.Int64? pts,
    $fixnum.Int64? date,
    Update_NewMessage? newMessage,
    Update_EditMessage? editMessage,
    Update_DeleteMessages? deleteMessages,
    Update_ReadInbox? readInbox,
    Update_ReadOutbox? readOutbox,
    Update_ReadContents? readContents,
    Update_DialogSettings? dialogSettings,
    Update_DialogDeleted? dialogDeleted,
    Update_PinnedMessages? pinnedMessages,
    Update_MessageReactionsChanged? messageReactions,
    Update_ReadReactions? readReactions,
    ChatFolders? folders,
    Update_ScheduledMessageChanged? scheduledMessage,
    Update_ScheduledDeleted? scheduledDeleted,
    Update_ChatInfoChanged? chatInfo,
    Update_ChatMembersChanged? chatMembers,
    Update_DialogNew? dialogNew,
    Update_JoinRequestsChanged? joinRequests,
    Update_MentionsChanged? mentions,
    Update_MessagePollChanged? messagePoll,
    $fixnum.Int64? chatPts,
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (pts != null) result.pts = pts;
    if (date != null) result.date = date;
    if (newMessage != null) result.newMessage = newMessage;
    if (editMessage != null) result.editMessage = editMessage;
    if (deleteMessages != null) result.deleteMessages = deleteMessages;
    if (readInbox != null) result.readInbox = readInbox;
    if (readOutbox != null) result.readOutbox = readOutbox;
    if (readContents != null) result.readContents = readContents;
    if (dialogSettings != null) result.dialogSettings = dialogSettings;
    if (dialogDeleted != null) result.dialogDeleted = dialogDeleted;
    if (pinnedMessages != null) result.pinnedMessages = pinnedMessages;
    if (messageReactions != null) result.messageReactions = messageReactions;
    if (readReactions != null) result.readReactions = readReactions;
    if (folders != null) result.folders = folders;
    if (scheduledMessage != null) result.scheduledMessage = scheduledMessage;
    if (scheduledDeleted != null) result.scheduledDeleted = scheduledDeleted;
    if (chatInfo != null) result.chatInfo = chatInfo;
    if (chatMembers != null) result.chatMembers = chatMembers;
    if (dialogNew != null) result.dialogNew = dialogNew;
    if (joinRequests != null) result.joinRequests = joinRequests;
    if (mentions != null) result.mentions = mentions;
    if (messagePoll != null) result.messagePoll = messagePoll;
    if (chatPts != null) result.chatPts = chatPts;
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Update._();

  factory Update.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Update_Update> _Update_UpdateByTag = {
    3: Update_Update.newMessage,
    4: Update_Update.editMessage,
    5: Update_Update.deleteMessages,
    6: Update_Update.readInbox,
    7: Update_Update.readOutbox,
    8: Update_Update.readContents,
    9: Update_Update.dialogSettings,
    10: Update_Update.dialogDeleted,
    11: Update_Update.pinnedMessages,
    12: Update_Update.messageReactions,
    13: Update_Update.readReactions,
    14: Update_Update.folders,
    15: Update_Update.scheduledMessage,
    16: Update_Update.scheduledDeleted,
    17: Update_Update.chatInfo,
    18: Update_Update.chatMembers,
    19: Update_Update.dialogNew,
    20: Update_Update.joinRequests,
    21: Update_Update.mentions,
    22: Update_Update.messagePoll,
    0: Update_Update.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22])
    ..aInt64(1, _omitFieldNames ? '' : 'pts')
    ..aInt64(2, _omitFieldNames ? '' : 'date')
    ..aOM<Update_NewMessage>(3, _omitFieldNames ? '' : 'newMessage', protoName: 'newMessage', subBuilder: Update_NewMessage.create)
    ..aOM<Update_EditMessage>(4, _omitFieldNames ? '' : 'editMessage', protoName: 'editMessage', subBuilder: Update_EditMessage.create)
    ..aOM<Update_DeleteMessages>(5, _omitFieldNames ? '' : 'deleteMessages',
        protoName: 'deleteMessages', subBuilder: Update_DeleteMessages.create)
    ..aOM<Update_ReadInbox>(6, _omitFieldNames ? '' : 'readInbox', protoName: 'readInbox', subBuilder: Update_ReadInbox.create)
    ..aOM<Update_ReadOutbox>(7, _omitFieldNames ? '' : 'readOutbox', protoName: 'readOutbox', subBuilder: Update_ReadOutbox.create)
    ..aOM<Update_ReadContents>(8, _omitFieldNames ? '' : 'readContents', protoName: 'readContents', subBuilder: Update_ReadContents.create)
    ..aOM<Update_DialogSettings>(9, _omitFieldNames ? '' : 'dialogSettings',
        protoName: 'dialogSettings', subBuilder: Update_DialogSettings.create)
    ..aOM<Update_DialogDeleted>(10, _omitFieldNames ? '' : 'dialogDeleted',
        protoName: 'dialogDeleted', subBuilder: Update_DialogDeleted.create)
    ..aOM<Update_PinnedMessages>(11, _omitFieldNames ? '' : 'pinnedMessages',
        protoName: 'pinnedMessages', subBuilder: Update_PinnedMessages.create)
    ..aOM<Update_MessageReactionsChanged>(12, _omitFieldNames ? '' : 'messageReactions',
        protoName: 'messageReactions', subBuilder: Update_MessageReactionsChanged.create)
    ..aOM<Update_ReadReactions>(13, _omitFieldNames ? '' : 'readReactions',
        protoName: 'readReactions', subBuilder: Update_ReadReactions.create)
    ..aOM<ChatFolders>(14, _omitFieldNames ? '' : 'folders', subBuilder: ChatFolders.create)
    ..aOM<Update_ScheduledMessageChanged>(15, _omitFieldNames ? '' : 'scheduledMessage',
        protoName: 'scheduledMessage', subBuilder: Update_ScheduledMessageChanged.create)
    ..aOM<Update_ScheduledDeleted>(16, _omitFieldNames ? '' : 'scheduledDeleted',
        protoName: 'scheduledDeleted', subBuilder: Update_ScheduledDeleted.create)
    ..aOM<Update_ChatInfoChanged>(17, _omitFieldNames ? '' : 'chatInfo', protoName: 'chatInfo', subBuilder: Update_ChatInfoChanged.create)
    ..aOM<Update_ChatMembersChanged>(18, _omitFieldNames ? '' : 'chatMembers',
        protoName: 'chatMembers', subBuilder: Update_ChatMembersChanged.create)
    ..aOM<Update_DialogNew>(19, _omitFieldNames ? '' : 'dialogNew', protoName: 'dialogNew', subBuilder: Update_DialogNew.create)
    ..aOM<Update_JoinRequestsChanged>(20, _omitFieldNames ? '' : 'joinRequests',
        protoName: 'joinRequests', subBuilder: Update_JoinRequestsChanged.create)
    ..aOM<Update_MentionsChanged>(21, _omitFieldNames ? '' : 'mentions', subBuilder: Update_MentionsChanged.create)
    ..aOM<Update_MessagePollChanged>(22, _omitFieldNames ? '' : 'messagePoll',
        protoName: 'messagePoll', subBuilder: Update_MessagePollChanged.create)
    ..aInt64(50, _omitFieldNames ? '' : 'chatPts', protoName: 'chatPts')
    ..a<$core.List<$core.int>>(51, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update copyWith(void Function(Update) updates) => super.copyWith((message) => updates(message as Update)) as Update;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update create() => Update._();
  @$core.override
  Update createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update>(create);
  static Update? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  Update_Update whichUpdate() => _Update_UpdateByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  void clearUpdate() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get pts => $_getI64(0);
  @$pb.TagNumber(1)
  set pts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPts() => $_has(0);
  @$pb.TagNumber(1)
  void clearPts() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get date => $_getI64(1);
  @$pb.TagNumber(2)
  set date($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);

  @$pb.TagNumber(3)
  Update_NewMessage get newMessage => $_getN(2);
  @$pb.TagNumber(3)
  set newMessage(Update_NewMessage value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNewMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewMessage() => $_clearField(3);
  @$pb.TagNumber(3)
  Update_NewMessage ensureNewMessage() => $_ensure(2);

  @$pb.TagNumber(4)
  Update_EditMessage get editMessage => $_getN(3);
  @$pb.TagNumber(4)
  set editMessage(Update_EditMessage value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEditMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearEditMessage() => $_clearField(4);
  @$pb.TagNumber(4)
  Update_EditMessage ensureEditMessage() => $_ensure(3);

  @$pb.TagNumber(5)
  Update_DeleteMessages get deleteMessages => $_getN(4);
  @$pb.TagNumber(5)
  set deleteMessages(Update_DeleteMessages value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDeleteMessages() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeleteMessages() => $_clearField(5);
  @$pb.TagNumber(5)
  Update_DeleteMessages ensureDeleteMessages() => $_ensure(4);

  @$pb.TagNumber(6)
  Update_ReadInbox get readInbox => $_getN(5);
  @$pb.TagNumber(6)
  set readInbox(Update_ReadInbox value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReadInbox() => $_has(5);
  @$pb.TagNumber(6)
  void clearReadInbox() => $_clearField(6);
  @$pb.TagNumber(6)
  Update_ReadInbox ensureReadInbox() => $_ensure(5);

  @$pb.TagNumber(7)
  Update_ReadOutbox get readOutbox => $_getN(6);
  @$pb.TagNumber(7)
  set readOutbox(Update_ReadOutbox value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasReadOutbox() => $_has(6);
  @$pb.TagNumber(7)
  void clearReadOutbox() => $_clearField(7);
  @$pb.TagNumber(7)
  Update_ReadOutbox ensureReadOutbox() => $_ensure(6);

  @$pb.TagNumber(8)
  Update_ReadContents get readContents => $_getN(7);
  @$pb.TagNumber(8)
  set readContents(Update_ReadContents value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasReadContents() => $_has(7);
  @$pb.TagNumber(8)
  void clearReadContents() => $_clearField(8);
  @$pb.TagNumber(8)
  Update_ReadContents ensureReadContents() => $_ensure(7);

  @$pb.TagNumber(9)
  Update_DialogSettings get dialogSettings => $_getN(8);
  @$pb.TagNumber(9)
  set dialogSettings(Update_DialogSettings value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDialogSettings() => $_has(8);
  @$pb.TagNumber(9)
  void clearDialogSettings() => $_clearField(9);
  @$pb.TagNumber(9)
  Update_DialogSettings ensureDialogSettings() => $_ensure(8);

  @$pb.TagNumber(10)
  Update_DialogDeleted get dialogDeleted => $_getN(9);
  @$pb.TagNumber(10)
  set dialogDeleted(Update_DialogDeleted value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDialogDeleted() => $_has(9);
  @$pb.TagNumber(10)
  void clearDialogDeleted() => $_clearField(10);
  @$pb.TagNumber(10)
  Update_DialogDeleted ensureDialogDeleted() => $_ensure(9);

  @$pb.TagNumber(11)
  Update_PinnedMessages get pinnedMessages => $_getN(10);
  @$pb.TagNumber(11)
  set pinnedMessages(Update_PinnedMessages value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPinnedMessages() => $_has(10);
  @$pb.TagNumber(11)
  void clearPinnedMessages() => $_clearField(11);
  @$pb.TagNumber(11)
  Update_PinnedMessages ensurePinnedMessages() => $_ensure(10);

  @$pb.TagNumber(12)
  Update_MessageReactionsChanged get messageReactions => $_getN(11);
  @$pb.TagNumber(12)
  set messageReactions(Update_MessageReactionsChanged value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasMessageReactions() => $_has(11);
  @$pb.TagNumber(12)
  void clearMessageReactions() => $_clearField(12);
  @$pb.TagNumber(12)
  Update_MessageReactionsChanged ensureMessageReactions() => $_ensure(11);

  @$pb.TagNumber(13)
  Update_ReadReactions get readReactions => $_getN(12);
  @$pb.TagNumber(13)
  set readReactions(Update_ReadReactions value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasReadReactions() => $_has(12);
  @$pb.TagNumber(13)
  void clearReadReactions() => $_clearField(13);
  @$pb.TagNumber(13)
  Update_ReadReactions ensureReadReactions() => $_ensure(12);

  /// Мои папки изменились (на этом или другом устройстве) — снимок целиком,
  /// всегда текущий.
  @$pb.TagNumber(14)
  ChatFolders get folders => $_getN(13);
  @$pb.TagNumber(14)
  set folders(ChatFolders value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasFolders() => $_has(13);
  @$pb.TagNumber(14)
  void clearFolders() => $_clearField(14);
  @$pb.TagNumber(14)
  ChatFolders ensureFolders() => $_ensure(13);

  @$pb.TagNumber(15)
  Update_ScheduledMessageChanged get scheduledMessage => $_getN(14);
  @$pb.TagNumber(15)
  set scheduledMessage(Update_ScheduledMessageChanged value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasScheduledMessage() => $_has(14);
  @$pb.TagNumber(15)
  void clearScheduledMessage() => $_clearField(15);
  @$pb.TagNumber(15)
  Update_ScheduledMessageChanged ensureScheduledMessage() => $_ensure(14);

  @$pb.TagNumber(16)
  Update_ScheduledDeleted get scheduledDeleted => $_getN(15);
  @$pb.TagNumber(16)
  set scheduledDeleted(Update_ScheduledDeleted value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasScheduledDeleted() => $_has(15);
  @$pb.TagNumber(16)
  void clearScheduledDeleted() => $_clearField(16);
  @$pb.TagNumber(16)
  Update_ScheduledDeleted ensureScheduledDeleted() => $_ensure(15);

  @$pb.TagNumber(17)
  Update_ChatInfoChanged get chatInfo => $_getN(16);
  @$pb.TagNumber(17)
  set chatInfo(Update_ChatInfoChanged value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasChatInfo() => $_has(16);
  @$pb.TagNumber(17)
  void clearChatInfo() => $_clearField(17);
  @$pb.TagNumber(17)
  Update_ChatInfoChanged ensureChatInfo() => $_ensure(16);

  @$pb.TagNumber(18)
  Update_ChatMembersChanged get chatMembers => $_getN(17);
  @$pb.TagNumber(18)
  set chatMembers(Update_ChatMembersChanged value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasChatMembers() => $_has(17);
  @$pb.TagNumber(18)
  void clearChatMembers() => $_clearField(18);
  @$pb.TagNumber(18)
  Update_ChatMembersChanged ensureChatMembers() => $_ensure(17);

  @$pb.TagNumber(19)
  Update_DialogNew get dialogNew => $_getN(18);
  @$pb.TagNumber(19)
  set dialogNew(Update_DialogNew value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasDialogNew() => $_has(18);
  @$pb.TagNumber(19)
  void clearDialogNew() => $_clearField(19);
  @$pb.TagNumber(19)
  Update_DialogNew ensureDialogNew() => $_ensure(18);

  @$pb.TagNumber(20)
  Update_JoinRequestsChanged get joinRequests => $_getN(19);
  @$pb.TagNumber(20)
  set joinRequests(Update_JoinRequestsChanged value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasJoinRequests() => $_has(19);
  @$pb.TagNumber(20)
  void clearJoinRequests() => $_clearField(20);
  @$pb.TagNumber(20)
  Update_JoinRequestsChanged ensureJoinRequests() => $_ensure(19);

  @$pb.TagNumber(21)
  Update_MentionsChanged get mentions => $_getN(20);
  @$pb.TagNumber(21)
  set mentions(Update_MentionsChanged value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasMentions() => $_has(20);
  @$pb.TagNumber(21)
  void clearMentions() => $_clearField(21);
  @$pb.TagNumber(21)
  Update_MentionsChanged ensureMentions() => $_ensure(20);

  @$pb.TagNumber(22)
  Update_MessagePollChanged get messagePoll => $_getN(21);
  @$pb.TagNumber(22)
  set messagePoll(Update_MessagePollChanged value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasMessagePoll() => $_has(21);
  @$pb.TagNumber(22)
  void clearMessagePoll() => $_clearField(22);
  @$pb.TagNumber(22)
  Update_MessagePollChanged ensureMessagePoll() => $_ensure(21);

  @$pb.TagNumber(50)
  $fixnum.Int64 get chatPts => $_getI64(22);
  @$pb.TagNumber(50)
  set chatPts($fixnum.Int64 value) => $_setInt64(22, value);
  @$pb.TagNumber(50)
  $core.bool hasChatPts() => $_has(22);
  @$pb.TagNumber(50)
  void clearChatPts() => $_clearField(50);

  @$pb.TagNumber(51)
  $core.List<$core.int> get chatID => $_getN(23);
  @$pb.TagNumber(51)
  set chatID($core.List<$core.int> value) => $_setBytes(23, value);
  @$pb.TagNumber(51)
  $core.bool hasChatID() => $_has(23);
  @$pb.TagNumber(51)
  void clearChatID() => $_clearField(51);
}

/// UPDATES — push по стриму (сервер → клиент): одно или несколько обновлений
/// подряд. Ответ на запросы MESSAGES тоже несёт обновления, которые запрос
/// породил (клиент применяет их сразу, не дожидаясь push).
class Updates extends $pb.GeneratedMessage {
  factory Updates({
    $core.Iterable<Update>? updates,
    UpdatesState? state,
  }) {
    final result = create();
    if (updates != null) result.updates.addAll(updates);
    if (state != null) result.state = state;
    return result;
  }

  Updates._();

  factory Updates.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Updates.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Updates',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Update>(1, _omitFieldNames ? '' : 'updates', subBuilder: Update.create)
    ..aOM<UpdatesState>(2, _omitFieldNames ? '' : 'state', subBuilder: UpdatesState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Updates clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Updates copyWith(void Function(Updates) updates) => super.copyWith((message) => updates(message as Updates)) as Updates;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Updates create() => Updates._();
  @$core.override
  Updates createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Updates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Updates>(create);
  static Updates? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Update> get updates => $_getList(0);

  @$pb.TagNumber(2)
  UpdatesState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(UpdatesState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);
  @$pb.TagNumber(2)
  UpdatesState ensureState() => $_ensure(1);
}

/// Страница списка диалогов: по убыванию даты последнего сообщения.
class Chats_List extends $pb.GeneratedMessage {
  factory Chats_List({
    $fixnum.Int64? offsetDate,
    $core.List<$core.int>? offsetChatID,
    $core.int? limit,
  }) {
    final result = create();
    if (offsetDate != null) result.offsetDate = offsetDate;
    if (offsetChatID != null) result.offsetChatID = offsetChatID;
    if (limit != null) result.limit = limit;
    return result;
  }

  Chats_List._();

  factory Chats_List.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_List.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.List',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'offsetDate', protoName: 'offsetDate')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'offsetChatID', $pb.PbFieldType.OY, protoName: 'offsetChatID')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_List clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_List copyWith(void Function(Chats_List) updates) => super.copyWith((message) => updates(message as Chats_List)) as Chats_List;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_List create() => Chats_List._();
  @$core.override
  Chats_List createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_List getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_List>(create);
  static Chats_List? _defaultInstance;

  /// Курсор: дата последнего сообщения последнего диалога предыдущей
  /// страницы (unix millis) + его chatID; 0/пусто — с начала.
  @$pb.TagNumber(1)
  $fixnum.Int64 get offsetDate => $_getI64(0);
  @$pb.TagNumber(1)
  set offsetDate($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOffsetDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffsetDate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get offsetChatID => $_getN(1);
  @$pb.TagNumber(2)
  set offsetChatID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffsetChatID() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffsetChatID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class Chats_ListResult extends $pb.GeneratedMessage {
  factory Chats_ListResult({
    $core.Iterable<Dialog>? dialogs,
    $core.bool? hasMore,
    UpdatesState? state,
  }) {
    final result = create();
    if (dialogs != null) result.dialogs.addAll(dialogs);
    if (hasMore != null) result.hasMore = hasMore;
    if (state != null) result.state = state;
    return result;
  }

  Chats_ListResult._();

  factory Chats_ListResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ListResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ListResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Dialog>(1, _omitFieldNames ? '' : 'dialogs', subBuilder: Dialog.create)
    ..aOB(2, _omitFieldNames ? '' : 'hasMore', protoName: 'hasMore')
    ..aOM<UpdatesState>(3, _omitFieldNames ? '' : 'state', subBuilder: UpdatesState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ListResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ListResult copyWith(void Function(Chats_ListResult) updates) =>
      super.copyWith((message) => updates(message as Chats_ListResult)) as Chats_ListResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ListResult create() => Chats_ListResult._();
  @$core.override
  Chats_ListResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ListResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ListResult>(create);
  static Chats_ListResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Dialog> get dialogs => $_getList(0);

  /// Есть ещё страницы.
  @$pb.TagNumber(2)
  $core.bool get hasMore => $_getBF(1);
  @$pb.TagNumber(2)
  set hasMore($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);

  /// Текущий pts — после загрузки списка клиент догоняет от него.
  @$pb.TagNumber(3)
  UpdatesState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(UpdatesState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);
  @$pb.TagNumber(3)
  UpdatesState ensureState() => $_ensure(2);
}

/// Личный чат с пользователем: существующий или новый (создаётся сразу,
/// пустой; у собеседника появится с первым сообщением).
class Chats_OpenPrivate extends $pb.GeneratedMessage {
  factory Chats_OpenPrivate({
    $core.List<$core.int>? userID,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    return result;
  }

  Chats_OpenPrivate._();

  factory Chats_OpenPrivate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_OpenPrivate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.OpenPrivate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_OpenPrivate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_OpenPrivate copyWith(void Function(Chats_OpenPrivate) updates) =>
      super.copyWith((message) => updates(message as Chats_OpenPrivate)) as Chats_OpenPrivate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_OpenPrivate create() => Chats_OpenPrivate._();
  @$core.override
  Chats_OpenPrivate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_OpenPrivate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_OpenPrivate>(create);
  static Chats_OpenPrivate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);
}

class Chats_OpenPrivateResult extends $pb.GeneratedMessage {
  factory Chats_OpenPrivateResult({
    Dialog? dialog,
  }) {
    final result = create();
    if (dialog != null) result.dialog = dialog;
    return result;
  }

  Chats_OpenPrivateResult._();

  factory Chats_OpenPrivateResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_OpenPrivateResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.OpenPrivateResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Dialog>(1, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_OpenPrivateResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_OpenPrivateResult copyWith(void Function(Chats_OpenPrivateResult) updates) =>
      super.copyWith((message) => updates(message as Chats_OpenPrivateResult)) as Chats_OpenPrivateResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_OpenPrivateResult create() => Chats_OpenPrivateResult._();
  @$core.override
  Chats_OpenPrivateResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_OpenPrivateResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_OpenPrivateResult>(create);
  static Chats_OpenPrivateResult? _defaultInstance;

  @$pb.TagNumber(1)
  Dialog get dialog => $_getN(0);
  @$pb.TagNumber(1)
  set dialog(Dialog value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDialog() => $_has(0);
  @$pb.TagNumber(1)
  void clearDialog() => $_clearField(1);
  @$pb.TagNumber(1)
  Dialog ensureDialog() => $_ensure(0);
}

/// Прочитать входящие до maxID.
class Chats_ReadHistory extends $pb.GeneratedMessage {
  factory Chats_ReadHistory({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? maxID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (maxID != null) result.maxID = maxID;
    return result;
  }

  Chats_ReadHistory._();

  factory Chats_ReadHistory.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReadHistory.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReadHistory',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'maxID', protoName: 'maxID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadHistory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadHistory copyWith(void Function(Chats_ReadHistory) updates) =>
      super.copyWith((message) => updates(message as Chats_ReadHistory)) as Chats_ReadHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReadHistory create() => Chats_ReadHistory._();
  @$core.override
  Chats_ReadHistory createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReadHistory getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReadHistory>(create);
  static Chats_ReadHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxID => $_getI64(1);
  @$pb.TagNumber(2)
  set maxID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxID() => $_clearField(2);
}

class Chats_ReadHistoryResult extends $pb.GeneratedMessage {
  factory Chats_ReadHistoryResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_ReadHistoryResult._();

  factory Chats_ReadHistoryResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReadHistoryResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReadHistoryResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadHistoryResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadHistoryResult copyWith(void Function(Chats_ReadHistoryResult) updates) =>
      super.copyWith((message) => updates(message as Chats_ReadHistoryResult)) as Chats_ReadHistoryResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReadHistoryResult create() => Chats_ReadHistoryResult._();
  @$core.override
  Chats_ReadHistoryResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReadHistoryResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReadHistoryResult>(create);
  static Chats_ReadHistoryResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Мои настройки диалога. Отсутствующее поле — не менять. Закрепить, когда
/// в списке (без архива) уже 10 закреплённых, — FAILED_PRECONDITION
/// «pinnedLimit».
class Chats_SetDialog extends $pb.GeneratedMessage {
  factory Chats_SetDialog({
    $core.List<$core.int>? chatID,
    $core.bool? pinned,
    $core.bool? archived,
    $core.bool? markedUnread,
    $fixnum.Int64? mutedUntil,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (pinned != null) result.pinned = pinned;
    if (archived != null) result.archived = archived;
    if (markedUnread != null) result.markedUnread = markedUnread;
    if (mutedUntil != null) result.mutedUntil = mutedUntil;
    return result;
  }

  Chats_SetDialog._();

  factory Chats_SetDialog.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetDialog.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetDialog',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOB(2, _omitFieldNames ? '' : 'pinned')
    ..aOB(3, _omitFieldNames ? '' : 'archived')
    ..aOB(4, _omitFieldNames ? '' : 'markedUnread', protoName: 'markedUnread')
    ..aInt64(5, _omitFieldNames ? '' : 'mutedUntil', protoName: 'mutedUntil')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetDialog clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetDialog copyWith(void Function(Chats_SetDialog) updates) =>
      super.copyWith((message) => updates(message as Chats_SetDialog)) as Chats_SetDialog;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetDialog create() => Chats_SetDialog._();
  @$core.override
  Chats_SetDialog createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetDialog getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetDialog>(create);
  static Chats_SetDialog? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get pinned => $_getBF(1);
  @$pb.TagNumber(2)
  set pinned($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPinned() => $_has(1);
  @$pb.TagNumber(2)
  void clearPinned() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get archived => $_getBF(2);
  @$pb.TagNumber(3)
  set archived($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasArchived() => $_has(2);
  @$pb.TagNumber(3)
  void clearArchived() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get markedUnread => $_getBF(3);
  @$pb.TagNumber(4)
  set markedUnread($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMarkedUnread() => $_has(3);
  @$pb.TagNumber(4)
  void clearMarkedUnread() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get mutedUntil => $_getI64(4);
  @$pb.TagNumber(5)
  set mutedUntil($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMutedUntil() => $_has(4);
  @$pb.TagNumber(5)
  void clearMutedUntil() => $_clearField(5);
}

class Chats_SetDialogResult extends $pb.GeneratedMessage {
  factory Chats_SetDialogResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_SetDialogResult._();

  factory Chats_SetDialogResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetDialogResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetDialogResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetDialogResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetDialogResult copyWith(void Function(Chats_SetDialogResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SetDialogResult)) as Chats_SetDialogResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetDialogResult create() => Chats_SetDialogResult._();
  @$core.override
  Chats_SetDialogResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetDialogResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetDialogResult>(create);
  static Chats_SetDialogResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Удалить диалог у себя (очистить историю); forEveryone — у собеседника тоже.
class Chats_DeleteDialog extends $pb.GeneratedMessage {
  factory Chats_DeleteDialog({
    $core.List<$core.int>? chatID,
    $core.bool? forEveryone,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (forEveryone != null) result.forEveryone = forEveryone;
    return result;
  }

  Chats_DeleteDialog._();

  factory Chats_DeleteDialog.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteDialog.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteDialog',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOB(2, _omitFieldNames ? '' : 'forEveryone', protoName: 'forEveryone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteDialog clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteDialog copyWith(void Function(Chats_DeleteDialog) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteDialog)) as Chats_DeleteDialog;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteDialog create() => Chats_DeleteDialog._();
  @$core.override
  Chats_DeleteDialog createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteDialog getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteDialog>(create);
  static Chats_DeleteDialog? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get forEveryone => $_getBF(1);
  @$pb.TagNumber(2)
  set forEveryone($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasForEveryone() => $_has(1);
  @$pb.TagNumber(2)
  void clearForEveryone() => $_clearField(2);
}

class Chats_DeleteDialogResult extends $pb.GeneratedMessage {
  factory Chats_DeleteDialogResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_DeleteDialogResult._();

  factory Chats_DeleteDialogResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteDialogResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteDialogResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteDialogResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteDialogResult copyWith(void Function(Chats_DeleteDialogResult) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteDialogResult)) as Chats_DeleteDialogResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteDialogResult create() => Chats_DeleteDialogResult._();
  @$core.override
  Chats_DeleteDialogResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteDialogResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteDialogResult>(create);
  static Chats_DeleteDialogResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Когда собеседник прочитал моё сообщение (личный чат, ≤ 7 дней).
class Chats_ReadDate extends $pb.GeneratedMessage {
  factory Chats_ReadDate({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    return result;
  }

  Chats_ReadDate._();

  factory Chats_ReadDate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReadDate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReadDate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadDate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadDate copyWith(void Function(Chats_ReadDate) updates) =>
      super.copyWith((message) => updates(message as Chats_ReadDate)) as Chats_ReadDate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReadDate create() => Chats_ReadDate._();
  @$core.override
  Chats_ReadDate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReadDate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReadDate>(create);
  static Chats_ReadDate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);
}

class Chats_ReadDateResult extends $pb.GeneratedMessage {
  factory Chats_ReadDateResult({
    Chats_ReadDateResult_Status? status,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (date != null) result.date = date;
    return result;
  }

  Chats_ReadDateResult._();

  factory Chats_ReadDateResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReadDateResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReadDateResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<Chats_ReadDateResult_Status>(1, _omitFieldNames ? '' : 'status', enumValues: Chats_ReadDateResult_Status.values)
    ..aInt64(2, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadDateResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadDateResult copyWith(void Function(Chats_ReadDateResult) updates) =>
      super.copyWith((message) => updates(message as Chats_ReadDateResult)) as Chats_ReadDateResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReadDateResult create() => Chats_ReadDateResult._();
  @$core.override
  Chats_ReadDateResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReadDateResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReadDateResult>(create);
  static Chats_ReadDateResult? _defaultInstance;

  @$pb.TagNumber(1)
  Chats_ReadDateResult_Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(Chats_ReadDateResult_Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get date => $_getI64(1);
  @$pb.TagNumber(2)
  set date($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);
}

/// Могу ли я писать в чат (в личном — приватность собеседника «кто может мне
/// писать»). Окно чата спрашивает при открытии, чтобы заранее показать
/// плашку вместо поля ввода. Отправку всё равно проверяет сервер.
class Chats_CanWrite extends $pb.GeneratedMessage {
  factory Chats_CanWrite({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Chats_CanWrite._();

  factory Chats_CanWrite.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_CanWrite.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.CanWrite',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CanWrite clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CanWrite copyWith(void Function(Chats_CanWrite) updates) =>
      super.copyWith((message) => updates(message as Chats_CanWrite)) as Chats_CanWrite;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_CanWrite create() => Chats_CanWrite._();
  @$core.override
  Chats_CanWrite createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_CanWrite getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_CanWrite>(create);
  static Chats_CanWrite? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

class Chats_CanWriteResult extends $pb.GeneratedMessage {
  factory Chats_CanWriteResult({
    $core.bool? allowed,
  }) {
    final result = create();
    if (allowed != null) result.allowed = allowed;
    return result;
  }

  Chats_CanWriteResult._();

  factory Chats_CanWriteResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_CanWriteResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.CanWriteResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'allowed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CanWriteResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CanWriteResult copyWith(void Function(Chats_CanWriteResult) updates) =>
      super.copyWith((message) => updates(message as Chats_CanWriteResult)) as Chats_CanWriteResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_CanWriteResult create() => Chats_CanWriteResult._();
  @$core.override
  Chats_CanWriteResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_CanWriteResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_CanWriteResult>(create);
  static Chats_CanWriteResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get allowed => $_getBF(0);
  @$pb.TagNumber(1)
  set allowed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllowed() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllowed() => $_clearField(1);
}

/// Сохранить черновик (как saveDraft в Telegram; пусто — удалить). Уходит на
/// все мои устройства обновлением dialogSettings (Dialog.draft); отправка
/// сообщения в чат черновик удаляет. Тот же текст — без обновлений.
class Chats_SaveDraft extends $pb.GeneratedMessage {
  factory Chats_SaveDraft({
    $core.List<$core.int>? chatID,
    $core.String? text,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (text != null) result.text = text;
    return result;
  }

  Chats_SaveDraft._();

  factory Chats_SaveDraft.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SaveDraft.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SaveDraft',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveDraft clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveDraft copyWith(void Function(Chats_SaveDraft) updates) =>
      super.copyWith((message) => updates(message as Chats_SaveDraft)) as Chats_SaveDraft;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SaveDraft create() => Chats_SaveDraft._();
  @$core.override
  Chats_SaveDraft createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SaveDraft getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SaveDraft>(create);
  static Chats_SaveDraft? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
}

class Chats_SaveDraftResult extends $pb.GeneratedMessage {
  factory Chats_SaveDraftResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_SaveDraftResult._();

  factory Chats_SaveDraftResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SaveDraftResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SaveDraftResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveDraftResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveDraftResult copyWith(void Function(Chats_SaveDraftResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SaveDraftResult)) as Chats_SaveDraftResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SaveDraftResult create() => Chats_SaveDraftResult._();
  @$core.override
  Chats_SaveDraftResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SaveDraftResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SaveDraftResult>(create);
  static Chats_SaveDraftResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Папки: снимок — при первом входе и перезагрузке диалогов; изменения
/// приходят обновлением folders на все мои устройства.
class Chats_GetFolders extends $pb.GeneratedMessage {
  factory Chats_GetFolders() => create();

  Chats_GetFolders._();

  factory Chats_GetFolders.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_GetFolders.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.GetFolders',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetFolders clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetFolders copyWith(void Function(Chats_GetFolders) updates) =>
      super.copyWith((message) => updates(message as Chats_GetFolders)) as Chats_GetFolders;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_GetFolders create() => Chats_GetFolders._();
  @$core.override
  Chats_GetFolders createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_GetFolders getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_GetFolders>(create);
  static Chats_GetFolders? _defaultInstance;
}

class Chats_GetFoldersResult extends $pb.GeneratedMessage {
  factory Chats_GetFoldersResult({
    ChatFolders? folders,
  }) {
    final result = create();
    if (folders != null) result.folders = folders;
    return result;
  }

  Chats_GetFoldersResult._();

  factory Chats_GetFoldersResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_GetFoldersResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.GetFoldersResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatFolders>(1, _omitFieldNames ? '' : 'folders', subBuilder: ChatFolders.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetFoldersResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetFoldersResult copyWith(void Function(Chats_GetFoldersResult) updates) =>
      super.copyWith((message) => updates(message as Chats_GetFoldersResult)) as Chats_GetFoldersResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_GetFoldersResult create() => Chats_GetFoldersResult._();
  @$core.override
  Chats_GetFoldersResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_GetFoldersResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_GetFoldersResult>(create);
  static Chats_GetFoldersResult? _defaultInstance;

  @$pb.TagNumber(1)
  ChatFolders get folders => $_getN(0);
  @$pb.TagNumber(1)
  set folders(ChatFolders value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFolders() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolders() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatFolders ensureFolders() => $_ensure(0);
}

/// Создать (id = 0, в конец; не больше 9) или изменить папку. Нет такой
/// (удалили на другом устройстве) — NOT_FOUND; лимит — FAILED_PRECONDITION
/// «foldersLimit». Без изменений — без обновлений.
class Chats_SaveFolder extends $pb.GeneratedMessage {
  factory Chats_SaveFolder({
    ChatFolder? folder,
  }) {
    final result = create();
    if (folder != null) result.folder = folder;
    return result;
  }

  Chats_SaveFolder._();

  factory Chats_SaveFolder.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SaveFolder.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SaveFolder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatFolder>(1, _omitFieldNames ? '' : 'folder', subBuilder: ChatFolder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveFolder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveFolder copyWith(void Function(Chats_SaveFolder) updates) =>
      super.copyWith((message) => updates(message as Chats_SaveFolder)) as Chats_SaveFolder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SaveFolder create() => Chats_SaveFolder._();
  @$core.override
  Chats_SaveFolder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SaveFolder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SaveFolder>(create);
  static Chats_SaveFolder? _defaultInstance;

  @$pb.TagNumber(1)
  ChatFolder get folder => $_getN(0);
  @$pb.TagNumber(1)
  set folder(ChatFolder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFolder() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolder() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatFolder ensureFolder() => $_ensure(0);
}

class Chats_SaveFolderResult extends $pb.GeneratedMessage {
  factory Chats_SaveFolderResult({
    Updates? updates,
    $core.int? id,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    if (id != null) result.id = id;
    return result;
  }

  Chats_SaveFolderResult._();

  factory Chats_SaveFolderResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SaveFolderResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SaveFolderResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..aI(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveFolderResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveFolderResult copyWith(void Function(Chats_SaveFolderResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SaveFolderResult)) as Chats_SaveFolderResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SaveFolderResult create() => Chats_SaveFolderResult._();
  @$core.override
  Chats_SaveFolderResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SaveFolderResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SaveFolderResult>(create);
  static Chats_SaveFolderResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get id => $_getIZ(1);
  @$pb.TagNumber(2)
  set id($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

/// Удалить папку (уже нет — ничего).
class Chats_DeleteFolder extends $pb.GeneratedMessage {
  factory Chats_DeleteFolder({
    $core.int? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  Chats_DeleteFolder._();

  factory Chats_DeleteFolder.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteFolder.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteFolder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteFolder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteFolder copyWith(void Function(Chats_DeleteFolder) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteFolder)) as Chats_DeleteFolder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteFolder create() => Chats_DeleteFolder._();
  @$core.override
  Chats_DeleteFolder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteFolder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteFolder>(create);
  static Chats_DeleteFolder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class Chats_DeleteFolderResult extends $pb.GeneratedMessage {
  factory Chats_DeleteFolderResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_DeleteFolderResult._();

  factory Chats_DeleteFolderResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteFolderResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteFolderResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteFolderResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteFolderResult copyWith(void Function(Chats_DeleteFolderResult) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteFolderResult)) as Chats_DeleteFolderResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteFolderResult create() => Chats_DeleteFolderResult._();
  @$core.override
  Chats_DeleteFolderResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteFolderResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteFolderResult>(create);
  static Chats_DeleteFolderResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Новый порядок папок: ids — по порядку; не названные — в конец.
class Chats_ReorderFolders extends $pb.GeneratedMessage {
  factory Chats_ReorderFolders({
    $core.Iterable<$core.int>? ids,
  }) {
    final result = create();
    if (ids != null) result.ids.addAll(ids);
    return result;
  }

  Chats_ReorderFolders._();

  factory Chats_ReorderFolders.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReorderFolders.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReorderFolders',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.int>(1, _omitFieldNames ? '' : 'ids', $pb.PbFieldType.K3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReorderFolders clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReorderFolders copyWith(void Function(Chats_ReorderFolders) updates) =>
      super.copyWith((message) => updates(message as Chats_ReorderFolders)) as Chats_ReorderFolders;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReorderFolders create() => Chats_ReorderFolders._();
  @$core.override
  Chats_ReorderFolders createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReorderFolders getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReorderFolders>(create);
  static Chats_ReorderFolders? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get ids => $_getList(0);
}

class Chats_ReorderFoldersResult extends $pb.GeneratedMessage {
  factory Chats_ReorderFoldersResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_ReorderFoldersResult._();

  factory Chats_ReorderFoldersResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReorderFoldersResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReorderFoldersResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReorderFoldersResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReorderFoldersResult copyWith(void Function(Chats_ReorderFoldersResult) updates) =>
      super.copyWith((message) => updates(message as Chats_ReorderFoldersResult)) as Chats_ReorderFoldersResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReorderFoldersResult create() => Chats_ReorderFoldersResult._();
  @$core.override
  Chats_ReorderFoldersResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReorderFoldersResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReorderFoldersResult>(create);
  static Chats_ReorderFoldersResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Пользователь по имени (ссылка iperon.net/<username>, @username): его
/// личный чат со мной — существующий или новый (как openPrivate); своё имя
/// — «Избранное». Нет такого — NOT_FOUND. Свой лимит частоты (перебор
/// имён), новый чат — ещё и лимит openPrivate.
class Chats_ResolveUsername extends $pb.GeneratedMessage {
  factory Chats_ResolveUsername({
    $core.String? username,
  }) {
    final result = create();
    if (username != null) result.username = username;
    return result;
  }

  Chats_ResolveUsername._();

  factory Chats_ResolveUsername.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ResolveUsername.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ResolveUsername',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveUsername clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveUsername copyWith(void Function(Chats_ResolveUsername) updates) =>
      super.copyWith((message) => updates(message as Chats_ResolveUsername)) as Chats_ResolveUsername;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ResolveUsername create() => Chats_ResolveUsername._();
  @$core.override
  Chats_ResolveUsername createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ResolveUsername getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ResolveUsername>(create);
  static Chats_ResolveUsername? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);
}

class Chats_ResolveUsernameResult extends $pb.GeneratedMessage {
  factory Chats_ResolveUsernameResult({
    Dialog? dialog,
  }) {
    final result = create();
    if (dialog != null) result.dialog = dialog;
    return result;
  }

  Chats_ResolveUsernameResult._();

  factory Chats_ResolveUsernameResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ResolveUsernameResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ResolveUsernameResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Dialog>(1, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveUsernameResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveUsernameResult copyWith(void Function(Chats_ResolveUsernameResult) updates) =>
      super.copyWith((message) => updates(message as Chats_ResolveUsernameResult)) as Chats_ResolveUsernameResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ResolveUsernameResult create() => Chats_ResolveUsernameResult._();
  @$core.override
  Chats_ResolveUsernameResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ResolveUsernameResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ResolveUsernameResult>(create);
  static Chats_ResolveUsernameResult? _defaultInstance;

  @$pb.TagNumber(1)
  Dialog get dialog => $_getN(0);
  @$pb.TagNumber(1)
  set dialog(Dialog value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDialog() => $_has(0);
  @$pb.TagNumber(1)
  void clearDialog() => $_clearField(1);
  @$pb.TagNumber(1)
  Dialog ensureDialog() => $_ensure(0);
}

/// Автоудаление в чате (как messages.setHistoryTTL в Telegram): period —
/// секунды, 0 — выключить, иначе от суток до года, кратно суткам (иначе
/// INVALID_ARGUMENT «ttlInvalid»). Только личный чат с собеседником (в
/// «Избранном» — PERMISSION_DENIED); менять может любой из двоих, таймер
/// общий. В ленте — служебное MessageTTLChanged от изменившего, у обоих —
/// Update.dialogSettings с новым Dialog.ttlPeriod. Действует на сообщения,
/// отправленные после. Собеседник ограничил, кто может писать, —
/// PERMISSION_DENIED «privacyRestricted»; тот же таймер — без обновлений.
class Chats_SetTTL extends $pb.GeneratedMessage {
  factory Chats_SetTTL({
    $core.List<$core.int>? chatID,
    $core.int? period,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (period != null) result.period = period;
    return result;
  }

  Chats_SetTTL._();

  factory Chats_SetTTL.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetTTL.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetTTL',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aI(2, _omitFieldNames ? '' : 'period')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetTTL clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetTTL copyWith(void Function(Chats_SetTTL) updates) =>
      super.copyWith((message) => updates(message as Chats_SetTTL)) as Chats_SetTTL;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetTTL create() => Chats_SetTTL._();
  @$core.override
  Chats_SetTTL createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetTTL getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetTTL>(create);
  static Chats_SetTTL? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get period => $_getIZ(1);
  @$pb.TagNumber(2)
  set period($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriod() => $_clearField(2);
}

class Chats_SetTTLResult extends $pb.GeneratedMessage {
  factory Chats_SetTTLResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_SetTTLResult._();

  factory Chats_SetTTLResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetTTLResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetTTLResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetTTLResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetTTLResult copyWith(void Function(Chats_SetTTLResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SetTTLResult)) as Chats_SetTTLResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetTTLResult create() => Chats_SetTTLResult._();
  @$core.override
  Chats_SetTTLResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetTTLResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetTTLResult>(create);
  static Chats_SetTTLResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Защита содержимого в личном чате (как messages.toggleNoForwards в
/// Telegram; «Избранное» и группы — PERMISSION_DENIED, у группы —
/// EditChat.noForwards). enabled = true — включить
/// (уже включено кем угодно — без изменений). enabled = false: включил я —
/// выключить; включил собеседник — не выключается, а в ленту уходит запрос
/// MessageNoForwardsRequest. requestID — ответ включившего на запрос
/// (enabled = false — принять и выключить, true — отклонить и оставить):
/// всегда служебное MessageNoForwards с этим requestID; запрос не от
/// собеседника, уже отвеченный или старше суток — FAILED_PRECONDITION
/// «requestExpired». Изменение — служебное в ленту и Update.dialogSettings
/// обоим; собеседник ограничил, кто может писать, — PERMISSION_DENIED
/// «privacyRestricted».
class Chats_SetNoForwards extends $pb.GeneratedMessage {
  factory Chats_SetNoForwards({
    $core.List<$core.int>? chatID,
    $core.bool? enabled,
    $fixnum.Int64? requestID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (enabled != null) result.enabled = enabled;
    if (requestID != null) result.requestID = requestID;
    return result;
  }

  Chats_SetNoForwards._();

  factory Chats_SetNoForwards.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetNoForwards.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetNoForwards',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOB(2, _omitFieldNames ? '' : 'enabled')
    ..aInt64(3, _omitFieldNames ? '' : 'requestID', protoName: 'requestID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetNoForwards clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetNoForwards copyWith(void Function(Chats_SetNoForwards) updates) =>
      super.copyWith((message) => updates(message as Chats_SetNoForwards)) as Chats_SetNoForwards;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetNoForwards create() => Chats_SetNoForwards._();
  @$core.override
  Chats_SetNoForwards createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetNoForwards getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetNoForwards>(create);
  static Chats_SetNoForwards? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get enabled => $_getBF(1);
  @$pb.TagNumber(2)
  set enabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnabled() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get requestID => $_getI64(2);
  @$pb.TagNumber(3)
  set requestID($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestID() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestID() => $_clearField(3);
}

class Chats_SetNoForwardsResult extends $pb.GeneratedMessage {
  factory Chats_SetNoForwardsResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_SetNoForwardsResult._();

  factory Chats_SetNoForwardsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetNoForwardsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetNoForwardsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetNoForwardsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetNoForwardsResult copyWith(void Function(Chats_SetNoForwardsResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SetNoForwardsResult)) as Chats_SetNoForwardsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetNoForwardsResult create() => Chats_SetNoForwardsResult._();
  @$core.override
  Chats_SetNoForwardsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetNoForwardsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetNoForwardsResult>(create);
  static Chats_SetNoForwardsResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Глобальный поиск людей (как contacts.search / resolvePhone в Telegram).
/// query — номер телефона (целиком, в любом формате; без кода страны —
/// российский) или username (ведущий «@» не важен, регистр тоже). Номер —
/// точное совпадение, если владелец разрешает найти себя по номеру
/// (PrivacySettings.phone_number_find), — номер в ответе тогда есть всегда
/// (ищущий его знает). Username — точное совпадение и по префиксу (от 3
/// символов), до limit (≤ 50, 0 — 20) человек. Себя в ответе нет. Профили —
/// глазами ищущего (гейты приватности, как PROFILE). Свои лимиты частоты
/// (по номеру — строже); короче / не подходит — пустой ответ.
class Chats_SearchUsers extends $pb.GeneratedMessage {
  factory Chats_SearchUsers({
    $core.String? query,
    $core.int? limit,
  }) {
    final result = create();
    if (query != null) result.query = query;
    if (limit != null) result.limit = limit;
    return result;
  }

  Chats_SearchUsers._();

  factory Chats_SearchUsers.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SearchUsers.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SearchUsers',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SearchUsers clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SearchUsers copyWith(void Function(Chats_SearchUsers) updates) =>
      super.copyWith((message) => updates(message as Chats_SearchUsers)) as Chats_SearchUsers;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SearchUsers create() => Chats_SearchUsers._();
  @$core.override
  Chats_SearchUsers createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SearchUsers getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SearchUsers>(create);
  static Chats_SearchUsers? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class Chats_SearchUsersResult extends $pb.GeneratedMessage {
  factory Chats_SearchUsersResult({
    $core.Iterable<$1.Profile_Response>? profiles,
  }) {
    final result = create();
    if (profiles != null) result.profiles.addAll(profiles);
    return result;
  }

  Chats_SearchUsersResult._();

  factory Chats_SearchUsersResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SearchUsersResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SearchUsersResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<$1.Profile_Response>(1, _omitFieldNames ? '' : 'profiles', subBuilder: $1.Profile_Response.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SearchUsersResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SearchUsersResult copyWith(void Function(Chats_SearchUsersResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SearchUsersResult)) as Chats_SearchUsersResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SearchUsersResult create() => Chats_SearchUsersResult._();
  @$core.override
  Chats_SearchUsersResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SearchUsersResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SearchUsersResult>(create);
  static Chats_SearchUsersResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Profile_Response> get profiles => $_getList(0);
}

/// Глобальный поиск публичных чатов (как contacts.search в Telegram —
/// группы рядом с людьми). Только публичные (группы OPEN; каналы — когда
/// появятся, тип — в ChatInfo.type), частные и удалённые не находятся.
/// query — слова названия по началу (регистр и ё/е не важны, все слова
/// запроса должны совпасть) или username по префиксу (ведущий «@» — только
/// по username). Короче 2 символов — пустой ответ. По убыванию числа
/// участников, до limit (≤ 50, 0 — 20). Свой лимит частоты.
class Chats_SearchChats extends $pb.GeneratedMessage {
  factory Chats_SearchChats({
    $core.String? query,
    $core.int? limit,
  }) {
    final result = create();
    if (query != null) result.query = query;
    if (limit != null) result.limit = limit;
    return result;
  }

  Chats_SearchChats._();

  factory Chats_SearchChats.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SearchChats.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SearchChats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SearchChats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SearchChats copyWith(void Function(Chats_SearchChats) updates) =>
      super.copyWith((message) => updates(message as Chats_SearchChats)) as Chats_SearchChats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SearchChats create() => Chats_SearchChats._();
  @$core.override
  Chats_SearchChats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SearchChats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SearchChats>(create);
  static Chats_SearchChats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

/// Найденный чат: chat — без pts, avatar — со ссылкой на скачивание; member
/// — я участник (открыть диалог), иначе — предпросмотр (ResolveLink по
/// chat.username) и вступление (JoinChat). Заблокированный в группе её
/// тоже находит (как в Telegram), вступить не может («banned»).
class Chats_FoundChat extends $pb.GeneratedMessage {
  factory Chats_FoundChat({
    ChatInfo? chat,
    $core.bool? member,
  }) {
    final result = create();
    if (chat != null) result.chat = chat;
    if (member != null) result.member = member;
    return result;
  }

  Chats_FoundChat._();

  factory Chats_FoundChat.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_FoundChat.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.FoundChat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatInfo>(1, _omitFieldNames ? '' : 'chat', subBuilder: ChatInfo.create)
    ..aOB(2, _omitFieldNames ? '' : 'member')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_FoundChat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_FoundChat copyWith(void Function(Chats_FoundChat) updates) =>
      super.copyWith((message) => updates(message as Chats_FoundChat)) as Chats_FoundChat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_FoundChat create() => Chats_FoundChat._();
  @$core.override
  Chats_FoundChat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_FoundChat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_FoundChat>(create);
  static Chats_FoundChat? _defaultInstance;

  @$pb.TagNumber(1)
  ChatInfo get chat => $_getN(0);
  @$pb.TagNumber(1)
  set chat(ChatInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChat() => $_has(0);
  @$pb.TagNumber(1)
  void clearChat() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatInfo ensureChat() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get member => $_getBF(1);
  @$pb.TagNumber(2)
  set member($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMember() => $_has(1);
  @$pb.TagNumber(2)
  void clearMember() => $_clearField(2);
}

class Chats_SearchChatsResult extends $pb.GeneratedMessage {
  factory Chats_SearchChatsResult({
    $core.Iterable<Chats_FoundChat>? chats,
  }) {
    final result = create();
    if (chats != null) result.chats.addAll(chats);
    return result;
  }

  Chats_SearchChatsResult._();

  factory Chats_SearchChatsResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SearchChatsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SearchChatsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Chats_FoundChat>(1, _omitFieldNames ? '' : 'chats', subBuilder: Chats_FoundChat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SearchChatsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SearchChatsResult copyWith(void Function(Chats_SearchChatsResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SearchChatsResult)) as Chats_SearchChatsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SearchChatsResult create() => Chats_SearchChatsResult._();
  @$core.override
  Chats_SearchChatsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SearchChatsResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SearchChatsResult>(create);
  static Chats_SearchChatsResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Chats_FoundChat> get chats => $_getList(0);
}

/// Создать группу (как messages.createChat в Telegram): я — владелец,
/// memberUserIDs — участники (≤ 200, без меня), роль у них WRITER. Кого
/// нельзя добавить по его приватности «кто может добавлять меня в группы»
/// (или заблокировал меня) — в restrictedUserIDs, группа создаётся без них.
/// title — 1..128 символов (иначе INVALID_ARGUMENT «titleInvalid»), about ≤ 255.
/// avatarCdnID — загружен мной заранее (иначе PERMISSION_DENIED). randomID —
/// идемпотентность: повтор (обрыв связи) вернёт уже созданную. В ленте —
/// служебные CREATED и ADDED; участникам — Update.dialogNew. Лимит частоты
/// «создать чат».
///
/// joinMode (по умолчанию LINK) и username (только при OPEN, обязателен;
/// занят — FAILED_PRECONDITION «usernameTaken», не по правилам —
/// INVALID_ARGUMENT «usernameInvalid»); у не-OPEN сервер сразу выдаёт
/// основную ссылку-приглашение (Dialog.inviteCode).
class Chats_CreateGroup extends $pb.GeneratedMessage {
  factory Chats_CreateGroup({
    $core.String? title,
    $core.String? about,
    $core.Iterable<$core.List<$core.int>>? memberUserIDs,
    $core.List<$core.int>? avatarCdnID,
    $fixnum.Int64? randomID,
    $core.String? username,
    ChatJoinMode? joinMode,
    $core.bool? historyHidden,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (about != null) result.about = about;
    if (memberUserIDs != null) result.memberUserIDs.addAll(memberUserIDs);
    if (avatarCdnID != null) result.avatarCdnID = avatarCdnID;
    if (randomID != null) result.randomID = randomID;
    if (username != null) result.username = username;
    if (joinMode != null) result.joinMode = joinMode;
    if (historyHidden != null) result.historyHidden = historyHidden;
    return result;
  }

  Chats_CreateGroup._();

  factory Chats_CreateGroup.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_CreateGroup.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.CreateGroup',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'about')
    ..p<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'memberUserIDs', $pb.PbFieldType.PY, protoName: 'memberUserIDs')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'avatarCdnID', $pb.PbFieldType.OY, protoName: 'avatarCdnID')
    ..aInt64(5, _omitFieldNames ? '' : 'randomID', protoName: 'randomID')
    ..aOS(6, _omitFieldNames ? '' : 'username')
    ..aE<ChatJoinMode>(7, _omitFieldNames ? '' : 'joinMode', protoName: 'joinMode', enumValues: ChatJoinMode.values)
    ..aOB(8, _omitFieldNames ? '' : 'historyHidden', protoName: 'historyHidden')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CreateGroup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CreateGroup copyWith(void Function(Chats_CreateGroup) updates) =>
      super.copyWith((message) => updates(message as Chats_CreateGroup)) as Chats_CreateGroup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_CreateGroup create() => Chats_CreateGroup._();
  @$core.override
  Chats_CreateGroup createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_CreateGroup getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_CreateGroup>(create);
  static Chats_CreateGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get about => $_getSZ(1);
  @$pb.TagNumber(2)
  set about($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAbout() => $_has(1);
  @$pb.TagNumber(2)
  void clearAbout() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.List<$core.int>> get memberUserIDs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$core.int> get avatarCdnID => $_getN(3);
  @$pb.TagNumber(4)
  set avatarCdnID($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvatarCdnID() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvatarCdnID() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get randomID => $_getI64(4);
  @$pb.TagNumber(5)
  set randomID($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRandomID() => $_has(4);
  @$pb.TagNumber(5)
  void clearRandomID() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get username => $_getSZ(5);
  @$pb.TagNumber(6)
  set username($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUsername() => $_has(5);
  @$pb.TagNumber(6)
  void clearUsername() => $_clearField(6);

  @$pb.TagNumber(7)
  ChatJoinMode get joinMode => $_getN(6);
  @$pb.TagNumber(7)
  set joinMode(ChatJoinMode value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasJoinMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearJoinMode() => $_clearField(7);

  /// «Скрыть историю» (как EditChat.historyHidden: при OPEN —
  /// INVALID_ARGUMENT).
  @$pb.TagNumber(8)
  $core.bool get historyHidden => $_getBF(7);
  @$pb.TagNumber(8)
  set historyHidden($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHistoryHidden() => $_has(7);
  @$pb.TagNumber(8)
  void clearHistoryHidden() => $_clearField(8);
}

class Chats_CreateGroupResult extends $pb.GeneratedMessage {
  factory Chats_CreateGroupResult({
    Dialog? dialog,
    $core.Iterable<$core.List<$core.int>>? restrictedUserIDs,
    Updates? updates,
  }) {
    final result = create();
    if (dialog != null) result.dialog = dialog;
    if (restrictedUserIDs != null) result.restrictedUserIDs.addAll(restrictedUserIDs);
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_CreateGroupResult._();

  factory Chats_CreateGroupResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_CreateGroupResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.CreateGroupResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Dialog>(1, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..p<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'restrictedUserIDs', $pb.PbFieldType.PY, protoName: 'restrictedUserIDs')
    ..aOM<Updates>(3, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CreateGroupResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CreateGroupResult copyWith(void Function(Chats_CreateGroupResult) updates) =>
      super.copyWith((message) => updates(message as Chats_CreateGroupResult)) as Chats_CreateGroupResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_CreateGroupResult create() => Chats_CreateGroupResult._();
  @$core.override
  Chats_CreateGroupResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_CreateGroupResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_CreateGroupResult>(create);
  static Chats_CreateGroupResult? _defaultInstance;

  @$pb.TagNumber(1)
  Dialog get dialog => $_getN(0);
  @$pb.TagNumber(1)
  set dialog(Dialog value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDialog() => $_has(0);
  @$pb.TagNumber(1)
  void clearDialog() => $_clearField(1);
  @$pb.TagNumber(1)
  Dialog ensureDialog() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.List<$core.int>> get restrictedUserIDs => $_getList(1);

  @$pb.TagNumber(3)
  Updates get updates => $_getN(2);
  @$pb.TagNumber(3)
  set updates(Updates value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpdates() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdates() => $_clearField(3);
  @$pb.TagNumber(3)
  Updates ensureUpdates() => $_ensure(2);
}

/// Изменить группу (владелец или админ с changeInfo, иначе
/// PERMISSION_DENIED): отсутствующее поле — не менять; avatarCdnID пустой —
/// удалить фото; defaultRole — READER или WRITER (иначе INVALID_ARGUMENT),
/// касается вступающих после. Смена названия / фото — служебное в ленту;
/// всем — Update.chatInfo. Без изменений — без обновлений.
///
/// joinMode / username / historyHidden — право changeInfo. OPEN требует
/// username (вместе или уже заданный), уход из OPEN освобождает его (и
/// убирает из поиска публичных); username при не-OPEN — INVALID_ARGUMENT.
/// historyHidden при OPEN — INVALID_ARGUMENT. Переход в не-OPEN без основной
/// ссылки — сервер её выдаёт. Ошибки имени — как в CreateGroup.
///
/// Подэтап 3.4 (право changeInfo): slowMode — только из ChatInfo.slowMode,
/// newcomerMediaDelay ≥ 0 (≤ 7 суток), membersHidden, reactions — режим и
/// набор (SOME — 1..allChatReactions, без повторов, только из общего набора;
/// иначе INVALID_ARGUMENT).
///
/// noForwards (право changeInfo) — защита содержимого группы, без запросов
/// «разрешить» (они только в личных, Chats.SetNoForwards).
class Chats_EditChat extends $pb.GeneratedMessage {
  factory Chats_EditChat({
    $core.List<$core.int>? chatID,
    $core.String? title,
    $core.String? about,
    $core.List<$core.int>? avatarCdnID,
    ChatRole? defaultRole,
    $core.String? username,
    ChatJoinMode? joinMode,
    $core.bool? historyHidden,
    $core.int? slowMode,
    $core.int? newcomerMediaDelay,
    $core.bool? membersHidden,
    Chats_ChatReactionsSettings? reactions,
    $core.bool? noForwards,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (title != null) result.title = title;
    if (about != null) result.about = about;
    if (avatarCdnID != null) result.avatarCdnID = avatarCdnID;
    if (defaultRole != null) result.defaultRole = defaultRole;
    if (username != null) result.username = username;
    if (joinMode != null) result.joinMode = joinMode;
    if (historyHidden != null) result.historyHidden = historyHidden;
    if (slowMode != null) result.slowMode = slowMode;
    if (newcomerMediaDelay != null) result.newcomerMediaDelay = newcomerMediaDelay;
    if (membersHidden != null) result.membersHidden = membersHidden;
    if (reactions != null) result.reactions = reactions;
    if (noForwards != null) result.noForwards = noForwards;
    return result;
  }

  Chats_EditChat._();

  factory Chats_EditChat.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_EditChat.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.EditChat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'about')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'avatarCdnID', $pb.PbFieldType.OY, protoName: 'avatarCdnID')
    ..aE<ChatRole>(5, _omitFieldNames ? '' : 'defaultRole', protoName: 'defaultRole', enumValues: ChatRole.values)
    ..aOS(6, _omitFieldNames ? '' : 'username')
    ..aE<ChatJoinMode>(7, _omitFieldNames ? '' : 'joinMode', protoName: 'joinMode', enumValues: ChatJoinMode.values)
    ..aOB(8, _omitFieldNames ? '' : 'historyHidden', protoName: 'historyHidden')
    ..aI(9, _omitFieldNames ? '' : 'slowMode', protoName: 'slowMode')
    ..aI(10, _omitFieldNames ? '' : 'newcomerMediaDelay', protoName: 'newcomerMediaDelay')
    ..aOB(11, _omitFieldNames ? '' : 'membersHidden', protoName: 'membersHidden')
    ..aOM<Chats_ChatReactionsSettings>(12, _omitFieldNames ? '' : 'reactions', subBuilder: Chats_ChatReactionsSettings.create)
    ..aOB(13, _omitFieldNames ? '' : 'noForwards', protoName: 'noForwards')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_EditChat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_EditChat copyWith(void Function(Chats_EditChat) updates) =>
      super.copyWith((message) => updates(message as Chats_EditChat)) as Chats_EditChat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_EditChat create() => Chats_EditChat._();
  @$core.override
  Chats_EditChat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_EditChat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_EditChat>(create);
  static Chats_EditChat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get about => $_getSZ(2);
  @$pb.TagNumber(3)
  set about($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAbout() => $_has(2);
  @$pb.TagNumber(3)
  void clearAbout() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get avatarCdnID => $_getN(3);
  @$pb.TagNumber(4)
  set avatarCdnID($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvatarCdnID() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvatarCdnID() => $_clearField(4);

  @$pb.TagNumber(5)
  ChatRole get defaultRole => $_getN(4);
  @$pb.TagNumber(5)
  set defaultRole(ChatRole value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDefaultRole() => $_has(4);
  @$pb.TagNumber(5)
  void clearDefaultRole() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get username => $_getSZ(5);
  @$pb.TagNumber(6)
  set username($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUsername() => $_has(5);
  @$pb.TagNumber(6)
  void clearUsername() => $_clearField(6);

  @$pb.TagNumber(7)
  ChatJoinMode get joinMode => $_getN(6);
  @$pb.TagNumber(7)
  set joinMode(ChatJoinMode value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasJoinMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearJoinMode() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get historyHidden => $_getBF(7);
  @$pb.TagNumber(8)
  set historyHidden($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHistoryHidden() => $_has(7);
  @$pb.TagNumber(8)
  void clearHistoryHidden() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get slowMode => $_getIZ(8);
  @$pb.TagNumber(9)
  set slowMode($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSlowMode() => $_has(8);
  @$pb.TagNumber(9)
  void clearSlowMode() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get newcomerMediaDelay => $_getIZ(9);
  @$pb.TagNumber(10)
  set newcomerMediaDelay($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNewcomerMediaDelay() => $_has(9);
  @$pb.TagNumber(10)
  void clearNewcomerMediaDelay() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get membersHidden => $_getBF(10);
  @$pb.TagNumber(11)
  set membersHidden($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMembersHidden() => $_has(10);
  @$pb.TagNumber(11)
  void clearMembersHidden() => $_clearField(11);

  @$pb.TagNumber(12)
  Chats_ChatReactionsSettings get reactions => $_getN(11);
  @$pb.TagNumber(12)
  set reactions(Chats_ChatReactionsSettings value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasReactions() => $_has(11);
  @$pb.TagNumber(12)
  void clearReactions() => $_clearField(12);
  @$pb.TagNumber(12)
  Chats_ChatReactionsSettings ensureReactions() => $_ensure(11);

  /// «Запретить копирование» (право changeInfo, ChatInfo.noForwards).
  @$pb.TagNumber(13)
  $core.bool get noForwards => $_getBF(12);
  @$pb.TagNumber(13)
  set noForwards($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasNoForwards() => $_has(12);
  @$pb.TagNumber(13)
  void clearNoForwards() => $_clearField(13);
}

class Chats_ChatReactionsSettings extends $pb.GeneratedMessage {
  factory Chats_ChatReactionsSettings({
    ChatReactionsMode? mode,
    $core.Iterable<$core.String>? emojis,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    if (emojis != null) result.emojis.addAll(emojis);
    return result;
  }

  Chats_ChatReactionsSettings._();

  factory Chats_ChatReactionsSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ChatReactionsSettings.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ChatReactionsSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<ChatReactionsMode>(1, _omitFieldNames ? '' : 'mode', enumValues: ChatReactionsMode.values)
    ..pPS(2, _omitFieldNames ? '' : 'emojis')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ChatReactionsSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ChatReactionsSettings copyWith(void Function(Chats_ChatReactionsSettings) updates) =>
      super.copyWith((message) => updates(message as Chats_ChatReactionsSettings)) as Chats_ChatReactionsSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ChatReactionsSettings create() => Chats_ChatReactionsSettings._();
  @$core.override
  Chats_ChatReactionsSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ChatReactionsSettings getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ChatReactionsSettings>(create);
  static Chats_ChatReactionsSettings? _defaultInstance;

  @$pb.TagNumber(1)
  ChatReactionsMode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode(ChatReactionsMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get emojis => $_getList(1);
}

class Chats_EditChatResult extends $pb.GeneratedMessage {
  factory Chats_EditChatResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_EditChatResult._();

  factory Chats_EditChatResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_EditChatResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.EditChatResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_EditChatResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_EditChatResult copyWith(void Function(Chats_EditChatResult) updates) =>
      super.copyWith((message) => updates(message as Chats_EditChatResult)) as Chats_EditChatResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_EditChatResult create() => Chats_EditChatResult._();
  @$core.override
  Chats_EditChatResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_EditChatResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_EditChatResult>(create);
  static Chats_EditChatResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Добавить участников (≤ 200 за раз) с ролью по умолчанию: любой участник,
/// а в режиме ADMINS — только владелец / админ с inviteUsers. Уже состоящие пропускаются; кому нельзя по
/// приватности — restrictedUserIDs. Заблокированных в группе может добавить
/// только админ с banUsers (они разблокируются), остальным — restricted.
/// Группа заполнена (200 000) — FAILED_PRECONDITION «membersLimit».
class Chats_AddMembers extends $pb.GeneratedMessage {
  factory Chats_AddMembers({
    $core.List<$core.int>? chatID,
    $core.Iterable<$core.List<$core.int>>? userIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  Chats_AddMembers._();

  factory Chats_AddMembers.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_AddMembers.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.AddMembers',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'userIDs', $pb.PbFieldType.PY, protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_AddMembers clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_AddMembers copyWith(void Function(Chats_AddMembers) updates) =>
      super.copyWith((message) => updates(message as Chats_AddMembers)) as Chats_AddMembers;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_AddMembers create() => Chats_AddMembers._();
  @$core.override
  Chats_AddMembers createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_AddMembers getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_AddMembers>(create);
  static Chats_AddMembers? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.List<$core.int>> get userIDs => $_getList(1);
}

class Chats_AddMembersResult extends $pb.GeneratedMessage {
  factory Chats_AddMembersResult({
    $core.Iterable<$core.List<$core.int>>? restrictedUserIDs,
    Updates? updates,
  }) {
    final result = create();
    if (restrictedUserIDs != null) result.restrictedUserIDs.addAll(restrictedUserIDs);
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_AddMembersResult._();

  factory Chats_AddMembersResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_AddMembersResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.AddMembersResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'restrictedUserIDs', $pb.PbFieldType.PY, protoName: 'restrictedUserIDs')
    ..aOM<Updates>(2, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_AddMembersResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_AddMembersResult copyWith(void Function(Chats_AddMembersResult) updates) =>
      super.copyWith((message) => updates(message as Chats_AddMembersResult)) as Chats_AddMembersResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_AddMembersResult create() => Chats_AddMembersResult._();
  @$core.override
  Chats_AddMembersResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_AddMembersResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_AddMembersResult>(create);
  static Chats_AddMembersResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get restrictedUserIDs => $_getList(0);

  @$pb.TagNumber(2)
  Updates get updates => $_getN(1);
  @$pb.TagNumber(2)
  set updates(Updates value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdates() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdates() => $_clearField(2);
  @$pb.TagNumber(2)
  Updates ensureUpdates() => $_ensure(1);
}

/// Выйти из группы (как leaveChannel): служебное LEFT, у меня —
/// dialogDeleted. Владелец выйти не может, пока не передал владение (3.2) —
/// FAILED_PRECONDITION «ownerCannotLeave»; он может удалить группу.
class Chats_LeaveChat extends $pb.GeneratedMessage {
  factory Chats_LeaveChat({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Chats_LeaveChat._();

  factory Chats_LeaveChat.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_LeaveChat.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.LeaveChat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_LeaveChat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_LeaveChat copyWith(void Function(Chats_LeaveChat) updates) =>
      super.copyWith((message) => updates(message as Chats_LeaveChat)) as Chats_LeaveChat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_LeaveChat create() => Chats_LeaveChat._();
  @$core.override
  Chats_LeaveChat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_LeaveChat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_LeaveChat>(create);
  static Chats_LeaveChat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

class Chats_LeaveChatResult extends $pb.GeneratedMessage {
  factory Chats_LeaveChatResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_LeaveChatResult._();

  factory Chats_LeaveChatResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_LeaveChatResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.LeaveChatResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_LeaveChatResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_LeaveChatResult copyWith(void Function(Chats_LeaveChatResult) updates) =>
      super.copyWith((message) => updates(message as Chats_LeaveChatResult)) as Chats_LeaveChatResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_LeaveChatResult create() => Chats_LeaveChatResult._();
  @$core.override
  Chats_LeaveChatResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_LeaveChatResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_LeaveChatResult>(create);
  static Chats_LeaveChatResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Удалить группу у всех (только владелец, иначе PERMISSION_DENIED): у всех
/// участников — dialogDeleted, сообщения и журнал чата удаляются.
class Chats_DeleteChat extends $pb.GeneratedMessage {
  factory Chats_DeleteChat({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Chats_DeleteChat._();

  factory Chats_DeleteChat.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteChat.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteChat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteChat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteChat copyWith(void Function(Chats_DeleteChat) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteChat)) as Chats_DeleteChat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteChat create() => Chats_DeleteChat._();
  @$core.override
  Chats_DeleteChat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteChat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteChat>(create);
  static Chats_DeleteChat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

class Chats_DeleteChatResult extends $pb.GeneratedMessage {
  factory Chats_DeleteChatResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_DeleteChatResult._();

  factory Chats_DeleteChatResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteChatResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteChatResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteChatResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteChatResult copyWith(void Function(Chats_DeleteChatResult) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteChatResult)) as Chats_DeleteChatResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteChatResult create() => Chats_DeleteChatResult._();
  @$core.override
  Chats_DeleteChatResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteChatResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteChatResult>(create);
  static Chats_DeleteChatResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Участники группы — страница по дате вступления (владелец первым). При
/// ChatInfo.membersHidden не-админу — только владелец и админы.
/// offset — курсор из прошлого ответа (пусто — с начала). profiles — профили
/// участников страницы глазами запросившего (гейты приватности, как PROFILE).
///
/// query (подэтап 3.5) — поиск участников: «@имя» — по началу username;
/// иначе слова запроса — по началам слов имени и фамилии в профиле (слепой
/// индекс на сервере, регистр и ё/е не важны, все слова должны совпасть).
/// С query порядок тот же (по дате вступления), total — 0 (неизвестно).
/// При membersHidden не-админ ищет только среди владельца и админов.
class Chats_Members extends $pb.GeneratedMessage {
  factory Chats_Members({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? offset,
    $core.int? limit,
    $core.String? query,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (offset != null) result.offset = offset;
    if (limit != null) result.limit = limit;
    if (query != null) result.query = query;
    return result;
  }

  Chats_Members._();

  factory Chats_Members.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_Members.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.Members',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OY)
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..aOS(4, _omitFieldNames ? '' : 'query')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Members clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Members copyWith(void Function(Chats_Members) updates) =>
      super.copyWith((message) => updates(message as Chats_Members)) as Chats_Members;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_Members create() => Chats_Members._();
  @$core.override
  Chats_Members createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_Members getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_Members>(create);
  static Chats_Members? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get offset => $_getN(1);
  @$pb.TagNumber(2)
  set offset($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get query => $_getSZ(3);
  @$pb.TagNumber(4)
  set query($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuery() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuery() => $_clearField(4);
}

class Chats_MembersResult extends $pb.GeneratedMessage {
  factory Chats_MembersResult({
    $core.Iterable<ChatMember>? members,
    $core.Iterable<$1.Profile_Response>? profiles,
    $core.List<$core.int>? nextOffset,
    $core.int? total,
  }) {
    final result = create();
    if (members != null) result.members.addAll(members);
    if (profiles != null) result.profiles.addAll(profiles);
    if (nextOffset != null) result.nextOffset = nextOffset;
    if (total != null) result.total = total;
    return result;
  }

  Chats_MembersResult._();

  factory Chats_MembersResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_MembersResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.MembersResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatMember>(1, _omitFieldNames ? '' : 'members', subBuilder: ChatMember.create)
    ..pPM<$1.Profile_Response>(2, _omitFieldNames ? '' : 'profiles', subBuilder: $1.Profile_Response.create)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'nextOffset', $pb.PbFieldType.OY, protoName: 'nextOffset')
    ..aI(4, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_MembersResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_MembersResult copyWith(void Function(Chats_MembersResult) updates) =>
      super.copyWith((message) => updates(message as Chats_MembersResult)) as Chats_MembersResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_MembersResult create() => Chats_MembersResult._();
  @$core.override
  Chats_MembersResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_MembersResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_MembersResult>(create);
  static Chats_MembersResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatMember> get members => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$1.Profile_Response> get profiles => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get nextOffset => $_getN(2);
  @$pb.TagNumber(3)
  set nextOffset($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNextOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextOffset() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get total => $_getIZ(3);
  @$pb.TagNumber(4)
  set total($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotal() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotal() => $_clearField(4);
}

/// Состояние журналов моих групп (после подключения): chats — какие знает
/// клиент и до какого chatPts. В ответе changed — те, где на сервере pts
/// больше (с текущим pts), их догоняют GetChatDifference; gone — где я больше
/// не участник (группа удалена, исключили). Не названные клиентом группы
/// приходят через журнал пользователя (dialogNew).
class Chats_GetChatsState extends $pb.GeneratedMessage {
  factory Chats_GetChatsState({
    $core.Iterable<Chats_ChatPts>? chats,
  }) {
    final result = create();
    if (chats != null) result.chats.addAll(chats);
    return result;
  }

  Chats_GetChatsState._();

  factory Chats_GetChatsState.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_GetChatsState.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.GetChatsState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Chats_ChatPts>(1, _omitFieldNames ? '' : 'chats', subBuilder: Chats_ChatPts.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetChatsState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetChatsState copyWith(void Function(Chats_GetChatsState) updates) =>
      super.copyWith((message) => updates(message as Chats_GetChatsState)) as Chats_GetChatsState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_GetChatsState create() => Chats_GetChatsState._();
  @$core.override
  Chats_GetChatsState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_GetChatsState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_GetChatsState>(create);
  static Chats_GetChatsState? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Chats_ChatPts> get chats => $_getList(0);
}

class Chats_ChatPts extends $pb.GeneratedMessage {
  factory Chats_ChatPts({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? pts,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (pts != null) result.pts = pts;
    return result;
  }

  Chats_ChatPts._();

  factory Chats_ChatPts.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ChatPts.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ChatPts',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'pts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ChatPts clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ChatPts copyWith(void Function(Chats_ChatPts) updates) =>
      super.copyWith((message) => updates(message as Chats_ChatPts)) as Chats_ChatPts;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ChatPts create() => Chats_ChatPts._();
  @$core.override
  Chats_ChatPts createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ChatPts getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ChatPts>(create);
  static Chats_ChatPts? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get pts => $_getI64(1);
  @$pb.TagNumber(2)
  set pts($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPts() => $_has(1);
  @$pb.TagNumber(2)
  void clearPts() => $_clearField(2);
}

class Chats_GetChatsStateResult extends $pb.GeneratedMessage {
  factory Chats_GetChatsStateResult({
    $core.Iterable<Chats_ChatPts>? changed,
    $core.Iterable<$core.List<$core.int>>? gone,
  }) {
    final result = create();
    if (changed != null) result.changed.addAll(changed);
    if (gone != null) result.gone.addAll(gone);
    return result;
  }

  Chats_GetChatsStateResult._();

  factory Chats_GetChatsStateResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_GetChatsStateResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.GetChatsStateResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Chats_ChatPts>(1, _omitFieldNames ? '' : 'changed', subBuilder: Chats_ChatPts.create)
    ..p<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'gone', $pb.PbFieldType.PY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetChatsStateResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetChatsStateResult copyWith(void Function(Chats_GetChatsStateResult) updates) =>
      super.copyWith((message) => updates(message as Chats_GetChatsStateResult)) as Chats_GetChatsStateResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_GetChatsStateResult create() => Chats_GetChatsStateResult._();
  @$core.override
  Chats_GetChatsStateResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_GetChatsStateResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_GetChatsStateResult>(create);
  static Chats_GetChatsStateResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Chats_ChatPts> get changed => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.List<$core.int>> get gone => $_getList(1);
}

/// Догон журнала чата: обновления с chatPts > pts (как getChannelDifference).
/// tooLong — журнал после pts уже обрезан: перезагрузить верх истории и
/// dialog, продолжать от dialog.chat.pts.
class Chats_GetChatDifference extends $pb.GeneratedMessage {
  factory Chats_GetChatDifference({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? pts,
    $core.int? limit,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (pts != null) result.pts = pts;
    if (limit != null) result.limit = limit;
    return result;
  }

  Chats_GetChatDifference._();

  factory Chats_GetChatDifference.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_GetChatDifference.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.GetChatDifference',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'pts')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetChatDifference clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetChatDifference copyWith(void Function(Chats_GetChatDifference) updates) =>
      super.copyWith((message) => updates(message as Chats_GetChatDifference)) as Chats_GetChatDifference;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_GetChatDifference create() => Chats_GetChatDifference._();
  @$core.override
  Chats_GetChatDifference createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_GetChatDifference getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_GetChatDifference>(create);
  static Chats_GetChatDifference? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get pts => $_getI64(1);
  @$pb.TagNumber(2)
  set pts($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPts() => $_has(1);
  @$pb.TagNumber(2)
  void clearPts() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class Chats_GetChatDifferenceResult extends $pb.GeneratedMessage {
  factory Chats_GetChatDifferenceResult({
    $core.Iterable<Update>? updates,
    $fixnum.Int64? pts,
    $core.bool? hasMore,
    $core.bool? tooLong,
    Dialog? dialog,
  }) {
    final result = create();
    if (updates != null) result.updates.addAll(updates);
    if (pts != null) result.pts = pts;
    if (hasMore != null) result.hasMore = hasMore;
    if (tooLong != null) result.tooLong = tooLong;
    if (dialog != null) result.dialog = dialog;
    return result;
  }

  Chats_GetChatDifferenceResult._();

  factory Chats_GetChatDifferenceResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_GetChatDifferenceResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.GetChatDifferenceResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Update>(1, _omitFieldNames ? '' : 'updates', subBuilder: Update.create)
    ..aInt64(2, _omitFieldNames ? '' : 'pts')
    ..aOB(3, _omitFieldNames ? '' : 'hasMore', protoName: 'hasMore')
    ..aOB(4, _omitFieldNames ? '' : 'tooLong', protoName: 'tooLong')
    ..aOM<Dialog>(5, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetChatDifferenceResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetChatDifferenceResult copyWith(void Function(Chats_GetChatDifferenceResult) updates) =>
      super.copyWith((message) => updates(message as Chats_GetChatDifferenceResult)) as Chats_GetChatDifferenceResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_GetChatDifferenceResult create() => Chats_GetChatDifferenceResult._();
  @$core.override
  Chats_GetChatDifferenceResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_GetChatDifferenceResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_GetChatDifferenceResult>(create);
  static Chats_GetChatDifferenceResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Update> get updates => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get pts => $_getI64(1);
  @$pb.TagNumber(2)
  set pts($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPts() => $_has(1);
  @$pb.TagNumber(2)
  void clearPts() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get tooLong => $_getBF(3);
  @$pb.TagNumber(4)
  set tooLong($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTooLong() => $_has(3);
  @$pb.TagNumber(4)
  void clearTooLong() => $_clearField(4);

  @$pb.TagNumber(5)
  Dialog get dialog => $_getN(4);
  @$pb.TagNumber(5)
  set dialog(Dialog value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDialog() => $_has(4);
  @$pb.TagNumber(5)
  void clearDialog() => $_clearField(5);
  @$pb.TagNumber(5)
  Dialog ensureDialog() => $_ensure(4);
}

/// Сменить роль участника READER ⇄ WRITER (владелец или админ с banUsers;
/// админа / владельца так не меняют — PERMISSION_DENIED). Правила прав — общая
/// таблица тестов клиента и сервера (group_rights_cases.json). Участнику —
/// Update.dialogSettings (его роль), всем — chatMembers.updated.
class Chats_SetMemberRole extends $pb.GeneratedMessage {
  factory Chats_SetMemberRole({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? userID,
    ChatRole? role,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (userID != null) result.userID = userID;
    if (role != null) result.role = role;
    return result;
  }

  Chats_SetMemberRole._();

  factory Chats_SetMemberRole.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetMemberRole.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetMemberRole',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aE<ChatRole>(3, _omitFieldNames ? '' : 'role', enumValues: ChatRole.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetMemberRole clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetMemberRole copyWith(void Function(Chats_SetMemberRole) updates) =>
      super.copyWith((message) => updates(message as Chats_SetMemberRole)) as Chats_SetMemberRole;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetMemberRole create() => Chats_SetMemberRole._();
  @$core.override
  Chats_SetMemberRole createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetMemberRole getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetMemberRole>(create);
  static Chats_SetMemberRole? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get userID => $_getN(1);
  @$pb.TagNumber(2)
  set userID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  ChatRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role(ChatRole value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);
}

class Chats_SetMemberRoleResult extends $pb.GeneratedMessage {
  factory Chats_SetMemberRoleResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_SetMemberRoleResult._();

  factory Chats_SetMemberRoleResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetMemberRoleResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetMemberRoleResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetMemberRoleResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetMemberRoleResult copyWith(void Function(Chats_SetMemberRoleResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SetMemberRoleResult)) as Chats_SetMemberRoleResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetMemberRoleResult create() => Chats_SetMemberRoleResult._();
  @$core.override
  Chats_SetMemberRoleResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetMemberRoleResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetMemberRoleResult>(create);
  static Chats_SetMemberRoleResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Исключить участника (ban — ещё и заблокировать: не вернётся, пока не
/// разблокируют). Владелец или админ с banUsers; только READER / WRITER —
/// админа сначала снимают (RemoveAdmin), владельца — никто (PERMISSION_DENIED).
/// В ленте — служебное REMOVED; исключённому — dialogDeleted. ban у того, кто
/// не в группе, — только блокировка (не вступит ни по ссылке, ни заявкой, ни
/// по имени; добавить его может только админ с banUsers), без служебного.
class Chats_RemoveMember extends $pb.GeneratedMessage {
  factory Chats_RemoveMember({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? userID,
    $core.bool? ban,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (userID != null) result.userID = userID;
    if (ban != null) result.ban = ban;
    return result;
  }

  Chats_RemoveMember._();

  factory Chats_RemoveMember.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_RemoveMember.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.RemoveMember',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aOB(3, _omitFieldNames ? '' : 'ban')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RemoveMember clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RemoveMember copyWith(void Function(Chats_RemoveMember) updates) =>
      super.copyWith((message) => updates(message as Chats_RemoveMember)) as Chats_RemoveMember;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_RemoveMember create() => Chats_RemoveMember._();
  @$core.override
  Chats_RemoveMember createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_RemoveMember getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_RemoveMember>(create);
  static Chats_RemoveMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get userID => $_getN(1);
  @$pb.TagNumber(2)
  set userID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get ban => $_getBF(2);
  @$pb.TagNumber(3)
  set ban($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBan() => $_has(2);
  @$pb.TagNumber(3)
  void clearBan() => $_clearField(3);
}

class Chats_RemoveMemberResult extends $pb.GeneratedMessage {
  factory Chats_RemoveMemberResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_RemoveMemberResult._();

  factory Chats_RemoveMemberResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_RemoveMemberResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.RemoveMemberResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RemoveMemberResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RemoveMemberResult copyWith(void Function(Chats_RemoveMemberResult) updates) =>
      super.copyWith((message) => updates(message as Chats_RemoveMemberResult)) as Chats_RemoveMemberResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_RemoveMemberResult create() => Chats_RemoveMemberResult._();
  @$core.override
  Chats_RemoveMemberResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_RemoveMemberResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_RemoveMemberResult>(create);
  static Chats_RemoveMemberResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Заблокированные в группе — страница (новые сверху); видят владелец и
/// админы с banUsers. profiles — как в Members.
class Chats_Banned extends $pb.GeneratedMessage {
  factory Chats_Banned({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? offset,
    $core.int? limit,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (offset != null) result.offset = offset;
    if (limit != null) result.limit = limit;
    return result;
  }

  Chats_Banned._();

  factory Chats_Banned.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_Banned.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.Banned',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OY)
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Banned clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Banned copyWith(void Function(Chats_Banned) updates) =>
      super.copyWith((message) => updates(message as Chats_Banned)) as Chats_Banned;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_Banned create() => Chats_Banned._();
  @$core.override
  Chats_Banned createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_Banned getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_Banned>(create);
  static Chats_Banned? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get offset => $_getN(1);
  @$pb.TagNumber(2)
  set offset($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class Chats_BannedResult extends $pb.GeneratedMessage {
  factory Chats_BannedResult({
    $core.Iterable<ChatBannedMember>? banned,
    $core.Iterable<$1.Profile_Response>? profiles,
    $core.List<$core.int>? nextOffset,
    $core.int? total,
  }) {
    final result = create();
    if (banned != null) result.banned.addAll(banned);
    if (profiles != null) result.profiles.addAll(profiles);
    if (nextOffset != null) result.nextOffset = nextOffset;
    if (total != null) result.total = total;
    return result;
  }

  Chats_BannedResult._();

  factory Chats_BannedResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_BannedResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.BannedResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatBannedMember>(1, _omitFieldNames ? '' : 'banned', subBuilder: ChatBannedMember.create)
    ..pPM<$1.Profile_Response>(2, _omitFieldNames ? '' : 'profiles', subBuilder: $1.Profile_Response.create)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'nextOffset', $pb.PbFieldType.OY, protoName: 'nextOffset')
    ..aI(4, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_BannedResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_BannedResult copyWith(void Function(Chats_BannedResult) updates) =>
      super.copyWith((message) => updates(message as Chats_BannedResult)) as Chats_BannedResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_BannedResult create() => Chats_BannedResult._();
  @$core.override
  Chats_BannedResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_BannedResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_BannedResult>(create);
  static Chats_BannedResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatBannedMember> get banned => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$1.Profile_Response> get profiles => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get nextOffset => $_getN(2);
  @$pb.TagNumber(3)
  set nextOffset($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNextOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextOffset() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get total => $_getIZ(3);
  @$pb.TagNumber(4)
  set total($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotal() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotal() => $_clearField(4);
}

/// Разблокировать (в группу не возвращает — только снимает блокировку).
class Chats_Unban extends $pb.GeneratedMessage {
  factory Chats_Unban({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? userID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (userID != null) result.userID = userID;
    return result;
  }

  Chats_Unban._();

  factory Chats_Unban.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_Unban.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.Unban',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Unban clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Unban copyWith(void Function(Chats_Unban) updates) => super.copyWith((message) => updates(message as Chats_Unban)) as Chats_Unban;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_Unban create() => Chats_Unban._();
  @$core.override
  Chats_Unban createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_Unban getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_Unban>(create);
  static Chats_Unban? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get userID => $_getN(1);
  @$pb.TagNumber(2)
  set userID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);
}

class Chats_UnbanResult extends $pb.GeneratedMessage {
  factory Chats_UnbanResult() => create();

  Chats_UnbanResult._();

  factory Chats_UnbanResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_UnbanResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.UnbanResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_UnbanResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_UnbanResult copyWith(void Function(Chats_UnbanResult) updates) =>
      super.copyWith((message) => updates(message as Chats_UnbanResult)) as Chats_UnbanResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_UnbanResult create() => Chats_UnbanResult._();
  @$core.override
  Chats_UnbanResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_UnbanResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_UnbanResult>(create);
  static Chats_UnbanResult? _defaultInstance;
}

/// Назначить админом / изменить права и звание (владелец или админ с
/// addAdmins; права — не шире своих, иначе PERMISSION_DENIED
/// «rightsTooWide»; владельца — нельзя). rank ≤ 16 символов («rankInvalid»).
/// userID = свой у владельца — сменить себе звание (rights не значат).
/// Права уже существующего админа меняет владелец или админ, чьи права не уже
/// его. Участнику —
/// Update.dialogSettings, всем — chatMembers.updated.
class Chats_SetAdmin extends $pb.GeneratedMessage {
  factory Chats_SetAdmin({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? userID,
    ChatAdminRights? rights,
    $core.String? rank,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (userID != null) result.userID = userID;
    if (rights != null) result.rights = rights;
    if (rank != null) result.rank = rank;
    return result;
  }

  Chats_SetAdmin._();

  factory Chats_SetAdmin.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetAdmin.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetAdmin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aOM<ChatAdminRights>(3, _omitFieldNames ? '' : 'rights', subBuilder: ChatAdminRights.create)
    ..aOS(4, _omitFieldNames ? '' : 'rank')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetAdmin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetAdmin copyWith(void Function(Chats_SetAdmin) updates) =>
      super.copyWith((message) => updates(message as Chats_SetAdmin)) as Chats_SetAdmin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetAdmin create() => Chats_SetAdmin._();
  @$core.override
  Chats_SetAdmin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetAdmin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetAdmin>(create);
  static Chats_SetAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get userID => $_getN(1);
  @$pb.TagNumber(2)
  set userID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  ChatAdminRights get rights => $_getN(2);
  @$pb.TagNumber(3)
  set rights(ChatAdminRights value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRights() => $_has(2);
  @$pb.TagNumber(3)
  void clearRights() => $_clearField(3);
  @$pb.TagNumber(3)
  ChatAdminRights ensureRights() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get rank => $_getSZ(3);
  @$pb.TagNumber(4)
  set rank($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRank() => $_has(3);
  @$pb.TagNumber(4)
  void clearRank() => $_clearField(4);
}

class Chats_SetAdminResult extends $pb.GeneratedMessage {
  factory Chats_SetAdminResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_SetAdminResult._();

  factory Chats_SetAdminResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetAdminResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetAdminResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetAdminResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetAdminResult copyWith(void Function(Chats_SetAdminResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SetAdminResult)) as Chats_SetAdminResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetAdminResult create() => Chats_SetAdminResult._();
  @$core.override
  Chats_SetAdminResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetAdminResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetAdminResult>(create);
  static Chats_SetAdminResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Снять админа — станет участником с ролью по умолчанию группы. Может
/// владелец или админ с addAdmins, чьи права не уже снимаемого.
class Chats_RemoveAdmin extends $pb.GeneratedMessage {
  factory Chats_RemoveAdmin({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? userID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (userID != null) result.userID = userID;
    return result;
  }

  Chats_RemoveAdmin._();

  factory Chats_RemoveAdmin.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_RemoveAdmin.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.RemoveAdmin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RemoveAdmin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RemoveAdmin copyWith(void Function(Chats_RemoveAdmin) updates) =>
      super.copyWith((message) => updates(message as Chats_RemoveAdmin)) as Chats_RemoveAdmin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_RemoveAdmin create() => Chats_RemoveAdmin._();
  @$core.override
  Chats_RemoveAdmin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_RemoveAdmin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_RemoveAdmin>(create);
  static Chats_RemoveAdmin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get userID => $_getN(1);
  @$pb.TagNumber(2)
  set userID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);
}

class Chats_RemoveAdminResult extends $pb.GeneratedMessage {
  factory Chats_RemoveAdminResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_RemoveAdminResult._();

  factory Chats_RemoveAdminResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_RemoveAdminResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.RemoveAdminResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RemoveAdminResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RemoveAdminResult copyWith(void Function(Chats_RemoveAdminResult) updates) =>
      super.copyWith((message) => updates(message as Chats_RemoveAdminResult)) as Chats_RemoveAdminResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_RemoveAdminResult create() => Chats_RemoveAdminResult._();
  @$core.override
  Chats_RemoveAdminResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_RemoveAdminResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_RemoveAdminResult>(create);
  static Chats_RemoveAdminResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Передать владение участнику userID (только владелец): он — OWNER, я —
/// ADMIN со всеми правами. Подтверждение облачным паролем — pwHash как в
/// CloudPasswordVerify; облачного пароля нет — FAILED_PRECONDITION
/// «cloudPasswordRequired», неверный — PERMISSION_DENIED «passwordInvalid».
/// Служебное OWNER_CHANGED, всем — chatInfo и chatMembers.updated.
class Chats_TransferOwnership extends $pb.GeneratedMessage {
  factory Chats_TransferOwnership({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? userID,
    $core.List<$core.int>? pwHash,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (userID != null) result.userID = userID;
    if (pwHash != null) result.pwHash = pwHash;
    return result;
  }

  Chats_TransferOwnership._();

  factory Chats_TransferOwnership.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_TransferOwnership.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.TransferOwnership',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'pwHash', $pb.PbFieldType.OY, protoName: 'pwHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_TransferOwnership clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_TransferOwnership copyWith(void Function(Chats_TransferOwnership) updates) =>
      super.copyWith((message) => updates(message as Chats_TransferOwnership)) as Chats_TransferOwnership;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_TransferOwnership create() => Chats_TransferOwnership._();
  @$core.override
  Chats_TransferOwnership createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_TransferOwnership getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_TransferOwnership>(create);
  static Chats_TransferOwnership? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get userID => $_getN(1);
  @$pb.TagNumber(2)
  set userID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get pwHash => $_getN(2);
  @$pb.TagNumber(3)
  set pwHash($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPwHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearPwHash() => $_clearField(3);
}

class Chats_TransferOwnershipResult extends $pb.GeneratedMessage {
  factory Chats_TransferOwnershipResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_TransferOwnershipResult._();

  factory Chats_TransferOwnershipResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_TransferOwnershipResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.TransferOwnershipResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_TransferOwnershipResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_TransferOwnershipResult copyWith(void Function(Chats_TransferOwnershipResult) updates) =>
      super.copyWith((message) => updates(message as Chats_TransferOwnershipResult)) as Chats_TransferOwnershipResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_TransferOwnershipResult create() => Chats_TransferOwnershipResult._();
  @$core.override
  Chats_TransferOwnershipResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_TransferOwnershipResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_TransferOwnershipResult>(create);
  static Chats_TransferOwnershipResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Свободно ли публичное имя (форма создания / «Изменить»): общее
/// пространство с именами пользователей. exceptChatID — своя группа (её
/// текущее имя — свободно).
class Chats_CheckUsername extends $pb.GeneratedMessage {
  factory Chats_CheckUsername({
    $core.String? username,
    $core.List<$core.int>? exceptChatID,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (exceptChatID != null) result.exceptChatID = exceptChatID;
    return result;
  }

  Chats_CheckUsername._();

  factory Chats_CheckUsername.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_CheckUsername.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.CheckUsername',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'exceptChatID', $pb.PbFieldType.OY, protoName: 'exceptChatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CheckUsername clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CheckUsername copyWith(void Function(Chats_CheckUsername) updates) =>
      super.copyWith((message) => updates(message as Chats_CheckUsername)) as Chats_CheckUsername;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_CheckUsername create() => Chats_CheckUsername._();
  @$core.override
  Chats_CheckUsername createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_CheckUsername getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_CheckUsername>(create);
  static Chats_CheckUsername? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get exceptChatID => $_getN(1);
  @$pb.TagNumber(2)
  set exceptChatID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExceptChatID() => $_has(1);
  @$pb.TagNumber(2)
  void clearExceptChatID() => $_clearField(2);
}

class Chats_CheckUsernameResult extends $pb.GeneratedMessage {
  factory Chats_CheckUsernameResult({
    $core.bool? available,
    $core.bool? invalid,
  }) {
    final result = create();
    if (available != null) result.available = available;
    if (invalid != null) result.invalid = invalid;
    return result;
  }

  Chats_CheckUsernameResult._();

  factory Chats_CheckUsernameResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_CheckUsernameResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.CheckUsernameResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'available')
    ..aOB(2, _omitFieldNames ? '' : 'invalid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CheckUsernameResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CheckUsernameResult copyWith(void Function(Chats_CheckUsernameResult) updates) =>
      super.copyWith((message) => updates(message as Chats_CheckUsernameResult)) as Chats_CheckUsernameResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_CheckUsernameResult create() => Chats_CheckUsernameResult._();
  @$core.override
  Chats_CheckUsernameResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_CheckUsernameResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_CheckUsernameResult>(create);
  static Chats_CheckUsernameResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get available => $_getBF(0);
  @$pb.TagNumber(1)
  set available($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAvailable() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvailable() => $_clearField(1);

  /// Не по правилам (длина, символы).
  @$pb.TagNumber(2)
  $core.bool get invalid => $_getBF(1);
  @$pb.TagNumber(2)
  set invalid($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInvalid() => $_has(1);
  @$pb.TagNumber(2)
  void clearInvalid() => $_clearField(2);
}

/// Ссылка iperon.net/<path>: path — username (пользователя или группы) или
/// «+код» приглашения. Пользователь — его личный чат со мной (как
/// ResolveUsername, в dialog); группа, где я участник, — dialog; чужая —
/// preview. Нет такого / ссылка отозвана, истекла, исчерпана —
/// NOT_FOUND. Лимит частоты — как ResolveUsername.
class Chats_ResolveLink extends $pb.GeneratedMessage {
  factory Chats_ResolveLink({
    $core.String? path,
  }) {
    final result = create();
    if (path != null) result.path = path;
    return result;
  }

  Chats_ResolveLink._();

  factory Chats_ResolveLink.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ResolveLink.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ResolveLink',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveLink clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveLink copyWith(void Function(Chats_ResolveLink) updates) =>
      super.copyWith((message) => updates(message as Chats_ResolveLink)) as Chats_ResolveLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ResolveLink create() => Chats_ResolveLink._();
  @$core.override
  Chats_ResolveLink createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ResolveLink getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ResolveLink>(create);
  static Chats_ResolveLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
}

class Chats_ResolveLinkResult extends $pb.GeneratedMessage {
  factory Chats_ResolveLinkResult({
    Dialog? dialog,
    ChatPreview? preview,
  }) {
    final result = create();
    if (dialog != null) result.dialog = dialog;
    if (preview != null) result.preview = preview;
    return result;
  }

  Chats_ResolveLinkResult._();

  factory Chats_ResolveLinkResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ResolveLinkResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ResolveLinkResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Dialog>(1, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..aOM<ChatPreview>(2, _omitFieldNames ? '' : 'preview', subBuilder: ChatPreview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveLinkResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveLinkResult copyWith(void Function(Chats_ResolveLinkResult) updates) =>
      super.copyWith((message) => updates(message as Chats_ResolveLinkResult)) as Chats_ResolveLinkResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ResolveLinkResult create() => Chats_ResolveLinkResult._();
  @$core.override
  Chats_ResolveLinkResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ResolveLinkResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ResolveLinkResult>(create);
  static Chats_ResolveLinkResult? _defaultInstance;

  @$pb.TagNumber(1)
  Dialog get dialog => $_getN(0);
  @$pb.TagNumber(1)
  set dialog(Dialog value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDialog() => $_has(0);
  @$pb.TagNumber(1)
  void clearDialog() => $_clearField(1);
  @$pb.TagNumber(1)
  Dialog ensureDialog() => $_ensure(0);

  @$pb.TagNumber(2)
  ChatPreview get preview => $_getN(1);
  @$pb.TagNumber(2)
  set preview(ChatPreview value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPreview() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreview() => $_clearField(2);
  @$pb.TagNumber(2)
  ChatPreview ensurePreview() => $_ensure(1);
}

/// Вступить (path — как в ResolveLink: username OPEN-группы или «+код»).
/// Сразу — dialogNew (у меня) + служебное JOINED и chatMembers (всем);
/// нужна заявка — requested = true (админам — joinRequests), повтор —
/// то же без дублей. Заблокирован в группе — PERMISSION_DENIED «banned»;
/// ссылка недействительна — NOT_FOUND; полна — «membersLimit»; моих групп
/// уже 500 — «groupsLimit». Уже участник — dialog без изменений.
class Chats_JoinChat extends $pb.GeneratedMessage {
  factory Chats_JoinChat({
    $core.String? path,
  }) {
    final result = create();
    if (path != null) result.path = path;
    return result;
  }

  Chats_JoinChat._();

  factory Chats_JoinChat.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_JoinChat.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.JoinChat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_JoinChat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_JoinChat copyWith(void Function(Chats_JoinChat) updates) =>
      super.copyWith((message) => updates(message as Chats_JoinChat)) as Chats_JoinChat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_JoinChat create() => Chats_JoinChat._();
  @$core.override
  Chats_JoinChat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_JoinChat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_JoinChat>(create);
  static Chats_JoinChat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
}

class Chats_JoinChatResult extends $pb.GeneratedMessage {
  factory Chats_JoinChatResult({
    Dialog? dialog,
    $core.bool? requested,
    Updates? updates,
  }) {
    final result = create();
    if (dialog != null) result.dialog = dialog;
    if (requested != null) result.requested = requested;
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_JoinChatResult._();

  factory Chats_JoinChatResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_JoinChatResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.JoinChatResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Dialog>(1, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..aOB(2, _omitFieldNames ? '' : 'requested')
    ..aOM<Updates>(3, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_JoinChatResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_JoinChatResult copyWith(void Function(Chats_JoinChatResult) updates) =>
      super.copyWith((message) => updates(message as Chats_JoinChatResult)) as Chats_JoinChatResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_JoinChatResult create() => Chats_JoinChatResult._();
  @$core.override
  Chats_JoinChatResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_JoinChatResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_JoinChatResult>(create);
  static Chats_JoinChatResult? _defaultInstance;

  @$pb.TagNumber(1)
  Dialog get dialog => $_getN(0);
  @$pb.TagNumber(1)
  set dialog(Dialog value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDialog() => $_has(0);
  @$pb.TagNumber(1)
  void clearDialog() => $_clearField(1);
  @$pb.TagNumber(1)
  Dialog ensureDialog() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get requested => $_getBF(1);
  @$pb.TagNumber(2)
  set requested($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequested() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequested() => $_clearField(2);

  @$pb.TagNumber(3)
  Updates get updates => $_getN(2);
  @$pb.TagNumber(3)
  set updates(Updates value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpdates() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdates() => $_clearField(3);
  @$pb.TagNumber(3)
  Updates ensureUpdates() => $_ensure(2);
}

/// Ссылки-приглашения группы (владелец / админ с inviteUsers): все, основная
/// первой, затем по дате создания (новые сверху), отозванные — в конце.
class Chats_InviteLinks extends $pb.GeneratedMessage {
  factory Chats_InviteLinks({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Chats_InviteLinks._();

  factory Chats_InviteLinks.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_InviteLinks.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.InviteLinks',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_InviteLinks clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_InviteLinks copyWith(void Function(Chats_InviteLinks) updates) =>
      super.copyWith((message) => updates(message as Chats_InviteLinks)) as Chats_InviteLinks;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_InviteLinks create() => Chats_InviteLinks._();
  @$core.override
  Chats_InviteLinks createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_InviteLinks getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_InviteLinks>(create);
  static Chats_InviteLinks? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

class Chats_InviteLinksResult extends $pb.GeneratedMessage {
  factory Chats_InviteLinksResult({
    $core.Iterable<ChatInviteLink>? links,
  }) {
    final result = create();
    if (links != null) result.links.addAll(links);
    return result;
  }

  Chats_InviteLinksResult._();

  factory Chats_InviteLinksResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_InviteLinksResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.InviteLinksResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatInviteLink>(1, _omitFieldNames ? '' : 'links', subBuilder: ChatInviteLink.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_InviteLinksResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_InviteLinksResult copyWith(void Function(Chats_InviteLinksResult) updates) =>
      super.copyWith((message) => updates(message as Chats_InviteLinksResult)) as Chats_InviteLinksResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_InviteLinksResult create() => Chats_InviteLinksResult._();
  @$core.override
  Chats_InviteLinksResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_InviteLinksResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_InviteLinksResult>(create);
  static Chats_InviteLinksResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatInviteLink> get links => $_getList(0);
}

/// Новая дополнительная ссылка (≤ 100 активных на группу — FAILED_PRECONDITION
/// «linksLimit»). title ≤ 32, usageLimit 0..99999, expireDate в будущем или 0.
class Chats_CreateInviteLink extends $pb.GeneratedMessage {
  factory Chats_CreateInviteLink({
    $core.List<$core.int>? chatID,
    $core.String? title,
    $fixnum.Int64? expireDate,
    $core.int? usageLimit,
    $core.bool? requestApproval,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (title != null) result.title = title;
    if (expireDate != null) result.expireDate = expireDate;
    if (usageLimit != null) result.usageLimit = usageLimit;
    if (requestApproval != null) result.requestApproval = requestApproval;
    return result;
  }

  Chats_CreateInviteLink._();

  factory Chats_CreateInviteLink.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_CreateInviteLink.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.CreateInviteLink',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aInt64(3, _omitFieldNames ? '' : 'expireDate', protoName: 'expireDate')
    ..aI(4, _omitFieldNames ? '' : 'usageLimit', protoName: 'usageLimit')
    ..aOB(5, _omitFieldNames ? '' : 'requestApproval', protoName: 'requestApproval')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CreateInviteLink clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CreateInviteLink copyWith(void Function(Chats_CreateInviteLink) updates) =>
      super.copyWith((message) => updates(message as Chats_CreateInviteLink)) as Chats_CreateInviteLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_CreateInviteLink create() => Chats_CreateInviteLink._();
  @$core.override
  Chats_CreateInviteLink createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_CreateInviteLink getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_CreateInviteLink>(create);
  static Chats_CreateInviteLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expireDate => $_getI64(2);
  @$pb.TagNumber(3)
  set expireDate($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpireDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpireDate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get usageLimit => $_getIZ(3);
  @$pb.TagNumber(4)
  set usageLimit($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsageLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsageLimit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get requestApproval => $_getBF(4);
  @$pb.TagNumber(5)
  set requestApproval($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRequestApproval() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequestApproval() => $_clearField(5);
}

class Chats_CreateInviteLinkResult extends $pb.GeneratedMessage {
  factory Chats_CreateInviteLinkResult({
    ChatInviteLink? link,
  }) {
    final result = create();
    if (link != null) result.link = link;
    return result;
  }

  Chats_CreateInviteLinkResult._();

  factory Chats_CreateInviteLinkResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_CreateInviteLinkResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.CreateInviteLinkResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatInviteLink>(1, _omitFieldNames ? '' : 'link', subBuilder: ChatInviteLink.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CreateInviteLinkResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CreateInviteLinkResult copyWith(void Function(Chats_CreateInviteLinkResult) updates) =>
      super.copyWith((message) => updates(message as Chats_CreateInviteLinkResult)) as Chats_CreateInviteLinkResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_CreateInviteLinkResult create() => Chats_CreateInviteLinkResult._();
  @$core.override
  Chats_CreateInviteLinkResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_CreateInviteLinkResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_CreateInviteLinkResult>(create);
  static Chats_CreateInviteLinkResult? _defaultInstance;

  @$pb.TagNumber(1)
  ChatInviteLink get link => $_getN(0);
  @$pb.TagNumber(1)
  set link(ChatInviteLink value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatInviteLink ensureLink() => $_ensure(0);
}

/// Изменить ссылку (не отозванную; у основной — только requestApproval).
class Chats_EditInviteLink extends $pb.GeneratedMessage {
  factory Chats_EditInviteLink({
    $core.List<$core.int>? chatID,
    $core.String? code,
    $core.String? title,
    $fixnum.Int64? expireDate,
    $core.int? usageLimit,
    $core.bool? requestApproval,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (code != null) result.code = code;
    if (title != null) result.title = title;
    if (expireDate != null) result.expireDate = expireDate;
    if (usageLimit != null) result.usageLimit = usageLimit;
    if (requestApproval != null) result.requestApproval = requestApproval;
    return result;
  }

  Chats_EditInviteLink._();

  factory Chats_EditInviteLink.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_EditInviteLink.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.EditInviteLink',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aInt64(4, _omitFieldNames ? '' : 'expireDate', protoName: 'expireDate')
    ..aI(5, _omitFieldNames ? '' : 'usageLimit', protoName: 'usageLimit')
    ..aOB(6, _omitFieldNames ? '' : 'requestApproval', protoName: 'requestApproval')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_EditInviteLink clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_EditInviteLink copyWith(void Function(Chats_EditInviteLink) updates) =>
      super.copyWith((message) => updates(message as Chats_EditInviteLink)) as Chats_EditInviteLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_EditInviteLink create() => Chats_EditInviteLink._();
  @$core.override
  Chats_EditInviteLink createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_EditInviteLink getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_EditInviteLink>(create);
  static Chats_EditInviteLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expireDate => $_getI64(3);
  @$pb.TagNumber(4)
  set expireDate($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpireDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpireDate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get usageLimit => $_getIZ(4);
  @$pb.TagNumber(5)
  set usageLimit($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUsageLimit() => $_has(4);
  @$pb.TagNumber(5)
  void clearUsageLimit() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get requestApproval => $_getBF(5);
  @$pb.TagNumber(6)
  set requestApproval($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRequestApproval() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequestApproval() => $_clearField(6);
}

class Chats_EditInviteLinkResult extends $pb.GeneratedMessage {
  factory Chats_EditInviteLinkResult({
    ChatInviteLink? link,
  }) {
    final result = create();
    if (link != null) result.link = link;
    return result;
  }

  Chats_EditInviteLinkResult._();

  factory Chats_EditInviteLinkResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_EditInviteLinkResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.EditInviteLinkResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatInviteLink>(1, _omitFieldNames ? '' : 'link', subBuilder: ChatInviteLink.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_EditInviteLinkResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_EditInviteLinkResult copyWith(void Function(Chats_EditInviteLinkResult) updates) =>
      super.copyWith((message) => updates(message as Chats_EditInviteLinkResult)) as Chats_EditInviteLinkResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_EditInviteLinkResult create() => Chats_EditInviteLinkResult._();
  @$core.override
  Chats_EditInviteLinkResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_EditInviteLinkResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_EditInviteLinkResult>(create);
  static Chats_EditInviteLinkResult? _defaultInstance;

  @$pb.TagNumber(1)
  ChatInviteLink get link => $_getN(0);
  @$pb.TagNumber(1)
  set link(ChatInviteLink value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatInviteLink ensureLink() => $_ensure(0);
}

/// Отозвать: по ссылке больше не вступить, её ждущие заявки остаются.
/// Основная — заменяется новой (primary в ответе), Dialog.inviteCode у
/// админов — через dialogSettings.
class Chats_RevokeInviteLink extends $pb.GeneratedMessage {
  factory Chats_RevokeInviteLink({
    $core.List<$core.int>? chatID,
    $core.String? code,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (code != null) result.code = code;
    return result;
  }

  Chats_RevokeInviteLink._();

  factory Chats_RevokeInviteLink.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_RevokeInviteLink.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.RevokeInviteLink',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RevokeInviteLink clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RevokeInviteLink copyWith(void Function(Chats_RevokeInviteLink) updates) =>
      super.copyWith((message) => updates(message as Chats_RevokeInviteLink)) as Chats_RevokeInviteLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_RevokeInviteLink create() => Chats_RevokeInviteLink._();
  @$core.override
  Chats_RevokeInviteLink createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_RevokeInviteLink getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_RevokeInviteLink>(create);
  static Chats_RevokeInviteLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);
}

class Chats_RevokeInviteLinkResult extends $pb.GeneratedMessage {
  factory Chats_RevokeInviteLinkResult({
    ChatInviteLink? revoked,
    ChatInviteLink? primary,
    Updates? updates,
  }) {
    final result = create();
    if (revoked != null) result.revoked = revoked;
    if (primary != null) result.primary = primary;
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_RevokeInviteLinkResult._();

  factory Chats_RevokeInviteLinkResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_RevokeInviteLinkResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.RevokeInviteLinkResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatInviteLink>(1, _omitFieldNames ? '' : 'revoked', subBuilder: ChatInviteLink.create)
    ..aOM<ChatInviteLink>(2, _omitFieldNames ? '' : 'primary', subBuilder: ChatInviteLink.create)
    ..aOM<Updates>(3, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RevokeInviteLinkResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_RevokeInviteLinkResult copyWith(void Function(Chats_RevokeInviteLinkResult) updates) =>
      super.copyWith((message) => updates(message as Chats_RevokeInviteLinkResult)) as Chats_RevokeInviteLinkResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_RevokeInviteLinkResult create() => Chats_RevokeInviteLinkResult._();
  @$core.override
  Chats_RevokeInviteLinkResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_RevokeInviteLinkResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_RevokeInviteLinkResult>(create);
  static Chats_RevokeInviteLinkResult? _defaultInstance;

  @$pb.TagNumber(1)
  ChatInviteLink get revoked => $_getN(0);
  @$pb.TagNumber(1)
  set revoked(ChatInviteLink value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRevoked() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevoked() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatInviteLink ensureRevoked() => $_ensure(0);

  @$pb.TagNumber(2)
  ChatInviteLink get primary => $_getN(1);
  @$pb.TagNumber(2)
  set primary(ChatInviteLink value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPrimary() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrimary() => $_clearField(2);
  @$pb.TagNumber(2)
  ChatInviteLink ensurePrimary() => $_ensure(1);

  @$pb.TagNumber(3)
  Updates get updates => $_getN(2);
  @$pb.TagNumber(3)
  set updates(Updates value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpdates() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdates() => $_clearField(3);
  @$pb.TagNumber(3)
  Updates ensureUpdates() => $_ensure(2);
}

/// Удалить все отозванные ссылки (основную не трогает).
class Chats_DeleteRevokedInviteLinks extends $pb.GeneratedMessage {
  factory Chats_DeleteRevokedInviteLinks({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Chats_DeleteRevokedInviteLinks._();

  factory Chats_DeleteRevokedInviteLinks.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteRevokedInviteLinks.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteRevokedInviteLinks',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteRevokedInviteLinks clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteRevokedInviteLinks copyWith(void Function(Chats_DeleteRevokedInviteLinks) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteRevokedInviteLinks)) as Chats_DeleteRevokedInviteLinks;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteRevokedInviteLinks create() => Chats_DeleteRevokedInviteLinks._();
  @$core.override
  Chats_DeleteRevokedInviteLinks createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteRevokedInviteLinks getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteRevokedInviteLinks>(create);
  static Chats_DeleteRevokedInviteLinks? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

class Chats_DeleteRevokedInviteLinksResult extends $pb.GeneratedMessage {
  factory Chats_DeleteRevokedInviteLinksResult() => create();

  Chats_DeleteRevokedInviteLinksResult._();

  factory Chats_DeleteRevokedInviteLinksResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteRevokedInviteLinksResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteRevokedInviteLinksResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteRevokedInviteLinksResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteRevokedInviteLinksResult copyWith(void Function(Chats_DeleteRevokedInviteLinksResult) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteRevokedInviteLinksResult)) as Chats_DeleteRevokedInviteLinksResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteRevokedInviteLinksResult create() => Chats_DeleteRevokedInviteLinksResult._();
  @$core.override
  Chats_DeleteRevokedInviteLinksResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteRevokedInviteLinksResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteRevokedInviteLinksResult>(create);
  static Chats_DeleteRevokedInviteLinksResult? _defaultInstance;
}

/// Заявки на вступление — страница (новые сверху); владелец / админ с
/// inviteUsers. profiles — как в Members.
class Chats_JoinRequests extends $pb.GeneratedMessage {
  factory Chats_JoinRequests({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? offset,
    $core.int? limit,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (offset != null) result.offset = offset;
    if (limit != null) result.limit = limit;
    return result;
  }

  Chats_JoinRequests._();

  factory Chats_JoinRequests.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_JoinRequests.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.JoinRequests',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OY)
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_JoinRequests clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_JoinRequests copyWith(void Function(Chats_JoinRequests) updates) =>
      super.copyWith((message) => updates(message as Chats_JoinRequests)) as Chats_JoinRequests;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_JoinRequests create() => Chats_JoinRequests._();
  @$core.override
  Chats_JoinRequests createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_JoinRequests getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_JoinRequests>(create);
  static Chats_JoinRequests? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get offset => $_getN(1);
  @$pb.TagNumber(2)
  set offset($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class Chats_JoinRequestsResult extends $pb.GeneratedMessage {
  factory Chats_JoinRequestsResult({
    $core.Iterable<ChatJoinRequest>? requests,
    $core.Iterable<$1.Profile_Response>? profiles,
    $core.List<$core.int>? nextOffset,
    $core.int? total,
  }) {
    final result = create();
    if (requests != null) result.requests.addAll(requests);
    if (profiles != null) result.profiles.addAll(profiles);
    if (nextOffset != null) result.nextOffset = nextOffset;
    if (total != null) result.total = total;
    return result;
  }

  Chats_JoinRequestsResult._();

  factory Chats_JoinRequestsResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_JoinRequestsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.JoinRequestsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatJoinRequest>(1, _omitFieldNames ? '' : 'requests', subBuilder: ChatJoinRequest.create)
    ..pPM<$1.Profile_Response>(2, _omitFieldNames ? '' : 'profiles', subBuilder: $1.Profile_Response.create)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'nextOffset', $pb.PbFieldType.OY, protoName: 'nextOffset')
    ..aI(4, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_JoinRequestsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_JoinRequestsResult copyWith(void Function(Chats_JoinRequestsResult) updates) =>
      super.copyWith((message) => updates(message as Chats_JoinRequestsResult)) as Chats_JoinRequestsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_JoinRequestsResult create() => Chats_JoinRequestsResult._();
  @$core.override
  Chats_JoinRequestsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_JoinRequestsResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_JoinRequestsResult>(create);
  static Chats_JoinRequestsResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatJoinRequest> get requests => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$1.Profile_Response> get profiles => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get nextOffset => $_getN(2);
  @$pb.TagNumber(3)
  set nextOffset($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNextOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextOffset() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get total => $_getIZ(3);
  @$pb.TagNumber(4)
  set total($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotal() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotal() => $_clearField(4);
}

/// Одобрить / отклонить заявку (userID пусто — все ждущие). Одобренный
/// вступает с ролью по умолчанию: ему dialogNew, всем — JOINED и
/// chatMembers; отклонённому ничего не приходит (как в Telegram). Админам —
/// joinRequests с новым счётчиком.
class Chats_AnswerJoinRequest extends $pb.GeneratedMessage {
  factory Chats_AnswerJoinRequest({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? userID,
    $core.bool? approve,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (userID != null) result.userID = userID;
    if (approve != null) result.approve = approve;
    return result;
  }

  Chats_AnswerJoinRequest._();

  factory Chats_AnswerJoinRequest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_AnswerJoinRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.AnswerJoinRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aOB(3, _omitFieldNames ? '' : 'approve')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_AnswerJoinRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_AnswerJoinRequest copyWith(void Function(Chats_AnswerJoinRequest) updates) =>
      super.copyWith((message) => updates(message as Chats_AnswerJoinRequest)) as Chats_AnswerJoinRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_AnswerJoinRequest create() => Chats_AnswerJoinRequest._();
  @$core.override
  Chats_AnswerJoinRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_AnswerJoinRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_AnswerJoinRequest>(create);
  static Chats_AnswerJoinRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get userID => $_getN(1);
  @$pb.TagNumber(2)
  set userID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get approve => $_getBF(2);
  @$pb.TagNumber(3)
  set approve($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasApprove() => $_has(2);
  @$pb.TagNumber(3)
  void clearApprove() => $_clearField(3);
}

class Chats_AnswerJoinRequestResult extends $pb.GeneratedMessage {
  factory Chats_AnswerJoinRequestResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_AnswerJoinRequestResult._();

  factory Chats_AnswerJoinRequestResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_AnswerJoinRequestResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.AnswerJoinRequestResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_AnswerJoinRequestResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_AnswerJoinRequestResult copyWith(void Function(Chats_AnswerJoinRequestResult) updates) =>
      super.copyWith((message) => updates(message as Chats_AnswerJoinRequestResult)) as Chats_AnswerJoinRequestResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_AnswerJoinRequestResult create() => Chats_AnswerJoinRequestResult._();
  @$core.override
  Chats_AnswerJoinRequestResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_AnswerJoinRequestResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_AnswerJoinRequestResult>(create);
  static Chats_AnswerJoinRequestResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

enum Chats_Request_Request {
  list,
  openPrivate,
  readHistory,
  setDialog,
  deleteDialog,
  readDate,
  canWrite,
  saveDraft,
  getFolders,
  saveFolder,
  deleteFolder,
  reorderFolders,
  resolveUsername,
  setTTL,
  setNoForwards,
  searchUsers,
  createGroup,
  editChat,
  addMembers,
  leaveChat,
  deleteChat,
  members,
  getChatsState,
  getChatDifference,
  setMemberRole,
  removeMember,
  banned,
  unban,
  setAdmin,
  removeAdmin,
  transferOwnership,
  checkUsername,
  resolveLink,
  joinChat,
  inviteLinks,
  createInviteLink,
  editInviteLink,
  revokeInviteLink,
  deleteRevokedInviteLinks,
  joinRequests,
  answerJoinRequest,
  searchChats,
  notSet
}

class Chats_Request extends $pb.GeneratedMessage {
  factory Chats_Request({
    Chats_List? list,
    Chats_OpenPrivate? openPrivate,
    Chats_ReadHistory? readHistory,
    Chats_SetDialog? setDialog,
    Chats_DeleteDialog? deleteDialog,
    Chats_ReadDate? readDate,
    Chats_CanWrite? canWrite,
    Chats_SaveDraft? saveDraft,
    Chats_GetFolders? getFolders,
    Chats_SaveFolder? saveFolder,
    Chats_DeleteFolder? deleteFolder,
    Chats_ReorderFolders? reorderFolders,
    Chats_ResolveUsername? resolveUsername,
    Chats_SetTTL? setTTL,
    Chats_SetNoForwards? setNoForwards,
    Chats_SearchUsers? searchUsers,
    Chats_CreateGroup? createGroup,
    Chats_EditChat? editChat,
    Chats_AddMembers? addMembers,
    Chats_LeaveChat? leaveChat,
    Chats_DeleteChat? deleteChat,
    Chats_Members? members,
    Chats_GetChatsState? getChatsState,
    Chats_GetChatDifference? getChatDifference,
    Chats_SetMemberRole? setMemberRole,
    Chats_RemoveMember? removeMember,
    Chats_Banned? banned,
    Chats_Unban? unban,
    Chats_SetAdmin? setAdmin,
    Chats_RemoveAdmin? removeAdmin,
    Chats_TransferOwnership? transferOwnership,
    Chats_CheckUsername? checkUsername,
    Chats_ResolveLink? resolveLink,
    Chats_JoinChat? joinChat,
    Chats_InviteLinks? inviteLinks,
    Chats_CreateInviteLink? createInviteLink,
    Chats_EditInviteLink? editInviteLink,
    Chats_RevokeInviteLink? revokeInviteLink,
    Chats_DeleteRevokedInviteLinks? deleteRevokedInviteLinks,
    Chats_JoinRequests? joinRequests,
    Chats_AnswerJoinRequest? answerJoinRequest,
    Chats_SearchChats? searchChats,
  }) {
    final result = create();
    if (list != null) result.list = list;
    if (openPrivate != null) result.openPrivate = openPrivate;
    if (readHistory != null) result.readHistory = readHistory;
    if (setDialog != null) result.setDialog = setDialog;
    if (deleteDialog != null) result.deleteDialog = deleteDialog;
    if (readDate != null) result.readDate = readDate;
    if (canWrite != null) result.canWrite = canWrite;
    if (saveDraft != null) result.saveDraft = saveDraft;
    if (getFolders != null) result.getFolders = getFolders;
    if (saveFolder != null) result.saveFolder = saveFolder;
    if (deleteFolder != null) result.deleteFolder = deleteFolder;
    if (reorderFolders != null) result.reorderFolders = reorderFolders;
    if (resolveUsername != null) result.resolveUsername = resolveUsername;
    if (setTTL != null) result.setTTL = setTTL;
    if (setNoForwards != null) result.setNoForwards = setNoForwards;
    if (searchUsers != null) result.searchUsers = searchUsers;
    if (createGroup != null) result.createGroup = createGroup;
    if (editChat != null) result.editChat = editChat;
    if (addMembers != null) result.addMembers = addMembers;
    if (leaveChat != null) result.leaveChat = leaveChat;
    if (deleteChat != null) result.deleteChat = deleteChat;
    if (members != null) result.members = members;
    if (getChatsState != null) result.getChatsState = getChatsState;
    if (getChatDifference != null) result.getChatDifference = getChatDifference;
    if (setMemberRole != null) result.setMemberRole = setMemberRole;
    if (removeMember != null) result.removeMember = removeMember;
    if (banned != null) result.banned = banned;
    if (unban != null) result.unban = unban;
    if (setAdmin != null) result.setAdmin = setAdmin;
    if (removeAdmin != null) result.removeAdmin = removeAdmin;
    if (transferOwnership != null) result.transferOwnership = transferOwnership;
    if (checkUsername != null) result.checkUsername = checkUsername;
    if (resolveLink != null) result.resolveLink = resolveLink;
    if (joinChat != null) result.joinChat = joinChat;
    if (inviteLinks != null) result.inviteLinks = inviteLinks;
    if (createInviteLink != null) result.createInviteLink = createInviteLink;
    if (editInviteLink != null) result.editInviteLink = editInviteLink;
    if (revokeInviteLink != null) result.revokeInviteLink = revokeInviteLink;
    if (deleteRevokedInviteLinks != null) result.deleteRevokedInviteLinks = deleteRevokedInviteLinks;
    if (joinRequests != null) result.joinRequests = joinRequests;
    if (answerJoinRequest != null) result.answerJoinRequest = answerJoinRequest;
    if (searchChats != null) result.searchChats = searchChats;
    return result;
  }

  Chats_Request._();

  factory Chats_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Chats_Request_Request> _Chats_Request_RequestByTag = {
    1: Chats_Request_Request.list,
    2: Chats_Request_Request.openPrivate,
    3: Chats_Request_Request.readHistory,
    4: Chats_Request_Request.setDialog,
    5: Chats_Request_Request.deleteDialog,
    6: Chats_Request_Request.readDate,
    7: Chats_Request_Request.canWrite,
    8: Chats_Request_Request.saveDraft,
    9: Chats_Request_Request.getFolders,
    10: Chats_Request_Request.saveFolder,
    11: Chats_Request_Request.deleteFolder,
    12: Chats_Request_Request.reorderFolders,
    13: Chats_Request_Request.resolveUsername,
    14: Chats_Request_Request.setTTL,
    15: Chats_Request_Request.setNoForwards,
    16: Chats_Request_Request.searchUsers,
    17: Chats_Request_Request.createGroup,
    18: Chats_Request_Request.editChat,
    19: Chats_Request_Request.addMembers,
    20: Chats_Request_Request.leaveChat,
    21: Chats_Request_Request.deleteChat,
    22: Chats_Request_Request.members,
    23: Chats_Request_Request.getChatsState,
    24: Chats_Request_Request.getChatDifference,
    25: Chats_Request_Request.setMemberRole,
    26: Chats_Request_Request.removeMember,
    27: Chats_Request_Request.banned,
    28: Chats_Request_Request.unban,
    29: Chats_Request_Request.setAdmin,
    30: Chats_Request_Request.removeAdmin,
    31: Chats_Request_Request.transferOwnership,
    32: Chats_Request_Request.checkUsername,
    33: Chats_Request_Request.resolveLink,
    34: Chats_Request_Request.joinChat,
    35: Chats_Request_Request.inviteLinks,
    36: Chats_Request_Request.createInviteLink,
    37: Chats_Request_Request.editInviteLink,
    38: Chats_Request_Request.revokeInviteLink,
    39: Chats_Request_Request.deleteRevokedInviteLinks,
    40: Chats_Request_Request.joinRequests,
    41: Chats_Request_Request.answerJoinRequest,
    42: Chats_Request_Request.searchChats,
    0: Chats_Request_Request.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
      39,
      40,
      41,
      42
    ])
    ..aOM<Chats_List>(1, _omitFieldNames ? '' : 'list', subBuilder: Chats_List.create)
    ..aOM<Chats_OpenPrivate>(2, _omitFieldNames ? '' : 'openPrivate', protoName: 'openPrivate', subBuilder: Chats_OpenPrivate.create)
    ..aOM<Chats_ReadHistory>(3, _omitFieldNames ? '' : 'readHistory', protoName: 'readHistory', subBuilder: Chats_ReadHistory.create)
    ..aOM<Chats_SetDialog>(4, _omitFieldNames ? '' : 'setDialog', protoName: 'setDialog', subBuilder: Chats_SetDialog.create)
    ..aOM<Chats_DeleteDialog>(5, _omitFieldNames ? '' : 'deleteDialog', protoName: 'deleteDialog', subBuilder: Chats_DeleteDialog.create)
    ..aOM<Chats_ReadDate>(6, _omitFieldNames ? '' : 'readDate', protoName: 'readDate', subBuilder: Chats_ReadDate.create)
    ..aOM<Chats_CanWrite>(7, _omitFieldNames ? '' : 'canWrite', protoName: 'canWrite', subBuilder: Chats_CanWrite.create)
    ..aOM<Chats_SaveDraft>(8, _omitFieldNames ? '' : 'saveDraft', protoName: 'saveDraft', subBuilder: Chats_SaveDraft.create)
    ..aOM<Chats_GetFolders>(9, _omitFieldNames ? '' : 'getFolders', protoName: 'getFolders', subBuilder: Chats_GetFolders.create)
    ..aOM<Chats_SaveFolder>(10, _omitFieldNames ? '' : 'saveFolder', protoName: 'saveFolder', subBuilder: Chats_SaveFolder.create)
    ..aOM<Chats_DeleteFolder>(11, _omitFieldNames ? '' : 'deleteFolder', protoName: 'deleteFolder', subBuilder: Chats_DeleteFolder.create)
    ..aOM<Chats_ReorderFolders>(12, _omitFieldNames ? '' : 'reorderFolders',
        protoName: 'reorderFolders', subBuilder: Chats_ReorderFolders.create)
    ..aOM<Chats_ResolveUsername>(13, _omitFieldNames ? '' : 'resolveUsername',
        protoName: 'resolveUsername', subBuilder: Chats_ResolveUsername.create)
    ..aOM<Chats_SetTTL>(14, _omitFieldNames ? '' : 'setTTL', protoName: 'setTTL', subBuilder: Chats_SetTTL.create)
    ..aOM<Chats_SetNoForwards>(15, _omitFieldNames ? '' : 'setNoForwards',
        protoName: 'setNoForwards', subBuilder: Chats_SetNoForwards.create)
    ..aOM<Chats_SearchUsers>(16, _omitFieldNames ? '' : 'searchUsers', protoName: 'searchUsers', subBuilder: Chats_SearchUsers.create)
    ..aOM<Chats_CreateGroup>(17, _omitFieldNames ? '' : 'createGroup', protoName: 'createGroup', subBuilder: Chats_CreateGroup.create)
    ..aOM<Chats_EditChat>(18, _omitFieldNames ? '' : 'editChat', protoName: 'editChat', subBuilder: Chats_EditChat.create)
    ..aOM<Chats_AddMembers>(19, _omitFieldNames ? '' : 'addMembers', protoName: 'addMembers', subBuilder: Chats_AddMembers.create)
    ..aOM<Chats_LeaveChat>(20, _omitFieldNames ? '' : 'leaveChat', protoName: 'leaveChat', subBuilder: Chats_LeaveChat.create)
    ..aOM<Chats_DeleteChat>(21, _omitFieldNames ? '' : 'deleteChat', protoName: 'deleteChat', subBuilder: Chats_DeleteChat.create)
    ..aOM<Chats_Members>(22, _omitFieldNames ? '' : 'members', subBuilder: Chats_Members.create)
    ..aOM<Chats_GetChatsState>(23, _omitFieldNames ? '' : 'getChatsState',
        protoName: 'getChatsState', subBuilder: Chats_GetChatsState.create)
    ..aOM<Chats_GetChatDifference>(24, _omitFieldNames ? '' : 'getChatDifference',
        protoName: 'getChatDifference', subBuilder: Chats_GetChatDifference.create)
    ..aOM<Chats_SetMemberRole>(25, _omitFieldNames ? '' : 'setMemberRole',
        protoName: 'setMemberRole', subBuilder: Chats_SetMemberRole.create)
    ..aOM<Chats_RemoveMember>(26, _omitFieldNames ? '' : 'removeMember', protoName: 'removeMember', subBuilder: Chats_RemoveMember.create)
    ..aOM<Chats_Banned>(27, _omitFieldNames ? '' : 'banned', subBuilder: Chats_Banned.create)
    ..aOM<Chats_Unban>(28, _omitFieldNames ? '' : 'unban', subBuilder: Chats_Unban.create)
    ..aOM<Chats_SetAdmin>(29, _omitFieldNames ? '' : 'setAdmin', protoName: 'setAdmin', subBuilder: Chats_SetAdmin.create)
    ..aOM<Chats_RemoveAdmin>(30, _omitFieldNames ? '' : 'removeAdmin', protoName: 'removeAdmin', subBuilder: Chats_RemoveAdmin.create)
    ..aOM<Chats_TransferOwnership>(31, _omitFieldNames ? '' : 'transferOwnership',
        protoName: 'transferOwnership', subBuilder: Chats_TransferOwnership.create)
    ..aOM<Chats_CheckUsername>(32, _omitFieldNames ? '' : 'checkUsername',
        protoName: 'checkUsername', subBuilder: Chats_CheckUsername.create)
    ..aOM<Chats_ResolveLink>(33, _omitFieldNames ? '' : 'resolveLink', protoName: 'resolveLink', subBuilder: Chats_ResolveLink.create)
    ..aOM<Chats_JoinChat>(34, _omitFieldNames ? '' : 'joinChat', protoName: 'joinChat', subBuilder: Chats_JoinChat.create)
    ..aOM<Chats_InviteLinks>(35, _omitFieldNames ? '' : 'inviteLinks', protoName: 'inviteLinks', subBuilder: Chats_InviteLinks.create)
    ..aOM<Chats_CreateInviteLink>(36, _omitFieldNames ? '' : 'createInviteLink',
        protoName: 'createInviteLink', subBuilder: Chats_CreateInviteLink.create)
    ..aOM<Chats_EditInviteLink>(37, _omitFieldNames ? '' : 'editInviteLink',
        protoName: 'editInviteLink', subBuilder: Chats_EditInviteLink.create)
    ..aOM<Chats_RevokeInviteLink>(38, _omitFieldNames ? '' : 'revokeInviteLink',
        protoName: 'revokeInviteLink', subBuilder: Chats_RevokeInviteLink.create)
    ..aOM<Chats_DeleteRevokedInviteLinks>(39, _omitFieldNames ? '' : 'deleteRevokedInviteLinks',
        protoName: 'deleteRevokedInviteLinks', subBuilder: Chats_DeleteRevokedInviteLinks.create)
    ..aOM<Chats_JoinRequests>(40, _omitFieldNames ? '' : 'joinRequests', protoName: 'joinRequests', subBuilder: Chats_JoinRequests.create)
    ..aOM<Chats_AnswerJoinRequest>(41, _omitFieldNames ? '' : 'answerJoinRequest',
        protoName: 'answerJoinRequest', subBuilder: Chats_AnswerJoinRequest.create)
    ..aOM<Chats_SearchChats>(42, _omitFieldNames ? '' : 'searchChats', protoName: 'searchChats', subBuilder: Chats_SearchChats.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Request copyWith(void Function(Chats_Request) updates) =>
      super.copyWith((message) => updates(message as Chats_Request)) as Chats_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_Request create() => Chats_Request._();
  @$core.override
  Chats_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_Request>(create);
  static Chats_Request? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  @$pb.TagNumber(33)
  @$pb.TagNumber(34)
  @$pb.TagNumber(35)
  @$pb.TagNumber(36)
  @$pb.TagNumber(37)
  @$pb.TagNumber(38)
  @$pb.TagNumber(39)
  @$pb.TagNumber(40)
  @$pb.TagNumber(41)
  @$pb.TagNumber(42)
  Chats_Request_Request whichRequest() => _Chats_Request_RequestByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  @$pb.TagNumber(33)
  @$pb.TagNumber(34)
  @$pb.TagNumber(35)
  @$pb.TagNumber(36)
  @$pb.TagNumber(37)
  @$pb.TagNumber(38)
  @$pb.TagNumber(39)
  @$pb.TagNumber(40)
  @$pb.TagNumber(41)
  @$pb.TagNumber(42)
  void clearRequest() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Chats_List get list => $_getN(0);
  @$pb.TagNumber(1)
  set list(Chats_List value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasList() => $_has(0);
  @$pb.TagNumber(1)
  void clearList() => $_clearField(1);
  @$pb.TagNumber(1)
  Chats_List ensureList() => $_ensure(0);

  @$pb.TagNumber(2)
  Chats_OpenPrivate get openPrivate => $_getN(1);
  @$pb.TagNumber(2)
  set openPrivate(Chats_OpenPrivate value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenPrivate() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenPrivate() => $_clearField(2);
  @$pb.TagNumber(2)
  Chats_OpenPrivate ensureOpenPrivate() => $_ensure(1);

  @$pb.TagNumber(3)
  Chats_ReadHistory get readHistory => $_getN(2);
  @$pb.TagNumber(3)
  set readHistory(Chats_ReadHistory value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReadHistory() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadHistory() => $_clearField(3);
  @$pb.TagNumber(3)
  Chats_ReadHistory ensureReadHistory() => $_ensure(2);

  @$pb.TagNumber(4)
  Chats_SetDialog get setDialog => $_getN(3);
  @$pb.TagNumber(4)
  set setDialog(Chats_SetDialog value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSetDialog() => $_has(3);
  @$pb.TagNumber(4)
  void clearSetDialog() => $_clearField(4);
  @$pb.TagNumber(4)
  Chats_SetDialog ensureSetDialog() => $_ensure(3);

  @$pb.TagNumber(5)
  Chats_DeleteDialog get deleteDialog => $_getN(4);
  @$pb.TagNumber(5)
  set deleteDialog(Chats_DeleteDialog value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDeleteDialog() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeleteDialog() => $_clearField(5);
  @$pb.TagNumber(5)
  Chats_DeleteDialog ensureDeleteDialog() => $_ensure(4);

  @$pb.TagNumber(6)
  Chats_ReadDate get readDate => $_getN(5);
  @$pb.TagNumber(6)
  set readDate(Chats_ReadDate value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReadDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearReadDate() => $_clearField(6);
  @$pb.TagNumber(6)
  Chats_ReadDate ensureReadDate() => $_ensure(5);

  @$pb.TagNumber(7)
  Chats_CanWrite get canWrite => $_getN(6);
  @$pb.TagNumber(7)
  set canWrite(Chats_CanWrite value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCanWrite() => $_has(6);
  @$pb.TagNumber(7)
  void clearCanWrite() => $_clearField(7);
  @$pb.TagNumber(7)
  Chats_CanWrite ensureCanWrite() => $_ensure(6);

  @$pb.TagNumber(8)
  Chats_SaveDraft get saveDraft => $_getN(7);
  @$pb.TagNumber(8)
  set saveDraft(Chats_SaveDraft value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSaveDraft() => $_has(7);
  @$pb.TagNumber(8)
  void clearSaveDraft() => $_clearField(8);
  @$pb.TagNumber(8)
  Chats_SaveDraft ensureSaveDraft() => $_ensure(7);

  @$pb.TagNumber(9)
  Chats_GetFolders get getFolders => $_getN(8);
  @$pb.TagNumber(9)
  set getFolders(Chats_GetFolders value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasGetFolders() => $_has(8);
  @$pb.TagNumber(9)
  void clearGetFolders() => $_clearField(9);
  @$pb.TagNumber(9)
  Chats_GetFolders ensureGetFolders() => $_ensure(8);

  @$pb.TagNumber(10)
  Chats_SaveFolder get saveFolder => $_getN(9);
  @$pb.TagNumber(10)
  set saveFolder(Chats_SaveFolder value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSaveFolder() => $_has(9);
  @$pb.TagNumber(10)
  void clearSaveFolder() => $_clearField(10);
  @$pb.TagNumber(10)
  Chats_SaveFolder ensureSaveFolder() => $_ensure(9);

  @$pb.TagNumber(11)
  Chats_DeleteFolder get deleteFolder => $_getN(10);
  @$pb.TagNumber(11)
  set deleteFolder(Chats_DeleteFolder value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDeleteFolder() => $_has(10);
  @$pb.TagNumber(11)
  void clearDeleteFolder() => $_clearField(11);
  @$pb.TagNumber(11)
  Chats_DeleteFolder ensureDeleteFolder() => $_ensure(10);

  @$pb.TagNumber(12)
  Chats_ReorderFolders get reorderFolders => $_getN(11);
  @$pb.TagNumber(12)
  set reorderFolders(Chats_ReorderFolders value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasReorderFolders() => $_has(11);
  @$pb.TagNumber(12)
  void clearReorderFolders() => $_clearField(12);
  @$pb.TagNumber(12)
  Chats_ReorderFolders ensureReorderFolders() => $_ensure(11);

  @$pb.TagNumber(13)
  Chats_ResolveUsername get resolveUsername => $_getN(12);
  @$pb.TagNumber(13)
  set resolveUsername(Chats_ResolveUsername value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasResolveUsername() => $_has(12);
  @$pb.TagNumber(13)
  void clearResolveUsername() => $_clearField(13);
  @$pb.TagNumber(13)
  Chats_ResolveUsername ensureResolveUsername() => $_ensure(12);

  @$pb.TagNumber(14)
  Chats_SetTTL get setTTL => $_getN(13);
  @$pb.TagNumber(14)
  set setTTL(Chats_SetTTL value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSetTTL() => $_has(13);
  @$pb.TagNumber(14)
  void clearSetTTL() => $_clearField(14);
  @$pb.TagNumber(14)
  Chats_SetTTL ensureSetTTL() => $_ensure(13);

  @$pb.TagNumber(15)
  Chats_SetNoForwards get setNoForwards => $_getN(14);
  @$pb.TagNumber(15)
  set setNoForwards(Chats_SetNoForwards value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSetNoForwards() => $_has(14);
  @$pb.TagNumber(15)
  void clearSetNoForwards() => $_clearField(15);
  @$pb.TagNumber(15)
  Chats_SetNoForwards ensureSetNoForwards() => $_ensure(14);

  @$pb.TagNumber(16)
  Chats_SearchUsers get searchUsers => $_getN(15);
  @$pb.TagNumber(16)
  set searchUsers(Chats_SearchUsers value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasSearchUsers() => $_has(15);
  @$pb.TagNumber(16)
  void clearSearchUsers() => $_clearField(16);
  @$pb.TagNumber(16)
  Chats_SearchUsers ensureSearchUsers() => $_ensure(15);

  @$pb.TagNumber(17)
  Chats_CreateGroup get createGroup => $_getN(16);
  @$pb.TagNumber(17)
  set createGroup(Chats_CreateGroup value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasCreateGroup() => $_has(16);
  @$pb.TagNumber(17)
  void clearCreateGroup() => $_clearField(17);
  @$pb.TagNumber(17)
  Chats_CreateGroup ensureCreateGroup() => $_ensure(16);

  @$pb.TagNumber(18)
  Chats_EditChat get editChat => $_getN(17);
  @$pb.TagNumber(18)
  set editChat(Chats_EditChat value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasEditChat() => $_has(17);
  @$pb.TagNumber(18)
  void clearEditChat() => $_clearField(18);
  @$pb.TagNumber(18)
  Chats_EditChat ensureEditChat() => $_ensure(17);

  @$pb.TagNumber(19)
  Chats_AddMembers get addMembers => $_getN(18);
  @$pb.TagNumber(19)
  set addMembers(Chats_AddMembers value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasAddMembers() => $_has(18);
  @$pb.TagNumber(19)
  void clearAddMembers() => $_clearField(19);
  @$pb.TagNumber(19)
  Chats_AddMembers ensureAddMembers() => $_ensure(18);

  @$pb.TagNumber(20)
  Chats_LeaveChat get leaveChat => $_getN(19);
  @$pb.TagNumber(20)
  set leaveChat(Chats_LeaveChat value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasLeaveChat() => $_has(19);
  @$pb.TagNumber(20)
  void clearLeaveChat() => $_clearField(20);
  @$pb.TagNumber(20)
  Chats_LeaveChat ensureLeaveChat() => $_ensure(19);

  @$pb.TagNumber(21)
  Chats_DeleteChat get deleteChat => $_getN(20);
  @$pb.TagNumber(21)
  set deleteChat(Chats_DeleteChat value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasDeleteChat() => $_has(20);
  @$pb.TagNumber(21)
  void clearDeleteChat() => $_clearField(21);
  @$pb.TagNumber(21)
  Chats_DeleteChat ensureDeleteChat() => $_ensure(20);

  @$pb.TagNumber(22)
  Chats_Members get members => $_getN(21);
  @$pb.TagNumber(22)
  set members(Chats_Members value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasMembers() => $_has(21);
  @$pb.TagNumber(22)
  void clearMembers() => $_clearField(22);
  @$pb.TagNumber(22)
  Chats_Members ensureMembers() => $_ensure(21);

  @$pb.TagNumber(23)
  Chats_GetChatsState get getChatsState => $_getN(22);
  @$pb.TagNumber(23)
  set getChatsState(Chats_GetChatsState value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasGetChatsState() => $_has(22);
  @$pb.TagNumber(23)
  void clearGetChatsState() => $_clearField(23);
  @$pb.TagNumber(23)
  Chats_GetChatsState ensureGetChatsState() => $_ensure(22);

  @$pb.TagNumber(24)
  Chats_GetChatDifference get getChatDifference => $_getN(23);
  @$pb.TagNumber(24)
  set getChatDifference(Chats_GetChatDifference value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasGetChatDifference() => $_has(23);
  @$pb.TagNumber(24)
  void clearGetChatDifference() => $_clearField(24);
  @$pb.TagNumber(24)
  Chats_GetChatDifference ensureGetChatDifference() => $_ensure(23);

  @$pb.TagNumber(25)
  Chats_SetMemberRole get setMemberRole => $_getN(24);
  @$pb.TagNumber(25)
  set setMemberRole(Chats_SetMemberRole value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasSetMemberRole() => $_has(24);
  @$pb.TagNumber(25)
  void clearSetMemberRole() => $_clearField(25);
  @$pb.TagNumber(25)
  Chats_SetMemberRole ensureSetMemberRole() => $_ensure(24);

  @$pb.TagNumber(26)
  Chats_RemoveMember get removeMember => $_getN(25);
  @$pb.TagNumber(26)
  set removeMember(Chats_RemoveMember value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasRemoveMember() => $_has(25);
  @$pb.TagNumber(26)
  void clearRemoveMember() => $_clearField(26);
  @$pb.TagNumber(26)
  Chats_RemoveMember ensureRemoveMember() => $_ensure(25);

  @$pb.TagNumber(27)
  Chats_Banned get banned => $_getN(26);
  @$pb.TagNumber(27)
  set banned(Chats_Banned value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasBanned() => $_has(26);
  @$pb.TagNumber(27)
  void clearBanned() => $_clearField(27);
  @$pb.TagNumber(27)
  Chats_Banned ensureBanned() => $_ensure(26);

  @$pb.TagNumber(28)
  Chats_Unban get unban => $_getN(27);
  @$pb.TagNumber(28)
  set unban(Chats_Unban value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasUnban() => $_has(27);
  @$pb.TagNumber(28)
  void clearUnban() => $_clearField(28);
  @$pb.TagNumber(28)
  Chats_Unban ensureUnban() => $_ensure(27);

  @$pb.TagNumber(29)
  Chats_SetAdmin get setAdmin => $_getN(28);
  @$pb.TagNumber(29)
  set setAdmin(Chats_SetAdmin value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasSetAdmin() => $_has(28);
  @$pb.TagNumber(29)
  void clearSetAdmin() => $_clearField(29);
  @$pb.TagNumber(29)
  Chats_SetAdmin ensureSetAdmin() => $_ensure(28);

  @$pb.TagNumber(30)
  Chats_RemoveAdmin get removeAdmin => $_getN(29);
  @$pb.TagNumber(30)
  set removeAdmin(Chats_RemoveAdmin value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasRemoveAdmin() => $_has(29);
  @$pb.TagNumber(30)
  void clearRemoveAdmin() => $_clearField(30);
  @$pb.TagNumber(30)
  Chats_RemoveAdmin ensureRemoveAdmin() => $_ensure(29);

  @$pb.TagNumber(31)
  Chats_TransferOwnership get transferOwnership => $_getN(30);
  @$pb.TagNumber(31)
  set transferOwnership(Chats_TransferOwnership value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasTransferOwnership() => $_has(30);
  @$pb.TagNumber(31)
  void clearTransferOwnership() => $_clearField(31);
  @$pb.TagNumber(31)
  Chats_TransferOwnership ensureTransferOwnership() => $_ensure(30);

  @$pb.TagNumber(32)
  Chats_CheckUsername get checkUsername => $_getN(31);
  @$pb.TagNumber(32)
  set checkUsername(Chats_CheckUsername value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasCheckUsername() => $_has(31);
  @$pb.TagNumber(32)
  void clearCheckUsername() => $_clearField(32);
  @$pb.TagNumber(32)
  Chats_CheckUsername ensureCheckUsername() => $_ensure(31);

  @$pb.TagNumber(33)
  Chats_ResolveLink get resolveLink => $_getN(32);
  @$pb.TagNumber(33)
  set resolveLink(Chats_ResolveLink value) => $_setField(33, value);
  @$pb.TagNumber(33)
  $core.bool hasResolveLink() => $_has(32);
  @$pb.TagNumber(33)
  void clearResolveLink() => $_clearField(33);
  @$pb.TagNumber(33)
  Chats_ResolveLink ensureResolveLink() => $_ensure(32);

  @$pb.TagNumber(34)
  Chats_JoinChat get joinChat => $_getN(33);
  @$pb.TagNumber(34)
  set joinChat(Chats_JoinChat value) => $_setField(34, value);
  @$pb.TagNumber(34)
  $core.bool hasJoinChat() => $_has(33);
  @$pb.TagNumber(34)
  void clearJoinChat() => $_clearField(34);
  @$pb.TagNumber(34)
  Chats_JoinChat ensureJoinChat() => $_ensure(33);

  @$pb.TagNumber(35)
  Chats_InviteLinks get inviteLinks => $_getN(34);
  @$pb.TagNumber(35)
  set inviteLinks(Chats_InviteLinks value) => $_setField(35, value);
  @$pb.TagNumber(35)
  $core.bool hasInviteLinks() => $_has(34);
  @$pb.TagNumber(35)
  void clearInviteLinks() => $_clearField(35);
  @$pb.TagNumber(35)
  Chats_InviteLinks ensureInviteLinks() => $_ensure(34);

  @$pb.TagNumber(36)
  Chats_CreateInviteLink get createInviteLink => $_getN(35);
  @$pb.TagNumber(36)
  set createInviteLink(Chats_CreateInviteLink value) => $_setField(36, value);
  @$pb.TagNumber(36)
  $core.bool hasCreateInviteLink() => $_has(35);
  @$pb.TagNumber(36)
  void clearCreateInviteLink() => $_clearField(36);
  @$pb.TagNumber(36)
  Chats_CreateInviteLink ensureCreateInviteLink() => $_ensure(35);

  @$pb.TagNumber(37)
  Chats_EditInviteLink get editInviteLink => $_getN(36);
  @$pb.TagNumber(37)
  set editInviteLink(Chats_EditInviteLink value) => $_setField(37, value);
  @$pb.TagNumber(37)
  $core.bool hasEditInviteLink() => $_has(36);
  @$pb.TagNumber(37)
  void clearEditInviteLink() => $_clearField(37);
  @$pb.TagNumber(37)
  Chats_EditInviteLink ensureEditInviteLink() => $_ensure(36);

  @$pb.TagNumber(38)
  Chats_RevokeInviteLink get revokeInviteLink => $_getN(37);
  @$pb.TagNumber(38)
  set revokeInviteLink(Chats_RevokeInviteLink value) => $_setField(38, value);
  @$pb.TagNumber(38)
  $core.bool hasRevokeInviteLink() => $_has(37);
  @$pb.TagNumber(38)
  void clearRevokeInviteLink() => $_clearField(38);
  @$pb.TagNumber(38)
  Chats_RevokeInviteLink ensureRevokeInviteLink() => $_ensure(37);

  @$pb.TagNumber(39)
  Chats_DeleteRevokedInviteLinks get deleteRevokedInviteLinks => $_getN(38);
  @$pb.TagNumber(39)
  set deleteRevokedInviteLinks(Chats_DeleteRevokedInviteLinks value) => $_setField(39, value);
  @$pb.TagNumber(39)
  $core.bool hasDeleteRevokedInviteLinks() => $_has(38);
  @$pb.TagNumber(39)
  void clearDeleteRevokedInviteLinks() => $_clearField(39);
  @$pb.TagNumber(39)
  Chats_DeleteRevokedInviteLinks ensureDeleteRevokedInviteLinks() => $_ensure(38);

  @$pb.TagNumber(40)
  Chats_JoinRequests get joinRequests => $_getN(39);
  @$pb.TagNumber(40)
  set joinRequests(Chats_JoinRequests value) => $_setField(40, value);
  @$pb.TagNumber(40)
  $core.bool hasJoinRequests() => $_has(39);
  @$pb.TagNumber(40)
  void clearJoinRequests() => $_clearField(40);
  @$pb.TagNumber(40)
  Chats_JoinRequests ensureJoinRequests() => $_ensure(39);

  @$pb.TagNumber(41)
  Chats_AnswerJoinRequest get answerJoinRequest => $_getN(40);
  @$pb.TagNumber(41)
  set answerJoinRequest(Chats_AnswerJoinRequest value) => $_setField(41, value);
  @$pb.TagNumber(41)
  $core.bool hasAnswerJoinRequest() => $_has(40);
  @$pb.TagNumber(41)
  void clearAnswerJoinRequest() => $_clearField(41);
  @$pb.TagNumber(41)
  Chats_AnswerJoinRequest ensureAnswerJoinRequest() => $_ensure(40);

  @$pb.TagNumber(42)
  Chats_SearchChats get searchChats => $_getN(41);
  @$pb.TagNumber(42)
  set searchChats(Chats_SearchChats value) => $_setField(42, value);
  @$pb.TagNumber(42)
  $core.bool hasSearchChats() => $_has(41);
  @$pb.TagNumber(42)
  void clearSearchChats() => $_clearField(42);
  @$pb.TagNumber(42)
  Chats_SearchChats ensureSearchChats() => $_ensure(41);
}

enum Chats_Response_Response {
  list,
  openPrivate,
  readHistory,
  setDialog,
  deleteDialog,
  readDate,
  canWrite,
  saveDraft,
  getFolders,
  saveFolder,
  deleteFolder,
  reorderFolders,
  resolveUsername,
  setTTL,
  setNoForwards,
  searchUsers,
  createGroup,
  editChat,
  addMembers,
  leaveChat,
  deleteChat,
  members,
  getChatsState,
  getChatDifference,
  setMemberRole,
  removeMember,
  banned,
  unban,
  setAdmin,
  removeAdmin,
  transferOwnership,
  checkUsername,
  resolveLink,
  joinChat,
  inviteLinks,
  createInviteLink,
  editInviteLink,
  revokeInviteLink,
  deleteRevokedInviteLinks,
  joinRequests,
  answerJoinRequest,
  searchChats,
  notSet
}

class Chats_Response extends $pb.GeneratedMessage {
  factory Chats_Response({
    Chats_ListResult? list,
    Chats_OpenPrivateResult? openPrivate,
    Chats_ReadHistoryResult? readHistory,
    Chats_SetDialogResult? setDialog,
    Chats_DeleteDialogResult? deleteDialog,
    Chats_ReadDateResult? readDate,
    Chats_CanWriteResult? canWrite,
    Chats_SaveDraftResult? saveDraft,
    Chats_GetFoldersResult? getFolders,
    Chats_SaveFolderResult? saveFolder,
    Chats_DeleteFolderResult? deleteFolder,
    Chats_ReorderFoldersResult? reorderFolders,
    Chats_ResolveUsernameResult? resolveUsername,
    Chats_SetTTLResult? setTTL,
    Chats_SetNoForwardsResult? setNoForwards,
    Chats_SearchUsersResult? searchUsers,
    Chats_CreateGroupResult? createGroup,
    Chats_EditChatResult? editChat,
    Chats_AddMembersResult? addMembers,
    Chats_LeaveChatResult? leaveChat,
    Chats_DeleteChatResult? deleteChat,
    Chats_MembersResult? members,
    Chats_GetChatsStateResult? getChatsState,
    Chats_GetChatDifferenceResult? getChatDifference,
    Chats_SetMemberRoleResult? setMemberRole,
    Chats_RemoveMemberResult? removeMember,
    Chats_BannedResult? banned,
    Chats_UnbanResult? unban,
    Chats_SetAdminResult? setAdmin,
    Chats_RemoveAdminResult? removeAdmin,
    Chats_TransferOwnershipResult? transferOwnership,
    Chats_CheckUsernameResult? checkUsername,
    Chats_ResolveLinkResult? resolveLink,
    Chats_JoinChatResult? joinChat,
    Chats_InviteLinksResult? inviteLinks,
    Chats_CreateInviteLinkResult? createInviteLink,
    Chats_EditInviteLinkResult? editInviteLink,
    Chats_RevokeInviteLinkResult? revokeInviteLink,
    Chats_DeleteRevokedInviteLinksResult? deleteRevokedInviteLinks,
    Chats_JoinRequestsResult? joinRequests,
    Chats_AnswerJoinRequestResult? answerJoinRequest,
    Chats_SearchChatsResult? searchChats,
  }) {
    final result = create();
    if (list != null) result.list = list;
    if (openPrivate != null) result.openPrivate = openPrivate;
    if (readHistory != null) result.readHistory = readHistory;
    if (setDialog != null) result.setDialog = setDialog;
    if (deleteDialog != null) result.deleteDialog = deleteDialog;
    if (readDate != null) result.readDate = readDate;
    if (canWrite != null) result.canWrite = canWrite;
    if (saveDraft != null) result.saveDraft = saveDraft;
    if (getFolders != null) result.getFolders = getFolders;
    if (saveFolder != null) result.saveFolder = saveFolder;
    if (deleteFolder != null) result.deleteFolder = deleteFolder;
    if (reorderFolders != null) result.reorderFolders = reorderFolders;
    if (resolveUsername != null) result.resolveUsername = resolveUsername;
    if (setTTL != null) result.setTTL = setTTL;
    if (setNoForwards != null) result.setNoForwards = setNoForwards;
    if (searchUsers != null) result.searchUsers = searchUsers;
    if (createGroup != null) result.createGroup = createGroup;
    if (editChat != null) result.editChat = editChat;
    if (addMembers != null) result.addMembers = addMembers;
    if (leaveChat != null) result.leaveChat = leaveChat;
    if (deleteChat != null) result.deleteChat = deleteChat;
    if (members != null) result.members = members;
    if (getChatsState != null) result.getChatsState = getChatsState;
    if (getChatDifference != null) result.getChatDifference = getChatDifference;
    if (setMemberRole != null) result.setMemberRole = setMemberRole;
    if (removeMember != null) result.removeMember = removeMember;
    if (banned != null) result.banned = banned;
    if (unban != null) result.unban = unban;
    if (setAdmin != null) result.setAdmin = setAdmin;
    if (removeAdmin != null) result.removeAdmin = removeAdmin;
    if (transferOwnership != null) result.transferOwnership = transferOwnership;
    if (checkUsername != null) result.checkUsername = checkUsername;
    if (resolveLink != null) result.resolveLink = resolveLink;
    if (joinChat != null) result.joinChat = joinChat;
    if (inviteLinks != null) result.inviteLinks = inviteLinks;
    if (createInviteLink != null) result.createInviteLink = createInviteLink;
    if (editInviteLink != null) result.editInviteLink = editInviteLink;
    if (revokeInviteLink != null) result.revokeInviteLink = revokeInviteLink;
    if (deleteRevokedInviteLinks != null) result.deleteRevokedInviteLinks = deleteRevokedInviteLinks;
    if (joinRequests != null) result.joinRequests = joinRequests;
    if (answerJoinRequest != null) result.answerJoinRequest = answerJoinRequest;
    if (searchChats != null) result.searchChats = searchChats;
    return result;
  }

  Chats_Response._();

  factory Chats_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Chats_Response_Response> _Chats_Response_ResponseByTag = {
    1: Chats_Response_Response.list,
    2: Chats_Response_Response.openPrivate,
    3: Chats_Response_Response.readHistory,
    4: Chats_Response_Response.setDialog,
    5: Chats_Response_Response.deleteDialog,
    6: Chats_Response_Response.readDate,
    7: Chats_Response_Response.canWrite,
    8: Chats_Response_Response.saveDraft,
    9: Chats_Response_Response.getFolders,
    10: Chats_Response_Response.saveFolder,
    11: Chats_Response_Response.deleteFolder,
    12: Chats_Response_Response.reorderFolders,
    13: Chats_Response_Response.resolveUsername,
    14: Chats_Response_Response.setTTL,
    15: Chats_Response_Response.setNoForwards,
    16: Chats_Response_Response.searchUsers,
    17: Chats_Response_Response.createGroup,
    18: Chats_Response_Response.editChat,
    19: Chats_Response_Response.addMembers,
    20: Chats_Response_Response.leaveChat,
    21: Chats_Response_Response.deleteChat,
    22: Chats_Response_Response.members,
    23: Chats_Response_Response.getChatsState,
    24: Chats_Response_Response.getChatDifference,
    25: Chats_Response_Response.setMemberRole,
    26: Chats_Response_Response.removeMember,
    27: Chats_Response_Response.banned,
    28: Chats_Response_Response.unban,
    29: Chats_Response_Response.setAdmin,
    30: Chats_Response_Response.removeAdmin,
    31: Chats_Response_Response.transferOwnership,
    32: Chats_Response_Response.checkUsername,
    33: Chats_Response_Response.resolveLink,
    34: Chats_Response_Response.joinChat,
    35: Chats_Response_Response.inviteLinks,
    36: Chats_Response_Response.createInviteLink,
    37: Chats_Response_Response.editInviteLink,
    38: Chats_Response_Response.revokeInviteLink,
    39: Chats_Response_Response.deleteRevokedInviteLinks,
    40: Chats_Response_Response.joinRequests,
    41: Chats_Response_Response.answerJoinRequest,
    42: Chats_Response_Response.searchChats,
    0: Chats_Response_Response.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
      39,
      40,
      41,
      42
    ])
    ..aOM<Chats_ListResult>(1, _omitFieldNames ? '' : 'list', subBuilder: Chats_ListResult.create)
    ..aOM<Chats_OpenPrivateResult>(2, _omitFieldNames ? '' : 'openPrivate',
        protoName: 'openPrivate', subBuilder: Chats_OpenPrivateResult.create)
    ..aOM<Chats_ReadHistoryResult>(3, _omitFieldNames ? '' : 'readHistory',
        protoName: 'readHistory', subBuilder: Chats_ReadHistoryResult.create)
    ..aOM<Chats_SetDialogResult>(4, _omitFieldNames ? '' : 'setDialog', protoName: 'setDialog', subBuilder: Chats_SetDialogResult.create)
    ..aOM<Chats_DeleteDialogResult>(5, _omitFieldNames ? '' : 'deleteDialog',
        protoName: 'deleteDialog', subBuilder: Chats_DeleteDialogResult.create)
    ..aOM<Chats_ReadDateResult>(6, _omitFieldNames ? '' : 'readDate', protoName: 'readDate', subBuilder: Chats_ReadDateResult.create)
    ..aOM<Chats_CanWriteResult>(7, _omitFieldNames ? '' : 'canWrite', protoName: 'canWrite', subBuilder: Chats_CanWriteResult.create)
    ..aOM<Chats_SaveDraftResult>(8, _omitFieldNames ? '' : 'saveDraft', protoName: 'saveDraft', subBuilder: Chats_SaveDraftResult.create)
    ..aOM<Chats_GetFoldersResult>(9, _omitFieldNames ? '' : 'getFolders',
        protoName: 'getFolders', subBuilder: Chats_GetFoldersResult.create)
    ..aOM<Chats_SaveFolderResult>(10, _omitFieldNames ? '' : 'saveFolder',
        protoName: 'saveFolder', subBuilder: Chats_SaveFolderResult.create)
    ..aOM<Chats_DeleteFolderResult>(11, _omitFieldNames ? '' : 'deleteFolder',
        protoName: 'deleteFolder', subBuilder: Chats_DeleteFolderResult.create)
    ..aOM<Chats_ReorderFoldersResult>(12, _omitFieldNames ? '' : 'reorderFolders',
        protoName: 'reorderFolders', subBuilder: Chats_ReorderFoldersResult.create)
    ..aOM<Chats_ResolveUsernameResult>(13, _omitFieldNames ? '' : 'resolveUsername',
        protoName: 'resolveUsername', subBuilder: Chats_ResolveUsernameResult.create)
    ..aOM<Chats_SetTTLResult>(14, _omitFieldNames ? '' : 'setTTL', protoName: 'setTTL', subBuilder: Chats_SetTTLResult.create)
    ..aOM<Chats_SetNoForwardsResult>(15, _omitFieldNames ? '' : 'setNoForwards',
        protoName: 'setNoForwards', subBuilder: Chats_SetNoForwardsResult.create)
    ..aOM<Chats_SearchUsersResult>(16, _omitFieldNames ? '' : 'searchUsers',
        protoName: 'searchUsers', subBuilder: Chats_SearchUsersResult.create)
    ..aOM<Chats_CreateGroupResult>(17, _omitFieldNames ? '' : 'createGroup',
        protoName: 'createGroup', subBuilder: Chats_CreateGroupResult.create)
    ..aOM<Chats_EditChatResult>(18, _omitFieldNames ? '' : 'editChat', protoName: 'editChat', subBuilder: Chats_EditChatResult.create)
    ..aOM<Chats_AddMembersResult>(19, _omitFieldNames ? '' : 'addMembers',
        protoName: 'addMembers', subBuilder: Chats_AddMembersResult.create)
    ..aOM<Chats_LeaveChatResult>(20, _omitFieldNames ? '' : 'leaveChat', protoName: 'leaveChat', subBuilder: Chats_LeaveChatResult.create)
    ..aOM<Chats_DeleteChatResult>(21, _omitFieldNames ? '' : 'deleteChat',
        protoName: 'deleteChat', subBuilder: Chats_DeleteChatResult.create)
    ..aOM<Chats_MembersResult>(22, _omitFieldNames ? '' : 'members', subBuilder: Chats_MembersResult.create)
    ..aOM<Chats_GetChatsStateResult>(23, _omitFieldNames ? '' : 'getChatsState',
        protoName: 'getChatsState', subBuilder: Chats_GetChatsStateResult.create)
    ..aOM<Chats_GetChatDifferenceResult>(24, _omitFieldNames ? '' : 'getChatDifference',
        protoName: 'getChatDifference', subBuilder: Chats_GetChatDifferenceResult.create)
    ..aOM<Chats_SetMemberRoleResult>(25, _omitFieldNames ? '' : 'setMemberRole',
        protoName: 'setMemberRole', subBuilder: Chats_SetMemberRoleResult.create)
    ..aOM<Chats_RemoveMemberResult>(26, _omitFieldNames ? '' : 'removeMember',
        protoName: 'removeMember', subBuilder: Chats_RemoveMemberResult.create)
    ..aOM<Chats_BannedResult>(27, _omitFieldNames ? '' : 'banned', subBuilder: Chats_BannedResult.create)
    ..aOM<Chats_UnbanResult>(28, _omitFieldNames ? '' : 'unban', subBuilder: Chats_UnbanResult.create)
    ..aOM<Chats_SetAdminResult>(29, _omitFieldNames ? '' : 'setAdmin', protoName: 'setAdmin', subBuilder: Chats_SetAdminResult.create)
    ..aOM<Chats_RemoveAdminResult>(30, _omitFieldNames ? '' : 'removeAdmin',
        protoName: 'removeAdmin', subBuilder: Chats_RemoveAdminResult.create)
    ..aOM<Chats_TransferOwnershipResult>(31, _omitFieldNames ? '' : 'transferOwnership',
        protoName: 'transferOwnership', subBuilder: Chats_TransferOwnershipResult.create)
    ..aOM<Chats_CheckUsernameResult>(32, _omitFieldNames ? '' : 'checkUsername',
        protoName: 'checkUsername', subBuilder: Chats_CheckUsernameResult.create)
    ..aOM<Chats_ResolveLinkResult>(33, _omitFieldNames ? '' : 'resolveLink',
        protoName: 'resolveLink', subBuilder: Chats_ResolveLinkResult.create)
    ..aOM<Chats_JoinChatResult>(34, _omitFieldNames ? '' : 'joinChat', protoName: 'joinChat', subBuilder: Chats_JoinChatResult.create)
    ..aOM<Chats_InviteLinksResult>(35, _omitFieldNames ? '' : 'inviteLinks',
        protoName: 'inviteLinks', subBuilder: Chats_InviteLinksResult.create)
    ..aOM<Chats_CreateInviteLinkResult>(36, _omitFieldNames ? '' : 'createInviteLink',
        protoName: 'createInviteLink', subBuilder: Chats_CreateInviteLinkResult.create)
    ..aOM<Chats_EditInviteLinkResult>(37, _omitFieldNames ? '' : 'editInviteLink',
        protoName: 'editInviteLink', subBuilder: Chats_EditInviteLinkResult.create)
    ..aOM<Chats_RevokeInviteLinkResult>(38, _omitFieldNames ? '' : 'revokeInviteLink',
        protoName: 'revokeInviteLink', subBuilder: Chats_RevokeInviteLinkResult.create)
    ..aOM<Chats_DeleteRevokedInviteLinksResult>(39, _omitFieldNames ? '' : 'deleteRevokedInviteLinks',
        protoName: 'deleteRevokedInviteLinks', subBuilder: Chats_DeleteRevokedInviteLinksResult.create)
    ..aOM<Chats_JoinRequestsResult>(40, _omitFieldNames ? '' : 'joinRequests',
        protoName: 'joinRequests', subBuilder: Chats_JoinRequestsResult.create)
    ..aOM<Chats_AnswerJoinRequestResult>(41, _omitFieldNames ? '' : 'answerJoinRequest',
        protoName: 'answerJoinRequest', subBuilder: Chats_AnswerJoinRequestResult.create)
    ..aOM<Chats_SearchChatsResult>(42, _omitFieldNames ? '' : 'searchChats',
        protoName: 'searchChats', subBuilder: Chats_SearchChatsResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Response copyWith(void Function(Chats_Response) updates) =>
      super.copyWith((message) => updates(message as Chats_Response)) as Chats_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_Response create() => Chats_Response._();
  @$core.override
  Chats_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_Response>(create);
  static Chats_Response? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  @$pb.TagNumber(33)
  @$pb.TagNumber(34)
  @$pb.TagNumber(35)
  @$pb.TagNumber(36)
  @$pb.TagNumber(37)
  @$pb.TagNumber(38)
  @$pb.TagNumber(39)
  @$pb.TagNumber(40)
  @$pb.TagNumber(41)
  @$pb.TagNumber(42)
  Chats_Response_Response whichResponse() => _Chats_Response_ResponseByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  @$pb.TagNumber(33)
  @$pb.TagNumber(34)
  @$pb.TagNumber(35)
  @$pb.TagNumber(36)
  @$pb.TagNumber(37)
  @$pb.TagNumber(38)
  @$pb.TagNumber(39)
  @$pb.TagNumber(40)
  @$pb.TagNumber(41)
  @$pb.TagNumber(42)
  void clearResponse() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Chats_ListResult get list => $_getN(0);
  @$pb.TagNumber(1)
  set list(Chats_ListResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasList() => $_has(0);
  @$pb.TagNumber(1)
  void clearList() => $_clearField(1);
  @$pb.TagNumber(1)
  Chats_ListResult ensureList() => $_ensure(0);

  @$pb.TagNumber(2)
  Chats_OpenPrivateResult get openPrivate => $_getN(1);
  @$pb.TagNumber(2)
  set openPrivate(Chats_OpenPrivateResult value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenPrivate() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenPrivate() => $_clearField(2);
  @$pb.TagNumber(2)
  Chats_OpenPrivateResult ensureOpenPrivate() => $_ensure(1);

  @$pb.TagNumber(3)
  Chats_ReadHistoryResult get readHistory => $_getN(2);
  @$pb.TagNumber(3)
  set readHistory(Chats_ReadHistoryResult value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReadHistory() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadHistory() => $_clearField(3);
  @$pb.TagNumber(3)
  Chats_ReadHistoryResult ensureReadHistory() => $_ensure(2);

  @$pb.TagNumber(4)
  Chats_SetDialogResult get setDialog => $_getN(3);
  @$pb.TagNumber(4)
  set setDialog(Chats_SetDialogResult value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSetDialog() => $_has(3);
  @$pb.TagNumber(4)
  void clearSetDialog() => $_clearField(4);
  @$pb.TagNumber(4)
  Chats_SetDialogResult ensureSetDialog() => $_ensure(3);

  @$pb.TagNumber(5)
  Chats_DeleteDialogResult get deleteDialog => $_getN(4);
  @$pb.TagNumber(5)
  set deleteDialog(Chats_DeleteDialogResult value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDeleteDialog() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeleteDialog() => $_clearField(5);
  @$pb.TagNumber(5)
  Chats_DeleteDialogResult ensureDeleteDialog() => $_ensure(4);

  @$pb.TagNumber(6)
  Chats_ReadDateResult get readDate => $_getN(5);
  @$pb.TagNumber(6)
  set readDate(Chats_ReadDateResult value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReadDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearReadDate() => $_clearField(6);
  @$pb.TagNumber(6)
  Chats_ReadDateResult ensureReadDate() => $_ensure(5);

  @$pb.TagNumber(7)
  Chats_CanWriteResult get canWrite => $_getN(6);
  @$pb.TagNumber(7)
  set canWrite(Chats_CanWriteResult value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCanWrite() => $_has(6);
  @$pb.TagNumber(7)
  void clearCanWrite() => $_clearField(7);
  @$pb.TagNumber(7)
  Chats_CanWriteResult ensureCanWrite() => $_ensure(6);

  @$pb.TagNumber(8)
  Chats_SaveDraftResult get saveDraft => $_getN(7);
  @$pb.TagNumber(8)
  set saveDraft(Chats_SaveDraftResult value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSaveDraft() => $_has(7);
  @$pb.TagNumber(8)
  void clearSaveDraft() => $_clearField(8);
  @$pb.TagNumber(8)
  Chats_SaveDraftResult ensureSaveDraft() => $_ensure(7);

  @$pb.TagNumber(9)
  Chats_GetFoldersResult get getFolders => $_getN(8);
  @$pb.TagNumber(9)
  set getFolders(Chats_GetFoldersResult value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasGetFolders() => $_has(8);
  @$pb.TagNumber(9)
  void clearGetFolders() => $_clearField(9);
  @$pb.TagNumber(9)
  Chats_GetFoldersResult ensureGetFolders() => $_ensure(8);

  @$pb.TagNumber(10)
  Chats_SaveFolderResult get saveFolder => $_getN(9);
  @$pb.TagNumber(10)
  set saveFolder(Chats_SaveFolderResult value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSaveFolder() => $_has(9);
  @$pb.TagNumber(10)
  void clearSaveFolder() => $_clearField(10);
  @$pb.TagNumber(10)
  Chats_SaveFolderResult ensureSaveFolder() => $_ensure(9);

  @$pb.TagNumber(11)
  Chats_DeleteFolderResult get deleteFolder => $_getN(10);
  @$pb.TagNumber(11)
  set deleteFolder(Chats_DeleteFolderResult value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDeleteFolder() => $_has(10);
  @$pb.TagNumber(11)
  void clearDeleteFolder() => $_clearField(11);
  @$pb.TagNumber(11)
  Chats_DeleteFolderResult ensureDeleteFolder() => $_ensure(10);

  @$pb.TagNumber(12)
  Chats_ReorderFoldersResult get reorderFolders => $_getN(11);
  @$pb.TagNumber(12)
  set reorderFolders(Chats_ReorderFoldersResult value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasReorderFolders() => $_has(11);
  @$pb.TagNumber(12)
  void clearReorderFolders() => $_clearField(12);
  @$pb.TagNumber(12)
  Chats_ReorderFoldersResult ensureReorderFolders() => $_ensure(11);

  @$pb.TagNumber(13)
  Chats_ResolveUsernameResult get resolveUsername => $_getN(12);
  @$pb.TagNumber(13)
  set resolveUsername(Chats_ResolveUsernameResult value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasResolveUsername() => $_has(12);
  @$pb.TagNumber(13)
  void clearResolveUsername() => $_clearField(13);
  @$pb.TagNumber(13)
  Chats_ResolveUsernameResult ensureResolveUsername() => $_ensure(12);

  @$pb.TagNumber(14)
  Chats_SetTTLResult get setTTL => $_getN(13);
  @$pb.TagNumber(14)
  set setTTL(Chats_SetTTLResult value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSetTTL() => $_has(13);
  @$pb.TagNumber(14)
  void clearSetTTL() => $_clearField(14);
  @$pb.TagNumber(14)
  Chats_SetTTLResult ensureSetTTL() => $_ensure(13);

  @$pb.TagNumber(15)
  Chats_SetNoForwardsResult get setNoForwards => $_getN(14);
  @$pb.TagNumber(15)
  set setNoForwards(Chats_SetNoForwardsResult value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSetNoForwards() => $_has(14);
  @$pb.TagNumber(15)
  void clearSetNoForwards() => $_clearField(15);
  @$pb.TagNumber(15)
  Chats_SetNoForwardsResult ensureSetNoForwards() => $_ensure(14);

  @$pb.TagNumber(16)
  Chats_SearchUsersResult get searchUsers => $_getN(15);
  @$pb.TagNumber(16)
  set searchUsers(Chats_SearchUsersResult value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasSearchUsers() => $_has(15);
  @$pb.TagNumber(16)
  void clearSearchUsers() => $_clearField(16);
  @$pb.TagNumber(16)
  Chats_SearchUsersResult ensureSearchUsers() => $_ensure(15);

  @$pb.TagNumber(17)
  Chats_CreateGroupResult get createGroup => $_getN(16);
  @$pb.TagNumber(17)
  set createGroup(Chats_CreateGroupResult value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasCreateGroup() => $_has(16);
  @$pb.TagNumber(17)
  void clearCreateGroup() => $_clearField(17);
  @$pb.TagNumber(17)
  Chats_CreateGroupResult ensureCreateGroup() => $_ensure(16);

  @$pb.TagNumber(18)
  Chats_EditChatResult get editChat => $_getN(17);
  @$pb.TagNumber(18)
  set editChat(Chats_EditChatResult value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasEditChat() => $_has(17);
  @$pb.TagNumber(18)
  void clearEditChat() => $_clearField(18);
  @$pb.TagNumber(18)
  Chats_EditChatResult ensureEditChat() => $_ensure(17);

  @$pb.TagNumber(19)
  Chats_AddMembersResult get addMembers => $_getN(18);
  @$pb.TagNumber(19)
  set addMembers(Chats_AddMembersResult value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasAddMembers() => $_has(18);
  @$pb.TagNumber(19)
  void clearAddMembers() => $_clearField(19);
  @$pb.TagNumber(19)
  Chats_AddMembersResult ensureAddMembers() => $_ensure(18);

  @$pb.TagNumber(20)
  Chats_LeaveChatResult get leaveChat => $_getN(19);
  @$pb.TagNumber(20)
  set leaveChat(Chats_LeaveChatResult value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasLeaveChat() => $_has(19);
  @$pb.TagNumber(20)
  void clearLeaveChat() => $_clearField(20);
  @$pb.TagNumber(20)
  Chats_LeaveChatResult ensureLeaveChat() => $_ensure(19);

  @$pb.TagNumber(21)
  Chats_DeleteChatResult get deleteChat => $_getN(20);
  @$pb.TagNumber(21)
  set deleteChat(Chats_DeleteChatResult value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasDeleteChat() => $_has(20);
  @$pb.TagNumber(21)
  void clearDeleteChat() => $_clearField(21);
  @$pb.TagNumber(21)
  Chats_DeleteChatResult ensureDeleteChat() => $_ensure(20);

  @$pb.TagNumber(22)
  Chats_MembersResult get members => $_getN(21);
  @$pb.TagNumber(22)
  set members(Chats_MembersResult value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasMembers() => $_has(21);
  @$pb.TagNumber(22)
  void clearMembers() => $_clearField(22);
  @$pb.TagNumber(22)
  Chats_MembersResult ensureMembers() => $_ensure(21);

  @$pb.TagNumber(23)
  Chats_GetChatsStateResult get getChatsState => $_getN(22);
  @$pb.TagNumber(23)
  set getChatsState(Chats_GetChatsStateResult value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasGetChatsState() => $_has(22);
  @$pb.TagNumber(23)
  void clearGetChatsState() => $_clearField(23);
  @$pb.TagNumber(23)
  Chats_GetChatsStateResult ensureGetChatsState() => $_ensure(22);

  @$pb.TagNumber(24)
  Chats_GetChatDifferenceResult get getChatDifference => $_getN(23);
  @$pb.TagNumber(24)
  set getChatDifference(Chats_GetChatDifferenceResult value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasGetChatDifference() => $_has(23);
  @$pb.TagNumber(24)
  void clearGetChatDifference() => $_clearField(24);
  @$pb.TagNumber(24)
  Chats_GetChatDifferenceResult ensureGetChatDifference() => $_ensure(23);

  @$pb.TagNumber(25)
  Chats_SetMemberRoleResult get setMemberRole => $_getN(24);
  @$pb.TagNumber(25)
  set setMemberRole(Chats_SetMemberRoleResult value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasSetMemberRole() => $_has(24);
  @$pb.TagNumber(25)
  void clearSetMemberRole() => $_clearField(25);
  @$pb.TagNumber(25)
  Chats_SetMemberRoleResult ensureSetMemberRole() => $_ensure(24);

  @$pb.TagNumber(26)
  Chats_RemoveMemberResult get removeMember => $_getN(25);
  @$pb.TagNumber(26)
  set removeMember(Chats_RemoveMemberResult value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasRemoveMember() => $_has(25);
  @$pb.TagNumber(26)
  void clearRemoveMember() => $_clearField(26);
  @$pb.TagNumber(26)
  Chats_RemoveMemberResult ensureRemoveMember() => $_ensure(25);

  @$pb.TagNumber(27)
  Chats_BannedResult get banned => $_getN(26);
  @$pb.TagNumber(27)
  set banned(Chats_BannedResult value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasBanned() => $_has(26);
  @$pb.TagNumber(27)
  void clearBanned() => $_clearField(27);
  @$pb.TagNumber(27)
  Chats_BannedResult ensureBanned() => $_ensure(26);

  @$pb.TagNumber(28)
  Chats_UnbanResult get unban => $_getN(27);
  @$pb.TagNumber(28)
  set unban(Chats_UnbanResult value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasUnban() => $_has(27);
  @$pb.TagNumber(28)
  void clearUnban() => $_clearField(28);
  @$pb.TagNumber(28)
  Chats_UnbanResult ensureUnban() => $_ensure(27);

  @$pb.TagNumber(29)
  Chats_SetAdminResult get setAdmin => $_getN(28);
  @$pb.TagNumber(29)
  set setAdmin(Chats_SetAdminResult value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasSetAdmin() => $_has(28);
  @$pb.TagNumber(29)
  void clearSetAdmin() => $_clearField(29);
  @$pb.TagNumber(29)
  Chats_SetAdminResult ensureSetAdmin() => $_ensure(28);

  @$pb.TagNumber(30)
  Chats_RemoveAdminResult get removeAdmin => $_getN(29);
  @$pb.TagNumber(30)
  set removeAdmin(Chats_RemoveAdminResult value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasRemoveAdmin() => $_has(29);
  @$pb.TagNumber(30)
  void clearRemoveAdmin() => $_clearField(30);
  @$pb.TagNumber(30)
  Chats_RemoveAdminResult ensureRemoveAdmin() => $_ensure(29);

  @$pb.TagNumber(31)
  Chats_TransferOwnershipResult get transferOwnership => $_getN(30);
  @$pb.TagNumber(31)
  set transferOwnership(Chats_TransferOwnershipResult value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasTransferOwnership() => $_has(30);
  @$pb.TagNumber(31)
  void clearTransferOwnership() => $_clearField(31);
  @$pb.TagNumber(31)
  Chats_TransferOwnershipResult ensureTransferOwnership() => $_ensure(30);

  @$pb.TagNumber(32)
  Chats_CheckUsernameResult get checkUsername => $_getN(31);
  @$pb.TagNumber(32)
  set checkUsername(Chats_CheckUsernameResult value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasCheckUsername() => $_has(31);
  @$pb.TagNumber(32)
  void clearCheckUsername() => $_clearField(32);
  @$pb.TagNumber(32)
  Chats_CheckUsernameResult ensureCheckUsername() => $_ensure(31);

  @$pb.TagNumber(33)
  Chats_ResolveLinkResult get resolveLink => $_getN(32);
  @$pb.TagNumber(33)
  set resolveLink(Chats_ResolveLinkResult value) => $_setField(33, value);
  @$pb.TagNumber(33)
  $core.bool hasResolveLink() => $_has(32);
  @$pb.TagNumber(33)
  void clearResolveLink() => $_clearField(33);
  @$pb.TagNumber(33)
  Chats_ResolveLinkResult ensureResolveLink() => $_ensure(32);

  @$pb.TagNumber(34)
  Chats_JoinChatResult get joinChat => $_getN(33);
  @$pb.TagNumber(34)
  set joinChat(Chats_JoinChatResult value) => $_setField(34, value);
  @$pb.TagNumber(34)
  $core.bool hasJoinChat() => $_has(33);
  @$pb.TagNumber(34)
  void clearJoinChat() => $_clearField(34);
  @$pb.TagNumber(34)
  Chats_JoinChatResult ensureJoinChat() => $_ensure(33);

  @$pb.TagNumber(35)
  Chats_InviteLinksResult get inviteLinks => $_getN(34);
  @$pb.TagNumber(35)
  set inviteLinks(Chats_InviteLinksResult value) => $_setField(35, value);
  @$pb.TagNumber(35)
  $core.bool hasInviteLinks() => $_has(34);
  @$pb.TagNumber(35)
  void clearInviteLinks() => $_clearField(35);
  @$pb.TagNumber(35)
  Chats_InviteLinksResult ensureInviteLinks() => $_ensure(34);

  @$pb.TagNumber(36)
  Chats_CreateInviteLinkResult get createInviteLink => $_getN(35);
  @$pb.TagNumber(36)
  set createInviteLink(Chats_CreateInviteLinkResult value) => $_setField(36, value);
  @$pb.TagNumber(36)
  $core.bool hasCreateInviteLink() => $_has(35);
  @$pb.TagNumber(36)
  void clearCreateInviteLink() => $_clearField(36);
  @$pb.TagNumber(36)
  Chats_CreateInviteLinkResult ensureCreateInviteLink() => $_ensure(35);

  @$pb.TagNumber(37)
  Chats_EditInviteLinkResult get editInviteLink => $_getN(36);
  @$pb.TagNumber(37)
  set editInviteLink(Chats_EditInviteLinkResult value) => $_setField(37, value);
  @$pb.TagNumber(37)
  $core.bool hasEditInviteLink() => $_has(36);
  @$pb.TagNumber(37)
  void clearEditInviteLink() => $_clearField(37);
  @$pb.TagNumber(37)
  Chats_EditInviteLinkResult ensureEditInviteLink() => $_ensure(36);

  @$pb.TagNumber(38)
  Chats_RevokeInviteLinkResult get revokeInviteLink => $_getN(37);
  @$pb.TagNumber(38)
  set revokeInviteLink(Chats_RevokeInviteLinkResult value) => $_setField(38, value);
  @$pb.TagNumber(38)
  $core.bool hasRevokeInviteLink() => $_has(37);
  @$pb.TagNumber(38)
  void clearRevokeInviteLink() => $_clearField(38);
  @$pb.TagNumber(38)
  Chats_RevokeInviteLinkResult ensureRevokeInviteLink() => $_ensure(37);

  @$pb.TagNumber(39)
  Chats_DeleteRevokedInviteLinksResult get deleteRevokedInviteLinks => $_getN(38);
  @$pb.TagNumber(39)
  set deleteRevokedInviteLinks(Chats_DeleteRevokedInviteLinksResult value) => $_setField(39, value);
  @$pb.TagNumber(39)
  $core.bool hasDeleteRevokedInviteLinks() => $_has(38);
  @$pb.TagNumber(39)
  void clearDeleteRevokedInviteLinks() => $_clearField(39);
  @$pb.TagNumber(39)
  Chats_DeleteRevokedInviteLinksResult ensureDeleteRevokedInviteLinks() => $_ensure(38);

  @$pb.TagNumber(40)
  Chats_JoinRequestsResult get joinRequests => $_getN(39);
  @$pb.TagNumber(40)
  set joinRequests(Chats_JoinRequestsResult value) => $_setField(40, value);
  @$pb.TagNumber(40)
  $core.bool hasJoinRequests() => $_has(39);
  @$pb.TagNumber(40)
  void clearJoinRequests() => $_clearField(40);
  @$pb.TagNumber(40)
  Chats_JoinRequestsResult ensureJoinRequests() => $_ensure(39);

  @$pb.TagNumber(41)
  Chats_AnswerJoinRequestResult get answerJoinRequest => $_getN(40);
  @$pb.TagNumber(41)
  set answerJoinRequest(Chats_AnswerJoinRequestResult value) => $_setField(41, value);
  @$pb.TagNumber(41)
  $core.bool hasAnswerJoinRequest() => $_has(40);
  @$pb.TagNumber(41)
  void clearAnswerJoinRequest() => $_clearField(41);
  @$pb.TagNumber(41)
  Chats_AnswerJoinRequestResult ensureAnswerJoinRequest() => $_ensure(40);

  @$pb.TagNumber(42)
  Chats_SearchChatsResult get searchChats => $_getN(41);
  @$pb.TagNumber(42)
  set searchChats(Chats_SearchChatsResult value) => $_setField(42, value);
  @$pb.TagNumber(42)
  $core.bool hasSearchChats() => $_has(41);
  @$pb.TagNumber(42)
  void clearSearchChats() => $_clearField(42);
  @$pb.TagNumber(42)
  Chats_SearchChatsResult ensureSearchChats() => $_ensure(41);
}

/// CHATS — диалоги.
class Chats extends $pb.GeneratedMessage {
  factory Chats() => create();

  Chats._();

  factory Chats.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats copyWith(void Function(Chats) updates) => super.copyWith((message) => updates(message as Chats)) as Chats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats create() => Chats._();
  @$core.override
  Chats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats>(create);
  static Chats? _defaultInstance;
}

/// История чата: сообщения с messageID < offsetID (0 — с последнего), по
/// убыванию messageID. Публичную группу (OPEN) можно читать и не вступив
/// (ChatPreview.canViewHistory), то же — Messages.Get. В группе со «Скрыть
/// историю» вступивший после включения видит только сообщения после своего
/// вступления (так же — Get, GetChatDifference, пересылка, закреплённые).
///
/// aroundID > 0 (offsetID при этом не значит) — окно вокруг сообщения
/// (переход к найденному, к цитате): половина limit — оно и старше,
/// половина — новее; hasMore — есть старше окна, hasNewer — новее.
class Messages_History extends $pb.GeneratedMessage {
  factory Messages_History({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? offsetID,
    $core.int? limit,
    $fixnum.Int64? aroundID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (offsetID != null) result.offsetID = offsetID;
    if (limit != null) result.limit = limit;
    if (aroundID != null) result.aroundID = aroundID;
    return result;
  }

  Messages_History._();

  factory Messages_History.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_History.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.History',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'offsetID', protoName: 'offsetID')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..aInt64(4, _omitFieldNames ? '' : 'aroundID', protoName: 'aroundID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_History clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_History copyWith(void Function(Messages_History) updates) =>
      super.copyWith((message) => updates(message as Messages_History)) as Messages_History;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_History create() => Messages_History._();
  @$core.override
  Messages_History createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_History getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_History>(create);
  static Messages_History? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get offsetID => $_getI64(1);
  @$pb.TagNumber(2)
  set offsetID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffsetID() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffsetID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get aroundID => $_getI64(3);
  @$pb.TagNumber(4)
  set aroundID($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAroundID() => $_has(3);
  @$pb.TagNumber(4)
  void clearAroundID() => $_clearField(4);
}

class Messages_HistoryResult extends $pb.GeneratedMessage {
  factory Messages_HistoryResult({
    $core.Iterable<ChatMessage>? messages,
    $core.bool? hasMore,
    $core.bool? hasNewer,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    if (hasMore != null) result.hasMore = hasMore;
    if (hasNewer != null) result.hasNewer = hasNewer;
    return result;
  }

  Messages_HistoryResult._();

  factory Messages_HistoryResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_HistoryResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.HistoryResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatMessage>(1, _omitFieldNames ? '' : 'messages', subBuilder: ChatMessage.create)
    ..aOB(2, _omitFieldNames ? '' : 'hasMore', protoName: 'hasMore')
    ..aOB(3, _omitFieldNames ? '' : 'hasNewer', protoName: 'hasNewer')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_HistoryResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_HistoryResult copyWith(void Function(Messages_HistoryResult) updates) =>
      super.copyWith((message) => updates(message as Messages_HistoryResult)) as Messages_HistoryResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_HistoryResult create() => Messages_HistoryResult._();
  @$core.override
  Messages_HistoryResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_HistoryResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_HistoryResult>(create);
  static Messages_HistoryResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatMessage> get messages => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get hasMore => $_getBF(1);
  @$pb.TagNumber(2)
  set hasMore($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasNewer => $_getBF(2);
  @$pb.TagNumber(3)
  set hasNewer($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasNewer() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasNewer() => $_clearField(3);
}

/// Отправить. Личный чат адресуется chatID (из OpenPrivate) или, если чата
/// ещё нет, peerUserID. randomID — случайное число клиента: повтор с тем же
/// randomID (обрыв связи, outbox) не создаст дубль — вернётся уже созданное.
class Messages_Send extends $pb.GeneratedMessage {
  factory Messages_Send({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? peerUserID,
    $fixnum.Int64? randomID,
    MessageContent? content,
    $core.bool? silent,
    Messages_ForwardFrom? forwardFrom,
    $fixnum.Int64? scheduleDate,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (peerUserID != null) result.peerUserID = peerUserID;
    if (randomID != null) result.randomID = randomID;
    if (content != null) result.content = content;
    if (silent != null) result.silent = silent;
    if (forwardFrom != null) result.forwardFrom = forwardFrom;
    if (scheduleDate != null) result.scheduleDate = scheduleDate;
    return result;
  }

  Messages_Send._();

  factory Messages_Send.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Send.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Send',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'peerUserID', $pb.PbFieldType.OY, protoName: 'peerUserID')
    ..aInt64(3, _omitFieldNames ? '' : 'randomID', protoName: 'randomID')
    ..aOM<MessageContent>(4, _omitFieldNames ? '' : 'content', subBuilder: MessageContent.create)
    ..aOB(5, _omitFieldNames ? '' : 'silent')
    ..aOM<Messages_ForwardFrom>(6, _omitFieldNames ? '' : 'forwardFrom', protoName: 'forwardFrom', subBuilder: Messages_ForwardFrom.create)
    ..aInt64(7, _omitFieldNames ? '' : 'scheduleDate', protoName: 'scheduleDate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Send clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Send copyWith(void Function(Messages_Send) updates) =>
      super.copyWith((message) => updates(message as Messages_Send)) as Messages_Send;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Send create() => Messages_Send._();
  @$core.override
  Messages_Send createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Send getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Send>(create);
  static Messages_Send? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get peerUserID => $_getN(1);
  @$pb.TagNumber(2)
  set peerUserID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeerUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeerUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get randomID => $_getI64(2);
  @$pb.TagNumber(3)
  set randomID($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRandomID() => $_has(2);
  @$pb.TagNumber(3)
  void clearRandomID() => $_clearField(3);

  @$pb.TagNumber(4)
  MessageContent get content => $_getN(3);
  @$pb.TagNumber(4)
  set content(MessageContent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => $_clearField(4);
  @$pb.TagNumber(4)
  MessageContent ensureContent() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get silent => $_getBF(4);
  @$pb.TagNumber(5)
  set silent($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSilent() => $_has(4);
  @$pb.TagNumber(5)
  void clearSilent() => $_clearField(5);

  /// Пересылка (как forwardMessages в Telegram): содержимое сервер берёт из
  /// исходного сообщения (без ответа, с заголовком forward; пересланное
  /// остаётся «от» автора оригинала) — content клиент не заполняет. Доступ —
  /// через исходное сообщение, а не владение файлами вложений. Из чата с
  /// защитой содержимого (Dialog.noForwards / ChatInfo.noForwards) — PERMISSION_DENIED
  /// «forwardsRestricted».
  @$pb.TagNumber(6)
  Messages_ForwardFrom get forwardFrom => $_getN(5);
  @$pb.TagNumber(6)
  set forwardFrom(Messages_ForwardFrom value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasForwardFrom() => $_has(5);
  @$pb.TagNumber(6)
  void clearForwardFrom() => $_clearField(6);
  @$pb.TagNumber(6)
  Messages_ForwardFrom ensureForwardFrom() => $_ensure(5);

  /// Отложить до этого времени (unix millis; 0 — отправить сейчас): в ответе
  /// scheduled вместо message. Уже прошедшее (ждало в outbox без сети) —
  /// уйдёт в ближайшие секунды. Не дальше года; до 100 на чат
  /// (FAILED_PRECONDITION «scheduledLimit»); пересылку отложить нельзя.
  @$pb.TagNumber(7)
  $fixnum.Int64 get scheduleDate => $_getI64(6);
  @$pb.TagNumber(7)
  set scheduleDate($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasScheduleDate() => $_has(6);
  @$pb.TagNumber(7)
  void clearScheduleDate() => $_clearField(7);
}

/// Исходное сообщение пересылки — в чате, где я участник и оно мне видно.
class Messages_ForwardFrom extends $pb.GeneratedMessage {
  factory Messages_ForwardFrom({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    return result;
  }

  Messages_ForwardFrom._();

  factory Messages_ForwardFrom.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ForwardFrom.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ForwardFrom',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ForwardFrom clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ForwardFrom copyWith(void Function(Messages_ForwardFrom) updates) =>
      super.copyWith((message) => updates(message as Messages_ForwardFrom)) as Messages_ForwardFrom;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ForwardFrom create() => Messages_ForwardFrom._();
  @$core.override
  Messages_ForwardFrom createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ForwardFrom getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ForwardFrom>(create);
  static Messages_ForwardFrom? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);
}

class Messages_SendResult extends $pb.GeneratedMessage {
  factory Messages_SendResult({
    ChatMessage? message,
    Updates? updates,
    ScheduledMessage? scheduled,
    $fixnum.Int64? slowModeUntil,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (updates != null) result.updates = updates;
    if (scheduled != null) result.scheduled = scheduled;
    if (slowModeUntil != null) result.slowModeUntil = slowModeUntil;
    return result;
  }

  Messages_SendResult._();

  factory Messages_SendResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_SendResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.SendResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatMessage>(1, _omitFieldNames ? '' : 'message', subBuilder: ChatMessage.create)
    ..aOM<Updates>(2, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..aOM<ScheduledMessage>(3, _omitFieldNames ? '' : 'scheduled', subBuilder: ScheduledMessage.create)
    ..aInt64(4, _omitFieldNames ? '' : 'slowModeUntil', protoName: 'slowModeUntil')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendResult copyWith(void Function(Messages_SendResult) updates) =>
      super.copyWith((message) => updates(message as Messages_SendResult)) as Messages_SendResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_SendResult create() => Messages_SendResult._();
  @$core.override
  Messages_SendResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_SendResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_SendResult>(create);
  static Messages_SendResult? _defaultInstance;

  @$pb.TagNumber(1)
  ChatMessage get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(ChatMessage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatMessage ensureMessage() => $_ensure(0);

  @$pb.TagNumber(2)
  Updates get updates => $_getN(1);
  @$pb.TagNumber(2)
  set updates(Updates value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdates() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdates() => $_clearField(2);
  @$pb.TagNumber(2)
  Updates ensureUpdates() => $_ensure(1);

  @$pb.TagNumber(3)
  ScheduledMessage get scheduled => $_getN(2);
  @$pb.TagNumber(3)
  set scheduled(ScheduledMessage value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScheduled() => $_has(2);
  @$pb.TagNumber(3)
  void clearScheduled() => $_clearField(3);
  @$pb.TagNumber(3)
  ScheduledMessage ensureScheduled() => $_ensure(2);

  /// Группа с медленным режимом: когда можно следующее (unix millis; 0 — нет
  /// ограничения), как Dialog.slowModeUntil.
  @$pb.TagNumber(4)
  $fixnum.Int64 get slowModeUntil => $_getI64(3);
  @$pb.TagNumber(4)
  set slowModeUntil($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSlowModeUntil() => $_has(3);
  @$pb.TagNumber(4)
  void clearSlowModeUntil() => $_clearField(4);
}

/// Мои отложенные в чате — по времени отправки.
class Messages_Scheduled extends $pb.GeneratedMessage {
  factory Messages_Scheduled({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Messages_Scheduled._();

  factory Messages_Scheduled.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Scheduled.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Scheduled',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Scheduled clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Scheduled copyWith(void Function(Messages_Scheduled) updates) =>
      super.copyWith((message) => updates(message as Messages_Scheduled)) as Messages_Scheduled;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Scheduled create() => Messages_Scheduled._();
  @$core.override
  Messages_Scheduled createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Scheduled getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Scheduled>(create);
  static Messages_Scheduled? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

class Messages_ScheduledResult extends $pb.GeneratedMessage {
  factory Messages_ScheduledResult({
    $core.Iterable<ScheduledMessage>? messages,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  Messages_ScheduledResult._();

  factory Messages_ScheduledResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ScheduledResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ScheduledResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ScheduledMessage>(1, _omitFieldNames ? '' : 'messages', subBuilder: ScheduledMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ScheduledResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ScheduledResult copyWith(void Function(Messages_ScheduledResult) updates) =>
      super.copyWith((message) => updates(message as Messages_ScheduledResult)) as Messages_ScheduledResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ScheduledResult create() => Messages_ScheduledResult._();
  @$core.override
  Messages_ScheduledResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ScheduledResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ScheduledResult>(create);
  static Messages_ScheduledResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ScheduledMessage> get messages => $_getList(0);
}

/// Отправить отложенные сейчас (уже ушедшие — пропускаются).
class Messages_SendScheduledNow extends $pb.GeneratedMessage {
  factory Messages_SendScheduledNow({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? scheduledIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (scheduledIDs != null) result.scheduledIDs.addAll(scheduledIDs);
    return result;
  }

  Messages_SendScheduledNow._();

  factory Messages_SendScheduledNow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_SendScheduledNow.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.SendScheduledNow',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'scheduledIDs', $pb.PbFieldType.K6, protoName: 'scheduledIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendScheduledNow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendScheduledNow copyWith(void Function(Messages_SendScheduledNow) updates) =>
      super.copyWith((message) => updates(message as Messages_SendScheduledNow)) as Messages_SendScheduledNow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_SendScheduledNow create() => Messages_SendScheduledNow._();
  @$core.override
  Messages_SendScheduledNow createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_SendScheduledNow getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_SendScheduledNow>(create);
  static Messages_SendScheduledNow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get scheduledIDs => $_getList(1);
}

class Messages_SendScheduledNowResult extends $pb.GeneratedMessage {
  factory Messages_SendScheduledNowResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_SendScheduledNowResult._();

  factory Messages_SendScheduledNowResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_SendScheduledNowResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.SendScheduledNowResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendScheduledNowResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendScheduledNowResult copyWith(void Function(Messages_SendScheduledNowResult) updates) =>
      super.copyWith((message) => updates(message as Messages_SendScheduledNowResult)) as Messages_SendScheduledNowResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_SendScheduledNowResult create() => Messages_SendScheduledNowResult._();
  @$core.override
  Messages_SendScheduledNowResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_SendScheduledNowResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_SendScheduledNowResult>(create);
  static Messages_SendScheduledNowResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Перенести отложенное (уже ушедшее — NOT_FOUND).
class Messages_Reschedule extends $pb.GeneratedMessage {
  factory Messages_Reschedule({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? scheduledID,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (scheduledID != null) result.scheduledID = scheduledID;
    if (date != null) result.date = date;
    return result;
  }

  Messages_Reschedule._();

  factory Messages_Reschedule.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Reschedule.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Reschedule',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'scheduledID', protoName: 'scheduledID')
    ..aInt64(3, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Reschedule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Reschedule copyWith(void Function(Messages_Reschedule) updates) =>
      super.copyWith((message) => updates(message as Messages_Reschedule)) as Messages_Reschedule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Reschedule create() => Messages_Reschedule._();
  @$core.override
  Messages_Reschedule createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Reschedule getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Reschedule>(create);
  static Messages_Reschedule? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get scheduledID => $_getI64(1);
  @$pb.TagNumber(2)
  set scheduledID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScheduledID() => $_has(1);
  @$pb.TagNumber(2)
  void clearScheduledID() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get date => $_getI64(2);
  @$pb.TagNumber(3)
  set date($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDate() => $_clearField(3);
}

class Messages_RescheduleResult extends $pb.GeneratedMessage {
  factory Messages_RescheduleResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_RescheduleResult._();

  factory Messages_RescheduleResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_RescheduleResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.RescheduleResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_RescheduleResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_RescheduleResult copyWith(void Function(Messages_RescheduleResult) updates) =>
      super.copyWith((message) => updates(message as Messages_RescheduleResult)) as Messages_RescheduleResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_RescheduleResult create() => Messages_RescheduleResult._();
  @$core.override
  Messages_RescheduleResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_RescheduleResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_RescheduleResult>(create);
  static Messages_RescheduleResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Удалить отложенные.
class Messages_DeleteScheduled extends $pb.GeneratedMessage {
  factory Messages_DeleteScheduled({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? scheduledIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (scheduledIDs != null) result.scheduledIDs.addAll(scheduledIDs);
    return result;
  }

  Messages_DeleteScheduled._();

  factory Messages_DeleteScheduled.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_DeleteScheduled.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.DeleteScheduled',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'scheduledIDs', $pb.PbFieldType.K6, protoName: 'scheduledIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteScheduled clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteScheduled copyWith(void Function(Messages_DeleteScheduled) updates) =>
      super.copyWith((message) => updates(message as Messages_DeleteScheduled)) as Messages_DeleteScheduled;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_DeleteScheduled create() => Messages_DeleteScheduled._();
  @$core.override
  Messages_DeleteScheduled createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_DeleteScheduled getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_DeleteScheduled>(create);
  static Messages_DeleteScheduled? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get scheduledIDs => $_getList(1);
}

class Messages_DeleteScheduledResult extends $pb.GeneratedMessage {
  factory Messages_DeleteScheduledResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_DeleteScheduledResult._();

  factory Messages_DeleteScheduledResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_DeleteScheduledResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.DeleteScheduledResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteScheduledResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteScheduledResult copyWith(void Function(Messages_DeleteScheduledResult) updates) =>
      super.copyWith((message) => updates(message as Messages_DeleteScheduledResult)) as Messages_DeleteScheduledResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_DeleteScheduledResult create() => Messages_DeleteScheduledResult._();
  @$core.override
  Messages_DeleteScheduledResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_DeleteScheduledResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_DeleteScheduledResult>(create);
  static Messages_DeleteScheduledResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Изменить своё (текст / разметку; медиа не меняются).
class Messages_Edit extends $pb.GeneratedMessage {
  factory Messages_Edit({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.String? text,
    $core.Iterable<MessageEntity>? entities,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (text != null) result.text = text;
    if (entities != null) result.entities.addAll(entities);
    return result;
  }

  Messages_Edit._();

  factory Messages_Edit.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Edit.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Edit',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..pPM<MessageEntity>(4, _omitFieldNames ? '' : 'entities', subBuilder: MessageEntity.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Edit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Edit copyWith(void Function(Messages_Edit) updates) =>
      super.copyWith((message) => updates(message as Messages_Edit)) as Messages_Edit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Edit create() => Messages_Edit._();
  @$core.override
  Messages_Edit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Edit getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Edit>(create);
  static Messages_Edit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<MessageEntity> get entities => $_getList(3);
}

class Messages_EditResult extends $pb.GeneratedMessage {
  factory Messages_EditResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_EditResult._();

  factory Messages_EditResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_EditResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.EditResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_EditResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_EditResult copyWith(void Function(Messages_EditResult) updates) =>
      super.copyWith((message) => updates(message as Messages_EditResult)) as Messages_EditResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_EditResult create() => Messages_EditResult._();
  @$core.override
  Messages_EditResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_EditResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_EditResult>(create);
  static Messages_EditResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Удалить: forEveryone — у всех (в личном чате — и чужие, как в Telegram;
/// в группе чужие — владелец или админ с deleteMessages), иначе только у
/// себя.
class Messages_Delete extends $pb.GeneratedMessage {
  factory Messages_Delete({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
    $core.bool? forEveryone,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    if (forEveryone != null) result.forEveryone = forEveryone;
    return result;
  }

  Messages_Delete._();

  factory Messages_Delete.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Delete.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Delete',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..aOB(3, _omitFieldNames ? '' : 'forEveryone', protoName: 'forEveryone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Delete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Delete copyWith(void Function(Messages_Delete) updates) =>
      super.copyWith((message) => updates(message as Messages_Delete)) as Messages_Delete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Delete create() => Messages_Delete._();
  @$core.override
  Messages_Delete createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Delete getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Delete>(create);
  static Messages_Delete? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get forEveryone => $_getBF(2);
  @$pb.TagNumber(3)
  set forEveryone($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasForEveryone() => $_has(2);
  @$pb.TagNumber(3)
  void clearForEveryone() => $_clearField(3);
}

class Messages_DeleteResult extends $pb.GeneratedMessage {
  factory Messages_DeleteResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_DeleteResult._();

  factory Messages_DeleteResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_DeleteResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.DeleteResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteResult copyWith(void Function(Messages_DeleteResult) updates) =>
      super.copyWith((message) => updates(message as Messages_DeleteResult)) as Messages_DeleteResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_DeleteResult create() => Messages_DeleteResult._();
  @$core.override
  Messages_DeleteResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_DeleteResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_DeleteResult>(create);
  static Messages_DeleteResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Голосовое прослушано (снять mediaUnread у обоих).
class Messages_ReadContents extends $pb.GeneratedMessage {
  factory Messages_ReadContents({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    return result;
  }

  Messages_ReadContents._();

  factory Messages_ReadContents.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadContents.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadContents',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadContents clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadContents copyWith(void Function(Messages_ReadContents) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadContents)) as Messages_ReadContents;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadContents create() => Messages_ReadContents._();
  @$core.override
  Messages_ReadContents createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadContents getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadContents>(create);
  static Messages_ReadContents? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);
}

class Messages_ReadContentsResult extends $pb.GeneratedMessage {
  factory Messages_ReadContentsResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_ReadContentsResult._();

  factory Messages_ReadContentsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadContentsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadContentsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadContentsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadContentsResult copyWith(void Function(Messages_ReadContentsResult) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadContentsResult)) as Messages_ReadContentsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadContentsResult create() => Messages_ReadContentsResult._();
  @$core.override
  Messages_ReadContentsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadContentsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadContentsResult>(create);
  static Messages_ReadContentsResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Закрепить / открепить. forEveryone — закрепить и у собеседника (в ленте
/// появляется служебное MessagePin); собеседник ограничил, кто может ему
/// писать, — закрепится только у себя. Открепление с forEveryone — у обоих,
/// без — только у себя (служебного нет). Служебные сообщения не закрепляются.
/// В группе forEveryone — владелец или админ с pinMessages (иначе
/// PERMISSION_DENIED): закреп общий для всех участников (Update.pinnedMessages
/// с shared — журналом чата).
class Messages_Pin extends $pb.GeneratedMessage {
  factory Messages_Pin({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.bool? pinned,
    $core.bool? forEveryone,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (pinned != null) result.pinned = pinned;
    if (forEveryone != null) result.forEveryone = forEveryone;
    return result;
  }

  Messages_Pin._();

  factory Messages_Pin.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Pin.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Pin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aOB(3, _omitFieldNames ? '' : 'pinned')
    ..aOB(4, _omitFieldNames ? '' : 'forEveryone', protoName: 'forEveryone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Pin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Pin copyWith(void Function(Messages_Pin) updates) =>
      super.copyWith((message) => updates(message as Messages_Pin)) as Messages_Pin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Pin create() => Messages_Pin._();
  @$core.override
  Messages_Pin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Pin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Pin>(create);
  static Messages_Pin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get pinned => $_getBF(2);
  @$pb.TagNumber(3)
  set pinned($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPinned() => $_has(2);
  @$pb.TagNumber(3)
  void clearPinned() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get forEveryone => $_getBF(3);
  @$pb.TagNumber(4)
  set forEveryone($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasForEveryone() => $_has(3);
  @$pb.TagNumber(4)
  void clearForEveryone() => $_clearField(4);
}

class Messages_PinResult extends $pb.GeneratedMessage {
  factory Messages_PinResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_PinResult._();

  factory Messages_PinResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_PinResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.PinResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PinResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PinResult copyWith(void Function(Messages_PinResult) updates) =>
      super.copyWith((message) => updates(message as Messages_PinResult)) as Messages_PinResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_PinResult create() => Messages_PinResult._();
  @$core.override
  Messages_PinResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_PinResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_PinResult>(create);
  static Messages_PinResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Открепить все мои закреплённые в чате: forEveryone — и у собеседника,
/// иначе только у себя.
class Messages_UnpinAll extends $pb.GeneratedMessage {
  factory Messages_UnpinAll({
    $core.List<$core.int>? chatID,
    $core.bool? forEveryone,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (forEveryone != null) result.forEveryone = forEveryone;
    return result;
  }

  Messages_UnpinAll._();

  factory Messages_UnpinAll.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_UnpinAll.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.UnpinAll',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOB(2, _omitFieldNames ? '' : 'forEveryone', protoName: 'forEveryone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnpinAll clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnpinAll copyWith(void Function(Messages_UnpinAll) updates) =>
      super.copyWith((message) => updates(message as Messages_UnpinAll)) as Messages_UnpinAll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_UnpinAll create() => Messages_UnpinAll._();
  @$core.override
  Messages_UnpinAll createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_UnpinAll getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_UnpinAll>(create);
  static Messages_UnpinAll? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get forEveryone => $_getBF(1);
  @$pb.TagNumber(2)
  set forEveryone($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasForEveryone() => $_has(1);
  @$pb.TagNumber(2)
  void clearForEveryone() => $_clearField(2);
}

class Messages_UnpinAllResult extends $pb.GeneratedMessage {
  factory Messages_UnpinAllResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_UnpinAllResult._();

  factory Messages_UnpinAllResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_UnpinAllResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.UnpinAllResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnpinAllResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnpinAllResult copyWith(void Function(Messages_UnpinAllResult) updates) =>
      super.copyWith((message) => updates(message as Messages_UnpinAllResult)) as Messages_UnpinAllResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_UnpinAllResult create() => Messages_UnpinAllResult._();
  @$core.override
  Messages_UnpinAllResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_UnpinAllResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_UnpinAllResult>(create);
  static Messages_UnpinAllResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Мои закреплённые сообщения чата — по убыванию messageID (не больше 100).
/// Окно чата спрашивает при открытии: закреплённые могут быть старше
/// скачанной истории.
class Messages_Pinned extends $pb.GeneratedMessage {
  factory Messages_Pinned({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Messages_Pinned._();

  factory Messages_Pinned.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Pinned.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Pinned',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Pinned clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Pinned copyWith(void Function(Messages_Pinned) updates) =>
      super.copyWith((message) => updates(message as Messages_Pinned)) as Messages_Pinned;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Pinned create() => Messages_Pinned._();
  @$core.override
  Messages_Pinned createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Pinned getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Pinned>(create);
  static Messages_Pinned? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

class Messages_PinnedResult extends $pb.GeneratedMessage {
  factory Messages_PinnedResult({
    $core.Iterable<ChatMessage>? messages,
    $core.Iterable<$fixnum.Int64>? sharedIDs,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    if (sharedIDs != null) result.sharedIDs.addAll(sharedIDs);
    return result;
  }

  Messages_PinnedResult._();

  factory Messages_PinnedResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_PinnedResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.PinnedResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatMessage>(1, _omitFieldNames ? '' : 'messages', subBuilder: ChatMessage.create)
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'sharedIDs', $pb.PbFieldType.K6, protoName: 'sharedIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PinnedResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PinnedResult copyWith(void Function(Messages_PinnedResult) updates) =>
      super.copyWith((message) => updates(message as Messages_PinnedResult)) as Messages_PinnedResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_PinnedResult create() => Messages_PinnedResult._();
  @$core.override
  Messages_PinnedResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_PinnedResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_PinnedResult>(create);
  static Messages_PinnedResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatMessage> get messages => $_getList(0);

  /// Какие из messages закреплены у всех участников (см.
  /// Update.PinnedMessages.shared), остальные — только у меня.
  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get sharedIDs => $_getList(1);
}

/// Мои реакции на сообщение — весь набор целиком (как sendReaction в
/// Telegram): пусто — снять все. Порядок — порядок постановки; не больше
/// трёх разных, только из разрешённых в чате (личный чат — фиксированный
/// набор). Новые нельзя, если собеседник ограничил, кто может ему писать
/// (PERMISSION_DENIED «privacyRestricted»); снять свои можно всегда.
/// Служебные сообщения реакций не принимают. Группа — любой участник (и
/// READER), только из разрешённых ChatInfo.reactionsMode / reactions (иначе
/// INVALID_ARGUMENT); снять свои — всегда.
class Messages_SetReactions extends $pb.GeneratedMessage {
  factory Messages_SetReactions({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.Iterable<$core.String>? emojis,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (emojis != null) result.emojis.addAll(emojis);
    return result;
  }

  Messages_SetReactions._();

  factory Messages_SetReactions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_SetReactions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.SetReactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..pPS(3, _omitFieldNames ? '' : 'emojis')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SetReactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SetReactions copyWith(void Function(Messages_SetReactions) updates) =>
      super.copyWith((message) => updates(message as Messages_SetReactions)) as Messages_SetReactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_SetReactions create() => Messages_SetReactions._();
  @$core.override
  Messages_SetReactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_SetReactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_SetReactions>(create);
  static Messages_SetReactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get emojis => $_getList(2);
}

class Messages_SetReactionsResult extends $pb.GeneratedMessage {
  factory Messages_SetReactionsResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_SetReactionsResult._();

  factory Messages_SetReactionsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_SetReactionsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.SetReactionsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SetReactionsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SetReactionsResult copyWith(void Function(Messages_SetReactionsResult) updates) =>
      super.copyWith((message) => updates(message as Messages_SetReactionsResult)) as Messages_SetReactionsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_SetReactionsResult create() => Messages_SetReactionsResult._();
  @$core.override
  Messages_SetReactionsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_SetReactionsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_SetReactionsResult>(create);
  static Messages_SetReactionsResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Реакции на мои сообщения просмотрены (как readReactions в Telegram):
/// messageIDs — показанные на экране, пусто — все в чате.
class Messages_ReadReactions extends $pb.GeneratedMessage {
  factory Messages_ReadReactions({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    return result;
  }

  Messages_ReadReactions._();

  factory Messages_ReadReactions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadReactions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadReactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadReactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadReactions copyWith(void Function(Messages_ReadReactions) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadReactions)) as Messages_ReadReactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadReactions create() => Messages_ReadReactions._();
  @$core.override
  Messages_ReadReactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadReactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadReactions>(create);
  static Messages_ReadReactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);
}

class Messages_ReadReactionsResult extends $pb.GeneratedMessage {
  factory Messages_ReadReactionsResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_ReadReactionsResult._();

  factory Messages_ReadReactionsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadReactionsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadReactionsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadReactionsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadReactionsResult copyWith(void Function(Messages_ReadReactionsResult) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadReactionsResult)) as Messages_ReadReactionsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadReactionsResult create() => Messages_ReadReactionsResult._();
  @$core.override
  Messages_ReadReactionsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadReactionsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadReactionsResult>(create);
  static Messages_ReadReactionsResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Мои сообщения с непрочитанными реакциями, от старых к новым (как
/// getUnreadReactions в Telegram) — куда вести кнопку ❤️ в окне чата.
class Messages_UnreadReactions extends $pb.GeneratedMessage {
  factory Messages_UnreadReactions({
    $core.List<$core.int>? chatID,
    $core.int? limit,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (limit != null) result.limit = limit;
    return result;
  }

  Messages_UnreadReactions._();

  factory Messages_UnreadReactions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_UnreadReactions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.UnreadReactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadReactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadReactions copyWith(void Function(Messages_UnreadReactions) updates) =>
      super.copyWith((message) => updates(message as Messages_UnreadReactions)) as Messages_UnreadReactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_UnreadReactions create() => Messages_UnreadReactions._();
  @$core.override
  Messages_UnreadReactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_UnreadReactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_UnreadReactions>(create);
  static Messages_UnreadReactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class Messages_UnreadReactionsResult extends $pb.GeneratedMessage {
  factory Messages_UnreadReactionsResult({
    $core.Iterable<ChatMessage>? messages,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  Messages_UnreadReactionsResult._();

  factory Messages_UnreadReactionsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_UnreadReactionsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.UnreadReactionsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatMessage>(1, _omitFieldNames ? '' : 'messages', subBuilder: ChatMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadReactionsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadReactionsResult copyWith(void Function(Messages_UnreadReactionsResult) updates) =>
      super.copyWith((message) => updates(message as Messages_UnreadReactionsResult)) as Messages_UnreadReactionsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_UnreadReactionsResult create() => Messages_UnreadReactionsResult._();
  @$core.override
  Messages_UnreadReactionsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_UnreadReactionsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_UnreadReactionsResult>(create);
  static Messages_UnreadReactionsResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatMessage> get messages => $_getList(0);
}

/// Сообщения чата по номерам (как messages.getMessages в Telegram) — со
/// свежими ссылками на файлы: клиент берёт их, когда старая ссылка на
/// вложение не открывается (403 — истёк токен, 404 — файл переехал в другое
/// хранилище). Отдаются только видимые пользователю (не удалённые у него и не
/// в очищенной истории); остальные номера пропускаются. Не больше 100.
class Messages_Get extends $pb.GeneratedMessage {
  factory Messages_Get({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    return result;
  }

  Messages_Get._();

  factory Messages_Get.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Get.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Get',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Get clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Get copyWith(void Function(Messages_Get) updates) =>
      super.copyWith((message) => updates(message as Messages_Get)) as Messages_Get;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Get create() => Messages_Get._();
  @$core.override
  Messages_Get createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Get getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Get>(create);
  static Messages_Get? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);
}

class Messages_GetResult extends $pb.GeneratedMessage {
  factory Messages_GetResult({
    $core.Iterable<ChatMessage>? messages,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  Messages_GetResult._();

  factory Messages_GetResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_GetResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.GetResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatMessage>(1, _omitFieldNames ? '' : 'messages', subBuilder: ChatMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_GetResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_GetResult copyWith(void Function(Messages_GetResult) updates) =>
      super.copyWith((message) => updates(message as Messages_GetResult)) as Messages_GetResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_GetResult create() => Messages_GetResult._();
  @$core.override
  Messages_GetResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_GetResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_GetResult>(create);
  static Messages_GetResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatMessage> get messages => $_getList(0);
}

/// «Кто прочитал» моё сообщение в группе (как getMessageReadParticipants):
/// по событиям прочтения; только группы до groups.readParticipantsMaxMembers
/// (100) участников и сообщения не старше 7 дней — иначе status UNAVAILABLE.
/// readers — от последних к первым, без автора; reaction — его реакция на
/// сообщение (первая, пусто — нет).
class Messages_ReadParticipants extends $pb.GeneratedMessage {
  factory Messages_ReadParticipants({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    return result;
  }

  Messages_ReadParticipants._();

  factory Messages_ReadParticipants.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadParticipants.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadParticipants',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadParticipants clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadParticipants copyWith(void Function(Messages_ReadParticipants) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadParticipants)) as Messages_ReadParticipants;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadParticipants create() => Messages_ReadParticipants._();
  @$core.override
  Messages_ReadParticipants createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadParticipants getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadParticipants>(create);
  static Messages_ReadParticipants? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);
}

class Messages_ReadParticipant extends $pb.GeneratedMessage {
  factory Messages_ReadParticipant({
    $core.List<$core.int>? userID,
    $fixnum.Int64? date,
    $core.String? reaction,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (date != null) result.date = date;
    if (reaction != null) result.reaction = reaction;
    return result;
  }

  Messages_ReadParticipant._();

  factory Messages_ReadParticipant.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadParticipant.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadParticipant',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aInt64(2, _omitFieldNames ? '' : 'date')
    ..aOS(3, _omitFieldNames ? '' : 'reaction')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadParticipant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadParticipant copyWith(void Function(Messages_ReadParticipant) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadParticipant)) as Messages_ReadParticipant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadParticipant create() => Messages_ReadParticipant._();
  @$core.override
  Messages_ReadParticipant createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadParticipant getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadParticipant>(create);
  static Messages_ReadParticipant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get date => $_getI64(1);
  @$pb.TagNumber(2)
  set date($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reaction => $_getSZ(2);
  @$pb.TagNumber(3)
  set reaction($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReaction() => $_has(2);
  @$pb.TagNumber(3)
  void clearReaction() => $_clearField(3);
}

class Messages_ReadParticipantsResult extends $pb.GeneratedMessage {
  factory Messages_ReadParticipantsResult({
    Messages_ReadParticipantsResult_Status? status,
    $core.Iterable<Messages_ReadParticipant>? readers,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (readers != null) result.readers.addAll(readers);
    return result;
  }

  Messages_ReadParticipantsResult._();

  factory Messages_ReadParticipantsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadParticipantsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadParticipantsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<Messages_ReadParticipantsResult_Status>(1, _omitFieldNames ? '' : 'status',
        enumValues: Messages_ReadParticipantsResult_Status.values)
    ..pPM<Messages_ReadParticipant>(2, _omitFieldNames ? '' : 'readers', subBuilder: Messages_ReadParticipant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadParticipantsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadParticipantsResult copyWith(void Function(Messages_ReadParticipantsResult) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadParticipantsResult)) as Messages_ReadParticipantsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadParticipantsResult create() => Messages_ReadParticipantsResult._();
  @$core.override
  Messages_ReadParticipantsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadParticipantsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadParticipantsResult>(create);
  static Messages_ReadParticipantsResult? _defaultInstance;

  @$pb.TagNumber(1)
  Messages_ReadParticipantsResult_Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(Messages_ReadParticipantsResult_Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Messages_ReadParticipant> get readers => $_getList(1);
}

/// Мои непрочитанные упоминания в группе, от старых к новым (как
/// getUnreadMentions) — куда вести кнопку «@».
class Messages_UnreadMentions extends $pb.GeneratedMessage {
  factory Messages_UnreadMentions({
    $core.List<$core.int>? chatID,
    $core.int? limit,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (limit != null) result.limit = limit;
    return result;
  }

  Messages_UnreadMentions._();

  factory Messages_UnreadMentions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_UnreadMentions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.UnreadMentions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadMentions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadMentions copyWith(void Function(Messages_UnreadMentions) updates) =>
      super.copyWith((message) => updates(message as Messages_UnreadMentions)) as Messages_UnreadMentions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_UnreadMentions create() => Messages_UnreadMentions._();
  @$core.override
  Messages_UnreadMentions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_UnreadMentions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_UnreadMentions>(create);
  static Messages_UnreadMentions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class Messages_UnreadMentionsResult extends $pb.GeneratedMessage {
  factory Messages_UnreadMentionsResult({
    $core.Iterable<ChatMessage>? messages,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  Messages_UnreadMentionsResult._();

  factory Messages_UnreadMentionsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_UnreadMentionsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.UnreadMentionsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatMessage>(1, _omitFieldNames ? '' : 'messages', subBuilder: ChatMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadMentionsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadMentionsResult copyWith(void Function(Messages_UnreadMentionsResult) updates) =>
      super.copyWith((message) => updates(message as Messages_UnreadMentionsResult)) as Messages_UnreadMentionsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_UnreadMentionsResult create() => Messages_UnreadMentionsResult._();
  @$core.override
  Messages_UnreadMentionsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_UnreadMentionsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_UnreadMentionsResult>(create);
  static Messages_UnreadMentionsResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatMessage> get messages => $_getList(0);
}

/// Упоминания messageIDs увидел на экране (пусто — все в чате): снять,
/// моим устройствам — Update.mentions.
class Messages_ReadMentions extends $pb.GeneratedMessage {
  factory Messages_ReadMentions({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    return result;
  }

  Messages_ReadMentions._();

  factory Messages_ReadMentions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadMentions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadMentions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadMentions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadMentions copyWith(void Function(Messages_ReadMentions) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadMentions)) as Messages_ReadMentions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadMentions create() => Messages_ReadMentions._();
  @$core.override
  Messages_ReadMentions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadMentions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadMentions>(create);
  static Messages_ReadMentions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);
}

class Messages_ReadMentionsResult extends $pb.GeneratedMessage {
  factory Messages_ReadMentionsResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_ReadMentionsResult._();

  factory Messages_ReadMentionsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadMentionsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadMentionsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadMentionsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadMentionsResult copyWith(void Function(Messages_ReadMentionsResult) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadMentionsResult)) as Messages_ReadMentionsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadMentionsResult create() => Messages_ReadMentionsResult._();
  @$core.override
  Messages_ReadMentionsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadMentionsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadMentionsResult>(create);
  static Messages_ReadMentionsResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Голос в опросе: options — мой выбор целиком (пусто — отменить голос;
/// у викторины отменить нельзя, и вариант ровно один; без multiple — один).
/// Любой участник (и READER); завершённый — FAILED_PRECONDITION
/// «pollClosed». Ответ — итоги глазами меня.
class Messages_VotePoll extends $pb.GeneratedMessage {
  factory Messages_VotePoll({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.Iterable<$core.int>? options,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (options != null) result.options.addAll(options);
    return result;
  }

  Messages_VotePoll._();

  factory Messages_VotePoll.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_VotePoll.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.VotePoll',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..p<$core.int>(3, _omitFieldNames ? '' : 'options', $pb.PbFieldType.K3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_VotePoll clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_VotePoll copyWith(void Function(Messages_VotePoll) updates) =>
      super.copyWith((message) => updates(message as Messages_VotePoll)) as Messages_VotePoll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_VotePoll create() => Messages_VotePoll._();
  @$core.override
  Messages_VotePoll createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_VotePoll getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_VotePoll>(create);
  static Messages_VotePoll? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.int> get options => $_getList(2);
}

class Messages_VotePollResult extends $pb.GeneratedMessage {
  factory Messages_VotePollResult({
    PollResults? results,
    Updates? updates,
  }) {
    final result = create();
    if (results != null) result.results = results;
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_VotePollResult._();

  factory Messages_VotePollResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_VotePollResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.VotePollResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<PollResults>(1, _omitFieldNames ? '' : 'results', subBuilder: PollResults.create)
    ..aOM<Updates>(2, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_VotePollResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_VotePollResult copyWith(void Function(Messages_VotePollResult) updates) =>
      super.copyWith((message) => updates(message as Messages_VotePollResult)) as Messages_VotePollResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_VotePollResult create() => Messages_VotePollResult._();
  @$core.override
  Messages_VotePollResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_VotePollResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_VotePollResult>(create);
  static Messages_VotePollResult? _defaultInstance;

  @$pb.TagNumber(1)
  PollResults get results => $_getN(0);
  @$pb.TagNumber(1)
  set results(PollResults value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResults() => $_has(0);
  @$pb.TagNumber(1)
  void clearResults() => $_clearField(1);
  @$pb.TagNumber(1)
  PollResults ensureResults() => $_ensure(0);

  @$pb.TagNumber(2)
  Updates get updates => $_getN(1);
  @$pb.TagNumber(2)
  set updates(Updates value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdates() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdates() => $_clearField(2);
  @$pb.TagNumber(2)
  Updates ensureUpdates() => $_ensure(1);
}

/// Завершить опрос: автор, владелец или админ с deleteMessages (иначе
/// PERMISSION_DENIED). Всем — MessagePollChanged с closed и верным ответом.
class Messages_ClosePoll extends $pb.GeneratedMessage {
  factory Messages_ClosePoll({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    return result;
  }

  Messages_ClosePoll._();

  factory Messages_ClosePoll.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ClosePoll.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ClosePoll',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ClosePoll clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ClosePoll copyWith(void Function(Messages_ClosePoll) updates) =>
      super.copyWith((message) => updates(message as Messages_ClosePoll)) as Messages_ClosePoll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ClosePoll create() => Messages_ClosePoll._();
  @$core.override
  Messages_ClosePoll createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ClosePoll getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ClosePoll>(create);
  static Messages_ClosePoll? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);
}

class Messages_ClosePollResult extends $pb.GeneratedMessage {
  factory Messages_ClosePollResult({
    PollResults? results,
    Updates? updates,
  }) {
    final result = create();
    if (results != null) result.results = results;
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_ClosePollResult._();

  factory Messages_ClosePollResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ClosePollResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ClosePollResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<PollResults>(1, _omitFieldNames ? '' : 'results', subBuilder: PollResults.create)
    ..aOM<Updates>(2, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ClosePollResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ClosePollResult copyWith(void Function(Messages_ClosePollResult) updates) =>
      super.copyWith((message) => updates(message as Messages_ClosePollResult)) as Messages_ClosePollResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ClosePollResult create() => Messages_ClosePollResult._();
  @$core.override
  Messages_ClosePollResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ClosePollResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ClosePollResult>(create);
  static Messages_ClosePollResult? _defaultInstance;

  @$pb.TagNumber(1)
  PollResults get results => $_getN(0);
  @$pb.TagNumber(1)
  set results(PollResults value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResults() => $_has(0);
  @$pb.TagNumber(1)
  void clearResults() => $_clearField(1);
  @$pb.TagNumber(1)
  PollResults ensureResults() => $_ensure(0);

  @$pb.TagNumber(2)
  Updates get updates => $_getN(1);
  @$pb.TagNumber(2)
  set updates(Updates value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdates() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdates() => $_clearField(2);
  @$pb.TagNumber(2)
  Updates ensureUpdates() => $_ensure(1);
}

/// Кто как голосовал (неанонимный опрос; анонимный — PERMISSION_DENIED):
/// option ≥ 0 — только выбравшие его, -1 — все. Страница по дате голоса,
/// offset — курсор из прошлого ответа.
class Messages_PollVoters extends $pb.GeneratedMessage {
  factory Messages_PollVoters({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.int? option,
    $core.List<$core.int>? offset,
    $core.int? limit,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (option != null) result.option = option;
    if (offset != null) result.offset = offset;
    if (limit != null) result.limit = limit;
    return result;
  }

  Messages_PollVoters._();

  factory Messages_PollVoters.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_PollVoters.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.PollVoters',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aI(3, _omitFieldNames ? '' : 'option')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OY)
    ..aI(5, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PollVoters clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PollVoters copyWith(void Function(Messages_PollVoters) updates) =>
      super.copyWith((message) => updates(message as Messages_PollVoters)) as Messages_PollVoters;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_PollVoters create() => Messages_PollVoters._();
  @$core.override
  Messages_PollVoters createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_PollVoters getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_PollVoters>(create);
  static Messages_PollVoters? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get option => $_getIZ(2);
  @$pb.TagNumber(3)
  set option($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOption() => $_has(2);
  @$pb.TagNumber(3)
  void clearOption() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get offset => $_getN(3);
  @$pb.TagNumber(4)
  set offset($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get limit => $_getIZ(4);
  @$pb.TagNumber(5)
  set limit($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLimit() => $_has(4);
  @$pb.TagNumber(5)
  void clearLimit() => $_clearField(5);
}

class Messages_PollVoter extends $pb.GeneratedMessage {
  factory Messages_PollVoter({
    $core.List<$core.int>? userID,
    $core.Iterable<$core.int>? options,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (options != null) result.options.addAll(options);
    if (date != null) result.date = date;
    return result;
  }

  Messages_PollVoter._();

  factory Messages_PollVoter.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_PollVoter.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.PollVoter',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..p<$core.int>(2, _omitFieldNames ? '' : 'options', $pb.PbFieldType.K3)
    ..aInt64(3, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PollVoter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PollVoter copyWith(void Function(Messages_PollVoter) updates) =>
      super.copyWith((message) => updates(message as Messages_PollVoter)) as Messages_PollVoter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_PollVoter create() => Messages_PollVoter._();
  @$core.override
  Messages_PollVoter createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_PollVoter getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_PollVoter>(create);
  static Messages_PollVoter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.int> get options => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get date => $_getI64(2);
  @$pb.TagNumber(3)
  set date($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDate() => $_clearField(3);
}

class Messages_PollVotersResult extends $pb.GeneratedMessage {
  factory Messages_PollVotersResult({
    $core.Iterable<Messages_PollVoter>? voters,
    $core.List<$core.int>? nextOffset,
  }) {
    final result = create();
    if (voters != null) result.voters.addAll(voters);
    if (nextOffset != null) result.nextOffset = nextOffset;
    return result;
  }

  Messages_PollVotersResult._();

  factory Messages_PollVotersResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_PollVotersResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.PollVotersResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Messages_PollVoter>(1, _omitFieldNames ? '' : 'voters', subBuilder: Messages_PollVoter.create)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'nextOffset', $pb.PbFieldType.OY, protoName: 'nextOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PollVotersResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PollVotersResult copyWith(void Function(Messages_PollVotersResult) updates) =>
      super.copyWith((message) => updates(message as Messages_PollVotersResult)) as Messages_PollVotersResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_PollVotersResult create() => Messages_PollVotersResult._();
  @$core.override
  Messages_PollVotersResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_PollVotersResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_PollVotersResult>(create);
  static Messages_PollVotersResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Messages_PollVoter> get voters => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get nextOffset => $_getN(1);
  @$pb.TagNumber(2)
  set nextOffset($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextOffset() => $_clearField(2);
}

/// Кто поставил реакции на сообщение группы (по запросу): emoji пусто — все.
/// Страница от поздних к ранним, offset — курсор из прошлого ответа.
class Messages_ReactionsList extends $pb.GeneratedMessage {
  factory Messages_ReactionsList({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.String? emoji,
    $core.List<$core.int>? offset,
    $core.int? limit,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (emoji != null) result.emoji = emoji;
    if (offset != null) result.offset = offset;
    if (limit != null) result.limit = limit;
    return result;
  }

  Messages_ReactionsList._();

  factory Messages_ReactionsList.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReactionsList.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReactionsList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aOS(3, _omitFieldNames ? '' : 'emoji')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OY)
    ..aI(5, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReactionsList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReactionsList copyWith(void Function(Messages_ReactionsList) updates) =>
      super.copyWith((message) => updates(message as Messages_ReactionsList)) as Messages_ReactionsList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReactionsList create() => Messages_ReactionsList._();
  @$core.override
  Messages_ReactionsList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReactionsList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReactionsList>(create);
  static Messages_ReactionsList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get emoji => $_getSZ(2);
  @$pb.TagNumber(3)
  set emoji($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEmoji() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmoji() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get offset => $_getN(3);
  @$pb.TagNumber(4)
  set offset($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get limit => $_getIZ(4);
  @$pb.TagNumber(5)
  set limit($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLimit() => $_has(4);
  @$pb.TagNumber(5)
  void clearLimit() => $_clearField(5);
}

class Messages_ReactionsListResult extends $pb.GeneratedMessage {
  factory Messages_ReactionsListResult({
    $core.Iterable<MessageReaction>? reactions,
    $core.List<$core.int>? nextOffset,
  }) {
    final result = create();
    if (reactions != null) result.reactions.addAll(reactions);
    if (nextOffset != null) result.nextOffset = nextOffset;
    return result;
  }

  Messages_ReactionsListResult._();

  factory Messages_ReactionsListResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReactionsListResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReactionsListResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<MessageReaction>(1, _omitFieldNames ? '' : 'reactions', subBuilder: MessageReaction.create)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'nextOffset', $pb.PbFieldType.OY, protoName: 'nextOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReactionsListResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReactionsListResult copyWith(void Function(Messages_ReactionsListResult) updates) =>
      super.copyWith((message) => updates(message as Messages_ReactionsListResult)) as Messages_ReactionsListResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReactionsListResult create() => Messages_ReactionsListResult._();
  @$core.override
  Messages_ReactionsListResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReactionsListResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReactionsListResult>(create);
  static Messages_ReactionsListResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MessageReaction> get reactions => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get nextOffset => $_getN(1);
  @$pb.TagNumber(2)
  set nextOffset($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextOffset() => $_clearField(2);
}

/// Поиск по сообщениям чата на сервере (подэтап 3.6, личные и группы):
/// слепой индекс основ слов, расшифровываются только кандидаты страницы.
/// Слова запроса — все должны встретиться (в любой форме: основы snowball,
/// язык — по алфавиту слова). Ищет по целым словам и их формам, не по
/// произвольному куску. Сообщения — от новых к старым, только видимые мне (не
/// удалённые у меня, после очистки истории, при «Скрыть историю» — после
/// вступления); offsetID — искать старше него (0 — с последнего). nextOffsetID
/// — продолжение (0 — больше нет). Запрос только из стоп-слов / пустой —
/// status QUERY_TOO_SHORT. Публичную группу без вступления искать нельзя.
class Messages_Search extends $pb.GeneratedMessage {
  factory Messages_Search({
    $core.List<$core.int>? chatID,
    $core.String? query,
    $fixnum.Int64? offsetID,
    $core.int? limit,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (query != null) result.query = query;
    if (offsetID != null) result.offsetID = offsetID;
    if (limit != null) result.limit = limit;
    return result;
  }

  Messages_Search._();

  factory Messages_Search.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Search.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Search',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOS(2, _omitFieldNames ? '' : 'query')
    ..aInt64(3, _omitFieldNames ? '' : 'offsetID', protoName: 'offsetID')
    ..aI(4, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Search clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Search copyWith(void Function(Messages_Search) updates) =>
      super.copyWith((message) => updates(message as Messages_Search)) as Messages_Search;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Search create() => Messages_Search._();
  @$core.override
  Messages_Search createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Search getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Search>(create);
  static Messages_Search? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get query => $_getSZ(1);
  @$pb.TagNumber(2)
  set query($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuery() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get offsetID => $_getI64(2);
  @$pb.TagNumber(3)
  set offsetID($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffsetID() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffsetID() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get limit => $_getIZ(3);
  @$pb.TagNumber(4)
  set limit($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearLimit() => $_clearField(4);
}

class Messages_SearchResult extends $pb.GeneratedMessage {
  factory Messages_SearchResult({
    Messages_SearchResult_Status? status,
    $core.Iterable<ChatMessage>? messages,
    $fixnum.Int64? nextOffsetID,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (messages != null) result.messages.addAll(messages);
    if (nextOffsetID != null) result.nextOffsetID = nextOffsetID;
    return result;
  }

  Messages_SearchResult._();

  factory Messages_SearchResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_SearchResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.SearchResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<Messages_SearchResult_Status>(1, _omitFieldNames ? '' : 'status', enumValues: Messages_SearchResult_Status.values)
    ..pPM<ChatMessage>(2, _omitFieldNames ? '' : 'messages', subBuilder: ChatMessage.create)
    ..aInt64(3, _omitFieldNames ? '' : 'nextOffsetID', protoName: 'nextOffsetID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SearchResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SearchResult copyWith(void Function(Messages_SearchResult) updates) =>
      super.copyWith((message) => updates(message as Messages_SearchResult)) as Messages_SearchResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_SearchResult create() => Messages_SearchResult._();
  @$core.override
  Messages_SearchResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_SearchResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_SearchResult>(create);
  static Messages_SearchResult? _defaultInstance;

  @$pb.TagNumber(1)
  Messages_SearchResult_Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(Messages_SearchResult_Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ChatMessage> get messages => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get nextOffsetID => $_getI64(2);
  @$pb.TagNumber(3)
  set nextOffsetID($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNextOffsetID() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextOffsetID() => $_clearField(3);
}

enum Messages_Request_Request {
  history,
  send,
  edit,
  delete,
  readContents,
  pin,
  unpinAll,
  pinned,
  setReactions,
  readReactions,
  unreadReactions,
  scheduled,
  sendScheduledNow,
  reschedule,
  deleteScheduled,
  get,
  readParticipants,
  unreadMentions,
  readMentions,
  votePoll,
  closePoll,
  pollVoters,
  reactionsList,
  search,
  notSet
}

class Messages_Request extends $pb.GeneratedMessage {
  factory Messages_Request({
    Messages_History? history,
    Messages_Send? send,
    Messages_Edit? edit,
    Messages_Delete? delete,
    Messages_ReadContents? readContents,
    Messages_Pin? pin,
    Messages_UnpinAll? unpinAll,
    Messages_Pinned? pinned,
    Messages_SetReactions? setReactions,
    Messages_ReadReactions? readReactions,
    Messages_UnreadReactions? unreadReactions,
    Messages_Scheduled? scheduled,
    Messages_SendScheduledNow? sendScheduledNow,
    Messages_Reschedule? reschedule,
    Messages_DeleteScheduled? deleteScheduled,
    Messages_Get? get,
    Messages_ReadParticipants? readParticipants,
    Messages_UnreadMentions? unreadMentions,
    Messages_ReadMentions? readMentions,
    Messages_VotePoll? votePoll,
    Messages_ClosePoll? closePoll,
    Messages_PollVoters? pollVoters,
    Messages_ReactionsList? reactionsList,
    Messages_Search? search,
  }) {
    final result = create();
    if (history != null) result.history = history;
    if (send != null) result.send = send;
    if (edit != null) result.edit = edit;
    if (delete != null) result.delete = delete;
    if (readContents != null) result.readContents = readContents;
    if (pin != null) result.pin = pin;
    if (unpinAll != null) result.unpinAll = unpinAll;
    if (pinned != null) result.pinned = pinned;
    if (setReactions != null) result.setReactions = setReactions;
    if (readReactions != null) result.readReactions = readReactions;
    if (unreadReactions != null) result.unreadReactions = unreadReactions;
    if (scheduled != null) result.scheduled = scheduled;
    if (sendScheduledNow != null) result.sendScheduledNow = sendScheduledNow;
    if (reschedule != null) result.reschedule = reschedule;
    if (deleteScheduled != null) result.deleteScheduled = deleteScheduled;
    if (get != null) result.get = get;
    if (readParticipants != null) result.readParticipants = readParticipants;
    if (unreadMentions != null) result.unreadMentions = unreadMentions;
    if (readMentions != null) result.readMentions = readMentions;
    if (votePoll != null) result.votePoll = votePoll;
    if (closePoll != null) result.closePoll = closePoll;
    if (pollVoters != null) result.pollVoters = pollVoters;
    if (reactionsList != null) result.reactionsList = reactionsList;
    if (search != null) result.search = search;
    return result;
  }

  Messages_Request._();

  factory Messages_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Messages_Request_Request> _Messages_Request_RequestByTag = {
    1: Messages_Request_Request.history,
    2: Messages_Request_Request.send,
    3: Messages_Request_Request.edit,
    4: Messages_Request_Request.delete,
    5: Messages_Request_Request.readContents,
    6: Messages_Request_Request.pin,
    7: Messages_Request_Request.unpinAll,
    8: Messages_Request_Request.pinned,
    9: Messages_Request_Request.setReactions,
    10: Messages_Request_Request.readReactions,
    11: Messages_Request_Request.unreadReactions,
    12: Messages_Request_Request.scheduled,
    13: Messages_Request_Request.sendScheduledNow,
    14: Messages_Request_Request.reschedule,
    15: Messages_Request_Request.deleteScheduled,
    16: Messages_Request_Request.get,
    17: Messages_Request_Request.readParticipants,
    18: Messages_Request_Request.unreadMentions,
    19: Messages_Request_Request.readMentions,
    20: Messages_Request_Request.votePoll,
    21: Messages_Request_Request.closePoll,
    22: Messages_Request_Request.pollVoters,
    23: Messages_Request_Request.reactionsList,
    24: Messages_Request_Request.search,
    0: Messages_Request_Request.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24])
    ..aOM<Messages_History>(1, _omitFieldNames ? '' : 'history', subBuilder: Messages_History.create)
    ..aOM<Messages_Send>(2, _omitFieldNames ? '' : 'send', subBuilder: Messages_Send.create)
    ..aOM<Messages_Edit>(3, _omitFieldNames ? '' : 'edit', subBuilder: Messages_Edit.create)
    ..aOM<Messages_Delete>(4, _omitFieldNames ? '' : 'delete', subBuilder: Messages_Delete.create)
    ..aOM<Messages_ReadContents>(5, _omitFieldNames ? '' : 'readContents',
        protoName: 'readContents', subBuilder: Messages_ReadContents.create)
    ..aOM<Messages_Pin>(6, _omitFieldNames ? '' : 'pin', subBuilder: Messages_Pin.create)
    ..aOM<Messages_UnpinAll>(7, _omitFieldNames ? '' : 'unpinAll', protoName: 'unpinAll', subBuilder: Messages_UnpinAll.create)
    ..aOM<Messages_Pinned>(8, _omitFieldNames ? '' : 'pinned', subBuilder: Messages_Pinned.create)
    ..aOM<Messages_SetReactions>(9, _omitFieldNames ? '' : 'setReactions',
        protoName: 'setReactions', subBuilder: Messages_SetReactions.create)
    ..aOM<Messages_ReadReactions>(10, _omitFieldNames ? '' : 'readReactions',
        protoName: 'readReactions', subBuilder: Messages_ReadReactions.create)
    ..aOM<Messages_UnreadReactions>(11, _omitFieldNames ? '' : 'unreadReactions',
        protoName: 'unreadReactions', subBuilder: Messages_UnreadReactions.create)
    ..aOM<Messages_Scheduled>(12, _omitFieldNames ? '' : 'scheduled', subBuilder: Messages_Scheduled.create)
    ..aOM<Messages_SendScheduledNow>(13, _omitFieldNames ? '' : 'sendScheduledNow',
        protoName: 'sendScheduledNow', subBuilder: Messages_SendScheduledNow.create)
    ..aOM<Messages_Reschedule>(14, _omitFieldNames ? '' : 'reschedule', subBuilder: Messages_Reschedule.create)
    ..aOM<Messages_DeleteScheduled>(15, _omitFieldNames ? '' : 'deleteScheduled',
        protoName: 'deleteScheduled', subBuilder: Messages_DeleteScheduled.create)
    ..aOM<Messages_Get>(16, _omitFieldNames ? '' : 'get', subBuilder: Messages_Get.create)
    ..aOM<Messages_ReadParticipants>(17, _omitFieldNames ? '' : 'readParticipants',
        protoName: 'readParticipants', subBuilder: Messages_ReadParticipants.create)
    ..aOM<Messages_UnreadMentions>(18, _omitFieldNames ? '' : 'unreadMentions',
        protoName: 'unreadMentions', subBuilder: Messages_UnreadMentions.create)
    ..aOM<Messages_ReadMentions>(19, _omitFieldNames ? '' : 'readMentions',
        protoName: 'readMentions', subBuilder: Messages_ReadMentions.create)
    ..aOM<Messages_VotePoll>(20, _omitFieldNames ? '' : 'votePoll', protoName: 'votePoll', subBuilder: Messages_VotePoll.create)
    ..aOM<Messages_ClosePoll>(21, _omitFieldNames ? '' : 'closePoll', protoName: 'closePoll', subBuilder: Messages_ClosePoll.create)
    ..aOM<Messages_PollVoters>(22, _omitFieldNames ? '' : 'pollVoters', protoName: 'pollVoters', subBuilder: Messages_PollVoters.create)
    ..aOM<Messages_ReactionsList>(23, _omitFieldNames ? '' : 'reactionsList',
        protoName: 'reactionsList', subBuilder: Messages_ReactionsList.create)
    ..aOM<Messages_Search>(24, _omitFieldNames ? '' : 'search', subBuilder: Messages_Search.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Request copyWith(void Function(Messages_Request) updates) =>
      super.copyWith((message) => updates(message as Messages_Request)) as Messages_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Request create() => Messages_Request._();
  @$core.override
  Messages_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Request>(create);
  static Messages_Request? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  Messages_Request_Request whichRequest() => _Messages_Request_RequestByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  void clearRequest() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Messages_History get history => $_getN(0);
  @$pb.TagNumber(1)
  set history(Messages_History value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHistory() => $_has(0);
  @$pb.TagNumber(1)
  void clearHistory() => $_clearField(1);
  @$pb.TagNumber(1)
  Messages_History ensureHistory() => $_ensure(0);

  @$pb.TagNumber(2)
  Messages_Send get send => $_getN(1);
  @$pb.TagNumber(2)
  set send(Messages_Send value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSend() => $_has(1);
  @$pb.TagNumber(2)
  void clearSend() => $_clearField(2);
  @$pb.TagNumber(2)
  Messages_Send ensureSend() => $_ensure(1);

  @$pb.TagNumber(3)
  Messages_Edit get edit => $_getN(2);
  @$pb.TagNumber(3)
  set edit(Messages_Edit value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEdit() => $_has(2);
  @$pb.TagNumber(3)
  void clearEdit() => $_clearField(3);
  @$pb.TagNumber(3)
  Messages_Edit ensureEdit() => $_ensure(2);

  @$pb.TagNumber(4)
  Messages_Delete get delete => $_getN(3);
  @$pb.TagNumber(4)
  set delete(Messages_Delete value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDelete() => $_has(3);
  @$pb.TagNumber(4)
  void clearDelete() => $_clearField(4);
  @$pb.TagNumber(4)
  Messages_Delete ensureDelete() => $_ensure(3);

  @$pb.TagNumber(5)
  Messages_ReadContents get readContents => $_getN(4);
  @$pb.TagNumber(5)
  set readContents(Messages_ReadContents value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReadContents() => $_has(4);
  @$pb.TagNumber(5)
  void clearReadContents() => $_clearField(5);
  @$pb.TagNumber(5)
  Messages_ReadContents ensureReadContents() => $_ensure(4);

  @$pb.TagNumber(6)
  Messages_Pin get pin => $_getN(5);
  @$pb.TagNumber(6)
  set pin(Messages_Pin value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPin() => $_has(5);
  @$pb.TagNumber(6)
  void clearPin() => $_clearField(6);
  @$pb.TagNumber(6)
  Messages_Pin ensurePin() => $_ensure(5);

  @$pb.TagNumber(7)
  Messages_UnpinAll get unpinAll => $_getN(6);
  @$pb.TagNumber(7)
  set unpinAll(Messages_UnpinAll value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUnpinAll() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnpinAll() => $_clearField(7);
  @$pb.TagNumber(7)
  Messages_UnpinAll ensureUnpinAll() => $_ensure(6);

  @$pb.TagNumber(8)
  Messages_Pinned get pinned => $_getN(7);
  @$pb.TagNumber(8)
  set pinned(Messages_Pinned value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPinned() => $_has(7);
  @$pb.TagNumber(8)
  void clearPinned() => $_clearField(8);
  @$pb.TagNumber(8)
  Messages_Pinned ensurePinned() => $_ensure(7);

  @$pb.TagNumber(9)
  Messages_SetReactions get setReactions => $_getN(8);
  @$pb.TagNumber(9)
  set setReactions(Messages_SetReactions value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSetReactions() => $_has(8);
  @$pb.TagNumber(9)
  void clearSetReactions() => $_clearField(9);
  @$pb.TagNumber(9)
  Messages_SetReactions ensureSetReactions() => $_ensure(8);

  @$pb.TagNumber(10)
  Messages_ReadReactions get readReactions => $_getN(9);
  @$pb.TagNumber(10)
  set readReactions(Messages_ReadReactions value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReadReactions() => $_has(9);
  @$pb.TagNumber(10)
  void clearReadReactions() => $_clearField(10);
  @$pb.TagNumber(10)
  Messages_ReadReactions ensureReadReactions() => $_ensure(9);

  @$pb.TagNumber(11)
  Messages_UnreadReactions get unreadReactions => $_getN(10);
  @$pb.TagNumber(11)
  set unreadReactions(Messages_UnreadReactions value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUnreadReactions() => $_has(10);
  @$pb.TagNumber(11)
  void clearUnreadReactions() => $_clearField(11);
  @$pb.TagNumber(11)
  Messages_UnreadReactions ensureUnreadReactions() => $_ensure(10);

  @$pb.TagNumber(12)
  Messages_Scheduled get scheduled => $_getN(11);
  @$pb.TagNumber(12)
  set scheduled(Messages_Scheduled value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasScheduled() => $_has(11);
  @$pb.TagNumber(12)
  void clearScheduled() => $_clearField(12);
  @$pb.TagNumber(12)
  Messages_Scheduled ensureScheduled() => $_ensure(11);

  @$pb.TagNumber(13)
  Messages_SendScheduledNow get sendScheduledNow => $_getN(12);
  @$pb.TagNumber(13)
  set sendScheduledNow(Messages_SendScheduledNow value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSendScheduledNow() => $_has(12);
  @$pb.TagNumber(13)
  void clearSendScheduledNow() => $_clearField(13);
  @$pb.TagNumber(13)
  Messages_SendScheduledNow ensureSendScheduledNow() => $_ensure(12);

  @$pb.TagNumber(14)
  Messages_Reschedule get reschedule => $_getN(13);
  @$pb.TagNumber(14)
  set reschedule(Messages_Reschedule value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasReschedule() => $_has(13);
  @$pb.TagNumber(14)
  void clearReschedule() => $_clearField(14);
  @$pb.TagNumber(14)
  Messages_Reschedule ensureReschedule() => $_ensure(13);

  @$pb.TagNumber(15)
  Messages_DeleteScheduled get deleteScheduled => $_getN(14);
  @$pb.TagNumber(15)
  set deleteScheduled(Messages_DeleteScheduled value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasDeleteScheduled() => $_has(14);
  @$pb.TagNumber(15)
  void clearDeleteScheduled() => $_clearField(15);
  @$pb.TagNumber(15)
  Messages_DeleteScheduled ensureDeleteScheduled() => $_ensure(14);

  @$pb.TagNumber(16)
  Messages_Get get get => $_getN(15);
  @$pb.TagNumber(16)
  set get(Messages_Get value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasGet() => $_has(15);
  @$pb.TagNumber(16)
  void clearGet() => $_clearField(16);
  @$pb.TagNumber(16)
  Messages_Get ensureGet() => $_ensure(15);

  @$pb.TagNumber(17)
  Messages_ReadParticipants get readParticipants => $_getN(16);
  @$pb.TagNumber(17)
  set readParticipants(Messages_ReadParticipants value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasReadParticipants() => $_has(16);
  @$pb.TagNumber(17)
  void clearReadParticipants() => $_clearField(17);
  @$pb.TagNumber(17)
  Messages_ReadParticipants ensureReadParticipants() => $_ensure(16);

  @$pb.TagNumber(18)
  Messages_UnreadMentions get unreadMentions => $_getN(17);
  @$pb.TagNumber(18)
  set unreadMentions(Messages_UnreadMentions value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasUnreadMentions() => $_has(17);
  @$pb.TagNumber(18)
  void clearUnreadMentions() => $_clearField(18);
  @$pb.TagNumber(18)
  Messages_UnreadMentions ensureUnreadMentions() => $_ensure(17);

  @$pb.TagNumber(19)
  Messages_ReadMentions get readMentions => $_getN(18);
  @$pb.TagNumber(19)
  set readMentions(Messages_ReadMentions value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasReadMentions() => $_has(18);
  @$pb.TagNumber(19)
  void clearReadMentions() => $_clearField(19);
  @$pb.TagNumber(19)
  Messages_ReadMentions ensureReadMentions() => $_ensure(18);

  @$pb.TagNumber(20)
  Messages_VotePoll get votePoll => $_getN(19);
  @$pb.TagNumber(20)
  set votePoll(Messages_VotePoll value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasVotePoll() => $_has(19);
  @$pb.TagNumber(20)
  void clearVotePoll() => $_clearField(20);
  @$pb.TagNumber(20)
  Messages_VotePoll ensureVotePoll() => $_ensure(19);

  @$pb.TagNumber(21)
  Messages_ClosePoll get closePoll => $_getN(20);
  @$pb.TagNumber(21)
  set closePoll(Messages_ClosePoll value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasClosePoll() => $_has(20);
  @$pb.TagNumber(21)
  void clearClosePoll() => $_clearField(21);
  @$pb.TagNumber(21)
  Messages_ClosePoll ensureClosePoll() => $_ensure(20);

  @$pb.TagNumber(22)
  Messages_PollVoters get pollVoters => $_getN(21);
  @$pb.TagNumber(22)
  set pollVoters(Messages_PollVoters value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasPollVoters() => $_has(21);
  @$pb.TagNumber(22)
  void clearPollVoters() => $_clearField(22);
  @$pb.TagNumber(22)
  Messages_PollVoters ensurePollVoters() => $_ensure(21);

  @$pb.TagNumber(23)
  Messages_ReactionsList get reactionsList => $_getN(22);
  @$pb.TagNumber(23)
  set reactionsList(Messages_ReactionsList value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasReactionsList() => $_has(22);
  @$pb.TagNumber(23)
  void clearReactionsList() => $_clearField(23);
  @$pb.TagNumber(23)
  Messages_ReactionsList ensureReactionsList() => $_ensure(22);

  @$pb.TagNumber(24)
  Messages_Search get search => $_getN(23);
  @$pb.TagNumber(24)
  set search(Messages_Search value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasSearch() => $_has(23);
  @$pb.TagNumber(24)
  void clearSearch() => $_clearField(24);
  @$pb.TagNumber(24)
  Messages_Search ensureSearch() => $_ensure(23);
}

enum Messages_Response_Response {
  history,
  send,
  edit,
  delete,
  readContents,
  pin,
  unpinAll,
  pinned,
  setReactions,
  readReactions,
  unreadReactions,
  scheduled,
  sendScheduledNow,
  reschedule,
  deleteScheduled,
  get,
  readParticipants,
  unreadMentions,
  readMentions,
  votePoll,
  closePoll,
  pollVoters,
  reactionsList,
  search,
  notSet
}

class Messages_Response extends $pb.GeneratedMessage {
  factory Messages_Response({
    Messages_HistoryResult? history,
    Messages_SendResult? send,
    Messages_EditResult? edit,
    Messages_DeleteResult? delete,
    Messages_ReadContentsResult? readContents,
    Messages_PinResult? pin,
    Messages_UnpinAllResult? unpinAll,
    Messages_PinnedResult? pinned,
    Messages_SetReactionsResult? setReactions,
    Messages_ReadReactionsResult? readReactions,
    Messages_UnreadReactionsResult? unreadReactions,
    Messages_ScheduledResult? scheduled,
    Messages_SendScheduledNowResult? sendScheduledNow,
    Messages_RescheduleResult? reschedule,
    Messages_DeleteScheduledResult? deleteScheduled,
    Messages_GetResult? get,
    Messages_ReadParticipantsResult? readParticipants,
    Messages_UnreadMentionsResult? unreadMentions,
    Messages_ReadMentionsResult? readMentions,
    Messages_VotePollResult? votePoll,
    Messages_ClosePollResult? closePoll,
    Messages_PollVotersResult? pollVoters,
    Messages_ReactionsListResult? reactionsList,
    Messages_SearchResult? search,
  }) {
    final result = create();
    if (history != null) result.history = history;
    if (send != null) result.send = send;
    if (edit != null) result.edit = edit;
    if (delete != null) result.delete = delete;
    if (readContents != null) result.readContents = readContents;
    if (pin != null) result.pin = pin;
    if (unpinAll != null) result.unpinAll = unpinAll;
    if (pinned != null) result.pinned = pinned;
    if (setReactions != null) result.setReactions = setReactions;
    if (readReactions != null) result.readReactions = readReactions;
    if (unreadReactions != null) result.unreadReactions = unreadReactions;
    if (scheduled != null) result.scheduled = scheduled;
    if (sendScheduledNow != null) result.sendScheduledNow = sendScheduledNow;
    if (reschedule != null) result.reschedule = reschedule;
    if (deleteScheduled != null) result.deleteScheduled = deleteScheduled;
    if (get != null) result.get = get;
    if (readParticipants != null) result.readParticipants = readParticipants;
    if (unreadMentions != null) result.unreadMentions = unreadMentions;
    if (readMentions != null) result.readMentions = readMentions;
    if (votePoll != null) result.votePoll = votePoll;
    if (closePoll != null) result.closePoll = closePoll;
    if (pollVoters != null) result.pollVoters = pollVoters;
    if (reactionsList != null) result.reactionsList = reactionsList;
    if (search != null) result.search = search;
    return result;
  }

  Messages_Response._();

  factory Messages_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Messages_Response_Response> _Messages_Response_ResponseByTag = {
    1: Messages_Response_Response.history,
    2: Messages_Response_Response.send,
    3: Messages_Response_Response.edit,
    4: Messages_Response_Response.delete,
    5: Messages_Response_Response.readContents,
    6: Messages_Response_Response.pin,
    7: Messages_Response_Response.unpinAll,
    8: Messages_Response_Response.pinned,
    9: Messages_Response_Response.setReactions,
    10: Messages_Response_Response.readReactions,
    11: Messages_Response_Response.unreadReactions,
    12: Messages_Response_Response.scheduled,
    13: Messages_Response_Response.sendScheduledNow,
    14: Messages_Response_Response.reschedule,
    15: Messages_Response_Response.deleteScheduled,
    16: Messages_Response_Response.get,
    17: Messages_Response_Response.readParticipants,
    18: Messages_Response_Response.unreadMentions,
    19: Messages_Response_Response.readMentions,
    20: Messages_Response_Response.votePoll,
    21: Messages_Response_Response.closePoll,
    22: Messages_Response_Response.pollVoters,
    23: Messages_Response_Response.reactionsList,
    24: Messages_Response_Response.search,
    0: Messages_Response_Response.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24])
    ..aOM<Messages_HistoryResult>(1, _omitFieldNames ? '' : 'history', subBuilder: Messages_HistoryResult.create)
    ..aOM<Messages_SendResult>(2, _omitFieldNames ? '' : 'send', subBuilder: Messages_SendResult.create)
    ..aOM<Messages_EditResult>(3, _omitFieldNames ? '' : 'edit', subBuilder: Messages_EditResult.create)
    ..aOM<Messages_DeleteResult>(4, _omitFieldNames ? '' : 'delete', subBuilder: Messages_DeleteResult.create)
    ..aOM<Messages_ReadContentsResult>(5, _omitFieldNames ? '' : 'readContents',
        protoName: 'readContents', subBuilder: Messages_ReadContentsResult.create)
    ..aOM<Messages_PinResult>(6, _omitFieldNames ? '' : 'pin', subBuilder: Messages_PinResult.create)
    ..aOM<Messages_UnpinAllResult>(7, _omitFieldNames ? '' : 'unpinAll', protoName: 'unpinAll', subBuilder: Messages_UnpinAllResult.create)
    ..aOM<Messages_PinnedResult>(8, _omitFieldNames ? '' : 'pinned', subBuilder: Messages_PinnedResult.create)
    ..aOM<Messages_SetReactionsResult>(9, _omitFieldNames ? '' : 'setReactions',
        protoName: 'setReactions', subBuilder: Messages_SetReactionsResult.create)
    ..aOM<Messages_ReadReactionsResult>(10, _omitFieldNames ? '' : 'readReactions',
        protoName: 'readReactions', subBuilder: Messages_ReadReactionsResult.create)
    ..aOM<Messages_UnreadReactionsResult>(11, _omitFieldNames ? '' : 'unreadReactions',
        protoName: 'unreadReactions', subBuilder: Messages_UnreadReactionsResult.create)
    ..aOM<Messages_ScheduledResult>(12, _omitFieldNames ? '' : 'scheduled', subBuilder: Messages_ScheduledResult.create)
    ..aOM<Messages_SendScheduledNowResult>(13, _omitFieldNames ? '' : 'sendScheduledNow',
        protoName: 'sendScheduledNow', subBuilder: Messages_SendScheduledNowResult.create)
    ..aOM<Messages_RescheduleResult>(14, _omitFieldNames ? '' : 'reschedule', subBuilder: Messages_RescheduleResult.create)
    ..aOM<Messages_DeleteScheduledResult>(15, _omitFieldNames ? '' : 'deleteScheduled',
        protoName: 'deleteScheduled', subBuilder: Messages_DeleteScheduledResult.create)
    ..aOM<Messages_GetResult>(16, _omitFieldNames ? '' : 'get', subBuilder: Messages_GetResult.create)
    ..aOM<Messages_ReadParticipantsResult>(17, _omitFieldNames ? '' : 'readParticipants',
        protoName: 'readParticipants', subBuilder: Messages_ReadParticipantsResult.create)
    ..aOM<Messages_UnreadMentionsResult>(18, _omitFieldNames ? '' : 'unreadMentions',
        protoName: 'unreadMentions', subBuilder: Messages_UnreadMentionsResult.create)
    ..aOM<Messages_ReadMentionsResult>(19, _omitFieldNames ? '' : 'readMentions',
        protoName: 'readMentions', subBuilder: Messages_ReadMentionsResult.create)
    ..aOM<Messages_VotePollResult>(20, _omitFieldNames ? '' : 'votePoll', protoName: 'votePoll', subBuilder: Messages_VotePollResult.create)
    ..aOM<Messages_ClosePollResult>(21, _omitFieldNames ? '' : 'closePoll',
        protoName: 'closePoll', subBuilder: Messages_ClosePollResult.create)
    ..aOM<Messages_PollVotersResult>(22, _omitFieldNames ? '' : 'pollVoters',
        protoName: 'pollVoters', subBuilder: Messages_PollVotersResult.create)
    ..aOM<Messages_ReactionsListResult>(23, _omitFieldNames ? '' : 'reactionsList',
        protoName: 'reactionsList', subBuilder: Messages_ReactionsListResult.create)
    ..aOM<Messages_SearchResult>(24, _omitFieldNames ? '' : 'search', subBuilder: Messages_SearchResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Response copyWith(void Function(Messages_Response) updates) =>
      super.copyWith((message) => updates(message as Messages_Response)) as Messages_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Response create() => Messages_Response._();
  @$core.override
  Messages_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Response>(create);
  static Messages_Response? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  Messages_Response_Response whichResponse() => _Messages_Response_ResponseByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  void clearResponse() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Messages_HistoryResult get history => $_getN(0);
  @$pb.TagNumber(1)
  set history(Messages_HistoryResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHistory() => $_has(0);
  @$pb.TagNumber(1)
  void clearHistory() => $_clearField(1);
  @$pb.TagNumber(1)
  Messages_HistoryResult ensureHistory() => $_ensure(0);

  @$pb.TagNumber(2)
  Messages_SendResult get send => $_getN(1);
  @$pb.TagNumber(2)
  set send(Messages_SendResult value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSend() => $_has(1);
  @$pb.TagNumber(2)
  void clearSend() => $_clearField(2);
  @$pb.TagNumber(2)
  Messages_SendResult ensureSend() => $_ensure(1);

  @$pb.TagNumber(3)
  Messages_EditResult get edit => $_getN(2);
  @$pb.TagNumber(3)
  set edit(Messages_EditResult value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEdit() => $_has(2);
  @$pb.TagNumber(3)
  void clearEdit() => $_clearField(3);
  @$pb.TagNumber(3)
  Messages_EditResult ensureEdit() => $_ensure(2);

  @$pb.TagNumber(4)
  Messages_DeleteResult get delete => $_getN(3);
  @$pb.TagNumber(4)
  set delete(Messages_DeleteResult value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDelete() => $_has(3);
  @$pb.TagNumber(4)
  void clearDelete() => $_clearField(4);
  @$pb.TagNumber(4)
  Messages_DeleteResult ensureDelete() => $_ensure(3);

  @$pb.TagNumber(5)
  Messages_ReadContentsResult get readContents => $_getN(4);
  @$pb.TagNumber(5)
  set readContents(Messages_ReadContentsResult value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReadContents() => $_has(4);
  @$pb.TagNumber(5)
  void clearReadContents() => $_clearField(5);
  @$pb.TagNumber(5)
  Messages_ReadContentsResult ensureReadContents() => $_ensure(4);

  @$pb.TagNumber(6)
  Messages_PinResult get pin => $_getN(5);
  @$pb.TagNumber(6)
  set pin(Messages_PinResult value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPin() => $_has(5);
  @$pb.TagNumber(6)
  void clearPin() => $_clearField(6);
  @$pb.TagNumber(6)
  Messages_PinResult ensurePin() => $_ensure(5);

  @$pb.TagNumber(7)
  Messages_UnpinAllResult get unpinAll => $_getN(6);
  @$pb.TagNumber(7)
  set unpinAll(Messages_UnpinAllResult value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUnpinAll() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnpinAll() => $_clearField(7);
  @$pb.TagNumber(7)
  Messages_UnpinAllResult ensureUnpinAll() => $_ensure(6);

  @$pb.TagNumber(8)
  Messages_PinnedResult get pinned => $_getN(7);
  @$pb.TagNumber(8)
  set pinned(Messages_PinnedResult value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPinned() => $_has(7);
  @$pb.TagNumber(8)
  void clearPinned() => $_clearField(8);
  @$pb.TagNumber(8)
  Messages_PinnedResult ensurePinned() => $_ensure(7);

  @$pb.TagNumber(9)
  Messages_SetReactionsResult get setReactions => $_getN(8);
  @$pb.TagNumber(9)
  set setReactions(Messages_SetReactionsResult value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSetReactions() => $_has(8);
  @$pb.TagNumber(9)
  void clearSetReactions() => $_clearField(9);
  @$pb.TagNumber(9)
  Messages_SetReactionsResult ensureSetReactions() => $_ensure(8);

  @$pb.TagNumber(10)
  Messages_ReadReactionsResult get readReactions => $_getN(9);
  @$pb.TagNumber(10)
  set readReactions(Messages_ReadReactionsResult value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReadReactions() => $_has(9);
  @$pb.TagNumber(10)
  void clearReadReactions() => $_clearField(10);
  @$pb.TagNumber(10)
  Messages_ReadReactionsResult ensureReadReactions() => $_ensure(9);

  @$pb.TagNumber(11)
  Messages_UnreadReactionsResult get unreadReactions => $_getN(10);
  @$pb.TagNumber(11)
  set unreadReactions(Messages_UnreadReactionsResult value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUnreadReactions() => $_has(10);
  @$pb.TagNumber(11)
  void clearUnreadReactions() => $_clearField(11);
  @$pb.TagNumber(11)
  Messages_UnreadReactionsResult ensureUnreadReactions() => $_ensure(10);

  @$pb.TagNumber(12)
  Messages_ScheduledResult get scheduled => $_getN(11);
  @$pb.TagNumber(12)
  set scheduled(Messages_ScheduledResult value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasScheduled() => $_has(11);
  @$pb.TagNumber(12)
  void clearScheduled() => $_clearField(12);
  @$pb.TagNumber(12)
  Messages_ScheduledResult ensureScheduled() => $_ensure(11);

  @$pb.TagNumber(13)
  Messages_SendScheduledNowResult get sendScheduledNow => $_getN(12);
  @$pb.TagNumber(13)
  set sendScheduledNow(Messages_SendScheduledNowResult value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSendScheduledNow() => $_has(12);
  @$pb.TagNumber(13)
  void clearSendScheduledNow() => $_clearField(13);
  @$pb.TagNumber(13)
  Messages_SendScheduledNowResult ensureSendScheduledNow() => $_ensure(12);

  @$pb.TagNumber(14)
  Messages_RescheduleResult get reschedule => $_getN(13);
  @$pb.TagNumber(14)
  set reschedule(Messages_RescheduleResult value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasReschedule() => $_has(13);
  @$pb.TagNumber(14)
  void clearReschedule() => $_clearField(14);
  @$pb.TagNumber(14)
  Messages_RescheduleResult ensureReschedule() => $_ensure(13);

  @$pb.TagNumber(15)
  Messages_DeleteScheduledResult get deleteScheduled => $_getN(14);
  @$pb.TagNumber(15)
  set deleteScheduled(Messages_DeleteScheduledResult value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasDeleteScheduled() => $_has(14);
  @$pb.TagNumber(15)
  void clearDeleteScheduled() => $_clearField(15);
  @$pb.TagNumber(15)
  Messages_DeleteScheduledResult ensureDeleteScheduled() => $_ensure(14);

  @$pb.TagNumber(16)
  Messages_GetResult get get => $_getN(15);
  @$pb.TagNumber(16)
  set get(Messages_GetResult value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasGet() => $_has(15);
  @$pb.TagNumber(16)
  void clearGet() => $_clearField(16);
  @$pb.TagNumber(16)
  Messages_GetResult ensureGet() => $_ensure(15);

  @$pb.TagNumber(17)
  Messages_ReadParticipantsResult get readParticipants => $_getN(16);
  @$pb.TagNumber(17)
  set readParticipants(Messages_ReadParticipantsResult value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasReadParticipants() => $_has(16);
  @$pb.TagNumber(17)
  void clearReadParticipants() => $_clearField(17);
  @$pb.TagNumber(17)
  Messages_ReadParticipantsResult ensureReadParticipants() => $_ensure(16);

  @$pb.TagNumber(18)
  Messages_UnreadMentionsResult get unreadMentions => $_getN(17);
  @$pb.TagNumber(18)
  set unreadMentions(Messages_UnreadMentionsResult value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasUnreadMentions() => $_has(17);
  @$pb.TagNumber(18)
  void clearUnreadMentions() => $_clearField(18);
  @$pb.TagNumber(18)
  Messages_UnreadMentionsResult ensureUnreadMentions() => $_ensure(17);

  @$pb.TagNumber(19)
  Messages_ReadMentionsResult get readMentions => $_getN(18);
  @$pb.TagNumber(19)
  set readMentions(Messages_ReadMentionsResult value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasReadMentions() => $_has(18);
  @$pb.TagNumber(19)
  void clearReadMentions() => $_clearField(19);
  @$pb.TagNumber(19)
  Messages_ReadMentionsResult ensureReadMentions() => $_ensure(18);

  @$pb.TagNumber(20)
  Messages_VotePollResult get votePoll => $_getN(19);
  @$pb.TagNumber(20)
  set votePoll(Messages_VotePollResult value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasVotePoll() => $_has(19);
  @$pb.TagNumber(20)
  void clearVotePoll() => $_clearField(20);
  @$pb.TagNumber(20)
  Messages_VotePollResult ensureVotePoll() => $_ensure(19);

  @$pb.TagNumber(21)
  Messages_ClosePollResult get closePoll => $_getN(20);
  @$pb.TagNumber(21)
  set closePoll(Messages_ClosePollResult value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasClosePoll() => $_has(20);
  @$pb.TagNumber(21)
  void clearClosePoll() => $_clearField(21);
  @$pb.TagNumber(21)
  Messages_ClosePollResult ensureClosePoll() => $_ensure(20);

  @$pb.TagNumber(22)
  Messages_PollVotersResult get pollVoters => $_getN(21);
  @$pb.TagNumber(22)
  set pollVoters(Messages_PollVotersResult value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasPollVoters() => $_has(21);
  @$pb.TagNumber(22)
  void clearPollVoters() => $_clearField(22);
  @$pb.TagNumber(22)
  Messages_PollVotersResult ensurePollVoters() => $_ensure(21);

  @$pb.TagNumber(23)
  Messages_ReactionsListResult get reactionsList => $_getN(22);
  @$pb.TagNumber(23)
  set reactionsList(Messages_ReactionsListResult value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasReactionsList() => $_has(22);
  @$pb.TagNumber(23)
  void clearReactionsList() => $_clearField(23);
  @$pb.TagNumber(23)
  Messages_ReactionsListResult ensureReactionsList() => $_ensure(22);

  @$pb.TagNumber(24)
  Messages_SearchResult get search => $_getN(23);
  @$pb.TagNumber(24)
  set search(Messages_SearchResult value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasSearch() => $_has(23);
  @$pb.TagNumber(24)
  void clearSearch() => $_clearField(24);
  @$pb.TagNumber(24)
  Messages_SearchResult ensureSearch() => $_ensure(23);
}

/// MESSAGES — сообщения.
class Messages extends $pb.GeneratedMessage {
  factory Messages() => create();

  Messages._();

  factory Messages.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages copyWith(void Function(Messages) updates) => super.copyWith((message) => updates(message as Messages)) as Messages;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages create() => Messages._();
  @$core.override
  Messages createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages>(create);
  static Messages? _defaultInstance;
}

class GetDifference_Request extends $pb.GeneratedMessage {
  factory GetDifference_Request({
    $fixnum.Int64? pts,
    $core.int? limit,
  }) {
    final result = create();
    if (pts != null) result.pts = pts;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetDifference_Request._();

  factory GetDifference_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDifference_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDifference.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pts')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference_Request copyWith(void Function(GetDifference_Request) updates) =>
      super.copyWith((message) => updates(message as GetDifference_Request)) as GetDifference_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDifference_Request create() => GetDifference_Request._();
  @$core.override
  GetDifference_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDifference_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDifference_Request>(create);
  static GetDifference_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pts => $_getI64(0);
  @$pb.TagNumber(1)
  set pts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPts() => $_has(0);
  @$pb.TagNumber(1)
  void clearPts() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class GetDifference_Response extends $pb.GeneratedMessage {
  factory GetDifference_Response({
    $core.Iterable<Update>? updates,
    UpdatesState? state,
    $core.bool? hasMore,
    $core.bool? tooLong,
  }) {
    final result = create();
    if (updates != null) result.updates.addAll(updates);
    if (state != null) result.state = state;
    if (hasMore != null) result.hasMore = hasMore;
    if (tooLong != null) result.tooLong = tooLong;
    return result;
  }

  GetDifference_Response._();

  factory GetDifference_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDifference_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDifference.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Update>(1, _omitFieldNames ? '' : 'updates', subBuilder: Update.create)
    ..aOM<UpdatesState>(2, _omitFieldNames ? '' : 'state', subBuilder: UpdatesState.create)
    ..aOB(3, _omitFieldNames ? '' : 'hasMore', protoName: 'hasMore')
    ..aOB(4, _omitFieldNames ? '' : 'tooLong', protoName: 'tooLong')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference_Response copyWith(void Function(GetDifference_Response) updates) =>
      super.copyWith((message) => updates(message as GetDifference_Response)) as GetDifference_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDifference_Response create() => GetDifference_Response._();
  @$core.override
  GetDifference_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDifference_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDifference_Response>(create);
  static GetDifference_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Update> get updates => $_getList(0);

  @$pb.TagNumber(2)
  UpdatesState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(UpdatesState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);
  @$pb.TagNumber(2)
  UpdatesState ensureState() => $_ensure(1);

  /// Есть ещё — запросить снова с state.pts.
  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  /// Отстали слишком сильно (журнал уже обрезан): перезагрузить диалоги
  /// (Chats.List) и историю открытых чатов, затем продолжать от state.pts.
  @$pb.TagNumber(4)
  $core.bool get tooLong => $_getBF(3);
  @$pb.TagNumber(4)
  set tooLong($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTooLong() => $_has(3);
  @$pb.TagNumber(4)
  void clearTooLong() => $_clearField(4);
}

/// GET_DIFFERENCE — догон после переподключения: обновления с pts > запрошенного.
class GetDifference extends $pb.GeneratedMessage {
  factory GetDifference() => create();

  GetDifference._();

  factory GetDifference.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDifference.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDifference',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference copyWith(void Function(GetDifference) updates) =>
      super.copyWith((message) => updates(message as GetDifference)) as GetDifference;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDifference create() => GetDifference._();
  @$core.override
  GetDifference createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDifference getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDifference>(create);
  static GetDifference? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
