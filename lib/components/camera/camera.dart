import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart' show MaterialPageRoute;

import 'camera_cupertino.dart';
import 'camera_material.dart';

export 'camera_cupertino.dart';
export 'camera_material.dart';

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
