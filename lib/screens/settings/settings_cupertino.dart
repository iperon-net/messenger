import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';
import '../../cubit.dart';
import '../../components.dart';

class SettingsCupertino extends StatefulWidget {
  const SettingsCupertino({super.key});

  @override
  State<SettingsCupertino> createState() => _SettingsCupertino();
}

class _SettingsCupertino extends State<SettingsCupertino> {
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
    return BlocConsumer<SettingsCubit, SettingsState>(
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
              middle: Text(context.t.common.settings),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  children: [
                    CupertinoListTileIcon(
                      title: Text(context.t.settings.myProfile),
                      color: Color(0xFFF80202),
                      icon: FontAwesomeIcons.solidUser,
                      onTab: () async => context.go("/settings/profile"),
                      isTrailing: true,
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  children: [
                    CupertinoListTileIcon(
                      title: Text(context.t.settings.privacyAndSecurity),
                      color: Color(0xFF049A40),
                      icon: FontAwesomeIcons.key,
                      onTab: () async => context.go("/settings/privacy_and_security"),
                      isTrailing: true,
                    ),
                    CupertinoListTileIcon(
                      title: Text(context.t.settings.appearance),
                      color: Color(0xFF1368E6),
                      icon: FontAwesomeIcons.circleHalfStroke,
                      onTab: () async => context.go("/settings/appearance"),
                      isTrailing: true,
                    ),
                    CupertinoListTileIcon(
                      title: Text(context.t.settings.devices),
                      color: Color(0xFFFF6B00),
                      icon: FontAwesomeIcons.mobileScreen,
                      onTab: () async => context.go("/settings/device_sessions"),
                      additionalInfo: state.countDeviceSessions > 0 ? Text(state.countDeviceSessions.toString()) : null,
                      isTrailing: true,
                    ),
                    CupertinoListTileIcon(
                      title: Text(context.t.settings.language),
                      color: Color(0xFFB818DC),
                      icon: FontAwesomeIcons.language,
                      onTab: () async => context.go("/settings/language"),
                      isTrailing: true,
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  children: [
                    CupertinoListTileIcon(
                      title: Text(context.t.settings.logout),
                      color: Color(0xFF5A48E6),
                      isTrailing: false,
                      icon: FontAwesomeIcons.rightFromBracket,
                      onTab: () async {
                        // Навигацию не делаем вручную: auth.logout() внутри
                        // terminate() дёрнет notifyListeners(), и go_router сам
                        // уведёт на /auth. Ручной context.go("/auth") здесь
                        // отбивался бы редиректом, пока сессия ещё в памяти.
                        context.read<SettingsCubit>().terminate();
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
