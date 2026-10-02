import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf.dart' as pb;
import '../../repositories/repositories.dart';
import '../../utils.dart';
import 'settings_notifications_state.dart';

/// «Уведомления и звуки». Настройки общие для всех устройств и применяются на
/// сервере (воркер push-очереди), поэтому паттерн — как у приватности: снимок в
/// SQLite (видно offline), подписка на NOTIFY_SETTINGS (ответ на запрос и push
/// при смене на другом устройстве), запись — серверный unary с гардом сети, без
/// оптимистичного отката.
class SettingsNotificationsCubit extends Cubit<SettingsNotificationsState> {
  SettingsNotificationsCubit() : super(const SettingsNotificationsState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();

  StreamSubscription<Uint8List>? _subscription;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    await checkPermission();
    if (isClosed) return;

    await _loadFromCache();
    if (isClosed) return;
    emit(state.copyWith(status: Status.success));

    // Подписываемся до запроса, чтобы не пропустить быстрый ответ. Запись в БД —
    // централизованно в API._handleMessage.
    _subscription = api.on(pb.MessageType.NOTIFY_SETTINGS).listen((payload) {
      if (isClosed) return;
      _applyResponse(pb.NotifySettings_Response.fromBuffer(payload));
    });

    await reload();
  }

  /// Перезапрашивает настройки через стрим; ответ придёт в подписку. Offline —
  /// оставляем кэш, но только для чтения.
  Future<void> reload() async {
    if (!await utils.hasNetwork()) {
      if (isClosed) return;
      emit(state.copyWith(readOnly: !state.loadError));
      return;
    }
    await api.sendEncoded(pb.MessageType.NOTIFY_SETTINGS, pb.NotifySettings_Request().writeToBuffer());
  }

  Future<void> _loadFromCache() async {
    try {
      final buffer = await repositories.notifySettings.get(userID: auth.session.userID);
      if (isClosed) return;
      if (buffer == null) {
        emit(state.copyWith(loadError: true));
        return;
      }
      _applyResponse(pb.NotifySettings_Response.fromBuffer(buffer));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  void _applyResponse(pb.NotifySettings_Response response) {
    if (isClosed) return;
    emit(
      state.copyWith(
        privateChats: _scopeFromProto(response.privateChats),
        groups: _scopeFromProto(response.groups),
        channels: _scopeFromProto(response.channels),
        contactJoined: response.contactJoined,
        missedCalls: response.missedCalls,
        loadError: false,
        readOnly: false,
      ),
    );
  }

  /// Сохраняет текущее состояние в кэш после успешной серверной записи, чтобы
  /// он сразу совпадал с UI, не дожидаясь push.
  Future<void> _persistFromState() async {
    try {
      final response = pb.NotifySettings_Response(
        privateChats: _scopeToProto(state.privateChats),
        groups: _scopeToProto(state.groups),
        channels: _scopeToProto(state.channels),
        contactJoined: state.contactJoined,
        missedCalls: state.missedCalls,
      );
      await repositories.notifySettings.upsert(userID: auth.session.userID, payload: response.writeToBuffer());
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Меняет настройку типа чатов. `false` — не применилось (offline/ошибка).
  Future<bool> setScope(NotifyScope scope, NotifyScopeSettings settings) async {
    final ok = await _update(
      pb.NotifySettingsUpdate_Request(
        scope: pb.NotifySettingsUpdate_ScopeChange(scope: _scopeKindToProto(scope), settings: _scopeToProto(settings)),
      ),
      'scope ${scope.name}',
    );
    if (!ok) return false;
    if (!isClosed) {
      emit(switch (scope) {
        NotifyScope.privateChats => state.copyWith(privateChats: settings),
        NotifyScope.groups => state.copyWith(groups: settings),
        NotifyScope.channels => state.copyWith(channels: settings),
      });
    }
    await _persistFromState();
    return true;
  }

  /// «Новые контакты». `false` — не применилось (offline/ошибка).
  Future<bool> setContactJoined(bool enabled) async {
    final ok = await _update(pb.NotifySettingsUpdate_Request(contactJoined: enabled), 'contact joined');
    if (!ok) return false;
    if (!isClosed) emit(state.copyWith(contactJoined: enabled));
    await _persistFromState();
    return true;
  }

  /// «Пропущенные звонки». `false` — не применилось (offline/ошибка).
  Future<bool> setMissedCalls(bool enabled) async {
    final ok = await _update(pb.NotifySettingsUpdate_Request(missedCalls: enabled), 'missed calls');
    if (!ok) return false;
    if (!isClosed) emit(state.copyWith(missedCalls: enabled));
    await _persistFromState();
    return true;
  }

  Future<bool> _update(pb.NotifySettingsUpdate_Request request, String what) async {
    if (!await utils.hasNetwork()) {
      logger.info('notify settings: set $what aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(pb.MessageType.NOTIFY_SETTINGS_UPDATE, request.writeToBuffer());
    if (status.status != APIStatus.success) {
      logger.warning('notify settings: set $what failed (${status.error})');
      return false;
    }

    if (!isClosed) emit(state.copyWith(loadError: false, readOnly: false));
    return true;
  }

  /// Статус системного разрешения без диалога (для предупреждения на экране).
  Future<void> checkPermission() async {
    try {
      final status = await Permission.notification.status;
      if (isClosed) return;
      emit(state.copyWith(permissionMissing: !status.isGranted && !status.isProvisional));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// «Включить»: системный запрос, а если система диалог уже не покажет —
  /// системные настройки приложения.
  Future<void> requestPermission() async {
    try {
      final status = await Permission.notification.status;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        await Permission.notification.request();
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    await checkPermission();
  }

  static NotifyScopeSettings _scopeFromProto(pb.NotifySettings_ScopeSettings settings) =>
      NotifyScopeSettings(enabled: settings.enabled, showPreviews: settings.showPreviews, sound: settings.sound);

  static pb.NotifySettings_ScopeSettings _scopeToProto(NotifyScopeSettings settings) =>
      pb.NotifySettings_ScopeSettings(enabled: settings.enabled, showPreviews: settings.showPreviews, sound: settings.sound);

  static pb.NotifySettings_Scope _scopeKindToProto(NotifyScope scope) => switch (scope) {
    NotifyScope.privateChats => pb.NotifySettings_Scope.PRIVATE,
    NotifyScope.groups => pb.NotifySettings_Scope.GROUPS,
    NotifyScope.channels => pb.NotifySettings_Scope.CHANNELS,
  };

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
