import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../components/nav_bar_button_cupertino.dart';
import '../../i18n/translations.g.dart';
import 'device_link_common.dart';

/// «Подключить устройство» (iOS): сканер QR входа с компьютера.
class DeviceLinkCupertino extends StatefulWidget {
  const DeviceLinkCupertino({super.key});

  /// Открыть сканер поверх текущего экрана (модально, снизу).
  static Future<void> open(BuildContext context) => Navigator.of(
    context,
    rootNavigator: true,
  ).push(CupertinoPageRoute<void>(fullscreenDialog: true, builder: (_) => const DeviceLinkCupertino()));

  @override
  State<DeviceLinkCupertino> createState() => _DeviceLinkCupertinoState();
}

class _DeviceLinkCupertinoState extends State<DeviceLinkCupertino> with DeviceLinkScanner {
  @override
  Future<bool> confirm(String description) async {
    final t = context.t;
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.deviceLink.confirmTitle),
        content: Text('$description\n\n${t.deviceLink.confirmMessage}'),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(t.common.cancel)),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.deviceLink.confirm),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  void onError(String message) {
    unawaited(
      showCupertinoDialog<void>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          content: Text(message),
          actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('OK'))],
        ),
      ),
    );
  }

  @override
  void onLinked() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final t = context.t.deviceLink;
    const white = Color(0xFFFFFFFF);
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF000000),
      navigationBar: CupertinoNavigationBar(
        middle: Text(t.linkDevice, style: const TextStyle(color: white)),
        backgroundColor: const Color(0xFF000000),
        leading: NavBarButtonCupertino(NavBarAction.close, label: context.t.common.cancel, onPressed: () => Navigator.of(context).pop()),
      ),
      child: Stack(
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
                  style: const TextStyle(color: white),
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
                border: Border.all(color: white, width: 3),
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
              style: const TextStyle(color: white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
