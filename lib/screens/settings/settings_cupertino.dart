import 'package:cupertino_ui/cupertino_ui.dart';
import '../../themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';
import '../../cubit.dart';
import '../../components.dart';
import '../chats/chat_folders_cupertino.dart';

class SettingsCupertino extends StatefulWidget {
  const SettingsCupertino({super.key});

  @override
  State<SettingsCupertino> createState() => _SettingsCupertino();
}

class _SettingsCupertino extends State<SettingsCupertino> {
  /// Родное название языка для текущей локали (как в экране выбора языка).
  String _languageName(AppLocale locale) => switch (locale) {
    AppLocale.ru => "Русский",
    AppLocale.en => "English",
  };

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
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.screenSettings.settings),
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
                      title: Text(context.t.screenSettings.myProfile),
                      color: Color(0xFFF80202),
                      icon: FontAwesomeIcons.solidUser,
                      onTab: () async => context.go("/settings/profile"),
                      isTrailing: true,
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  children: [
                    CupertinoListTileIcon(
                      title: Text(context.t.screenSettings.notifications),
                      color: Color(0xFFE5214D),
                      icon: FontAwesomeIcons.solidBell,
                      onTab: () async => context.go("/settings/notifications"),
                      isTrailing: true,
                    ),
                    CupertinoListTileIcon(
                      title: Text(context.t.screenSettings.privacyAndSecurity),
                      color: Color(0xFF049A40),
                      icon: FontAwesomeIcons.key,
                      onTab: () async => context.go("/settings/privacy_and_security"),
                      isTrailing: true,
                    ),
                    CupertinoListTileIcon(
                      title: Text(context.t.screenSettings.appearance),
                      color: Color(0xFF1368E6),
                      icon: FontAwesomeIcons.circleHalfStroke,
                      onTab: () async => context.go("/settings/appearance"),
                      isTrailing: true,
                    ),
                    // Папки чатов — пока только в UX-демо (флаг на экране «Разработчик»).
                    if (context.select((CommonCubit cubit) => cubit.state.settingsDevice.chatsDemo))
                      CupertinoListTileIcon(
                        title: Text(context.t.screenSettings.folders),
                        color: Color(0xFF00A3D9),
                        icon: FontAwesomeIcons.solidFolder,
                        onTab: () async => showChatFoldersCupertino(context),
                        isTrailing: true,
                      ),
                    CupertinoListTileIcon(
                      title: Text(context.t.screenSettings.devices),
                      color: Color(0xFFFF6B00),
                      icon: FontAwesomeIcons.mobileScreen,
                      onTab: () async => context.go("/settings/device_sessions"),
                      additionalInfo: state.countDeviceSessions > 0 ? Text(state.countDeviceSessions.toString()) : null,
                      isTrailing: true,
                    ),
                    CupertinoListTileIcon(
                      title: Text(context.t.screenSettings.language),
                      color: Color(0xFFB818DC),
                      icon: FontAwesomeIcons.language,
                      onTab: () async => context.go("/settings/language"),
                      additionalInfo: Text(_languageName(LocaleSettings.currentLocale)),
                      isTrailing: true,
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
