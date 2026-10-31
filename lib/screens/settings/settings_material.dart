import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../platform.dart';
import '../../split_layout.dart';
import '../../i18n/translations.g.dart';
import '../../cubit.dart';
import '../../components.dart';
import '../chats/chat_folders_material.dart';
import 'settings_accounts_material.dart';

class SettingsMaterial extends StatefulWidget {
  const SettingsMaterial({super.key});

  @override
  State<SettingsMaterial> createState() => _SettingsMaterial();
}

class _SettingsMaterial extends State<SettingsMaterial> {
  /// Группа-«карточка» со скруглёнными углами (как в Telegram): несколько
  /// плиток объединяются в один контейнер на сером фоне страницы.
  Widget _group(BuildContext context, List<Widget> children) {
    // Форма/скругление/цвет/отступы берутся из `cardTheme` в ThemesMaterial.
    return Card(child: Column(children: children));
  }

  /// Родное название языка для текущей локали (как в экране выбора языка).
  String _languageName(AppLocale locale) => switch (locale) {
    AppLocale.ru => "Русский",
    AppLocale.en => "English",
  };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          // Серый фон страницы, на котором «плавают» скруглённые группы.
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          appBar: AppBar(centerTitle: true, title: Text(context.t.screenSettings.settings)),
          body: SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 6),
                _group(context, [
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.myProfile),
                    color: const Color(0xFFF80202),
                    icon: FontAwesomeIcons.solidUser,
                    onTab: () async => context.go("/settings/profile"),
                    selected: SplitSelection.of(context) == 'profile',
                    isTrailing: true,
                  ),
                ]),
                const SizedBox(height: 6),
                const SettingsAccountsMaterial(),
                const SizedBox(height: 6),
                _group(context, [
                  // Десктоп: клавиша отправки, автозапуск.
                  if (AppPlatform.isDesktop)
                    MaterialListTileIcon(
                      title: Text(context.t.screenSettings.general),
                      color: const Color(0xFF8E8E93),
                      icon: FontAwesomeIcons.gear,
                      onTab: () async => context.go("/settings/general"),
                      selected: SplitSelection.of(context) == 'general',
                      isTrailing: true,
                    ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.notifications),
                    color: const Color(0xFFE5214D),
                    icon: FontAwesomeIcons.solidBell,
                    onTab: () async => context.go("/settings/notifications"),
                    selected: SplitSelection.of(context) == 'notifications',
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.privacyAndSecurity),
                    color: const Color(0xFF049A40),
                    icon: FontAwesomeIcons.key,
                    onTab: () async => context.go("/settings/privacy_and_security"),
                    selected: SplitSelection.of(context) == 'privacy_and_security',
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.dataAndStorage),
                    color: const Color(0xFF34C759),
                    icon: FontAwesomeIcons.database,
                    onTab: () async => context.go("/settings/data"),
                    selected: SplitSelection.of(context) == 'data',
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.appearance),
                    color: const Color(0xFF1368E6),
                    icon: FontAwesomeIcons.circleHalfStroke,
                    onTab: () async => context.go("/settings/appearance"),
                    selected: SplitSelection.of(context) == 'appearance',
                    isTrailing: true,
                  ),
                  // Папки чатов.
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.folders),
                    color: const Color(0xFF00A3D9),
                    icon: FontAwesomeIcons.solidFolder,
                    // Планшет — в правой панели «Настроек», иначе поверх всего.
                    onTab: () async => SplitLayout.enabled ? context.go('/settings/folders') : showChatFoldersMaterial(context),
                    selected: SplitSelection.of(context) == 'folders',
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.devices),
                    color: const Color(0xFFFF6B00),
                    icon: FontAwesomeIcons.mobileScreen,
                    onTab: () async => context.go("/settings/device_sessions"),
                    selected: SplitSelection.of(context) == 'device_sessions',
                    additionalInfo: state.countDeviceSessions > 0 ? Text(state.countDeviceSessions.toString()) : null,
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.language),
                    color: const Color(0xFFB818DC),
                    icon: FontAwesomeIcons.language,
                    onTab: () async => context.go("/settings/language"),
                    selected: SplitSelection.of(context) == 'language',
                    additionalInfo: Text(_languageName(LocaleSettings.currentLocale)),
                    isTrailing: true,
                  ),
                  // Лицензии библиотек.
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.licenses),
                    color: const Color(0xFF8E8E93),
                    icon: FontAwesomeIcons.fileLines,
                    onTab: () async => context.go("/settings/licenses"),
                    selected: SplitSelection.of(context) == 'licenses',
                    isTrailing: true,
                  ),
                ]),
                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }
}
