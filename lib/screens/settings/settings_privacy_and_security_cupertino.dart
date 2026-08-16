import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';

class SettingsPrivacyAndSecurityCupertino extends StatefulWidget {
  const SettingsPrivacyAndSecurityCupertino({super.key});

  @override
  State<SettingsPrivacyAndSecurityCupertino> createState() => _SettingsPrivacyAndSecurityCupertino();
}

class _SettingsPrivacyAndSecurityCupertino extends State<SettingsPrivacyAndSecurityCupertino> {
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
        middle: Text(context.t.settings.privacyAndSecurity),
      ),
      child: SafeArea(
        child: CupertinoListSection.insetGrouped(
          children: [
            CupertinoListTileIcon(
              title: Text(context.t.settings.passcodeAndFaceID),
              color: Color(0xFF41CA22),
              icon: FontAwesomeIcons.unlockKeyhole,
              onTab: () async => context.go("/settings/privacy_and_security/passcode"),
            ),
          ],
        ),
      ),
    );
  }
}
