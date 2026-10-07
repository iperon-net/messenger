import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chats/reactions.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models/constants.dart';
import '../../themes.dart';

class SettingsAppearanceMaterial extends StatefulWidget {
  const SettingsAppearanceMaterial({super.key});

  @override
  State<SettingsAppearanceMaterial> createState() => _SettingsAppearanceMaterial();
}

class _SettingsAppearanceMaterial extends State<SettingsAppearanceMaterial> {
  /// «Быстрая реакция»: сетка всех реакций, выбранная — в кружке.
  Future<void> _pickQuickReaction(BuildContext context, String current) async {
    final cubit = context.read<CommonCubit>();
    final scheme = Theme.of(context).colorScheme;
    final emoji = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.t.screenSettingsAppearance.quickReaction, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(context.t.screenSettingsAppearance.quickReactionDescription, style: TextStyle(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final emoji in allChatReactions)
                    InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.of(sheetContext).pop(emoji),
                      child: Ink(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: emoji == current ? scheme.secondaryContainer : null),
                        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (emoji != null && emoji != current) await cubit.setQuickReaction(emoji);
  }

  Widget _sectionHeader(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.primary),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final check = Icon(Icons.check, size: 22, color: Theme.of(context).colorScheme.primary);

    return BlocConsumer<SettingsAppearanceCubit, SettingsAppearanceState>(
      listenWhen: (previousState, currentState) =>
          previousState.colorTheme != currentState.colorTheme ||
          previousState.darkMode != currentState.darkMode ||
          previousState.isBlurOnInactive != currentState.isBlurOnInactive,
      listener: (context, state) async {
        final commonCubit = context.read<CommonCubit>();
        await commonCubit.setColorTheme(colorTheme: state.colorTheme);
        await commonCubit.setDarkMode(darkMode: state.darkMode);
        await commonCubit.setIsBlurOnInactive(isBlurOnInactive: state.isBlurOnInactive);
      },
      builder: (context, state) {
        Widget colorTile(String title, ColorThemeModel value) => ListTile(
          title: Text(title),
          onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: value),
          trailing: state.colorTheme == value ? check : null,
        );

        Widget darkModeTile(String title, String subtitle, DarkModeModel value) => ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: value),
          trailing: state.darkMode == value ? check : null,
        );

        return Scaffold(
          appBar: AppBar(title: Text(context.t.screenSettingsAppearance.appearance)),
          body: SafeArea(
            child: ListView(
              children: [
                _sectionHeader(context, context.t.screenSettingsAppearance.colorTheme),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      colorTile(context.t.screenSettingsAppearance.colorThemeDefault, ColorThemeModel.blue),
                      colorTile(context.t.screenSettingsAppearance.colorThemeGreen, ColorThemeModel.green),
                      colorTile(context.t.screenSettingsAppearance.colorThemePurple, ColorThemeModel.purple),
                      colorTile(context.t.screenSettingsAppearance.colorThemeOrange, ColorThemeModel.orange),
                    ],
                  ),
                ),
                _sectionHeader(context, context.t.screenSettingsAppearance.darkMode),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      darkModeTile(
                        context.t.screenSettingsAppearance.darkModeSystem,
                        context.t.screenSettingsAppearance.darkModeSystemDescription,
                        DarkModeModel.system,
                      ),
                      darkModeTile(
                        context.t.screenSettingsAppearance.darkModeAlwaysOn,
                        context.t.screenSettingsAppearance.darkModeAlwaysOnDescription,
                        DarkModeModel.alwaysOn,
                      ),
                      darkModeTile(
                        context.t.screenSettingsAppearance.darkModeDisabled,
                        context.t.screenSettingsAppearance.darkModeDisabledDescription,
                        DarkModeModel.disabled,
                      ),
                    ],
                  ),
                ),
                // Обои окна чата — отдельный экран с превью.
                Card(
                  margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(context.t.screenSettingsAppearance.chatThemes),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/settings/appearance/chat_themes'),
                      ),
                      BlocBuilder<CommonCubit, CommonState>(
                        buildWhen: (previous, current) => previous.settingsDevice.quickReaction != current.settingsDevice.quickReaction,
                        builder: (context, common) => ListTile(
                          title: Text(context.t.screenSettingsAppearance.quickReaction),
                          subtitle: Text(context.t.screenSettingsAppearance.quickReactionDescription),
                          trailing: Text(common.settingsDevice.quickReaction, style: const TextStyle(fontSize: 22)),
                          onTap: () => _pickQuickReaction(context, common.settingsDevice.quickReaction),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(12, 16, 12, 4),
                  child: SwitchListTile(
                    title: Text(context.t.screenSettingsAppearance.blurOnInactive),
                    value: state.isBlurOnInactive,
                    onChanged: (bool value) async =>
                        await context.read<SettingsAppearanceCubit>().setIsBlurOnInactive(isBlurOnInactive: value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Text(
                    context.t.screenSettingsAppearance.blurOnInactiveDescription,
                    style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
