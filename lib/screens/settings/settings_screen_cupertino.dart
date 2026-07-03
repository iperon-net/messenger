import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/constants.dart';
import 'package:messenger/cubit/settings/settings_state.dart';

import '../../cubit/main_cubit.dart';
import '../../cubit/settings/settings_cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';


class SettingsCupertinoScreen extends StatefulWidget {
  const SettingsCupertinoScreen({super.key});

  @override
  State<SettingsCupertinoScreen> createState() => _SettingsCupertinoScreen();
}

class _SettingsCupertinoScreen extends State<SettingsCupertinoScreen> {
  final logger = getIt.get<Logger>();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().setLocale(locale: context.read<MainCubit>().state.settingsDevice.locale ?? AppLocale.en);
    context.read<SettingsCubit>().initialization();
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
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.systemGroupedBackground,
            darkColor: CupertinoColors.darkBackgroundGray,
          ),
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            middle: Text(context.t.settings),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  children: [
                    _item(
                      title: Text(context.t.myProfile),
                      color: Color(0xFFF80202),
                      icon: FontAwesomeIcons.solidUser,
                      onTab: () async => context.go("/"),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  children: [
                    _item(
                      title: Text(context.t.appearance),
                      color: Color(0xFF1368E6),
                      icon: FontAwesomeIcons.circleHalfStroke,
                      onTab: () async => context.go("/settings_appearance"),
                    ),
                    _item(
                      title: Text(context.t.privateAndSecurity),
                      color: Color(0xFF049A40),
                      icon: FontAwesomeIcons.key,
                      onTab: () async => context.go("/private_and_security"),
                    ),
                    _item(
                      title: Text(context.t.notifications),
                      color: Color(0xFFDD0856),
                      icon: FontAwesomeIcons.solidBell,
                      onTab: () async => context.go("/"),
                    ),
                    _item(
                      title: Text(context.t.devices),
                      color: Color(0xFFFF6B00),
                      icon: FontAwesomeIcons.mobileScreen,
                      onTab: () async => context.go("/settings_device_sessions"),
                      additionalInfo: state.deviceSessionsCount > 0 ? Text(state.deviceSessionsCount.toString()) : null,
                    ),
                    _item(
                      title: Text(context.t.language),
                      color: Color(0xFFBE0BCC),
                      icon: FontAwesomeIcons.language,
                      additionalInfo: state.locale == AppLocale.ru ? Text("Русский") : Text("English"),
                      onTab: () async => context.go("/settings_language"),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  children: [
                    _item(
                      title: Text(context.t.faq),
                      color: Color(0xFFDC9A0F),
                      icon: FontAwesomeIcons.solidCircleQuestion,
                      onTab: () async => context.go("/"),
                    ),
                    _item(
                      title: Text(context.t.privacyPolicy),
                      color: Color(0xFF29A840),
                      icon: FontAwesomeIcons.shieldHalved,
                      onTab: () async => context.go("/"),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  children: [
                    _item(
                      title: Text(context.t.logout),
                      color: Color(0xFF7637DD),
                      icon: FontAwesomeIcons.rightFromBracket,
                      onTab: () async { context.read<SettingsCubit>().logout(); },
                      additionalInfo: state.status == Status.loading ? CupertinoActivityIndicator() : null,
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

