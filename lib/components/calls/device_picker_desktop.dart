import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';

import '../../cubit.dart';
import '../../media_devices.dart';
import '../actions_sheet_material.dart';

/// Десктоп, экран звонка: выбор динамика и камеры меню у курсора (как все
/// меню на десктопе). Выбор применяют к комнате на лету ([CallCubit]) и
/// сохраняют в «Общие → Звонки» ([CommonCubit]) — подхватят настройки и
/// следующий звонок; на входящем (комната ещё не подключена) — подключение.

/// Меню выбора динамика из подключённых (в «Звонках» выбранное отмечено).
/// Пустой список — меню не открываем.
Future<void> showSpeakerPicker(BuildContext context) async {
  final common = context.read<CommonCubit>();
  final call = context.read<CallCubit>();
  final speakerId = common.state.settingsDevice.speakerId;
  final speakers = await MediaDevices.speakers();
  if (speakers.isEmpty || !context.mounted) return;
  final selected = await showActionsMaterial<String>(
    context: context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final speaker in speakers)
          ListTile(
            leading: HugeIcon(icon: HugeIcons.strokeRoundedSpeaker, size: 20, color: Theme.of(sheetContext).iconTheme.color),
            title: Text(speaker.name),
            trailing: speaker.id == speakerId
                ? HugeIcon(icon: HugeIcons.strokeRoundedTick02, size: 18, color: Theme.of(sheetContext).colorScheme.primary)
                : null,
            onTap: () => Navigator.of(sheetContext).pop(speaker.id),
          ),
      ],
    ),
  );
  if (selected == null) return;
  final speaker = speakers.firstWhere((item) => item.id == selected);
  await call.applyAudioOutput(speaker.id);
  await common.setSpeaker(id: speaker.id, name: speaker.name);
}

/// Меню выбора камеры из подключённых; отмечена выбранная в «Звонках».
Future<void> showCameraPicker(BuildContext context) async {
  final common = context.read<CommonCubit>();
  final call = context.read<CallCubit>();
  final cameraId = common.state.settingsDevice.cameraId;
  final cameras = await MediaDevices.cameras();
  if (cameras.isEmpty || !context.mounted) return;
  final selected = await showActionsMaterial<String>(
    context: context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final camera in cameras)
          ListTile(
            leading: HugeIcon(icon: HugeIcons.strokeRoundedVideo01, size: 20, color: Theme.of(sheetContext).iconTheme.color),
            title: Text(camera.label),
            trailing: camera.deviceId == cameraId
                ? HugeIcon(icon: HugeIcons.strokeRoundedTick02, size: 18, color: Theme.of(sheetContext).colorScheme.primary)
                : null,
            onTap: () => Navigator.of(sheetContext).pop(camera.deviceId),
          ),
      ],
    ),
  );
  if (selected == null) return;
  final camera = cameras.firstWhere((item) => item.deviceId == selected);
  await call.applyCamera(camera.deviceId);
  await common.setCamera(id: camera.deviceId, name: camera.label);
}
