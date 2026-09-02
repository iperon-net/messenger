import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                _sectionHeader(context, context.t.screenSettingsAppearance.fontSize),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    // Живой предпросмотр: слайдер двигает CommonCubit (без записи в БД),
                    // сам масштаб глобально применяется через MediaQuery в корне
                    // приложения — поэтому и образец, и весь экран растут сразу.
                    // Запись в БД — на onChangeEnd через SettingsAppearanceCubit.
                    child: BlocBuilder<CommonCubit, CommonState>(
                      builder: (context, common) {
                        final scale = common.settingsDevice.fontScale;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.t.screenSettingsAppearance.fontSizeSample),
                            Row(
                              children: [
                                Text('A', style: TextStyle(fontSize: AppFontSizes.caption)),
                                Expanded(
                                  child: Slider(
                                    value: scale,
                                    min: AppFontSizes.minFontScale,
                                    max: AppFontSizes.maxFontScale,
                                    divisions: AppFontSizes.fontScaleDivisions,
                                    onChanged: (v) => context.read<CommonCubit>().setFontScale(scale: v),
                                    onChangeEnd: (v) => context.read<SettingsAppearanceCubit>().setFontScale(fontScale: v),
                                  ),
                                ),
                                Text('A', style: TextStyle(fontSize: AppFontSizes.appBarTitle)),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: scale == 1.0
                                    ? null
                                    : () {
                                        context.read<CommonCubit>().setFontScale(scale: 1.0);
                                        context.read<SettingsAppearanceCubit>().setFontScale(fontScale: 1.0);
                                      },
                                child: Text(context.t.screenSettingsAppearance.fontSizeReset),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Text(
                    context.t.screenSettingsAppearance.fontSizeDescription,
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
