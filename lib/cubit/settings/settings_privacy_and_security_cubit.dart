import 'dart:async';
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

  StreamSubscription<Uint8List>? _subscription;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    final isBiometricAvailable = await utils.isBiometricAvailable();
    if (isClosed) return;
    emit(state.copyWith(status: Status.success, isBiometricAvailable: isBiometricAvailable));

    // 1. Мгновенно поднимаем последнее известное значение из локальной БД —
    // видно и offline (см. offline-раздел CLAUDE.md / CLAUDE.local.md).
    await _loadFromCache();
    if (isClosed) return;

    // 2. Подписываемся ДО отправки запроса, чтобы не пропустить быстрый ответ.
    // Через эту же подписку приходит серверный push при смене на другом
    // устройстве. Запись в БД — централизованно в API._handleMessage.
    _subscription = api.on(MessageType.PRIVACY_SETTINGS).listen((payload) {
      if (isClosed) return;
      _applyResponse(PrivacySettings_Response.fromBuffer(payload));
    });

    // 3. Запрашиваем свежие настройки через стрим.
    await _refresh();
  }

  /// Перезапрашивает серверные настройки приватности через стрим. Вызывается
  /// родительским экраном «Конфиденциальность» после возврата с детейл-экранов
  /// (у них свой инстанс cubit), чтобы label'ы не остались устаревшими; ответ
  /// (один PRIVACY_SETTINGS несёт все каналы) прилетит в подписку [_subscription].
  /// Offline: оставляем значение из кэша, но помечаем read-only (менять нельзя —
  /// гейт серверный), а если кэша нет — [callsLoadError] с повтором.
  Future<void> _refresh() async {
    if (!await utils.hasNetwork()) {
      if (isClosed) return;
      // Нет сети: показываем кэш read-only; если кэша не было — нечего показать.
      emit(state.copyWith(callsReadOnly: !state.callsLoadError));
      return;
    }
    // Ответ придёт в подписку и будет записан в БД в API._handleMessage.
    await api.sendEncoded(MessageType.PRIVACY_SETTINGS, PrivacySettings_Request().writeToBuffer());
  }

  Future<void> reloadCalls() => _refresh();

  /// Алиас [reloadCalls] для читаемости на экране дня рождения (тот же ответ).
  Future<void> reloadBirthday() => _refresh();

  /// Алиас [reloadCalls] для читаемости на экране «О себе» (тот же ответ).
  Future<void> reloadAboutMe() => _refresh();

  /// Алиас [reloadCalls] для читаемости на экране «Последнее посещение».
  Future<void> reloadLastSeen() => _refresh();

  /// Поднимает последнее известное значение из локальной БД. Кэша нет
  /// ([callsLoadError] останется, пока не придёт ответ сервера) — первый запуск.
  Future<void> _loadFromCache() async {
    try {
      final buffer = await repositories.privacySettings.get(userID: auth.session.userID);
      if (isClosed) return;
      if (buffer == null) {
        // Кэша ещё нет — нечего показывать, ждём ответ сервера / повтор offline.
        emit(state.copyWith(callsLoadError: true));
        return;
      }
      _applyResponse(PrivacySettings_Response.fromBuffer(buffer));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Раскладывает ответ сервера в состояние и снимает блокировки. Общий путь для
  /// чтения из кэша и для входящих сообщений подписки.
  void _applyResponse(PrivacySettings_Response response) {
    if (isClosed) return;
    emit(
      state.copyWith(
        callsAudience: _fromProto(response.calls),
        callsAllow: response.callsAllow.map(Uint8List.fromList).toList(growable: false),
        callsDeny: response.callsDeny.map(Uint8List.fromList).toList(growable: false),
        birthdayAudience: _fromProto(response.birthday),
        birthdayAllow: response.birthdayAllow.map(Uint8List.fromList).toList(growable: false),
        birthdayDeny: response.birthdayDeny.map(Uint8List.fromList).toList(growable: false),
        hideBirthYear: response.hideBirthYear,
        aboutMeAudience: _fromProto(response.aboutMe),
        aboutMeAllow: response.aboutMeAllow.map(Uint8List.fromList).toList(growable: false),
        aboutMeDeny: response.aboutMeDeny.map(Uint8List.fromList).toList(growable: false),
        lastSeenAudience: _fromProto(response.lastSeen),
        lastSeenAllow: response.lastSeenAllow.map(Uint8List.fromList).toList(growable: false),
        lastSeenDeny: response.lastSeenDeny.map(Uint8List.fromList).toList(growable: false),
        callsLoadError: false,
        callsReadOnly: false,
      ),
    );
  }

  /// Пересобирает `PrivacySettings_Response` из текущего состояния и сохраняет его
  /// в БД. Вызывается после успешной серверной записи (set*), чтобы локальный кэш
  /// сразу совпадал с UI, не дожидаясь серверного push/следующего [_refresh].
  Future<void> _persistFromState() async {
    try {
      final response = PrivacySettings_Response(
        calls: _toProto(state.callsAudience),
        callsAllow: state.callsAllow,
        callsDeny: state.callsDeny,
        birthday: _toProto(state.birthdayAudience),
        birthdayAllow: state.birthdayAllow,
        birthdayDeny: state.birthdayDeny,
        hideBirthYear: state.hideBirthYear,
        aboutMe: _toProto(state.aboutMeAudience),
        aboutMeAllow: state.aboutMeAllow,
        aboutMeDeny: state.aboutMeDeny,
        lastSeen: _toProto(state.lastSeenAudience),
        lastSeenAllow: state.lastSeenAllow,
        lastSeenDeny: state.lastSeenDeny,
      );
      await repositories.privacySettings.upsert(userID: auth.session.userID, payload: response.writeToBuffer());
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
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

    // Успех подтверждает и связь, и новое значение — фиксируем, снимаем блокировки, кэшируем.
    if (!isClosed) emit(state.copyWith(callsAudience: audience, callsLoadError: false, callsReadOnly: false));
    await _persistFromState();
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
    await _persistFromState();
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
    await _persistFromState();
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

    if (!isClosed) emit(state.copyWith(birthdayAudience: audience, callsLoadError: false, callsReadOnly: false));
    await _persistFromState();
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
    await _persistFromState();
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
    await _persistFromState();
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

    if (!isClosed) emit(state.copyWith(hideBirthYear: hide, callsLoadError: false, callsReadOnly: false));
    await _persistFromState();
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

    if (!isClosed) emit(state.copyWith(aboutMeAudience: audience, callsLoadError: false, callsReadOnly: false));
    await _persistFromState();
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
    await _persistFromState();
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
    await _persistFromState();
    return true;
  }

  /// Меняет настройку «кто может видеть последнее посещение». Серверная операция,
  /// offline недоступна. Возвращает `false`, если не применилось.
  Future<bool> setLastSeenAudience(CallsPrivacyAudience audience) async {
    if (audience == state.lastSeenAudience && !state.callsLoadError && !state.callsReadOnly) return true;

    if (!await utils.hasNetwork()) {
      logger.info('privacy: set last seen audience aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_LAST_SEEN_UPDATE,
      PrivacyLastSeenUpdate_Request(lastSeen: _toProto(audience)).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update last seen audience failed (${status.error})');
      return false;
    }

    if (!isClosed) emit(state.copyWith(lastSeenAudience: audience, callsLoadError: false, callsReadOnly: false));
    await _persistFromState();
    return true;
  }

  /// Полностью заменяет allow-list «всегда разрешать» для последнего посещения.
  Future<bool> setLastSeenAllow(List<Uint8List> userIDs) async {
    if (!await utils.hasNetwork()) {
      logger.info('privacy: set last seen allow aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_LAST_SEEN_ALLOW_UPDATE,
      PrivacyLastSeenAllowUpdate_Request(userIds: userIDs).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update last seen allow failed (${status.error})');
      return false;
    }

    if (!isClosed) emit(state.copyWith(lastSeenAllow: List<Uint8List>.unmodifiable(userIDs)));
    await _persistFromState();
    return true;
  }

  /// Полностью заменяет deny-list «всегда запрещать» для последнего посещения.
  Future<bool> setLastSeenDeny(List<Uint8List> userIDs) async {
    if (!await utils.hasNetwork()) {
      logger.info('privacy: set last seen deny aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_LAST_SEEN_DENY_UPDATE,
      PrivacyLastSeenDenyUpdate_Request(userIds: userIDs).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update last seen deny failed (${status.error})');
      return false;
    }

    if (!isClosed) emit(state.copyWith(lastSeenDeny: List<Uint8List>.unmodifiable(userIDs)));
    await _persistFromState();
    return true;
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

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
