import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/cubit/main_cubit.dart';

import '../../i18n/translations.g.dart';
import '../../models/models.dart';
import 'settings_appearance_cubit.dart';

class SettingsAppearanceScreenCupertino extends StatefulWidget {
  const SettingsAppearanceScreenCupertino({super.key});

  @override
  State<SettingsAppearanceScreenCupertino> createState() => _SettingsAppearanceScreenCupertino();
}

class _SettingsAppearanceScreenCupertino extends State<SettingsAppearanceScreenCupertino> {
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

    return CupertinoPageScaffold(
      backgroundColor: CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.systemGroupedBackground,
        darkColor: CupertinoColors.darkBackgroundGray,
      ),
      navigationBar: CupertinoNavigationBar(
        automaticBackgroundVisibility: false,
        middle: Text(context.t.appearance),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: BlocBuilder<MainCubit, MainState>(
              builder: (context, state) {

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

                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Text(
                        context.t.colorTheme,
                        style: TextStyle(
                          fontSize: const TextScaler.linear(1.5).scale(10),
                          color: CupertinoColors.inactiveGray,
                        ),
                      )
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: CupertinoDynamicColor.resolve(
                          CupertinoDynamicColor.withBrightness(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            darkColor: Color(0xFF1C1C1E),
                          ),
                          context,
                        ),
                      ),
                      child: CupertinoListTile(
                        title: Text(context.t.colorThemeDefault),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(context, colorTheme: SettingsDeviceColorTheme.blue),
                        additionalInfo: state.settingsDevice.colorTheme == SettingsDeviceColorTheme.blue ? additionalInfo : null,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: CupertinoDynamicColor.resolve(
                          CupertinoDynamicColor.withBrightness(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            darkColor: Color(0xFF1C1C1E),
                          ),
                          context,
                        ),
                      ),
                      child: CupertinoListTile(
                        title: Text(context.t.colorThemeGreen),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(context, colorTheme: SettingsDeviceColorTheme.green),
                        additionalInfo: state.settingsDevice.colorTheme == SettingsDeviceColorTheme.green ? additionalInfo : null,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: CupertinoDynamicColor.resolve(
                          CupertinoDynamicColor.withBrightness(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            darkColor: Color(0xFF1C1C1E),
                          ),
                          context,
                        ),
                      ),
                      child: CupertinoListTile(
                        title: Text(context.t.colorThemePurple),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(context, colorTheme: SettingsDeviceColorTheme.purple),
                        additionalInfo: state.settingsDevice.colorTheme == SettingsDeviceColorTheme.purple ? additionalInfo : null,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10),
                      child: Text(
                        context.t.darkMode,
                        style: TextStyle(
                          fontSize: const TextScaler.linear(1.5).scale(10),
                          color: CupertinoColors.inactiveGray,
                        ),
                      )
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: CupertinoDynamicColor.resolve(
                          CupertinoDynamicColor.withBrightness(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            darkColor: Color(0xFF1C1C1E),
                          ),
                          context,
                        ),
                      ),
                      child: CupertinoListTile(
                        title: Text(context.t.darkModeSystem),
                        subtitle: Text(context.t.darkModeSystemDescription),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(context, darkMode: SettingsDeviceDarkMode.system),
                        additionalInfo: state.settingsDevice.darkMode == SettingsDeviceDarkMode.system ? additionalInfo : null,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: CupertinoDynamicColor.resolve(
                          CupertinoDynamicColor.withBrightness(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            darkColor: Color(0xFF1C1C1E),
                          ),
                          context,
                        ),
                      ),
                      child: CupertinoListTile(
                        title: Text(context.t.darkModeAlwaysOn),
                        subtitle: Text(context.t.darkModeAlwaysOnDescription),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(context, darkMode: SettingsDeviceDarkMode.alwaysOn),                        additionalInfo: state.settingsDevice.darkMode == SettingsDeviceDarkMode.alwaysOn ? additionalInfo : null,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: CupertinoDynamicColor.resolve(
                          CupertinoDynamicColor.withBrightness(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            darkColor: Color(0xFF1C1C1E),
                          ),
                          context,
                        ),
                      ),
                      child: CupertinoListTile(
                        title: Text(context.t.darkModeDisabled),
                        subtitle: Text(context.t.darkModeDisabledDescription),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(context, darkMode: SettingsDeviceDarkMode.disabled),                        additionalInfo: state.settingsDevice.darkMode == SettingsDeviceDarkMode.disabled ? additionalInfo : null,
                      ),
                    ),

                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
