import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/cubit/settings/settings_language_state.dart';

import '../../cubit/settings/settings_language_cubit.dart';
import '../../i18n/translations.g.dart';


class SettingsPrivateAndSecurityScreenCupertino extends StatefulWidget {
  const SettingsPrivateAndSecurityScreenCupertino({super.key});

  @override
  State<SettingsPrivateAndSecurityScreenCupertino> createState() => _SettingsPrivateAndSecurityScreenCupertino();
}

class _SettingsPrivateAndSecurityScreenCupertino extends State<SettingsPrivateAndSecurityScreenCupertino> {
  @override
  void initState() {
    super.initState();
    // final locate = context.read<MainCubit>().state.settingsDevice.locale;
    // context.read<SettingsLanguageCubit>().setLocale(locale: locate ?? AppLocale.en);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _item({
    required Widget title,
    Widget? subtitle,
    required Color color,
    required FaIconData icon,
    Widget? additionalInfo,
    required Future<void> Function()? onTab,
  }) {
    return CupertinoListTile(
      padding: EdgeInsets.all(10),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: FaIcon(icon, size: 16, color: Color(0xFFFFFFFF)),
        ),
      ),
      onTap: onTab,
      title: title,
      subtitle: subtitle,
      trailing: CupertinoListTileChevron(),
      additionalInfo: additionalInfo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsLanguageCubit, SettingsLanguageState>(
      // listenWhen: (previous, current) => previous.locale != current.locale,
      listener: (context, state) {
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            middle: Text(context.t.privateAndSecurity),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  children: [
                    _item(
                      title: Text(context.t.twoStepVerification),
                      color: Color(0xFFFFAF00),
                      icon: FontAwesomeIcons.lock,
                      onTab: () async => context.go("/private_and_security/settings_two_step_verification"),
                      additionalInfo: Text(context.t.off),
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

