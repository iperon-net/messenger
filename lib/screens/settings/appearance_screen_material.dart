import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/screens/settings/appearance_cubit.dart';

import '../../components/progress_indicator/progress_indicator.dart';
import '../../components/widget_wrapper/widget_wrapper.dart';
import '../../cubit/app_cubit.dart';
import '../../cubit/constants.dart';
import '../../i18n/translations.g.dart';
import '../../models/models.dart' as models;

class AppearanceScreenMaterial extends StatefulWidget {
  const AppearanceScreenMaterial({super.key});

  @override
  State<AppearanceScreenMaterial> createState() => _AppearanceScreenMaterial();
}

class _AppearanceScreenMaterial extends State<AppearanceScreenMaterial> {

  @override
  void initState() {
    context.read<AppearanceCubit>().initialization();
    super.initState();
  }

  List<RadioListTile> themeGenerator(BuildContext context, AppearanceState state) {
    List<RadioListTile> themeGenerator = [];

    List<Map<String, dynamic>> themeList = [
      {"title": t.settings.appearance.darkMode.system, "value": models.SettingsDeviceDarkMode.system},
      {"title": t.settings.appearance.darkMode.disabled, "value": models.SettingsDeviceDarkMode.disabled},
      {"title": t.settings.appearance.darkMode.alwaysOn, "value": models.SettingsDeviceDarkMode.alwaysOn},
    ];

    for (final theme in themeList){
      themeGenerator.add(
          RadioListTile(
            title: Text(theme["title"]),
            value: theme["value"],
            groupValue: state.darkMode,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onChanged: state.status == Status.loading && state.action == "darkMode" ? null : (value) async {
              await context.read<AppearanceCubit>().changeDarkMode(theme["value"]);
            },
            secondary: (
              state.status == Status.loading && theme["value"] == state.selectedDarkMode && state.action == "darkMode"
            ) ? ProgressIndicatorComponent() : null,
          )
      );
    }
    return themeGenerator;
  }

  List<RadioListTile> colorThemeGenerator(BuildContext context, AppearanceState state) {
    List<RadioListTile> colorThemeGenerator = [];

    List<Map<String, dynamic>> themeList = [
      {"title": t.settings.appearance.colorScheme.system, "value": models.SettingsDeviceThemeColor.blue},
      {"title": t.settings.appearance.colorScheme.green, "value": models.SettingsDeviceThemeColor.green},
      {"title": t.settings.appearance.colorScheme.purple, "value": models.SettingsDeviceThemeColor.purple},
    ];

    for (final theme in themeList){
      colorThemeGenerator.add(
          RadioListTile(
            title: Text(theme["title"]),
            value: theme["value"],
            groupValue: state.themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onChanged: state.status == Status.loading && state.action == "themeColor" ? null : (value) async {
              await context.read<AppearanceCubit>().changeThemeColor(theme["value"]);
            },
            secondary: (
                state.status == Status.loading && theme["value"] == state.selectedThemeColor && state.action == "themeColor"
            ) ? ProgressIndicatorComponent() : null,
          )
      );
    }
    return colorThemeGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.t.settings.appearance.appearance),
        ),
        body: BlocConsumer<AppearanceCubit, AppearanceState>(
          listener: (context, state) async {
            if (context.mounted) await context.read<AppCubit>().changeDarkMode(state.darkMode);
            if (context.mounted) await context.read<AppCubit>().changeThemeColor(state.themeColor);
          },
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.all(8.0),
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                          title: Text(
                            context.t.settings.appearance.colorScheme.colorScheme,
                            style: TextStyle(
                                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                                fontStyle: FontStyle.normal
                            ),
                          )
                      ),
                      ...colorThemeGenerator(context, state),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          t.settings.appearance.darkMode.darkMode,
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                              fontStyle: FontStyle.normal
                          ),
                        )
                      ),
                      ...themeGenerator(context, state),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}
