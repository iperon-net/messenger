import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
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
                      ListTile(title: Text(context.t.myPersonalInfo)),
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
                      ListTile(title: Text(context.t.settings)),
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
                            widgetLanguage = SizedBox(height: 16, width: 16, child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)));
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

                        // trailing: Text(
                        //   ,
                        //   style: TextStyle(
                        //     fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                        //     fontStyle: FontStyle.normal,
                        //   ),
                        // ),
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

  _createGroupedListView() {
    List _elements = [
      {'name': 'Мой профиль', 'group': 'Мой профиль', "sort": 1},
      {'name': '+ 7 909 160 00 44', 'group': 'Мой профиль', "sort": 2},
      {'name': 'Miranda', 'group': 'Team B', "sort": 3},
      {'name': 'Mike', 'group': 'Team C', "sort": 4},
    ];

    return GroupedListView<dynamic, String>(
      elements: _elements,
      groupBy: (element) => element['group'],
      groupComparator: (value1, value2) => value2.compareTo(value1),
      itemComparator: (item1, item2) => item1['sort'].compareTo(item2['sort']),
      order: GroupedListOrder.ASC,
      useStickyGroupSeparators: false,
      groupSeparatorBuilder: (String value) {
        return Container(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(value),
          ),
        );
      },
      itemBuilder: (c, element) {
        return Container(
          color: Theme.of(context).cardColor,
          child: ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(element['name']),
          ),
        );
      },
    );
  }

}

/*
Container(
          color: Theme.of(context).cardColor,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(context.t.language),
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text(context.t.language),
                trailing: Text("English"),
              ),
            ],
          ),
        )*
 */
