import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/screens/settings/settings_cubit.dart';

import '../../cubit/constants.dart';
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
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {

        Widget widgetVersionApplication = Container();
        if(state.status == Status.success) {
          widgetVersionApplication = Text(state.versionApplication, style: TextStyle(fontSize: Theme.of(context).textTheme.titleMedium!.fontSize, fontStyle: FontStyle.normal));
        } else {
          widgetVersionApplication = SizedBox(height: 16, width: 16, child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)));
        }

        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
              title: Text(context.t.settings),
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
                          context.t.myPersonalInfo,
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                              fontStyle: FontStyle.normal
                          ),
                        )
                      ),
                      ListTile(title: Text(context.t.myProfile), leading: Icon(Icons.person)),
                      ListTile(title: Text(context.t.favorites), leading: Icon(Icons.bookmark_border_outlined)),
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
                          context.t.settings,
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                              fontStyle: FontStyle.normal
                          ),
                        ),
                      ),
                      ListTile(title: Text(context.t.privacyAndSecurity), leading: Icon(Icons.lock)),
                      ListTile(
                        title: Text(context.t.devices),
                        leading: Icon(Icons.computer),
                        trailing: Text(
                          "0",
                          style: TextStyle(
                            fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      ListTile(title: Text(context.t.appearance), leading: Icon(Icons.wb_sunny_outlined)),
                      BlocBuilder<LanguageCubit, LanguageState>(
                        builder: (context, stateLanguage) {

                          Widget widgetLanguage = Container();
                          if(stateLanguage.status == Status.success) {
                            String additionalInfo = "English";
                            if (stateLanguage.currentLanguage == AppLocale.ru) additionalInfo = "Русский";
                            widgetLanguage = Text(
                              additionalInfo,
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                                fontStyle: FontStyle.normal
                              ),
                            );
                          } else {
                            widgetLanguage = SizedBox(
                              height: 16,
                              width: 16,
                              child: Center(
                                child: CircularProgressIndicator(strokeWidth: 1.5),
                              )
                            );
                          }

                          return ListTile(
                            title: Text(context.t.language),
                            leading: Icon(Icons.language),
                            trailing: widgetLanguage,
                          );
                        },
                      ),
                      ListTile(title: Text(context.t.updates), leading: Icon(Icons.update)),
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
                        title: Text(context.t.versionApplication),
                        trailing: widgetVersionApplication,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
