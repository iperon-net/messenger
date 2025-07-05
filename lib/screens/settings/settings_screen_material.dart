import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/screens/settings/settings_cubit.dart';

import 'appearance_cubit.dart';

class SettingsScreenMaterial extends StatefulWidget {
  const SettingsScreenMaterial({super.key});

  @override
  State<SettingsScreenMaterial> createState() => _SettingsScreenMaterial();
}

class _SettingsScreenMaterial extends State<SettingsScreenMaterial> {

  @override
  void initState() {
    context.read<SettingsCubit>().initialization();
    context.read<AppearanceCubit>().initialization();
    super.initState();
  }

  Widget widgetTrailingLanguage() {
    String languageName = "English";
    if (LocaleSettings.currentLocale == AppLocale.ru) languageName = "Русский";

    return Text(
      languageName,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
          fontStyle: FontStyle.normal
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.t.settings.settings),
          ),
          body: ListView(
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
                        context.t.settings.myPersonalInfo,
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                          fontStyle: FontStyle.normal
                        ),
                      )
                    ),
                    ListTile(title: Text(context.t.settings.myProfile), leading: Icon(Icons.person)),
                    ListTile(title: Text(context.t.settings.favorites), leading: Icon(Icons.bookmark_border_outlined)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        context.t.settings.settings,
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                          fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(context.t.settings.privacyAndSecurity.privacyAndSecurity),
                      leading: Icon(Icons.lock),
                      onTap: () => context.goNamed("settings_privacy_security"),
                    ),
                    ListTile(
                      title: Text(context.t.settings.devices),
                      leading: Icon(Icons.computer),
                      trailing: Text(
                        "0",
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(context.t.settings.appearance.appearance),
                      leading: Icon(Icons.wb_sunny_outlined),
                      onTap: () => context.goNamed("settings_appearance"),
                    ),
                    ListTile(
                      title: Text(context.t.settings.language.language),
                      leading: Icon(Icons.language),
                      trailing: widgetTrailingLanguage(),
                      onTap: () => context.goNamed("settings_language"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
