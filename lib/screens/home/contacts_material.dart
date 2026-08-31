import 'package:material_ui/material_ui.dart';

import '../../i18n/translations.g.dart';

class ContactsMaterial extends StatelessWidget {
  const ContactsMaterial({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.t.screenHome.contacts)),
    body: const Center(child: Text('Contacts')),
  );
}
