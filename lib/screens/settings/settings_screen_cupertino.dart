import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/cubit/main_cubit.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import 'settings_cubit.dart';

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget item({
    required BorderRadius borderRadius,
    required Widget title,
    Widget? subtitle,
    required Color color,
    required FaIconData icon,
    Widget? additionalInfo,
    required Future<void> Function()? onTab,
  }) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: CupertinoDynamicColor.resolve(
          CupertinoDynamicColor.withBrightness(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            darkColor: Color(0xFF1C1C1E),
          ),
          context,
        ),
      ),
      child: CupertinoListTile(
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
        trailing: Icon(CupertinoIcons.forward, color: CupertinoColors.inactiveGray),
        additionalInfo: additionalInfo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

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
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: ListView(
              children: [
                item(
                  title: Text(context.t.myProfile),
                  color: Color(0xFFF80202),
                  icon: FontAwesomeIcons.solidUser,
                  borderRadius: BorderRadius.circular(20),
                  onTab: () async => context.go("/"),
                ),
                SizedBox(height: 20),
                item(
                  title: Text(context.t.appearance),
                  color: Color(0xFF1368E6),
                  icon: FontAwesomeIcons.circleHalfStroke,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  onTab: () async => context.go("/settings_appearance"),
                ),
                item(
                  title: Text(context.t.privateAndSecurity),
                  color: Color(0xFF049A40),
                  icon: FontAwesomeIcons.key,
                  borderRadius: BorderRadius.zero,
                  onTab: () async => context.go("/"),
                ),
                item(
                  title: Text(context.t.notifications),
                  color: Color(0xFFDD0856),
                  icon: FontAwesomeIcons.solidBell,
                  borderRadius: BorderRadius.zero,
                  onTab: () async => context.go("/"),
                ),
                item(
                  title: Text(context.t.language),
                  color: Color(0xFFBE0BCC),
                  icon: FontAwesomeIcons.language,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  additionalInfo: BlocBuilder<MainCubit, MainState>(
                    builder: (context, state) {
                      if (state.settingsDevice.locate == AppLocale.ru) {
                        return Text("Русский");
                      } else {
                        return Text("English");
                      }
                    },
                  ),
                  onTab: () async => context.go("/settings_language"),
                ),
                SizedBox(height: 20),
                item(
                  title: Text(context.t.faq),
                  color: Color(0xFFDC9A0F),
                  icon: FontAwesomeIcons.solidCircleQuestion,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  onTab: () async => context.go("/"),
                ),
                item(
                  title: Text(context.t.privacyPolicy),
                  color: Color(0xFF29A840),
                  icon: FontAwesomeIcons.shieldHalved,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  onTab: () async => context.go("/"),
                ),
                SizedBox(height: 20),
                item(
                  title: Text(context.t.logout),
                  color: Color(0xFF7637DD),
                  icon: FontAwesomeIcons.rightFromBracket,
                  borderRadius: BorderRadius.circular(20),
                  onTab: () async => await context.read<SettingsCubit>().logout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
