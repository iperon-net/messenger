import 'package:cupertino_ui/cupertino_ui.dart';
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
          color: CupertinoTheme
              .of(context)
              .primaryColor,
          darkColor: CupertinoTheme
              .of(context)
              .primaryColor,
        ),
        context,
      ),
    );

    return BlocConsumer<SettingsAppearanceCubit, SettingsAppearanceState>(
      listenWhen: (previousState, currentState) => previousState.colorTheme != currentState.colorTheme || previousState.darkMode != currentState.darkMode || previousState.isBlurOnInactive != currentState.isBlurOnInactive,
      listener: (context, state) async {
        final commonCubit = context.read<CommonCubit>();
        await commonCubit.setColorTheme(colorTheme: state.colorTheme);
        await commonCubit.setDarkMode(darkMode: state.darkMode);
        await commonCubit.setIsBlurOnInactive(isBlurOnInactive: state.isBlurOnInactive);
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGroupedBackground,
            navigationBar: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: CupertinoColors.systemGroupedBackground,
              middle: Text(context.t.settings.appearance),
            ),
            child: SafeArea(
              child: ListView(
                children: [
                  CupertinoListSection.insetGrouped(
                    header: Text(context.t.settings.colorTheme.toUpperCase(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                    children: [
                      CupertinoListTile(
                        title: Text(context.t.settings.colorThemeDefault),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.blue),
                        additionalInfo: state.colorTheme == ColorThemeModel.blue ? additionalInfo : null,
                      ),
                      CupertinoListTile(
                        title: Text(context.t.settings.colorThemeGreen),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.green),
                        additionalInfo: state.colorTheme == ColorThemeModel.green ? additionalInfo : null,
                      ),
                      CupertinoListTile(
                        title: Text(context.t.settings.colorThemePurple),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.purple),
                        additionalInfo: state.colorTheme == ColorThemeModel.purple ? additionalInfo : null,
                      ),
                      CupertinoListTile(
                        title: Text(context.t.settings.colorThemeRed),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.red),
                        additionalInfo: state.colorTheme == ColorThemeModel.red ? additionalInfo : null,
                      ),
                    ],
                  ),

                  CupertinoListSection.insetGrouped(
                    header: Text(context.t.settings.darkMode.toUpperCase(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                    children: [
                      CupertinoListTile(
                        title: Text(context.t.settings.darkModeSystem),
                        subtitle: Text(context.t.settings.darkModeSystemDescription),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.system),
                        additionalInfo: state.darkMode == DarkModeModel.system ? additionalInfo : null,
                      ),
                      CupertinoListTile(
                        title: Text(context.t.settings.darkModeAlwaysOn),
                        subtitle: Text(context.t.settings.darkModeAlwaysOnDescription),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.alwaysOn),
                        additionalInfo: state.darkMode == DarkModeModel.alwaysOn ? additionalInfo : null,
                      ),
                      CupertinoListTile(
                        title: Text(context.t.settings.darkModeDisabled),
                        subtitle: Text(context.t.settings.darkModeDisabledDescription),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.disabled),
                        additionalInfo: state.darkMode == DarkModeModel.disabled ? additionalInfo : null,
                      ),
                    ],
                  ),
                  CupertinoListSection.insetGrouped(
                    footer: Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: Text(context.t.settings.blurOnInactiveDescription, style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                    ),
                    children: [
                      CupertinoListTile(
                        title: Text(context.t.settings.blurOnInactive),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.disabled),
                        trailing: CupertinoSwitch(
                          value: state.isBlurOnInactive,
                          onChanged: (bool value) async => await context.read<SettingsAppearanceCubit>().setIsBlurOnInactive(isBlurOnInactive: value),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        );
      },
    );
  }
}
