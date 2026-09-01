import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:material_ui/material_ui.dart' show MaterialPageRoute;

import 'camera_cupertino.dart';
import 'camera_material.dart';

export 'camera_cupertino.dart';
export 'camera_material.dart';

/// Соотношение сторон живого превью под текущую ориентацию устройства.
///
/// Повторяет внутреннюю логику [CameraPreview] (оно само разворачивается по
/// [CameraValue.deviceOrientation]), поэтому размер снаружи задаём как
/// `SizedBox(width: cameraPreviewAspectRatio(c), height: 1, child: CameraPreview(c))`
/// внутри `FittedBox(fit: cover)`. Свой размер `CameraPreview` навязывать
/// нельзя — иначе кадр растягивается.
double cameraPreviewAspectRatio(CameraController controller) {
  final orientation = controller.value.deviceOrientation;
  final landscape = orientation == DeviceOrientation.landscapeLeft || orientation == DeviceOrientation.landscapeRight;
  final ar = controller.value.aspectRatio;
  return landscape ? ar : 1 / ar;
}

/// Открывает кастомный полноэкранный экран камеры и возвращает снятый кадр как
/// [XFile] (или `null`, если экран закрыли без съёмки).
///
/// Выбор дизайна — по платформе, как и весь app-scaffolding (см. main.dart):
/// iOS → [CameraScreenCupertino], Android → [CameraScreenMaterial]. Экран
/// пушится в корневой навигатор, чтобы перекрыть модальные листы поверх табов.
///
/// Пример:
/// ```dart
/// final file = await openCamera(context);
/// if (file != null) attach(file);
/// ```
Future<XFile?> openCamera(BuildContext context) {
  final navigator = Navigator.of(context, rootNavigator: true);
  if (Platform.isIOS) {
    return navigator.push<XFile>(CupertinoPageRoute(fullscreenDialog: true, builder: (_) => const CameraScreenCupertino()));
  }
  return navigator.push<XFile>(MaterialPageRoute(fullscreenDialog: true, builder: (_) => const CameraScreenMaterial()));
}
