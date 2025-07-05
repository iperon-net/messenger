import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/app_cubit.dart';
import '../../cubit/constants.dart';
import '../../i18n/translations.g.dart';
import 'appearance_cubit.dart';

class AppearanceScreenCupertino extends StatefulWidget {
  const AppearanceScreenCupertino({super.key});

  @override
  State<AppearanceScreenCupertino> createState() => _AppearanceScreenCupertino();
}

class _AppearanceScreenCupertino extends State<AppearanceScreenCupertino> {

  @override
  void initState() {
    context.read<AppearanceCubit>().initialization();
    super.initState();
  }


  List<CupertinoListTile> themeGenerator(BuildContext context, AppearanceState state) {
    List<CupertinoListTile> themeGenerator = [];

    List<Map<String, dynamic>> themeList = [
      {"title": t.settings.appearance.darkMode.system, "value": DarkMode.system},
      {"title": t.settings.appearance.darkMode.disabled, "value": DarkMode.disabled},
      {"title": t.settings.appearance.darkMode.alwaysOn, "value": DarkMode.alwaysOn},
    ];

    for (final theme in themeList){
      themeGenerator.add(
          CupertinoListTile(
            backgroundColorActivated: CupertinoDynamicColor.resolve(CupertinoColors.transparent, context),
            title: Text(theme["title"]),
            onTap: state.status == Status.loading ? () => null : () async => context.read<AppearanceCubit>().changeDarkMode(theme["value"]),
            trailing: (state.status == Status.loading && theme["value"] == state.selectedDarkMode && state.action == "darkMode") ? CupertinoActivityIndicator() :
              (state.selectedDarkMode == theme["value"] ? Icon(CupertinoIcons.checkmark_alt, color: CupertinoTheme.of(context).primaryColor) : Container()),
          ),
      );
    }
    return themeGenerator;
  }

  List<CupertinoListTile> colorThemeGenerator(BuildContext context, AppearanceState state) {
    List<CupertinoListTile> colorThemeGenerator = [];

    List<Map<String, dynamic>> themeList = [
      {"title": t.settings.appearance.colorScheme.system, "value": ThemeColor.blue},
      {"title": t.settings.appearance.colorScheme.green, "value": ThemeColor.green},
      {"title": t.settings.appearance.colorScheme.purple, "value": ThemeColor.purple},
    ];

    for (final theme in themeList){
      colorThemeGenerator.add(
          CupertinoListTile(
            backgroundColorActivated: CupertinoDynamicColor.resolve(CupertinoColors.transparent, context),
            title: Text(theme["title"]),
            onTap: state.status == Status.loading ? () => null : () async => context.read<AppearanceCubit>().changeThemeColor(theme["value"]),
            trailing: (state.status == Status.loading && theme["value"] == state.selectedThemeColor && state.action == "themeColor") ? CupertinoActivityIndicator() :
            (state.selectedThemeColor == theme["value"] ? Icon(CupertinoIcons.checkmark_alt, color: CupertinoTheme.of(context).primaryColor) : Container()),
          )
      );
    }
    return colorThemeGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: t.settings.appearance.back,
        middle: Text(context.t.settings.appearance.appearance),
      ),
      child: SafeArea(
        bottom: true,
        child: BlocConsumer<AppearanceCubit, AppearanceState>(
          listener: (context, state) async {
            if (context.mounted) await context.read<AppCubit>().changeDarkMode(state.darkMode);
            if (context.mounted) await context.read<AppCubit>().changeThemeColor(state.themeColor);
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CupertinoFormSection.insetGrouped(
                    header: Text(context.t.settings.appearance.colorScheme.colorScheme),
                    children: [
                      ...colorThemeGenerator(context, state),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    header: Text(context.t.settings.appearance.darkMode.darkMode),
                    children: [
                      ...themeGenerator(context, state),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}
