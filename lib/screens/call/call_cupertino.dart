import 'package:cupertino_ui/cupertino_ui.dart';

import '../../components/calls/call_view.dart';

/// Полноэкранный экран звонка (iOS). Тонкая обёртка над общим [CallView].
class CallCupertino extends StatelessWidget {
  const CallCupertino({super.key});

  @override
  Widget build(BuildContext context) => const CupertinoPageScaffold(child: CallView());
}
