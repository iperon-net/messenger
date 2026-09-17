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
    return audience == CallsPrivacyAudience.everybody
        ? context.t.sessionsPrivacyAndSecurity.callsEverybody
        : context.t.sessionsPrivacyAndSecurity.callsContacts;
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
                  header: Text(context.t.sessionsPrivacyAndSecurity.privacyAndSecurity),
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
                      onTab: null,
                      trailing: CupertinoMenuAnchor(
                        builder: (context, controller, child) {
                          return CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    _audienceLabel(context, state.callsAudience),
                                    style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        menuChildren: [
                          for (final audience in CallsPrivacyAudience.values)
                            CupertinoMenuItem(
                              trailing: state.callsAudience == audience ? const Icon(CupertinoIcons.check_mark) : null,
                              onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().setCallsAudience(audience),
                              child: Text(_audienceLabel(context, audience)),
                            ),
                        ],
                      ),
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
