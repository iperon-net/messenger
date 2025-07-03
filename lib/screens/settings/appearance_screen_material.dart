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

  List<RadioListTile> radioListTileGenerator(BuildContext context, AppearanceState state) {
    List<RadioListTile> radioListTileGenerator = [];

    List<Map<String, dynamic>> themeList = [
      {"title": context.t.themeSystem, "value": AppTheme.system},
      {"title": context.t.themeLight, "value": AppTheme.light},
      {"title": context.t.themeDark, "value": AppTheme.dark},
    ];

    for (final theme in themeList){
      radioListTileGenerator.add(
          RadioListTile(
            title: Text(theme["title"]),
            value: theme["value"],
            groupValue: state.theme,
            onChanged: state.status == Status.loading ? null : (value) async => context.read<AppearanceCubit>().changeThemeMode(theme["value"]),
          )
      );
    }
    return radioListTileGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.appearance),
      ),
      body: BlocConsumer<AppearanceCubit, AppearanceState>(
        listener: (context, state) async => await context.read<AppCubit>().changeThemeMode(state.theme),
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
                        context.t.theme,
                        style: TextStyle(
                            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                            fontStyle: FontStyle.normal
                        ),
                      )
                    ),
                    ...radioListTileGenerator(context, state),
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
