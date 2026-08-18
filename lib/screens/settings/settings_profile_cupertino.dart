import 'package:cupertino_ui/cupertino_ui.dart';

import '../../i18n/translations.g.dart';

class SettingsProfileCupertino extends StatefulWidget {
  const SettingsProfileCupertino({super.key});

  @override
  State<SettingsProfileCupertino> createState() => _SettingsProfileCupertino();
}

class _SettingsProfileCupertino extends State<SettingsProfileCupertino> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        automaticBackgroundVisibility: false,
        backgroundColor: CupertinoColors.systemGroupedBackground,
        middle: Text(context.t.settings.myProfile),
      ),
      child: Center(child: Text(context.t.settings.myProfile)),
    );
  }
}
