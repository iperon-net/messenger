import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart' hide ConnectionState;
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../cubit.dart';
import '../../desktop.dart';
import '../../i18n/translations.g.dart';
import '../../media_devices.dart';
import '../../models.dart' as models;
import '../../themes.dart';

/// «Общие → Звонки» (только десктоп): микрофон и камера по умолчанию. Пока
/// экран открыт, сразу видно, что устройства работают: шкала громкости
/// микрофона и превью камеры. Окно свернули — устройства отпускаем (гаснет
/// индикатор камеры), вернули — снова включаем.
class SettingsCallsMaterial extends StatelessWidget {
  const SettingsCallsMaterial({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.t.screenSettingsGeneral.calls)),
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
    body: const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_MicrophoneSection(), _SpeakerSection(), _CameraSection()],
        ),
      ),
    ),
  );
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
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: ListTile(
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
      ),
    );
  }
}

/// Общее у секций: список устройств, доступ, подключение на ходу, пауза при
/// свёрнутом окне. [start] / [stop] — включить / отпустить устройство.
abstract class _DeviceSectionState<W extends StatefulWidget, D> extends State<W> with WidgetsBindingObserver {
  MediaKind get kind;
  List<D> devices = const [];
  MediaAccess? access;
  StreamSubscription<void>? _changes;
  bool _visible = true;

  Future<List<D>> list();
  Future<void> start();
  Future<void> stop();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _changes = MediaDevices.changes.listen((_) => unawaited(load()));
    unawaited(load(ask: true));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Окно свернули / спрятали — отпускаем устройство; вернули — включаем
    // (заодно доступ: его могли дать в системных настройках).
    if (state == AppLifecycleState.hidden || state == AppLifecycleState.paused) {
      _visible = false;
      unawaited(stop());
    } else if (state == AppLifecycleState.resumed && !_visible) {
      _visible = true;
      unawaited(load());
    }
  }

  /// Перечитать доступ и устройства и (пере)запустить проверку. [ask] — при
  /// открытии экрана: системного вопроса ещё не было — задаём сразу (экран ради
  /// этих устройств и открыли).
  Future<void> load({bool ask = false}) async {
    var current = await Desktop.mediaAccess(kind);
    if (ask && current == MediaAccess.notDetermined) {
      current = await Desktop.requestMediaAccess(kind) ? MediaAccess.granted : MediaAccess.denied;
    }
    List<D> found = const [];
    try {
      found = await list();
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      access = current;
      devices = found;
    });
    await stop();
    if (current == MediaAccess.granted && _visible && mounted) await start();
  }

  /// Выбор сохранён — перезапускаем проверку на новом устройстве.
  Future<void> restart() async {
    await stop();
    if (access == MediaAccess.granted && _visible && mounted) await start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _changes?.cancel();
    super.dispose();
  }
}

/// «Микрофон»: выбор устройства для голосовых и звонков и шкала громкости —
/// пробная запись тем же `record`, что и голосовые (файл удаляется).
class _MicrophoneSection extends StatefulWidget {
  const _MicrophoneSection();

  @override
  State<_MicrophoneSection> createState() => _MicrophoneSectionState();
}

class _MicrophoneSectionState extends _DeviceSectionState<_MicrophoneSection, InputDevice> {
  final _recorder = AudioRecorder();
  StreamSubscription<Amplitude>? _amplitude;
  String? _testPath;
  double _level = 0;

  @override
  MediaKind get kind => MediaKind.microphone;

  @override
  Future<List<InputDevice>> list() => MediaDevices.microphones(_recorder);

  @override
  Future<void> start() async {
    final settings = context.read<CommonCubit>().state.settingsDevice;
    final path = p.join((await getTemporaryDirectory()).path, 'mic_test_${DateTime.now().microsecondsSinceEpoch}.m4a');
    try {
      await _recorder.start(RecordConfig(numChannels: 1, device: MediaDevices.microphone(devices, settings)), path: path);
    } catch (_) {
      return;
    }
    _testPath = path;
    _amplitude = _recorder.onAmplitudeChanged(const Duration(milliseconds: 80)).listen((amplitude) {
      // dBFS: тишина около −50 и ниже, громкая речь — к 0.
      if (mounted) setState(() => _level = ((amplitude.current + 50) / 50).clamp(0.0, 1.0));
    });
  }

  @override
  Future<void> stop() async {
    await _amplitude?.cancel();
    _amplitude = null;
    final path = _testPath;
    _testPath = null;
    if (path == null) return;
    try {
      await _recorder.stop();
    } catch (_) {}
    unawaited(File(path).delete().then((_) {}, onError: (_) {}));
    if (mounted) setState(() => _level = 0);
  }

  Future<void> _select(int? index) async {
    final device = index == null ? null : devices[index];
    await context.read<CommonCubit>().setMicrophone(id: device?.id ?? '', name: device?.label ?? '');
    await restart();
  }

  @override
  void dispose() {
    unawaited(stop().whenComplete(_recorder.dispose));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsGeneral;
    final settings = context.select<CommonCubit, models.SettingsDeviceModel>((cubit) => cubit.state.settingsDevice);
    final selected = MediaDevices.microphone(devices, settings);
    final access = this.access;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context, t.microphone),
        if (access != null && access != MediaAccess.granted)
          _AccessTile(kind: kind, access: access, onRequested: load)
        else ...[
          Card(
            margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.mic_none, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: _level, minHeight: 8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _deviceList(
            context,
            names: [for (final device in devices) device.label],
            selected: selected == null ? null : devices.indexOf(selected),
            onSelect: _select,
          ),
        ],
        _hint(context, t.microphoneHint),
      ],
    );
  }
}

/// «Динамик»: куда выводить звук звонка, и проверка — короткий звук через
/// выбранное устройство (нативно: `audioplayers` устройство выбрать не умеет).
class _SpeakerSection extends StatefulWidget {
  const _SpeakerSection();

  @override
  State<_SpeakerSection> createState() => _SpeakerSectionState();
}

class _SpeakerSectionState extends State<_SpeakerSection> {
  List<({String id, String name})> _devices = const [];
  StreamSubscription<void>? _changes;
  String? _testPath;

  @override
  void initState() {
    super.initState();
    _changes = MediaDevices.changes.listen((_) => unawaited(_load()));
    unawaited(_load());
  }

  Future<void> _load() async {
    final devices = await MediaDevices.speakers();
    if (mounted) setState(() => _devices = devices);
  }

  Future<void> _select(int? index) async {
    final device = index == null ? null : _devices[index];
    await context.read<CommonCubit>().setSpeaker(id: device?.id ?? '', name: device?.name ?? '');
    await _test();
  }

  Future<void> _test() async {
    final settings = context.read<CommonCubit>().state.settingsDevice;
    var path = _testPath;
    if (path == null) {
      final data = await rootBundle.load('assets/audio/ringtone.wav');
      final file = File(p.join((await getTemporaryDirectory()).path, 'speaker_test.wav'));
      await file.writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      path = _testPath = file.path;
    }
    await Desktop.playTestSound(path, device: MediaDevices.speaker(_devices, settings)?.id ?? '');
  }

  @override
  void dispose() {
    _changes?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsGeneral;
    final settings = context.select<CommonCubit, models.SettingsDeviceModel>((cubit) => cubit.state.settingsDevice);
    final selected = MediaDevices.speaker(_devices, settings);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context, t.speaker),
        _deviceList(
          context,
          names: [for (final device in _devices) device.name],
          selected: selected == null ? null : _devices.indexOf(selected),
          onSelect: _select,
        ),
        Card(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: ListTile(
            leading: Icon(Icons.volume_up_outlined, color: Theme.of(context).colorScheme.primary),
            title: Text(t.testSpeaker),
            textColor: Theme.of(context).colorScheme.primary,
            onTap: _test,
          ),
        ),
        _hint(context, t.speakerHint),
      ],
    );
  }
}

/// «Камера»: выбор устройства для видеозвонков и превью.
class _CameraSection extends StatefulWidget {
  const _CameraSection();

  @override
  State<_CameraSection> createState() => _CameraSectionState();
}

class _CameraSectionState extends _DeviceSectionState<_CameraSection, MediaDevice> {
  LocalVideoTrack? _preview;
  bool _starting = false;

  @override
  MediaKind get kind => MediaKind.camera;

  @override
  Future<List<MediaDevice>> list() => MediaDevices.cameras();

  @override
  Future<void> start() async {
    if (devices.isEmpty || _starting) return;
    _starting = true;
    final settings = context.read<CommonCubit>().state.settingsDevice;
    try {
      final track = await LocalVideoTrack.createCameraTrack(
        CameraCaptureOptions(deviceId: MediaDevices.camera(devices, settings)?.deviceId),
      );
      if (!mounted) {
        await track.stop();
        return;
      }
      setState(() => _preview = track);
    } catch (_) {
    } finally {
      _starting = false;
    }
  }

  // Сначала убираем рендерер из дерева, потом гасим трек: новый трек — новый
  // рендерер (пересоздание рендерера на живом треке роняло flutter_webrtc).
  @override
  Future<void> stop() async {
    final track = _preview;
    if (track == null) return;
    if (mounted) setState(() => _preview = null);
    await track.stop();
  }

  Future<void> _select(int? index) async {
    final device = index == null ? null : devices[index];
    await context.read<CommonCubit>().setCamera(id: device?.deviceId ?? '', name: device?.label ?? '');
    await restart();
  }

  @override
  void dispose() {
    final track = _preview;
    _preview = null;
    unawaited(track?.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsGeneral;
    final settings = context.select<CommonCubit, models.SettingsDeviceModel>((cubit) => cubit.state.settingsDevice);
    final selected = MediaDevices.camera(devices, settings);
    final access = this.access;
    final preview = _preview;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context, t.camera),
        if (access != null && access != MediaAccess.granted)
          _AccessTile(kind: kind, access: access, onRequested: load)
        else ...[
          Card(
            margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            clipBehavior: Clip.antiAlias,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ColoredBox(
                color: Colors.black,
                child: preview != null
                    ? VideoTrackRenderer(preview, fit: VideoViewFit.cover)
                    : Center(
                        child: access == null || (devices.isNotEmpty && _starting)
                            ? const CircularProgressIndicator()
                            : Text(devices.isEmpty ? t.noCamera : '', style: const TextStyle(color: Colors.white70)),
                      ),
              ),
            ),
          ),
          _deviceList(
            context,
            names: [for (final device in devices) device.label],
            selected: selected == null ? null : devices.indexOf(selected),
            onSelect: _select,
          ),
        ],
        _hint(context, t.cameraHint),
      ],
    );
  }
}
