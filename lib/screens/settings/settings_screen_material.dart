import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/screens/settings/settings_cubit.dart';

import 'language_cubit.dart';

class SettingsScreenMaterial extends StatefulWidget {
  const SettingsScreenMaterial({super.key});

  @override
  State<SettingsScreenMaterial> createState() => _SettingsScreenMaterial();
}

class _SettingsScreenMaterial extends State<SettingsScreenMaterial> {

  @override
  void initState() {
    context.read<SettingsCubit>().initialization();
    context.read<LanguageCubit>().initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          context.t.settings,
          // style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("My profile"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text("Language"),
                    trailing: Text(
                      "English",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text("Language"),
                    trailing: Text("English", style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),),
                  ),
                  Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}
