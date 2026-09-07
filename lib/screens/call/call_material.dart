import 'package:material_ui/material_ui.dart';

import '../../components/calls/call_view.dart';

/// Полноэкранный экран звонка (Android). Тонкая обёртка над общим [CallView].
class CallMaterial extends StatelessWidget {
  const CallMaterial({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: CallView());
}
