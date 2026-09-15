import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';
import '../../cubit.dart';
import '../../components.dart';

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
                    isTrailing: true,
                  ),
                ]),
                const SizedBox(height: 6),
                _group(context, [
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.privacyAndSecurity),
                    color: const Color(0xFF049A40),
                    icon: FontAwesomeIcons.key,
                    onTab: () async => context.go("/settings/privacy_and_security"),
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.appearance),
                    color: const Color(0xFF1368E6),
                    icon: FontAwesomeIcons.circleHalfStroke,
                    onTab: () async => context.go("/settings/appearance"),
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.devices),
                    color: const Color(0xFFFF6B00),
                    icon: FontAwesomeIcons.mobileScreen,
                    onTab: () async => context.go("/settings/device_sessions"),
                    additionalInfo: state.countDeviceSessions > 0 ? Text(state.countDeviceSessions.toString()) : null,
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.language),
                    color: const Color(0xFFB818DC),
                    icon: FontAwesomeIcons.language,
                    onTab: () async => context.go("/settings/language"),
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenSettings.logout),
                    color: const Color(0xFF5A48E6),
                    icon: FontAwesomeIcons.rightFromBracket,
                    // Навигацию не делаем вручную: auth.logout() внутри terminate()
                    // дёрнет notifyListeners(), и go_router сам уведёт на /auth.
                    onTab: () async => context.read<SettingsCubit>().terminate(),
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
