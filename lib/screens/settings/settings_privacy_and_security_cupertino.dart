import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../utils.dart';

class SettingsPrivacyAndSecurityCupertino extends StatefulWidget {
  const SettingsPrivacyAndSecurityCupertino({super.key});

  @override
  State<SettingsPrivacyAndSecurityCupertino> createState() => _SettingsPrivacyAndSecurityCupertino();
}

class _SettingsPrivacyAndSecurityCupertino extends State<SettingsPrivacyAndSecurityCupertino> {
  final utils = getIt.get<Utils>();

  bool isBiometricAvailable = false;

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
    return BlocConsumer<SettingsPrivacyAndSecurityCubit, SettingsPrivacyAndSecurityState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: CupertinoColors.systemGroupedBackground,
              middle: Text(context.t.settings.privacyAndSecurity),
            ),
          ),
          child: SafeArea(
            child: CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTileIcon(
                  title: state.isBiometricAvailable ? Text(context.t.settings.passcodeAndFaceID) : Text(context.t.settings.passcode.title),
                  color: Color(0xFF41CA22),
                  icon: FontAwesomeIcons.unlockKeyhole,
                  onTab: () async => context.go("/settings/privacy_and_security/passcode"),
                  isTrailing: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
