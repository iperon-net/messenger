import 'package:material_ui/material_ui.dart';

import '../../components/actions_sheet_material.dart';
import '../../components/calls/call_view.dart';
import '../../platform.dart';

/// Полноэкранный экран звонка (Android, на macOS — и обход код-пароля).
/// Тонкая обёртка над общим [CallView].
class CallMaterial extends StatelessWidget {
  const CallMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(body: const CallView());
    // Десктоп: где нажали мышью — там откроется контекстное меню
    // (showSpeakerPicker / showCameraPicker). Корневой Listener приложения в
    // это время не смонтирован (экран звонка рисуется вместо обычного дерева).
    if (!AppPlatform.isDesktop) return scaffold;
    return Listener(behavior: HitTestBehavior.translucent, onPointerDown: (event) => DesktopPointer.last = event.position, child: scaffold);
  }
}
