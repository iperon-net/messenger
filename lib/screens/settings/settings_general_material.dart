import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart' hide ConnectionState;
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../themes.dart';
import '../../cubit.dart';
import '../../desktop.dart';
import '../../i18n/translations.g.dart';
import '../../media_devices.dart';
import '../../models.dart' as models;
import '../../split_layout.dart';

/// «Общие» (только десктоп): клавиша отправки сообщения, микрофон и камера по
/// умолчанию, запуск при входе в систему.
class SettingsGeneralMaterial extends StatelessWidget {
  const SettingsGeneralMaterial({super.key});

  /// Клавиша-модификатор отправки: ⌘ на Mac, Ctrl на Windows / Linux.
  static String get modifierKey => Platform.isMacOS ? '⌘' : 'Ctrl';

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsGeneral;
    final check = Icon(Icons.check, size: 22, color: Theme.of(context).colorScheme.primary);
    final modifier = context.select<CommonCubit, bool>((cubit) => cubit.state.settingsDevice.sendWithModifierEnter);

    Widget option(String title, bool value) => ListTile(
      title: Text(title),
      trailing: modifier == value ? check : null,
      onTap: () => context.read<CommonCubit>().setSendWithModifierEnter(value),
    );

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: !context.isSplitPaneRoot, title: Text(t.general)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: ListView(
          children: [
            _header(context, t.sendMessage),
            Card(
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Column(children: [option('Enter', false), option('$modifierKey + Enter', true)]),
            ),
            _hint(context, modifier ? t.newLineEnter : t.newLineShiftEnter),
            const _MicrophoneSection(),
            const _CameraSection(),
            const Card(margin: EdgeInsets.fromLTRB(12, 16, 12, 16), child: _LaunchAtLoginTile()),
          ],
        ),
      ),
    );
  }
}

Widget _header(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
  child: Text(
    text.toUpperCase(),
    style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.primary),
  ),
);

Widget _hint(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
  child: Text(
    text,
    style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
  ),
);

/// Список устройств с галочкой: «Как в системе» + подключённые. [selected] —
/// индекс в [names] или `null` (как в системе).
Widget _deviceList(BuildContext context, {required List<String> names, required int? selected, required void Function(int?) onSelect}) {
  final t = context.t.screenSettingsGeneral;
  final check = Icon(Icons.check, size: 22, color: Theme.of(context).colorScheme.primary);
  return Card(
    margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
    child: Column(
      children: [
        ListTile(title: Text(t.systemDefault), trailing: selected == null ? check : null, onTap: () => onSelect(null)),
        for (var i = 0; i < names.length; i++)
          ListTile(
            title: Text(names[i], maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: selected == i ? check : null,
            onTap: () => onSelect(i),
          ),
      ],
    ),
  );
}

/// Нет доступа к камере / микрофону: строка-кнопка в системные настройки
/// (после отказа включить можно только там) или к системному вопросу.
class _AccessTile extends StatelessWidget {
  final MediaKind kind;
  final MediaAccess access;
  final VoidCallback onRequested;

  const _AccessTile({required this.kind, required this.access, required this.onRequested});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsGeneral;
    return ListTile(
      leading: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.error),
      title: Text(kind == MediaKind.camera ? t.cameraNoAccess : t.microphoneNoAccess),
      trailing: Text(
        access == MediaAccess.notDetermined ? t.allow : t.openSettings,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      onTap: () async {
        if (access == MediaAccess.notDetermined) {
          await Desktop.requestMediaAccess(kind);
        } else {
          await Desktop.openPrivacySettings(kind);
        }
        onRequested();
      },
    );
  }
}

/// «Микрофон»: выбор устройства для голосовых (и звонков) и проверка уровня —
/// пробная запись тем же `record`, что и голосовые, файл сразу удаляется.
class _MicrophoneSection extends StatefulWidget {
  const _MicrophoneSection();

  @override
  State<_MicrophoneSection> createState() => _MicrophoneSectionState();
}

class _MicrophoneSectionState extends State<_MicrophoneSection> with WidgetsBindingObserver {
  final _recorder = AudioRecorder();
  List<InputDevice> _devices = const [];
  MediaAccess? _access;
  StreamSubscription<void>? _changes;
  StreamSubscription<Amplitude>? _amplitude;
  String? _testPath;
  double? _level;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _changes = MediaDevices.changes.listen((_) => unawaited(_load()));
    unawaited(_load());
  }

  // Вернулись из системных настроек — доступ мог появиться.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_load());
  }

  Future<void> _load() async {
    final access = await Desktop.mediaAccess(MediaKind.microphone);
    List<InputDevice> devices = const [];
    try {
      devices = await MediaDevices.microphones(_recorder);
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _access = access;
      _devices = devices;
    });
  }

  Future<void> _select(int? index) async {
    final device = index == null ? null : _devices[index];
    await context.read<CommonCubit>().setMicrophone(id: device?.id ?? '', name: device?.label ?? '');
    // Проверка идёт — перезапускаем на новом устройстве.
    if (_level != null) {
      await _stopTest();
      await _startTest();
    }
  }

  Future<void> _startTest() async {
    final settings = context.read<CommonCubit>().state.settingsDevice;
    final path = p.join((await getTemporaryDirectory()).path, 'mic_test_${DateTime.now().microsecondsSinceEpoch}.m4a');
    try {
      await _recorder.start(RecordConfig(numChannels: 1, device: MediaDevices.microphone(_devices, settings)), path: path);
    } catch (_) {
      return;
    }
    _testPath = path;
    _amplitude = _recorder.onAmplitudeChanged(const Duration(milliseconds: 80)).listen((amplitude) {
      // dBFS: тишина около −50 и ниже, громкая речь — к 0.
      if (mounted) setState(() => _level = ((amplitude.current + 50) / 50).clamp(0.0, 1.0));
    });
    if (mounted) setState(() => _level = 0);
  }

  Future<void> _stopTest() async {
    await _amplitude?.cancel();
    _amplitude = null;
    try {
      await _recorder.stop();
    } catch (_) {}
    final path = _testPath;
    _testPath = null;
    if (path != null) unawaited(File(path).delete().then((_) {}, onError: (_) {}));
    if (mounted) setState(() => _level = null);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _changes?.cancel();
    unawaited(_stopTest().whenComplete(_recorder.dispose));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsGeneral;
    final settings = context.select<CommonCubit, models.SettingsDeviceModel>((cubit) => cubit.state.settingsDevice);
    final selected = MediaDevices.microphone(_devices, settings);
    final access = _access;
    final level = _level;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context, t.microphone),
        if (access != null && access != MediaAccess.granted)
          Card(
            margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: _AccessTile(kind: MediaKind.microphone, access: access, onRequested: _load),
          )
        else ...[
          _deviceList(
            context,
            names: [for (final device in _devices) device.label],
            selected: selected == null ? null : _devices.indexOf(selected),
            onSelect: _select,
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Column(
              children: [
                ListTile(
                  title: Text(level == null ? t.testMicrophone : t.stopTest),
                  textColor: Theme.of(context).colorScheme.primary,
                  onTap: level == null ? _startTest : _stopTest,
                ),
                if (level != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: level, minHeight: 8),
                    ),
                  ),
              ],
            ),
          ),
        ],
        _hint(context, t.microphoneHint),
      ],
    );
  }
}

/// «Камера»: выбор устройства (для видеозвонков) и превью — камера включается
/// только по кнопке и гаснет при уходе с экрана.
class _CameraSection extends StatefulWidget {
  const _CameraSection();

  @override
  State<_CameraSection> createState() => _CameraSectionState();
}

class _CameraSectionState extends State<_CameraSection> with WidgetsBindingObserver {
  List<MediaDevice> _devices = const [];
  MediaAccess? _access;
  StreamSubscription<void>? _changes;
  LocalVideoTrack? _preview;
  bool _previewOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _changes = MediaDevices.changes.listen((_) => unawaited(_load()));
    unawaited(_load());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_load());
  }

  Future<void> _load() async {
    final access = await Desktop.mediaAccess(MediaKind.camera);
    List<MediaDevice> devices = const [];
    try {
      devices = await MediaDevices.cameras();
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _access = access;
      _devices = devices;
    });
  }

  Future<void> _select(int? index) async {
    final device = index == null ? null : _devices[index];
    await context.read<CommonCubit>().setCamera(id: device?.deviceId ?? '', name: device?.label ?? '');
    if (_previewOn) {
      await _stopPreview();
      await _startPreview();
    }
  }

  Future<void> _startPreview() async {
    final settings = context.read<CommonCubit>().state.settingsDevice;
    setState(() => _previewOn = true);
    try {
      final track = await LocalVideoTrack.createCameraTrack(
        CameraCaptureOptions(deviceId: MediaDevices.camera(_devices, settings)?.deviceId),
      );
      if (!mounted || !_previewOn) {
        await track.stop();
        return;
      }
      setState(() => _preview = track);
    } catch (_) {
      if (mounted) setState(() => _previewOn = false);
    }
  }

  // Сначала убираем рендерер из дерева, потом гасим трек: новый трек — новый
  // рендерер (пересоздание на живом треке роняло flutter_webrtc).
  Future<void> _stopPreview() async {
    final track = _preview;
    if (mounted) {
      setState(() {
        _preview = null;
        _previewOn = false;
      });
    }
    await track?.stop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _changes?.cancel();
    final track = _preview;
    _preview = null;
    unawaited(track?.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsGeneral;
    final settings = context.select<CommonCubit, models.SettingsDeviceModel>((cubit) => cubit.state.settingsDevice);
    final selected = MediaDevices.camera(_devices, settings);
    final access = _access;
    final preview = _preview;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context, t.camera),
        if (access != null && access != MediaAccess.granted)
          Card(
            margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: _AccessTile(kind: MediaKind.camera, access: access, onRequested: _load),
          )
        else ...[
          _deviceList(
            context,
            names: [for (final device in _devices) device.label],
            selected: selected == null ? null : _devices.indexOf(selected),
            onSelect: _select,
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  title: Text(_previewOn ? t.hidePreview : t.showPreview),
                  textColor: Theme.of(context).colorScheme.primary,
                  onTap: _previewOn ? _stopPreview : _startPreview,
                ),
                if (_previewOn)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ColoredBox(
                      color: Colors.black,
                      child: preview == null
                          ? const Center(child: CircularProgressIndicator())
                          : VideoTrackRenderer(preview, fit: VideoViewFit.cover),
                    ),
                  ),
              ],
            ),
          ),
        ],
        _hint(context, t.cameraHint),
      ],
    );
  }
}

/// «Запускать при входе в систему» ([Desktop.setLaunchAtLogin]).
class _LaunchAtLoginTile extends StatefulWidget {
  const _LaunchAtLoginTile();

  @override
  State<_LaunchAtLoginTile> createState() => _LaunchAtLoginTileState();
}

class _LaunchAtLoginTileState extends State<_LaunchAtLoginTile> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    Desktop.launchAtLogin().then((enabled) {
      if (mounted) setState(() => _enabled = enabled);
    });
  }

  Future<void> _set(bool value) async {
    try {
      final status = await Desktop.setLaunchAtLogin(value);
      if (!mounted) return;
      setState(() => _enabled = status == 'enabled');
      if (status == 'requiresApproval') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t.screenSettings.launchAtLoginApproval)));
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.t.screenSettings.launchAtLoginFailed(error: error is PlatformException ? error.message ?? error.code : error),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => SwitchListTile(
    title: Text(context.t.screenSettings.launchAtLogin),
    value: _enabled ?? false,
    onChanged: _enabled == null ? null : _set,
  );
}
