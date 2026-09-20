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
    switch (audience) {
      case CallsPrivacyAudience.everybody:
        return context.t.sessionsPrivacyAndSecurity.callsEverybody;
      case CallsPrivacyAudience.contacts:
        return context.t.sessionsPrivacyAndSecurity.callsContacts;
      case CallsPrivacyAudience.nobody:
        return context.t.sessionsPrivacyAndSecurity.callsNobody;
    }
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
                    isTrailing: true,
                    additionalInfo: Text(state.callsLoadError ? "—" : _audienceLabel(context, state.callsAudience)),
                    onTab: () async {
                      final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                      await context.push("/settings/privacy_and_security/calls");
                      // Детейл-экран правит свой инстанс cubit — по возврату
                      // перечитываем значение, чтобы label не остался старым.
                      await cubit.reloadCalls();
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: MaterialListTileIcon(
                    title: Text(context.t.sessionsPrivacyAndSecurity.birthday),
                    color: const Color(0xFFFF2D55),
                    icon: FontAwesomeIcons.cakeCandles,
                    isTrailing: true,
                    additionalInfo: Text(state.callsLoadError ? "—" : _audienceLabel(context, state.birthdayAudience)),
                    onTab: () async {
                      final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                      await context.push("/settings/privacy_and_security/birthday");
                      await cubit.reloadBirthday();
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: MaterialListTileIcon(
                    title: Text(context.t.sessionsPrivacyAndSecurity.aboutMe),
                    color: const Color(0xFFAF52DE),
                    icon: FontAwesomeIcons.circleInfo,
                    isTrailing: true,
                    additionalInfo: Text(state.callsLoadError ? "—" : _audienceLabel(context, state.aboutMeAudience)),
                    onTab: () async {
                      final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                      await context.push("/settings/privacy_and_security/about_me");
                      await cubit.reloadAboutMe();
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: MaterialListTileIcon(
                    title: Text(context.t.sessionsPrivacyAndSecurity.lastSeen),
                    color: const Color(0xFF34C759),
                    icon: FontAwesomeIcons.solidClock,
                    isTrailing: true,
                    additionalInfo: Text(state.callsLoadError ? "—" : _audienceLabel(context, state.lastSeenAudience)),
                    onTab: () async {
                      final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                      await context.push("/settings/privacy_and_security/last_seen");
                      await cubit.reloadLastSeen();
                    },
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
