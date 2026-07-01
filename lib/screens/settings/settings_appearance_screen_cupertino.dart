import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/cubit/main_cubit.dart';
import 'package:messenger/cubit/settings/settings_appearance_state.dart';

import '../../cubit/settings/settings_appearance_cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart';

class SettingsAppearanceScreenCupertino extends StatefulWidget {
  const SettingsAppearanceScreenCupertino({super.key});

  @override
  State<SettingsAppearanceScreenCupertino> createState() => _SettingsAppearanceScreenCupertino();
}

class _SettingsAppearanceScreenCupertino extends State<SettingsAppearanceScreenCupertino> {
  @override
  void initState() {
    super.initState();
    final colorTheme = context.read<MainCubit>().state.settingsDevice.colorTheme;
    final darkMode = context.read<MainCubit>().state.settingsDevice.darkMode;

    context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: colorTheme);
    context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: darkMode);

  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _divider() {
    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoDynamicColor.withBrightness(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          darkColor: const Color(0xFF1C1C1E),
        ),
        context,
      ),
      child: Container(
        height: 0.3,
        color: CupertinoDynamicColor.resolve(CupertinoColors.separator, context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsAppearanceCubit, SettingsAppearanceState>(
      listenWhen: (previous, current) => previous.colorTheme != current.colorTheme || previous.darkMode != current.darkMode,
      listener: (context, state) {
        context.read<MainCubit>().setColorTheme(colorTheme: state.colorTheme);
        context.read<MainCubit>().setDarkMode(darkMode: state.darkMode);
      },
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
                child: ListView(
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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                        title: Text(context.t.colorThemeDefault),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: SettingsDeviceColorTheme.blue),
                        additionalInfo: state.colorTheme == SettingsDeviceColorTheme.blue ? additionalInfo : null,
                      ),
                    ),
                    _divider(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.zero,
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
                        title: Text(context.t.colorThemeGreen),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: SettingsDeviceColorTheme.green),
                        additionalInfo: state.colorTheme == SettingsDeviceColorTheme.green ? additionalInfo : null,
                      ),
                    ),
                    _divider(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
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
                        title: Text(context.t.colorThemePurple),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: SettingsDeviceColorTheme.purple),
                        additionalInfo: state.colorTheme == SettingsDeviceColorTheme.purple ? additionalInfo : null,
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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                        title: Text(context.t.darkModeSystem),
                        subtitle: Text(context.t.darkModeSystemDescription),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: SettingsDeviceDarkMode.system),
                        additionalInfo: state.darkMode == SettingsDeviceDarkMode.system ? additionalInfo : null,
                      ),
                    ),
                    _divider(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.zero,
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
                        title: Text(context.t.darkModeAlwaysOn),
                        subtitle: Text(context.t.darkModeAlwaysOnDescription),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: SettingsDeviceDarkMode.alwaysOn),
                        additionalInfo: state.darkMode == SettingsDeviceDarkMode.alwaysOn ? additionalInfo : null,
                      ),
                    ),
                    _divider(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
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
                        title: Text(context.t.darkModeDisabled),
                        subtitle: Text(context.t.darkModeDisabledDescription),
                        onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: SettingsDeviceDarkMode.disabled),
                        additionalInfo: state.darkMode == SettingsDeviceDarkMode.disabled ? additionalInfo : null,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
