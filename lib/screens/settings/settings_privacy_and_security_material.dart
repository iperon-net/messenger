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

  String _audienceLabel(BuildContext context, CallsPrivacyAudience audience) {
    return audience == CallsPrivacyAudience.everybody
        ? context.t.sessionsPrivacyAndSecurity.callsEverybody
        : context.t.sessionsPrivacyAndSecurity.callsContacts;
  }

  /// Выбор аудитории звонков через диалог. Значение применяет cubit.
  void _pickCallsAudience(BuildContext context, CallsPrivacyAudience current) {
    final cubit = context.read<SettingsPrivacyAndSecurityCubit>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(context.t.sessionsPrivacyAndSecurity.whoCanCall),
        children: [
          for (final audience in CallsPrivacyAudience.values)
            ListTile(
              title: Text(_audienceLabel(context, audience)),
              trailing: audience == current ? const FaIcon(FontAwesomeIcons.check, color: Color(0xFF007AFF), size: 18) : null,
              onTap: () {
                Navigator.of(dialogContext).pop();
                cubit.setCallsAudience(audience);
              },
            ),
        ],
      ),
    );
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
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: MaterialListTileIcon(
                    title: Text(context.t.sessionsPrivacyAndSecurity.whoCanCall),
                    additionalInfo: Text(_audienceLabel(context, state.callsAudience)),
                    color: const Color(0xFF007AFF),
                    icon: FontAwesomeIcons.phone,
                    onTab: () async => _pickCallsAudience(context, state.callsAudience),
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
