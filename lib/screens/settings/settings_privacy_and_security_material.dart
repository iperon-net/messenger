import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../../utils.dart';

class SettingsPrivacyAndSecurityMaterial extends StatefulWidget {
  const SettingsPrivacyAndSecurityMaterial({super.key});

  @override
  State<SettingsPrivacyAndSecurityMaterial> createState() => _SettingsPrivacyAndSecurityMaterial();
}

class _SettingsPrivacyAndSecurityMaterial extends State<SettingsPrivacyAndSecurityMaterial> {
  final utils = getIt.get<Utils>();

  String _audienceLabel(BuildContext context, CallsPrivacyAudience audience) {
    return audience == CallsPrivacyAudience.everybody
        ? context.t.sessionsPrivacyAndSecurity.callsEverybody
        : context.t.sessionsPrivacyAndSecurity.callsContacts;
  }

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
                        ? Text(context.t.sessionsPrivacyAndSecurity.passcodeAndBiometric)
                        : Text(context.t.sessionsPrivacyAndSecurity.passcode),
                    color: const Color(0xFF41CA22),
                    icon: FontAwesomeIcons.unlockKeyhole,
                    onTab: () async => context.go("/settings/privacy_and_security/passcode"),
                    isTrailing: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Text(
                    context.t.sessionsPrivacyAndSecurity.privacyAndSecurity,
                    style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: MaterialListTileIcon(
                    title: Text(context.t.sessionsPrivacyAndSecurity.calls),
                    color: const Color(0xFF007AFF),
                    icon: FontAwesomeIcons.phone,
                    onTab: null,
                    trailing: MaterialInlineDropdown<CallsPrivacyAudience>(
                      value: state.callsAudience,
                      items: CallsPrivacyAudience.values,
                      labelBuilder: (audience) => _audienceLabel(context, audience),
                      onSelected: (audience) => context.read<SettingsPrivacyAndSecurityCubit>().setCallsAudience(audience),
                    ),
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
