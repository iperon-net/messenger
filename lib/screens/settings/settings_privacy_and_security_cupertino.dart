import 'package:cupertino_ui/cupertino_ui.dart';
import '../../themes.dart';
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
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.sessionsPrivacyAndSecurity.privacyAndSecurity),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  children: [
                    CupertinoListTileIcon(
                      title: state.isBiometricAvailable
                          ? Text(context.t.sessionsPrivacyAndSecurity.passcodeAndFaceID)
                          : Text(context.t.sessionsPrivacyAndSecurity.passcode),
                      color: Color(0xFF41CA22),
                      icon: FontAwesomeIcons.unlockKeyhole,
                      onTab: () async => context.go("/settings/privacy_and_security/passcode"),
                      isTrailing: true,
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: Text(
                    context.t.sessionsPrivacyAndSecurity.privacyAndSecurity,
                    style: TextStyle(fontSize: AppFontSizes.base, fontWeight: FontWeight.normal),
                  ),
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  children: [
                    CupertinoListTileIcon(
                      title: Text(context.t.sessionsPrivacyAndSecurity.calls),
                      color: Color(0xFF007AFF),
                      icon: FontAwesomeIcons.phone,
                      isTrailing: true,
                      additionalInfo: Text(
                        state.callsLoadError ? "—" : _audienceLabel(context, state.callsAudience),
                        style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                      onTab: () async {
                        final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                        await context.push("/settings/privacy_and_security/calls");
                        // Детейл-экран правит свой инстанс cubit — по возврату
                        // перечитываем значение, чтобы label не остался старым.
                        await cubit.reloadCalls();
                      },
                    ),
                    CupertinoListTileIcon(
                      title: Text(context.t.sessionsPrivacyAndSecurity.birthday),
                      color: Color(0xFFFF2D55),
                      icon: FontAwesomeIcons.cakeCandles,
                      isTrailing: true,
                      additionalInfo: Text(
                        state.callsLoadError ? "—" : _audienceLabel(context, state.birthdayAudience),
                        style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                      onTab: () async {
                        final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                        await context.push("/settings/privacy_and_security/birthday");
                        await cubit.reloadBirthday();
                      },
                    ),
                    CupertinoListTileIcon(
                      title: Text(context.t.sessionsPrivacyAndSecurity.aboutMe),
                      color: Color(0xFFAF52DE),
                      icon: FontAwesomeIcons.circleInfo,
                      isTrailing: true,
                      additionalInfo: Text(
                        state.callsLoadError ? "—" : _audienceLabel(context, state.aboutMeAudience),
                        style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                      onTab: () async {
                        final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                        await context.push("/settings/privacy_and_security/about_me");
                        await cubit.reloadAboutMe();
                      },
                    ),
                    CupertinoListTileIcon(
                      title: Text(context.t.sessionsPrivacyAndSecurity.lastSeen),
                      color: Color(0xFF34C759),
                      icon: FontAwesomeIcons.solidClock,
                      isTrailing: true,
                      additionalInfo: Text(
                        state.callsLoadError ? "—" : _audienceLabel(context, state.lastSeenAudience),
                        style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                      onTab: () async {
                        final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                        await context.push("/settings/privacy_and_security/last_seen");
                        await cubit.reloadLastSeen();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
