import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../utils.dart';

class SettingsPrivacyAndSecurityMaterial extends StatefulWidget {
  const SettingsPrivacyAndSecurityMaterial({super.key});

  @override
  State<SettingsPrivacyAndSecurityMaterial> createState() => _SettingsPrivacyAndSecurityMaterial();
}

class _SettingsPrivacyAndSecurityMaterial extends State<SettingsPrivacyAndSecurityMaterial> {
  final utils = getIt.get<Utils>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsPrivacyAndSecurityCubit, SettingsPrivacyAndSecurityState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(context.t.sessionsPrivacyAndSecurity.privacyAndSecurity)),
          body: SafeArea(
            child: ListView(
              children: [
                Card(
                  margin: const EdgeInsets.all(12),
                  child: MaterialListTileIcon(
                    title: state.isBiometricAvailable
                        ? Text(context.t.sessionsPrivacyAndSecurity.passcodeAndFaceID)
                        : Text(context.t.sessionsPrivacyAndSecurity.passcode),
                    color: const Color(0xFF41CA22),
                    icon: FontAwesomeIcons.unlockKeyhole,
                    onTab: () async => context.go("/settings/privacy_and_security/passcode"),
                    isTrailing: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
