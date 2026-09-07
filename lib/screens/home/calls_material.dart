import 'package:material_ui/material_ui.dart';

import '../../components/calls/local_media_preview.dart';
import '../../i18n/translations.g.dart';

class CallsMaterial extends StatelessWidget {
  const CallsMaterial({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.t.screenHome.calls)),
    body: const LocalMediaPreview(),
  );
}
