import 'dart:typed_data';

import 'package:bloc/bloc.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';
import 'settings_privacy_and_security_state.dart';

class SettingsPrivacyAndSecurityCubit extends Cubit<SettingsPrivacyAndSecurityState> {
  SettingsPrivacyAndSecurityCubit() : super(SettingsPrivacyAndSecurityState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();

  /// Ключ локального кэша настройки «кто может звонить» (per-user, бессрочно).
  static const _callsCacheKey = "privacy.calls.audience";

  /// Ключи локального кэша настроек дня рождения (per-user, бессрочно).
  static const _birthdayCacheKey = "privacy.birthday.audience";
  static const _hideBirthYearCacheKey = "privacy.birthday.hideYear";

  /// Ключ локального кэша настройки «кто может видеть „О себе“».
  static const _aboutMeCacheKey = "privacy.aboutMe.audience";

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    final isBiometricAvailable = await utils.isBiometricAvailable();
    emit(state.copyWith(status: Status.success, isBiometricAvailable: isBiometricAvailable));
    await _loadCalls();
  }

  /// Перечитывает серверные настройки приватности. Вызывается родительским
  /// экраном «Конфиденциальность» после возврата с детейл-экранов (у них свой
  /// инстанс cubit), чтобы label'ы в списке не остались устаревшими. Один ответ
  /// PRIVACY_SETTINGS несёт и звонки, и день рождения.
  Future<void> reloadCalls() => _loadCalls();

  /// Алиас [reloadCalls] для читаемости на экране дня рождения (тот же ответ).
  Future<void> reloadBirthday() => _loadCalls();

  /// Алиас [reloadCalls] для читаемости на экране «О себе» (тот же ответ).
  Future<void> reloadAboutMe() => _loadCalls();

  /// Загружает настройку «кто может звонить». Сначала мгновенно поднимаем
  /// последнее значение из локального кэша (видно и offline), затем пробуем
  /// сервер. Успех — обновляем значение + кэш, снимаем блокировки. Сбой:
  /// показываем кэш read-only (offline, менять нельзя — гейт серверный), а если
  /// кэша нет — [callsLoadError] с повтором (см. offline-раздел CLAUDE.md).
  Future<void> _loadCalls() async {
    final cached = await _readCache();
    final cachedBirthday = await _readBirthdayCache();
    final cachedHideBirthYear = await _readHideBirthYearCache();
    final cachedAboutMe = await _readAboutMeCache();
    if (isClosed) return;
    if (cached != null) emit(state.copyWith(callsAudience: cached, callsLoadError: false));
    if (cachedBirthday != null) emit(state.copyWith(birthdayAudience: cachedBirthday));
    if (cachedHideBirthYear != null) emit(state.copyWith(hideBirthYear: cachedHideBirthYear));
    if (cachedAboutMe != null) emit(state.copyWith(aboutMeAudience: cachedAboutMe));

    try {
      final (status, payload) = await api.unaryEncodedWithResponse(MessageType.PRIVACY_SETTINGS, PrivacySettings_Request().writeToBuffer());
      if (isClosed) return;

      if (status.status != APIStatus.success || payload == null) {
        logger.warning('privacy: load settings failed (${status.error})');
        emit(state.copyWith(callsLoadError: cached == null, callsReadOnly: cached != null));
        return;
      }

      final response = PrivacySettings_Response.fromBuffer(payload);
      final audience = _fromProto(response.calls);
      final allow = response.callsAllow.map(Uint8List.fromList).toList(growable: false);
      final deny = response.callsDeny.map(Uint8List.fromList).toList(growable: false);
      final birthday = _fromProto(response.birthday);
      final birthdayAllow = response.birthdayAllow.map(Uint8List.fromList).toList(growable: false);
      final birthdayDeny = response.birthdayDeny.map(Uint8List.fromList).toList(growable: false);
      final aboutMe = _fromProto(response.aboutMe);
      final aboutMeAllow = response.aboutMeAllow.map(Uint8List.fromList).toList(growable: false);
      final aboutMeDeny = response.aboutMeDeny.map(Uint8List.fromList).toList(growable: false);
      await _writeCache(audience);
      await _writeBirthdayCache(birthday);
      await _writeHideBirthYearCache(response.hideBirthYear);
      await _writeAboutMeCache(aboutMe);
      if (!isClosed) {
        emit(
          state.copyWith(
            callsAudience: audience,
            callsAllow: allow,
            callsDeny: deny,
            birthdayAudience: birthday,
            birthdayAllow: birthdayAllow,
            birthdayDeny: birthdayDeny,
            hideBirthYear: response.hideBirthYear,
            aboutMeAudience: aboutMe,
            aboutMeAllow: aboutMeAllow,
            aboutMeDeny: aboutMeDeny,
            callsLoadError: false,
            callsReadOnly: false,
          ),
        );
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      if (!isClosed) emit(state.copyWith(callsLoadError: cached == null, callsReadOnly: cached != null));
    }
  }

  /// Меняет настройку «кто может звонить». Настройку нельзя применить offline
  /// (гейт серверный) — поэтому сперва проверяем сеть и НЕ делаем оптимистичный
  /// emit с откатом (галочка визуально не прыгает). При успехе обновляем кэш.
  /// Возвращает `false`, если изменение не применилось (offline/ошибка).
  Future<bool> setCallsAudience(CallsPrivacyAudience audience) async {
    if (audience == state.callsAudience && !state.callsLoadError && !state.callsReadOnly) return true;

    if (!await utils.hasNetwork()) {
      logger.info('privacy: set calls audience aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_SETTINGS_UPDATE,
      PrivacySettingsUpdate_Request(calls: _toProto(audience)).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update calls audience failed (${status.error})');
      return false;
    }

    // Успех подтверждает и связь, и новое значение — фиксируем, кэшируем, снимаем блокировки.
    await _writeCache(audience);
    if (!isClosed) emit(state.copyWith(callsAudience: audience, callsLoadError: false, callsReadOnly: false));
    return true;
  }

  /// Полностью заменяет allow-list «всегда разрешать» для звонков. Как и смена
  /// аудитории — серверная операция, offline недоступна. Возвращает `false`,
  /// если не применилось (offline/ошибка).
  Future<bool> setCallsAllow(List<Uint8List> userIDs) async {
    if (!await utils.hasNetwork()) {
      logger.info('privacy: set calls allow aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_CALLS_ALLOW_UPDATE,
      PrivacyCallsAllowUpdate_Request(userIds: userIDs).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update calls allow failed (${status.error})');
      return false;
    }

    if (!isClosed) emit(state.copyWith(callsAllow: List<Uint8List>.unmodifiable(userIDs)));
    return true;
  }

  /// Полностью заменяет deny-list «всегда запрещать» для звонков. Как и смена
  /// аудитории — серверная операция, offline недоступна. Возвращает `false`,
  /// если не применилось (offline/ошибка).
  Future<bool> setCallsDeny(List<Uint8List> userIDs) async {
    if (!await utils.hasNetwork()) {
      logger.info('privacy: set calls deny aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_CALLS_DENY_UPDATE,
      PrivacyCallsDenyUpdate_Request(userIds: userIDs).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update calls deny failed (${status.error})');
      return false;
    }

    if (!isClosed) emit(state.copyWith(callsDeny: List<Uint8List>.unmodifiable(userIDs)));
    return true;
  }

  /// Меняет настройку «кто может видеть мою дату рождения». Как и звонки —
  /// серверная операция, offline недоступна (не делаем оптимистичный emit с
  /// откатом). Возвращает `false`, если не применилось (offline/ошибка).
  Future<bool> setBirthdayAudience(CallsPrivacyAudience audience) async {
    if (audience == state.birthdayAudience && !state.callsLoadError && !state.callsReadOnly) return true;

    if (!await utils.hasNetwork()) {
      logger.info('privacy: set birthday audience aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_BIRTHDAY_UPDATE,
      PrivacyBirthdayUpdate_Request(birthday: _toProto(audience)).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update birthday audience failed (${status.error})');
      return false;
    }

    await _writeBirthdayCache(audience);
    if (!isClosed) emit(state.copyWith(birthdayAudience: audience, callsLoadError: false, callsReadOnly: false));
    return true;
  }

  /// Полностью заменяет allow-list «всегда разрешать» для дня рождения.
  Future<bool> setBirthdayAllow(List<Uint8List> userIDs) async {
    if (!await utils.hasNetwork()) {
      logger.info('privacy: set birthday allow aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_BIRTHDAY_ALLOW_UPDATE,
      PrivacyBirthdayAllowUpdate_Request(userIds: userIDs).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update birthday allow failed (${status.error})');
      return false;
    }

    if (!isClosed) emit(state.copyWith(birthdayAllow: List<Uint8List>.unmodifiable(userIDs)));
    return true;
  }

  /// Полностью заменяет deny-list «всегда запрещать» для дня рождения.
  Future<bool> setBirthdayDeny(List<Uint8List> userIDs) async {
    if (!await utils.hasNetwork()) {
      logger.info('privacy: set birthday deny aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_BIRTHDAY_DENY_UPDATE,
      PrivacyBirthdayDenyUpdate_Request(userIds: userIDs).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update birthday deny failed (${status.error})');
      return false;
    }

    if (!isClosed) emit(state.copyWith(birthdayDeny: List<Uint8List>.unmodifiable(userIDs)));
    return true;
  }

  /// Переключает «скрывать год рождения и возраст». Серверная операция, offline
  /// недоступна. Возвращает `false`, если не применилось (offline/ошибка).
  Future<bool> setHideBirthYear(bool hide) async {
    if (hide == state.hideBirthYear && !state.callsLoadError && !state.callsReadOnly) return true;

    if (!await utils.hasNetwork()) {
      logger.info('privacy: set hide birth year aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_HIDE_BIRTH_YEAR_UPDATE,
      PrivacyHideBirthYearUpdate_Request(hide: hide).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update hide birth year failed (${status.error})');
      return false;
    }

    await _writeHideBirthYearCache(hide);
    if (!isClosed) emit(state.copyWith(hideBirthYear: hide, callsLoadError: false, callsReadOnly: false));
    return true;
  }

  /// Меняет настройку «кто может видеть „О себе“». Как и звонки — серверная
  /// операция, offline недоступна. Возвращает `false`, если не применилось.
  Future<bool> setAboutMeAudience(CallsPrivacyAudience audience) async {
    if (audience == state.aboutMeAudience && !state.callsLoadError && !state.callsReadOnly) return true;

    if (!await utils.hasNetwork()) {
      logger.info('privacy: set about me audience aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_ABOUT_ME_UPDATE,
      PrivacyAboutMeUpdate_Request(aboutMe: _toProto(audience)).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update about me audience failed (${status.error})');
      return false;
    }

    await _writeAboutMeCache(audience);
    if (!isClosed) emit(state.copyWith(aboutMeAudience: audience, callsLoadError: false, callsReadOnly: false));
    return true;
  }

  /// Полностью заменяет allow-list «всегда разрешать» для «О себе».
  Future<bool> setAboutMeAllow(List<Uint8List> userIDs) async {
    if (!await utils.hasNetwork()) {
      logger.info('privacy: set about me allow aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_ABOUT_ME_ALLOW_UPDATE,
      PrivacyAboutMeAllowUpdate_Request(userIds: userIDs).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update about me allow failed (${status.error})');
      return false;
    }

    if (!isClosed) emit(state.copyWith(aboutMeAllow: List<Uint8List>.unmodifiable(userIDs)));
    return true;
  }

  /// Полностью заменяет deny-list «всегда запрещать» для «О себе».
  Future<bool> setAboutMeDeny(List<Uint8List> userIDs) async {
    if (!await utils.hasNetwork()) {
      logger.info('privacy: set about me deny aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_ABOUT_ME_DENY_UPDATE,
      PrivacyAboutMeDenyUpdate_Request(userIds: userIDs).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update about me deny failed (${status.error})');
      return false;
    }

    if (!isClosed) emit(state.copyWith(aboutMeDeny: List<Uint8List>.unmodifiable(userIDs)));
    return true;
  }

  /// Читает закэшированное значение звонков; null — кэша нет или он битый.
  Future<CallsPrivacyAudience?> _readCache() async {
    try {
      final raw = await repositories.cache.getString(userID: Uint8List.fromList(auth.session.userID), key: _callsCacheKey);
      if (raw == null) return null;
      return CallsPrivacyAudience.values.asNameMap()[raw];
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return null;
    }
  }

  Future<void> _writeCache(CallsPrivacyAudience audience) async {
    try {
      await repositories.cache.setString(userID: Uint8List.fromList(auth.session.userID), key: _callsCacheKey, value: audience.name);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Читает закэшированную аудиторию дня рождения; null — кэша нет или он битый.
  Future<CallsPrivacyAudience?> _readBirthdayCache() async {
    try {
      final raw = await repositories.cache.getString(userID: Uint8List.fromList(auth.session.userID), key: _birthdayCacheKey);
      if (raw == null) return null;
      return CallsPrivacyAudience.values.asNameMap()[raw];
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return null;
    }
  }

  Future<void> _writeBirthdayCache(CallsPrivacyAudience audience) async {
    try {
      await repositories.cache.setString(userID: Uint8List.fromList(auth.session.userID), key: _birthdayCacheKey, value: audience.name);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Читает закэшированный флаг «скрыть год»; null — кэша нет или он битый.
  Future<bool?> _readHideBirthYearCache() async {
    try {
      final raw = await repositories.cache.getString(userID: Uint8List.fromList(auth.session.userID), key: _hideBirthYearCacheKey);
      if (raw == null) return null;
      return raw == "1";
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return null;
    }
  }

  Future<void> _writeHideBirthYearCache(bool hide) async {
    try {
      await repositories.cache.setString(
        userID: Uint8List.fromList(auth.session.userID),
        key: _hideBirthYearCacheKey,
        value: hide ? "1" : "0",
      );
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Читает закэшированную аудиторию «О себе»; null — кэша нет или он битый.
  Future<CallsPrivacyAudience?> _readAboutMeCache() async {
    try {
      final raw = await repositories.cache.getString(userID: Uint8List.fromList(auth.session.userID), key: _aboutMeCacheKey);
      if (raw == null) return null;
      return CallsPrivacyAudience.values.asNameMap()[raw];
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return null;
    }
  }

  Future<void> _writeAboutMeCache(CallsPrivacyAudience audience) async {
    try {
      await repositories.cache.setString(userID: Uint8List.fromList(auth.session.userID), key: _aboutMeCacheKey, value: audience.name);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  CallsPrivacyAudience _fromProto(PrivacySettings_Audience audience) {
    switch (audience) {
      case PrivacySettings_Audience.EVERYBODY:
        return CallsPrivacyAudience.everybody;
      case PrivacySettings_Audience.NOBODY:
        return CallsPrivacyAudience.nobody;
      default:
        return CallsPrivacyAudience.contacts;
    }
  }

  PrivacySettings_Audience _toProto(CallsPrivacyAudience audience) {
    switch (audience) {
      case CallsPrivacyAudience.everybody:
        return PrivacySettings_Audience.EVERYBODY;
      case CallsPrivacyAudience.nobody:
        return PrivacySettings_Audience.NOBODY;
      case CallsPrivacyAudience.contacts:
        return PrivacySettings_Audience.CONTACTS;
    }
  }
}
