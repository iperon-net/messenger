import 'package:camera/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../i18n/translations.g.dart';

/// Кастомный полноэкранный экран камеры (Material) — замена нативному
/// `ImagePicker(source: camera)` там, где нужен собственный UI видоискателя.
///
/// Логика/состояние идентичны [CameraScreenCupertino]; отличается только
/// оформлением (Material-иконки/кнопки). Возвращает снятый кадр как [XFile]
/// через `Navigator.pop`, либо `null`, если экран закрыли без съёмки.
class CameraScreenMaterial extends StatefulWidget {
  const CameraScreenMaterial({super.key});

  @override
  State<CameraScreenMaterial> createState() => _CameraScreenMaterialState();
}

class _CameraScreenMaterialState extends State<CameraScreenMaterial> with WidgetsBindingObserver {
  /// Контроллер живого превью; `null`, пока камера не инициализирована или
  /// временно освобождена (уход в фон / переключение камеры).
  CameraController? _cameraController;

  /// Все доступные камеры устройства (для переключения фронт ⇄ тыл).
  List<CameraDescription> _cameras = [];

  /// Индекс активной камеры в [_cameras].
  int _cameraIndex = 0;

  /// Текущий режим вспышки (циклически off → auto → always).
  FlashMode _flashMode = FlashMode.off;

  /// Доступ к камере не выдан — показываем экран-заглушку с кнопкой настроек.
  bool _denied = false;

  /// Камера недоступна (нет камер / ошибка инициализации).
  bool _unavailable = false;

  /// Идёт съёмка кадра — блокируем повторные нажатия затвора.
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Сессия захвата прерывается при уходе в фон — освобождаем контроллер на
    // сворачивании и пересоздаём его при возврате.
    if (_cameras.isEmpty) return;
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        final previous = _cameraController;
        if (previous != null) {
          setState(() => _cameraController = null);
          previous.dispose();
        }
      case AppLifecycleState.resumed:
        if (_cameraController == null) _startCamera(_cameraIndex);
      case AppLifecycleState.detached:
        break;
    }
  }

  /// Запрашивает доступ и запускает камеру (по умолчанию тыловую).
  Future<void> _init() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) setState(() => _denied = true);
      return;
    }
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _unavailable = true);
        return;
      }
      _cameras = cameras;
      final back = cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);
      await _startCamera(back >= 0 ? back : 0);
    } catch (_) {
      if (mounted) setState(() => _unavailable = true);
    }
  }

  /// Создаёт и запускает контроллер для камеры [index] и делает её активной.
  /// Предыдущий контроллер должен быть уже освобождён вызывающей стороной.
  Future<void> _startCamera(int index) async {
    try {
      final controller = CameraController(_cameras[index], ResolutionPreset.high, enableAudio: false);
      await controller.initialize();
      await controller.setFlashMode(_flashMode);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _cameraIndex = index;
        _cameraController = controller;
      });
    } catch (_) {
      if (mounted) setState(() => _unavailable = true);
    }
  }

  /// Переключает камеру на следующую (фронт ⇄ тыл).
  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    final next = (_cameraIndex + 1) % _cameras.length;
    final previous = _cameraController;
    // Освобождаем текущую камеру ПЕРЕД инициализацией новой: два активных
    // контроллера на одной сессии захвата приводят к зависанию превью.
    setState(() => _cameraController = null);
    await previous?.dispose();
    await _startCamera(next);
  }

  /// Циклически переключает режим вспышки и применяет его к контроллеру.
  Future<void> _cycleFlash() async {
    final next = switch (_flashMode) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.always,
      _ => FlashMode.off,
    };
    setState(() => _flashMode = next);
    await _cameraController?.setFlashMode(next);
  }

  /// Снимает кадр и возвращает его вызывающей стороне.
  Future<void> _capture() async {
    final c = _cameraController;
    if (_capturing || c == null || !c.value.isInitialized || c.value.isTakingPicture) return;
    setState(() => _capturing = true);
    try {
      final shot = await c.takePicture();
      if (!mounted) return;
      Navigator.pop(context, XFile(shot.path));
    } catch (_) {
      if (mounted) setState(() => _capturing = false);
    }
  }

  FaIconData get _flashIcon => switch (_flashMode) {
    FlashMode.off => FontAwesomeIcons.boltLightning,
    FlashMode.auto => FontAwesomeIcons.bolt,
    _ => FontAwesomeIcons.bolt,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: _denied || _unavailable ? _message(context) : _camera(context));
  }

  /// Экран-заглушка при отказе в доступе / недоступности камеры.
  Widget _message(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Align(alignment: Alignment.topLeft, child: _closeButton(context)),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.triangleExclamation, size: 40, color: Colors.white70),
                  const SizedBox(height: 16),
                  Text(
                    _denied ? context.t.componentsCamera.accessDenied : context.t.componentsCamera.unavailable,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  if (_denied) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: openAppSettings,
                      child: Text(context.t.componentsCamera.openSettings, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _camera(BuildContext context) {
    final controller = _cameraController;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Живое превью на весь экран (кадр камеры вписываем через cover).
        if (controller != null && controller.value.isInitialized)
          _fullPreview(controller)
        else
          const Center(child: CircularProgressIndicator(color: Colors.white)),
        // Верхняя панель: только закрыть (слева).
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Align(alignment: Alignment.topLeft, child: _closeButton(context)),
          ),
        ),
        // Нижняя панель: смена камеры слева + затвор по центру + вспышка справа.
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32).copyWith(bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cameras.length > 1 ? _roundButton(icon: FontAwesomeIcons.cameraRotate, onTap: _switchCamera) : const SizedBox(width: 44),
                  _shutterButton(),
                  _roundButton(icon: _flashIcon, onTap: _cycleFlash, active: _flashMode != FlashMode.off),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Превью «покрывает» экран: у камеры кадр альбомный, поэтому меняем местами
  /// ширину/высоту и вписываем через `BoxFit.cover`.
  Widget _fullPreview(CameraController controller) {
    final preview = controller.value.previewSize ?? const Size(1, 1);
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(width: preview.height, height: preview.width, child: CameraPreview(controller)),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return _roundButton(icon: FontAwesomeIcons.xmark, onTap: () => Navigator.pop(context));
  }

  /// Кнопка-затвор: белое кольцо с заполненным центром; во время съёмки —
  /// индикатор.
  Widget _shutterButton() {
    return GestureDetector(
      onTap: _capture,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: _capturing
            ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
      ),
    );
  }

  Widget _roundButton({required FaIconData icon, required VoidCallback onTap, bool active = false}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), shape: BoxShape.circle),
        child: FaIcon(icon, size: 18, color: active ? Colors.amber : Colors.white),
      ),
    );
  }
}
