import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart' show AlertDialog, TextButton, Theme, showDialog;

import '../../api.dart';
import '../../auth.dart';
import '../../chats/chats_mapping.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../protobuf.dart';
import '../../utils.dart';
import '../settings/settings_cloud_password_cupertino.dart';
import '../settings/settings_cloud_password_material.dart';
import '../settings/settings_device_sessions_cupertino.dart';
import '../settings/settings_device_sessions_material.dart';

/// Уведомления системного аккаунта «Iperon» (docs/plans/system-notices.md):
/// кнопки под пузырём — «Устройства» и «Это не я» (завершить сеанс, который
/// это сделал, и предложить облачный пароль). Диалоги — по платформе, как
/// [showNoConnectionAlert].

/// Кнопки под уведомлением [message]; «Это не я» — если известна сессия и это
/// не текущее устройство.
List<(String, VoidCallback)> systemNoticeActions(BuildContext context, models.Message message) {
  final notice = message.systemNotice;
  if (notice == null) return const [];
  final t = context.t.systemNotice;
  final current = idHex(getIt.get<Auth>().session.sessionID);
  final foreign = notice.sessionID.isNotEmpty && notice.sessionID != current;
  return [(t.devices, () => _openDeviceSessions(context)), if (foreign) (t.notMe, () => _notMe(context, notice))];
}

void _openDeviceSessions(BuildContext context) {
  Navigator.of(context).push(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider<SettingsDeviceSessionsCubit>(
        create: (_) => SettingsDeviceSessionsCubit()..initialization(),
        child: Platform.isIOS ? SettingsDeviceSessionsCupertino() : const SettingsDeviceSessionsMaterial(),
      ),
    ),
  );
}

void _openCloudPassword(BuildContext context) {
  Navigator.of(context).push(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider<SettingsCloudPasswordCubit>(
        create: (_) => SettingsCloudPasswordCubit()..initialization(),
        child: Platform.isIOS ? SettingsCloudPasswordCupertino() : const SettingsCloudPasswordMaterial(),
      ),
    ),
  );
}

/// «Это не я»: подтвердить → завершить сеанс (серверная операция: без сети —
/// «Нет соединения», ничего не делаем) → облачный пароль не включён —
/// предложить включить.
Future<void> _notMe(BuildContext context, models.SystemNotice notice) async {
  final t = context.t.systemNotice;
  final confirmed = await _ask(
    context,
    title: t.notMeTitle,
    message: notice.deviceModel.isEmpty ? t.notMeMessageUnknown : t.notMeMessage(device: notice.deviceModel),
    cancel: context.t.common.cancel,
    confirm: t.terminate,
    destructive: true,
  );
  if (!confirmed || !context.mounted) return;
  // Демо-чаты: сеанс выдуманный — на сервер не ходим.
  if (context.read<CommonCubit>().state.settingsDevice.chatsDemo) {
    await _ask(context, title: t.terminatedTitle, cancel: context.t.common.done);
    return;
  }

  if (!await getIt.get<Utils>().hasNetwork()) {
    if (context.mounted) await showNoConnectionAlert(context);
    return;
  }
  final api = getIt.get<API>();
  final status = await api.unaryEncoded(
    MessageType.DEVICE_SESSIONS_TERMINATE,
    DeviceSessionsTerminate_Request(sessionID: [idBytes(notice.sessionID)]).writeToBuffer(),
  );
  if (!context.mounted) return;
  if (status.status != APIStatus.success) {
    await _ask(context, title: t.terminateFailed, cancel: context.t.common.done);
    return;
  }

  // Облачный пароль уже включён — предлагать нечего; не узнали — тоже молчим.
  final (infoStatus, payload) = await api.unaryEncodedWithResponse(
    MessageType.CLOUD_PASSWORD_INFO,
    CloudPasswordInfo_Request().writeToBuffer(),
  );
  if (!context.mounted) return;
  final enabled = infoStatus.status != APIStatus.success || payload == null || CloudPasswordInfo_Response.fromBuffer(payload).isEnabled;
  if (enabled) {
    await _ask(context, title: t.terminatedTitle, cancel: context.t.common.done);
    return;
  }
  final enable = await _ask(
    context,
    title: t.terminatedTitle,
    message: t.terminatedMessage,
    cancel: t.later,
    confirm: t.enableCloudPassword,
  );
  if (enable && context.mounted) _openCloudPassword(context);
}

/// Диалог: [confirm] — `true` по нему; без [confirm] — только [cancel] (ок).
Future<bool> _ask(
  BuildContext context, {
  required String title,
  String? message,
  required String cancel,
  String? confirm,
  bool destructive = false,
}) async {
  final result = Platform.isIOS
      ? await showCupertinoDialog<bool>(
          context: context,
          builder: (dialogContext) => CupertinoAlertDialog(
            title: Text(title),
            content: message == null ? null : Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: confirm == null,
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(cancel),
              ),
              if (confirm != null)
                CupertinoDialogAction(
                  isDestructiveAction: destructive,
                  isDefaultAction: !destructive,
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(confirm),
                ),
            ],
          ),
        )
      : await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(title),
            content: message == null ? null : Text(message),
            actions: [
              TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(cancel)),
              if (confirm != null)
                TextButton(
                  style: destructive ? TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error) : null,
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(confirm),
                ),
            ],
          ),
        );
  return result ?? false;
}
