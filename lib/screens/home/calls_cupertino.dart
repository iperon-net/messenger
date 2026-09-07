import 'package:cupertino_ui/cupertino_ui.dart';

import '../../components/calls/local_media_preview.dart';

class CallsCupertino extends StatelessWidget {
  const CallsCupertino({super.key});

  @override
  Widget build(BuildContext context) => const CupertinoPageScaffold(child: SafeArea(child: LocalMediaPreview()));
}
