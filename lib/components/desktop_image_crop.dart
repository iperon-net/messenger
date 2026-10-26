import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../i18n/translations.g.dart';

/// Кадрирование картинки на десктопе — вместо `image_cropper` (у него нет
/// macOS / Windows): окно с рамкой [aspectRatio] (круг — [circle]), результат
/// ужимается до [maxWidth]×[maxHeight] JPEG. `null` — отменили (как у
/// `ImageCropper`).
Future<XFile?> cropImageDesktop(
  BuildContext context,
  String path, {
  required String title,
  double aspectRatio = 1,
  bool circle = false,
  int maxWidth = 512,
  int maxHeight = 512,
  int quality = 90,
}) async {
  final bytes = await File(path).readAsBytes();
  if (!context.mounted) return null;
  final cropped = await showDialog<Uint8List>(
    context: context,
    builder: (_) => _CropDialog(image: bytes, title: title, aspectRatio: aspectRatio, circle: circle),
  );
  if (cropped == null) return null;
  final jpeg = await FlutterImageCompress.compressWithList(
    cropped,
    minWidth: maxWidth,
    minHeight: maxHeight,
    quality: quality,
    format: CompressFormat.jpeg,
  );
  final file = File(p.join((await getTemporaryDirectory()).path, 'crop_${DateTime.now().microsecondsSinceEpoch}.jpg'));
  await file.writeAsBytes(jpeg, flush: true);
  return XFile(file.path);
}

class _CropDialog extends StatefulWidget {
  const _CropDialog({required this.image, required this.title, required this.aspectRatio, required this.circle});

  final Uint8List image;
  final String title;
  final double aspectRatio;
  final bool circle;

  @override
  State<_CropDialog> createState() => _CropDialogState();
}

class _CropDialogState extends State<_CropDialog> {
  final _controller = CropController();
  bool _cropping = false;

  void _done() {
    setState(() => _cropping = true);
    widget.circle ? _controller.cropCircle() : _controller.crop();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 480,
        height: 480,
        child: Crop(
          image: widget.image,
          controller: _controller,
          aspectRatio: widget.aspectRatio,
          withCircleUi: widget.circle,
          baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          onCropped: (result) {
            switch (result) {
              case CropSuccess(:final croppedImage):
                Navigator.of(context).pop(croppedImage);
              case CropFailure():
                setState(() => _cropping = false);
            }
          },
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(t.common.cancel)),
        TextButton(onPressed: _cropping ? null : _done, child: Text(t.common.done)),
      ],
    );
  }
}
