import 'package:cupertino_ui/cupertino_ui.dart';
import '../../themes.dart';

import '../../components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models/constants.dart';

class SettingsAppearanceCupertino extends StatefulWidget {
  const SettingsAppearanceCupertino({super.key});

  @override
  State<SettingsAppearanceCupertino> createState() => _SettingsAppearanceCupertino();
}

class _SettingsAppearanceCupertino extends State<SettingsAppearanceCupertino> {
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
    Widget additionalInfo = FaIcon(
      FontAwesomeIcons.solidCircleCheck,
      size: 18,
      color: CupertinoDynamicColor.resolve(
        CupertinoDynamicColor.withBrightness(
          color: CupertinoTheme.of(context).primaryColor,
          darkColor: CupertinoTheme.of(context).primaryColor,
        ),
        context,
      ),
    );

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
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.screenSettingsAppearance.appearance),
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
                  header: Text(
                    context.t.screenSettingsAppearance.colorTheme.toUpperCase(),
                    style: TextStyle(fontSize: AppFontSizes.caption, fontWeight: FontWeight.normal),
                  ),
                  children: [
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.colorThemeDefault),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.blue),
                      additionalInfo: state.colorTheme == ColorThemeModel.blue ? additionalInfo : null,
                    ),
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.colorThemeGreen),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.green),
                      additionalInfo: state.colorTheme == ColorThemeModel.green ? additionalInfo : null,
                    ),
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.colorThemePurple),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.purple),
                      additionalInfo: state.colorTheme == ColorThemeModel.purple ? additionalInfo : null,
                    ),
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.colorThemeOrange),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.orange),
                      additionalInfo: state.colorTheme == ColorThemeModel.orange ? additionalInfo : null,
                    ),
                  ],
                ),

                CupertinoListSection.insetGrouped(
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  header: Text(
                    context.t.screenSettingsAppearance.darkMode.toUpperCase(),
                    style: TextStyle(fontSize: AppFontSizes.caption, fontWeight: FontWeight.normal),
                  ),
                  children: [
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.darkModeSystem),
                      subtitle: Text(context.t.screenSettingsAppearance.darkModeSystemDescription),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.system),
                      additionalInfo: state.darkMode == DarkModeModel.system ? additionalInfo : null,
                    ),
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.darkModeAlwaysOn),
                      subtitle: Text(context.t.screenSettingsAppearance.darkModeAlwaysOnDescription),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.alwaysOn),
                      additionalInfo: state.darkMode == DarkModeModel.alwaysOn ? additionalInfo : null,
                    ),
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.darkModeDisabled),
                      subtitle: Text(context.t.screenSettingsAppearance.darkModeDisabledDescription),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.disabled),
                      additionalInfo: state.darkMode == DarkModeModel.disabled ? additionalInfo : null,
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  footer: Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Text(
                      context.t.screenSettingsAppearance.blurOnInactiveDescription,
                      style: TextStyle(fontSize: AppFontSizes.caption, fontWeight: FontWeight.normal),
                    ),
                  ),
                  children: [
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.blurOnInactive),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.disabled),
                      trailing: CupertinoSwitch(
                        value: state.isBlurOnInactive,
                        onChanged: (bool value) async =>
                            await context.read<SettingsAppearanceCubit>().setIsBlurOnInactive(isBlurOnInactive: value),
                      ),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  header: Text(
                    context.t.screenSettingsAppearance.fontSize.toUpperCase(),
                    style: TextStyle(fontSize: AppFontSizes.caption, fontWeight: FontWeight.normal),
                  ),
                  footer: Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Text(
                      context.t.screenSettingsAppearance.fontSizeDescription,
                      style: TextStyle(fontSize: AppFontSizes.caption, fontWeight: FontWeight.normal),
                    ),
                  ),
                  // Живой предпросмотр: слайдер двигает CommonCubit (без записи в
                  // БД) — масштаб применяется глобально через MediaQuery в корне
                  // приложения. Запись в БД — на onChangeEnd через кубит экрана.
                  children: [
                    CupertinoListTile(title: Text(context.t.screenSettingsAppearance.fontSizeSample)),
                    BlocBuilder<CommonCubit, CommonState>(
                      builder: (context, common) {
                        final scale = common.settingsDevice.fontScale;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('A', style: TextStyle(fontSize: AppFontSizes.caption)),
                                  Expanded(
                                    child: CupertinoSlider(
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
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
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
                          ),
                        );
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
