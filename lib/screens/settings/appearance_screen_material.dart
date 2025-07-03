import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/screens/settings/appearance_cubit.dart';

import '../../cubit/app_cubit.dart';
import '../../cubit/constants.dart';
import '../../i18n/translations.g.dart';

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
      {"title": t.settings.appearance.darkMode.system, "value": DarkMode.system},
      {"title": t.settings.appearance.darkMode.disabled, "value": DarkMode.disabled},
      {"title": t.settings.appearance.darkMode.alwaysOn, "value": DarkMode.alwaysOn},
    ];

    for (final theme in themeList){
      themeGenerator.add(
          RadioListTile(
            title: Text(theme["title"]),
            value: theme["value"],
            groupValue: state.darkMode,
            onChanged: state.status == Status.loading ? (value) => {} : (value) async => context.read<AppearanceCubit>().changeDarkMode(theme["value"]),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          )
      );
    }
    return themeGenerator;
  }

  List<RadioListTile> colorThemeGenerator(BuildContext context, AppearanceState state) {
    List<RadioListTile> colorThemeGenerator = [];

    List<Map<String, dynamic>> themeList = [
      {"title": t.settings.appearance.colorScheme.system, "value": "system"},
      {"title": t.settings.appearance.colorScheme.green, "value": "green"},
    ];

    for (final theme in themeList){
      colorThemeGenerator.add(
          RadioListTile(
            title: Text(theme["title"]),
            value: theme["value"],
            groupValue: state.darkMode,
            onChanged: state.status == Status.loading ? (value) => {} : (value) async => context.read<AppearanceCubit>().changeDarkMode(theme["value"]),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          )
      );
    }
    return colorThemeGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.settings.appearance.appearance),
      ),
      body: BlocConsumer<AppearanceCubit, AppearanceState>(
        listener: (context, state) async => await context.read<AppCubit>().changeDarkMode(state.darkMode),
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(8.0),
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 10),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10.0),
              //     color: Theme.of(context).cardColor,
              //   ),
              //   child: Column(
              //     children: [
              //       ListTile(
              //           title: Text(
              //             context.t.settings.appearance.colorScheme.colorScheme,
              //             style: TextStyle(
              //                 fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              //                 fontStyle: FontStyle.normal
              //             ),
              //           )
              //       ),
              //       ...colorThemeGenerator(context, state),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 20,),
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
    );;
  }

}
