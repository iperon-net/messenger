import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../di.dart';
import '../../logger.dart';

/// Проверочный виджет Фазы 0 интеграции WebRTC: запрашивает камеру и микрофон,
/// открывает локальный медиапоток через `getUserMedia` и рендерит его в
/// [RTCVideoView]. Никакого сигналинга/`RTCPeerConnection` здесь ещё нет — это
/// только подтверждение, что нативный слой `flutter_webrtc` собран и
/// захватывает медиа на обеих платформах.
///
/// Платформенно-нейтральный (импортирует `flutter/widgets`, а не
/// `cupertino_ui`/`material_ui`), поэтому его встраивают оба экрана `/calls`.
class LocalMediaPreview extends StatefulWidget {
  const LocalMediaPreview({super.key});

  @override
  State<LocalMediaPreview> createState() => _LocalMediaPreviewState();
}

enum _PreviewStatus { loading, ready, denied, error }

class _LocalMediaPreviewState extends State<LocalMediaPreview> {
  final RTCVideoRenderer _renderer = RTCVideoRenderer();
  MediaStream? _stream;
  _PreviewStatus _status = _PreviewStatus.loading;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final camera = await Permission.camera.request();
    final microphone = await Permission.microphone.request();
    if (!camera.isGranted || !microphone.isGranted) {
      if (mounted) setState(() => _status = _PreviewStatus.denied);
      return;
    }

    try {
      await _renderer.initialize();
      final stream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': {'facingMode': 'user'},
      });
      if (!mounted) {
        await _disposeStream(stream);
        return;
      }
      _stream = stream;
      _renderer.srcObject = stream;
      setState(() => _status = _PreviewStatus.ready);
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
      if (mounted) setState(() => _status = _PreviewStatus.error);
    }
  }

  Future<void> _disposeStream(MediaStream stream) async {
    for (final track in stream.getTracks()) {
      await track.stop();
    }
    await stream.dispose();
  }

  @override
  void dispose() {
    _renderer.srcObject = null;
    final stream = _stream;
    if (stream != null) _disposeStream(stream);
    _renderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _PreviewStatus.loading:
        return const Center(child: Text('Запрашиваем камеру и микрофон…'));
      case _PreviewStatus.denied:
        return const Center(child: Text('Нет доступа к камере или микрофону'));
      case _PreviewStatus.error:
        return const Center(child: Text('Не удалось открыть медиапоток'));
      case _PreviewStatus.ready:
        return RTCVideoView(_renderer, mirror: true, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover);
    }
  }
}
