import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../i18n/translations.g.dart';
import 'device_link_common.dart';

/// «Подключить устройство» (Android): сканер QR входа с компьютера.
class DeviceLinkMaterial extends StatefulWidget {
  const DeviceLinkMaterial({super.key});

  /// Открыть сканер поверх текущего экрана.
  static Future<void> open(BuildContext context) =>
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute<void>(builder: (_) => const DeviceLinkMaterial()));

  @override
  State<DeviceLinkMaterial> createState() => _DeviceLinkMaterialState();
}

class _DeviceLinkMaterialState extends State<DeviceLinkMaterial> with DeviceLinkScanner {
  @override
  Future<bool> confirm(String description) async {
    final t = context.t;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.deviceLink.confirmTitle),
        content: Text('$description\n\n${t.deviceLink.confirmMessage}'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.deviceLink.confirm)),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  void onError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void onLinked() {
    final messenger = ScaffoldMessenger.of(context);
    final text = context.t.deviceLink.linked;
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.deviceLink;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(t.linkDevice), backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: scanner,
            onDetect: onDetect,
            errorBuilder: (context, error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  t.cameraDenied,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // Рамка, куда навести QR.
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: Text(
              t.hint,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
